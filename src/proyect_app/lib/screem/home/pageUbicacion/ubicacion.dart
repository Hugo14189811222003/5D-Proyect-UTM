import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Ubicacion extends StatefulWidget {
  final double? screenWidth;
  final double? screenHeight;

  const Ubicacion({super.key, this.screenWidth, this.screenHeight});

  @override
  State<Ubicacion> createState() => _UbicacionState();
}

class _UbicacionState extends State<Ubicacion> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Set<Marker> _markers = {};
  final Set<Circle> _circle = {};
  final TextEditingController _searchController = TextEditingController(); // Controlador para el buscador

  static const double searchRadius = 2000;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.966430466971097, -89.588418379426),
    zoom: 14.4746,
  );

  // Tu API Key
  static const String apiKey = "AIzaSyAze78nAXnTwvz7QIaSCSxvNC9LevB0Hn8";

  Future<Position> _getPermission() async {
    // Solicitar permisos para obtener la ubicación
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Permiso denegado");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  // Función para ajustar el zoom del mapa para el radio
  Future<void> adjustCameraToRadius(LatLng center, double radius) async {
    final GoogleMapController controller = await _controller.future;

    // Aproximación: 1° de latitud ≈ 111 km, 1° de longitud varía según la latitud
    const double degreesPerMeter = 1 / 111000; // Aproximación

    double latOffset = radius * degreesPerMeter;
    double lngOffset = radius * degreesPerMeter / (111000 * (1 / 0.000621371));

    LatLng southwest = LatLng(center.latitude - latOffset, center.longitude - lngOffset);
    LatLng northeast = LatLng(center.latitude + latOffset, center.longitude + lngOffset);

    LatLngBounds bounds = LatLngBounds(southwest: southwest, northeast: northeast);

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 150)); // 150 es el padding
  }

  // Función para obtener la ubicación del usuario y mostrar veterinarias cercanas
  void getCurrentLocation() async {
    try {
      Position position = await _getPermission();
      LatLng myPosition = LatLng(position.latitude, position.longitude);

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(myPosition, 16));

      setState(() {
        _markers.clear();
        _circle.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId("ubicacion_del_usuario"),
            position: myPosition,
            infoWindow: const InfoWindow(title: "Tu ubicación"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );
      });

      _circle.add(
        Circle(
          circleId: const CircleId("radio_de_busqueda"),
          radius: searchRadius,
          center: myPosition,
          strokeColor: Colors.black26,
          strokeWidth: 2,
          fillColor: Colors.black12,
        ),
      );

      adjustCameraToRadius(myPosition, searchRadius);

      // Realiza la búsqueda de veterinarias cercanas usando la API de Google Places
      String url =
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${Uri.encodeComponent(position.latitude.toString())},${Uri.encodeComponent(position.longitude.toString())}&radius=$searchRadius&type=veterinary_care&key=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Respuesta de la API: ${response.body}");
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> results = data['results'];

        if (results.isEmpty) {
          print("No se encontraron resultados.");
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
        print("Error en la respuesta de la API: ${response.statusCode}");
      }
    } catch (e) {
      print("Error obteniendo la ubicación o realizando la búsqueda: $e");
    }
  }

  void getCurrentVeterinarias() async {
    if(_searchController.text == "ZOOVET" || _searchController.text == "zoovet"){
      print("encontrado");
      LatLng myPosition = LatLng(20.9632582, -89.6503775);

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(myPosition, 16));

      setState(() {
        _markers.clear();
        _circle.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId("ubicacion_de_la_veterinaria"),
            position: myPosition,
            infoWindow: const InfoWindow(title: "ZOOVET"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );
      });
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
            onTap: (argument) {
              print(argument);
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            circles: _circle,
            zoomControlsEnabled: false,
          ),
          // Buscador flotante encima del mapa
          Positioned(
            top: 10, // Ajusta la posición vertical como desees
            left: 10, // Ajusta la posición horizontal como desees
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // Fondo blanco semi-transparente
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 5)
                  )
                ]
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
                    // Realiza la búsqueda cuando el texto cambia
                    getCurrentVeterinarias();
                  }
                },
              ),
            ),
          ),
          // Floating button en la parte inferior derecha
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Buscando veterinarias cercanas...", style: GoogleFonts.fredoka(color: Colors.black)), backgroundColor: const Color.fromARGB(255, 169, 211, 193),)
                );
                getCurrentLocation();
              },
              child: const Icon(Icons.pets_outlined, color: Color.fromARGB(255, 255, 255, 255),),
              backgroundColor: const Color.fromARGB(255, 0, 132, 103),
            ),
          ),
        ],
      ),
    );
  }
}
