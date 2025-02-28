import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:proyect_app/Apis/apiMascota.dart';
import 'package:proyect_app/models/modeloMascota.dart';
import 'package:proyect_app/screem/home/bodyHome.dart';
import 'package:proyect_app/screem/home/horizontalBody.dart';
import 'package:proyect_app/screem/home/menuDrawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/screem/home/navigationBottomBar.dart';
import 'package:proyect_app/screem/home/pageGu%C3%ADas/verticalGuiasBody.dart';
import 'package:proyect_app/screem/home/pageHome/verticaBoody.dart';
import 'package:proyect_app/screem/home/pageMascotas/mascota.dart';
import 'package:proyect_app/screem/home/pageMonitoreo/verticalMonitoreo.dart';
import 'package:proyect_app/screem/home/pageUbicacion/ubicacion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final int indexSeleccionado;
  const Home({super.key, required this.indexSeleccionado});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  
  String? nombreUsuario;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _currentIndex = 1;
  final List<Widget> _screens = [];
  ScrollController _scrollController = ScrollController();
  List<GetMascota> _mascotas = [];
  List<GetMascota> _filtradoDeMascotas = [];
  int _paginaActual = 1;
  bool _isLoading = false;
  int? _mascotaSeleccionadaId;
  


  @override
  void initState() {
    super.initState();
    _cargarNombreUsuario();
    loadUserData();
    _obtenerMascotas();
    _cargarMascotaSeleccionada();
    if(_currentIndex == 2) {
      _guardarCurrentIndex();
    }
    _currentIndex = widget.indexSeleccionado;
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading){
        _obtenerMascotas();
      }
    });
  }

  String? nombreUser;
  String? emailUser;
  int? userId;

  Future<void> _guardarCurrentIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("currentIndex", _currentIndex.toString());
  }

  Future<void> _cargarNombreUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombreUsuario = prefs.getString('nombre');
    });
  }
  
  Future<void> _cargarMascotaSeleccionada() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idPerro = prefs.getString('idPerro');
    if (idPerro != null) {
      setState(() {
        _mascotaSeleccionadaId = int.tryParse(idPerro);
      });
    }
  }

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
      setState(() {
        _isLoading = false;
      });
    }
  }

  void agregarMascota(GetMascota nuevaMascota) {
  setState(() {
    _mascotas.add(nuevaMascota);
    _filtradoDeMascotas = _mascotas; // Actualiza la lista filtrada
  });
}

  void _mostrarMascotasDialog() async {
    setState(() {
      _mascotas.clear();
      _filtradoDeMascotas.clear();
      _paginaActual = 1;
    });
    await _obtenerMascotas();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tus Mascotas"),
          content: _mascotas.isEmpty
              ? Center(child: Text("No tienes mascotas"))
              : SizedBox(
                  height: 300, // Limitar la altura del ListView
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: _filtradoDeMascotas.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _filtradoDeMascotas.length) {
                        return _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox.shrink();
                      }
                      final mascota = _filtradoDeMascotas[index];
                      bool esSeleccionada = mascota.id == _mascotaSeleccionadaId;
                      return Container(
                        decoration: BoxDecoration(
                          color: esSeleccionada ? Color.fromARGB(255, 0, 85, 66) : null,
                        borderRadius: BorderRadius.circular(20), // Agrega borderRadius aquí
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          title: Text(mascota.nombre ?? 'Sin nombre', 
                          style: GoogleFonts.fredoka(color: esSeleccionada ? Colors.white : Colors.black, fontWeight: FontWeight.w500)
                          ),
                          subtitle: Text('ID: ${mascota.usuarioId}', 
                          style: GoogleFonts.fredoka(color: esSeleccionada ? Colors.white : Colors.black)
                          ),
                          //icon pets
                          leading: Icon(Icons.pets, color: esSeleccionada ? const Color.fromARGB(255, 255, 255, 255) : null,),
                          onTap: () async {
                            // Aquí puedes manejar lo que pasa cuando seleccionas una mascota
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('idPerro', mascota.id.toString());

                        
                            setState(() {
                              _mascotaSeleccionadaId = mascota.id;
                              _mascotas = [];
                              _filtradoDeMascotas = [];
                              _paginaActual = 1;
                              
                            });
                            print("aver mascota de home: ${_mascotaSeleccionadaId}");
                            await _obtenerMascotas();
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: const Color.fromARGB(255, 0, 85, 66),
                                content: Text("Cambiaste a ${mascota.nombre}", style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 255, 255, 255)),),
                              )
                            );
                            print("Seleccionaste: ${mascota.nombre} y su id es: ${mascota.id}");
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                        ),
                      );
                    },
                  ),
                ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Aquí calculamos screenHeightd después de que el contexto esté disponible.
    final screenHeightd = MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight;
    // Si aún no agregaste la lista de pantallas, lo haces aquí para que se ejecute una vez.
    if (_screens.isEmpty) {
      _screens.add(const Bodyhome());
      _screens.add(LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = screenHeightd;
          final screenHorizontal = screenWidth > screenHeight;
          return screenHorizontal ? Horizontalbody(screenHeight: screenHeight, screenWidth: screenWidth) : verticalBody(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            screenHorizontal: screenHorizontal,
          );
          
        },
      ));
      _screens.add(LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = screenHeightd;
          return Verticalguiasbody(screenHeight: screenHeight, screenWidth: screenWidth ,key: Key('screen-verticalguiasbody'));
        },
      ));
      _screens.add(LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = screenHeightd;
          return monitoreo(screenHeight: screenHeight, screenWidth: screenWidth);
        },
      ));
      _screens.add(LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = screenHeightd;
          return Ubicacion(screenHeight: screenHeight, screenWidth: screenWidth);
        },
      ));
      _screens.add(LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          return mascotasPage(screenHeight: screenHeight, screenWidth: screenWidth,);
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    double appBarSize;
    if (_currentIndex == 2) {
      appBarTitle = "Guía de primeros auxilios";
      appBarSize = 22;
    } else if (_currentIndex == 3) {
      appBarTitle = "Página de Monitoreo";
      appBarSize = 22;
    } else if (_currentIndex == 4) {
      appBarTitle = "Página de Veterinarias";
      appBarSize = 22;
    } else if (_currentIndex == 5) {
      appBarTitle = "Página de Mascotas";
      appBarSize = 22;
    } else {
      appBarTitle = 'Hola, ${nombreUsuario ?? "Usuario"}!';
      appBarSize = 30;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: FadeInLeftBig(
              duration: Duration(milliseconds: 1000),
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 17, bottom: 17),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(255, 170, 212, 194)
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings, size: 25, color: Color.fromARGB(255, 0, 77, 58)),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ),
            ),
            title: LayoutBuilder(
              builder: (context, constraints) {
                final appBarWidth = constraints.maxWidth;
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(0, 67, 61, 42)
                      ),
                      width: appBarWidth * 0.82,
                      child: Center(child: Text(appBarTitle, style: GoogleFonts.fredoka(color: Colors.white, fontSize: appBarSize),),)
                    )
                  ],
                );
              },
            ),
        iconTheme: const IconThemeData(
          size: 35,
          color: Colors.white
        ),
        toolbarHeight: 80.0,
        backgroundColor: const Color.fromARGB(255, 0, 132, 103),
                actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: _currentIndex == 1 ? CircleAvatar(
              radius: 25, // Tamaño del círculo
              backgroundColor: const Color.fromARGB(255, 0, 77, 58),
              child: IconButton(
                icon: const Icon(Icons.pets, color: Colors.white),
                onPressed: _mostrarMascotasDialog, // Muestra las mascotas al hacer clic
              ),
            ) : null,
          ),
        ],
      ),
      drawer: const drawerMenuList(),
      body: _screens[_currentIndex],
      bottomNavigationBar: Navigationbottombar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

