import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IniciarSesion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Geek',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: LoginPage(),
    );
  }
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

List<Widget> _buildNavLinks() {
  return [
    _navLink('Inicio'),
    _navLink('Autos a Escala'),
    _navLink('Figuras'),
    _navLink('Cómics'),
    _navLink('Cafetería'),
    GestureDetector(
      onTap: () {
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
class LoginPage extends StatelessWidget {
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
        child: Column(
          children: [
            _buildLoginForm(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }



  Widget _buildLoginForm() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Iniciar sesión',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Text('Correo:', style: TextStyle(fontSize: 18)),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: 'monstergeekoficial@gmail.com',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Text('Contraseña:', style: TextStyle(fontSize: 18)),
          SizedBox(height: 5),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: '****************',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Lógica de inicio de sesión
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    'Acceder',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Lógica para recuperar la contraseña
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Text(
                  'o',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para registrarse
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('lib/assets/hotwheels.png', height: 100),
              Image.asset('lib/assets/lego.png', height: 50),
              Image.asset('lib/assets/funko.png', height: 50),
            ],
          ),
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
