import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:login_flutter/components/upper_header.dart';
import 'package:login_flutter/screens/homescreen.dart';

class AsignaturaDetalleScreen extends StatefulWidget {
  final String asignaturaId;
  final Map<String, dynamic> asignaturaData;
  final VoidCallback? onUpdated;

  const AsignaturaDetalleScreen({
    super.key,
    required this.asignaturaId,
    required this.asignaturaData,
    this.onUpdated,
  });

  @override
  State<AsignaturaDetalleScreen> createState() => _AsignaturaDetalleScreenState();
}

class _AsignaturaDetalleScreenState extends State<AsignaturaDetalleScreen> {
  late TextEditingController _nombreController;
  late List<Map<String, dynamic>> evaluacionesPendientes;
  late List<Map<String, dynamic>> evaluacionesHechas;
  late List<Map<String, dynamic>> tareasPendientes;
  late List<Map<String, dynamic>> tareasHechas;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.asignaturaData['nombre'] ?? '');
    evaluacionesPendientes = List<Map<String, dynamic>>.from(widget.asignaturaData['evaluacionesPendientes'] ?? []);
    evaluacionesHechas = List<Map<String, dynamic>>.from(widget.asignaturaData['evaluacionesHechas'] ?? []);
    tareasPendientes = List<Map<String, dynamic>>.from(widget.asignaturaData['tareasPendientes'] ?? []);
    tareasHechas = List<Map<String, dynamic>>.from(widget.asignaturaData['tareasHechas'] ?? []);
  }

  Future<void> _saveChanges() async {
    try {
      await FirebaseFirestore.instance.collection('asignaturas').doc(widget.asignaturaId).update({
        'nombre': _nombreController.text.trim(),
        'evaluacionesPendientes': evaluacionesPendientes,
        'evaluacionesHechas': evaluacionesHechas,
        'tareasPendientes': tareasPendientes,
        'tareasHechas': tareasHechas,
      });
      if (widget.onUpdated != null) widget.onUpdated!();
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  void _addItem(List<Map<String, dynamic>> list, {bool hecha = false}) {
    setState(() {
      list.add({
        'nombre': '',
        'descripcion': '',
        'fecha': null,
        'max': null,
        if (hecha) 'obtenida': null,
      });
    });
  }

  Widget _buildItemForm(List<Map<String, dynamic>> list, int index, {bool hecha = false}) {
    final item = list[index];
    DateTime? fecha;
    if (item['fecha'] is Timestamp) {
      fecha = (item['fecha'] as Timestamp).toDate();
    } else {
      fecha = item['fecha'] as DateTime?;
    }
    bool isVencida = !hecha && fecha != null && fecha.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: item['nombre'],
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
                    onChanged: (v) => item['nombre'] = v,
                  ),
                ),
                if (isVencida)
                  IconButton(
                    icon: Icon(Icons.warning, color: Colors.orange),
                    tooltip: 'Fecha vencida. ¿Ya fue evaluada?',
                    onPressed: () async {
                      final result = await showDialog<num?>(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController();
                          return AlertDialog(
                            title: Text('¿Ya fue evaluada?'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Ingrese la calificación obtenida si ya fue evaluada.'),
                                TextField(
                                  controller: controller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: 'Calificación obtenida'),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, null),
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final val = num.tryParse(controller.text);
                                  Navigator.pop(context, val);
                                },
                                child: Text('Guardar'),
                              ),
                            ],
                          );
                        },
                      );
                      if (result != null) {
                        setState(() {
                          item['obtenida'] = result;
                          // Mover a hechos
                          list.removeAt(index);
                          if (list == tareasPendientes) {
                            tareasHechas.add(item);
                          } else if (list == evaluacionesPendientes) {
                            evaluacionesHechas.add(item);
                          }
                        });
                      }
                    },
                  ),
              ],
            ),
            TextFormField(
              initialValue: item['descripcion'],
              decoration: InputDecoration(labelText: 'Descripción'),
              validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
              onChanged: (v) => item['descripcion'] = v,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(fecha == null
                      ? 'Fecha de entrega'
                      : DateFormat('yyyy-MM-dd').format(fecha)),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: fecha ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => item['fecha'] = picked);
                  },
                  child: const Text('Seleccionar fecha'),
                ),
              ],
            ),
            TextFormField(
              initialValue: item['max']?.toString(),
              decoration: InputDecoration(labelText: 'Calificación máxima'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
              onChanged: (v) => item['max'] = num.tryParse(v),
            ),
            if (hecha)
              TextFormField(
                initialValue: item['obtenida']?.toString(),
                decoration: InputDecoration(labelText: 'Calificación obtenida'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
                onChanged: (v) => item['obtenida'] = num.tryParse(v),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() => list.removeAt(index));
                },
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
    return Scaffold(
      //appBar: AppBar(title: const Text('Detalle de Asignatura')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: he*0.03, right: he*0.03, top: he*0.03, bottom: he*0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            upperHeader('Detalles de ${_nombreController.text}', context, false, page: HomeScreen()),
            SizedBox(height: he*0.015,),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre de la asignatura'),
            ),
            const SizedBox(height: 18),
            Text('Evaluaciones pendientes', style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate(
              evaluacionesPendientes.length,
              (i) => _buildItemForm(evaluacionesPendientes, i),
            ),
            TextButton.icon(
              onPressed: () => _addItem(evaluacionesPendientes),
              icon: Icon(Icons.add),
              label: Text('Agregar evaluación pendiente'),
            ),
            const SizedBox(height: 10),
            Text('Evaluaciones hechas', style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate(
              evaluacionesHechas.length,
              (i) => _buildItemForm(evaluacionesHechas, i, hecha: true),
            ),
            TextButton.icon(
              onPressed: () => _addItem(evaluacionesHechas, hecha: true),
              icon: Icon(Icons.add),
              label: Text('Agregar evaluación hecha'),
            ),
            const SizedBox(height: 10),
            Text('Tareas pendientes', style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate(
              tareasPendientes.length,
              (i) => _buildItemForm(tareasPendientes, i),
            ),
            TextButton.icon(
              onPressed: () => _addItem(tareasPendientes),
              icon: Icon(Icons.add),
              label: Text('Agregar tarea pendiente'),
            ),
            const SizedBox(height: 10),
            Text('Tareas hechas', style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate(
              tareasHechas.length,
              (i) => _buildItemForm(tareasHechas, i, hecha: true),
            ),
            TextButton.icon(
              onPressed: () => _addItem(tareasHechas, hecha: true),
              icon: Icon(Icons.add),
              label: Text('Agregar tarea hecha'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Guardar cambios'),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
