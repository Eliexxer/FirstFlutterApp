import 'package:flutter/material.dart';

class TutoriaScreen extends StatefulWidget {
  const TutoriaScreen({super.key});

  @override
  State<TutoriaScreen> createState() => _TutoriaScreenState();
}

class _TutoriaScreenState extends State<TutoriaScreen> {
  final List<String> _areas = [
    'Matemática', 'Castellano', 'Biología', 'Física', 'Química', 'Historia'
  ];
  String? _selectedArea;
  double _minRating = 1;
  double _maxRating = 5;
  double _minExperience = 1;
  double _maxExperience = 10;
  double _minPrice = 10;
  double _maxPrice = 60;

  // Ejemplo de datos de expertos
  final List<Map<String, dynamic>> _expertos = [
    {
      'nombre': 'Dr. Amelia Chen',
      'areas': ['Matemática', 'Física'],
      'rating': 4.8,
      'experiencia': 7,
      'precio': 60,
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'nombre': 'Dr. Ethan Ramirez',
      'areas': ['Biología', 'Química'],
      'rating': 4.5,
      'experiencia': 5,
      'precio': 40,
      'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    {
      'nombre': 'Dr. Olivia Carter',
      'areas': ['Historia', 'Castellano'],
      'rating': 4.2,
      'experiencia': 3,
      'precio': 30,
      'avatar': 'https://randomuser.me/api/portraits/women/65.jpg',
    },
    // Puedes agregar más expertos aquí
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _expertos.where((e) {
      final areaMatch = _selectedArea == null || e['areas'].contains(_selectedArea);
      final ratingMatch = (e['rating'] ?? 0) >= _minRating && (e['rating'] ?? 0) <= _maxRating;
      final expMatch = (e['experiencia'] ?? 0) >= _minExperience && (e['experiencia'] ?? 0) <= _maxExperience;
      final priceMatch = (e['precio'] ?? 0) >= _minPrice && (e['precio'] ?? 0) <= _maxPrice;
      return areaMatch && ratingMatch && expMatch && priceMatch;
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
        title: const Text('Encuentra a un experto', style: TextStyle(color: Colors.black)),
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
                  hintText: 'Busca por una asignatura',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedArea = value.isEmpty ? null : value;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            // Chips de áreas
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _areas.map((area) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(area),
                    selected: _selectedArea == area,
                    onSelected: (selected) {
                      setState(() {
                        _selectedArea = selected ? area : null;
                      });
                    },
                    selectedColor: Colors.deepPurpleAccent.withOpacity(0.15),
                    labelStyle: TextStyle(
                      color: _selectedArea == area ? Colors.deepPurpleAccent : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Filtros', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            // Rating
            _buildSlider('Rating', _minRating, _maxRating, 1, 5, (values) {
              setState(() {
                _minRating = values.start;
                _maxRating = values.end;
              });
            }),
            // Experiencia
            _buildSlider('Experiencia (años)', _minExperience, _maxExperience, 1, 10, (values) {
              setState(() {
                _minExperience = values.start;
                _maxExperience = values.end;
              });
            }),
            // Precio
            _buildSlider('Precio (REF/hour)', _minPrice, _maxPrice, 10, 60, (values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            }),
            const SizedBox(height: 10),
            const Text('Expertos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('No se encontraron expertos.'))
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final e = filtered[i];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(e['avatar']),
                              radius: 26,
                            ),
                            title: Text(e['nombre'], style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(e['areas'].join(', ')),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 18),
                                    Text(e['rating'].toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Text(' 24${e['precio']}/h', style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                            onTap: () {
                              // Aquí puedes abrir el perfil del experto o iniciar una solicitud de mentoría
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double min, double max, double minValue, double maxValue, Function(RangeValues) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        RangeSlider(
          values: RangeValues(min, max),
          min: minValue,
          max: maxValue,
          divisions: (maxValue - minValue).toInt(),
          labels: RangeLabels(min.toStringAsFixed(0), max.toStringAsFixed(0)),
          onChanged: onChanged,
          activeColor: Colors.deepPurpleAccent,
          inactiveColor: Colors.deepPurpleAccent.withOpacity(0.15),
        ),
      ],
    );
  }
}
