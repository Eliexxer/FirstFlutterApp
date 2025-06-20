import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:login_flutter/components/tarea.dart';
//import 'package:dotted_border/dotted_border.dart' show BorderType;

class Tareas extends StatelessWidget {
  final tareaList = Tarea.generarTarea();
  Tareas({super.key});

  /*@override
  State<Tareas> createState() => _TareasState();*/

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        shrinkWrap: true,
        //physics: NeverScrollableScrollPhysics(),
        itemCount: tareaList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          //mainAxisExtent: 225,
          childAspectRatio: 0.8,
        ),
        itemBuilder:
            (context, index) =>
                tareaList[index].isLast
                    ? _buildAddTarea()
                    : buildTarea(context, tareaList[index]),
      ),
    );
  }
}

Widget _buildAddTarea() {
  return DottedBorder(
    options: RoundedRectDottedBorderOptions(
      radius: Radius.circular(20),
      color: Colors.grey.shade600,
      strokeWidth: 2,
      dashPattern: [10, 5],
    ),
    child: Center(
      child: Image.asset('assets/images/Icons/plus.png', height: 30, width: 30, color: Colors.grey[600],)//Icon(Icons.add, size: 30, color: Colors.grey.shade600),
    ),
  );
}

Widget buildTarea(BuildContext context, Tarea tareaList) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: tareaList.bgColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(tareaList.icon, color: tareaList.iconColor, size: 30),
        /*Image(
          image: tareaList.image!,
          width: 30,
          height: 30,
          color: tareaList.iconColor,
        ),*/
        SizedBox(height: 30),
        Text(
          tareaList.title.toString(),
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'MiFuente',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          runSpacing: 10,
          children: [
            Expanded(
              child: _buildTareaStatus(
                tareaList.btnColor!,
                tareaList.iconColor!,
                '${tareaList.left} faltantes',
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: _buildTareaStatus(
                Colors.grey[400]!,
                tareaList.iconColor!,
                '${tareaList.left} hechos',
              ),
            ),
          ],
        ),
      ],
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
