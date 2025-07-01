import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/core/premium_provider.dart';

class PremiumGuard extends StatelessWidget {
  final Widget child;
  final String feature;
  final Widget? fallback;
  
  const PremiumGuard({
    super.key,
    required this.child,
    required this.feature,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumProvider>(
      builder: (context, premiumProvider, _) {
        if (premiumProvider.cargando) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }
        
        if (premiumProvider.puedeAcceder(feature)) {
          return child;
        }
        
        return fallback ?? _buildPremiumRequired(context);
      },
    );
  }

  Widget _buildPremiumRequired(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffFDC830), Color(0XFFf37335)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/Recurso 8.png',
                  height: 60,
                  width: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Función Premium',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MiFuente',
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Esta función requiere una suscripción Premium para acceder a ella.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'MiFuente',
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _PremiumScreenInline(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Obtener Premium',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MiFuente',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Volver atrás',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'MiFuente',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla premium simplificada para evitar dependencias circulares
class _PremiumScreenInline extends StatefulWidget {
  @override
  _PremiumScreenInlineState createState() => _PremiumScreenInlineState();
}

class _PremiumScreenInlineState extends State<_PremiumScreenInline> {
  int _selectedPlan = 1;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _planes = [
    {
      'titulo': 'Plan Mensual',
      'precio': '9.99',
      'periodo': 'mes',
      'meses': 1,
    },
    {
      'titulo': 'Plan Anual',
      'precio': '79.99',
      'periodo': 'año',
      'meses': 12,
    },
  ];

  Future<void> _procesarSuscripcion() async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    final premiumProvider = Provider.of<PremiumProvider>(context, listen: false);
    final plan = _planes[_selectedPlan];
    
    await Future.delayed(const Duration(seconds: 2));
    
    final exito = await premiumProvider.activarPremium(meses: plan['meses'] as int);
    
    if (mounted) {
      setState(() => _isProcessing = false);
      
      if (exito) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Bienvenido a Premium!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al procesar la suscripción.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Vuélvete Premium',
          style: TextStyle(color: Colors.black, fontFamily: 'MiFuente'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                            Text(
                              plan['titulo'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MiFuente',
                              ),
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
            const SizedBox(height: 30),
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
          ],
        ),
      ),
    );
  }
}