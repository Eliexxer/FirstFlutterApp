import 'package:flutter/material.dart';

class GoPremium extends StatefulWidget {
  const GoPremium({super.key});

  @override
  State<GoPremium> createState() => _GoPremiumState();
}

class _GoPremiumState extends State<GoPremium> {
  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(he * 0.004),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(he * 0.02),
            gradient: const LinearGradient(
              colors: [Color(0xffFDC830), Color(0XFFf37335)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(he * 0.02),
              color: Colors.transparent,
            ),
            padding: EdgeInsets.all(he * 0.012),
            child: Row(
              children: [
                Container(
                  height: he * 0.06,
                  width: he * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(he * 0.02),
                    color: Colors.transparent,//const Color(0xffFDC830),//Colors.deepPurpleAccent.shade400,
                  ),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Color.fromARGB(102, 228, 221, 221),
                      BlendMode.srcATop,
                    ),
                    child: Image.asset('assets/images/Recurso 8.png', height: 24, width: 24, color: Colors.black),//Colors.white,)
                  ),
                ),
                SizedBox(width: he * 0.035),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '¡Vuélvete Premium!',
                        style: TextStyle(
                          color: Colors.black,//Color.fromARGB(255, 22, 23, 22),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'MiFuente',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Consigue acceso a nuestra comunidad de profesionales y nuestros recursos de estudio ilimitados',
                        style: TextStyle(
                          color: Colors.black,//Colors.grey[800],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'MiFuente',
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/images/Icons/chevron-right.png',
                    width: 24,
                    height: 24,
                    color: Colors.black//const Color(0xffFDC830), // mismo color que el gradiente
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
