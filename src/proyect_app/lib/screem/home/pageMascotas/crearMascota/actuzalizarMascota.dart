import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyect_app/Apis/apiMascota.dart';
import 'package:proyect_app/models/modeloMascota.dart';
import 'package:intl/intl.dart';
import 'package:proyect_app/models/models.dart';
import 'package:proyect_app/models/recordatorioModelo.dart';
import 'package:proyect_app/screem/home/navigationBottomBar.dart';
import 'package:proyect_app/screem/home/pageMascotas/mascota.dart';
import 'package:proyect_app/services/upload_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Actualizarmascota extends StatefulWidget {
  final screenHeight;
  final screenWidth;
  final mascota;
  const Actualizarmascota({super.key, this.screenHeight, this.screenWidth, this.mascota});

  @override
  State<Actualizarmascota> createState() => _ActualizarmascotaState();
}

class _ActualizarmascotaState extends State<Actualizarmascota> {
  String? selectedEspecie;

  final List<String> razasCat = [
    // Grupo 1
    "Ragdoll", "Gato persa", "Sphynx", "Gato siamés",
    // Grupo 2
    "Gato Exótico", "Maine Coon", "Scottish Fold", "Abisinio",
    // Grupo 3
    "Cornish rex", "Gato exótico", "British Shorthair", "American Shorthair"
  ];
  final List<String> razas = [
    // Grupo 1: Pastores y boyeros
    "Pastor Alemán", "Border Collie", "Pastor Belga", "Pastor Australiano",
    // Grupo 2: Molosos
    "Rottweiler", "Dogo Argentino", "Gran Danés", "San Bernardo",
    // Grupo 3: Terriers
    "Jack Russell Terrier", "Bull Terrier", "Yorkshire Terrier",
    // Grupo 4: Teckel
    "Teckel Estándar", "Teckel Miniatura",
    // Grupo 5: Spitz y primitivos
    "Husky Siberiano", "Samoyedo", "Chow Chow", "Akita Inu",
    // Grupo 6: Sabuesos
    "Beagle", "Basset Hound", "Bloodhound",
    // Grupo 7: Perros de muestra
    "Braco Alemán", "Pointer Inglés", "Setter Irlandés",
    // Grupo 8: Cobradores y de agua
    "Labrador Retriever", "Golden Retriever", "Cocker Spaniel",
    // Grupo 9: Compañía
    "Poodle", "Chihuahua", "Pug", "Bichón Maltés", "Bulldog Francés",
    // Grupo 10: Lebreles
    "Galgo Español", "Whippet", "Lebrel Afgano"
  ];

  File? _image; // Imagen local seleccionada
  String? _imageUrl; // URL de la imagen que viene del servidor

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

  String? selectedSize;
  String? selectedPeso;

