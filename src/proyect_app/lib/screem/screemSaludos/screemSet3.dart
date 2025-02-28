import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/screem/screemSaludos/circleScreem/circle3Animals.dart';
import 'package:proyect_app/screem/screemSaludos/circleScreem/circleDog.dart';
import 'package:proyect_app/screem/screemSaludos/circleScreem/circle2Cat.dart';

class set3 extends StatelessWidget {
  const set3({super.key});

  @override
  Widget build(BuildContext context) {
    final String TextInfo = 'Porque tus mascotas merecen lo mejor, en todo momento.';
    final screemWidth = MediaQuery.of(context).size.width;
    final screemHeight = MediaQuery.of(context).size.height;
    final ScreemVolteado = screemWidth > screemHeight;

    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final widththisContainer = constraints.maxWidth;
              final heightthisContainer = constraints.maxHeight;
                return Container(
                height: screemHeight,
                width: screemWidth,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Circle3(
                  width: widththisContainer,
                  height: heightthisContainer,
                )
              );
            },
          ),
          Positioned(
            bottom: screemHeight * -0.1,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(70),
                topRight: Radius.circular(70)
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenContainerPurpe = constraints.maxHeight;
                  return Container(
                    height: screemHeight * 0.60,
                    color: const Color.fromARGB(255, 117, 106, 186),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: screemHeight * 0.04),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0),
                                child: Text('☺', style: GoogleFonts.anton(color: Colors.white, fontSize: 50),),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: ScreemVolteado ? 20.0 : 50.0),
                                child: Text(TextInfo, style: GoogleFonts.fredoka(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,)
                              ),
                              SizedBox(height: 40,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 204, 196, 255),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                    )
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 40),
                                    child: Text('Inicia sesión', style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 83, 68, 141), fontSize: 18),),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context, "login");
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 170, 212, 194),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                    )
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 40),
                                    child: Text('Crear cuenta', style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 77, 58), fontSize: 18),),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context, "register");
                                  },
                                ),
                              ),    
                            ],
                          ),
                        )               
                      ],
                    ),
                  );
                },
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}