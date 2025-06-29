import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/core/preguntas_y_respuestas_provider.dart';

class RespuestasScreen extends StatefulWidget {
  final Map<String, dynamic> preguntaDoc;
  RespuestasScreen({Key? key, required this.preguntaDoc}) : super(key: key);

  @override
  _RespuestasScreenState createState() => _RespuestasScreenState();
}

class _RespuestasScreenState extends State<RespuestasScreen> {
  final TextEditingController _respuestaController = TextEditingController();
  bool _enviando = false;
  late PreguntasProvider _provider;
  late String _preguntaId;
  List<Map<String, dynamic>> _respuestas = [];
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<PreguntasProvider>(context, listen: false);
    _preguntaId = widget.preguntaDoc['id'];
    _updateRespuestas();
    // Listener para cambios en el provider
    _listener = () {
      _updateRespuestas();
    };
    _provider.addListener(_listener);
  }

  void _updateRespuestas() {
    final pregunta = _provider.getPreguntaById(_preguntaId);
    if (pregunta != null && mounted) {
      setState(() {
        _respuestas = List<Map<String, dynamic>>.from(pregunta['respuestas'] ?? []);
        // También actualiza el doc local para mantener consistencia
        widget.preguntaDoc['respuestas'] = _respuestas;
      });
    }
  }

  @override
  void dispose() {
    _provider.removeListener(_listener);
    _respuestaController.dispose();
    super.dispose();
  }

  Future<void> _enviarRespuesta() async {
    if (_respuestaController.text.trim().isEmpty) return;
    setState(() => _enviando = true);
    await _provider.agregarRespuesta(
      preguntaId: _preguntaId,
      respuesta: _respuestaController.text.trim(),
    );
    _respuestaController.clear();
    setState(() => _enviando = false);
    // _updateRespuestas se llamará automáticamente por el listener
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.preguntaDoc;
    final respuestas = _respuestas;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregunta'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F8FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pregunta principal
            Text(
              data['titulo'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              data['fragmento'] ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  (data['materia'] ?? ''),
                  style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
                Text(
                  'por ${data['usuario'] ?? 'Anónimo'}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            const Divider(height: 30),
            const Text('Respuestas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: respuestas.isEmpty
                  ? const Center(child: Text('Aún no hay respuestas.'))
                  : ListView.separated(
                      itemCount: respuestas.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final r = respuestas[i];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              child: Text((r['usuario'] ?? '?')[0].toUpperCase()),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r['usuario'] ?? 'Anónimo',
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    r['respuesta'] ?? '',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  if (r['timestamp'] != null)
                                    Text(
                                      _formatoFecha(r['timestamp']),
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _respuestaController,
                    decoration: const InputDecoration(
                      hintText: 'Añade un comentario...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 8),
                _enviando
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : IconButton(
                        icon: const Icon(Icons.send, color: Colors.black),
                        onPressed: _enviarRespuesta,
                      ),
              ],
            ),
            SizedBox(height: 25,)
          ],
        ),
      ),
    );
  }

  String _formatoFecha(dynamic timestamp) {
    if (timestamp is DateTime) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (timestamp is String) {
      return timestamp;
    }
    return '';
  }
}
