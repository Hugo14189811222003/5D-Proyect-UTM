import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/models/modeloMascota.dart';
import 'package:proyect_app/screem/home/home.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/historialMedico/historialMedico.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/monitoreoAnimal/monitoreoAnimal.dart';
import 'package:proyect_app/screem/home/pageMascotas/mascota.dart';
import 'package:shared_preferences/shared_preferences.dart';

class historyAnimals extends StatefulWidget {
  final GetMascota mascota;
  final mascotaSeleccionadaIdHistorial;

  const historyAnimals({super.key, required this.mascota, this.mascotaSeleccionadaIdHistorial});

  @override
  State<historyAnimals> createState() => _historyAnimalsState();
}

class _historyAnimalsState extends State<historyAnimals> {
  initState() {
    super.initState();
    ObtenerCurrentIndex();
  }
  int? currentIndex;

  String calcularEdad(DateTime fechaNacimiento) {
  DateTime now = DateTime.now();
  Duration diferencia = now.difference(fechaNacimiento);

  int years = (diferencia.inDays / 365).floor(); // Edad en años
  int months = ((diferencia.inDays % 365) / 30).floor(); // Edad en meses
  int weeks = (diferencia.inDays / 7).floor(); // Edad en semanas

  if (years > 0) {
    return "$years años";
  } else if (months > 0) {
    return "$months meses";
  } else if (weeks > 0) {
    return "$weeks semanas";
  } else {
    return "${diferencia.inDays} días"; // Si es menos de 1 semana
  }
}



  Future<String> obtenerGenero(int mascotaId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('genero_$mascotaId') ?? "Desconocido"; // Si no existe, devuelve "Desconocido"
  }

