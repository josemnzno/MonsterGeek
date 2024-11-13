import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monstergeek/Comics/AdministrarComics.dart';
import 'package:monstergeek/Figuras/AdministrarFiguras.dart';

import 'package:monstergeek/main.dart';
import 'AutosEscala/AdministrarAuto.dart'; // Página de administración de Autos a escala

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Adminmenu());
}

class Adminmenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Geek',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: AdminMenu(),
    );
  }
}

class AdminMenu extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Princial()), // Vuelve a la página de inicio
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sesión cerrada exitosamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('lib/assets/logo.png', height: 40),
            SizedBox(width: 10),
            Text('Monster Geek', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: _buildNavLinks(context),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildAdminMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      color: Colors.black,
      child: Center(
        child: Image.asset('lib/assets/banner.png', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildAdminMenu(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Administrador',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _buildAdminCard('Administrar Inventario', [
                  'Autos a escala',
                  'Figuras',
                  'Comics'
                ], context),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildAdminCard('Administrar Empleados', [
                  'Empleados',
                  'Permisos',
                  'Accesos'
                ], context),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _buildAdminCard('Administrar Servicios', [
                  'Cafetería',
                  'Sublimación',
                  'Impresión 3D',
                  'Ensamble PC'
                ], context),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildAdminCard('Administrar Ventas', [
                  'Tienda',
                  'Pedidos',
                  'Ventas'
                ], context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(String title, List<String> items, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: InkWell(
              onTap: () {
                if (item == 'Autos a escala') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdministrarAuto(),
                    ),
                  );
                } else if (item == 'Figuras') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdministrarFigura(),
                    ),
                  );
                }else if (item == 'Comics') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdministrarComics(),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.yellow,
                child: Center(
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  List<Widget> _buildNavLinks(BuildContext context) {
    return [
      _navLink('Inicio'),
      _navLink('Autos a Escala'),
      _navLink('Figuras'),
      _navLink('Cómics'),
      _navLink('Cafetería'),
      _navLink('Servicios'),
      PopupMenuButton<String>(
        icon: Image.asset('lib/assets/icono.png', height: 30),
        onSelected: (value) {
          if (value == 'Cerrar sesión') {
            _signOut(context);
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              value: 'Cerrar sesión',
              child: Text('Cerrar sesión'),
            ),
          ];
        },
      ),
    ];
  }

  Widget _navLink(String text) {
    return TextButton(
      onPressed: () {
        // Implementar la lógica de navegación aquí
      },
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  Widget _footerLink(String text) {
    return TextButton(
      onPressed: () {
        // Implementar la lógica para cada enlace aquí
      },
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
