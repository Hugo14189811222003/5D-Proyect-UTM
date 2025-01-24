import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyect_app/models/modelsPost.dart';

Future<void> createAccount(UsuarioPost newUser) async {
  const String url = 'https://nodejs-mysql-railwey-production.up.railway.app/api/usuarios';

  try{
    final uri = Uri.parse(url);
    final response = await http.post(uri, headers: {'Content-type': 'application/json'}, body: json.encode(newUser.toJson()));

    if(response.statusCode == 200){
      print('Usuario ingresado con exito');
    } else {
      print('Error al ingresar a los usuarios');
    }
  } catch (error){
    print("Ha habido un error: $error");
  }
}