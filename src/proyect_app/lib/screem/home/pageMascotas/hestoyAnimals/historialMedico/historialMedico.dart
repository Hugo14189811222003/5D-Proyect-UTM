import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/Apis/apiHistorialMedico.dart';
import 'package:proyect_app/Apis/apiMascota.dart';
import 'package:proyect_app/models/modeloHistorialMedico.dart';
import 'package:proyect_app/models/modeloMascota.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Historialmedico extends StatefulWidget {
  final GetMascota mascota;
  final mascotaSeleccionadaIdHistorial;
  const Historialmedico({super.key, required this.mascota, this.mascotaSeleccionadaIdHistorial});

  @override
  State<Historialmedico> createState() => _HistorialmedicoState();
}

class _HistorialmedicoState extends State<Historialmedico> {
    GlobalKey<FormState> _globalKey1 = GlobalKey<FormState>();
    GlobalKey<FormState> _globalKey2 = GlobalKey<FormState>();
    GlobalKey<FormState> _globalKey3 = GlobalKey<FormState>();
    TextEditingController _vacunaController = TextEditingController();
    TextEditingController _enfermedadesController = TextEditingController();
    TextEditingController _tratamientoController = TextEditingController();
    ScrollController _vacunasScrollController = ScrollController();
    ScrollController _enfermedadesScrollController = ScrollController();
    ScrollController _tratamientosScrollController = ScrollController();

    
    int? mascotaId;

        // VACUNAS
    List<getHistorialMedico> _historialVacunas = [];
    List<getHistorialMedico> _filtrarVacunas = [];
    bool _isLoadingVacunas = false;
    int _paginaVacunas = 1;

    // ENFERMEDADES
    List<getHistorialMedico> _historialEnfermedades = [];
    List<getHistorialMedico> _filtrarEnfermedades = [];
    bool _isLoadingEnfermedades = false;
    int _paginaEnfermedades = 1;

    // TRATAMIENTOS
    List<getHistorialMedico> _historialTratamientos = [];
    List<getHistorialMedico> _filtrarTratamientos = [];
    bool _isLoadingTratamientos = false;
    int _paginaTratamientos = 1;

    Timer? _timer;
    String? _vacunas;
    String? _enfermedad;
    String? _tratamiento;
    

    @override
  @override
void initState() {
  super.initState();
  loadUserData();
  obtenerRegistrosVacunas();
  obtenerRegistrosEnfermedades();
  obtenerRegistrosTratamientos();
  // Listener para el scroll de Vacunas
  _vacunasScrollController.addListener(() {
    if (_vacunasScrollController.position.pixels >= _vacunasScrollController.position.maxScrollExtent - 50 && !_isLoadingVacunas) {
      obtenerRegistrosVacunas();
    }
  });

  // Listener para el scroll de Enfermedades
  _enfermedadesScrollController.addListener(() {
    if (_enfermedadesScrollController.position.pixels >= _enfermedadesScrollController.position.maxScrollExtent - 50 && !_isLoadingEnfermedades) {
      obtenerRegistrosEnfermedades();
    }
  });

  // Listener para el scroll de Tratamientos
  _tratamientosScrollController.addListener(() {
    if (_tratamientosScrollController.position.pixels >= _tratamientosScrollController.position.maxScrollExtent - 50 && !_isLoadingTratamientos) {
      obtenerRegistrosTratamientos();
    }
  });

  // Timer para verificar cambios en los datos cada 2 segundos
  _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
    await checkForUpdates();
  });
}

  

