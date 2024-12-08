import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monstergeek/AutosEscala/AgregarAutosLote.dart';
import 'package:monstergeek/AutosEscala/EditarAuto.dart';
import 'package:monstergeek/AutosEscala/EliminarAuto.dart';

import 'AgregarAuto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AdministrarAutoMobileApp());
}

class AdministrarAutoMobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Geek',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: AdministrarAutoMobile(),
    );
  }
}

class AdministrarAutoMobile extends StatelessWidget {
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset('lib/assets/supercars.png', height: 150),
              SizedBox(height: 20),
              Text(
                'Autos a escala',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildOptionButton(context, 'Agregar', AgregarAuto()),
              SizedBox(height: 20),
              _buildOptionButton(context, 'Eliminar', EliminarAuto()),
              SizedBox(height: 20),
              _buildOptionButton(context, 'Editar', EditarAuto()),
              SizedBox(height: 20),
              _buildOptionButton(context, 'Agregar autos lote', AgregarAuto()),
              SizedBox(height: 30),
              Image.asset('lib/assets/llantas.png', height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String text, Widget screen) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
