import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_flutter/firebase_options.dart';
import 'package:login_flutter/screens/homescreen.dart';
import 'package:login_flutter/screens/signinscreen.dart';
//import 'package:login_flutter/screens/homescreen.dart';
import 'package:login_flutter/screens/welcome.dart';
//import 'package:login_flutter/widgets/custom_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //supportedLocales: [const Locale('es'),],
      debugShowCheckedModeBanner: false,
      title: 'Login Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'MiFuente',
      ),
      home: HomeScreen(),
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