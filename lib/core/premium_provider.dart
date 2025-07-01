import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class PremiumProvider extends ChangeNotifier {
  bool _isPremium = false;
  bool _cargando = false;
  StreamSubscription<DocumentSnapshot>? _premiumSub;

  bool get isPremium => _isPremium;
  bool get cargando => _cargando;

  // Cargar estado premium del usuario actual
  Future<void> cargarEstadoPremium() async {
    _cargando = true;
    notifyListeners();
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isPremium = false;
      _cargando = false;
      notifyListeners();
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      
      if (doc.exists) {
        final data = doc.data()!;
        _isPremium = data['isPremium'] ?? false;
        
        // Si es premium, verificar si no ha expirado
        if (_isPremium && data['premiumExpira'] != null) {
          final expira = (data['premiumExpira'] as Timestamp).toDate();
          if (DateTime.now().isAfter(expira)) {
            _isPremium = false;
            // Actualizar en Firestore
            await FirebaseFirestore.instance
                .collection('usuarios')
                .doc(user.uid)
                .update({'isPremium': false});
          }
        }
      }
    } catch (e) {
      _isPremium = false;
    }
    
    _cargando = false;
    notifyListeners();
  }

  // Escuchar cambios en tiempo real del estado premium
  void escucharEstadoPremium() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    _premiumSub?.cancel();
    _premiumSub = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        final nuevoPremium = data['isPremium'] ?? false;
        
        // Verificar expiración si es premium
        if (nuevoPremium && data['premiumExpira'] != null) {
          final expira = (data['premiumExpira'] as Timestamp).toDate();
          if (DateTime.now().isAfter(expira)) {
            _isPremium = false;
            // Actualizar en Firestore
            FirebaseFirestore.instance
                .collection('usuarios')
                .doc(user.uid)
                .update({'isPremium': false});
            return;
          }
        }
        
        if (_isPremium != nuevoPremium) {
          _isPremium = nuevoPremium;
          notifyListeners();
        }
      }
    });
  }

  // Activar premium (simulación de compra exitosa)
  Future<bool> activarPremium({int meses = 1}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      final expira = DateTime.now().add(Duration(days: 30 * meses));
      
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .update({
        'isPremium': true,
        'premiumExpira': Timestamp.fromDate(expira),
        'premiumActivado': FieldValue.serverTimestamp(),
      });
      
      _isPremium = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Desactivar premium (para testing)
  Future<bool> desactivarPremium() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .update({
        'isPremium': false,
        'premiumExpira': null,
      });
      
      _isPremium = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Verificar si puede acceder a funciones premium
  bool puedeAcceder(String funcion) {
    // Lista de funciones que requieren premium
    final funcionesPremium = [
      'tutoria',
      'pruebas',
      'material_estudio',
      'asignaturas_ilimitadas',
      'respuestas_destacadas',
    ];
    
    return _isPremium || !funcionesPremium.contains(funcion);
  }

  // Obtener fecha de expiración
  Future<DateTime?> getFechaExpiracion() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || !_isPremium) return null;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      
      if (doc.exists && doc.data()!['premiumExpira'] != null) {
        return (doc.data()!['premiumExpira'] as Timestamp).toDate();
      }
    } catch (e) {
      // Error al obtener fecha
    }
    
    return null;
  }

  @override
  void dispose() {
    _premiumSub?.cancel();
    super.dispose();
  }
}