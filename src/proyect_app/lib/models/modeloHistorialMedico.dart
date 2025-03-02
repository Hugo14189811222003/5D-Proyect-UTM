
class postHistorialMedico {
  String vacunas;
  String enfermedades;
  String tratamientos;

  postHistorialMedico({
    required this.vacunas,
    required this.enfermedades,
    required this.tratamientos
  });

  factory postHistorialMedico.fromJson(Map<String, dynamic> json) {
    return postHistorialMedico(
      vacunas: json["vacunas"] ?? "no hay vacunas",
      enfermedades: json["enfermedades"] ?? "no hay enfermedades",
      tratamientos: json["tratamientos"] ?? "no hay tratamientos"
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "vacunas": vacunas,
      "enfermedades": enfermedades,
      "tratamientos": tratamientos
    };
  }
}

class getHistorialMedico {
  String vacunas;
  String enfermedades;
  String tratamientos;

  getHistorialMedico({
    required this.vacunas,
    required this.enfermedades,
    required this.tratamientos
  });

  factory getHistorialMedico.fromJson(Map<String, dynamic> json) {
    return getHistorialMedico(
      vacunas: json["vacunas"] ?? "no hay vacunas",
      enfermedades: json["enfermedades"] ?? "no hay enfermedades",
      tratamientos: json["tratamientos"] ?? "no hay tratamientos"
    );
  }
}