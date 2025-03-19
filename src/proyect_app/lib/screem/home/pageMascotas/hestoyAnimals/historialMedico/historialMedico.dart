import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/Apis/HistorialMedico/apiEnfermedad/enfermedad.dart';
import 'package:proyect_app/Apis/HistorialMedico/apiHistorialMedico.dart';
import 'package:proyect_app/Apis/HistorialMedico/apiMascotaHistorialMedico.dart';
import 'package:proyect_app/Apis/HistorialMedico/apiTratamiento/tratamientes.dart';
import 'package:proyect_app/Apis/HistorialMedico/apiVacuna/vacuna.dart';
import 'package:proyect_app/Apis/apiMascota.dart';
import 'package:proyect_app/models/HistorialMedico/modeloEnfermedad/enfermedad.dart';
import 'package:proyect_app/models/HistorialMedico/modeloHistorialMedico.dart';
import 'package:proyect_app/models/HistorialMedico/modeloTratamiento/tratamiento.dart';
import 'package:proyect_app/models/HistorialMedico/modeloVacuna/postVacuna.dart';
import 'package:proyect_app/models/modeloMascota.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/historialMedico/verTodoHistorial/verEnfermedades.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/historialMedico/verTodoHistorial/verTratamientos.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/historialMedico/verTodoHistorial/verVacunas.dart';
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
    TextEditingController _descripcionVacunaController= TextEditingController();
    TextEditingController _enfermedadesController = TextEditingController();
    TextEditingController _descripcionEnfermedadController= TextEditingController();
    TextEditingController _tratamientoController = TextEditingController();
    TextEditingController _descripcionTratamientoController= TextEditingController();
    ScrollController _vacunasScrollController = ScrollController();
    ScrollController _enfermedadesScrollController = ScrollController();
    ScrollController _tratamientosScrollController = ScrollController();

    
    int? mascotaId;

        // VACUNAS
    List<Vacuna> _historialVacunas = [];
    List<Vacuna> _filtrarVacunas = [];
    bool _isLoadingVacunas = false;
    int _paginaVacunas = 1;

    // ENFERMEDADES
    List<Enfermedades> _historialEnfermedades = [];
    List<Enfermedades> _filtrarEnfermedades = [];
    bool _isLoadingEnfermedades = false;
    int _paginaEnfermedades = 1;

    // TRATAMIENTOS
    List<Tratamientos> _historialTratamientos = [];
    List<Tratamientos> _filtrarTratamientos = [];
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
      // 1️⃣ Obtener el historial médico de la mascota usando el ID de la mascota
      int mascotaId = widget.mascotaSeleccionadaIdHistorial; // ID de la mascota seleccionada
      print("📌 Intentando obtener historial médico para la mascota con ID $mascotaId...");

      // Usamos la función modificada para obtener el historial médico por ID de la mascota
      HistorialMedico? historial = await obtenerHistorialMedicoPorMascota(mascotaId);

      if (historial == null) {
        print("⚠️ No se encontró historial médico para esta mascota.");
        return;
      }

      print("✅ Historial encontrado: ${historial.id}");

      // 2️⃣ Obtener vacunas usando el ID del historial médico
      final List<Vacuna> vacunas = await obtenerVacunas(historial.id ?? 0);

      if (vacunas.isEmpty) {
        print("⚠️ No hay vacunas registradas para el historial médico ${historial.id}");
      } else {
        print("💉 Se encontraron ${vacunas.length} vacunas.");
      }

      // 3️⃣ Actualizar la lista de vacunas en el estado
      setState(() {
        _historialVacunas = vacunas;
        _filtrarVacunas = _historialVacunas;
      });
    } catch (err) {
      print("❌ Error al obtener registros de Vacunas: $err");
    } finally {
      setState(() {
        _isLoadingVacunas = false;
      });
    }
  }



  Future<void> obtenerRegistrosEnfermedades() async {
    if (_isLoadingEnfermedades) return; // Evita llamadas múltiples mientras está cargando

    setState(() {
      _isLoadingEnfermedades = true;
    });

    try {
      // 1️⃣ Obtener el historial médico de la mascota usando el ID de la mascota
      int mascotaId = widget.mascotaSeleccionadaIdHistorial; // ID de la mascota seleccionada
      print("📌 Intentando obtener historial médico para la mascota con ID $mascotaId...");

      // Usamos la función modificada para obtener el historial médico por ID de la mascota
      HistorialMedico? historial = await obtenerHistorialMedicoPorMascota(mascotaId);

      if (historial == null) {
        print("⚠️ No se encontró historial médico para esta mascota.");
        return;
      }

      print("✅ Historial encontrado: ${historial.id}");

      // 2️⃣ Obtener las enfermedades usando el ID del historial médico
      final List<Enfermedades> enfermedades = await obtenerEnfermedades(historial.id ?? 0);

      if (enfermedades.isEmpty) {
        print("⚠️ No hay enfermedades registradas para el historial médico ${historial.id}");
      } else {
        print("🦠 Se encontraron ${enfermedades.length} enfermedades.");
      }

      // 3️⃣ Actualizar la lista de enfermedades en el estado
      setState(() {
        _historialEnfermedades = enfermedades;
        _filtrarEnfermedades = _historialEnfermedades;
      });
    } catch (err) {
      print("❌ Error al obtener registros de Enfermedades: $err");
    } finally {
      setState(() {
        _isLoadingEnfermedades = false;
      });
    }
  }


  Future<void> obtenerRegistrosTratamientos() async {
    if (_isLoadingTratamientos) return; // Evita llamadas múltiples mientras está cargando

    setState(() {
      _isLoadingTratamientos = true;
    });

    try {
      // 1️⃣ Obtener el historial médico de la mascota usando el ID de la mascota
      int mascotaId = widget.mascotaSeleccionadaIdHistorial; // ID de la mascota seleccionada
      print("📌 Intentando obtener historial médico para la mascota con ID $mascotaId...");

      // Usamos la función modificada para obtener el historial médico por ID de la mascota
      HistorialMedico? historial = await obtenerHistorialMedicoPorMascota(mascotaId);

      if (historial == null) {
        print("⚠️ No se encontró historial médico para esta mascota.");
        return;
      }

      print("✅ Historial encontrado: ${historial.id}");

      // 2️⃣ Obtener los tratamientos usando el ID del historial médico
      final List<Tratamientos> tratamientos = await obtenerTratamientos(historial.id ?? 0);

      if (tratamientos.isEmpty) {
        print("⚠️ No hay tratamientos registrados para el historial médico ${historial.id}");
      } else {
        print("💊 Se encontraron ${tratamientos.length} tratamientos.");
      }

      // 3️⃣ Actualizar la lista de tratamientos en el estado
      setState(() {
        _historialTratamientos = tratamientos;
        _filtrarTratamientos = _historialTratamientos;
      });
    } catch (err) {
      print("❌ Error al obtener registros de Tratamientos: $err");
    } finally {
      setState(() {
        _isLoadingTratamientos = false;
      });
    }
  }


    void _enviarVacuna(String nombre, String descripcion) async {
      print("🚀 Iniciando proceso de vacunación...");

      // 1️⃣ Obtener el historial médico usando el ID de la mascota (llamando a la nueva función)
      HistorialMedico? historial = await obtenerHistorialMedicoPorMascota(widget.mascotaSeleccionadaIdHistorial);
      print("📜 Historial médico obtenido: $historial");

      // 2️⃣ Si no existe, crear uno nuevo
      if (historial == null) {
        print("⚠️ No se encontró historial médico para esta mascota. Creando uno nuevo...");

        HistorialMedico nuevoHistorial = HistorialMedico(
          mascotaId: widget.mascotaSeleccionadaIdHistorial,
        );

        // Crear un nuevo historial médico
        await crearHistorialMedico(nuevoHistorial);

        // Esperar un momento para que el historial se registre
        await Future.delayed(Duration(seconds: 5));  

        // Volver a obtener el historial médico después de crearlo
        historial = await obtenerHistorialMedicoPorMascota(widget.mascotaSeleccionadaIdHistorial);
        print("📜 Historial médico después de la creación: $historial");

        if (historial == null) {
          print("❌ Error: No se pudo obtener el historial médico.");
          return;
        }
      }

      // 3️⃣ Extraer el ID del historial médico (se obtiene después de crear el historial o si ya existe)
      int historialMedicoId = historial.id ?? 0;
      print("🆔 ID del historial médico obtenido: $historialMedicoId");

      // 4️⃣ Obtener la fecha actual
      String fechaAplicacion = DateTime.now().toIso8601String();

      // 5️⃣ Crear objeto de vacuna
      Vacuna nuevaVacuna = Vacuna(
        historialMedicoId: historialMedicoId,
        nombre: nombre,
        fechaAplicacion: fechaAplicacion,
        descripcion: descripcion,
      );

      print("📤 Enviando vacuna con JSON: ${json.encode(nuevaVacuna.toJson())}");

      // 6️⃣ Enviar la vacuna a la API
      await crearVacuna(nuevaVacuna);
    }


    void _enviarEnfermedad(String nombre, String descripcion) async {
    print("🚀 Iniciando proceso de enfermedad...");

    // 1️⃣ Obtener el historial médico de la mascota usando el ID de la mascota
    int mascotaId = widget.mascotaSeleccionadaIdHistorial; // ID de la mascota seleccionada
    HistorialMedico? historial = await obtenerHistorialMedicoPorMascota(mascotaId);
    print("📜 Historial médico obtenido: $historial");

    // 2️⃣ Si no existe, crear uno nuevo
    if (historial == null) {
      print("⚠️ No se encontró historial médico para esta mascota. Creando uno nuevo...");
      HistorialMedico nuevoHistorial = HistorialMedico(
        mascotaId: mascotaId,
      );
      await crearHistorialMedico(nuevoHistorial);

      // Esperar un momento para que el historial se registre
      await Future.delayed(Duration(seconds: 5));  

      // Volver a obtener el historial médico después de crearlo
      historial = await obtenerHistorialMedicoPorMascota(mascotaId);
      print("📜 Historial médico después de la creación: $historial");

      if (historial == null) {
        print("❌ Error: No se pudo obtener el historial médico.");
        return;
      }
    }

    // 3️⃣ Extraer el ID del historial médico
    int historialMedicoId = historial.id ?? 0;
    print("🆔 ID del historial médico obtenido: $historialMedicoId");
    String fechaAplicacion = DateTime.now().toIso8601String();

    // 4️⃣ Crear objeto de enfermedad
    Enfermedades nuevaEnfermedad = Enfermedades(
      historialMedicoId: historialMedicoId,
      nombre: nombre,
      descripcion: descripcion, 
      fechaAplicacion: fechaAplicacion,
    );

    print("📤 Enviando enfermedad con JSON: ${json.encode(nuevaEnfermedad.toJson())}");

    // 5️⃣ Enviar la enfermedad a la API
    await crearEnfermedad(nuevaEnfermedad);
  }


    void _enviarTratamiento(String nombre, String descripcion) async {
      print("🚀 Iniciando proceso de tratamiento...");

      // 1️⃣ Obtener el historial médico de la mascota usando el ID de la mascota
      int mascotaId = widget.mascotaSeleccionadaIdHistorial; // ID de la mascota seleccionada
      HistorialMedico? historial = await obtenerHistorialMedicoPorMascota(mascotaId);
      print("📜 Historial médico obtenido: $historial");

      // 2️⃣ Si no existe, crear uno nuevo
      if (historial == null) {
        print("⚠️ No se encontró historial médico para esta mascota. Creando uno nuevo...");
        HistorialMedico nuevoHistorial = HistorialMedico(
          mascotaId: mascotaId,
        );
        await crearHistorialMedico(nuevoHistorial);

        // Esperar un momento para que el historial se registre
        await Future.delayed(Duration(seconds: 5));  

        // Volver a obtener el historial médico después de crearlo
        historial = await obtenerHistorialMedicoPorMascota(mascotaId);
        print("📜 Historial médico después de la creación: $historial");

        if (historial == null) {
          print("❌ Error: No se pudo obtener el historial médico.");
          return;
        }
      }

      // 3️⃣ Extraer el ID del historial médico
      int historialMedicoId = historial.id ?? 0;
      print("🆔 ID del historial médico obtenido: $historialMedicoId");
      
      String fechaAplicacion = DateTime.now().toIso8601String();
      // 4️⃣ Crear objeto de tratamiento
      Tratamientos nuevoTratamiento = Tratamientos(
        historialMedicoId: historialMedicoId,
        nombre: nombre,
        descripcion: descripcion, 
        fechaAplicacion: fechaAplicacion,
      );

      print("📤 Enviando tratamiento con JSON: ${json.encode(nuevoTratamiento.toJson())}");

      // 5️⃣ Enviar el tratamiento a la API
      await crearTratamiento(nuevoTratamiento);
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
              child: Column(
                children: [
                  // Campo para el nombre de la vacuna
                  TextFormField(
                    controller: _vacunaController,
                    maxLength: 35,
                    style: GoogleFonts.fredoka(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Nombre de vacuna",
                      labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                      hintText: "Ejemplo: Parvovirus",
                      hintStyle: GoogleFonts.fredoka(color: const Color.fromARGB(110, 0, 0, 0), fontSize: 14),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 151, 2, 177),
                          width: 5.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el nombre de la vacuna';
                      }
                      return null;
                    },
                  ),
                  // Campo para la descripción de la vacuna
                  TextFormField(
                    controller: _descripcionVacunaController,
                    maxLength: 100,
                    style: GoogleFonts.fredoka(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Descripción",
                      labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                      hintText: "Ejemplo: Vacuna contra el parvovirus",
                      hintStyle: GoogleFonts.fredoka(color: const Color.fromARGB(110, 0, 0, 0), fontSize: 14),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 151, 2, 177),
                          width: 5.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una descripción';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_globalKey1.currentState?.validate() ?? false) {
                    // Extraer nombre y descripción
                    String nombreVacuna = _vacunaController.text;
                    String descripcionVacuna = _descripcionVacunaController.text;

                    // Llamar al método para enviar la vacuna
                    _enviarVacuna(nombreVacuna, descripcionVacuna);

                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Column(
                          children: [
                            Icon(Icons.check, color: const Color.fromARGB(255, 30, 101, 33), size: 65),
                            Text(
                              "¡Vacuna agregada con éxito!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 77, 61)),
                            ),
                          ],
                        ),
                        backgroundColor: const Color.fromARGB(255, 169, 211, 193),
                      ),
                    );

                    // Cerrar el dialogo
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  "Guardar",
                  style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103)),
                ),
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
            child: Column(
              children: [
                // Campo para el nombre de la enfermedad
                TextFormField(
                  controller: _enfermedadesController,
                  maxLength: 35,
                  style: GoogleFonts.fredoka(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Enfermedades",
                    labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                    hintText: "Ejemplo: Espiroqueta",
                    hintStyle: GoogleFonts.fredoka(color: const Color.fromARGB(110, 0, 0, 0), fontSize: 14),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 151, 2, 177),
                        width: 5.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el nombre de la enfermedad';
                    }
                    return null;
                  },
                ),
                // Campo para la descripción de la enfermedad
                TextFormField(
                  controller: _descripcionEnfermedadController,
                  maxLength: 100,
                  style: GoogleFonts.fredoka(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Descripción",
                    labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                    hintText: "Ejemplo: Enfermedad bacteriana",
                    hintStyle: GoogleFonts.fredoka(color: const Color.fromARGB(110, 0, 0, 0), fontSize: 14),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 151, 2, 177),
                        width: 5.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una descripción';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_globalKey2.currentState?.validate() ?? false) {
                  // Extraer nombre y descripción de la enfermedad
                  String nombreEnfermedad = _enfermedadesController.text;
                  String descripcionEnfermedad = _descripcionEnfermedadController.text;

                  // Llamar al método para enviar la enfermedad
                  _enviarEnfermedad(nombreEnfermedad, descripcionEnfermedad);

                  // Mostrar mensaje de éxito
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Column(
                        children: [
                          Icon(Icons.check, color: const Color.fromARGB(255, 30, 101, 33), size: 65),
                          Text(
                            "¡Enfermedad agregada con éxito!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 77, 61)),
                          ),
                        ],
                      ),
                      backgroundColor: const Color.fromARGB(255, 169, 211, 193),
                    ),
                  );

                  // Cerrar el dialogo
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Guardar",
                style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103)),
              ),
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
            child: Column(
              children: [
                // Campo para el nombre del tratamiento
                TextFormField(
                  controller: _tratamientoController,
                  maxLength: 35,
                  style: GoogleFonts.fredoka(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Tratamiento",
                    labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                    hintText: "Ejemplo: Terapia huesal",
                    hintStyle: GoogleFonts.fredoka(color: const Color.fromARGB(110, 0, 0, 0), fontSize: 14),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 151, 2, 177),
                        width: 5.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el nombre del tratamiento';
                    }
                    return null;
                  },
                ),
                // Campo para la descripción del tratamiento
                TextFormField(
                  controller: _descripcionTratamientoController,
                  maxLength: 100,
                  style: GoogleFonts.fredoka(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Descripción",
                    labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                    hintText: "Ejemplo: Tratamiento para aliviar el dolor",
                    hintStyle: GoogleFonts.fredoka(color: const Color.fromARGB(110, 0, 0, 0), fontSize: 14),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 151, 2, 177),
                        width: 5.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una descripción';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_globalKey3.currentState?.validate() ?? false) {
                  // Extraer nombre y descripción del tratamiento
                  String nombreTratamiento = _tratamientoController.text;
                  String descripcionTratamiento = _descripcionTratamientoController.text;

                  // Llamar al método para enviar el tratamiento
                  _enviarTratamiento(nombreTratamiento, descripcionTratamiento);

                  // Mostrar mensaje de éxito
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Column(
                        children: [
                          Icon(Icons.check, color: const Color.fromARGB(255, 30, 101, 33), size: 65),
                          Text(
                            "¡Tratamiento agregado con éxito!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 77, 61)),
                          ),
                        ],
                      ),
                      backgroundColor: const Color.fromARGB(255, 169, 211, 193),
                    ),
                  );

                  // Cerrar el dialogo
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Guardar",
                style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103)),
              ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Vacunas",
                                  style: GoogleFonts.fredoka(
                                      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => verVacunas(
                                                    idMascotaSeleccionadaParaHistorial:
                                                        widget.mascotaSeleccionadaIdHistorial,
                                                  )),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Ver todo",
                                            style: GoogleFonts.fredoka(
                                              color: const Color.fromARGB(255, 83, 68, 141),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidthConnstrain * 0.025,
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Color.fromARGB(255, 83, 68, 141),
                                          ),
                                        ],
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
                                children: List.generate(
                                    _filtrarVacunas.length + (_isLoadingVacunas ? 1 : 0), (index) {
                                  if (index == _filtrarVacunas.length) {
                                    // Mostrar el indicador de carga si estamos esperando más datos
                                    return _isLoadingVacunas
                                        ? Center(child: CircularProgressIndicator())
                                        : SizedBox.shrink();
                                  }

                                  final vacunas = _filtrarVacunas[index];
                                  print("datos aver: ${_filtrarVacunas.length}");
                                  print("datos recor: ${vacunas.nombre}");

                                  return Container(
                                    margin: EdgeInsets.all(8),
                                    width: MediaQuery.of(context).size.width * 0.4, // Ajusta según lo necesario
                                    height: MediaQuery.of(context).size.height * 0.075, // Ajusta para mostrar nombre y descripción
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Mostrar el nombre de la vacuna
                                          Text(
                                            vacunas.nombre,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredoka(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 5),
                                          // Mostrar la descripción de la vacuna
                                          Text(
                                            vacunas.descripcion, // Aquí se usa descripción de la vacuna
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredoka(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
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
                                  color: Color.fromARGB(255, 169, 211, 193),
                                ),
                                child: GestureDetector(
                                  onTap: _addVacuna,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Añadir vacuna",
                                        style: GoogleFonts.fredoka(
                                          color: const Color(0xFF004D3A),
                                          fontSize: MediaQuery.of(context).size.height * 0.016,
                                        ),
                                      ),
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
                          vertical: MediaQuery.of(context).size.height * 0.01,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Enfermedades",
                                  style: GoogleFonts.fredoka(
                                      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => verEnfermedades(
                                                    idMascotaSeleccionadaParaHistorial:
                                                        widget.mascotaSeleccionadaIdHistorial,
                                                  )),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Ver todo",
                                            style: GoogleFonts.fredoka(
                                              color: const Color.fromARGB(255, 83, 68, 141),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidthConnstrain * 0.025,
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Color.fromARGB(255, 83, 68, 141),
                                          ),
                                        ],
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
                                children: List.generate(
                                    _filtrarEnfermedades.length + (_isLoadingEnfermedades ? 1 : 0), (index) {
                                  if (index == _filtrarEnfermedades.length) {
                                    // Mostrar el indicador de carga si estamos esperando más datos
                                    return _isLoadingEnfermedades
                                        ? Center(child: CircularProgressIndicator())
                                        : SizedBox.shrink();
                                  }

                                  final enfermedad = _filtrarEnfermedades[index];
                                  print("Datos de la enfermedad: ${_filtrarEnfermedades.length}");
                                  print("Nombre de la enfermedad: ${enfermedad.nombre}");

                                  return Container(
                                    margin: EdgeInsets.all(8),
                                    width: MediaQuery.of(context).size.width * 0.4, // Ajusta según lo necesario
                                    height: MediaQuery.of(context).size.height * 0.075, // Ajusta para mostrar nombre y descripción
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Mostrar el nombre de la enfermedad
                                          Text(
                                            enfermedad.nombre,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredoka(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 5),
                                          // Mostrar la descripción de la enfermedad
                                          Text(
                                            enfermedad.descripcion, // Aquí se usa descripción de la enfermedad
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredoka(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
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
                                  color: Color.fromARGB(255, 169, 211, 193),
                                ),
                                child: GestureDetector(
                                  onTap: _addEnfermedades,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Añadir enfermedades",
                                        style: GoogleFonts.fredoka(
                                          color: const Color(0xFF004D3A),
                                          fontSize: MediaQuery.of(context).size.height * 0.016,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward)
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Tratamientos",
                                  style: GoogleFonts.fredoka(
                                      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => verTratamientos(
                                                    idMascotaSeleccionadaParaHistorial:
                                                        widget.mascotaSeleccionadaIdHistorial,
                                                  )),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Ver todo",
                                            style: GoogleFonts.fredoka(
                                              color: const Color.fromARGB(255, 83, 68, 141),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidthConnstrain * 0.025,
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Color.fromARGB(255, 83, 68, 141),
                                          ),
                                        ],
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
                                children: List.generate(
                                    _filtrarTratamientos.length + (_isLoadingTratamientos ? 1 : 0), (index) {
                                  if (index == _filtrarTratamientos.length) {
                                    // Mostrar el indicador de carga si estamos esperando más datos
                                    return _isLoadingTratamientos
                                        ? Center(child: CircularProgressIndicator())
                                        : SizedBox.shrink();
                                  }

                                  final tratamiento = _filtrarTratamientos[index];
                                  print("Datos de tratamiento: ${_filtrarTratamientos.length}");
                                  print("Nombre de tratamiento: ${tratamiento.nombre}");

                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.4, // Ajusta según lo necesario
                                    height: MediaQuery.of(context).size.height * 0.075, // Ajusta para mostrar nombre y descripción
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Mostrar el nombre del tratamiento
                                          Text(
                                            tratamiento.nombre,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredoka(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 5),
                                          // Mostrar la descripción del tratamiento
                                          Text(
                                            tratamiento.descripcion, // Aquí se usa la descripción del tratamiento
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredoka(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
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
                                  color: Color.fromARGB(255, 169, 211, 193),
                                ),
                                child: GestureDetector(
                                  onTap: _addTratamientos,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Añadir tratamientos",
                                        style: GoogleFonts.fredoka(
                                          color: const Color(0xFF004D3A),
                                          fontSize: MediaQuery.of(context).size.height * 0.016,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward)
                                    ],
                                  ),
                                ),
                              ),
                            ),
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