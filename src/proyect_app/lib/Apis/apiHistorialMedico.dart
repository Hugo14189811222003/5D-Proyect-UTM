import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyect_app/models/modeloHistorialMedico.dart';

Future<void> crearHistorialMedico(postHistorialMedico historial) async {
  try{
    final uri = Uri.parse("https://petpalzapi.onrender.com/api/HistorialMedico");
    
    print("JSON enviado: ${json.encode(historial.toJson())}");
    final response = await http.post(uri, headers: {"Content-Type": "application/json"}, body: json.encode(historial.toJson())).timeout(Duration(seconds: 10));;
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

Future<List<getHistorialMedico>> getHistorialMedicoApi(int page) async {
  final url = Uri.parse("https://petpalzapi.onrender.com/api/HistorialMedico?pageNumber=$page&pageSize=10000");
  final response = await http.get(url);
  print("estado ${response.statusCode}: ${response.body}");

  if(response.statusCode == 200 || response.statusCode == 201) {
    final decodificacion = jsonDecode(response.body);
    if (decodificacion is Map<String, dynamic> && decodificacion.containsKey("\$values")) {
        final List<dynamic> listahistorial = decodificacion["\$values"];

        return listahistorial.map((json) => getHistorialMedico.fromJson(json)).toList();
      } else {
        throw Exception("La respuesta de la API no tiene la clave '\$values': $decodificacion");
      }
  } else {
    print("no se obtuvo la informacion, estado ${response.statusCode}: ${response.body}");
    throw Exception("No se pudo obtener la información. Estado: ${response.statusCode}");
  }
}