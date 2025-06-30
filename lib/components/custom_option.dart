import 'package:flutter/material.dart';

Widget customOption(
    String text,
    String assetImage1,
    String assetImage2,
    onTap,
  ) {
    //var he = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          children: [
            Image.asset(assetImage1),
            SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'MiFuente',
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            Expanded(child: Container()),
            Image.asset(assetImage2, color: Colors.black, height: 18, width: 18,),
          ],
        ),
      ),
    );
  }