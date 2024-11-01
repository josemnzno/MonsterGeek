import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monstergeek/AdministrarAuto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        actions: _buildNavLinks(),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildAdminMenu(context), // Pasamos `context` aquí
            _buildFooterBanner(),
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

  Widget _buildAdminMenu(BuildContext context) { // Se acepta `context` como argumento
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

  Widget _buildFooterBanner() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('lib/assets/hotwheels.png', height: 100),
          Image.asset('lib/assets/lego.png', height: 50),
          Image.asset('lib/assets/funko.png', height: 50),
        ],
      ),
    );
  }

  List<Widget> _buildNavLinks() {
    return [
      _navLink('Inicio'),
      _navLink('Autos a Escala'),
      _navLink('Figuras'),
      _navLink('Cómics'),
      _navLink('Cafetería'),
      _navLink('Servicios'),
      GestureDetector(
        onTap: () {
          // Implementar la lógica del icono aquí
        },
        child: Image.asset('lib/assets/icono.png', height: 30),
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
}
