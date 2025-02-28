import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class monitoreo extends StatefulWidget {
  final screenWidth;
  final screenHeight;

  const monitoreo({super.key, this.screenWidth, this.screenHeight});

  @override
  State<monitoreo> createState() => _monitoreoState();
}

class _monitoreoState extends State<monitoreo> {

  int index = 1;

  Future<void> cambiodecolor(int indexcambio) async {
    if(indexcambio == 1){
      setState(() {
        index = 1;
      });
    } else if(indexcambio == 2){
      setState(() {
        index = 2;
      });
    } else if(indexcambio == 3){
      setState(() {
        index = 3;
      });
    } else if(indexcambio == 4){
      setState(() {
        index = 4;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 237, 237, 237),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appSubBar(),
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
                        height: widget.screenHeight * 0.08,
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
        )
    );
  }

  Container appSubBar() {
    return Container(
              alignment: AlignmentDirectional.centerStart,
              width: double.infinity,
              height: widget.screenHeight * 0.10,
              decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border:Border(
                            bottom: BorderSide(
                              color: index == 1 ? const Color.fromARGB(255, 83, 68, 141) : Colors.transparent,
                              width: 5.0,
                            )
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),  
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Salud",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(color: index == 1 ? Color.fromARGB(255, 83, 68, 141) : Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () => cambiodecolor(1),
                    ),
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border:Border(
                            bottom: BorderSide(
                              color: index == 2 ? const Color.fromARGB(255, 83, 68, 141) : Colors.transparent,
                              width: 5.0
                            )
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),  
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Actividad",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(color: index == 2 ? Color.fromARGB(255, 83, 68, 141) : Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () => cambiodecolor(2),
                    ),
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border:Border(
                            bottom: BorderSide(
                              color: index == 3 ? const Color.fromARGB(255, 83, 68, 141) : Colors.transparent,
                              width: 5.0
                            )
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),  
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Ubicación",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(color: index == 3 ? Color.fromARGB(255, 83, 68, 141) : Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () => cambiodecolor(3),
                    ),
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border:Border(
                            bottom: BorderSide(
                              color: index == 4 ? const Color.fromARGB(255, 83, 68, 141) : Colors.transparent,
                              width: 5.0
                            )
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),  
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Alertas",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(color: index == 4 ? Color.fromARGB(255, 83, 68, 141) : Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () => cambiodecolor(4),
                    ),
                  ],
                ),
              ),
            );
  }
}
