import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/Apis/userApi.dart';
import 'package:proyect_app/models/models.dart';
import 'package:proyect_app/screem/home/pageGu%C3%ADas/listCategoria/infoAnimal/infoAnimal.dart';

class Listcategoria extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  const Listcategoria({super.key, required this.screenHeight, required this.screenWidth});

  @override
  State<Listcategoria> createState() => _ListcategoriaState();
}

class _ListcategoriaState extends State<Listcategoria> {
  final ScrollController _scrollController = ScrollController();
  List<Usuario> _usuarios = [];
  List<Usuario> _usuariosFiltrados = [];
  int _paginaActual = 1;
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    _usuariosFiltrados = [];
    _fetchMoreUsuario();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading){
        _fetchMoreUsuario();
      };
    });
  }

  Future<void> _fetchMoreUsuario() async {
    setState(() {
      _isLoading = true;
    });

    try{
      final usuariosFect = await fetchUsuarios(_paginaActual);
      if(usuariosFect.isNotEmpty){
        setState(() {
          _usuarios.addAll(usuariosFect);
          _usuariosFiltrados = _usuarios;
          _paginaActual++;
        });
      }
    } catch (err) {
      print('Problemas al cargar los datos, error: ${err}');
    } finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

    void _filtrarUsuarios(String query) {
    setState(() {
      if (query.isEmpty) {
        _usuariosFiltrados = _usuarios;
      } else {
        _usuariosFiltrados = _usuarios.where((usuario) =>
            usuario.nombre.toLowerCase().contains(query.toLowerCase()) ||
            usuario.email.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
    print("Usuarios filtrados: ${_usuariosFiltrados.length}"); // Verifica si realmente se está filtrando
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 132, 103),
        toolbarHeight: 70,
        title: Text("Guia de primeros auxilios"),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 237, 237, 237),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: TextFormField(
                  onChanged: (value) {
                    _filtrarUsuarios(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Buscar...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black)
                      
                    ),
                     
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("Herida y hemorragias", style: GoogleFonts.fredoka(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25),),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _usuariosFiltrados.length + 1,
                    itemBuilder: (context, index) {
                      if(index == _usuariosFiltrados.length){
                        return _isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink();
                      }
                      final usuario = _usuariosFiltrados[index];
                      return LayoutBuilder(
                        builder: (context, Constraints ) {
                          final screenWidthConstrain = widget.screenWidth * 0.18;
                          final screenHeightConstrain = widget.screenHeight * 0.18;
                          return Container(
                            width: double.infinity,
                            height: widget.screenHeight * 0.18,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color.fromARGB(255, 255, 255, 255)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.photo_album, size: 100, color: Colors.black26,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(usuario.nombre.isNotEmpty ? usuario.nombre : "no hay nombre", style: GoogleFonts.fredoka(color: Colors.black, fontSize: screenWidthConstrain * 0.21,  fontWeight: FontWeight.w500),),
                                      SizedBox(height: 5,),
                                      Text(usuario.email.isNotEmpty ? usuario.email : "no hay email", style: GoogleFonts.fredoka(color: Colors.black, fontSize: screenWidthConstrain * 0.18)),
                                      
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navegar sin reemplazar la pantalla actual
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => infoAnimal(
                                            screenHeight: widget.screenHeight,
                                            screenWidth: widget.screenWidth,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.arrow_forward),
                                  ),
                                  SizedBox(height: 30)
                                ],
                              ),
                            ),
                          );
                        }
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}