import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        actions: _buildNavLinks(),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            _buildInventoryOptions(),
            SizedBox(height: 50),// Cuadro con opciones en el centro
            _buildFooterBanner(), // Banner al final de la página
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryOptions() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagen a la izquierda
          Image.asset('lib/assets/supercars.png', height: 150),

          SizedBox(width: 20), // Espacio entre la imagen y el cuadro

          // Cuadro azul con las opciones
          Container(
            width: 300, // Ajusta el ancho del cuadro
            height: 400, // Ajusta la altura del cuadro
            padding: EdgeInsets.all(20),
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
                SizedBox(height: 50),
                _buildOptionButton('Agregar'),
                SizedBox(height: 50),
                _buildOptionButton('Eliminar'),
                SizedBox(height: 50),
                _buildOptionButton('Editar'),

              ],
            ),
          ),
          Image.asset('lib/assets/llantas.png', height: 180),


        ],
      ),
    );
  }

  Widget _buildOptionButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.yellow,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      onPressed: () {
        // Implementar la acción para cada botón aquí
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
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
