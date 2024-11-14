import 'dart:html'; // Necesario para el iframe
import 'package:flutter/material.dart';
import 'dart:ui_web';
import 'package:firebase_core/firebase_core.dart';
import 'package:monstergeek/AutosEscala/VentaAutos.dart';
import 'package:monstergeek/IniciarSesion.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Princial());
}

class Princial extends StatelessWidget {
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
  bool isServicesHovered = false; // Para controlar el hover del menú de servicios

  @override
  void initState() {
    super.initState();
    // Registrar el iframe para Google Maps
    platformViewRegistry.registerViewFactory(
      'google-maps',
          (int viewId) => IFrameElement()
        ..src = "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3791.3617054670085!2d-94.42482262615084!3d18.14724418047402!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x85e98399b675949d%3A0xc7d56bed76c74cf!2sMonstergeek!5e0!3m2!1ses-419!2smx!4v1729704890114!5m2!1ses-419!2smx"
        ..style.border = 'none'
        ..style.height = '350px'
        ..style.width = '100%',
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
        actions: _buildNavLinks(),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildMapAndAddressSection(),
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: Image.asset('lib/assets/icono.png', height: 30),
      ),
    ];
  }

  Widget _navLink(String text) {
    return TextButton(
      onPressed: () {
        if (text == 'Autos a Escala') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Ventaautos()),
          );
        } else {
          // Aquí puedes agregar la lógica de navegación para otras opciones
          print("Selected: $text");
        }
      },
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildServicesDropdown() {
    return MouseRegion(
      onEnter: (_) => setState(() => isServicesHovered = true),
      onExit: (_) => setState(() => isServicesHovered = false),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          // Lógica para navegar a la sección correspondiente
          print("Selected: $value");
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'Cafetería', child: Text('Cafetería')),
          PopupMenuItem(value: 'Sublimación', child: Text('Sublimación')),
          PopupMenuItem(value: 'Impresión 3D', child: Text('Impresión 3D')),
          PopupMenuItem(value: 'Ensamblaje PC', child: Text('Ensamblaje de PC')),
        ],
        child: TextButton(
          onPressed: () {}, // Puedes dejar esto vacío si usas hover
          child: Text('Servicios', style: TextStyle(color: Colors.white)),
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

  Widget _buildMapAndAddressSection() {
    return Column(
      children: [
        Container(
          color: Color(0xFFFCE14D),
          padding: EdgeInsets.symmetric(horizontal: 20), // Ajuste aquí
          child: Text(
            '¿Dónde nos encuentras?                                                                                                                                                                                                                                                                                                                                  ',
            style: TextStyle(
              fontSize: 26,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 500,
                  height: 350,
                  child: HtmlElementView(viewType: 'google-maps'),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
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
                    ),
                    SizedBox(width: 20),
                    Image.asset('lib/assets/grenlim.png', height: 300), // Imagen al lado derecho
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      children: [
        Container(
          color: Color(0xFFFCE14D),
          padding: EdgeInsets.symmetric(horizontal: 20), // Ajuste aquí
          child: Text(
            'Categorías                                                                                                                                                                                                                                                                                                                                                 ',
            style: TextStyle(
              fontSize: 26,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryItem('lib/assets/autos.jfif', 'Autos a Escala'),
            _buildCategoryItem('lib/assets/comics.jfif', 'Cómics'),
            _buildCategoryItem('lib/assets/funkos.jfif', 'Figuras'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String imagePath, String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'Autos a Escala') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Ventaautos()),
          );
        }
      },
      child: Column(
        children: [
          SizedBox(height: 30),
          Image.asset(imagePath, height: 250, width: 250),
          Text(title, style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
          SizedBox(height: 50),
        ],
      ),
    );
  }


  Widget _buildServicesSection() {
    return Column(
      children: [
        Container(
          color: Color(0xFFFCE14D),
          padding: EdgeInsets.symmetric(horizontal: 20), // Ajuste aquí
          child: Text(
            'Servicios                                                                                                                                                                                                                                                                                                                                                      ',
            style: TextStyle(
              fontSize: 26,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildServiceItem('lib/assets/cafeteria.png', 'Cafetería'),
            _buildServiceItem('lib/assets/sublimacion.png', 'Sublimación'),
            _buildServiceItem('lib/assets/impresion.png', 'Impresión 3D'),
            _buildServiceItem('lib/assets/ensamble.png', 'Ensamblajes de PC'),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceItem(String imagePath, String title) {
    return Column(
      children: [
        SizedBox(height: 30),
        Image.asset(imagePath, height: 250, width: 250),
        Text(title, style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
        SizedBox(height: 50),
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
          SizedBox(height: 10),
          Text('© 2024 Monster Geek. Todos los derechos reservados.', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset('lib/assets/hotwheels.png', height: 100),
        Image.asset('lib/assets/lego.png', height: 50),
        Image.asset('lib/assets/funko.png', height: 50),
      ],
    );
  }
}