Future<void> checkForUpdates() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? newIdString = prefs.getString('idPerro');
  int? newMascotaId = newIdString != null ? int.tryParse(newIdString) : null;

  if (newMascotaId != null && newMascotaId != mascotaId) { // Solo actualiza si cambió
    print("⚡ Cambio detectado en idPerro: $newMascotaId");

    setState(() {
      mascotaId = newMascotaId;
      
      // Vaciar listas antes de recargar datos
      _historialVacunas.clear();
      _filtrarVacunas.clear();
      _paginaVacunas = 1;

      _historialEnfermedades.clear();
      _filtrarEnfermedades.clear();
      _paginaEnfermedades = 1;

      _historialTratamientos.clear();
      _filtrarTratamientos.clear();
      _paginaTratamientos = 1;
    });

    // Cargar datos nuevamente para cada sección
    await obtenerRegistrosVacunas();
    await obtenerRegistrosEnfermedades();
    await obtenerRegistrosTratamientos();
  }
}


  @override
  void dispose() {
    _timer?.cancel(); // Detener el timer cuando se destruya el widget
    super.dispose();
  }

  Future<void> loadUserData() async {
    // Recuperar el userId como String y convertirlo a int
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('idPerro');
    mascotaId = userIdString != null ? int.tryParse(userIdString) : null;
    print("ID Recuperado: ${mascotaId}");
  }

  Future<void> obtenerRegistrosVacunas() async {
  if (_isLoadingVacunas) return; // Evita llamadas múltiples mientras está cargando

  setState(() {
    _isLoadingVacunas = true;
  });

  try {
    final obtencionResponse = await getHistorialMedicoApi(_paginaVacunas);
    print("📡 Respuesta de la API (Vacunas): $obtencionResponse");

    if (obtencionResponse.isNotEmpty) {

      final obtenerHistorialPormMascota = obtencionResponse.where((element) {
        print("Iwhere:  ${element.mascotaId == widget.mascotaSeleccionadaIdHistorial} element num ${element.mascotaId} y idhistorial ${widget.mascotaSeleccionadaIdHistorial}");
        return element.mascotaId == widget.mascotaSeleccionadaIdHistorial;
      }).toList();
      print("ID VACUNA HISTORIAL SOLO MASCOTA ${widget.mascotaSeleccionadaIdHistorial}");
      print("ver el objeto historial de VACUNA: ${obtenerHistorialPormMascota}");

      print("📋 Lista de vacunas filtrada: $obtenerHistorialPormMascota");

      setState(() {
        _historialVacunas.addAll(obtenerHistorialPormMascota);
        _filtrarVacunas = _historialVacunas;
        _paginaVacunas++;
      });
    } else {
      print("⚠️ No se encontraron datos de vacunas.");
    }
  } catch (err) {
    print("❌ Error al obtener registros de Vacunas: $err");
  } finally {
    setState(() {
      _isLoadingVacunas = false;
    });
  }
}

Future<void> obtenerRegistrosEnfermedades() async {
  if (_isLoadingEnfermedades) return;

  setState(() {
    _isLoadingEnfermedades = true;
  });

  try {
    final obtencionResponse = await getHistorialMedicoApi(_paginaEnfermedades);
    print("📡 Respuesta de la API (Vacunas): $obtencionResponse");

    if (obtencionResponse.isNotEmpty) {

      final obtenerHistorialPormMascota = obtencionResponse.where((element) {
        print("Comparando mascotaId: ${element.mascotaId} con ${widget.mascotaSeleccionadaIdHistorial}");
        return element.mascotaId == widget.mascotaSeleccionadaIdHistorial;  
      }).toList();

      print("ver el objeto historial: ${obtenerHistorialPormMascota}");

      print("📋 Lista de vacunas filtrada: $obtenerHistorialPormMascota");
      print("widget.mascotaSeleccionadaIdHistorial: ${widget.mascotaSeleccionadaIdHistorial}");
      print("Respuesta de la API: $obtencionResponse");
      print("Filtrado: ${obtencionResponse.where((element) => element.mascotaId == widget.mascotaSeleccionadaIdHistorial)}");
      print("Primer objeto de historial: ${obtencionResponse[0]}");

      setState(() {
        _historialEnfermedades.addAll(obtenerHistorialPormMascota);
        _filtrarEnfermedades = _historialEnfermedades;
        print("Historial Vacunas: $_historialVacunas");
        _paginaEnfermedades++;
      });
    } else {
      print("⚠️ No se encontraron datos de vacunas.");
    }
  } catch (err) {
    print("❌ Error al obtener registros de Vacunas: $err");
  } finally {
    setState(() {
      _isLoadingEnfermedades = false;
    });
  }
}

