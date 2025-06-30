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
          'likes': [],
          'destacar': false,
        }
      ])
    });
    // Incrementa el contador de respuestas del usuario
    await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
      'respuestas': FieldValue.increment(1),
    }, SetOptions(merge: true));
    // No recargar, el stream lo actualizará automáticamente
  }

  Future<void> toggleLikeRespuesta({
    required String preguntaId,
    required int respuestaIndex,
    required String userUid,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('preguntas').doc(preguntaId);
    final doc = await docRef.get();
    if (!doc.exists) return;
    final data = doc.data()!;
    final respuestas = List<Map<String, dynamic>>.from(data['respuestas'] ?? []);
    if (respuestaIndex < 0 || respuestaIndex >= respuestas.length) return;

    // 1. Actualiza los likes de la respuesta
    List likes = List.from(respuestas[respuestaIndex]['likes'] ?? []);
    if (likes.contains(userUid)) {
      likes.remove(userUid);
    } else {
      likes.add(userUid);
    }
    respuestas[respuestaIndex]['likes'] = likes;

    // 2. Guarda el estado anterior de destacados por usuarioUid
    Set<String> oldDestacados = respuestas.where((r) => r['destacar'] == true && r['usuarioUid'] != null).map<String>((r) => r['usuarioUid'] as String).toSet();

    // 3. Actualiza en Firestore
    await docRef.update({'respuestas': respuestas});

    // 4. Vuelve a obtener las respuestas actualizadas
    final updatedDoc = await docRef.get();
    final updatedRespuestas = List<Map<String, dynamic>>.from(updatedDoc['respuestas'] ?? []);
    List<int> newTopIndexes = _getTop2Indexes(updatedRespuestas);

    // 5. Actualiza los destacados y los contadores de usuarios
    await _updateDestacadasCounters(
      respuestas: updatedRespuestas,
      oldDestacados: oldDestacados,
      newTopIndexes: newTopIndexes,
    );
}

// Función para obtener los índices de las dos respuestas con más likes
List<int> _getTop2Indexes(List<Map<String, dynamic>> respuestas) {
  // Solo considerar respuestas con al menos 1 like
  List<Map<String, dynamic>> respuestasConLikes = respuestas.where((r) => (r['likes']?.length ?? 0) > 0).toList();
  respuestasConLikes.sort((a, b) => (b['likes']?.length ?? 0).compareTo(a['likes']?.length ?? 0));
  List top2 = respuestasConLikes.take(2).toList();
  return top2.map((r) => respuestas.indexOf(r)).toList();
}

// Función para actualizar los contadores de respuestas destacadas
Future<void> _updateDestacadasCounters({
  required List<Map<String, dynamic>> respuestas,
  required Set<String> oldDestacados,
  required List<int> newTopIndexes,
}) async {
  // 1. Actualiza el campo 'destacar' en cada respuesta (solo los top2 deben tener true)
  Set<String> nuevosDestacados = {};
  for (int i = 0; i < respuestas.length; i++) {
    final esDestacada = newTopIndexes.contains(i);
    respuestas[i]['destacar'] = esDestacada;
    if (esDestacada && respuestas[i]['usuarioUid'] != null) {
      nuevosDestacados.add(respuestas[i]['usuarioUid']);
    }
  }

  // 2. Guarda la lista de respuestas actualizada en Firestore
  if (respuestas.isNotEmpty) {
    final pregunta = preguntas.firstWhere(
      (p) => p['respuestas'] != null &&
        List<Map<String, dynamic>>.from(p['respuestas']).any((r) => r['respuesta'] == respuestas[0]['respuesta']),
      orElse: () => <String, dynamic>{},
    );
    if (pregunta.isNotEmpty && pregunta['id'] != null) {
      await FirebaseFirestore.instance.collection('preguntas').doc(pregunta['id']).update({
        'respuestas': respuestas,
      });
    }
  }

  // 3. Usuarios que ganan una destacada
  for (final uid in nuevosDestacados) {
    if (!oldDestacados.contains(uid)) {
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'respuestasDestacadas': FieldValue.increment(1),
      }, SetOptions(merge: true));
    }
  }
  // 4. Usuarios que pierden una destacada
  for (final uid in oldDestacados) {
    if (!nuevosDestacados.contains(uid)) {
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'respuestasDestacadas': FieldValue.increment(-1),
      }, SetOptions(merge: true));
    }
  }
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
