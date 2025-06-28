import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_flutter/core/preguntas_y_respuestas_provider.dart';
import 'package:login_flutter/core/tareas_provider.dart';
import 'package:login_flutter/firebase_options.dart';
import 'package:login_flutter/screens/welcome.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/core/usuario_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ChangeNotifierProvider(create: (_) => TareasProvider()),
        ChangeNotifierProvider(create: (_) => PreguntasProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login Flutter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'MiFuente',
        ),
        home: Welcome(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, String? title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
