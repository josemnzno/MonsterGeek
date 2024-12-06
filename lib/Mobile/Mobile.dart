import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:monstergeek/AutosEscala/VentaAutos.dart';
import 'package:monstergeek/Comics/VentaComics.dart';
import 'package:monstergeek/Figuras/VentaFiguras.dart';
import 'package:monstergeek/IniciarSesion.dart';
import 'package:monstergeek/Mobile/IniciarSesionMobile.dart';
import '../firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(PrincipalMobile());
}

class PrincipalMobile extends StatelessWidget {
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
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white), // Cambia el color de los íconos a blanco

      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/logo.png', height: 80),
                  Text('Monster Geek', style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            _drawerItem('Inicio'),
            _drawerItem('Autos a Escala', Ventaautos()),
            _drawerItem('Figuras', Ventafiguras()),
            _drawerItem('Cómics', Ventacomics()),
            _drawerItem('Iniciar Sesión', LoginPageMobile()),
          ],
        ),
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

  Widget _drawerItem(String title, [Widget? page]) {
    return ListTile(
      title: Text(title),
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
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
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: Color(0xFFFCE14D),
          child: const Text(
            '¿Dónde nos encuentras?'                                                                        ,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dirección: Guerrero #505, Coatzacoalcos, Ver, México', style: TextStyle(fontSize: 16)),
              Text('Horario: Lunes-Sábado: 11am - 6pm, Domingo: 11am - 5pm', style: TextStyle(fontSize: 16)),
              TextButton(
                onPressed: () {},
                child: Text('Monster Geek en Facebook', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: Color(0xFFFCE14D),
          child: Text(
            'Categorías',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          children: [
            _buildCategoryItem('lib/assets/autos.jfif', 'Autos a Escala', Ventaautos()),
            _buildCategoryItem('lib/assets/comics.jfif', 'Cómics', Ventacomics()),
            _buildCategoryItem('lib/assets/funkos.jfif', 'Figuras', Ventafiguras()),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String imagePath, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        children: [
          Image.asset(imagePath, height: 100, fit: BoxFit.cover),
          Text(title, style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: Color(0xFFFCE14D),
          child: Text(
            'Servicios',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
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
        Image.asset(imagePath, height: 100, fit: BoxFit.cover),
        Text(title, style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black,
      child: Column(
        children: [
          Text('© 2024 Monster Geek. Todos los derechos reservados.', style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
