class UsuarioPost {
  final String nombre;  // Cambié "name" por "nombre"
  final String email;
  final String contrasena;  // Cambié "password" por "contraseña"

  UsuarioPost({
    required this.nombre,
    required this.email,
    required this.contrasena,
  });

  // Constructor para crear un objeto desde un JSON
  factory UsuarioPost.fromJson(Map<String, dynamic> json) {
    return UsuarioPost(
      nombre: json['nombre'],  // Cambiado "nombre" por "name" para que coincida con la API
      email: json['email'],
      contrasena: json['contraseña'],  // Cambiado "contraseña" por "password" para que coincida con la API
    );
  }

  // Método para convertir el objeto en un JSON con el formato correcto
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,  // Cambiado "nombre" por "name"
      'email': email,
      'contraseña': contrasena,  // Cambiado "contraseña" por "password"
    };
  }
}
