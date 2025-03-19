import 'package:intl/intl.dart';

class PostMascota {
  int usuarioId;
  String nombre;
  String fechaNacimiento;  // ⬅ Cambiar a DateTime
  String especie;
  String raza;
  int peso;
  String imagenURL;
  String genero;
  String tamano;
  String color;

  PostMascota({
    required this.usuarioId,
    required this.nombre,
    required this.fechaNacimiento,
    required this.especie,
    required this.raza,
    required this.peso,
    required this.imagenURL,
    required this.genero,
    required this.tamano,
    required this.color
  });

  factory PostMascota.fromJson(Map<String, dynamic> json) {
    return PostMascota(
      color: json["color"] ?? "sin color",
      tamano: json ["tamano"] ?? "sin tamaño",
      usuarioId: json["usuarioId"] ?? 0,
      nombre: json["nombre"] ?? "no hay nombre",
      fechaNacimiento: json["anoNacimiento"] ?? "no hay año de nacimiento", // ⬅ Convertir a DateTime
      especie: json["especie"] ?? "no hay especie",
      raza: json["raza"] ?? "no hay raza",
      peso: (json["peso"] is int) ? json["peso"] : int.tryParse(json["peso"].toString()) ?? 0,
      imagenURL: json["imagenUrl"] ?? "no hay imagen",
      genero: json["genero"] ?? "Desconocido",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "anoNacimiento": fechaNacimiento,  
      "especie": especie,
      "raza": raza,
      "peso": peso,
      "imagenUrl": imagenURL,
      "usuarioId": usuarioId,
      "genero": genero,
      "tamano": tamano,
      "color": color
    };
  }
}

class GetMascota {
  int id;
  int usuarioId;
  String nombre;
  String fechaNacimiento; 
  String especie;
  String raza;
  int peso;
  String imagenURL;
  String genero;
  String tamano;
  String color;

  GetMascota({
    required this.color,
    required this.tamano,
    required this.id,
    required this.usuarioId,
    required this.nombre,
    required this.fechaNacimiento,
    required this.especie,
    required this.raza,
    required this.peso,
    required this.imagenURL,
    required this.genero
  });

  factory GetMascota.fromJson(Map<String, dynamic> json) {
    return GetMascota(
      color: json["color"] ?? "no hay color",
      tamano: json["tamano"] ?? "no hay tamaño",
      id: json["id"],
      usuarioId: json["usuarioId"],
      nombre: json["nombre"] ?? "no hay nombre",
      fechaNacimiento: json["anoNacimiento"] ?? "no hay año de nacimiento",
      especie: json["especie"] ?? "no hay especie",
      raza: json["raza"] ?? "no hay raza",
      peso: (json["peso"] is int) ? json["peso"] : int.tryParse(json["peso"].toString()) ?? 0,
      imagenURL: json["imagenUrl"] ?? "no hay imagen",
      genero: json["genero"] ?? "Desconocido",
    );
  }

  where(bool Function(dynamic element) param0) {}
}