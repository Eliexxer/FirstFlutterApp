import 'package:flutter/material.dart';

class Tarea{
  IconData? icon;
  ImageProvider? image;
  String? title;
  Color? bgColor;
  Color? iconColor;
  Color? btnColor;
  num? left;
  num? done;
  bool isLast;

  Tarea(
    {
      this.icon,
      this.image,
      this.title,
      this.bgColor,
      this.iconColor,
      this.btnColor,
      this.left,
      this.done,
      this.isLast = false,
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
        left: 5,
        done: 3,
        isLast: true, 
      ),
      Tarea(
        icon: Icons.person_rounded,
        image: AssetImage('assets/images/Icons/user.png'),
        title: 'Personal',
        bgColor: Colors.black38,
        iconColor: Colors.black87,
        btnColor: Colors.black54,
        left: 5,
        done: 3,
        isLast: true, 
      ),
      Tarea(
        icon: Icons.numbers_rounded,
        image: AssetImage('assets/images/Icons/user.png'),
        title: 'Matemática',
        bgColor: Colors.grey[350],
        iconColor: Colors.white,
        btnColor: Colors.grey[500],
        left: 5,
        done: 3,
        isLast: false, 
      ),
      Tarea(
        icon: Icons.person_rounded,
        image: AssetImage('assets/images/Icons/user.png'),
        title: 'Personal',
        bgColor: Colors.black38,
        iconColor: Colors.black87,
        btnColor: Colors.black54,
        left: 5,
        done: 3,
        isLast: false, 
      ),
      Tarea(
        icon: Icons.person_rounded,
        image: AssetImage('assets/images/Icons/user.png'),
        title: 'Personal',
        bgColor: Colors.black38,
        iconColor: Colors.black87,
        btnColor: Colors.black54,
        left: 5,
        done: 3,
        isLast: false, 
      ),
    ];
  }
}