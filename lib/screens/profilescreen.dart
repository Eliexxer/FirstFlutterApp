import 'package:flutter/material.dart';
import 'package:login_flutter/widgets/date_of_birth.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/core/usuario_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formEditProfileKey = GlobalKey<FormState>();
  String? _selectedGenero;
  DateTime? fechaNacimiento;
  int? edad;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _carreraController = TextEditingController();
  // Eliminados los controladores de contadores, usaremos el provider directamente

  final List<String> _generos = ['Masculino', 'Femenino', 'Otro'];

  @override
  void initState() {
    super.initState();
    final usuarioProvider = Provider.of<UsuarioProvider>(
      context,
      listen: false,
    );
    usuarioProvider.escucharUsuario();
    // Ya no es necesario llamar a _loadDatosUsuarioSeguro porque escucharUsuario actualiza en tiempo real
    _nombreController.text = usuarioProvider.nombre ?? '';
    _apellidoController.text = usuarioProvider.apellido ?? '';
    _carreraController.text = usuarioProvider.carrera ?? '';
    _selectedGenero = usuarioProvider.genero;
    fechaNacimiento = usuarioProvider.fechaNacimiento;
    edad = usuarioProvider.edad;
  }

  // El método _loadDatosUsuarioSeguro ya no es necesario porque escucharUsuario actualiza en tiempo real

  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
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
                  SizedBox(height: 50),
                  Consumer<UsuarioProvider>(
                    builder: (context, usuarioProvider, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    usuarioProvider.preguntas.toString(),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Preguntas',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    usuarioProvider.respuestas.toString(),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Respuestas',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    usuarioProvider.respuestasDestacadas.toString(),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Destacadas',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: he * 0.03),
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
                        borderSide: BorderSide(color: Colors.black87, width: 5),
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
                    key: ValueKey(
                      fechaNacimiento,
                    ), // fuerza rebuild si cambia la fecha
                    initialDate: fechaNacimiento,
                    onValidDate: (fecha, edadCalculada) {
                      setState(() {
                        fechaNacimiento = fecha;
                        edad = edadCalculada;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formEditProfileKey.currentState!.validate()) {
                              final usuarioProvider =
                                  Provider.of<UsuarioProvider>(
                                    context,
                                    listen: false,
                                  );
                              await usuarioProvider.actualizarDatosUsuario(
                                nombre: _nombreController.text,
                                apellido: _apellidoController.text,
                                carrera: _carreraController.text,
                                genero: _selectedGenero,
                                fechaNacimiento: fechaNacimiento,
                                edad: edad,
                              );
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Datos actualizados correctamente',
                                  ),
                                ),
                              );
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
    super.dispose();
  }
}
