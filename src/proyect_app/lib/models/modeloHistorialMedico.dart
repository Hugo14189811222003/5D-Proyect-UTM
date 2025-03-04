class postHistorialMedico {
  int mascotaId;
  String vacunas;
  String enfermedades;
  String tratamiento;

  postHistorialMedico({
    required this.mascotaId,
    required this.vacunas,
    required this.enfermedades,
    required this.tratamiento,
  });

  factory postHistorialMedico.fromJson(Map<String, dynamic> json) {
    return postHistorialMedico(
      mascotaId: json["mascotaId"] ?? 0,
      vacunas: json["vacunas"] ?? "no hay vacunas",
      enfermedades: json["enfermedades"] ?? "no hay enfermedades",
      tratamiento: json["tratamientos"]?? "no hay enfermedades"
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mascotaId": mascotaId,
      "vacunas": vacunas,
      "enfermedades": enfermedades,
      "tratamientos": tratamiento
    };
  }
}

class getHistorialMedico {
  int mascotaId;
  String vacunas;
  String enfermedades;
  String tratamientos;

  getHistorialMedico({
    required this.mascotaId,
    required this.vacunas,
    required this.enfermedades,
    required this.tratamientos
  });

  factory getHistorialMedico.fromJson(Map<String, dynamic> json) {
    return getHistorialMedico(
      mascotaId: json["mascotaId"] ?? 0,
      vacunas: json["vacunas"] ?? "no hay vacunas",
      enfermedades: json["enfermedades"] ?? "no hay enfermedades",
      tratamientos: json["tratamientos"] ?? "no hay tratamientos"
    );
  }
}