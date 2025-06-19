import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum UserRol { admin, user, superAdmin }

class RegisterProvider extends ChangeNotifier {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(
    {
      required String nombre,
      required String apellido,
      required String email,
      required String password,
      required String rol,
      required String age,
      required String birth,
      required String token,
      required String createdAt,
      //required Function onSuccess,
      required Function(String) onError,
    }
  ) async {
    try {
      //verificar las credenciales del usuario
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final User user = userCredential.user!;
      final String userId = user.uid;

      final userDatos = {
        'id': userId,
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'password': password,
        'rol': rol,
        'birth': birth,
        'age': age,
        'token': token,
        'createdAt': createdAt,
      };

      await _firestore.collection('usuarios').doc(userId).set(userDatos);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        onError('El correo ya está registrado');
      } else if (e.code == 'invalid-email') {
        onError('El correo no es válido');
      } else if (e.code == 'weak-password') {
        onError('La contraseña es muy débil');
      }
    } catch (e) {
      onError('Error: $e');
    }
  }
}