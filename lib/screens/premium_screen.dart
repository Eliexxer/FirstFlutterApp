import 'package:flutter/material.dart';
import 'package:login_flutter/components/upper_header.dart';
import 'package:login_flutter/screens/homescreen.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/core/premium_provider.dart';

class PremiumScreen extends StatefulWidget {
  final bool fromRestriction;
  
  const PremiumScreen({
    super.key, 
    this.fromRestriction = false
  });

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _selectedPlan = 1; // 0: Mensual, 1: Anual
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _planes = [
    {
      'titulo': 'Plan Mensual',
      'precio': '2.99',
      'periodo': 'mes',
      'ahorro': null,
      'meses': 1,
    },
    {
      'titulo': 'Plan Anual',
      'precio': '20.99',
      'periodo': 'año',
      'ahorro': '33%',
      'meses': 12,
    },
  ];

  final List<String> _beneficios = [
    'Acceso ilimitado a tutorías personalizadas',
    'Descarga y acceso a material de estudio',
    'Pruebas y exámenes de práctica',
    'Asignaturas ilimitadas',
    'Respuestas destacadas prioritarias',
    'Soporte técnico prioritario',
    'Sin anuncios',
    'Backup automático de datos',
  ];

  Future<void> _procesarSuscripcion() async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    final premiumProvider = Provider.of<PremiumProvider>(context, listen: false);
    final plan = _planes[_selectedPlan];
    
    // Simular proceso de pago
    await Future.delayed(const Duration(seconds: 2));
    
    final exito = await premiumProvider.activarPremium(meses: plan['meses']);
    
    if (mounted) {
      setState(() => _isProcessing = false);
      
      if (exito) {
        _mostrarExito();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al procesar la suscripción. Inténtalo de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _mostrarExito() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Bienvenido a Premium!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'MiFuente',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ya tienes acceso a todas las funciones premium de EsTuApp',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontFamily: 'MiFuente',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar diálogo
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Empezar a usar Premium',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'MiFuente',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: he * 0.03,
            right: he * 0.03,
            bottom: he * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.fromRestriction)
                upperHeader(
                  'Vuélvete Premium',
                  context,
                  false,
                  page: const HomeScreen(),
                )
              else
                Padding(
                  padding: EdgeInsets.only(top: he * 0.03),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        ),
                        icon: const Icon(Icons.close, size: 30),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Función Premium',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MiFuente',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              SizedBox(height: he * 0.02),
              
              // Header premium
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffFDC830), Color(0XFFf37335)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/Recurso 8.png',
                      height: 60,
                      width: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'EsTuApp Premium',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'MiFuente',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Desbloquea todo el potencial de tu aprendizaje',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'MiFuente',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Planes de suscripción
              const Text(
                'Elige tu plan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MiFuente',
                ),
              ),
              const SizedBox(height: 15),
              
              ...List.generate(_planes.length, (index) {
                final plan = _planes[index];
                final isSelected = _selectedPlan == index;
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedPlan = index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Radio<int>(
                          value: index,
                          groupValue: _selectedPlan,
                          onChanged: (value) => setState(() => _selectedPlan = value!),
                          activeColor: Colors.black,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    plan['titulo'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'MiFuente',
                                    ),
                                  ),
                                  if (plan['ahorro'] != null) ...[
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Ahorra ${plan['ahorro']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                '\$${plan['precio']} / ${plan['periodo']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontFamily: 'MiFuente',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              
              const SizedBox(height: 25),
              
              // Beneficios
              const Text(
                'Lo que incluye Premium:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MiFuente',
                ),
              ),
              const SizedBox(height: 15),
              
              ...List.generate(_beneficios.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _beneficios[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'MiFuente',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              
              const SizedBox(height: 30),
              
              // Botón de suscripción
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _procesarSuscripcion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text(
                          'Suscribirse por \$${_planes[_selectedPlan]['precio']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MiFuente',
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Términos
              Text(
                'Al suscribirte, aceptas nuestros términos y condiciones. La suscripción se renueva automáticamente.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: 'MiFuente',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}