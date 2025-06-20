import 'package:flutter/material.dart';
import 'package:login_flutter/screens/signupscreen.dart';
import 'package:login_flutter/widgets/custom_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_flutter/widgets/date_of_birth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool agreePersonalData = false;
  bool _obscurePassword = true;
  String? _selectedGenero;
  //String? _carreraSeleccionada;
  DateTime? fechaNacimiento;
  int? edad;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _carreraController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  // Lista de opciones de género
  final List<String> _generos = ['Masculino', 'Femenino', 'Otro'];

  // Lista de opciones de carrera
  /*final List<String> _carreras = [
    'Administración',
    'Contabilidad',
    'Computación',
    'Derecho',
    'Enfermería',
    'Farmacia',
    'Filosofía',
    'Física',
    'Hotelería',
    'Ingeniería de Sistemas',
    'Ingeniería Civil',
    'Ingeniería Aeronáutica',
    'Ingeniería Eléctrica',
    'Ingeniería Electrónica',
    'Ingeniería en Telecomunicaciones',
    'Matemática',
    'Medicina',
    'Turismo',
  ];*/

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Image.asset(
                _selectedGenero == 'Femenino'
                    ? 'assets/images/mujer1.png'
                    : _selectedGenero == 'Masculino'
                    ? 'assets/images/hombre3.png'
                    : 'assets/images/otrodeefault.png',
                height: 220,
                width: 220,
              ),
            ),
          ),
          SizedBox(height: 34),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
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
                      Text(
                        '¡Comencemos!',
                        style: TextStyle(
                          fontFamily: 'MiFuente',
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nombreController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingrese su nombre';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text(
                                  'Nombre',
                                  style: TextStyle(fontFamily: 'MiFuente'),
                                ),
                                hintText: 'Ingrese su nombre',
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
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _apellidoController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingrese su apellido';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text(
                                  'Apellido',
                                  style: TextStyle(fontFamily: 'MiFuente'),
                                ),
                                hintText: 'Ingrese su apellido',
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
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        controller: _carreraController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese su carrera';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            'Carrera',
                            style: TextStyle(fontFamily: 'MiFuente'),
                          ),
                          hintText: 'Carrera',
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
                        /*items:
                            _carreras.map((String carrera) {
                              return DropdownMenuItem(
                                value: carrera,
                                child: Text(carrera),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _carreraSeleccionada = newValue;
                          });
                        },*/
                      ),
                      SizedBox(height: 24),
                      DropdownButtonFormField<String>(
                        value: _selectedGenero,
                        decoration: InputDecoration(
                          label: const Text(
                            'Género',
                            style: TextStyle(fontFamily: 'MiFuente'),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black87,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items:
                            _generos.map((String genero) {
                              return DropdownMenuItem<String>(
                                value: genero,
                                child: Text(genero),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGenero = newValue;
                          });
                        },
                        validator:
                            (value) =>
                                value == null
                                    ? 'Por favor, selecciona una opción'
                                    : null,
                      ),
                      SizedBox(height: 24),
                      DateOfBirthField(
                        onValidDate: (fecha, edadCalculada) {
                          fechaNacimiento = fecha;
                          edad = edadCalculada;
                        },
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        controller: _correoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese su correo electrónico';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            'Correo Electrónico',
                            style: TextStyle(fontFamily: 'MiFuente'),
                          ),
                          hintText: 'ejemplo@gmail.com',
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
                          suffixIcon: Image.asset(
                            'assets/images/Icons/envelope-alt.png',
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: Colors.black87,
                          ),
                          const Text(
                            'Estoy de acuerdo con el proceso de información',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (!agreePersonalData) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Por favor acepta el proceso de información personal',
                                ),
                              ),
                            );
                            return;
                          }
                          if (_formSignInKey.currentState!.validate()) {
                            try {
                              // Crear usuario en Firebase Auth
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                    email: _correoController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );
                              // Aquí puedes guardar datos adicionales en Firestore si lo deseas
                              await FirebaseFirestore.instance
                                  .collection('usuarios')
                                  .add({
                                    'nombre': _nombreController.text,
                                    'apellido': _apellidoController.text,
                                    'carrera': _carreraController.text,
                                    'genero': _selectedGenero,
                                    'correo': _correoController.text,
                                    'fechaNacimiento': fechaNacimiento,
                                    'edad': edad,
                                    'fechaRegistro':
                                        FieldValue.serverTimestamp(),
                                  });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Usuario registrado correctamente',
                                  ),
                                ),
                              );
                              // Navega a otra pantalla si quieres
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => SignUpScreen(),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              String mensaje = 'Error desconocido';
                              if (e.code == 'email-already-in-use') {
                                mensaje = 'El correo ya está registrado';
                              } else if (e.code == 'invalid-email') {
                                mensaje = 'El correo no es válido';
                              } else if (e.code == 'weak-password') {
                                mensaje = 'La contraseña es muy débil';
                              }
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(mensaje)));
                            }
                          }
                        },
                        style: ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(
                            Colors.white70,
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.black87,
                          ),
                          minimumSize: WidgetStatePropertyAll(
                            Size(double.infinity, 56),
                          ),
                        ),
                        child: Text(
                          'Regístrate',
                          style: TextStyle(
                            fontFamily: 'MiFuente',
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿Ya tienes una cuenta? ',
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
                                  builder: (e) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Inicia sesión',
                              style: TextStyle(
                                fontFamily: 'MiFuente',
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
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

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _dateController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }
}
