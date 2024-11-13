import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monstergeek/AutosEscala/EditarAuto.dart';
import 'package:monstergeek/AutosEscala/EliminarAuto.dart';

import 'AgregarAuto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AdministrarAuto());
}


class Administrarauto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Geek',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: AdministrarAuto(),
    );
  }
}

class AdministrarAuto extends StatelessWidget {
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
          color: Colors.white,  // Cambiar el color del icono (flecha de retroceso) a blanco
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
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/assets/supercars.png', height: 150),
          SizedBox(width: 20),
          Container(
            width: 300,
            height: 350,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Autos a escala',
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
          Image.asset('lib/assets/llantas.png', height: 180),
        ],
      ),
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
            MaterialPageRoute(builder: (context) => AgregarAuto()),
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
            MaterialPageRoute(builder: (context) => EliminarAuto()),
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
            MaterialPageRoute(builder: (context) => EditarAuto()),
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


