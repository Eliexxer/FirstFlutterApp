import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    this.child,
    this.background,
    this.appBar, // Nuevo parámetro
  });

  final Widget? child;
  final Widget? background;
  final PreferredSizeWidget? appBar; // Nuevo parámetro

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(backgroundColor: Colors.transparent, elevation: 0,),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          background ?? Container(color: Colors.black87),
          SafeArea(child: child!),
        ],
      ),
    );
  }
}
