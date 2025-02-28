import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class infoAnimal extends StatelessWidget {
  final screenWidth;
  final screenHeight;

  const infoAnimal({super.key, this.screenWidth, this.screenHeight});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 132, 103),
        toolbarHeight: 70,
        title: Text("Guia de primeros auxilios", style: GoogleFonts.fredoka(color: Colors.white),),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 237, 237, 237),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Image.network(
                              'https://th.bing.com/th/id/OIP.JqwHXqBvB_FRGXtnq1gJQgAAAA?rs=1&pid=ImgDetMain',
                              fit: BoxFit.contain,
                              scale: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: screenHeight *0.5,
                      child: Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(40),
                                    width: screenWidth, // Ancho que ajusta el contenedor
                                    height: screenHeight * 0.5,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50)
                                      ),
                                    ),
                                    child: SingleChildScrollView( // Permite hacer scroll en el contenido cuando sea necesario
                                      child: Column(
                                        children: [
                                          Text(
                                            'Detención de hemorragias \n externas',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredoka(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 26,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2
                                            ),
                                          ),
                                          SizedBox(height: 20), // Espacio entre los textos
                                          Text(
                                            "Las hemorragias externas pueden ocurrir por cortes, raspaduras o heridas abiertas que tu mascota sufra durante un accidente o juego. Saber cómo detener el sangrado de manera rápida y segura es esencial para proteger su vida y evitar complicaciones mayores.",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredoka(color: Colors.black),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            "Paso a paso para detener el sangrado:",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredoka(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                                            
                                          ),
                                          SizedBox(height: 20),  // Espacio entre los textos
                                          Text(
                                            "1. Mantén la calma y evalúa la situación. Verifica la gravedad de la herida y asegúrate de que tanto tú como tu mascota estén seguros antes de actuar. Si tu mascota está muy inquieta, trata de tranquilizarla o pídele ayuda a alguien para sostenerla.",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredoka(color: Colors.black),
                                          ), 
                                          
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
