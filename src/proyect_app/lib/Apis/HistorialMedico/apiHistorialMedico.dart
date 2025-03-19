import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyect_app/models/HistorialMedico/modeloHistorialMedico.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

  Future<HistorialMedico?> obtenerHistorialMedico(int id) async {
    // Se usa la ruta con el ID en el path
    final uri = Uri.parse("https://petpalzapi.onrender.com/api/historial-medico/$id");

    try {
      final response = await http.get(uri).timeout(Duration(seconds: 10));
      print("🔄 Estado de respuesta: ${response.statusCode}");
      print("📥 Respuesta del servidor: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        return HistorialMedico.fromJson(jsonResponse);
      } else {
        print("❌ Error al obtener el historial médico: ${response.body}");
        return null;
      }
    } catch (err) {
      print("⚠️ Error de conexión: $err");
      throw Exception('Error de conexión: $err');
    }
  }

Future<void> crearHistorialMedico(HistorialMedico historial) async {
  try{
    final uri = Uri.parse("https://petpalzapi.onrender.com/api/historial-medico");

    print("JSON enviado: ${json.encode(historial.toJson())}");
    print("ver uri: ${uri}");
    final response = await http.post(uri, headers: {"Content-Type": "application/json"}, body: json.encode(historial.toJson())).timeout(Duration(seconds: 10));
    print("Estado de respuesta ${response.statusCode} : ${response.body}");
    if(response.statusCode == 200 || response.statusCode == 201){
      print("historial medico ingresada con exito");
      return;
    } else{
      print("Problemas al ingresar el historial medico");
      return;
    }
  } catch (err) {
    throw Exception('Error de servidor: ${err}');
  }
}

Future<void> eliminarHistorialMedico(int id) async {
  try {
    final uri = Uri.parse("https://petpalzapi.onrender.com/api/HistorialMedico/$id");

    final response = await http.delete(
      uri,
      headers: {"Content-Type": "application/json"},
    ).timeout(Duration(seconds: 10));

    print("Estado de respuesta ${response.statusCode}: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Historial médico eliminado con éxito");
    } else {
      print("Problemas al eliminar el historial médico");
    }
  } catch (err) {
    throw Exception('Error de servidor: $err');
  }
}
