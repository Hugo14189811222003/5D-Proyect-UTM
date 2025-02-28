import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Historialmedico extends StatelessWidget {
  const Historialmedico({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 0, 132, 103),
          toolbarHeight: 70,
          title: Text("historial Medico", style: GoogleFonts.fredoka(color: Colors.white),),
        ),
        body: Container(
          decoration: const BoxDecoration(color: Color.fromARGB(255, 237, 237, 237)),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidthConnstrain = constraints.maxWidth;
                    final screenHeightConstrain = constraints.maxHeight;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04, 
                        vertical: MediaQuery.of(context).size.height * 0.03
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Vacunas", 
                              style: GoogleFonts.fredoka(
                                color: Colors.black, 
                                fontSize: 20, fontWeight: 
                                FontWeight.w500)
                              ),
                              Row(
                                children: [
                                  Text("Ver todo", 
                                  style: GoogleFonts.fredoka(
                                    color: const Color.fromARGB(255, 83, 68, 141),
                                    fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  SizedBox(width: screenWidthConnstrain * 0.025,),
                                  GestureDetector(
                                    onTap: () {
                                      
                                    },
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Color.fromARGB(255, 83, 68, 141),
                                      ),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Flexible(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final screenWidthConstrain2 = constraints.maxWidth;
                                final screenHHeightConstrain2 = constraints.maxHeight;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: screenWidthConstrain2 * 0.4,
                                      height: screenHHeightConstrain2 * 0.5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(17, 0, 0, 0),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                            offset: Offset(0, 5)
                                          )
                                        ]
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Vacuna contra la rabia",
                                          style: GoogleFonts.fredoka(
                                              color: Colors.black,
                                              fontSize: screenWidthConstrain2 * 0.030,
                                              fontWeight: FontWeight.w500
                                            ),
                                          ),
                                          Text("24 Enero 2023",
                                          style: GoogleFonts.fredoka(
                                              color: Colors.black,
                                              fontSize: screenWidthConstrain2 * 0.030,
                                              fontWeight: FontWeight.w300
                                            ),
                                          ),
                                          Text("Dr. Gabriel",
                                          style: GoogleFonts.fredoka(
                                              color: Colors.black,
                                              fontSize: screenWidthConstrain2 * 0.035,
                                              fontWeight: FontWeight.w300
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: screenWidthConstrain2 * 0.4,
                                      height: screenHHeightConstrain2 * 0.5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(17, 0, 0, 0),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                            offset: Offset(0, 5)
                                          )
                                        ]
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Calicivirus",
                                          style: GoogleFonts.fredoka(
                                              color: Colors.black,
                                              fontSize: screenWidthConstrain2 * 0.035,
                                              fontWeight: FontWeight.w500
                                            ),
                                          ),
                                          Text("12 Febrero 2023",
                                          style: GoogleFonts.fredoka(
                                              color: Colors.black,
                                              fontSize: screenWidthConstrain2 * 0.035,
                                              fontWeight: FontWeight.w300
                                            ),
                                          ),
                                          Text("Dr. Gabriel",
                                          style: GoogleFonts.fredoka(
                                              color: Colors.black,
                                              fontSize: screenWidthConstrain2 * 0.035,
                                              fontWeight: FontWeight.w300
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text("dsd")
                        ],
                      ),
                    );
                  },
                ),
            ],
          )
      )
    );
  }
}