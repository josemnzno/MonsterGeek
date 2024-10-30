import 'dart:html'; // Necesario para el iframe
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monstergeek/IniciarSesion.dart';

void main() {
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isServicesHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('lib/assets/logo.png', height: 40),
            SizedBox(width: 10),
            Text('Monster Geek', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: isMobile ? null : _buildNavLinks(),
        backgroundColor: Colors.black,
      ),
      drawer: isMobile ? Drawer(child: ListView(children: _buildNavLinks())) : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildMapAndAddressSection(isMobile),
            _buildCategoriesSection(),
            _buildServicesSection(),
            _buildFooter(),
          ],
        ),
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
      _buildServicesDropdown(),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IniciarSesion()),
          );
        },
        child: Image.asset('lib/assets/icono.png', height: 30),
      ),
    ];
  }

  Widget _navLink(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildServicesDropdown() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        print("Selected: $value");
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'Cafetería', child: Text('Cafetería')),
        PopupMenuItem(value: 'Sublimación', child: Text('Sublimación')),
        PopupMenuItem(value: 'Impresión 3D', child: Text('Impresión 3D')),
        PopupMenuItem(value: 'Ensamblaje PC', child: Text('Ensamblaje de PC')),
      ],
      child: TextButton(
        onPressed: () {},
        child: Text('Servicios', style: TextStyle(color: Colors.white)),
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

  Widget _buildMapAndAddressSection(bool isMobile) {
    return Column(
      children: [
        Container(
          color: Color(0xFFFCE14D),
          padding: EdgeInsets.all(8),
          child: Text(
            '¿Dónde nos encuentras?',
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: isMobile
              ? Column(
            children: [
              _buildMap(),
              _buildAddress(),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMap(),
              _buildAddress(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return Container(
      width: 500,
      height: 350,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: HtmlElementView(viewType: 'google-maps'),
      ),
    );
  }

  Widget _buildAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dirección: Guerrero #505,', style: TextStyle(fontSize: 24)),
        Text('Coatzacoalcos, Ver, México', style: TextStyle(fontSize: 24)),
        Text('Lunes-Sábado: 11am - 6pm', style: TextStyle(fontSize: 24)),
        Text('Domingo: 11am - 5pm', style: TextStyle(fontSize: 24)),
        TextButton(
          onPressed: () {},
          child: Text('Monster Geek en Facebook', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return _buildSection(
      title: 'Categorías',
      children: [
        _buildCategoryItem('lib/assets/autos.jfif', 'Autos a Escala'),
        _buildCategoryItem('lib/assets/comics.jfif', 'Cómics'),
        _buildCategoryItem('lib/assets/funkos.jfif', 'Figuras'),
      ],
    );
  }

  Widget _buildCategoryItem(String imagePath, String title) {
    return Column(
      children: [
        Image.asset(imagePath, height: 150, width: 150), // Ajuste de tamaño para móviles
        Text(title, style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildServicesSection() {
    return _buildSection(
      title: 'Servicios',
      children: [
        _buildServiceItem('lib/assets/cafeteria.png', 'Cafetería'),
        _buildServiceItem('lib/assets/sublimacion.png', 'Sublimación'),
        _buildServiceItem('lib/assets/impresion.png', 'Impresión 3D'),
        _buildServiceItem('lib/assets/ensamble.png', 'Ensamblajes de PC'),
      ],
    );
  }

  Widget _buildServiceItem(String imagePath, String title) {
    return Column(
      children: [
        Image.asset(imagePath, height: 150, width: 150), // Ajuste de tamaño para móviles
        Text(title, style: TextStyle(fontSize: 20)),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      children: [
        Container(
          color: Color(0xFFFCE14D),
          padding: EdgeInsets.all(10),
          child: Text(title, style: TextStyle(fontSize: 24)),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: children,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text('LEGALES', style: TextStyle(color: Colors.white)),
          _buildFooterLinks(),
          _buildLegalImages(),
        ],
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: [
        _footerLink('Términos de uso'),
        _footerLink('Política de privacidad'),
        _footerLink('Acuerdo de licencia'),
        _footerLink('Información de copyright'),
        _footerLink('Política de cookies'),
      ],
    );
  }

  Widget _footerLink(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildLegalImages() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: [
        Image.asset('lib/assets/hotwheels.png', height: 50),
        Image.asset('lib/assets/lego.png', height: 30),
      ],
    );
  }
}
