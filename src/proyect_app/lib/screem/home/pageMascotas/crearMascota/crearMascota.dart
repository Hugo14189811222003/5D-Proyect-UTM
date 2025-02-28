import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyect_app/Apis/apiMascota.dart';
import 'package:proyect_app/models/modeloMascota.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Crearmascota extends StatefulWidget {
  final screenHeight;
  final screenWidth;
  const Crearmascota({super.key, this.screenHeight, this.screenWidth});

  @override
  State<Crearmascota> createState() => _CrearmascotaState();
}

class _CrearmascotaState extends State<Crearmascota> {
    File? _image;

    Future<void> _pickImage() async {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      
      });
    }
  }
  GlobalKey<FormState> _globalKeyForm1 = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _especieController = TextEditingController();
  TextEditingController _razaController = TextEditingController();
  TextEditingController _generoController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  TextEditingController _pesoController = TextEditingController();
  TextEditingController _tamanoController = TextEditingController();
  TextEditingController _fechaController = TextEditingController();
  final FocusNode focusNode_ = FocusNode();
  final FocusNode focusNode2_ = FocusNode();
  final FocusNode focusNode3_ = FocusNode();
  final FocusNode focusNode4_ = FocusNode();
  final FocusNode focusNode5_ = FocusNode();
  final FocusNode focusNode6_ = FocusNode();
  final FocusNode focusNode7_ = FocusNode();
  final FocusNode focusNode8_ = FocusNode();
  bool _isFocusName = false;
  bool _isFocusEspecie = false;
  bool _isFocusRaza = false;
  bool _isFocusGenero = false;
  bool _isFocusColor = false;
  bool _isFocusPeso = false;
  bool _isFocusTamano = false;
  bool _isFocusFechaDeNacimiento = false;

  @override
  void initState() {
    super.initState();
    focusNode_.addListener(() {
      setState(() {
        _isFocusName = focusNode_.hasFocus;
      });
    });
    focusNode2_.addListener(() {
      setState(() {
        _isFocusEspecie = focusNode2_.hasFocus;
      });
    });
    focusNode3_.addListener(() {
      setState(() {
        _isFocusRaza = focusNode3_.hasFocus;
      });
    });
    focusNode4_.addListener(() {
      setState(() {
        _isFocusGenero = focusNode4_.hasFocus;
      });
    });
    focusNode5_.addListener(() {
      setState(() {
        _isFocusColor = focusNode5_.hasFocus;
      });
    });
    focusNode6_.addListener(() {
      setState(() {
        _isFocusPeso = focusNode6_.hasFocus;
      });
    });
    focusNode7_.addListener(() {
      setState(() {
        _isFocusTamano = focusNode7_.hasFocus;
      });
    });
    focusNode8_.addListener(() {
      setState(() {
        _isFocusFechaDeNacimiento = focusNode8_.hasFocus;
      });
    });
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Fecha inicial
      firstDate: DateTime(1900), // Fecha más antigua seleccionable
      lastDate: DateTime(2101), // Fecha más futura seleccionable
    );

    if (pickedDate != null) {
      // Formato de la fecha
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        _fechaController.text = formattedDate; // Actualiza el campo con la fecha seleccionada.
        _isFocusFechaDeNacimiento = false; // Para desactivar el focus después de la selección
      });
    }
  }

  Future<void> inserMascota() async {
    if(_nameController.text.isEmpty || _especieController.text.isEmpty || _razaController.text.isEmpty || _generoController.text.isEmpty || _colorController.text.isEmpty || _pesoController.text.isEmpty || _tamanoController.text.isEmpty || _fechaController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 255, 191, 0),
          content: Column(
            children: [
              Icon(Icons.warning),
              Text("Por favor no dejar vacio ninguna casilla", style: GoogleFonts.fredoka(color: Colors.black))
            ],
          ),
        )
      );
    } else {
      if(_globalKeyForm1.currentState!.validate()){
        String nombre = _nameController.text;
        String fechaDeNacimiento = _fechaController.text;
        String especie = _especieController.text;
        String raza = _razaController.text;
        int peso = int.tryParse(_pesoController.text) ?? 0;
        DateFormat formato = DateFormat("dd-MM-yyyy");
        DateTime fechaNacimiento = formato.parse(fechaDeNacimiento);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userIdString = prefs.getString('id');
        int? userId = userIdString != null ? int.tryParse(userIdString) : null;
        print("ID Recuperado: ${userId}");
        
        PostMascota mascota = PostMascota(
          usuarioId: userId ?? 0,
          nombre: nombre,
          fechaNacimiento: fechaNacimiento,
          especie: especie,
          raza: raza,
          peso: peso,
          imagenURL: "https://th.bing.com/th/id/OIP.rI4-WtIPuAZERhJlUNk9IgHaE8?w=724&h=483&rs=1&pid=ImgDetMain"
        );

        await crearMascota(mascota);

          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 0, 114, 13),
            content: Column(
              children: [
                Text("Mascota registrada con exito", style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 255, 255, 255)))
              ],
            ),
          )
        );
        _nameController.clear();
        _especieController.clear();
        _razaController.clear();
        _generoController.clear();
        _colorController.clear();
        _pesoController.clear();
        _tamanoController.clear();
        _fechaController.clear();
      } else {
        print("Dato no mandado");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 132, 103),
        toolbarHeight: 70,
        title: Text("Añadir mascota", style: GoogleFonts.fredoka(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text("Añada a tu mascota", style: GoogleFonts.fredoka(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500)),
                SizedBox(height: 10,),
                Container(
                  width: (widget.screenWidth ?? MediaQuery.of(context).size.width) * 0.55,
                  height: (widget.screenHeight ?? MediaQuery.of(context).size.height) * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Ajusta el radio de los bordes
                    color: Colors.grey[300], // Color de fondo si no hay imagen
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
                          )
                        : null,
                  ),
                  child: _image == null
                      ? Icon(Icons.image, size: 50, color: Colors.grey[700]) // Ícono cuando no hay imagen
                      : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Seleccionar Foto', style: GoogleFonts.fredoka(color: Color.fromARGB(255, 0, 132, 103), fontWeight: FontWeight.w500),),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _globalKeyForm1,
                      child: Column(
                        children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: _isFocusName ? const Color.fromARGB(255, 226, 226, 226) : const Color.fromARGB(255, 255, 255, 255),
                                border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: TextFormField(
                                controller: _nameController,
                                focusNode: focusNode_,
                                style: TextStyle(),
                                decoration: InputDecoration(
                                  hintText: "Nombre",
                                  hintStyle: TextStyle(color: _isFocusName ? const Color.fromARGB(255, 72, 72, 72) : Color.fromARGB(255, 71, 71, 71)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 0.0),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isFocusName = true;
                                  });
                                },
                                validator: (value) {
                                  return(value != null) ? null : "Esta vacio, ingrese datos";
                                },
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: _isFocusEspecie ? const Color.fromARGB(255, 226, 226, 226) : const Color.fromARGB(255, 255, 255, 255),
                                border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: TextFormField(
                                controller: _especieController,
                                focusNode: focusNode2_,
                                style: TextStyle(),
                                decoration: InputDecoration(
                                  hintText: "Especie",
                                  hintStyle: TextStyle(color: _isFocusEspecie ? const Color.fromARGB(255, 72, 72, 72) : Color.fromARGB(255, 71, 71, 71)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 0.0),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isFocusEspecie = true;
                                  });
                                },
                                validator: (value) {
                                  return(value != null) ? null : "Esta vacio, ingrese datos";
                                },
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: _isFocusRaza ? const Color.fromARGB(255, 226, 226, 226) : const Color.fromARGB(255, 255, 255, 255),
                                border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: TextFormField(
                                controller: _razaController,
                                focusNode: focusNode3_,
                                style: TextStyle(),
                                decoration: InputDecoration(
                                  hintText: "Raza",
                                  hintStyle: TextStyle(color: _isFocusRaza ? const Color.fromARGB(255, 72, 72, 72) : Color.fromARGB(255, 71, 71, 71)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 0.0),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isFocusRaza = true;
                                  });
                                },
                                validator: (value) {
                                  return(value != null) ? null : "Esta vacio, ingrese datos";
                                },
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded( 
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: _isFocusGenero ? const Color.fromARGB(255, 226, 226, 226) : const Color.fromARGB(255, 255, 255, 255),
                                      border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: TextFormField(
                                      controller: _generoController,
                                      focusNode: focusNode4_,
                                      style: TextStyle(),
                                      decoration: InputDecoration(
                                        hintText: "Genero",
                                        hintStyle: TextStyle(color: _isFocusGenero ? const Color.fromARGB(255, 72, 72, 72) : Color.fromARGB(255, 71, 71, 71)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(left: 0.0),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isFocusGenero = true;
                                        });
                                      },
                                      validator: (value) {
                                        return(value != null) ? null : "Esta vacio, ingrese datos";
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: _isFocusColor ? const Color.fromARGB(255, 226, 226, 226) : const Color.fromARGB(255, 255, 255, 255),
                                      border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: TextFormField(
                                      controller: _colorController,
                                      focusNode: focusNode5_,
                                      style: TextStyle(),
                                      decoration: InputDecoration(
                                        hintText: "Color",
                                        hintStyle: TextStyle(color: _isFocusColor ? const Color.fromARGB(255, 72, 72, 72) : Color.fromARGB(255, 71, 71, 71)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(left: 0.0),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isFocusColor = true;
                                        });
                                      },
                                      validator: (value) {
                                        return(value != null) ? null : "Esta vacio, ingrese datos";
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: _isFocusPeso ? const Color.fromARGB(255, 226, 226, 226) : const Color.fromARGB(255, 255, 255, 255),
                                      border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: TextFormField(
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      controller: _pesoController,
                                      focusNode: focusNode6_,
                                      style: TextStyle(),
                                      decoration: InputDecoration(
                                        hintText: "Peso",
                                        hintStyle: TextStyle(color: _isFocusPeso ? const Color.fromARGB(255, 72, 72, 72) : Color.fromARGB(255, 71, 71, 71)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(left: 0.0),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isFocusPeso = true;
                                        });
                                      },
                                      validator: (value) {
                                        return(value != null) ? null : "Esta vacio, ingrese datos";
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12,),
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: _isFocusTamano ? const Color.fromARGB(255, 226, 226, 226) : const Color.fromARGB(255, 255, 255, 255),
                                      border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: TextFormField(
                                      controller: _tamanoController,
                                      focusNode: focusNode7_,
                                      style: TextStyle(),
                                      decoration: InputDecoration(
                                        hintText: "Tamaño",
                                        hintStyle: TextStyle(color: _isFocusTamano ? const Color.fromARGB(255, 72, 72, 72) : Color.fromARGB(255, 71, 71, 71)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(left: 0.0),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isFocusTamano = true;
                                        });
                                      },
                                      validator: (value) {
                                        return(value != null) ? null : "Esta vacio, ingrese datos";
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: _isFocusFechaDeNacimiento
                                          ? const Color.fromARGB(255, 226, 226, 226)
                                          : const Color.fromARGB(255, 255, 255, 255),
                                      border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      controller: _fechaController,
                                      focusNode: focusNode8_,
                                      style: TextStyle(),
                                      decoration: InputDecoration(
                                        hintText: "Fcha. Nacimiento",
                                        hintStyle: TextStyle(color: _isFocusFechaDeNacimiento
                                            ? const Color.fromARGB(255, 72, 72, 72)
                                            : Color.fromARGB(255, 71, 71, 71)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(left: 0.0),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isFocusFechaDeNacimiento = true;
                                        });
                                        _selectDate(context); // Abre el DatePicker cuando se toca el campo
                                      },
                                      validator: (value) {
                                        return value != null && value.isNotEmpty
                                            ? null
                                            : "Este campo es obligatorio.";
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 12,),
                            TextButton(
                              onPressed: () {
                                inserMascota();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: MediaQuery.of(context).size.width * 0.3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 170, 212, 194),
                                  borderRadius: BorderRadius.circular(7)
                                ),
                                child: Text("Enviar", style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 77, 58), fontSize: 18, fontWeight: FontWeight.w500),),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                )
          
              ],
            ),
          ),
        ),
      )
    );
  }
}