class HistorialMedico {
  int? id;
  int mascotaId;

  HistorialMedico({this.id, required this.mascotaId});

  factory HistorialMedico.fromJson(Map<String, dynamic> json) {
    return HistorialMedico(
      id: json["id"] ?? 0,
      mascotaId: json["mascotaId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
  return {
    "mascotaId": mascotaId ?? 0,
  };
}
}

