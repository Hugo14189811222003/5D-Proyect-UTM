class Usuario {
  final int id;
  final String nombre;
  final String email;
  final String contrasena;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.contrasena,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? 'Nombre no disponible',  
      email: json['email'] ?? 'Correo no disponible', 
      contrasena: json['contraseña'] ?? 'Contraseña no disponible',
    );
  }
}