Future<void> obtenerRegistrosTratamientos() async {
  if (_isLoadingTratamientos) return;

  setState(() {
    _isLoadingTratamientos = true;
  });

  try {
    final obtencionResponse = await getHistorialMedicoApi(_paginaTratamientos);
    print("📡 Respuesta de la API (Vacunas): $obtencionResponse");

    if (obtencionResponse.isNotEmpty) {
      
      final obtenerHistorialPormMascota = obtencionResponse.where((element) {
        return element.mascotaId == widget.mascotaSeleccionadaIdHistorial;  
      }).toList();

      print("📋 Lista de vacunas filtrada: $obtenerHistorialPormMascota");
      print("_vacuna ${_vacunas} con ${obtenerHistorialPormMascota.length} y ${obtenerHistorialPormMascota}");
      print("_enfermedades ${_enfermedad}");
      print("_tratamiento ${_tratamiento}");
      print("mascota seleccionada para historial ${widget.mascotaSeleccionadaIdHistorial}");
      setState(() {
        _historialTratamientos.addAll(obtenerHistorialPormMascota);
        _filtrarTratamientos = _historialTratamientos;
        _paginaTratamientos++;
      });
    } else {
      print("⚠️ No se encontraron datos de vacunas.");
    }
  } catch (err) {
    print("❌ Error al obtener registros de Vacunas: $err");
  } finally {
    setState(() {
      _isLoadingTratamientos = false;
    });
  }
}

  void _enviarHistorial() {
    postHistorialMedico historialMedico = postHistorialMedico(
      mascotaId: widget.mascotaSeleccionadaIdHistorial,
      vacunas: _vacunas!,
      enfermedades: _enfermedad!,
      tratamiento: _tratamiento!
    );
    crearHistorialMedico(historialMedico);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Datos guardado con exito",
        textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 255, 255, 255))
        ),
      )
    );
  }

    Future<void> _addVacuna() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Ingresar la vacuna de la mascota",
            style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103)),
            ),
          content: Form(
            key: _globalKey1,
            child: TextFormField(
              controller: _vacunaController,
              maxLength: 35,
              style: GoogleFonts.fredoka(color: Colors.black),
              decoration: InputDecoration(
                labelText: "Vacuna", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                hintText: "Ejemplo: Parvovirus",
                hintStyle: GoogleFonts.fredoka(color: const Color.fromARGB(110, 0, 0, 0), fontSize: 14),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                    color: const Color.fromARGB(255, 151, 2, 177),
                    width: 5.0
                  )
                )
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _vacunas = _vacunaController.text;
                print(_vacunas);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Column(
                      children: [
                        Icon(Icons.check, color: const Color.fromARGB(255, 30, 101, 33), size: 65,),
                        Text(
                          _enfermedad == null 
                          ?
                          "Genial! ahora ingresa sus enfermedades para poder guardarlo todo"
                          :
                          _tratamiento == null 
                          ? 
                          "Genial! ahora ingresa sus tratamientos para poder guardarlo todo"
                          :
                          "Genial! ya tienes todos los datos, por favor guarde"
                          , 
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 77, 61))
                        )
                      ],
                    ),
                    backgroundColor: const Color.fromARGB(255, 169, 211, 193),
                  )
                );
                Navigator.of(context).pop();
                if(_vacunas != null && _enfermedad != null && _tratamiento != null){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("¿Guardar o segir editando?", style: GoogleFonts.fredoka(color: Colors.black),),
                        content: Icon(Icons.save, size: 45, color: Color.fromARGB(255, 0, 132, 103),),
                        actions: [
                          TextButton(
                          style: ButtonStyle(
                            
                          ),
                          onPressed:() {
                            _enviarHistorial();
                            Navigator.of(context).pop();
                          }, 
                          child: Text("Guardar", style: GoogleFonts.fredoka(color: Color.fromARGB(255, 0, 132, 103)),)
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("Guardar", style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103)),),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 169, 211, 193),
              ),
            ),
          ],
        );
      },
    );
  }


  Future<void> _addEnfermedades() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Ingresar la enfermedad de la mascota",
            style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103)),
            ),
          content: Form(
            key: _globalKey2,
            child: TextFormField(
              controller: _enfermedadesController,
              maxLength: 35,
              style: GoogleFonts.fredoka(color: Colors.black),
              decoration: InputDecoration(
                labelText: "Enfermedades", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                hintText: "Ejemplo: Espiroqueta",
                hintStyle: GoogleFonts.fredoka(color: const Color.fromARGB(110, 0, 0, 0), fontSize: 14),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                    color: const Color.fromARGB(255, 151, 2, 177),
                    width: 5.0
                  )
                )
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _enfermedad = _enfermedadesController.text;
                print(_enfermedad);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Column(
                      children: [
                        Icon(Icons.check, color: const Color.fromARGB(255, 30, 101, 33), size: 65,),
                        Text(
                          _vacunas == null 
                          ?
                          "Genial! ahora ingresa sus vacunas para poder guardarlo todo"
                          :
                          _tratamiento == null 
                          ? 
                          "Genial! ahora ingresa sus tratamientos para poder guardarlo todo"
                          :
                          "Genial! ya tienes todos los datos, por favor guarde"
                          , 
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 77, 61))
                        )
                      ],
                    ),
                    backgroundColor: const Color.fromARGB(255, 169, 211, 193),
                  )
                );
                Navigator.of(context).pop();
                if(_vacunas != null && _enfermedad != null && _tratamiento != null){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("¿Guardar o segir editando?", style: GoogleFonts.fredoka(color: Colors.black),),
                        content: Icon(Icons.save, size: 45, color: Color.fromARGB(255, 0, 132, 103),),
                        actions: [
                          TextButton(
                          style: ButtonStyle(
                            
                          ),
                          onPressed:() {
                            _enviarHistorial();
                            Navigator.of(context).pop();
                          }, 
                          child: Text("Guardar", style: GoogleFonts.fredoka(color: Color.fromARGB(255, 0, 132, 103)),)
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("Guardar", style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103)),),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 169, 211, 193),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTratamientos() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Ingresar el tratamiento de la mascota",
            style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103)),
            ),
          content: Form(
            key: _globalKey3,
            child: TextFormField(
              controller: _tratamientoController,
              maxLength: 35,
              style: GoogleFonts.fredoka(color: Colors.black),
              decoration: InputDecoration(
                labelText: "Tratamientos", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                hintText: "Ejemplo: Terapia huesal",
                hintStyle: GoogleFonts.fredoka(color: const Color.fromARGB(110, 0, 0, 0), fontSize: 14),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                    color: const Color.fromARGB(255, 151, 2, 177),
                    width: 5.0
                  )
                )
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _tratamiento = _tratamientoController.text;
                print(_tratamiento);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Column(
                      children: [
                        Icon(Icons.check, color: const Color.fromARGB(255, 30, 101, 33), size: 65,),
                        Text(
                          _enfermedad == null 
                          ?
                          "Genial! ahora ingresa sus enfermedades para poder guardarlo todo"
                          :
                          _vacunas == null 
                          ? 
                          "Genial! ahora ingresa sus vacunas para poder guardarlo todo"
                          :
                          "Genial! ya tienes todos los datos, por favor guarde"
                          , 
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 77, 61))
                        )
                      ],
                    ),
                    backgroundColor: const Color.fromARGB(255, 169, 211, 193),
                  )
                );
                Navigator.of(context).pop();
                if(_vacunas != null && _enfermedad != null && _tratamiento != null){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("¿Guardar o segir editando?", style: GoogleFonts.fredoka(color: Colors.black),),
                        content: Icon(Icons.save, size: 45, color: Color.fromARGB(255, 0, 132, 103),),
                        actions: [
                          TextButton(
                          style: ButtonStyle(
                            
                          ),
                          onPressed:() {
                            _enviarHistorial();
                            Navigator.of(context).pop();
                          }, 
                          child: Text("Guardar", style: GoogleFonts.fredoka(color: Color.fromARGB(255, 0, 132, 103)),)
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("Guardar", style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103)),),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 169, 211, 193),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 0, 132, 103),
          toolbarHeight: 70,
          title: Text("historial Medico", style: GoogleFonts.fredoka(color: Colors.white),),
        ),
        body: Container(
          decoration: const BoxDecoration(color: Color.fromARGB(255, 237, 237, 237)),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //VACUNAS
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidthConnstrain = constraints.maxWidth;
                      final screenHeightConstrain = constraints.maxHeight;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04, 
                          vertical: MediaQuery.of(context).size.height * 0.02
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Vacunas", 
                                style: GoogleFonts.fredoka(
                                  color: Colors.black, 
                                  fontSize: 20, fontWeight: 
                                  FontWeight.w500)
                                ),
                                Row(
                                  children: [
                                    Text("Ver todo", 
                                    style: GoogleFonts.fredoka(
                                      color: const Color.fromARGB(255, 83, 68, 141),
                                      fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    SizedBox(width: screenWidthConnstrain * 0.025,),
                                    GestureDetector(
                                      onTap: () {
                                        
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: Color.fromARGB(255, 83, 68, 141),
                                        ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // Hacer scroll horizontal
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // O "center" si prefieres centrar
                                children: List.generate(_filtrarVacunas.length + (_isLoadingVacunas ? 1 : 0), (index) {
                                  if (index == _filtrarVacunas.length) {
                                    // Mostrar el indicador de carga si estamos esperando más datos
                                    return _isLoadingVacunas
                                        ? Center(child: CircularProgressIndicator())
                                        : SizedBox.shrink();
                                  }
            
                                  final vacunas = _filtrarVacunas[index];
                                  print("datos aver: ${_filtrarVacunas.length}");
                                  print("datos recor: ${vacunas.vacunas}");
                                  
                                  return Container(
                                    margin: EdgeInsets.all(8),
                                    width: MediaQuery.of(context).size.width * 0.4, // Ajusta según lo necesario
                                    height: MediaQuery.of(context).size.height * 0.075,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(17, 0, 0, 0),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(vacunas.vacunas, textAlign: TextAlign.center),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 169, 211, 193)
                                ),
                                child: GestureDetector(
                                  onTap: _addVacuna,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Añadir vacuna", style: 
                                      GoogleFonts.fredoka(color: const Color(0xFF004D3A),
                                      fontSize: MediaQuery.of(context).size.height * 0.016,
                                      )),
                                      Icon(Icons.arrow_forward)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  //ENFERMEDADES
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidthConnstrain = constraints.maxWidth;
                      final screenHeightConstrain = constraints.maxHeight;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04, 
                          vertical: MediaQuery.of(context).size.height * 0.01
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Enfermedades", 
                                style: GoogleFonts.fredoka(
                                  color: Colors.black, 
                                  fontSize: 20, fontWeight: 
                                  FontWeight.w500)
                                ),
                                Row(
                                  children: [
                                    Text("Ver todo", 
                                    style: GoogleFonts.fredoka(
                                      color: const Color.fromARGB(255, 83, 68, 141),
                                      fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    SizedBox(width: screenWidthConnstrain * 0.025,),
                                    GestureDetector(
                                      onTap: () {
                                        
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: Color.fromARGB(255, 83, 68, 141),
                                        ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // Hacer scroll horizontal
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // O "center" si prefieres centrar
                                children: List.generate(_filtrarEnfermedades.length + (_isLoadingEnfermedades ? 1 : 0), (index) {
                                  if (index == _filtrarEnfermedades.length) {
                                    // Mostrar el indicador de carga si estamos esperando más datos
                                    return _isLoadingEnfermedades
                                        ? Center(child: CircularProgressIndicator())
                                        : SizedBox.shrink();
                                  }
            
                                  final enfermedad = _filtrarEnfermedades[index];
                                  return Container(
                                    margin: EdgeInsets.all(8),
                                    width: MediaQuery.of(context).size.width * 0.4, // Ajusta según lo necesario
                                    height: MediaQuery.of(context).size.height * 0.075,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(17, 0, 0, 0),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(enfermedad.enfermedades, textAlign: TextAlign.center),
                                    ),
                                  );
                                }),
                              ),
                            ),
            
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 169, 211, 193)
                                ),
                                child: GestureDetector(
                                  onTap: _addEnfermedades,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Añadir enfermedades", style: 
                                      GoogleFonts.fredoka(color: const Color(0xFF004D3A),
                                      fontSize: MediaQuery.of(context).size.height * 0.016,
                                      )),
                                      Icon(Icons.arrow_forward)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  //Tratamientos
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidthConnstrain = constraints.maxWidth;
                      final screenHeightConstrain = constraints.maxHeight;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04, 
                          vertical: MediaQuery.of(context).size.height * 0.02
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Tratamientos", 
                                style: GoogleFonts.fredoka(
                                  color: Colors.black, 
                                  fontSize: 20, fontWeight: 
                                  FontWeight.w500)
                                ),
                                Row(
                                  children: [
                                    Text("Ver todo", 
                                    style: GoogleFonts.fredoka(
                                      color: const Color.fromARGB(255, 83, 68, 141),
                                      fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    SizedBox(width: screenWidthConnstrain * 0.025,),
                                    GestureDetector(
                                      onTap: () {
                                        
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: Color.fromARGB(255, 83, 68, 141),
                                        ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                            SingleChildScrollView(
                            scrollDirection: Axis.horizontal, // Hacer scroll horizontal
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start, // O "center" si prefieres centrar
                              children: List.generate(_filtrarTratamientos.length + (_isLoadingTratamientos ? 1 : 0), (index) {
                                if (index == _filtrarTratamientos.length) {
                                  // Mostrar el indicador de carga si estamos esperando más datos
                                  return _isLoadingTratamientos
                                      ? Center(child: CircularProgressIndicator())
                                      : SizedBox.shrink();
                                }
            
                                final tratamiento = _filtrarTratamientos[index];
                                return Container(
                                  width: MediaQuery.of(context).size.width * 0.4, // Ajusta según lo necesario
                                  height: MediaQuery.of(context).size.height * 0.08,
                                  margin: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(17, 0, 0, 0),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(tratamiento.tratamientos, textAlign: TextAlign.center),
                                  ),
                                );
                              }),
                            ),
                          ),
            
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 169, 211, 193)
                                ),
                                child: GestureDetector(
                                  onTap: _addTratamientos,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Añadir tratamientos", style: 
                                      GoogleFonts.fredoka(color: const Color(0xFF004D3A),
                                      fontSize: MediaQuery.of(context).size.height * 0.016,
                                      )),
                                      Icon(Icons.arrow_forward)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          )
      )
    );
  }
}