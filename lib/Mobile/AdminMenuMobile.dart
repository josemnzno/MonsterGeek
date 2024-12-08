import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monstergeek/Comics/AdministrarComics.dart';
import 'package:monstergeek/Figuras/AdministrarFiguras.dart';
import 'package:monstergeek/Mobile/AutosEscalaMobile/AdministrarAutoMobile.dart';
import 'package:monstergeek/Mobile/Mobile.dart';
import '../AutosEscala/AdministrarAuto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(AdminMenuApp());
  } catch (e) {
    print('Error inicializando Firebase: $e');
  }
}

class AdminMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Geek',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: AdminMenuHome(),
    );
  }
}

class AdminMenuHome extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PrincipalMobile()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sesión cerrada exitosamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Geek', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () => _signOut(context),
            child: Text('Cerrar Sesión'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, // Cambia el color del texto a rojo
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          _buildAdminCard('Administrar Inventario', [
            {'label': 'Autos a Escala', 'route': AdministrarAutoMobileApp()},
            {'label': 'Figuras', 'route': AdministrarFigura()},
            {'label': 'Cómics', 'route': AdministrarComics()},
          ], context),
          SizedBox(height: 10),
          _buildAdminCard('Administrar Empleados', [
            {'label': 'Empleados'},
            {'label': 'Permisos'},
            {'label': 'Accesos'},
          ], context),
          SizedBox(height: 10),
          _buildAdminCard('Administrar Servicios', [
            {'label': 'Cafetería'},
            {'label': 'Sublimación'},
            {'label': 'Impresión 3D'},
            {'label': 'Ensamble PC'},
          ], context),
          SizedBox(height: 10),
          _buildAdminCard('Administrar Ventas', [
            {'label': 'Tienda'},
            {'label': 'Pedidos'},
            {'label': 'Ventas'},
          ], context),
        ],
      ),
    );
  }

  Widget _buildAdminCard(String title, List<Map<String, dynamic>> items, BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            ...items.map((item) => ListTile(
              title: Text(item['label']),
              onTap: item['route'] != null
                  ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item['route']),
              )
                  : null,
            )),
          ],
        ),
      ),
    );
  }
}
