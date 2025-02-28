import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Ubicacion extends StatefulWidget {
  final double? screenWidth;
  final double? screenHeight;

  const Ubicacion({super.key, this.screenWidth, this.screenHeight});

  @override
  State<Ubicacion> createState() => _UbicacionState();
}

class _UbicacionState extends State<Ubicacion> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- MAPA EN EL FONDO ---
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(20.9674, -89.5926), // CDMX
                initialZoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://api.maptiler.com/maps/streets-v2/256/{z}/{x}/{y}.png?key=SXOKGRbZzww6ECQWY16G',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(19.4326, -99.1332), // CDMX
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- CONTENEDOR FLOTANTE ---
          Positioned(
            bottom: 30, // Ajusta la distancia desde la parte inferior
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 3,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Zoovet",
                    style: GoogleFonts.fredoka(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(
                        "5.0 ",
                        style: GoogleFonts.fredoka(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < 5 ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: const Color.fromARGB(255, 0, 77, 58),),
                      SizedBox(width: 10,),
                      Text(
                        "C. 73 527, Centro, 97000 Mérida, Yuc.",
                        style: GoogleFonts.fredoka(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: const Color.fromARGB(255, 0, 77, 58)),
                      SizedBox(width: 10,),
                      Text(
                        "Abierto - Cierra a las 7 PM",
                        style: GoogleFonts.fredoka(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
