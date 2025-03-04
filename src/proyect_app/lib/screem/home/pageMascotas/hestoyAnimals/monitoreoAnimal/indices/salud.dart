import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/screem/home/porcentaje/circlePorcentaje.dart';
import 'package:proyect_app/screem/home/porcentaje/circlePorcentaje1.dart';
import 'package:proyect_app/screem/home/porcentaje/circlePorcentaje2.dart';

class salud extends StatelessWidget {
  const salud({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 237, 237, 237),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    temperatura(),
                    pulso(),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    respiracion()
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Padding respiracion() {
    return Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: LayoutBuilder(
                builder: (context, Constraints) {
                  final screenConstrainWight = Constraints.maxWidth;
                  final screenConstrainHeight = Constraints.maxHeight;
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.29,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Text("Respiración",
                          style: GoogleFonts.fredoka(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: MediaQuery.of(context).size.width * 0.035
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: circlePorce2(),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          GestureDetector(
                            onTap: () {
                              print("detalles de respiración");
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              width: screenConstrainWight * 0.5,
                              height: screenConstrainHeight * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 204, 196, 255)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                "Detalles", 
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredoka(
                                    color: const Color.fromARGB(255, 83, 68, 141),
                                  )
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              ),
            );
  }

  Padding pulso() {
    return Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: LayoutBuilder(
                builder: (context, Constraints) {
                  final screenConstrainWight = Constraints.maxWidth;
                  final screenConstrainHeight = Constraints.maxHeight;
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.29,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Text("Pulso",
                          style: GoogleFonts.fredoka(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: MediaQuery.of(context).size.width * 0.035
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: circlePorce1(),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          GestureDetector(
                            onTap: () {
                              print("detalles de pulso");
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              width: screenConstrainWight * 0.5,
                              height: screenConstrainHeight * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 204, 196, 255)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                "Detalles", 
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredoka(
                                    color: const Color.fromARGB(255, 83, 68, 141),
                                  )
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              ),
            );
  }

  Padding temperatura() {
    return Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: LayoutBuilder(
                builder: (context, Constraints) {
                  final screenConstrainWight = Constraints.maxWidth;
                  final screenConstrainHeight = Constraints.maxHeight;
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.29,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Text("Temperatura",
                          style: GoogleFonts.fredoka(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: MediaQuery.of(context).size.width * 0.035
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: circlePorce(),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          GestureDetector(
                            onTap: () {
                              print("detalles de temperatura");
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              width: screenConstrainWight * 0.5,
                              height: screenConstrainHeight * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 204, 196, 255)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                "Detalles", 
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredoka(
                                    color: const Color.fromARGB(255, 83, 68, 141),
                                  )
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              ),
            );
  }
}