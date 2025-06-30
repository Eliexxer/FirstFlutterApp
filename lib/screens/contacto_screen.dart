import 'package:flutter/material.dart';
import 'package:login_flutter/components/custom_option.dart';
import 'package:login_flutter/components/upper_header.dart';
import 'package:login_flutter/screens/menuscreen.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactoScreen extends StatefulWidget {
  const ContactoScreen({super.key});

  @override
  State<ContactoScreen> createState() => _ContactoScreenState();
}

class _ContactoScreenState extends State<ContactoScreen> {
  Future<void> _enviarCorreo(String? subjectBody) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'estuapp.oficial@gmail.com', // Cambia por tu correo real
      query: subjectBody,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No se pudo abrir el correo.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(left: he * 0.03, right: he * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              upperHeader(
                'Contáctanos',
                context,
                false,
                page: const MenuScreen(),
                trailing: Image.asset(
                  'assets/images/Icons/construction-worker.png',
                  height: 28,
                  width: 28,
                ),
              ),
              SizedBox(height: he * 0.023),
              Text(
                '''Nuestro equipo está disponible para atender cualquier consulta relacionada con el uso de la aplicación.  Puedes comunicarte con nosotros a través de los canales oficiales disponibles:
''',
                style: TextStyle(
                  color: Colors.black87,
                  fontFamily: 'MiFuente',
                  fontSize: 18,
                ),
              ),
              customOption(
                'Reporta un problema',
                'assets/images/Icons/bug.png',
                'assets/images/Icons/chevron-right.png',
                () => _enviarCorreo(
                  'subject=Error en la aplicación&body=Escribe aquí el problema y descríbelo',
                ),
              ),
              customOption(
                'Hacer una petición',
                'assets/images/Icons/mailbox.png',
                'assets/images/Icons/chevron-right.png',
                () => _enviarCorreo(
                  'subject=Recomendación o Petición&body=Escribe aquí tu petición o lo que tengas que decirnos ¡Te Escuchamos!',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
