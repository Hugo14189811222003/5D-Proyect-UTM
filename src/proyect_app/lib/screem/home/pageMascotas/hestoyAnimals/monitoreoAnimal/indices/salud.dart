import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class salud extends StatelessWidget {
  const salud({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 237, 237, 237),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                margin: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 25,
                  children: [
                    Text("Temperatura", style: GoogleFonts.fredoka(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),),
                    const ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.center,
                      collapsedTextColor: Color.fromARGB(255, 0, 77, 58),
                      collapsedBackgroundColor: Color.fromARGB(255, 170, 212, 194),
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none
                      ),
                      backgroundColor: Color.fromARGB(255, 170, 212, 194),
                        title: Text("Día",),
                        children: [
                          ListTile(
                            title: Text('Día'),
                          ),
                          ListTile(
                            title: Text('Semana'),
                          ),
                          ListTile(
                            title: Text('Mes'),
                          ),
                          ListTile(
                            title: Text('Año'),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [BoxShadow(
                            color: const Color.fromARGB(18, 0, 0, 0),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: Offset(0, 0)
                          )]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.arrow_back, size: 30,),
                            Text('Hoy', style: GoogleFonts.fredoka(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),),
                            Icon(Icons.arrow_forward, size: 30,)
                          ],
                        ),
                        
                      )
                  ],
                ),
              ),

            ],
          ),
        ),
    );
  }
}