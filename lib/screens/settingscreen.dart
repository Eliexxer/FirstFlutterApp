import 'package:flutter/material.dart';
import 'package:login_flutter/components/custom_text.dart';
import 'package:login_flutter/components/upper_header.dart';
import 'package:login_flutter/screens/menuscreen.dart';
import 'package:login_flutter/screens/securityscreen.dart';
import 'package:login_flutter/screens/welcome.dart';
import 'package:login_flutter/widgets/custom_switch.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitched = true;
  bool isSound = true;

  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(left: he * 0.03, right: he * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              upperHeader(
                'Configuración',
                context,
                false,
                page: const MenuScreen(),
              ),
              SizedBox(height: he * 0.035),
              Container(
                padding: EdgeInsets.all(he * 0.004),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 208, 240, 1),
                      Color.fromARGB(255, 253, 170, 52),
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[200],
                  ),
                  padding: EdgeInsets.all(he * 0.012),
                  child: Row(
                    children: [
                      Container(
                        height: he * 0.07,
                        width: he * 0.07,
                        padding: EdgeInsets.all(he * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[300],
                        ),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            const Color.fromARGB(
                              255,
                              224,
                              224,
                              224,
                            ).withOpacity(0.6),
                            BlendMode.srcATop,
                          ),
                          child: Icon(
                            Icons.workspace_premium_outlined,
                            size: 30,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(width: he * 0.015),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              customText('Tareas ', 26),
                              SizedBox(width: he * 0.005),
                              Image.asset(
                                'assets/images/Icons/plus.png',
                                height: 25,
                                width: 25,
                                color: Color.fromARGB(255, 141, 127, 65),
                              ),
                            ],
                          ),
                          SizedBox(height: he * 0.0005),
                          const Text(
                            'Desbloquea nuestras funciones más exclusivas',
                            style: TextStyle(
                              fontFamily: 'MiFuente',
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      Image.asset(
                        'assets/images/Icons/chevron-right.png',
                        color: Color.fromARGB(255, 22, 23, 22),
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: he * 0.025),
              Row(
                children: [
                  if (isSound == true)
                    Image.asset('assets/images/Icons/volume.png')
                  else
                    Image.asset('assets/images/Icons/volume-mute.png'),
                  SizedBox(width: he * 0.015),
                  const Text(
                    "Sonido",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'MiFuente',
                      color: Colors.black54,
                    ),
                  ),
                  Expanded(child: Container()),
                  CustomImageSwitch(
                    value: isSound,
                    onChanged: (context) {
                      setState(() {
                        isSound = context;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: he * 0.025),
              Row(
                children: [
                  if (isSwitched == true)
                    Icon(
                      Icons.notifications_active_outlined,
                      size: 25,
                      color: Colors.black87,
                    )
                  else
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 25,
                      color: Colors.black87,
                    ),
                  SizedBox(width: he * 0.015),
                  const Text(
                    'Notificaciones',
                    style: TextStyle(
                      fontFamily: 'MiFuente',
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  Expanded(child: Container()),
                  CustomImageSwitch(
                    value: isSwitched,
                    onChanged: (context) {
                      setState(() {
                        isSwitched = context;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: he * 0.025),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecurityScreen()),
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/Icons/lock-alt.png',
                      //color: Colors.black54,
                    ),
                    SizedBox(width: he * 0.015),
                    const Text(
                      'Privacidad y Seguridad',
                      style: TextStyle(
                        fontFamily: 'MiFuente',
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(child: Container()),
                    Image.asset(
                      'assets/images/Icons/chevron-right.png',
                      color: Colors.black54,
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(height: he * 0.025),
              Row(
                children: [
                  Image.asset(
                    'assets/images/Icons/info-circle.png',
                    //color: Colors.black54,
                  ),
                  SizedBox(width: he * 0.015),
                  const Text(
                    'Sobre la App',
                    style: TextStyle(
                      fontFamily: 'MiFuente',
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  Expanded(child: Container()),
                  Image.asset(
                    'assets/images/Icons/chevron-right.png',
                    color: Colors.black54,
                    height: 20,
                    width: 20,
                  ),
                ],
              ),
              SizedBox(height: he * 0.025),
              Row(
                children: [
                  Image.asset(
                    'assets/images/Icons/question-circle.png',
                    //color: Colors.black54,
                  ),
                  SizedBox(width: he * 0.015),
                  const Text(
                    'Ayuda y Soporte',
                    style: TextStyle(
                      fontFamily: 'MiFuente',
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  Expanded(child: Container()),
                  Image.asset(
                    'assets/images/Icons/chevron-right.png',
                    color: Colors.black54,
                    height: 20,
                    width: 20,
                  ),
                ],
              ),
              SizedBox(height: he * 0.025),
              const Divider(thickness: 1, color: Colors.black),
              SizedBox(height: he * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Welcome()),
                  );
                },
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    fontFamily: 'MiFuente',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: he * 0.02),
              const Text(
                'VERSION 0.1',
                style: TextStyle(
                  fontFamily: 'MiFuente',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
