import 'package:flutter/material.dart';
import 'package:login_flutter/components/custom_option.dart';
import 'package:login_flutter/components/upper_header.dart';
import 'package:login_flutter/screens/change_password_screen.dart';
import 'package:login_flutter/screens/homescreen.dart';
import 'package:login_flutter/screens/settingscreen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
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
                'Privacidad y Seguridad',
                context,
                false,
                page: const SettingScreen(),
              ),
              SizedBox(height: he * 0.033),
              Text(
                'Seguridad e Inicio de Sesión',
                style: TextStyle(
                  fontFamily: 'MiFuente',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: he*0.023,),
              customOption(
                'Contraseña',
                'assets/images/Icons/lock-alt.png',
                'assets/images/Icons/chevron-right.png',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen(),
                    ),
                  );
                },
              ),
              customOption(
                'Mi Cuenta',
                'assets/images/Icons/user-circle.png',
                'assets/images/Icons/chevron-right.png',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              customOption(
                'Mis datos',
                'assets/images/Icons/upload.png',
                'assets/images/Icons/chevron-right.png',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
