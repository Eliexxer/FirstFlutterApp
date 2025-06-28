import 'package:flutter/material.dart';
import 'package:login_flutter/screens/menuscreen.dart';
import 'package:login_flutter/screens/profilescreen.dart';
import 'package:login_flutter/screens/preguntas_screen.dart';
import 'package:login_flutter/widgets/premium.dart';
import 'package:login_flutter/widgets/tareas.dart';
import 'package:login_flutter/screens/registrar_asignatura_screen.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/core/usuario_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<PreguntasScreenState> _tutoriaKey =
      GlobalKey<PreguntasScreenState>();
  late final List<Widget> _pages;
  int activeIndex = 1;
  String? genero;
  String? nombre;
  String? apellido;
  String? carrera;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pages = [
      PreguntasScreen(key: _tutoriaKey),
      MainHomeScreen(),
      ProfileScreen(),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDatosUsuarioProvider();
    });
  }

  bool _isLoadingUser = false;
  Future<void> _loadDatosUsuarioProvider() async {
    if (_isLoadingUser) return;
    _isLoadingUser = true;
    final usuarioProvider = Provider.of<UsuarioProvider>(
      context,
      listen: false,
    );
    setState(() {
      isLoading = true;
    });
    await usuarioProvider.cargarDatosUsuario();
    setState(() {
      genero = usuarioProvider.genero;
      nombre = usuarioProvider.nombre;
      apellido = usuarioProvider.apellido;
      carrera = usuarioProvider.carrera;
      isLoading = false;
    });
    _isLoadingUser = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F8FA),
        appBar:
            activeIndex == 0
                ? null
                : AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Row(
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        margin: EdgeInsets.only(left: 10, top: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            genero == 'Femenino'
                                ? 'assets/images/mujer1.png'
                                : genero == 'Masculino'
                                ? 'assets/images/hombre3.png'
                                : 'assets/images/hombre3.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Text(
                        isLoading
                            ? 'Cargando...'
                            : 'Hola${nombre != null ? ', $nombre $apellido' : ', '}',
                        style: const TextStyle(
                          fontFamily: 'MiFuente',
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset('assets/images/Icons/edit.png', color: Colors.black,),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MenuScreen()),
                        );
                      },
                      icon: Image.asset(
                        'assets/images/Icons/Menu.png',
                        width: 28,
                        height: 28,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              showSelectedLabels: true,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black87,
              unselectedItemColor: Colors.black87,
              unselectedLabelStyle: TextStyle(
                fontFamily: 'MiFuente',
                fontWeight: FontWeight.w300,
              ),
              selectedLabelStyle: TextStyle(
                fontFamily: 'MiFuente',
                fontWeight: FontWeight.w600,
              ),
              currentIndex: activeIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/Recurso 2.png',
                    height: 30,
                    width: 30,
                    color: Colors.black,
                  ),
                  label: 'Tutorías',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/Icons/home-alt.png',
                    height: 30,
                    width: 30,
                    color: Colors.black,
                  ),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/Icons/user.png',
                    height: 30,
                    width: 30,
                    color: Colors.black,
                  ),
                  label: 'Perfil',
                ),
              ],
              onTap: (index) async {
                setState(() {
                  activeIndex = index;
                });
                // Solo recarga si no está cargando y solo si es perfil
                if (index == 2 && !_isLoadingUser) {
                  await _loadDatosUsuarioProvider();
                }
              },
            ),
          ),
        ),
        floatingActionButton: _buildFAB(context),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        body:
            isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    backgroundColor: Colors.black45,
                  ),
                )
                : _pages[activeIndex],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    if (activeIndex == 2) return SizedBox.shrink();
    if (activeIndex == 0) {
      return FloatingActionButton(
        onPressed: () {
          _tutoriaKey.currentState?.showNewQuestionDialog();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.black87,
        child: Image.asset(
          'assets/images/Icons/plus.png',
          width: 40,
          height: 40,
        ),
      );
    }
    if (activeIndex == 1) {
      return FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistrarAsignaturaScreen(),
            ),
          );
          if (result == true) {
            setState(() {});
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.black87,
        child: Image.asset(
          'assets/images/Icons/plus.png',
          width: 40,
          height: 40,
        ),
      );
    }
    return SizedBox.shrink();
  }
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
            left: 8.0,
            top: 20,
            bottom: 20,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GoPremium(),
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          child: Center(
            child: Text(
              'Tareas pendientes',
              style: TextStyle(
                fontFamily: 'MiFuente',
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
        Expanded(child: Tareas()),
      ],
    );
  }
}
