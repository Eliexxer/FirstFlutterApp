import 'package:flutter/material.dart';

Widget customText(String text, double size, {int? maxLines, TextOverflow? overflow}) {
  return Text(
    text,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      fontFamily: 'MiFuente',
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}