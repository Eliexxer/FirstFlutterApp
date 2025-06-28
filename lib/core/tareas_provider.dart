import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TareasProvider extends ChangeNotifier {
  List<Map<String, dynamic>> asignaturas = [];
  bool cargando = false;

  // Cargar todas las asignaturas del usuario actual
  Future<void> cargarAsignaturas() async {
    cargando = true;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      asignaturas = [];
      cargando = false;
      notifyListeners();
      return;
    }
    final query = await FirebaseFirestore.instance
        .collection('asignaturas')
        .where('uid', isEqualTo: user.uid)
        .get();
    asignaturas = query.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
    cargando = false;
    notifyListeners();
  }

  // Agregar una nueva asignatura
  Future<void> agregarAsignatura(Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    data['uid'] = user.uid;
    data['createdAt'] = FieldValue.serverTimestamp();
    final docRef = await FirebaseFirestore.instance.collection('asignaturas').add(data);
    data['id'] = docRef.id;
    asignaturas.add(data);
    notifyListeners();
  }

  // Actualizar una asignatura existente
  Future<void> actualizarAsignatura(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('asignaturas').doc(id).update(data);
    final idx = asignaturas.indexWhere((a) => a['id'] == id);
    if (idx != -1) {
      asignaturas[idx] = {...asignaturas[idx], ...data};
      notifyListeners();
    }
  }

  // Eliminar una asignatura
  Future<void> eliminarAsignatura(String id) async {
    await FirebaseFirestore.instance.collection('asignaturas').doc(id).delete();
    asignaturas.removeWhere((a) => a['id'] == id);
    notifyListeners();
  }
}
