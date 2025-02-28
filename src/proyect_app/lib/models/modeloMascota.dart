import 'package:intl/intl.dart';

class PostMascota {
  int usuarioId;
  String nombre;
  DateTime fechaNacimiento;  // ⬅ Cambiar a DateTime
  String especie;
  String raza;
  int peso;
  String imagenURL;

  PostMascota({
    required this.usuarioId,
    required this.nombre,
    required this.fechaNacimiento,
    required this.especie,
    required this.raza,
    required this.peso,
    required this.imagenURL
  });

  factory PostMascota.fromJson(Map<String, dynamic> json) {
    return PostMascota(
      usuarioId: json["usuarioId"] ?? 0,
      nombre: json["nombre"] ?? "no hay nombre",
      fechaNacimiento: DateTime.tryParse(json["fechaNacimiento"] ?? "") ?? DateTime.now(), // ⬅ Convertir a DateTime
      especie: json["especie"] ?? "no hay especie",
      raza: json["raza"] ?? "no hay raza",
      peso: (json["peso"] is int) ? json["peso"] : int.tryParse(json["peso"].toString()) ?? 0,
      imagenURL: json["imagenUrl"] ?? "no hay imagen"
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "fechaNacimiento": fechaNacimiento.toIso8601String(),  // ⬅ Convertir a ISO 8601
      "especie": especie,
      "raza": raza,
      "peso": peso,
      "imagenUrl": imagenURL,
      "usuarioId": usuarioId
    };
  }
}

class GetMascota {
  int id;
  int usuarioId;
  String nombre;
  DateTime fechaNacimiento;  // ⬅ Cambiar a DateTime
  String especie;
  String raza;
  int peso;
  String imagenURL;

  GetMascota({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    required this.fechaNacimiento,
    required this.especie,
    required this.raza,
    required this.peso,
    required this.imagenURL
  });

  factory GetMascota.fromJson(Map<String, dynamic> json) {
    return GetMascota(
      id: json["id"],
      usuarioId: json["usuarioId"],
      nombre: json["nombre"] ?? "no hay nombre",
      fechaNacimiento: DateTime.tryParse(json["fechaNacimiento"] ?? "") ?? DateTime.now(), // ⬅ Convertir a DateTime
      especie: json["especie"] ?? "no hay especie",
      raza: json["raza"] ?? "no hay raza",
      peso: (json["peso"] is int) ? json["peso"] : int.tryParse(json["peso"].toString()) ?? 0,
      imagenURL: json["imagenUrl"] ?? "no hay imagen"
    );
  }
}