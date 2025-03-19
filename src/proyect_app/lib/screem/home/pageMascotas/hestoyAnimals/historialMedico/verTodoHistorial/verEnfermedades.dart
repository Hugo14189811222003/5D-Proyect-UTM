import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/Apis/HistorialMedico/apiEnfermedad/enfermedad.dart';
import 'package:proyect_app/Apis/HistorialMedico/apiMascotaHistorialMedico.dart';
import 'package:proyect_app/Apis/HistorialMedico/apiVacuna/vacuna.dart';
import 'package:proyect_app/Apis/HistorialMedico/apiHistorialMedico.dart';
import 'package:proyect_app/models/HistorialMedico/modeloEnfermedad/enfermedad.dart';
import 'package:proyect_app/models/HistorialMedico/modeloHistorialMedico.dart';
import 'package:proyect_app/models/HistorialMedico/modeloVacuna/postVacuna.dart';

class verEnfermedades extends StatefulWidget {
  final idMascotaSeleccionadaParaHistorial;
  const verEnfermedades({super.key, this.idMascotaSeleccionadaParaHistorial});

  @override
  State<verEnfermedades> createState() => _verEnfermedadesState();
}

class _verEnfermedadesState extends State<verEnfermedades> {
  GlobalKey<FormState> _globalKeyVacuna = GlobalKey<FormState>();
  ScrollController _scrollControllerVacuna = ScrollController();
  List<Enfermedades> _historialEnfermedades = [];
  bool _isLoadingVacuna = false;

  // Variables para el formulario de edición
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  int? _vacunaId;

  @override
  void initState() {
    super.initState();
    _cargarHistorialVacuna();
  }

  // Función para cargar las vacunas del historial médico de la mascota
  Future<void> _cargarHistorialVacuna() async {
  if (_isLoadingVacuna) return; // Evita llamadas múltiples mientras está cargando

  setState(() {
    _isLoadingVacuna = true;
  });

  try {
    // 1️⃣ Obtener el historial médico de la mascota usando el ID de la mascota
    int mascotaId = widget.idMascotaSeleccionadaParaHistorial; // ID de la mascota seleccionada
    print("📌 Intentando obtener historial médico para la mascota con ID $mascotaId...");

    // Usamos la función para obtener el historial médico por ID de la mascota
    HistorialMedico? historial = await obtenerHistorialMedicoPorMascota(mascotaId);

    if (historial == null) {
      print("⚠️ No se encontró historial médico para esta mascota.");
      return;
    }

    print("✅ Historial encontrado: ${historial.id}");

    // 2️⃣ Obtener vacunas usando el ID del historial médico
    final List<Enfermedades> enfermedad = await obtenerEnfermedades(historial.id ?? 0);

    if (enfermedad.isEmpty) {
      print("⚠️ No se encontraron vacunas registradas.");
    } else {
      print("💉 Se encontraron ${enfermedad.length} vacunas.");
    }

    // 3️⃣ Actualizar la lista de vacunas en el estado
    setState(() {
      _historialEnfermedades = enfermedad;
    });
  } catch (err) {
    print("❌ Error al obtener registros de Vacunas: $err");
  } finally {
    setState(() {
      _isLoadingVacuna = false;
    });
  }
}


  // Función de edición para actualizar los datos de la vacuna
  Future<void> _editarVacuna(Enfermedades enfermedad) async {
    print("🔍 ID de la vacuna antes de asignar: ${enfermedad.id}");
    setState(() {
      if (enfermedad.id != null) {
        _vacunaId = enfermedad.id; // Guardamos el id de la vacuna que se está editando
      } else {
        print("⚠️ El ID de la vacuna es nulo, no se puede actualizar.");
      }
      _nombreController.text = enfermedad.nombre;
      _descripcionController.text = enfermedad.descripcion;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Enfermedad', style: GoogleFonts.fredoka()),
          content: Form(
            key: _globalKeyVacuna,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre de la Vacuna'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
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
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String fechaAplicacion = DateTime.now().toIso8601String();
                if (_globalKeyVacuna.currentState?.validate() ?? false) {
                  if (_vacunaId == null) {
                    // Si el ID de la vacuna es nulo, muestra un mensaje de error
                    print("⚠️ El ID de la vacuna es nulo, no se puede actualizar.");
                    return; // Evita llamar a la función de actualización
                  }

                  // Crear el objeto Vacuna actualizado
                  EnfermedadPut vacunaActualizada = EnfermedadPut(
                    id: _vacunaId!,
                    nombre: _nombreController.text,
                    descripcion: _descripcionController.text,
                    historialMedicoId: widget.idMascotaSeleccionadaParaHistorial, 
                    fechaAplicacion: fechaAplicacion, 
                  );

                  if (_vacunaId == null || _vacunaId! <= 0) {
                    print("⚠️ El ID de la vacuna es inválido o nulo, no se puede actualizar.");
                    return;
                  }

                  // Llamamos a la función para actualizar la vacuna en la API
                  await actualizarEnfermedad(_vacunaId!, vacunaActualizada);

                  // Cerrar el formulario de edición
                  Navigator.of(context).pop();
                  _cargarHistorialVacuna(); // Recargar las vacunas después de la actualización
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarEnfermedad(int enfermedadId) async {
    print("🗑️ Intentando eliminar la vacuna con ID: $enfermedadId...");

    try {
      await eliminarEnfermedad(enfermedadId);
      setState(() {
        _historialEnfermedades.removeWhere((enfermedad) => enfermedad.id == enfermedadId);
      });
      print("✅ Vacuna eliminada correctamente.");
    } catch (err) {
      print("❌ Error al eliminar la vacuna: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    final queryWidth = MediaQuery.of(context).size.width;
    final queryHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 0, 132, 103),
        toolbarHeight: 70,
        title: Text("Vacunas", style: GoogleFonts.fredoka(color: Colors.white)),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollControllerVacuna,
                itemCount: _historialEnfermedades.length + (_isLoadingVacuna ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _historialEnfermedades.length) {
                    return _isLoadingVacuna
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox.shrink();
                  }

                  final enfermedad = _historialEnfermedades[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: queryWidth * 0.8,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 132, 103),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mostrar el nombre de la enfermedad
                          Text(
                            enfermedad.nombre,
                            style: GoogleFonts.fredoka(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: queryWidth * 0.04,
                            ),
                          ),
                          SizedBox(height: 10),

                          // Mostrar la descripción de la enfermedad con texto truncado si es necesario
                          Text(
                            enfermedad.descripcion,
                            style: GoogleFonts.fredoka(
                              color: const Color.fromARGB(255, 120, 120, 120),
                              fontSize: queryWidth * 0.035,
                            ),
                            maxLines: 3, // Limita el texto a 3 líneas
                            overflow: TextOverflow.ellipsis, // Añadir "..." si el texto excede
                          ),
                          SizedBox(height: 10),

                          // Fila de botones (editar y eliminar)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Botón de editar
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.green),
                                onPressed: () {
                                  print("📝 Enfermedad seleccionada desde ListView: ${enfermedad.toJson()}");
                                  _editarVacuna(enfermedad); // Llamar a la función de edición
                                },
                              ),
                              SizedBox(width: 10),

                              // Botón de eliminar
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _eliminarEnfermedad(enfermedad.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );

                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
