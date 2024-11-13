import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monstergeek/Comics/EditarComics.dart';
import 'package:monstergeek/Comics/EliminarComics.dart';

import 'AgregarComics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Administrarcomics());
}

class Administrarcomics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Geek',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: AdministrarComics(),
    );
  }
}

class AdministrarComics extends StatelessWidget {
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
        iconTheme: IconThemeData(
          color: Colors.white, // Cambiar el color del icono (flecha de retroceso) a blanco
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            _buildInventoryOptions(context),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryOptions(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen de los Vengadores al borde izquierdo
        Image.asset('lib/assets/Vengadores.png', height: 400),

        // Espacio flexible para centrar el contenedor azul
        Spacer(),

        // Contenedor azul centrado
        Container(
          width: 300,
          height: 350,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comics',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              _buildOptionButton(context, 'Agregar'),
              SizedBox(height: 30),
              _buildOptionButton2(context, 'Eliminar'),
              SizedBox(height: 30),
              _buildOptionButton3(context, 'Editar'),
            ],
          ),
        ),

        // Espacio flexible para centrar el contenedor azul


        // Imagen del Joker a la derecha
        Image.asset('lib/assets/joker.png', height: 400),
        Spacer()


      ],
    );
  }

  Widget _buildOptionButton(BuildContext context, String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      onPressed: () {
        if (text == 'Agregar') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarComics()),
          );
        }
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildOptionButton2(BuildContext context, String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      onPressed: () {
        if (text == 'Eliminar') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EliminarComics()),
          );
        }
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildOptionButton3(BuildContext context, String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      onPressed: () {
        if (text == 'Editar') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditarComics()),
          );
        }
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
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
