import 'package:flutter/material.dart';
import 'package:login_flutter/components/custom_text.dart';
import 'package:login_flutter/components/upper_header.dart';
import 'package:login_flutter/screens/aboutapp_screen.dart';
import 'package:login_flutter/screens/contacto_screen.dart';
import 'package:login_flutter/screens/menuscreen.dart';
import 'package:login_flutter/screens/securityscreen.dart';
import 'package:login_flutter/screens/welcome.dart';
import 'package:login_flutter/screens/premium_screen.dart';
import 'package:login_flutter/widgets/custom_switch.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/core/premium_provider.dart';

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

              // Widget Premium - Solo mostrar si NO es premium
              Consumer<PremiumProvider>(
                builder: (context, premiumProvider, child) {
                  if (premiumProvider.isPremium) {
                    // Si es premium, mostrar estado premium
                    return Container(
                      padding: EdgeInsets.all(he * 0.012),
                      margin: EdgeInsets.only(bottom: he * 0.025),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green[50],
                        border: Border.all(color: Colors.green, width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: he * 0.07,
                            width: he * 0.07,
                            padding: EdgeInsets.all(he * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.green,
                            ),
                            child: Icon(
                              Icons.workspace_premium,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: he * 0.015),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    customText('Premium ', 26),
                                    SizedBox(width: he * 0.005),
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 25,
                                    ),
                                  ],
                                ),
                                SizedBox(height: he * 0.0005),
                                const Text(
                                  'Tienes acceso a todas las funciones premium',
                                  style: TextStyle(
                                    fontFamily: 'MiFuente',
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Botón para gestionar suscripción
                          TextButton(
                            onPressed: () {
                              _showManagePremiumDialog(
                                context,
                                premiumProvider,
                              );
                            },
                            child: Text(
                              'Gestionar',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Si NO es premium, mostrar widget para volverse premium
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PremiumScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(he * 0.004),
                        margin: EdgeInsets.only(bottom: he * 0.025),
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        customText('EsTuPrime ', 26),
                                        SizedBox(width: he * 0.005),
                                        Image.asset(
                                          'assets/images/Icons/plus.png',
                                          height: 25,
                                          width: 25,
                                          color: Color.fromARGB(
                                            255,
                                            141,
                                            127,
                                            65,
                                          ),
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
                              ),
                              SizedBox(width: he * 0.005),
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
                    );
                  }
                },
              ),

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
                  Spacer(),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutappScreen()));
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/Icons/info-circle.png',
                      //color: Colors.black54,
                    ),
                    SizedBox(width: he * 0.015),
                    const Text(
                      'Sobre EsTuApp',
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
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactoScreen()));
                },
                child: Row(
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

  void _showManagePremiumDialog(
    BuildContext context,
    PremiumProvider premiumProvider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Gestionar Premium',
              style: TextStyle(fontFamily: 'MiFuente'),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tu suscripción Premium está activa.',
                  style: TextStyle(fontFamily: 'MiFuente'),
                ),
                const SizedBox(height: 10),
                FutureBuilder<DateTime?>(
                  future: premiumProvider.getFechaExpiracion(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Text(
                        'Expira el: ${snapshot.data!.day}/${snapshot.data!.month}/${snapshot.data!.year}',
                        style: TextStyle(
                          fontFamily: 'MiFuente',
                          color: Colors.grey[600],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.black, fontFamily: 'MiFuente'),
                ),
              ),
              // Solo para testing - remover en producción
              TextButton(
                onPressed: () async {
                  await premiumProvider.desactivarPremium();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Premium desactivado')),
                  );
                },
                child: const Text(
                  'Desactivar (Test)',
                  style: TextStyle(color: Colors.red, fontFamily: 'MiFuente'),
                ),
              ),
            ],
          ),
    );
  }
}
