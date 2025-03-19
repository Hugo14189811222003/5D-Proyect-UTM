import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/Apis/postApiUser.dart';
import 'package:proyect_app/Apis/userApi.dart';
import 'package:proyect_app/models/models.dart';
import 'package:proyect_app/models/modelsPost.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isEmailFieldFucoused = false;
  bool _isPasswordFieldFocus = false;
  bool _isPasswordVisible = true;
  final FocusNode focusNode_ = FocusNode();
  final FocusNode focusNode2_ = FocusNode();
  final FocusNode focusNode3_ = FocusNode();
  bool _isFocus = false;
  bool _isFocusEmail = false;
  bool _isFocusPsw = false;

  

  @override
  void initState(){
    super.initState();
    focusNode_.addListener(() {
      setState(() {
        _isFocus = focusNode_.hasFocus;
      });
    });
    focusNode2_.addListener(() {
      setState(() {
        _isFocusEmail = focusNode2_.hasFocus;
      });
    });
    focusNode3_.addListener(() {
      setState(() {
        _isFocusPsw = focusNode3_.hasFocus;
      });
    });
  }

  Future<void> verifyDataForm() async {
  if(nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      if (_formState.currentState!.validate()) {  // Verifica si el formulario es válido primero
      // Si pasa la validación, proceder con el código
      String nombre = nameController.text;
      String email = emailController.text;
      String contrasena = passwordController.text;

      UsuarioPost newUser = UsuarioPost(
        nombre: nombre,
        email: email,
        contrasena: contrasena
      );

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Llamar a la API
      final List<Usuario> dataUsuario = await fetchUsuarios(1);

      final List<Usuario> gmailFiltrado = dataUsuario.where(
        (emailOfUser) => emailOfUser.email.trim().toLowerCase() == emailController.text.trim().toLowerCase()
      ).toList();

      if (gmailFiltrado.isEmpty) {
        // Datos enviados a la API de POST
        await createAccount(newUser);
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Cuenta creada con éxito'),
          ),
        );
        Navigator.pushReplacementNamed(context, "login");
      } else {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Problemas con el Gmail"),
              content: Text("El Gmail ya existe, ingresa otro."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Si la validación falla, simplemente muestra un error sin hacer nada más
      print('Formulario no válido');
    }
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Error de entreda'),
            content: Text('Favor de ingresar datos'),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
  }
}


    @override
    void dispose(){
      super.dispose();
      nameController.dispose();
      passwordController.dispose();
      emailController.dispose();
      focusNode_.dispose();
      focusNode2_.dispose();
      focusNode3_.dispose();
    }
  @override
  Widget build(BuildContext context) {
    // Controladores TextFiel
    // tamaño total de la pantalla: ancho y alto
    final screemWidth = MediaQuery.of(context).size.width;
    final screemHeigth = MediaQuery.of(context).size.height;
    // Verificación si la pantalla esta en landScape (volteada horizontalmente)
    final landScape = screemWidth > screemHeigth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder:(context, constraints) {
          // obtener el maximo tamaño de ancho de un widgets
          final maxWidth = constraints.maxWidth;
          return Column(
              children: [
                // icono usuario
                icon(landScape, screemHeigth, maxWidth, screemWidth),
                //formulario
                Expanded(
                  child: Container(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: screemWidth,
                        height: screemHeigth,
                        child: ListView(
                          children: [
                            formulario(nameController, emailController, passwordController)
                          ],
                        ),
                      ),
                )
              ],
            );        
          },
      ),
      bottomNavigationBar: FadeInUpBig(
        duration: Duration(milliseconds: 1000),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
              child: BottomAppBar(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'home');
                    },
                  ),
                ),
                height: landScape ? screemHeigth * 0.1 : screemHeigth * 0.035,
                color: const Color.fromARGB(255, 0, 132, 103),
              ),
          ),
      ),
    );
  }

  Form formulario(TextEditingController nameController, TextEditingController emailController, TextEditingController passwordController) {
    return Form(
      key: _formState,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FadeInRight(
                                    duration: Duration(seconds: 1),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                      child: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: _isFocus ? const Color.fromARGB(255, 0, 77, 58) : const Color.fromARGB(255, 255, 255, 255),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 3),
                                          boxShadow: _isFocus ? [
                                            const BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10,
                                              spreadRadius: 5,
                                              offset: Offset(0, 0)
                                            )
                                          ] : null,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: TextFormField(
                                            maxLength: 75,
                                            style: TextStyle(color: _isFocus ? Colors.white :Color.fromARGB(255, 71, 71, 71)),
                                            focusNode: focusNode_,
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(color: _isFocus ? Colors.white : Colors.red),
                                              icon: Icon(Icons.person, color: _isFocus ? Colors.white : Color.fromARGB(255, 71, 71, 71)),
                                              hintText: "Nombre",
                                              hintStyle: TextStyle(color: _isFocus ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 71, 71, 71)),
                                              border: InputBorder.none
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  FadeInLeft(
                                    duration: Duration(seconds: 1),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                      child: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: _isFocusEmail ? const Color.fromARGB(255, 0, 77, 58) : const Color.fromARGB(255, 255, 255, 255),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 3),
                                          boxShadow: _isFocusEmail ? [
                                            const BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10,
                                              spreadRadius: 5,
                                              offset: Offset(0, 0)
                                            )
                                          ] : null,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: TextFormField(
                                            keyboardType: TextInputType.emailAddress,
                                            style: TextStyle(color: _isFocusEmail ? Colors.white :Color.fromARGB(255, 71, 71, 71)),
                                            focusNode: focusNode2_,
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(color: _isFocusEmail ? Colors.white : Colors.red),
                                              icon: Icon(Icons.email, color: _isFocusEmail ? Colors.white : Color.fromARGB(255, 71, 71, 71)),
                                              hintText: "email",
                                              hintStyle: TextStyle(color: _isFocusEmail ? Colors.white : Color.fromARGB(255, 71, 71, 71)),
                                              border: InputBorder.none
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _isEmailFieldFucoused = true;
                                              });
                                            },
                                            validator: (value) {
                                              String pattern = 
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                              RegExp regex = RegExp(pattern);
                                              if (_isEmailFieldFucoused) {
                                                return regex.hasMatch(value ?? "") ? null : 'Esto no es un gmail, ingrese otro';
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  FadeInRight(
                                    duration: Duration(seconds: 1),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                      child: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: _isFocusPsw ? const Color.fromARGB(255, 0, 77, 58) : const Color.fromARGB(255, 255, 255, 255),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 3),
                                          boxShadow: _isFocusPsw ? [
                                            const BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10,
                                              spreadRadius: 5,
                                              offset: Offset(0, 0)
                                            )
                                          ] : null,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: TextFormField(
                                            obscureText: _isPasswordVisible, // Controla si el texto está oculto o no
                                            style: TextStyle(color: _isFocusPsw ? Colors.white : Color.fromARGB(255, 71, 71, 71)),
                                            focusNode: focusNode3_,
                                            controller: passwordController,
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(color: _isFocusPsw ? Colors.white : Colors.red),
                                              icon: Icon(
                                                Icons.lock,
                                                color: _isFocusPsw ? Colors.white : Color.fromARGB(255, 71, 71, 71),
                                              ),
                                              hintText: "password",
                                              hintStyle: TextStyle(color: _isFocusPsw ? Colors.white : Color.fromARGB(255, 71, 71, 71)),
                                              border: InputBorder.none,
                                              suffixIcon: IconButton( // Ícono para mostrar/ocultar la contraseña
                                                icon: Icon(
                                                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility, // Cambia el ícono
                                                  color: _isFocusPsw ? Colors.white : Color.fromARGB(255, 71, 71, 71),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _isPasswordVisible = !_isPasswordVisible; // Alterna la visibilidad
                                                  });
                                                },
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _isPasswordFieldFocus = true;
                                              });
                                            },
                                            validator: (value) {
                                              
                                              if (value!.length < 6) {
                                                return 'La contraseña tiene que ser mayor a 6 caracteres';
                                              }
                                              if (!RegExp(r'[A-Z]').hasMatch(value!)) {
                                                return 'favor de meter una mayuscula tan siquiera'; 
                                              }
                                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                                return 'favor de meter una numero tan siquiera';
                                              }
                                            },
                                          ),

                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  FadeIn(duration: Duration(seconds: 5), child: GestureDetector(
                                    onTap: () {
                                        
                                      Navigator.pushReplacementNamed(context, "login");
                                    },
                                    child: Text("Iniciar sesión"),
                                  )),
                                  SizedBox(height: 20),
                                  FadeIn(
                                    duration: Duration(seconds: 4),
                                    child: ElevatedButton(
                                      onPressed: verifyDataForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 170, 212, 194)
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                                        child: Text("Crear  cuenta", style: TextStyle(color: const Color.fromARGB(255, 0, 77, 58), fontSize: 18),),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  FadeIn(duration: Duration(seconds: 3), child: Text("O cree una cuenta con:")),
                                  SizedBox(height: 40,),
                                  FadeIn(
                                    duration: Duration(seconds: 5),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 40),
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.blue, width: 1)
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 10,),
                                          Image.network(
                                            'https://static.vecteezy.com/system/resources/previews/023/986/516/non_2x/facebook-logo-facebook-logo-transparent-facebook-icon-transparent-free-free-png.png',
                                            fit: BoxFit.contain,
                                            scale: 40,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(width: 10,),
                                          Text("Continuar con Facebook", style: TextStyle(color: Colors.blue, fontSize: 18),),
                                          
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 13,),
                                  FadeIn(
                                    duration: Duration(seconds: 5),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 40),
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black26),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 2,
                                            offset: Offset(1, 1)
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color.fromARGB(255, 255, 255, 255)
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 10,),
                                          Image.network(
                                            'https://s3-us-west-2.amazonaws.com/mfcollectnew/reviewIcons/google.png',
                                            fit: BoxFit.contain,
                                            scale: 5,
                                          ),
                                          SizedBox(width: 10,),
                                          Text("Continuar con Google", style: TextStyle(color: const Color.fromARGB(255, 147, 147, 147), fontSize: 18),),
                                          
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 13,),
                                  FadeIn(
                                    duration: Duration(seconds: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 40),
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 10,),
                                          Image.network(
                                            'https://th.bing.com/th/id/R.77f375e898ed68102d9bfcb33fb55470?rik=I0KVCZaI9gOUNw&pid=ImgRaw&r=0',
                                            fit: BoxFit.contain,
                                            scale: 30,
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                          ),
                                          SizedBox(width: 10,),
                                          Text("Continuar con Apple", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 18),),
                                          
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
  }

  SafeArea icon(bool landScape, double screemHeigth, double maxWidth, double screemWidth) {
    return SafeArea(
      child: Container(
                  height: landScape ? screemHeigth * 0.4 : screemHeigth * 0.16,
                  width: maxWidth,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 40),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: BounceInDown(
                        duration: const Duration(milliseconds: 1100),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/sample-firebase-ai-app-b53ae.firebasestorage.app/o/logo-full.png?alt=media&token=14a5059f-d9bc-4765-91a4-9dadb823eddb',
                          fit: BoxFit.contain,
                          width: landScape ? screemWidth * 0.1 : screemWidth * 0.1,
                          height: landScape ? screemWidth * 0.1 : screemWidth * 0.1,
                        ),
                      )
                      
                      /*Image.asset(
                        "images/logoMascota.png",
                        width: landScape ? screemWidth * 0.1 : screemWidth * 0.1,
                        height: landScape ? screemWidth * 0.1 : screemWidth * 0.1,
                        fit: BoxFit.contain,
                      ),*/
                    ),
                  ),
                ),
    );
  }
}