import 'package:flutter/material.dart';
import 'package:login_flutter/components/custom_text.dart';
import 'package:login_flutter/core/premium_provider.dart';
import 'package:login_flutter/screens/premium_screen.dart';
import 'package:login_flutter/widgets/date_of_birth.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/core/usuario_provider.dart';
import 'package:login_flutter/screens/settingscreen.dart';

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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    usuarioProvider.respuestasDestacadas
                                        .toString(),
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

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
