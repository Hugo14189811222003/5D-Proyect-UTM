import 'package:flutter/material.dart';
import 'package:proyect_app/Apis/userApi.dart';
import 'package:proyect_app/models/models.dart';
import 'package:proyect_app/screem/search/buscadorUsuario.dart';

class ListaUsuario extends StatefulWidget {
  const ListaUsuario({super.key});

  @override
  State<ListaUsuario> createState() => _ListaUsuarioState();
}

class _ListaUsuarioState extends State<ListaUsuario> {
  final ScrollController _scrollController = ScrollController();
  List<Usuario> _usuarios = [];
  List<Usuario> _usuariosFiltrados = [];  // Lista para los usuarios filtrados
  int _paginaActual = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMoreUsuarios();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
        _fetchMoreUsuarios();
      }
    });
  }

  Future<void> _fetchMoreUsuarios() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final nuevosUsuarios = await fetchUsuarios(_paginaActual);
      if (nuevosUsuarios.isNotEmpty) {
        setState(() {
          _usuarios.addAll(nuevosUsuarios);
          _usuariosFiltrados = _usuarios; // Inicializa la lista filtrada con todos los usuarios
          _paginaActual++;
        });
      }
    } catch (e) {
      print('Error: $e');
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
        title: Text('Lista de Usuarios', style: TextStyle(color: const Color.fromARGB(255, 0, 80, 0), fontSize: 30)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Navega a la nueva pantalla de búsqueda de usuario
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BuscarUsuario()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _usuariosFiltrados.length + 1,
              itemBuilder: (context, index) {
                if (index == _usuariosFiltrados.length) {
                  return _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink();
                }
                final usuario = _usuariosFiltrados[index];
                return ListTile(
                  tileColor: const Color.fromARGB(255, 0, 0, 0),
                  title: Text(usuario.nombre.isNotEmpty ? usuario.nombre : 'Nombre no disponible', style: TextStyle(color: const Color.fromARGB(255, 81, 255, 0), fontSize: 20)),
                  subtitle: Text(usuario.email.isNotEmpty ? usuario.email : 'Correo no disponible', style: TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
