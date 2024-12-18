import 'dart:html'; // Para ImageElement y platformViewRegistry
import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monstergeek/main.dart';
import '../Comics/EditarComics.dart';
import '../IniciarSesion.dart';
import '../firebase_options.dart';
import 'VentaAutos.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy()); // Mejora para la gestión de URL en web
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class Detallesauto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Geek',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: Detallesauto(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _articulos = [];
  List<Map<String, dynamic>> _articulosFiltrados = [];
  String _ordenSeleccionado = 'Por Defecto';

  @override
  void initState() {
    super.initState();
    _cargarArticulos();
  }

  Future<void> _cargarArticulos() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('autos').get();
      setState(() {
        _articulos = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
        _articulosFiltrados = List.from(_articulos); // Inicialmente mostrar todos los artículos
        _ordenarArticulos(); // Ordenar inicialmente por defecto
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar artículos: $e')),
      );
    }
  }

  void _filtrarArticulos(String query) {
    setState(() {
      _articulosFiltrados = _articulos.where((articulo) {
        final modelo = articulo['modelo'].toString().toLowerCase();
        return modelo.contains(query.toLowerCase());
      }).toList();
      _ordenarArticulos(); // Vuelve a ordenar después de filtrar
    });
  }

  void _ordenarArticulos() {
    setState(() {
      if (_ordenSeleccionado == 'Precio Ascendente') {
        _articulosFiltrados.sort((a, b) => a['precio'].compareTo(b['precio']));
      } else if (_ordenSeleccionado == 'Precio Descendente') {
        _articulosFiltrados.sort((a, b) => b['precio'].compareTo(a['precio']));
      } else if (_ordenSeleccionado == 'Nombre A-Z') {
        _articulosFiltrados.sort((a, b) => a['modelo'].compareTo(b['modelo']));
      } else if (_ordenSeleccionado == 'Nombre Z-A') {
        _articulosFiltrados.sort((a, b) => b['modelo'].compareTo(a['modelo']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Princial()),
            );
          },
          child: Row(
            children: [
              Image.asset('lib/assets/logo.png', height: 40),
              SizedBox(width: 10),
              Text('Monster Geek', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        actions: _buildNavLinks(),
        backgroundColor: Colors.black,
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
        } else if(text=='Inicio') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Princial()),
          );

          // Aquí puedes agregar la lógica de navegación para otras opciones
          print("Selected: $text");
        }
      },
      child: Text(text, style: TextStyle(color: Colors.white)),
    );


  }


  Widget _buildServicesDropdown() {
    return MouseRegion(
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


  Widget _buildFooter() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text('LEGALES', style: TextStyle(color: Colors.white)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _footerLink('Términos de uso'),
              _footerLink('Política de privacidad'),
              _footerLink('Acuerdo de licencia'),
              _footerLink('Información de copyright'),
              _footerLink('Política de cookies'),
            ],
          ),
          SizedBox(height: 10),
          Text('© 2024 Monster Geek. Todos los derechos reservados.', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
