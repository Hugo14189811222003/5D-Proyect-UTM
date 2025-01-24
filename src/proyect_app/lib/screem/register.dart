import 'package:flutter/material.dart';
import 'package:proyect_app/Apis/postApiUser.dart';
import 'package:proyect_app/models/models.dart';
import 'package:proyect_app/models/modelsPost.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    // Controladores TextField
    final TextEditingController nameController = TextEditingController();
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    // tamaño total de la pantalla: ancho y alto
    final screemWidth = MediaQuery.of(context).size.width;
    final screemHeigth = MediaQuery.of(context).size.height;
    // Verificación si la pantalla esta en landScape (volteada horizontalmente)
    final landScape = screemWidth > screemHeigth;

    return Scaffold(
      
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
                            formulario(nameController, userNameController, emailController, passwordController, )
                          ],
                        ),
                      ),
                )
              ],
            );        
          },
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        child: BottomAppBar(
          height: landScape ? screemHeigth * 0.1 : screemHeigth * 0.08,
          color: const Color.fromARGB(255, 0, 132, 103),
        ),
      ),
    );
  }

  Form formulario(TextEditingController nameController, TextEditingController userNameController, TextEditingController emailController, TextEditingController passwordController, ) {
    return Form(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 206, 206, 206),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextFormField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.person, color: Colors.white),
                                          hintText: "Nombre",
                                          hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                          border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 206, 206, 206),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextFormField(
                                        controller: userNameController,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.person_2, color: Colors.white),
                                          hintText: "userName",
                                          hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                          border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 206, 206, 206),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextFormField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.email, color: Colors.white),
                                          hintText: "email",
                                          hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                          border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 206, 206, 206),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextFormField(
                                        controller: passwordController,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.lock, color: Colors.white,),
                                          hintText: "password",
                                          hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                          border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // guardamos los controladores en un String
                                      String name = nameController.text;
                                      String userName = userNameController.text;
                                      String email = emailController.text;
                                      String password = passwordController.text;
                                      //objeto para mandar los datos a el modelo
                                      UsuarioPost newUser = UsuarioPost(
                                        name: name,
                                        userName: userName,
                                        email: email,
                                        password: password
                                      );
                                      // datos mandado a la api de POST
                                      await createAccount(newUser);
                                      
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Cuenta creada con exito'),
                                          )
                                        );
                                        Navigator.pushReplacementNamed(context, "listInfinity");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 170, 212, 194)
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                                      child: Text("Crear  cuenta", style: TextStyle(color: const Color.fromARGB(255, 0, 77, 58), fontSize: 18),),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text("O cree una cuenta con"),
                                  SizedBox(height: 10,),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 40),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blue
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 10,),
                                        Image.asset('images/facebook.png', width: 20, height: 20,),
                                        SizedBox(width: 10,),
                                        Text("Continuar con Facebook", style: TextStyle(color: Colors.white, fontSize: 18),),
                                        
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 13,),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 40),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 1,
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
                                        Image.asset('images/google.png', width: 20, height: 20,),
                                        SizedBox(width: 10,),
                                        Text("Continuar con Google", style: TextStyle(color: const Color.fromARGB(255, 147, 147, 147), fontSize: 18),),
                                        
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 13,),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 40),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 10,),
                                        Image.asset('images/apple.png', width: 20, height: 20,),
                                        SizedBox(width: 10,),
                                        Text("Continuar con Apple", style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 18),),
                                        
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
  }

  Container icon(bool landScape, double screemHeigth, double maxWidth, double screemWidth) {
    return Container(
                height: landScape ? screemHeigth * 0.4 : screemHeigth * 0.20,
                width: maxWidth,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(top: 0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Image.asset(
                      "images/logoMascota.png",
                      width: landScape ? screemWidth * 0.1 : screemWidth * 0.1,
                      height: landScape ? screemWidth * 0.1 : screemWidth * 0.1,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
              );
  }
}