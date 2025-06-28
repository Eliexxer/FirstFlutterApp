import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioProvider extends ChangeNotifier {
  // Datos del usuario
  String? uid;
  String? correo;
  String? nombre;
  String? apellido;
  String? carrera;
  String? genero;
  DateTime? fechaNacimiento;
  int? edad;
  DateTime? fechaRegistro;
  int preguntas = 0;
  int respuestas = 0;
  bool cargando = false;

  // Cargar datos del usuario desde Firestore
  Future<void> cargarDatosUsuario() async {
    cargando = true;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        uid = user.uid;
        correo = data['correo'] ?? user.email;
        nombre = data['nombre'] ?? '';
        apellido = data['apellido'] ?? '';
        carrera = data['carrera'] ?? '';
        genero = data['genero'] ?? '';
        preguntas = data['preguntas'] ?? 0;
        respuestas = data['respuestas'] ?? 0;
        edad = data['edad'];
        // Fecha de nacimiento
        if (data['fechaNacimiento'] != null) {
          if (data['fechaNacimiento'] is Timestamp) {
            fechaNacimiento = (data['fechaNacimiento'] as Timestamp).toDate();
          } else if (data['fechaNacimiento'] is DateTime) {
            fechaNacimiento = data['fechaNacimiento'];
          }
        } else {
          fechaNacimiento = null;
        }
        // Fecha de registro
        if (data['fechaRegistro'] != null) {
          if (data['fechaRegistro'] is Timestamp) {
            fechaRegistro = (data['fechaRegistro'] as Timestamp).toDate();
          } else if (data['fechaRegistro'] is DateTime) {
            fechaRegistro = data['fechaRegistro'];
          }
        } else {
          fechaRegistro = null;
        }
      } else {
        // Si no existe, crear el documento
        await registrarUsuario();
      }
    }
    cargando = false;
    notifyListeners();
  }

  // Registrar usuario en Firestore si no existe
  Future<void> registrarUsuario({
    String? nombre,
    String? apellido,
    String? carrera,
    String? genero,
    DateTime? fechaNacimiento,
    int? edad,
    DateTime? fechaRegistro,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final now = DateTime.now();
      await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
        'correo': user.email,
        'nombre': nombre ?? user.displayName ?? '',
        'apellido': apellido ?? '',
        'carrera': carrera ?? '',
        'genero': genero ?? '',
        'fechaNacimiento': fechaNacimiento,
        'edad': edad,
        'fechaRegistro': fechaRegistro ?? now,
        'preguntas': 0,
        'respuestas': 0,
      }, SetOptions(merge: true));
      this.uid = user.uid;
      this.correo = user.email;
      this.nombre = nombre ?? user.displayName ?? '';
      this.apellido = apellido ?? '';
      this.carrera = carrera ?? '';
      this.genero = genero ?? '';
      this.fechaNacimiento = fechaNacimiento;
      this.edad = edad;
      this.fechaRegistro = fechaRegistro ?? now;
      preguntas = 0;
      respuestas = 0;
      notifyListeners();
    }
  }

  // (Eliminado: la lógica de incrementar contadores ahora está centralizada en los providers de preguntas y respuestas)

  // Actualizar datos del usuario
  Future<void> actualizarDatosUsuario({
    String? nombre,
    String? apellido,
    String? carrera,
    String? genero,
    DateTime? fechaNacimiento,
    int? edad,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = <String, dynamic>{};
      if (nombre != null) data['nombre'] = nombre;
      if (apellido != null) data['apellido'] = apellido;
      if (carrera != null) data['carrera'] = carrera;
      if (genero != null) data['genero'] = genero;
      if (fechaNacimiento != null) data['fechaNacimiento'] = fechaNacimiento;
      if (edad != null) data['edad'] = edad;
      await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set(data, SetOptions(merge: true));
      if (nombre != null) this.nombre = nombre;
      if (apellido != null) this.apellido = apellido;
      if (carrera != null) this.carrera = carrera;
      if (genero != null) this.genero = genero;
      if (fechaNacimiento != null) this.fechaNacimiento = fechaNacimiento;
      if (edad != null) this.edad = edad;
      notifyListeners();
    }
  }

  // Cerrar sesión y limpiar datos
  Future<void> cerrarSesion() async {
    await FirebaseAuth.instance.signOut();
    uid = null;
    correo = null;
    nombre = null;
    apellido = null;
    carrera = null;
    genero = null;
    fechaNacimiento = null;
    edad = null;
    fechaRegistro = null;
    preguntas = 0;
    respuestas = 0;
    notifyListeners();
  }

  // Iniciar sesión y recordar datos si es necesario
  Future<bool> iniciarSesion({
    required String correo,
    required String password,
    bool recordar = false,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: correo.trim(),
        password: password.trim(),
      );
      await cargarDatosUsuario();
      if (recordar) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', correo.trim());
        await prefs.setString('password', password.trim());
        await prefs.setBool('rememberPassword', true);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('email');
        await prefs.remove('password');
        await prefs.setBool('rememberPassword', false);
      }
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  // Cargar datos recordados (correo y contraseña)
  Future<Map<String, String>?> cargarDatosRecordados() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('rememberPassword') ?? false;
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (remember && email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  // Cambiar correo electrónico tras reautenticación
  Future<String?> cambiarCorreo({
    required String nuevoCorreo,
    required String passwordActual,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return 'Usuario no autenticado';
      final cred = EmailAuthProvider.credential(email: user.email!, password: passwordActual);
      await user.reauthenticateWithCredential(cred);
      await user.updateEmail(nuevoCorreo.trim());
      await cargarDatosUsuario();
      return null; // Éxito
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Por seguridad, vuelve a iniciar sesión y reintenta.';
      } else if (e.code == 'email-already-in-use') {
        return 'El correo ya está registrado.';
      } else if (e.code == 'invalid-email') {
        return 'El correo no es válido.';
      }
      return 'Error: ${e.message}';
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Cambiar contraseña tras reautenticación
  Future<String?> cambiarContrasena({
    required String passwordActual,
    required String nuevaContrasena,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return 'Usuario no autenticado';
      final cred = EmailAuthProvider.credential(email: user.email!, password: passwordActual);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(nuevaContrasena.trim());
      return null; // Éxito
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Por seguridad, vuelve a iniciar sesión y reintenta.';
      } else if (e.code == 'weak-password') {
        return 'La contraseña es muy débil.';
      }
      return 'Error: ${e.message}';
    } catch (e) {
      return 'Error: $e';
    }
  }
}