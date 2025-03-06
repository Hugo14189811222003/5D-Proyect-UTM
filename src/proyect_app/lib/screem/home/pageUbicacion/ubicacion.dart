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
      body: Container()
    );
  }
}
