import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/monitoreoAnimal/indices/actividad.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/monitoreoAnimal/indices/alertas.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/monitoreoAnimal/indices/salud.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/monitoreoAnimal/indices/ubicaci%C3%B3n.dart';
import 'package:proyect_app/screem/home/pageUbicacion/ubicacion.dart';

class monitoreAnimal extends StatefulWidget {
  final screenWidth;
  final screenHeight;
  final mascotaSeleccionadaIdHistorial;
  const monitoreAnimal({super.key, this.screenWidth, this.screenHeight, this.mascotaSeleccionadaIdHistorial});

  @override
  State<monitoreAnimal> createState() => _monitoreAnimalState();
}

class _monitoreAnimalState extends State<monitoreAnimal> {

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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 0, 132, 103),
        toolbarHeight: 70,
        title: Text("Informacion de mi mascota", style: GoogleFonts.fredoka(color: Colors.white)),
      ),
      body: Column(
        children: [
          appSubBar(),
          Expanded(
            child: IndexedStack(
              index: index - 1,
              children: [ 
                salud(mascotaSeleccionadaIdHistorial: widget.mascotaSeleccionadaIdHistorial), 
                Actividad(), 
                UbicacionPet(), 
                alertas(),
              ],
            ),
          )
        ],
      )
    );
  }

  Container appSubBar() {
    return Container(
              alignment: AlignmentDirectional.centerStart,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.10,
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
