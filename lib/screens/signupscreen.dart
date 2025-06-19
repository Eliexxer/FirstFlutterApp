import 'package:flutter/material.dart';
import 'package:login_flutter/screens/homescreen.dart';
import 'package:login_flutter/screens/signinscreen.dart';
import 'package:login_flutter/widgets/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  bool _obscurePassword = true;
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkRememberedLogin();
  }

  Future<void> _checkRememberedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('rememberPassword') ?? false;
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (remember && email != null && password != null) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (e) => HomeScreen()),
        );
      } catch (e) {
        // Si falla el login automático, no hacer nada
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Image.asset(
                'assets/images/hombre3.png',
                height: 360,
                width: 360,
              ),
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            flex: 7,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                        child: Text(
                          '¡BIENVENIDO!',
                          style: TextStyle(
                            fontFamily: 'MiFuente',
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: TextFormField(
                          controller: _correoController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese un correo electrónico';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text(
                              'Email',
                              style: TextStyle(fontFamily: 'MiFuente'),
                            ),
                            hintText: 'Ingrese su correo electrónico',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                              fontFamily: 'MiFuente',
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black87,
                                width: 10,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: Image.asset('assets/images/Icons/envelope-alt.png', color: Colors.black45,)
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese una contraseña';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text(
                              'Contraseña',
                              style: TextStyle(fontFamily: 'MiFuente'),
                            ),
                            hintText: 'Ingrese una contraseña',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                              fontFamily: 'MiFuente',
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black87,
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberPassword,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberPassword = value!;
                                    });
                                  },
                                  activeColor: Colors.black87,
                                ),
                                const Text(
                                  'Recuérdame',
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formSignInKey.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: _correoController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );
                                  // Guarda los datos si rememberPassword es true
                                  if (rememberPassword) {
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('email', _correoController.text.trim());
                                    await prefs.setString('password', _passwordController.text.trim());
                                    await prefs.setBool('rememberPassword', true);
                                  } else {
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.remove('email');
                                    await prefs.remove('password');
                                    await prefs.setBool('rememberPassword', false);
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Inicio de sesión exitoso')),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (e) => HomeScreen()),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  String mensaje = 'Error desconocido';
                                  if (e.code == 'user-not-found') {
                                    mensaje = 'Usuario no encontrado';
                                  } else if (e.code == 'wrong-password') {
                                    mensaje = 'Contraseña incorrecta';
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(mensaje)),
                                  );
                                }
                              }
                            },
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all(
                                Colors.white70,
                              ),
                              backgroundColor: WidgetStateProperty.all(
                                Colors.black87,
                              ),
                              minimumSize: WidgetStatePropertyAll(
                                Size(double.infinity, 56),
                              ),
                            ),
                            child: Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontFamily: 'MiFuente',
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 34),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿No tienes una cuenta? ',
                            style: TextStyle(
                              fontFamily: 'MiFuente',
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Regístrate',
                              style: TextStyle(
                                fontFamily: 'MiFuente',
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 34),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
