import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/Apis/apiHistorialMedico.dart';
import 'package:proyect_app/models/modeloHistorialMedico.dart';

class verEnfermedades extends StatefulWidget {
  final idMascotaSeleccionadaParaHistorial;
  const verEnfermedades({super.key, this.idMascotaSeleccionadaParaHistorial});

  @override
  State<verEnfermedades> createState() => _verEnfermedadesState();
}

class _verEnfermedadesState extends State<verEnfermedades> {
  GlobalKey<FormState> _globalKeyVacuna = GlobalKey<FormState>();
  ScrollController _scrollControllerVacuna = ScrollController();
  List<getHistorialMedico> _historialVacuna = [];
  List<getHistorialMedico> _filtrarHistorialVacunas = [];
  bool _isLoadingVacuna = false;
  int numPagina = 1;

  @override
  void initState() {
    super.initState();
    _cargarHistorialVacuna();
    _scrollControllerVacuna.addListener(() {
      if(_scrollControllerVacuna.position.pixels >= _scrollControllerVacuna.position.maxScrollExtent - 50 && !_isLoadingVacuna){
        _cargarHistorialVacuna();
      }
    });
  }

  Future<void> _cargarHistorialVacuna() async {
    if(_isLoadingVacuna) return;

    setState(() {
      _isLoadingVacuna = true;
    });

    try{
      final getResponseApiHistorialMedico = await getHistorialMedicoApi(numPagina);

      if(getResponseApiHistorialMedico.isNotEmpty) {
        final getHistorialMascotaId = getResponseApiHistorialMedico.where((element) {
          return element.mascotaId == widget.idMascotaSeleccionadaParaHistorial;
        }).toList();

        if(getHistorialMascotaId.isEmpty) return;

        setState(() {
          _historialVacuna.addAll(getHistorialMascotaId);
          _filtrarHistorialVacunas = _historialVacuna;
          numPagina ++;
        });
      }
    } catch (err) {
      print("Error al cargar los datos: ${err}");
    } finally {
      setState(() {
        _isLoadingVacuna = false;
      });
    }
  }

  Future<void> _addSesionPut(getHistorialMedico historial) async {
    TextEditingController vacunaController = TextEditingController(text: historial.vacunas);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Actualizar sesión",
            style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103)),
            ),
          content: Form(
            key: _globalKeyVacuna,
            child: TextFormField(
              controller: vacunaController,
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
                onPressed: () async {
                  postHistorialMedico historialActualizado = postHistorialMedico(
                  mascotaId: historial.mascotaId,
                  vacunas: vacunaController.text,
                  enfermedades: historial.enfermedades,
                  tratamiento: historial.tratamientos
                );

                await actualizarHistorialMedico(historial.id, historialActualizado);

                setState(() {
                  _historialVacuna.clear();
                  _filtrarHistorialVacunas.clear();
                  numPagina = 1; // Reiniciamos la paginación
                });

                _cargarHistorialVacuna();

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Datos actualizado con exito",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 255, 255, 255))
                    ),
                  )
                );
              },
              child: Text("Actualizar", style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103)),),
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
    final queryWidth = MediaQuery.of(context).size.width;
    final queryHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 0, 132, 103),
          toolbarHeight: 70,
          title: Text("Enfermedades", style: GoogleFonts.fredoka(color: Colors.white),),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollControllerVacuna,
                    itemCount: _filtrarHistorialVacunas.length + (_isLoadingVacuna ? 1 : 0),
                    itemBuilder: (context, index) {
                      if(index == _filtrarHistorialVacunas.length){
                        return _isLoadingVacuna
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox.shrink();
                      }
                      final historialMedicoVacuna = _filtrarHistorialVacunas[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: queryWidth * 0.8,
                          height: queryHeight * 0.15,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: const Color.fromARGB(255, 0, 132, 103),
                              width: 3
                            )
                          ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  historialMedicoVacuna.enfermedades, 
                                  style: GoogleFonts.fredoka(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: queryWidth * 0.04
                                  )
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _addSesionPut(historialMedicoVacuna);
                                  },
                                  child: Container(
                                    width: queryWidth * 0.15,
                                    height: queryHeight * 0.08,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color.fromARGB(255, 170, 212, 194)
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: const Color.fromARGB(255, 0, 77, 58),
                                      size: 25,
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      );
                    }
                  ),
                ),
            ],
          ),
        )
    );
  }
}