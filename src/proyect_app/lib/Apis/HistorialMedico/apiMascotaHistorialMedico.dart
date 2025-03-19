import 'dart:convert';

import 'package:proyect_app/models/HistorialMedico/modeloHistorialMedico.dart';
import 'package:http/http.dart' as http;

Future<HistorialMedico?> obtenerHistorialMedicoPorMascota(int mascotaId) async {
  final uri = Uri.parse("https://petpalzapi.onrender.com/api/historial-medico/mascota/$mascotaId");
  
  try {
    final response = await http.get(uri).timeout(Duration(seconds: 10));
    print("🔄 Estado de respuesta: ${response.statusCode}");
    print("📥 Respuesta del servidor: ${response.body}");
    
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return HistorialMedico.fromJson(jsonResponse);
    } else {
      print("❌ No se encontró historial médico para la mascota con ID $mascotaId");
      return null;
    }
  } catch (err) {
    print("⚠️ Error de conexión: $err");
    return null;
  }
}
