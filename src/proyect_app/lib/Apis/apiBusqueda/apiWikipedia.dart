import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchInformacionDeCategoria(String categoria) async {
  final url = Uri.parse('https://es.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exintro=&titles=$categoria');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final decodedData = jsonDecode(response.body);

    if (decodedData.containsKey("query") && decodedData["query"].containsKey("pages")) {
      final page = decodedData["query"]["pages"].values.first;
      final extract = page["extract"] ?? "No se encontró información disponible.";

      return extract;
    } else {
      throw Exception("La respuesta de la API no contiene la información esperada");
    }
  } else {
    throw Exception("Error al cargar la información de Wikipedia");
  }
}
