import 'package:flutter/material.dart';
import 'package:login_flutter/widgets/custom_switch.dart';
import 'package:login_flutter/widgets/date_of_birth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formEditProfileKey = GlobalKey<FormState>();
  bool _camposEditables = false;
  String? _selectedGenero;
  String? _carreraSeleccionada;
  String? _usuarioDocId;
  DateTime? fechaNacimiento;
  int? edad;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _carreraController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  final List<String> _generos = ['Masculino', 'Femenino', 'Otro'];

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final query =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .where('correo', isEqualTo: user.email)
              .limit(1)
              .get();
      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        setState(() {
          _usuarioDocId = doc.id; // <--- Guarda el ID del documento
          _nombreController.text = doc['nombre'] ?? '';
          _apellidoController.text = doc['apellido'] ?? '';
          _correoController.text = doc['correo'] ?? '';
          _carreraSeleccionada = doc['carrera'];
          _selectedGenero = doc['genero'];
          fechaNacimiento =
              doc['fechaNacimiento'] != null
                  ? (doc['fechaNacimiento'] as Timestamp).toDate()
                  : null;
          edad = doc['edad'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              left: he * 0.03,
              right: he * 0.03,
              top: 0.03,
              bottom: 0.05,
            ),
            child: Form(
              key: _formEditProfileKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //upperHeader('Mi Perfil', context, false, page: const HomeScreen()),
                  SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: _camposEditables,
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
                            hintText: _nombreController.text,
                            hintStyle: const TextStyle(
                              color: Colors.black87,
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
                          enabled: _camposEditables,
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
                            hintText: _apellidoController.text,
                            hintStyle: const TextStyle(
                              color: Colors.black87,
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
                    enabled: _camposEditables,
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
                      hintText: _carreraController.text,
                      hintStyle: const TextStyle(
                        color: Colors.black87,
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
                        borderSide: BorderSide(
                          color:
                              _camposEditables
                                  ? Colors.black87
                                  : Colors.grey[200] ?? Colors.grey,
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
                    onChanged:
                        _camposEditables
                            ? (String? newValue) {
                              setState(() {
                                _selectedGenero = newValue;
                              });
                            }
                            : null,
                    disabledHint:
                        _selectedGenero != null
                            ? Text(_selectedGenero!)
                            : const Text('Seleccione un género'),
                    validator:
                        (value) =>
                            value == null
                                ? 'Por favor, selecciona una opción'
                                : null,
                  ),
                  SizedBox(height: 24),
                  DateOfBirthField(
                    enabled: _camposEditables,
                    initialDate: fechaNacimiento,
                    onValidDate: (fecha, edadCalculada) {
                      fechaNacimiento = fecha;
                      edad = edadCalculada;
                    },
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    enabled: _camposEditables,
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
                  Row(
                    children: [
                      CustomImageSwitch(
                        value: _camposEditables,
                        onChanged: (context) {
                          setState(() {
                            _camposEditables = context;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_camposEditables) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Por favor acepta el proceso de información personal',
                                  ),
                                ),
                              );
                              return;
                            }
                            if (_formEditProfileKey.currentState!.validate()) {
                              try {
                                final user = FirebaseAuth.instance.currentUser;
                                // Actualiza el correo en Firebase Auth
                                if (user != null &&
                                    user.email !=
                                        _correoController.text.trim()) {
                                  await user.verifyBeforeUpdateEmail(
                                    _correoController.text.trim(),
                                  );
                                }
                                // Actualiza los datos en Firestore
                                if (_usuarioDocId != null) {
                                  await FirebaseFirestore.instance
                                      .collection('usuarios')
                                      .doc(_usuarioDocId)
                                      .update({
                                        'nombre': _nombreController.text,
                                        'apellido': _apellidoController.text,
                                        'carrera': _carreraSeleccionada,
                                        'genero': _selectedGenero,
                                        'correo': _correoController.text,
                                        'fechaNacimiento': fechaNacimiento,
                                        'edad': edad,
                                      });
                                }
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Datos actualizados correctamente',
                                    ),
                                  ),
                                );
                              } on FirebaseAuthException catch (e) {
                                String mensaje = 'Error desconocido';
                                if (e.code == 'email-already-in-use') {
                                  mensaje = 'El correo ya está registrado';
                                } else if (e.code == 'invalid-email') {
                                  mensaje = 'El correo no es válido';
                                } else if (e.code == 'requires-recent-login') {
                                  mensaje =
                                      'Por seguridad, vuelve a iniciar sesión y reintenta.';
                                }
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(mensaje)),
                                );
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                          style: ButtonStyle(
                            foregroundColor: WidgetStatePropertyAll(
                              _camposEditables
                                  ? Colors.white70
                                  : Colors.black38,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              _camposEditables ? Colors.black87 : Colors.grey,
                            ),
                            minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, 56),
                            ),
                          ),
                          child: Text(
                            '¿Actualizar datos?',
                            style: TextStyle(
                              fontFamily: 'MiFuente',
                              fontWeight: FontWeight.w400,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _dateController.dispose();
    _correoController.dispose();
    super.dispose();
  }
}
