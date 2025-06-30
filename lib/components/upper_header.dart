import 'package:flutter/material.dart';
import 'custom_text.dart';

Widget upperHeader(
  String text,
  BuildContext context,
  bool isIcon, {
  required Widget page,
  Widget? trailing, // <-- Nuevo parámetro opcional
}) {
  var he = MediaQuery.of(context).size.height;

  return Padding(
    padding: EdgeInsets.only(top: he * 0.03, right: he * 0.02),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Icon(Icons.arrow_back_rounded, color: Colors.black, size: 30),
        ),
        SizedBox(width: he * 0.03),
        Expanded(
          flex: 6,
          child: customText(
            text,
            28,
            maxLines: 2,
          ),
        ),
        Expanded(child: Container()),
        isIcon
            ? Icon(Icons.search, color: Colors.black, size: 30)
            : Container(),
        if (trailing != null) ...[
          SizedBox(width: 8),
          trailing,
        ],
      ],
    ),
  );
}
