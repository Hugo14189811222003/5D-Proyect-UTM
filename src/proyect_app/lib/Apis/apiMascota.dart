import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyect_app/models/modeloMascota.dart';

Future<void> crearMascota(PostMascota mascota) async {
  try{
    final uri = Uri.parse("https://petpalzapi.onrender.com/api/mascota");
    
    print("JSON enviado: ${json.encode(mascota.toJson())}");
    final response = await http.post(uri, headers: {"Content-Type": "application/json"}, body: json.encode(mascota.toJson())).timeout(Duration(seconds: 10));;
    print("Estado de respuesta ${response.statusCode} : ${response.body}");
    if(response.statusCode == 200 || response.statusCode == 201){
      print("Mascota ingresada con exito");
      return;
    } else{
      print("Problemas al ingresar la mascota");
      return;
    }
  } catch (err) {
    throw Exception('Error de servidor: ${err}');
  }
}

Future<List<GetMascota>> getMascota(int page) async {
  final url = Uri.parse("https://petpalzapi.onrender.com/api/mascota?pageNumber=$page&pageSize=10000");
  final response = await http.get(url);
  print("estado ${response.statusCode}: ${response.body}");

  if(response.statusCode == 200 || response.statusCode == 201) {
    final decodificacion = jsonDecode(response.body);
    if (decodificacion is Map<String, dynamic> && decodificacion.containsKey("\$values")) {
        final List<dynamic> listaMascota = decodificacion["\$values"];

        return listaMascota.map((json) => GetMascota.fromJson(json)).toList();
      } else {
        throw Exception("La respuesta de la API no tiene la clave '\$values': $decodificacion");
      }
  } else {
    print("no se obtuvo la informacion, estado ${response.statusCode}: ${response.body}");
    throw Exception("No se pudo obtener la información. Estado: ${response.statusCode}");
  }
}
