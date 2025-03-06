import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/Apis/apiMascota.dart';
import 'package:proyect_app/models/modeloMascota.dart';
import 'package:proyect_app/screem/home/pageMascotas/crearMascota/crearMascota.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/historyAnimals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mascotasPage extends StatefulWidget {
  final screenWidth;
  final screenHeight;
  const mascotasPage({super.key, this.screenWidth, this.screenHeight});

  @override
  State<mascotasPage> createState() => _mascotasPageState();
}

class _mascotasPageState extends State<mascotasPage> {
  ScrollController _scrollController = ScrollController();
  List<GetMascota> _mascotas = [];
  List<GetMascota> _filtradoDeMascotas = [];
  int _paginaActual = 1;
  bool _isLoading = false;
  int? _mascotaSeleccionadaId;

  Future<void> _refreshMascota() async {
  setState(() {
    _mascotas.clear();
    _paginaActual = 1; 
  });

  await _obtenerMascotas();

  setState(() {

  });
}



  @override
  void initState() {
    super.initState();
    loadUserData();
    _obtenerMascotas();
    obtenerIdGuardado();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading){
        _obtenerMascotas();
      }
    });
  }

  String? nombreUser;
  String? emailUser;
  int? userId;
  

  Future<void> loadUserData() async {
    // Recuperar el userId como String y convertirlo a int
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('id');
    userId = userIdString != null ? int.tryParse(userIdString) : null;
    print("ID Recuperado: ${userId}");

    if (nombreUser != null && emailUser != null) {
      print('Usuario logueado: $nombreUser');
    } else {
      print('No hay usuario logueado');
    }
  }

  Future<void> CambiadorDePagina(GetMascota mascotaSeleccionada) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("idMascotaforHistorial", mascotaSeleccionada.id.toString());

    setState(() {
      _mascotaSeleccionadaId = mascotaSeleccionada.id;
    });
    
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => historyAnimals(mascota: mascotaSeleccionada, mascotaSeleccionadaIdHistorial: _mascotaSeleccionadaId,))
    );
  }

  Future<void> obtenerIdGuardado() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idPerroForHistorial = await pref.getString('idMascotaforHistorial');
    setState(() {
      _mascotaSeleccionadaId = idPerroForHistorial != null ? int.tryParse(idPerroForHistorial) : null;
    });
  }

  Future<void> _obtenerMascotas() async {
    setState(() {
      _isLoading = true;
    });
    try{
      final responseGet = await getMascota(_paginaActual);
      print("datos obtenidos: ${responseGet.length}");
      if(responseGet.isNotEmpty && userId != null){
        final getMascotaUser1 = responseGet.where((element) => element.usuarioId == userId);
        setState(() {
          _mascotas.addAll(getMascotaUser1);
          _filtradoDeMascotas = _mascotas;
          _paginaActual++;
        });
      } else {
        print("no se encontro ese usuario con ID");
      }
    } catch (err) {
      print("error con el servidor");
    } finally {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: _refreshMascota,
      child: Scaffold(
        body: Container(
            decoration: BoxDecoration(color: const Color.fromARGB(255, 237, 237, 237)),
            width: widget.screenWidth,
            height: widget.screenHeight,
            child: Padding(
              padding: const EdgeInsets.all(35),
              child: Column(
                children: [
                  agregarMascota(context),
                  SizedBox(height: widget.screenHeight * 0.03,),
                  scrollMascotas(),
                ],
              ),
            ),
          ),
      ),
    );
  }

  Expanded scrollMascotas() {
  return Expanded(
    child: SizedBox(
      height: widget.screenHeight, // Define la altura que necesitas para el GridView
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Número de columnas (ajústalo según tus necesidades)
          crossAxisSpacing: 10, // Espaciado horizontal entre elementos
          mainAxisSpacing: 10, // Espaciado vertical entre elementos
          childAspectRatio: 0.8, // Relación de aspecto para cada item (ajústalo según el tamaño de la imagen y el contenido)
        ),
        scrollDirection: Axis.vertical,
        itemCount: _filtradoDeMascotas.length + 1,
        itemBuilder: (context, index) {
          if (index == _filtradoDeMascotas.length) {
            return _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox.shrink();
          }
          final mascotasResponse = _filtradoDeMascotas[index];
          bool _mascotaSeleccionadaIdHistorial = mascotasResponse.id == _mascotaSeleccionadaId;
          return GestureDetector(
            onTap: () => CambiadorDePagina(mascotasResponse),
            child: Container(
              margin: EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: 100, // Ajusta el tamaño según lo que necesites
                      height: 100, // Ajusta el tamaño según lo necesites
                      child: Image.network(
                        mascotasResponse.imagenURL,
                        fit: BoxFit.cover, // Usa cover para recortar y llenar el contenedor
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    mascotasResponse.nombre.isNotEmpty
                        ? mascotasResponse.nombre
                        : "sin nombre",
                    style: GoogleFonts.fredoka(
                        fontSize: widget.screenHeight * 0.02,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(mascotasResponse.raza.isNotEmpty
                      ? mascotasResponse.raza
                      : "sin raza"),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}


  Row agregarMascota(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Mascota añadida", style: GoogleFonts.fredoka(color: Colors.black, fontSize: 20),),
                GestureDetector(onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Crearmascota(),
                    )
                  );
                }, 
                child: Icon(Icons.add, color: const Color.fromARGB(255, 0, 77, 58), size: 30,)),
              ],
            );
  }
}