  Future<void> guardarGenero(int mascotaId, String genero) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('genero_$mascotaId', genero);
  }

  @override
  void initState() {
    super.initState();
    cargarDatosMascota(widget.mascota.id);
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

  Future<void> cargarDatosMascota(int mascotaId) async {
    final String apiUrl = 'https://petpalzapi.onrender.com/api/mascota/$mascotaId';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nameController.text = data['nombre'];
          _especieController.text = data['especie'];
          _razaController.text = data['raza'];
          _generoController.text = data['genero'];
          _colorController.text = data['color'];
          _pesoController.text = data['peso'].toString();
          _tamanoController.text = data['tamano'];
          _fechaController.text = data['anoNacimiento'];
          _imageUrl = data['imagenUrl']; // Asigna directamente la URL
        });
      } else {
        print("❌ Error al obtener los datos de la mascota.");
      }
    } catch (e) {
      print("⚠️ Error: $e");
    }
  }

  Future<void> _actualizarMascotaUnique(int mascotaId) async {
    if (_nameController.text.isEmpty ||
        _especieController.text.isEmpty ||
        _razaController.text.isEmpty ||
        _generoController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _pesoController.text.isEmpty ||
        _tamanoController.text.isEmpty ||
        _fechaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 255, 191, 0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning),
              Text("Por favor no dejar vacio ninguna casilla", style: GoogleFonts.fredoka(color: Colors.black))
            ],
          ),
        ),
      );
    } else {
      if (_globalKeyForm1.currentState!.validate()) {
        String nombre = _nameController.text;
        String fechaNacimiento = _fechaController.text;
        String especie = _especieController.text;
        String raza = _razaController.text;
        int peso = int.tryParse(_pesoController.text) ?? 0;
        String genero = _generoController.text;
        String tamano = _tamanoController.text;
        String colors = _colorController.text;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userIdString = prefs.getString('id');
        int? userId = userIdString != null ? int.tryParse(userIdString) : null;
        print("ID Recuperado: ${userId}");

        // Si se seleccionó una nueva imagen se sube; si no, se utiliza la URL existente.
        final String? imageUrl;
        if (_image != null) {
          imageUrl = await uploadImage(_image!);
        } else {
          imageUrl = _imageUrl;
        }

        if (imageUrl != null && imageUrl.isNotEmpty) {
          // Crear el objeto de la mascota a actualizar
          PostMascota mascota = PostMascota(
            color: colors,
            tamano: tamano,
            usuarioId: userId ?? 0,
            nombre: nombre,
            fechaNacimiento: fechaNacimiento,
            especie: especie,
            raza: raza,
            peso: peso,
            imagenURL: imageUrl,
            genero: genero,
          );
          // Actualizar la mascota
          await actualizarMascota(mascotaId, mascota);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromARGB(255, 0, 114, 13),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Mascota actualizada con éxito", style: GoogleFonts.fredoka(color: Colors.white))
                ],
              ),
            ),
          );
          Navigator.pop(context);  // Regresar a la pantalla anterior
          // Limpiar los campos del formulario
          _nameController.clear();
          _especieController.clear();
          _razaController.clear();
          _generoController.clear();
          _colorController.clear();
          _pesoController.clear();
          _tamanoController.clear();
          _fechaController.clear();
        } else {
          print("No se pudo obtener el Url de la imagen");
        }
      } else {
        print("Dato no mandado");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 0, 132, 103),
        toolbarHeight: 70,
        title: Text("Actualizar mascotas", style: GoogleFonts.fredoka(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text("Actualizar a tu mascota", style: GoogleFonts.fredoka(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Container(
                width: (widget.screenWidth ?? MediaQuery.of(context).size.width) * 0.55,
                height: (widget.screenHeight ?? MediaQuery.of(context).size.height) * 0.18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[300],
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                      : (_imageUrl != null && _imageUrl!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(_imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: (_image == null && (_imageUrl == null || _imageUrl!.isEmpty))
                    ? Icon(Icons.image, size: 50, color: Colors.grey[700])
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Seleccionar Foto', style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103), fontWeight: FontWeight.w500)),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _globalKeyForm1,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: _isFocusName ? const Color.fromARGB(255, 226, 226, 226) : Colors.white,
                          border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          maxLength: 10,
                          controller: _nameController,
                          focusNode: focusNode_,
                          decoration: InputDecoration(
                            hintText: "Nombre",
                            hintStyle: TextStyle(color: _isFocusName ? const Color.fromARGB(255, 72, 72, 72) : const Color.fromARGB(255, 71, 71, 71)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(left: 0.0),
                          ),
                          onTap: () {
                            setState(() {
                              _isFocusName = true;
                            });
                          },
                          validator: (value) {
                            return (value != null && value.isNotEmpty) ? null : "Esta vacio, ingrese datos";
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: _isFocusEspecie ? const Color.fromARGB(255, 226, 226, 226) : Colors.white,
                          border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _especieController.text.isNotEmpty ? _especieController.text : null,
                          items: ["Perro", "Gato"].map((String especie) {
                            return DropdownMenuItem<String>(
                              value: especie,
                              child: Text(especie),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _especieController.text = newValue!;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "Especie",
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Seleccione una opción";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: _isFocusRaza ? const Color.fromARGB(255, 226, 226, 226) : Colors.white,
                          border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: _razaController,
                          maxLength: 25,
                          decoration: InputDecoration(
                            hintText: "Escriba o seleccione la raza",
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(left: 0.0),
                            suffixIcon: PopupMenuButton<String>(
                              icon: const Icon(Icons.arrow_drop_down),
                              onSelected: (String value) {
                                setState(() {
                                  _razaController.text = value;
                                });
                              },
                              itemBuilder: (BuildContext context) {
                                return _especieController.text == "Perro"
                                    ? razas.map((String raza) {
                                        return PopupMenuItem<String>(
                                          value: raza,
                                          child: Text(raza),
                                        );
                                      }).toList()
                                    : razasCat.map((String razaCat) {
                                        return PopupMenuItem<String>(
                                          value: razaCat,
                                          child: Text(razaCat),
                                        );
                                      }).toList();
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Seleccione o escriba una raza";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: _isFocusGenero ? const Color.fromARGB(255, 226, 226, 226) : Colors.white,
                                border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _generoController.text.isNotEmpty ? _generoController.text : null,
                                items: ["Macho", "Hembra"].map((String genero) {
                                  return DropdownMenuItem<String>(
                                    value: genero,
                                    child: Text(genero),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _generoController.text = newValue!;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Género",
                                  hintStyle: TextStyle(
                                    color: _isFocusGenero ? const Color.fromARGB(255, 72, 72, 72) : const Color.fromARGB(255, 71, 71, 71),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(left: 0.0),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Seleccione un género";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: _isFocusColor ? const Color.fromARGB(255, 226, 226, 226) : Colors.white,
                                border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                maxLength: 10,
                                controller: _colorController,
                                focusNode: focusNode5_,
                                decoration: InputDecoration(
                                  hintText: "Color",
                                  hintStyle: TextStyle(color: _isFocusColor ? const Color.fromARGB(255, 72, 72, 72) : const Color.fromARGB(255, 71, 71, 71)),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(left: 0.0),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isFocusColor = true;
                                  });
                                },
                                validator: (value) {
                                  return (value != null && value.isNotEmpty) ? null : "Esta vacio, ingrese datos";
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: _isFocusTamano ? const Color.fromARGB(255, 226, 226, 226) : Colors.white,
                                border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _tamanoController.text.isNotEmpty ? _tamanoController.text : null,
                                items: <String>['Pequeño', 'Mediano', 'Grande']
                                    .map<DropdownMenuItem<String>>((String size) {
                                  return DropdownMenuItem<String>(
                                    value: size,
                                    child: Text(size),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _tamanoController.text = newValue!;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Tamaño",
                                  hintStyle: TextStyle(
                                    color: _isFocusTamano ? const Color.fromARGB(255, 72, 72, 72) : const Color.fromARGB(255, 71, 71, 71),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(left: 0.0),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Seleccione un tamaño";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: _isFocusFechaDeNacimiento ? const Color.fromARGB(255, 226, 226, 226) : Colors.white,
                                border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                maxLength: 10,
                                controller: _fechaController,
                                focusNode: focusNode8_,
                                decoration: InputDecoration(
                                  hintText: "Fecha. Nacimiento",
                                  hintStyle: TextStyle(
                                      color: _isFocusFechaDeNacimiento ? const Color.fromARGB(255, 72, 72, 72) : const Color.fromARGB(255, 71, 71, 71)),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(left: 0.0),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isFocusFechaDeNacimiento = true;
                                  });
                                },
                                validator: (value) {
                                  return (value != null && value.isNotEmpty) ? null : "Este campo es obligatorio.";
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () async {
                          // Si no hay imagen local y tampoco URL, se detiene
                          if (_image == null && (_imageUrl == null || _imageUrl!.isEmpty)) {
                            print("No hay imagen seleccionada o disponible");
                            return;
                          }
                          await _actualizarMascotaUnique(widget.mascota.id);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: MediaQuery.of(context).size.width * 0.3),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 170, 212, 194),
                              borderRadius: BorderRadius.circular(7)),
                          child: Text(
                            "Enviar",
                            style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 77, 58), fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
