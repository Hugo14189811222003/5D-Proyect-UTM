import 'package:flutter/material.dart';
import 'package:proyect_app/Apis/apiUsuarioPorNombre.dart';
import 'package:proyect_app/models/models.dart';

class BuscarUsuario extends StatefulWidget {
  @override
  State<BuscarUsuario> createState() => _BuscarUsuarioState();
}

class _BuscarUsuarioState extends State<BuscarUsuario> {
  final TextEditingController _controller = TextEditingController();  // Controlador para el campo de texto
  Usuario? _usuarioEncontrado;  // Usuario encontrado a través de la búsqueda
  bool _isLoading = false;
  String _error = '';  // Mensaje de error si no se encuentra el usuario

  Future<void> _buscarUsuario() async {
    setState(() {
      _isLoading = true;
      _usuarioEncontrado = null;
      _error = '';  // Limpiar cualquier mensaje de error previo
    });

    try {
      // Convertir el texto a un número entero y llamar a la API con ese valor
      final idUsuario = int.tryParse(_controller.text);  // Intentar parsear el texto a un entero
      if (idUsuario == null) {
        setState(() {
          _error = 'Por favor ingrese un ID válido';
        });
        return;
      }

      print("Buscando usuario con ID: $idUsuario");

      final usuario = await fetchUsuarioPorId(idUsuario);  
      print("Resultado de la búsqueda: $usuario");

      setState(() {
        if (usuario == null) {
          _error = 'Usuario no encontrado';
        } else {
          _usuarioEncontrado = usuario;
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Error al realizar la búsqueda: $e';  // Mostrar el mensaje de error específico
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 255, 8),
        title: Text('Buscar Usuario', style: TextStyle(color: const Color.fromARGB(255, 0, 80, 0), fontSize: 30)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,  // Configurar para aceptar solo números
              decoration: InputDecoration(
                labelText: 'Ingrese ID del usuario',
                border: OutlineInputBorder(),
                errorText: _error.isNotEmpty ? _error : null,  // Mostrar mensaje de error si hay uno
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _buscarUsuario,  // Deshabilitar botón mientras se carga
              child: _isLoading ? CircularProgressIndicator() : Text('Buscar'),
            ),
            SizedBox(height: 16),
            _usuarioEncontrado == null
                ? Container()  // No mostrar nada si no se ha encontrado un usuario
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre: ${_usuarioEncontrado!.nombre}', style: TextStyle(fontSize: 18)),
                      Text('Correo: ${_usuarioEncontrado!.email}', style: TextStyle(fontSize: 18)),
                      // Mostrar otros campos según sea necesario
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
