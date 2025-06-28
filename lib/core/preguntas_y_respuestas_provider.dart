
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class PreguntasProvider extends ChangeNotifier {
  List<Map<String, dynamic>> preguntas = [];
  bool cargando = false;
  StreamSubscription<QuerySnapshot>? _preguntasSub;

  // Escuchar preguntas en tiempo real
  void escucharPreguntas() {
    cargando = true;
    notifyListeners();
    _preguntasSub?.cancel();
    _preguntasSub = FirebaseFirestore.instance
        .collection('preguntas')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
    preguntas = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
      cargando = false;
      notifyListeners();
    });
  }

  // Dejar de escuchar (llamar en dispose)
  void cancelarEscucha() {
    _preguntasSub?.cancel();
    _preguntasSub = null;
  }

  // (Opcional) Cargar una sola vez (ya no se usará en la UI, pero útil para agregar preguntas)
  Future<void> cargarPreguntas({String? materia, String? search}) async {
    cargando = true;
    notifyListeners();
    Query query = FirebaseFirestore.instance.collection('preguntas').orderBy('timestamp', descending: true);
    final snapshot = await query.get();
    preguntas = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).where((data) {
      final materiaMatch = materia == null || materia == 'Todas' || ((data['materia']?.toString().toLowerCase() ?? '') == (materia.toLowerCase()));
      final searchMatch = search == null || search.isEmpty ||
        ((data['titulo']?.toString().toLowerCase() ?? '').contains(search.toLowerCase())) ||
        ((data['fragmento']?.toString().toLowerCase() ?? '').contains(search.toLowerCase()));
      return materiaMatch && searchMatch;
    }).cast<Map<String, dynamic>>().toList();
    cargando = false;
    notifyListeners();
  }

  // Agregar una nueva pregunta
  Future<void> agregarPregunta({
    required String titulo,
    required String fragmento,
    required String materia,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('preguntas').add({
      'titulo': titulo,
      'fragmento': fragmento,
      'usuario': user.email ?? 'Anónimo',
      'usuarioUid': user.uid,
      'materia': materia,
      'respuestas': [],
      'timestamp': FieldValue.serverTimestamp(),
    });
    // Incrementa el contador de preguntas del usuario
    await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
      'preguntas': FieldValue.increment(1),
    }, SetOptions(merge: true));
    // No recargar, el stream lo actualizará automáticamente
  }

  // Agregar una respuesta a una pregunta
  Future<void> agregarRespuesta({
    required String preguntaId,
    required String respuesta,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('preguntas').doc(preguntaId).update({
      'respuestas': FieldValue.arrayUnion([
        {
          'usuario': user.email ?? 'Anónimo',
          'usuarioUid': user.uid,
          'respuesta': respuesta,
          'timestamp': DateTime.now(),
        }
      ])
    });
    // Incrementa el contador de respuestas del usuario
    await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
      'respuestas': FieldValue.increment(1),
    }, SetOptions(merge: true));
    // No recargar, el stream lo actualizará automáticamente
  }
  @override
  void dispose() {
    cancelarEscucha();
    super.dispose();
  }

  // Obtener una pregunta por id
  Map<String, dynamic>? getPreguntaById(String id) {
    return preguntas.firstWhere((p) => p['id'] == id, orElse: () => {});
  }
}
