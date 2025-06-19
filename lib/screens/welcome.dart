import 'package:flutter/material.dart';
import 'package:login_flutter/screens/signinscreen.dart';
import 'package:login_flutter/screens/signupscreen.dart';
import 'package:login_flutter/widgets/custom_scaffold.dart';
import 'package:login_flutter/widgets/welcome_button.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      background: Container(color: Colors.white),
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '¡Bienvenido de nuevo!\n',
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'MiFuente',
                          fontSize: 45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            '\nIngrese detalles personales para su cuenta de estudiante',
                        style: TextStyle(
                          fontFamily: 'MiFuente',
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      //imageProvider: AssetImage('assets/images/Size=Large, Type=Solid.png'),
                      buttonText: 'Regístrate',
                      textStyle: TextStyle(
                        fontFamily: 'MiFuente',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ),
                        );
                      },
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                      ),
                      borderColor: Colors.transparent,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      //imageProvider: AssetImage('assets/images/Size=Large, Type=Solid.png'),
                      buttonText: 'Iniciar Sesión',
                      textStyle: TextStyle(
                        fontFamily: 'MiFuente',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                      ),
                      borderColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
