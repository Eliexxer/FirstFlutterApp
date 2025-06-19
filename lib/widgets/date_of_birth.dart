import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateOfBirthField extends StatefulWidget {
  final void Function(DateTime fechaNacimiento, int edad) onValidDate;

  const DateOfBirthField({super.key, required this.onValidDate});

  @override
  State<DateOfBirthField> createState() => _DateOfBirthFieldState();
}

class _DateOfBirthFieldState extends State<DateOfBirthField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _fechaNacimiento;
  String? _errorText;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 12),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      //locale: const Locale('es'),
    );
    if (picked != null) {
      setState(() {
        _fechaNacimiento = picked;
        _controller.text = DateFormat('dd/MM/yyyy').format(picked);
        _errorText = null;
      });
      final edad = _calcularEdad(picked);
      widget.onValidDate(picked, edad);
    }
  }

  int _calcularEdad(DateTime fecha) {
    final hoy = DateTime.now();
    int edad = hoy.year - fecha.year;
    if (hoy.month < fecha.month ||
        (hoy.month == fecha.month && hoy.day < fecha.day)) {
      edad--;
    }
    return edad;
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'La fecha de nacimiento es obligatoria';
    }
    if (_fechaNacimiento == null) {
      return 'Selecciona una fecha válida';
    }
    final edad = _calcularEdad(_fechaNacimiento!);
    if (edad < 12) {
      return 'Debes tener al menos 12 años';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        label: Text(
          'Fecha de nacimiento',
          style: TextStyle(fontFamily: 'MiFuente'),
        ),
        hintText: 'Selecciona tu fecha de nacimiento',
        hintStyle: const TextStyle(
          fontFamily: 'MiFuente',
          color: Colors.black26,
        ),
        errorText: _errorText,
        suffixIcon: Image.asset(
          'assets/images/Icons/calendar-alt.png',
          color: Colors.black54,
        ), // const Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
          color: Colors.black87,
          width: 5,
        ),
        borderRadius: BorderRadius.circular(10),
        )
      ),
      onTap: () async {
        await _selectDate(context);
      },
      validator: _validator,
      onChanged: (value) {
        setState(() {
          _errorText = _validator(value);
        });
      },
    );
  }
}
