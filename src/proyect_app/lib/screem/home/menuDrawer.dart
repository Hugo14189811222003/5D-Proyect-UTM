import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class drawerMenuList extends StatelessWidget {
  const drawerMenuList({super.key});

  void _logout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();

    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 132, 103)
                  ),
                  child: Center(child: Text('Menu',style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 30),)),
                ),
                ExpansionTile(
                  collapsedShape: RoundedRectangleBorder(
                    side: BorderSide.none
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none
                  ),
                  backgroundColor: const Color.fromARGB(47, 0, 132, 103),
                  title: Text("Configuraciones", style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 97, 76), fontSize: 18)),
                  children: [
                    ListTile(
                      title: Text("bloque 1", style: GoogleFonts.fredoka(color: const Color.fromARGB(255, 0, 132, 103), fontSize: 14),),
                      onTap: () {
                        
                      },
                    )
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: const Color.fromARGB(255, 0, 132, 103)),
                  title: Text("Cerrar sesión"),
                  onTap: () {
                    _logout(context);
                  },
                )
              ],
            ),
          ),
      ),
    );
  }
}