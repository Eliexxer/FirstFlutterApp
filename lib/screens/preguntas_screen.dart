import 'package:flutter/material.dart';
import 'package:login_flutter/screens/pruebas_screen.dart';
import 'package:login_flutter/screens/tutoria_screen.dart';
import 'package:login_flutter/widgets/premium_guard_widget.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/screens/respuestas_screen.dart';
import 'package:login_flutter/core/preguntas_y_respuestas_provider.dart';

class PreguntasScreen extends StatefulWidget {
  const PreguntasScreen({super.key});

  @override
  PreguntasScreenState createState() => PreguntasScreenState();
}

class PreguntasScreenState extends State<PreguntasScreen> {
  int _lastFeedCount = 0;
  bool _hayNuevasPreguntas = false;
  bool _isLoadingPreguntas = false;

  // Simula la verificación de nuevas preguntas
  Future<void> checkForNewQuestions() async {
    if (_isLoadingPreguntas) return;
    _isLoadingPreguntas = true;
    final provider = Provider.of<PreguntasProvider>(context, listen: false);
    await provider.cargarPreguntas();
    final currentCount = provider.preguntas.length;
    if (_lastFeedCount != 0 && currentCount > _lastFeedCount) {
      if (mounted) {
        setState(() {
          _hayNuevasPreguntas = true;
        });
      }
    }
    _lastFeedCount = currentCount;
    _isLoadingPreguntas = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  String search = '';
  String selectedSubject = 'Todas';
  final TextEditingController _preguntaController = TextEditingController();
  final TextEditingController _materiaController = TextEditingController();
  final TextEditingController _asuntoController = TextEditingController();
  final List<String> asignaturas = [
    'Todas',
    'Matemática',
    'Historia',
    'Física',
    'Inglés',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadPreguntasSeguro);
    // Chequea cada 10 segundos si hay nuevas preguntas
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      await checkForNewQuestions();
      return true;
    });
  }

  Future<void> _loadPreguntasSeguro() async {
    if (_isLoadingPreguntas) return;
    _isLoadingPreguntas = true;
    await Provider.of<PreguntasProvider>(
      context,
      listen: false,
    ).cargarPreguntas();
    if (!mounted) return;
    setState(() {
      _lastFeedCount =
          Provider.of<PreguntasProvider>(
            context,
            listen: false,
          ).preguntas.length;
    });
    _isLoadingPreguntas = false;
  }

  Future<void> recargarFeed() async {
    if (_isLoadingPreguntas) return;
    _isLoadingPreguntas = true;
    await Provider.of<PreguntasProvider>(
      context,
      listen: false,
    ).cargarPreguntas();
    if (!mounted) return;
    setState(() {});
    _isLoadingPreguntas = false;
  }

  void showNewQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Nueva pregunta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _asuntoController,
                decoration: const InputDecoration(labelText: 'Asunto'),
                maxLines: 2,
              ),
              TextField(
                controller: _preguntaController,
                decoration: const InputDecoration(
                  labelText: 'Pregunta o consulta',
                ),
                maxLines: 2,
              ),
              TextField(
                controller: _materiaController,
                decoration: const InputDecoration(labelText: 'Materia'),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    _preguntaController.clear();
                    _materiaController.clear();
                    _asuntoController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Consumer<PreguntasProvider>(
                  builder:
                      (context, provider, _) => ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                        ),
                        onPressed:
                            provider.cargando
                                ? null
                                : () async {
                                  if (_preguntaController.text.trim().isEmpty ||
                                      _materiaController.text.trim().isEmpty ||
                                      _asuntoController.text.trim().isEmpty) {
                                    return;
                                  }
                                  await provider.agregarPregunta(
                                    titulo:
                                        _asuntoController.text
                                            .trim()
                                            .split('\n')
                                            .first,
                                    fragmento: _preguntaController.text.trim(),
                                    materia: _materiaController.text.trim(),
                                  );
                                  _preguntaController.clear();
                                  _asuntoController.clear();
                                  _materiaController.clear();
                                  Navigator.pop(context);
                                },
                        child:
                            provider.cargando
                                ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Publicar'),
                      ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: [
            SizedBox(width: 15),
            Text(
              'EsTuPrime Community',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PremiumGuard(
                          feature: 'tutoria',
                          child: TutoriaScreen(),
                        ),
                      ),
                    );
                  },
                  icon: Image.asset(
                    'assets/images/Recurso 8.png',
                    width: 28,
                    height: 28,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PremiumGuard(
                          feature: 'pruebas',
                          child: PruebasScreen(),
                        ),
                      ),
                    );
                  },
                  icon: Image.asset(
                    'assets/images/Icons/receipt-alt.png',
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Buscar preguntas o tareas',
                        border: InputBorder.none,
                      ),
                      onChanged: (v) => setState(() => search = v),
                    ),
                  ),
                ],
              ),
            ),
            // Subject filter
            Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: asignaturas.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final subject = asignaturas[i];
                          final selected = selectedSubject == subject;
                          return ChoiceChip(
                            label: Text(subject),
                            selected: selected,
                            onSelected:
                                (_) =>
                                    setState(() => selectedSubject = subject),
                            selectedColor: Colors.deepPurpleAccent,
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black87,
                            ),
                            backgroundColor: Colors.grey[200],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
            // Feed
            Expanded(
              child: Consumer<PreguntasProvider>(
                builder: (context, provider, _) {
                  final preguntas = provider.preguntas;
                  if (provider.cargando) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final filtered =
                      preguntas.where((doc) {
                        final materia =
                            (doc['materia'] ?? '').toString().toLowerCase();
                        final titulo =
                            (doc['titulo'] ?? '').toString().toLowerCase();
                        final fragmento =
                            (doc['fragmento'] ?? '').toString().toLowerCase();
                        final matchesSubject =
                            selectedSubject == 'Todas' ||
                            materia == selectedSubject.toLowerCase();
                        final matchesSearch =
                            search.isEmpty ||
                            titulo.contains(search.toLowerCase()) ||
                            fragmento.contains(search.toLowerCase());
                        return matchesSubject && matchesSearch;
                      }).toList();
                  if (filtered.isEmpty) {
                    return const Center(child: Text('No questions found.'));
                  }
                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      final doc = filtered[index];
                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        RespuestasScreen(preguntaDoc: doc),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc['titulo'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        doc['fragmento'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            doc['materia'] ?? '',
                                            style: const TextStyle(
                                              color: Colors.deepPurpleAccent,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Publicado por ${doc['usuario'] ?? 'Anónimo'}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/Icons/chevron-right.png',
                                  color: Colors.black54,
                                  height: 20,
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}