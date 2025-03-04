import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class alertas extends StatelessWidget {
  const alertas({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWight = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: screenWight,
        height: screenHeight,
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          children: [
            Text(
              "Alertas",
              style: GoogleFonts.fredoka(
                color: Colors.black,
                fontSize: screenWight * 0.05,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: screenHeight * 0.05,),
            Column(
              children: [
                Container(
                  width: screenWight * 0.8,
                  height: screenHeight * 0.15,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.red,
                      width: 3
                    )
                  ),
                  child: Row(
                    
                    children: [
                      SizedBox(width: screenWight * 0.05,),
                      Icon(Icons.error, color: Colors.red, size: screenHeight * 0.07,),
                      SizedBox(width: screenWight * 0.05,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Respiración baja", style: GoogleFonts.fredoka(
                            color: const Color.fromARGB(255, 0, 77, 58),
                            fontSize: 18
                            )),
                          SizedBox(height: screenHeight * 0.01,),
                          Row(
                            children: [
                              Icon(Icons.access_time, color: const Color.fromARGB(255, 0, 77, 58),),
                              SizedBox(width: screenWight * 0.03,),
                              Text("14/01/25", style: GoogleFonts.fredoka(
                                color: const Color.fromARGB(255, 0, 77, 58),
                              )),
                              SizedBox(width: screenWight * 0.03,),
                              Text("13:45", style: GoogleFonts.fredoka(
                                color: const Color.fromARGB(255, 0, 77, 58),
                              )),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.01,),
                          GestureDetector(
                            onTap: () {
                              print("detalles de alerta");
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: screenHeight * 0.09,
                              height: screenHeight * 0.04,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color.fromARGB(255, 204, 196, 255)
                              ),
                              child: Text("Detalle", textAlign: TextAlign.center ,style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 83, 68, 141))),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}