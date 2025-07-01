import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_flutter/screens/contacto_screen.dart';
import 'package:login_flutter/screens/homescreen.dart';
import 'package:login_flutter/screens/settingscreen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          left: he * 0.03,
          right: he * 0.03,
          bottom: he * 0.03,
          top: he * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: he * 0.03, bottom: he * 0.03),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Image.asset('assets/images/Icons/close-x-exit.png'),
                  ),
                  SizedBox(height: he * 0.01),
                ],
              ),
            ),
            SizedBox(height: he * 0.13),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ContactoScreen()),
                );
              },
              child: Text(
                'Contáctanos',
                style: TextStyle(fontFamily: 'MiFuente', fontSize: 30),
              ),
            ),
            SizedBox(height: he * 0.03),
            GestureDetector(
              onTap: () async {
                const url = 'https://www.google.com/'; // Reemplaza con tu URL
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url);
                } else {
                  throw 'No se pudo abrir $url';
                }
              },
              child: Text(
                'Sobre Nosotros',
                style: TextStyle(fontFamily: 'MiFuente', fontSize: 30),
              ),
            ),
            SizedBox(height: he * 0.03),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
              child: Text(
                'Configuración',
                style: TextStyle(fontFamily: 'MiFuente', fontSize: 30),
              ),
            ),
            SizedBox(height: he * 0.03),
            GestureDetector(
              onTap: SystemNavigator.pop,
              child: const Text(
                'Salir',
                style: TextStyle(fontFamily: 'MiFuente', fontSize: 30),
              ),
            ),
            SizedBox(height: he * 0.03),
          ],
        ),
      ),
    );
  }
}
