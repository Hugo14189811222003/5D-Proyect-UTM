import 'dart:async';
import 'dart:convert'; // Import necesario para `jsonDecode`
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; // Import necesario para `http.get`

class UbicacionPet extends StatefulWidget {
  const UbicacionPet({super.key});

  @override
  State<UbicacionPet> createState() => _UbicacionPetState();
}

class _UbicacionPetState extends State<UbicacionPet> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  final TextEditingController _searchController = TextEditingController();

  static const double searchRadius = 2000;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.966430466971097, -89.588418379426),
    zoom: 14.5,
  );

  // Reemplaza con tu API Key de Google Maps
  static const String apiKey = "TU_API_KEY_AQUI";

  Future<Position> _getPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error("Permiso denegado permanentemente");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  // Ajusta la cámara para mostrar un área alrededor del usuario
  Future<void> adjustCameraToRadius(LatLng center, double radius) async {
    final GoogleMapController controller = await _controller.future;
    double latOffset = radius / 111000; // 1° de latitud ≈ 111 km
    double lngOffset = radius / (111000 * (1 / 0.000621371));

    LatLng southwest = LatLng(center.latitude - latOffset, center.longitude - lngOffset);
    LatLng northeast = LatLng(center.latitude + latOffset, center.longitude + lngOffset);

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(LatLngBounds(southwest: southwest, northeast: northeast), 165),
    );
  }

  // Obtiene la ubicación actual del usuario y busca veterinarias cercanas
  void getCurrentLocation() async {
    try {
      Position position = await _getPermission();
      LatLng myPosition = LatLng(position.latitude, position.longitude);

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(myPosition, 15));

      setState(() {
        _markers.clear();
        _circles.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId("ubicacion_usuario"),
            position: myPosition,
            infoWindow: const InfoWindow(title: "Tu ubicación"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );
        _circles.add(
          Circle(
            circleId: const CircleId("radio_busqueda"),
            center: myPosition,
            radius: searchRadius,
            strokeColor: Colors.blueAccent.withOpacity(0.5),
            strokeWidth: 2,
            fillColor: Colors.blue.withOpacity(0.2),
          ),
        );
      });

      adjustCameraToRadius(myPosition, searchRadius);

      buscarVeterinarias(myPosition);
    } catch (e) {
      print("Error obteniendo la ubicación: $e");
    }
  }

  // Búsqueda de veterinarias cercanas con Google Places API
  Future<void> buscarVeterinarias(LatLng ubicacion) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${ubicacion.latitude},${ubicacion.longitude}&radius=$searchRadius&type=veterinary_care&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> results = data['results'];

        if (results.isEmpty) {
          print("No se encontraron veterinarias.");
          return;
        }

        setState(() {
          for (var place in results) {
            LatLng placeLocation = LatLng(
              place['geometry']['location']['lat'],
              place['geometry']['location']['lng'],
            );

            _markers.add(
              Marker(
                markerId: MarkerId(place['place_id']),
                position: placeLocation,
                infoWindow: InfoWindow(title: place['name']),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            );
          }
        });
      } else {
        print("Error en la API de Google Places: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la búsqueda de veterinarias: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            markers: _markers,
            onTap: (LatLng argument) {
              print("Posición tocada: $argument");
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            circles: _circles,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: _searchController,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black),
                  iconColor: Colors.black,
                  hintText: "Buscar veterinarias...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    // Implementar búsqueda local
                  }
                },
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Buscando veterinarias cercanas...",
                        style: GoogleFonts.fredoka(color: Colors.black)),
                    backgroundColor: const Color.fromARGB(255, 169, 211, 193),
                  ),
                );
                getCurrentLocation();
              },
              child: const Icon(Icons.pets_outlined, color: Colors.white),
              backgroundColor: const Color.fromARGB(255, 0, 132, 103),
            ),
          ),
        ],
      ),
    );
  }
}
