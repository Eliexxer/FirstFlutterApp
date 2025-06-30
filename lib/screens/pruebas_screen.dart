import 'package:flutter/material.dart';

class PruebasScreen extends StatefulWidget {
  const PruebasScreen({super.key});

  @override
  State<PruebasScreen> createState() => _PruebasScreenState();
}

class _PruebasScreenState extends State<PruebasScreen> {
  final List<String> _universidades = [
    'UNEFA',
    'Universidad Central de Venezuela',
    'Universidad Simón Bolívar',
  ];
  final List<String> _materias = [
    'Matemática',
    'Física',
    'Química',
    'Cálculo',
    'Álgebra Lineal',
  ];
  final List<String> _topicos = [
    'Límites y Derivadas',
    'Integrales',
    'Problemas de Práctica',
    'Examen Intermedio',
    'Examen Final',
  ];
  String? _selectedUniversidad = 'UNEFA';
  String? _selectedMateria = 'Matemática';
  String? _selectedTopico;
  int _tipoSeleccionado = 2; // 0: Ejercicios, 1: Exámenes, 2: Ambos
  String _search = '';

  // Guardar favoritos en memoria local (puedes migrar a Firestore o SharedPreferences si lo deseas)
  final Set<String> _favoritos = {};

  final List<Map<String, dynamic>> _materiales = [
    {
      'titulo': 'Cálculo II - Examen Intermedio',
      'fecha': '2023-04-15',
      'universidad': 'Universidad Central de Venezuea',
      'materia': 'Matemática',
      'topico': 'Examen Final',
      'tipo': 1, // Examen
    },
    {
      'titulo': 'Linear Algebra - Practice Problems',
      'fecha': '2023-03-20',
      'universidad': 'UNEFA',
      'materia': 'Matemática',
      'topico': 'Problemas de Práctica',
      'tipo': 0, // Ejercicio
    },
    {
      'titulo': 'Physics I - Final Exam',
      'fecha': '2023-02-28',
      'universidad': 'University National',
      'materia': 'Physics',
      'topico': 'Final Exam',
      'tipo': 1, // Examen
    },
    // Puedes agregar más materiales aquí
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _materiales.where((m) {
      final uniMatch = _selectedUniversidad == null || m['universidad'] == _selectedUniversidad;
      final matMatch = _selectedMateria == null || m['materia'] == _selectedMateria;
      final topicoMatch = _selectedTopico == null || m['topico'] == _selectedTopico;
      final tipoMatch = _tipoSeleccionado == 2 || m['tipo'] == _tipoSeleccionado;
      final searchMatch = _search.isEmpty || (m['titulo'] as String).toLowerCase().contains(_search.toLowerCase());
      return uniMatch && matMatch && topicoMatch && tipoMatch && searchMatch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Material de Estudio', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Busca por tus materiales de estudio',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            // Chips de filtros
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._universidades.map((u) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(u),
                      selected: _selectedUniversidad == u,
                      onSelected: (selected) {
                        setState(() {
                          _selectedUniversidad = selected ? u : null;
                        });
                      },
                      selectedColor: Colors.deepPurpleAccent.withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: _selectedUniversidad == u ? Colors.deepPurpleAccent : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
                  ..._materias.map((m) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(m),
                      selected: _selectedMateria == m,
                      onSelected: (selected) {
                        setState(() {
                          _selectedMateria = selected ? m : null;
                        });
                      },
                      selectedColor: Colors.deepPurpleAccent.withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: _selectedMateria == m ? Colors.deepPurpleAccent : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
                  ..._topicos.map((t) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(t),
                      selected: _selectedTopico == t,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTopico = selected ? t : null;
                        });
                      },
                      selectedColor: Colors.deepPurpleAccent.withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: _selectedTopico == t ? Colors.deepPurpleAccent : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Toggle ejercicios/exámenes/ambos
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToggle('Ejercicios', 0),
                  _buildToggle('Exámenes', 1),
                  _buildToggle('Ambos', 2),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('Resultados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('No se encontró material.'))
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final m = filtered[i];
                        final isFav = _favoritos.contains(m['titulo'] + m['fecha']);
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                          title: Text(m['titulo'], style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(m['fecha'], style: const TextStyle(fontSize: 13, color: Colors.black54)),
                          trailing: IconButton(
                            icon: Icon(
                              isFav ? Icons.bookmark : Icons.bookmark_border,
                              color: isFav ? Colors.deepPurpleAccent : Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                final key = m['titulo'] + m['fecha'];
                                if (_favoritos.contains(key)) {
                                  _favoritos.remove(key);
                                } else {
                                  _favoritos.add(key);
                                }
                              });
                            },
                          ),
                          onTap: () {
                            // Acción para abrir el material
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(String label, int value) {
    final selected = _tipoSeleccionado == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tipoSeleccionado = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.deepPurpleAccent.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.deepPurpleAccent : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