  Future<void> ObtenerCurrentIndex() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
      String? currentIndexString = pref.getString('currentIndex');
      currentIndex = currentIndexString != null ? int.tryParse(currentIndexString) : null;
      print("current Index usado: ${currentIndex}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 0, 132, 103),
        toolbarHeight: 70,
        title: Text("Informacion de ${widget.mascota.nombre}", style: GoogleFonts.fredoka(color: Colors.white),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: const Color.fromARGB(255, 237, 237, 237)
        ),
        child: Column(
          children: [
            ClipPath(
                clipper: BottomCurveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    image: DecorationImage(
                      image: widget.mascota.imagenURL.isNotEmpty 
                        ? NetworkImage(widget.mascota.imagenURL) 
                        : Icon(Icons.image) as ImageProvider, // Imagen por defecto
                      fit: BoxFit.cover,
                    )
                  ),
                ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(10, 0, 0, 0),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, 0)
                  )
                ]
                
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder: (context, Constraints) {
                      final screenWidthConstrain = Constraints.maxWidth;
                      final screenHeightConstrain = Constraints.maxHeight;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.mascota.nombre, style: GoogleFonts.fredoka(
                            color: Colors.black, 
                            fontSize: screenHeightConstrain * 0.25, 
                            fontWeight: FontWeight.w500)
                          ),
                          Text(widget.mascota.raza, style: GoogleFonts.fredoka(
                            color: const Color.fromARGB(255, 83, 68, 141), 
                            fontSize: screenHeightConstrain * 0.18, 
                            fontWeight: FontWeight.w400)
                          ),
                        ],
                      );
                    }
                  ),
                  Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          color: widget.mascota.genero == "Hembra" ? const Color.fromARGB(255, 245, 118, 173) 
                          : widget.mascota.genero == "Macho" ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                          
                        ),
                        child: Icon(
                          widget.mascota.genero == "Hembra" ? Icons.woman : widget.mascota.genero == "Macho" ? Icons.man : Icons.pets, 
                          color: Colors.white, 
                          size: MediaQuery.of(context).size.width * 0.07
                        ),
                      )
                ],
              ),
            ),
            SizedBox(height: 15,),
            Flexible(
              child: LayoutBuilder(
                builder: (context, Constraints) {
                  final screenWidthConstrain = Constraints.maxWidth;
                  final screenHeightConstrain = Constraints.maxHeight;
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sobre Hera", style: GoogleFonts.fredoka(
                            color: Colors.black, 
                            fontSize: screenWidthConstrain * 0.055, 
                            fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: screenWidthConstrain * 0.2,
                                height: screenHeightConstrain * 0.2,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 218, 208, 252),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Edad", style: GoogleFonts.fredoka(
                                      color: Colors.black, 
                                      fontSize: 17, 
                                      fontWeight: FontWeight.w200
                                      )
                                    ),
                                    Text(widget.mascota.fechaNacimiento, style: GoogleFonts.fredoka(
                                      color: const Color.fromARGB(255, 105, 89, 165), 
                                      fontSize: 12, 
                                      fontWeight: FontWeight.w400
                                      )
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: screenWidthConstrain * 0.2,
                                height: screenHeightConstrain * 0.2,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 218, 208, 252),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Color", style: GoogleFonts.fredoka(
                                      color: Colors.black, 
                                      fontSize: 17, 
                                      fontWeight: FontWeight.w200
                                      )
                                    ),
                                    Text(widget.mascota.color, style: GoogleFonts.fredoka(
                                      color: const Color.fromARGB(255, 105, 89, 165), 
                                      fontSize: 12, 
                                      fontWeight: FontWeight.w400
                                      )
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: screenWidthConstrain * 0.2,
                                height: screenHeightConstrain * 0.2,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 218, 208, 252),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Tamaño", style: GoogleFonts.fredoka(
                                      color: Colors.black, 
                                      fontSize: 17, 
                                      fontWeight: FontWeight.w200
                                      )
                                    ),
                                    Text(widget.mascota.tamano, style: GoogleFonts.fredoka(
                                      color: const Color.fromARGB(255, 105, 89, 165), 
                                      fontSize: 12, 
                                      fontWeight: FontWeight.w400
                                      )
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: screenWidthConstrain * 0.2,
                                height: screenHeightConstrain * 0.2,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 218, 208, 252),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Especie", style: GoogleFonts.fredoka(
                                      color: Colors.black, 
                                      fontSize: 17, 
                                      fontWeight: FontWeight.w200
                                      )
                                    ),
                                    Text(widget.mascota.especie, style: GoogleFonts.fredoka(
                                      color: const Color.fromARGB(255, 105, 89, 165), 
                                      fontSize: 12, 
                                      fontWeight: FontWeight.w400
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeightConstrain * 0.035),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: screenWidthConstrain * 0.8,
                                height: screenHeightConstrain * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.white
                                ),
                                child: Text("Ingrese una mini descripción :)"),
                              ),
                              Icon(Icons.edit, color: const Color.fromARGB(255, 0, 77, 58), size: screenWidthConstrain * 0.05,)
                            ],
                          ),
                          SizedBox(height: screenHeightConstrain * 0.02),
                          Container(
                            width: screenWidthConstrain * 0.55,
                            height: screenHeightConstrain * 0.18,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 169, 211, 193),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Ver historial medico"),
                                GestureDetector(
                                  child: Icon(Icons.arrow_forward),
                                  onTap:() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Historialmedico(mascota: widget.mascota, mascotaSeleccionadaIdHistorial: widget.mascotaSeleccionadaIdHistorial,))
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeightConstrain * 0.02),
                          Container(
                            width: screenWidthConstrain * 0.55,
                            height: screenHeightConstrain * 0.18,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 169, 211, 193),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Ver su monitoreo"),
                                GestureDetector(
                                  child: Icon(Icons.arrow_forward),
                                  onTap:() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => monitoreAnimal(mascotaSeleccionadaIdHistorial: widget.mascota.id,))
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            )
          ],
        ),
      )
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Dibuja una curva hacia abajo en la parte inferior del contenedor
    path.lineTo(0, 0); // Comienza desde la esquina superior izquierda
    path.lineTo(0, size.height - 50); // Línea recta hacia abajo (ajusta el valor de -20)
    path.quadraticBezierTo(
      size.width / 2, size.height, // Control point en la mitad de la base
      size.width, size.height - 20, // Fin de la curva (ajusta el valor de -20)
    );
    path.lineTo(size.width, 0); // Línea recta hasta la esquina superior derecha
    path.close(); // Cierra el path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // No necesitamos reclippear si no cambian las propiedades
  }
}
