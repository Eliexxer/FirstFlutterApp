import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateOfBirthField extends StatefulWidget {
  final void Function(DateTime fechaNacimiento, int edad) onValidDate;
  final bool? enabled;
  final DateTime? initialDate; // <-- Nuevo parámetro

  const DateOfBirthField({
    super.key,
    required this.onValidDate,
    this.enabled,
    this.initialDate, // <-- Nuevo parámetro
  });

  @override
  State<DateOfBirthField> createState() => _DateOfBirthFieldState();
}

class _DateOfBirthFieldState extends State<DateOfBirthField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _fechaNacimiento;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    // Si hay una fecha inicial, muéstrala en el campo
    if (widget.initialDate != null) {
      _fechaNacimiento = widget.initialDate;
      _controller.text = DateFormat('dd/MM/yyyy').format(widget.initialDate!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(DateTime.now().year - 12),
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
      enabled: widget.enabled,
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        label: Text(
          'Fecha de nacimiento',
          style: TextStyle(fontFamily: 'MiFuente'),
        ),
        hintText: widget.initialDate != null
            ? DateFormat('dd/MM/yyyy').format(widget.initialDate!)
            : 'Selecciona tu fecha de nacimiento',
        hintStyle: const TextStyle(
          fontFamily: 'MiFuente',
          color: Colors.black26,
        ),
        errorText: _errorText,
        suffixIcon: Image.asset(
          'assets/images/Icons/calendar-alt.png',
          color: Colors.black54,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black87,
            width: 5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: widget.enabled! ? () async {
        await _selectDate(context);
      } : null,
      validator: _validator,
      onChanged: (value) {
        setState(() {
          _errorText = _validator(value);
        });
      },
    );
  }
}
