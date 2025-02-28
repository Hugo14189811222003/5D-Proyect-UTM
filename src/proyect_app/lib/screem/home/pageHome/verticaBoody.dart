import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/Apis/recordatorioApi.dart';
import 'package:proyect_app/models/recordatorioModelo.dart';
import 'package:proyect_app/screem/home/porcentaje/circlePorcentaje.dart';
import 'package:proyect_app/screem/home/porcentaje/circlePorcentaje1.dart';
import 'package:proyect_app/screem/home/porcentaje/circlePorcentaje2.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class verticalBody extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final bool screenHorizontal;
  

  const verticalBody({super.key, required this.screenWidth, required this.screenHeight, required this.screenHorizontal});

  @override
  State<verticalBody> createState() => _verticalBodyState();
}

class _verticalBodyState extends State<verticalBody> {
  
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _tipoController = TextEditingController();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _frecuenciaController = TextEditingController();
  TextEditingController _horaController = TextEditingController();
  final int idContainer = 11;

  final ScrollController _scroolController = ScrollController();
  List<RecordatorioGet> _recordatorios = [];
  List<RecordatorioGet> _filtrarRecordotarios = [];
  int _paginaActual = 1;
  bool _isloading = false;
  Timer? _timer;
  
  @override
  initState(){
    super.initState();
    loadUserData();
    obtenerRegistros();
    _scroolController.addListener(() {
      if(_scroolController.position.pixels == _scroolController.position.maxScrollExtent && !_isloading) {
        obtenerRegistros();
      };
    });
      _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      await checkForUpdates();
    });
  }


  


  int? mascotaId;

    Future<void> checkForUpdates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? newIdString = prefs.getString('idPerro');
    int? newMascotaId = newIdString != null ? int.tryParse(newIdString) : null;

    if (newMascotaId != mascotaId) { // Solo actualiza si cambió
      print("⚡ Cambio detectado en idPerro: $newMascotaId");
      setState(() {
        mascotaId = newMascotaId;
        _recordatorios = []; // Vaciar lista antes de cargar nuevos datos
        _filtrarRecordotarios = [];
        _paginaActual = 1;
      });

      await obtenerRegistros();
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

  Future<void> obtenerRegistros() async {
    setState(() {
      _isloading = true;
    });

    try{
      final obtencionResponse = await ObtenerRecordatorios(_paginaActual);
      print("📡 Respuesta de la API: ${obtencionResponse}");
      
      if(obtencionResponse.isNotEmpty && mascotaId != null){

        print("🐶 ID de mascota guardado: ${mascotaId}");

        for (var element in obtencionResponse) {
          print("🔍 Comparando: ${element.mascotaId} == $mascotaId");
        }

        final obtenerRecordatorioPorUsuario1 = obtencionResponse.where((element) {
          return element.mascotaId == mascotaId;  // Filtrar solo los recordatorios que corresponden al mascotaId
        }).toList();

        print("📋 Lista filtrada: ${obtenerRecordatorioPorUsuario1}");

        setState(() {
          _recordatorios.addAll(obtenerRecordatorioPorUsuario1);
          _filtrarRecordotarios = _recordatorios;
          _paginaActual++;
        });
      } else {
        print("Problemas al anexar los datos");
      }
    } catch(err) {
      print("❌ Error al obtener registros: $err");
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  } 
  Future<void> insertaRecordatorio() async {
    if(mascotaId != null && mascotaId! > 0){
      formularioDePost();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text("Favor de registrar o seleccionar por lo menos una mascota", 
              style: GoogleFonts.fredoka(
                color: const Color.fromARGB(255, 0, 132, 103),
                fontSize: 18
              ),
              textAlign: TextAlign.center,
              ),
              
            ),
            content: Icon(Icons.pets_outlined, color: const Color.fromARGB(255, 0, 132, 103), size: 130,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ok"),
              )
            ],
          );
        },
      );
    }
    
  }

  Future<void> updateRecordatorio(int id) async {
      return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Actualizar recordatorío"),
          content: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextFormField(
                              controller: _tipoController,
                              style: GoogleFonts.fredoka(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Tipo", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                                hintText: "Ejemplo: Vacuna",
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
                              validator: (value) {
                                return(_tipoController.text.isNotEmpty) ? null : "Favor de ingresar el tipo";
                              },
                            ),
                            SizedBox(height: 15,),
                            TextFormField(
                              controller: _nombreController,
                              style: GoogleFonts.fredoka(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Nombre", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                                hintText: "Ejemplo: Piroflox",
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
                              validator: (value) {
                                return(_nombreController.text.isNotEmpty) ? null : "Favor de ingresar el nombre";
                              },
                            ),
                            SizedBox(height: 15,),
                            TextFormField(
                              controller: _descripcionController,
                              style: GoogleFonts.fredoka(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Descripcion", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                                hintText: "Ejemplo: Tratamiento de infección",
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
                              validator: (value) {
                                return(_descripcionController.text.isNotEmpty) ? null : "Favor de ingresar la descripcion";
                              },
                            ),
                            SizedBox(height: 15,),
                            TextFormField(
                              controller: _frecuenciaController,
                              style: GoogleFonts.fredoka(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Frecuencia", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                                hintText: "Ejemplo: Anual",
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
                              validator: (value) {
                                return(_frecuenciaController.text.isNotEmpty) ? null : "Favor de ingresar el tipo";
                              },
                            ),
                            SizedBox(height: 15,),
                            TextFormField(
                              controller: _horaController,
                              style: GoogleFonts.fredoka(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Hora", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                                hintText: "Ejemplo: 1:00 pm",
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
                              validator: (value) {
                                return(_horaController.text.isNotEmpty) ? null : "Favor de ingresar la hora";
                              },
                            ),
                            
                          ],
                        ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if(_globalKey.currentState!.validate()){
                  String tipo = _tipoController.text;
                  String nombre = _nombreController.text;
                  String descripcion = _descripcionController.text;
                  String frecuencia = _frecuenciaController.text;
                  String horaText = _horaController.text;

                  try{
                    DateTime hora = DateFormat("HH:mm").parseStrict(horaText);

                    RecordatorioUpdate recordatorioUpdate = RecordatorioUpdate(
                      id: id,
                      tipo: tipo,
                      nombre: nombre,
                      descripcion: descripcion,
                      frecuencia: frecuencia,
                      hora: hora
                    );

                    await updateRecordatorios(recordatorioUpdate, id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Dato actualizado con exito"),
                        backgroundColor: Colors.green,
                      )
                    );
                    Navigator.of(context).pop();
                    _tipoController.clear();
                    _nombreController.clear();
                    _descripcionController.clear();
                    _frecuenciaController.clear();
                    _horaController.clear();
                  } catch (err) {

                  }
                  
                }
              },
              child: Text("Guardar"),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> formularioDePost() {
    return formularioRegisterRecordatorioPost();
  }

  Future<dynamic> formularioRegisterRecordatorioPost() {
    return showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: Text("Ingresar el nuevo recordatorio"),
      content: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextFormField(
                          controller: _tipoController,
                          style: GoogleFonts.fredoka(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Tipo", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                            hintText: "Ejemplo: Vacuna",
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
                          validator: (value) {
                            return(_tipoController.text.isNotEmpty) ? null : "Favor de ingresar el tipo";
                          },
                        ),
                        SizedBox(height: 15,),
                        TextFormField(
                          controller: _nombreController,
                          style: GoogleFonts.fredoka(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Nombre", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                            hintText: "Ejemplo: Piroflox",
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
                          validator: (value) {
                            return(_nombreController.text.isNotEmpty) ? null : "Favor de ingresar el nombre";
                          },
                        ),
                        SizedBox(height: 15,),
                        TextFormField(
                          controller: _descripcionController,
                          style: GoogleFonts.fredoka(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Descripcion", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                            hintText: "Ejemplo: Tratamiento de infección",
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
                          validator: (value) {
                            return(_descripcionController.text.isNotEmpty) ? null : "Favor de ingresar la descripcion";
                          },
                        ),
                        SizedBox(height: 15,),
                        TextFormField(
                          controller: _frecuenciaController,
                          style: GoogleFonts.fredoka(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Frecuencia", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                            hintText: "Ejemplo: Anual",
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
                          validator: (value) {
                            return(_frecuenciaController.text.isNotEmpty) ? null : "Favor de ingresar el tipo";
                          },
                        ),
                        SizedBox(height: 15,),
                        TextFormField(
                          controller: _horaController,
                          style: GoogleFonts.fredoka(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Hora", labelStyle: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),
                            hintText: "Ejemplo: 1:00 pm",
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
                          validator: (value) {
                            return(_horaController.text.isNotEmpty) ? null : "Favor de ingresar la hora";
                          },
                        ),
                        
                      ],
                    ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_globalKey.currentState!.validate()) {
              String tipo = _tipoController.text;
              String nombre = _nombreController.text;
              String descripcion = _descripcionController.text;
              String frecuencia = _frecuenciaController.text;
              String horaTexto = _horaController.text;

              try {
                DateTime hora = DateFormat("HH:mm").parseStrict(horaTexto);
                int? mascotaIdOnly = mascotaId;
                print("Revision de dato onlymascota: ${mascotaIdOnly}");

                // Crear el nuevo Recordatorio con la hora formateada
                Recordatorio newRecordatorio = Recordatorio(
                  tipo: tipo,
                  nombre: nombre,
                  descripcion: descripcion,
                  frecuencia: frecuencia,
                  hora: hora,  // Usar la hora formateada
                  mascotaId: mascotaIdOnly ?? 0
                );

                await crearRecordatorios(newRecordatorio);

                print("Enviando recordatorio con mascotaId: ${newRecordatorio.mascotaId}");


                setState(() {
                _filtrarRecordotarios.add(
                  RecordatorioGet(
                    tipo: newRecordatorio.tipo,
                    nombre: newRecordatorio.nombre,
                    descripcion: newRecordatorio.descripcion,
                    frecuencia: newRecordatorio.frecuencia,
                    hora: newRecordatorio.hora,
                    mascotaId: newRecordatorio.mascotaId,
                  ),
                );
              });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color.fromARGB(255, 19, 141, 0),
                    content: Text("dato enviado"),
                  ),
                );

                Navigator.of(context).pop();
                _tipoController.clear();
                _nombreController.clear();
                _frecuenciaController.clear();
                _horaController.clear();
                _descripcionController.clear();
              } catch (err) {
                print('Error en el formato de la hora: ${err}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                    content: Text("Error al guardar datos: ${err}"),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                  content: Text("Error al guardar datos"),
                ),
              );
            }
          },
          child: Text("Guardar"),
        )
      ],
    );
  },
);
  }

  

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
              child: Container(
              width: widget.screenWidth,
              height: widget.screenHeight * 1.22,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 237, 237),
              ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidthBuild = constraints.maxWidth;
                    final screenHeightBuild = constraints.maxHeight;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          width: widget.screenHorizontal ? widget.screenWidth * 0.4 : widget.screenWidth,
                          child: Text("Monitoreo de salud", style: GoogleFonts.fredoka(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w600)),
                        ),
                        Porcentaje(),
                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidthBuild * 0.05),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          height: widget.screenHeight * 0.03,
                          width: widget.screenWidth,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(0, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Recordatorios", style: GoogleFonts.fredoka(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),),
                              GestureDetector(
                                onTap: insertaRecordatorio,
                                child: Icon(Icons.add, size: 28, color: const Color.fromARGB(255, 0, 77, 58)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidthBuild * 0.05),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          height: widget.screenHeight * 0.08,
                          width: widget.screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(15, 0, 0, 0),
                                blurRadius: 10,
                                spreadRadius: 4,
                                offset: Offset(0, 0)
                              )
                            ]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Icon(Icons.arrow_back_ios),
                                Text('Marzo', style: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),),
                                ],
                              ),
                              Text('Abril', style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 77, 58), fontSize: 26, fontWeight: FontWeight.w600),),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Mayo', style: GoogleFonts.fredoka(color: Colors.black, fontSize: 18),),
                                  Icon(Icons.arrow_forward_ios),
                                ],
                              )
                              
                              
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final screenConstraintsWidth = constraints.maxWidth;
                            final screenConstraintsHeight = constraints.maxHeight;
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: screenWidthBuild * 0.05),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              height: widget.screenHeight * 0.11,
                              width: widget.screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          final screenConstraintsHeighth = constraints.maxHeight;
                                          return Container(
                                            margin: EdgeInsets.all(10),
                                            height: screenConstraintsHeight * 0.8,
                                            width: screenConstraintsWidth * 0.20,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 227, 223, 255),
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('3', style: GoogleFonts.fredoka(color: Colors.black, fontSize: screenConstraintsHeighth * 0.3),),
                                                Text('Vie', style: GoogleFonts.fredoka(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          final screenConstraintsHeighth = constraints.maxHeight;
                                          return Container(
                                            margin: EdgeInsets.all(10),
                                            height: screenConstraintsHeight * 0.8,
                                            width: screenConstraintsWidth * 0.20,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 227, 223, 255),
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('4', style: GoogleFonts.fredoka(color: Colors.black, fontSize: screenConstraintsHeighth * 0.3),),
                                                Text('Sab', style: GoogleFonts.fredoka(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          final screenConstraintsHeighth = constraints.maxHeight;
                                          return Container(
                                            margin: EdgeInsets.all(10),
                                            height: screenConstraintsHeight * 0.8,
                                            width: screenConstraintsWidth * 0.20,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 227, 223, 255),
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('5', style: GoogleFonts.fredoka(color: Colors.black, fontSize: screenConstraintsHeighth * 0.3),),
                                                Text('Dom', style: GoogleFonts.fredoka(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          final screenConstraintsHeighth = constraints.maxHeight;
                                          return Container(
                                            margin: EdgeInsets.all(10),
                                            height: screenConstraintsHeight * 0.8,
                                            width: screenConstraintsWidth * 0.20,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 83, 68, 141),
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('6', style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 255, 244, 244), fontSize: screenConstraintsHeighth * 0.3),),
                                                Text('Lun', style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 14))
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          final screenConstraintsHeighth = constraints.maxHeight;
                                          return Container(
                                            margin: EdgeInsets.all(10),
                                            height: screenConstraintsHeight * 0.8,
                                            width: screenConstraintsWidth * 0.20,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 227, 223, 255),
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('7', style: GoogleFonts.fredoka(color: Colors.black, fontSize: screenConstraintsHeighth * 0.3),),
                                                Text('Mar', style: GoogleFonts.fredoka(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          final screenConstraintsHeighth = constraints.maxHeight;
                                          return Container(
                                            margin: EdgeInsets.all(10),
                                            height: screenConstraintsHeight * 0.8,
                                            width: screenConstraintsWidth * 0.20,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 227, 223, 255),
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('8', style: GoogleFonts.fredoka(color: Colors.black, fontSize: screenConstraintsHeighth * 0.3),),
                                                Text('Mie', style: GoogleFonts.fredoka(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            );
                          },
                        ),
                        SizedBox(height: 20,),
                        Expanded(
                          child: Container(
                            
                            height: widget.screenHeight,
                            width: widget.screenWidth,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      controller: _scroolController,
                                      itemCount: _filtrarRecordotarios.length + (_isloading ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        if(index == _filtrarRecordotarios.length){
                                          return _isloading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink();
                                        }
                                        
                                        final recordatorios = _filtrarRecordotarios[index];
                                        print("datos aver: ${_filtrarRecordotarios.length}");
                                        print("datos recor: ${recordatorios.nombre}");
                                        return LayoutBuilder(
                                          builder: (context, constraints) {
                                            final widthConstraints = constraints.maxWidth;
                                            final heightConstraints = constraints.maxHeight;
                                            return Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                                              width: widget.screenWidth,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(255, 255, 255, 255),
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: const Color.fromARGB(255, 83, 68, 141),
                                                  width: 2.0
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 0,
                                                    spreadRadius: 4,
                                                    offset: Offset(1, 1)
                                                  )
                                                ]
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.circle, size: 75, color: Color.fromARGB(57, 0, 0, 0),),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.medication, color: Color.fromARGB(255, 0, 77, 58), size: 30,),
                                                          SizedBox(width: 5,),
                                                          Text(
                                                            recordatorios.hora != null 
                                                              ? DateFormat("HH:mm").format(recordatorios.hora!)  // Usamos '!' porque ya sabemos que no es null
                                                              : "Hora no disponible",  // Valor predeterminado si la hora es nula
                                                            style: GoogleFonts.fredoka(color: Colors.black, fontSize: 20),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(recordatorios.tipo.isNotEmpty ? recordatorios.tipo : "no hay tipo", style: GoogleFonts.fredoka(color: Colors.black, fontSize: 16),),
                                                          SizedBox(width: 8,),
                                                          Text("|", style: GoogleFonts.fredoka(color: Colors.black, fontSize: 16),),
                                                          SizedBox(width: 8,),
                                                          Text(recordatorios.nombre.isNotEmpty ? recordatorios.nombre : "no hay nombre", style: GoogleFonts.fredoka(color: Colors.black, fontSize: 16),)
                                                        ],
                                                      ),
                                                      Text(recordatorios.descripcion.isNotEmpty ? recordatorios.descripcion : "no hay descripción", style: GoogleFonts.fredoka(color: Colors.black, fontSize: 14), textAlign: TextAlign.center,)
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      updateRecordatorio(idContainer);
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(vertical: 25),
                                                      height: heightConstraints * 0.01,
                                                      width: widthConstraints * 0.13,
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromARGB(255, 204, 196, 255),
                                                        borderRadius: BorderRadius.circular(15),
                                                        boxShadow: [BoxShadow(
                                                          color: const Color.fromARGB(37, 0, 0, 0),
                                                          blurRadius: 5,
                                                          spreadRadius: 1,
                                                          offset: Offset(0, 0)
                                                        )]
                                                      ),
                                                      child: Icon(Icons.edit, color: const Color.fromARGB(255, 83, 68, 141),),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    ),
                                  ),
                                ],
                              ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ),
            
        );
      
  }

  LayoutBuilder Porcentaje() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenConstraintsHeightPorcen = constraints.maxHeight;
        final screenConstraintsWidthPorcen = constraints.maxWidth;
        return Container(
          padding: EdgeInsets.all(15),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: widget.screenHeight * 0.24,
                        width: widget.screenWidth,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(15, 0, 0, 0),
                              blurRadius: 10,
                              spreadRadius: 4,
                              offset: Offset(0, 0)
                            )
                          ]
                        ),
                        child: Row(
                          children: [
                            Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: widget.screenWidth * 0.25,
                                              height: widget.screenHeight * 0.12,
                                              child: circlePorce(),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Temperatura", style: GoogleFonts.fredoka(fontSize: widget.screenWidth *0.033))
                                          ],
                                        ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: widget.screenWidth * 0.25,
                                              height: widget.screenHeight * 0.12,
                                              child: circlePorce1(),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Pulso", style: GoogleFonts.fredoka(fontSize: widget.screenWidth *0.033))
                                          ],
                                        ),
                                      SizedBox(width: 10,),
                                      Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: widget.screenWidth * 0.25,
                                              height: widget.screenHeight * 0.12,
                                              child: circlePorce2(),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Respiración", style: GoogleFonts.fredoka(fontSize: widget.screenWidth *0.033))
                                          ],
                                        ),
                                    ],
                                  ),
                          ],
                        )
                      );
      },
    );
  }
}