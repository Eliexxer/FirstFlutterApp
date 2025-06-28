import 'package:flutter/material.dart';
import 'package:login_flutter/screens/signinscreen.dart';
import 'package:login_flutter/screens/signupscreen.dart';
import 'package:login_flutter/widgets/custom_scaffold.dart';
import 'package:login_flutter/widgets/welcome_button.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    return CustomScaffold(
      background: Container(color: Colors.black),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/images/hombre1.png', height: 48, width: 48,),
                      Image.asset('assets/images/mujer1.png', height: 48, width: 48,),
                      Image.asset('assets/images/hombre2.png', height: 48, width: 48,),
                      Image.asset('assets/images/mujer2.png', height: 48, width: 48,),
                    ],
                  ),
            ),
          ),
          SizedBox(height: he*0.03,),
          Expanded(
            flex: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: he * 0.125),
                  Image.asset('assets/images/Recurso 2.png', color: Colors.black,),
                  SizedBox(height: he*0.05,),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '¡Bienvenido de nuevo!\n',
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'MiFuente',
                              fontSize: 38,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\n¡La aplicación número 1 para los estudiantes!',
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
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Expanded(
                      child: WelcomeButton(
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
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                        ),
                        borderColor: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: WelcomeButton(
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
                        borderColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
