
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_flutter/firebase_options.dart';

Future<void> main() async {
  // Inicializa Firebase usando firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final preguntas = await FirebaseFirestore.instance.collection('preguntas').get();

  for (final doc in preguntas.docs) {
    final data = doc.data();
    final respuestas = List<Map<String, dynamic>>.from(data['respuestas'] ?? []);
    bool needsUpdate = false;

    for (var r in respuestas) {
      if (!r.containsKey('likes')) {
        r['likes'] = [];
        needsUpdate = true;
      }
    }

    if (needsUpdate) {
      await doc.reference.update({'respuestas': respuestas});
      print('Actualizado: ${doc.id}');
    }
  }

  print('Migración completada.');
}
