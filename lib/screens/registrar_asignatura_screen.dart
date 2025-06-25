import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:login_flutter/components/upper_header.dart';
import 'package:login_flutter/screens/homescreen.dart';

class RegistrarAsignaturaScreen extends StatefulWidget {
  const RegistrarAsignaturaScreen({super.key});

  @override
  State<RegistrarAsignaturaScreen> createState() => _RegistrarAsignaturaScreenState();
}

class _RegistrarAsignaturaScreenState extends State<RegistrarAsignaturaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();

  List<Map<String, dynamic>> evaluacionesPendientes = [];
  List<Map<String, dynamic>> evaluacionesHechas = [];
  List<Map<String, dynamic>> tareasPendientes = [];
  List<Map<String, dynamic>> tareasHechas = [];

  void _addItem(List<Map<String, dynamic>> list, {bool hecha = false}) {
    setState(() {
      list.add({
        'nombre': '',
        'descripcion': '', // Nuevo campo
        'fecha': null,
        'max': null,
        if (hecha) 'obtenida': null,
      });
    });
  }

  Future<void> _saveAsignatura() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await FirebaseFirestore.instance.collection('asignaturas').add({
        'nombre': _nombreController.text.trim(),
        'evaluacionesPendientes': evaluacionesPendientes,
        'evaluacionesHechas': evaluacionesHechas,
        'tareasPendientes': tareasPendientes,
        'tareasHechas': tareasHechas,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  Widget _buildItemForm(List<Map<String, dynamic>> list, int index, {bool hecha = false}) {
    final item = list[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: item['nombre'],
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
              onChanged: (v) => item['nombre'] = v,
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
                  child: Text(item['fecha'] == null
                      ? 'Fecha de entrega'
                      : DateFormat('yyyy-MM-dd').format(item['fecha'])),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: item['fecha'] ?? DateTime.now(),
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
      //appBar: AppBar(title: const Text('Registrar Asignatura')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: he*0.03, right: he*0.03, top: he*0.03),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              upperHeader('Registrar Asignatura', context, false, page: HomeScreen()),
              SizedBox(height: he*0.035,),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre de la asignatura', labelStyle: TextStyle(
                  fontFamily: 'MiFuente',
                )),
                validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 18),
              Text('Evaluaciones pendientes', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'MiFuente')),
              ...List.generate(
                evaluacionesPendientes.length,
                (i) => _buildItemForm(evaluacionesPendientes, i),
              ),
              TextButton.icon(
                onPressed: () => _addItem(evaluacionesPendientes),
                icon: Icon(Icons.add),
                label: Text('Agregar evaluación pendiente', style: TextStyle(fontFamily: 'MiFuente'),),
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
                  onPressed: _saveAsignatura,
                  child: const Text('Guardar asignatura'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
