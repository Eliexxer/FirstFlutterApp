import 'package:flutter/material.dart';

class CustomImageSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomImageSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomImageSwitch> createState() => _CustomImageSwitchState();
}

class _CustomImageSwitchState extends State<CustomImageSwitch> {
  void _toggleSwitch() {
    widget.onChanged(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSwitch,
      child: Image.asset(
        widget.value
            ? 'assets/images/State=On.png'   // Pon aquí la ruta de tu imagen "on"
            : 'assets/images/State=Off.png', // Pon aquí la ruta de tu imagen "off"
        width: 40, // Ajusta el tamaño si lo deseas
        height: 30,
      ),
    );
  }
}