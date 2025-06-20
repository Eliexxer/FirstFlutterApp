import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_flutter/components/upper_header.dart';
import 'package:login_flutter/screens/securityscreen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscurePassword = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final _formChangePasswordKey = GlobalKey<FormState>();

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
                'Cambiar Contraseña',
                context,
                false,
                page: const SecurityScreen(),
              ),
              SizedBox(height: he * 0.042),
              Form(
                key: _formChangePasswordKey,
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    Text(
                      'Su contraseña debe contener al menos 8 caracteres, debe incluir al menos:\n - 1 Letra Mayúscula.\n - 1 Número.\n - 1 Caracter Especial',
                      style: TextStyle(
                        fontFamily: 'MiFuente',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: he * 0.01),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      obscuringCharacter: '*',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su contraseña';
                        }
                        // Mínimo 8 caracteres, al menos una mayúscula, un número y un carácter especial
                        if (!RegExp(
                          r'^(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
                        ).hasMatch(value)) {
                          return '''Debe contener:
                        - 8 caracteres mínimo
                        - 1 letra mayúscula
                        - 1 número
                        - 1 carácter especial''';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text(
                          'Contraseña',
                          style: TextStyle(fontFamily: 'MiFuente'),
                        ),
                        hintText: 'Contraseña',
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
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _repeatPasswordController,
                      obscureText: true,
                      obscuringCharacter: '*',
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text(
                          'Repetir Contraseña',
                          style: TextStyle(fontFamily: 'MiFuente'),
                        ),
                        hintText: 'Repita su contraseña',
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
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _cambiarContrasena();
                      },
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.white70),
                        backgroundColor: WidgetStatePropertyAll(Colors.black87),
                        minimumSize: WidgetStatePropertyAll(
                          Size(double.infinity, 56),
                        ),
                      ),
                      child: Text(
                        'Cambiar Contraseña',
                        style: TextStyle(
                          fontFamily: 'MiFuente',
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cambiarContrasena() async {
    if (_formChangePasswordKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.currentUser!
            .updatePassword(_passwordController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña actualizada correctamente')),
        );
        // Opcional: Navega a otra pantalla o cierra el modal
      } on FirebaseAuthException catch (e) {
        String mensaje = 'Error al cambiar la contraseña';
        if (e.code == 'requires-recent-login') {
          mensaje = 'Por seguridad, vuelve a iniciar sesión y reintenta.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensaje)),
        );
      }
    }
  }
}
