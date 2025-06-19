import 'package:flutter/material.dart';

Widget customText(String text, double size){
  return Text(
    text, style: TextStyle(
      fontSize: size,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  );
}