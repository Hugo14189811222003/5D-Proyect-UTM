import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/Apis/apiPrimerosAuxilio.dart';
import 'package:proyect_app/Apis/userApi.dart';
import 'package:proyect_app/models/models.dart';
import 'package:proyect_app/models/primerosAuxilio.dart';
import 'package:proyect_app/screem/home/pageGu%C3%ADas/listCategoria/listCategoria.dart';

class Verticalguiasbody extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  const Verticalguiasbody({super.key, required this.screenHeight, required this.screenWidth});

  @override
  State<Verticalguiasbody> createState() => _VerticalguiasbodyState();
}

class _VerticalguiasbodyState extends State<Verticalguiasbody> {
  final ScrollController _scrollController = ScrollController();
  List<PrimerosAuxilios> _auxilio = [];
  List<PrimerosAuxilios> _auxilioFiltrados = [];
  int _paginaActual = 1;
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    _fetchMoreAuxilio();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading){
        _fetchMoreAuxilio();
      };
    });
  }

  Future<void> _fetchMoreAuxilio() async {
    if(_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try{
      final auxilioFect = await PrimeroAuxilioGet(_paginaActual); 
      if(auxilioFect.isNotEmpty){
        setState(() {
          _auxilio.addAll(auxilioFect);
          _auxilioFiltrados = _auxilio;
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
        _auxilioFiltrados = _auxilio;
      } else {
        _auxilioFiltrados = _auxilio.where((auxilio) =>
            auxilio.titulo.toLowerCase().contains(query.toLowerCase()) ||
            auxilio.categoria.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
    print("Usuarios filtrados: ${_auxilioFiltrados.length}"); // Verifica si realmente se está filtrando
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 237, 237, 237),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
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
              child: Text('Categoria', style: GoogleFonts.fredoka(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25),),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _auxilioFiltrados.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if(index == _auxilioFiltrados.length){
                      return _isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink();
                    }
                    final auxilio = _auxilioFiltrados[index];
                    return LayoutBuilder(
                      builder: (context, Constraints) {
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    scale: 8,
                                    auxilio.imagenUrl,
                                    fit: BoxFit.cover, // Ajusta la imagen al contenedor
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error,  weight: screenHeightConstrain * 0.6,);
                                    },
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 170,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text(auxilio.categoria.isNotEmpty ? auxilio.categoria : "no hay resumen", style: GoogleFonts.fredoka(color: Colors.black, fontSize: screenWidthConstrain * 0.21,  fontWeight: FontWeight.w500),),
                                          SizedBox(height: 5,),
                                          SizedBox(
                                            height: screenHeightConstrain * 0.45,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                width: 185,
                                                child: Text(auxilio.resumen.isNotEmpty ? auxilio.resumen : "no hay resumen", style: GoogleFonts.fredoka(color: Colors.black, fontSize: screenWidthConstrain * 0.19)),
                                              ),
                                            ),
                                          )
                                          
                                        ],
                                      ),
                                    )
                                    
                                    
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () {
                                      // Navegar sin reemplazar la pantalla actual
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Listcategoria(
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
    );
  }
}