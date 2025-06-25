import 'package:flutter/material.dart';
import 'package:login_flutter/components/tarea.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_flutter/screens/asignatura_detalle_screen.dart';

class Tareas extends StatelessWidget {
  Tareas({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('asignaturas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No hay asignaturas registradas'));
        }
        final docs = snapshot.data!.docs;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final tarea = Tarea(
              title: data['nombre'] ?? '',
              bgColor: Colors.black38,
              icon: Icons.book,
              iconColor: Colors.white,
              btnColor: Colors.grey[500],
              tareasLeft: (data['tareasPendientes'] as List?)?.length ?? 0,
              tareasDone: (data['tareasHechas'] as List?)?.length ?? 0,
              evaluacionesLeft: (data['evaluacionesPendientes'] as List?)?.length ?? 0,
              evaluacionesDone: (data['evaluacionesHechas'] as List?)?.length ?? 0,
              nota: _calcularNota(data),
              isLast: false,
            );
            return buildTarea(context, tarea, doc.id, data);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
        );
      },
    );
  }
}

// Calcula la nota promedio de las evaluaciones y tareas hechas
num _calcularNota(Map<String, dynamic> data) {
  final List evals = data['evaluacionesHechas'] ?? [];
  final List tareas = data['tareasHechas'] ?? [];
  num totalPonderado = 0;
  num totalMax = 0;
  for (final e in evals) {
    final obtenida = e['obtenida'] ?? e['calificacionObtenida'];
    final max = e['max'] ?? e['calificacionMaxima'];
    if (obtenida != null && max != null && max != 0) {
      totalPonderado += (num.tryParse(obtenida.toString()) ?? 0);
      totalMax += (num.tryParse(max.toString()) ?? 0);
    }
  }
  for (final t in tareas) {
    final obtenida = t['obtenida'] ?? t['calificacionObtenida'];
    final max = t['max'] ?? t['calificacionMaxima'];
    if (obtenida != null && max != null && max != 0) {
      totalPonderado += (num.tryParse(obtenida.toString()) ?? 0);
      totalMax += (num.tryParse(max.toString()) ?? 0);
    }
  }
  if (totalMax == 0) return 0;
  // Escala la nota a 20 y retorna como num con dos decimales
  return double.parse(((totalPonderado / totalMax) * 20).clamp(0, 20).toStringAsFixed(2));
}

// Calcula la nota acumulada y la nota máxima posible
Map<String, num> calcularNotas(Map<String, dynamic> data) {
  final List evalsHechas = data['evaluacionesHechas'] ?? [];
  final List tareasHechas = data['tareasHechas'] ?? [];
  final List evalsPendientes = data['evaluacionesPendientes'] ?? [];
  final List tareasPendientes = data['tareasPendientes'] ?? [];

  num totalPonderado = 0;
  num totalMaxHechas = 0;
  num totalMaxTodas = 0;

  // Hechas
  for (final e in evalsHechas) {
    final obtenida = e['obtenida'] ?? e['calificacionObtenida'];
    final max = e['max'] ?? e['calificacionMaxima'];
    if (obtenida != null && max != null && max != 0) {
      totalPonderado += (num.tryParse(obtenida.toString()) ?? 0);
      totalMaxHechas += (num.tryParse(max.toString()) ?? 0);
      totalMaxTodas += (num.tryParse(max.toString()) ?? 0);
    }
  }
  for (final t in tareasHechas) {
    final obtenida = t['obtenida'] ?? t['calificacionObtenida'];
    final max = t['max'] ?? t['calificacionMaxima'];
    if (obtenida != null && max != null && max != 0) {
      totalPonderado += (num.tryParse(obtenida.toString()) ?? 0);
      totalMaxHechas += (num.tryParse(max.toString()) ?? 0);
      totalMaxTodas += (num.tryParse(max.toString()) ?? 0);
    }
  }
  // Pendientes (solo suma el max)
  for (final e in evalsPendientes) {
    final max = e['max'] ?? e['calificacionMaxima'];
    if (max != null && max != 0) {
      totalMaxTodas += (num.tryParse(max.toString()) ?? 0);
    }
  }
  for (final t in tareasPendientes) {
    final max = t['max'] ?? t['calificacionMaxima'];
    if (max != null && max != 0) {
      totalMaxTodas += (num.tryParse(max.toString()) ?? 0);
    }
  }
  num notaAcumulada = (totalMaxHechas == 0) ? 0 : double.parse(((totalPonderado / totalMaxHechas) * 20).clamp(0, 20).toStringAsFixed(2));
  num notaMaxima = (totalMaxTodas == 0) ? 0 : double.parse(((totalPonderado / totalMaxTodas) * 20).clamp(0, 20).toStringAsFixed(2));
  return {
    'acumulada': notaAcumulada,
    'maxima': notaMaxima,
  };
}

Widget buildTarea(BuildContext context, Tarea tareaList, String asignaturaId, Map<String, dynamic> asignaturaData) {
  final notas = calcularNotas(asignaturaData);
  return InkWell(
    onTap: () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AsignaturaDetalleScreen(
            asignaturaId: asignaturaId,
            asignaturaData: asignaturaData,
            onUpdated: () {
              // Puedes agregar lógica adicional si necesitas refrescar algo más
            },
          ),
        ),
      );
      if (result == true) {
        // Si se guardó algún cambio, puedes refrescar la lista si es necesario
        // (en este caso, StreamBuilder ya lo hace automáticamente)
      }
    },
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: tareaList.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(tareaList.icon, color: tareaList.iconColor, size: 30),
              SizedBox(width: 20),
              Text(
                tareaList.title.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MiFuente',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Acumulada: ${notas['acumulada']}/20',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MiFuente',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  /*Text(
                    'Máxima posible: ${notas['maxima']}/20',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'MiFuente',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),*/
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            //runSpacing: 10,
            children: [
              Expanded(
                child: _buildTareaStatus(
                  tareaList.btnColor!,
                  tareaList.iconColor!,
                  '${tareaList.tareasLeft} tareas faltantes',
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: _buildTareaStatus(
                  Colors.grey[400]!,
                  tareaList.iconColor!,
                  '${tareaList.tareasDone} tareas hechas',
                ),
              ),
            ],
          ),
          SizedBox(height: 12,),
          Row(
            //runSpacing: 10,
            children: [
              Expanded(
                child: _buildTareaStatus(
                  Colors.grey[400]!,
                  tareaList.iconColor!,
                  '${tareaList.evaluacionesLeft} evaluaciones faltantes',
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: _buildTareaStatus(
                  tareaList.btnColor!,
                  tareaList.iconColor!,
                  '${tareaList.evaluacionesDone} evaluaciones hechas',
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildTareaStatus(Color bgColor, Color txtColor, String txt) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      txt,
      //overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: txtColor,
        fontFamily: 'MiFuente',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
