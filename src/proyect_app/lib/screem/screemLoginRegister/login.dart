import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/Apis/postApiUser.dart';
import 'package:proyect_app/Apis/userApi.dart';
import 'package:proyect_app/models/models.dart';
import 'package:proyect_app/models/modelsPost.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _focusPassword = false;
  final _focusEmail = false;
  bool _isPasswordVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode focusNode_ = FocusNode();
  final FocusNode focusNode2_ = FocusNode();
  bool _isFocus = false;
  bool _isFocusPsw = false;

  @override
  void initState(){
    super.initState();
    checkIfLoggedIn();
    focusNode_.addListener(() {
      setState(() {
        _isFocus = focusNode_.hasFocus;
      });
    });
    focusNode2_.addListener(() {
      setState(() {
        _isFocusPsw = focusNode2_.hasFocus;
      });
    });
  }

  // Verificar si el usuario está logueado
  Future<void> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id'); // Recuperamos el id del usuario

    if (userId != null) {
      // Si hay un usuario logueado, redirigimos a la página principal
      Navigator.pushReplacementNamed(context, 'home');
    }
  }

  Future<void> veryfiqueDataFormLogin() async {
    if(emailController.text.isEmpty || passwordController.text.isEmpty){
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
      print('datos no enviados');
      return;
    } else {
      if(_formKey.currentState!.validate()){
          try{  
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return Center(child: CircularProgressIndicator(),);
              },
            );
            //llamar a la api para obtener los usuarios
            final List<Usuario> usuarioData = await fetchUsuarios(1);
            Navigator.of(context).pop;
            print("Usuarios obtenidos de la API:");
            usuarioData.forEach((usuario) => print("Email: ${usuario.email}, Contraseña: ${usuario.contrasena}")); 
            print("Email ingresado: ${emailController.text.trim().toLowerCase()}");
            //buscar al usuario
            final List<Usuario> usuarioFiltrado = usuarioData.where(
              (usuario) => usuario.email.trim().toLowerCase() == emailController.text.trim().toLowerCase(),
            ).toList();
            //
            Usuario? usuarioEncontrado = usuarioFiltrado.isNotEmpty ? usuarioFiltrado.first : null;
            print("este es el usuario encontrado: ${usuarioEncontrado?.email} y su password es ${usuarioEncontrado?.contrasena}");
            //verificacion de password y email
            if(usuarioEncontrado != null){
              if(usuarioEncontrado.contrasena == passwordController.text){
                // Guardar en SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('id', usuarioEncontrado.id.toString());
                prefs.setString('nombre', usuarioEncontrado.nombre);
                prefs.setString('email', usuarioEncontrado.email);
                print("ID Guardado: ${usuarioEncontrado.id}");
                
                Navigator.pushReplacementNamed(context, 'home', arguments: usuarioEncontrado.nombre);
              } else {
                print('contraseña incorrecta');
                Navigator.of(context).pop();
                showDialog(
                  context: context, 
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text('Error de credenciales'),
                      content: Text('Favor de ingresar la contraseña de forma correcta'),
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
            } else {
              print('El gmail es incorrecto');
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Error de credenciales'),
                    content: Text('El gmail es incorrecto, favor de ingresar de nuevo'),
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

          } catch (err) {
            print('Error al validar los datos: $e');
            ErroresServidor('Error', 'Hubo un problema con el servidor');
          }
        } else {
          print('Error de validaciones del formulario');
        }
      }
    }
  void ErroresServidor(titulo, contenido) {
    showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(titulo),
                  content: Text(contenido),
                  actions: [
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
  }
  @override
  void dispose(){
    super.dispose();
    nameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    focusNode_.dispose();
    focusNode2_.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Controladores TextField
    // tamaño total de la pantalla: ancho y alto
    final screemWidth = MediaQuery.of(context).size.width;
    final screemHeigth = MediaQuery.of(context).size.height;
    // Verificación si la pantalla esta en landScape (volteada horizontalmente)
    final landScape = screemWidth > screemHeigth;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

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
                            formulario(screemHeigth, screemWidth,nameController, userNameController, emailController, passwordController, _formKey, _focusEmail, _focusPassword)
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

  Form formulario(final screemWidth, final screemHeight, TextEditingController nameController, TextEditingController userNameController, TextEditingController emailController, TextEditingController passwordController, GlobalKey<FormState> _formKey, bool _focusEmail, bool _focusPassword) {
    return Form(
      key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: screemHeight * 0.1,),
                                  FadeInLeft(
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
                                            
                                            style: TextStyle(color: _isFocus ? Colors.white :Color.fromARGB(255, 71, 71, 71)),
                                            focusNode: focusNode_,
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              icon: Icon(Icons.email_outlined, color: _isFocus ? Colors.white : Color.fromARGB(255, 71, 71, 71)),
                                              hintText: "Correo electronico",
                                              hintStyle: TextStyle(color: _isFocus ? Colors.white : Color.fromARGB(255, 71, 71, 71)),
                                              border: InputBorder.none,
                                              contentPadding: const EdgeInsets.only(left: 0.0),
                                              errorStyle: TextStyle(color: _isFocus ? Colors.white : Colors.red)
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _focusEmail = true;
                                              });
                                            },
                                            validator: (value) {
                                              String pattern = 
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                              RegExp regex = RegExp(pattern);
                                              
                                                return regex.hasMatch(value ?? "") ? null : 'Esto no es un gmail, ingrese otro';
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 25,),
                                  FadeInRight(
                                    duration: Duration(seconds: 1),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                      child: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color.fromARGB(255, 0, 77, 58), width: 3),
                                          color: _isFocusPsw ? const Color.fromARGB(255, 0, 77, 58) : const Color.fromARGB(255, 255, 255, 255),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: TextFormField(
                                            style: TextStyle(color: _isFocusPsw ? Colors.white :Color.fromARGB(255, 71, 71, 71)),
                                            focusNode: focusNode2_,
                                            obscureText: _isPasswordVisible,
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
                                              )
                                            ),onTap: () {
                                              setState(() {
                                                _focusPassword = true;
                                              });
                                            },
                                            validator: (value) {
                                              return (value != null && value.length >= 6) ? null : "Favor de ingresar mas de 6 caracteres";
                                            },
                                          
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  FadeIn(duration: Duration(seconds: 5), child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(context, "register");
                                    },
                                    child: Text("Crear cuenta"),
                                  )),
                                  SizedBox(height: 10),
                                  FadeIn(duration: Duration(seconds: 5), child: Text("Olvide mi contraseña")),
                                  SizedBox(height: 10),
                                  FadeIn(
                                    duration: Duration(seconds: 5),
                                    child: ElevatedButton(
                                      onPressed: veryfiqueDataFormLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 170, 212, 194)
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                                        child: Text("Iniciar sesión", style: TextStyle(color: const Color.fromARGB(255, 0, 77, 58), fontSize: 18),),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 25,),
                                  FadeIn(duration: Duration(seconds: 3), child: Text("O inicie sesión con:")),
                                  SizedBox(height: 25,),
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
                                  SizedBox(height: 15,),
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
                                  SizedBox(height: 15,),
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
                  height: landScape ? screemHeigth * 0.4 : screemHeigth * 0.15,
                  width: maxWidth,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 20),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: BounceInDown(
                        duration: const Duration(milliseconds: 1100),
                        child: Image.network(
                          'https://cielodemascotas.com/wp-content/uploads/2022/03/cropped-logo-cielo-de-mascotas-01-1.png',
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