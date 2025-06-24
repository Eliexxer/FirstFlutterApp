import 'package:flutter/material.dart';
//import 'package:login_flutter/widgets/custom_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_flutter/screens/menuscreen.dart';
import 'package:login_flutter/screens/profilescreen.dart';
import 'package:login_flutter/widgets/premium.dart';
import 'package:login_flutter/widgets/tareas.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = [MainHomeScreen(), ProfileScreen()];
  int activeIndex = 0;
  String? genero;
  String? nombre;
  String? apellido;
  String? carrera;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDatosUsuario();
  }

  Future<void> _loadDatosUsuario() async {
    setState(() {
      isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final query =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .where('correo', isEqualTo: user.email)
              .limit(1)
              .get();
      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        setState(() {
          genero = /*query.docs.first*/ doc['genero'] as String?;
          nombre = doc['nombre'] as String?;
          apellido = doc['apellido'] as String?;
          carrera = doc['carrera'] as String?;
          isLoading = false;
        });
      } else {
        setState(() {
          genero = null;
          nombre = null;
          apellido = null;
          carrera = null;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
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
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
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
              backgroundColor: const Color.fromARGB(255, 228, 221, 221),
              selectedItemColor: Colors.black87,
              unselectedItemColor: Colors.black87,
              unselectedLabelStyle: TextStyle(
                fontFamily: 'MiFuente',
                fontWeight: FontWeight.w300,
                //fontSize: 16,
              ),
              selectedLabelStyle: TextStyle(
                fontFamily: 'MiFuente',
                //fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              currentIndex: activeIndex, // <-- Usa la variable de estado
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/Icons/home-alt.png',
                    height: 30,
                    width: 30,
                  ),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/Icons/user.png',
                    height: 30,
                    width: 30,
                  ),
                  label: 'Perfil',
                ),
              ],
              onTap: (index) {
                setState(() {
                  activeIndex = index;
                });
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.black87,
          child: Image.asset(
            'assets/images/Icons/plus.png',
            width: 40,
            height: 40,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.black, backgroundColor: Colors.black45,))
            : _pages[activeIndex],
      ),
    );
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
          child: GoPremium(),
        ),
        Container(
          padding: EdgeInsets.all(15),
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
        //Tareas(),
      ],
    );
  }
}
