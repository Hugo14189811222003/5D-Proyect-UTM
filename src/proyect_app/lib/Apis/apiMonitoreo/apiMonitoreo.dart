import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyect_app/models/monitoreo/modeloMonitoreo.dart';

Future<bool> postMonitoreo(Monitoreo monitoreo) async {
  try {
    String url = "https://petpalzapi.onrender.com/api/monitoreo";
    
    final uri = Uri.parse(url);
    print("Estado de URI: ${uri}");

    // Enviar la solicitud POST con el cuerpo correcto (jsonEncode)
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(monitoreo.jsonData()),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Estado de respuesta ${response.statusCode} mensaje: ${response.body}");
      return true; // Retornar true si la respuesta fue exitosa
    } else {
      print("No se pudo mandar los datos. Estado: ${response.statusCode}, Cuerpo: ${response.body}");
      return false; // Retornar false si la respuesta no fue exitosa
    }
  } catch (err) {
    print("Error de servidor: $err");
    return false; // Retornar false si hubo un error en la solicitud
  }
}



Future<List<Monitoreo>> getMonitoreo(int page) async{
  try{
    String url = "https://petpalzapi.onrender.com/api/monitoreo?pageNumber=$page&pageSize=10000";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print("estado ${response.statusCode} : ${response}");
    if(response.statusCode == 201 || response.statusCode == 200) {
      final responseDecode = jsonDecode(response.body);
      if(responseDecode is Map<String, dynamic> && responseDecode.containsKey("\$values")) {
        final List<dynamic> listMonitoreo = responseDecode["\$values"];
        return listMonitoreo.map((json) => Monitoreo.fromJson(json)).toList();
      } else {
        print("la list no tiene el \$values");
        return [];
      }
    } else {
      print("problema al obtener los datos: ${response}");
      return [];
    }
  } catch (err) {
    throw Exception("error de servidor ${err}");
  }
}