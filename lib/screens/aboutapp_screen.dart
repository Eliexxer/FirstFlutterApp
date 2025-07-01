import 'package:flutter/material.dart';
import 'package:login_flutter/components/upper_header.dart';
import 'package:login_flutter/screens/settingscreen.dart';

class AboutappScreen extends StatefulWidget {
  const AboutappScreen({super.key});

  @override
  State<AboutappScreen> createState() => _AboutappScreenState();
}

class _AboutappScreenState extends State<AboutappScreen> {
  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(left: he * 0.03, right: he * 0.03),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                upperHeader(
                  'Sobre la EsTuApp',
                  context,
                  false,
                  page: const SettingScreen(),
                ),
                SizedBox(height: he * 0.053),
                Center(child: Image.asset('assets/images/loguitppp.png', height: 140, width: 140,)),
                SizedBox(height: he*0.033,),
                Text(
                  '''EsTuApp está diseñada específicamente para estudiantes universitarios con el objetivo de optimizar la gestión de su tiempo académico y mejorar su rendimiento.\n\nA través de una interfaz intuitiva y funcional, los usuarios pueden registrar y organizar todas sus tareas, evaluaciones pendientes y actividades completadas, categorizándolas por asignatura.\n\nAdemás, la aplicación permite realizar un seguimiento detallado del progreso en cada materia, incorporando un sistema de control de calificaciones que facilita al estudiante conocer su rendimiento en tiempo real.\n\nEsta herramientano solo fomenta una planificación eficiente, sino que también promueve la autonomía y responsabilidad académica, convirtiéndose en un aliado esencial para alcanzar los objetivos universitarios.''',
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'MiFuente',
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
