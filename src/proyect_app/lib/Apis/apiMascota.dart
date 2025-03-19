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


Future<void> eliminarMascotaAPI(int mascotaId) async {
  final String apiUrl = 'https://petpalzapi.onrender.com/api/mascota/$mascotaId';

  try {
    final uri = Uri.parse(apiUrl);
    final response = await http.delete(uri, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("✅ Mascota eliminada con éxito.");
    } else {
      print("❌ Error al eliminar la mascota: ${response.statusCode} - ${response.body}");
      throw Exception("Error al eliminar la mascota.");
    }
  } catch (err) {
    print("⚠️ Error de conexión: $err");
    throw Exception("Error de conexión al intentar eliminar la mascota.");
  }
}



Future<void> actualizarMascota(int mascotaId, PostMascota mascota) async {
  final String apiUrl = 'https://petpalzapi.onrender.com/api/mascota/$mascotaId';

  try {
    final uri = Uri.parse(apiUrl);
    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(mascota.toJson()),
    );

    print("Estado de respuesta ${response.statusCode} : ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("✅ Mascota actualizada con éxito.");
    } else {
      print("❌ Error al actualizar la mascota: ${response.statusCode} - ${response.body}");
      throw Exception("Error al actualizar la mascota.");
    }
  } catch (err) {
    print("⚠️ Error de conexión: $err");
    throw Exception("Error de conexión al intentar actualizar la mascota.");
  }
}

