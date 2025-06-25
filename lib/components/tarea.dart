import 'package:flutter/material.dart';

class Tarea{
  IconData? icon;
  ImageProvider? image;
  String? title;
  Color? bgColor;
  Color? iconColor;
  Color? btnColor;
  num? tareasLeft;
  num? tareasDone;
  num? evaluacionesLeft;
  num? evaluacionesDone;
  num? nota;
  bool isLast;

  Tarea(
    {
      this.icon,
      this.image,
      this.title,
      this.bgColor,
      this.iconColor,
      this.btnColor,
      this.tareasLeft,
      this.tareasDone,
      this.evaluacionesLeft = 0,
      this.evaluacionesDone = 0,
      this.isLast = false,
      this.nota = 0,
    }
  );
  static List<Tarea> generarTarea() {
    return [
      Tarea(
        icon: Icons.person_rounded,
        image: AssetImage('assets/images/Icons/user.png'),
        title: 'Personal',
        bgColor: Colors.black38,
        iconColor: Colors.black87,
        btnColor: Colors.black54,
        tareasLeft: 5,
        tareasDone: 3,
        isLast: true, 
      ),
      Tarea(
        icon: Icons.person_rounded,
        image: AssetImage('assets/images/Icons/user.png'),
        title: 'Personal',
        bgColor: Colors.black38,
        iconColor: Colors.black87,
        btnColor: Colors.black54,
        tareasLeft: 5,
        tareasDone: 3,
        isLast: true, 
      ),
      Tarea(
        icon: Icons.numbers_rounded,
        image: AssetImage('assets/images/Icons/user.png'),
        title: 'Matemática',
        bgColor: Colors.grey[350],
        iconColor: Colors.white,
        btnColor: Colors.grey[500],
        tareasLeft: 5,
        tareasDone: 3,
        nota: 10,
        isLast: false, 
      ),
      Tarea(
        icon: Icons.person_rounded,
        image: AssetImage('assets/images/Icons/user.png'),
        title: 'Personal',
        bgColor: Colors.black38,
        iconColor: Colors.black87,
        btnColor: Colors.black54,
        tareasLeft: 5,
        tareasDone: 3,
        isLast: false, 
      ),
      Tarea(
        icon: Icons.person_rounded,
        image: AssetImage('assets/images/Icons/user.png'),
        title: 'Personal',
        bgColor: Colors.black38,
        iconColor: Colors.black87,
        btnColor: Colors.black54,
        tareasLeft: 5,
        tareasDone: 3,
        isLast: false, 
      ),
    ];
  }
}