import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monstergeek/AdminMenu.dart';
import 'package:monstergeek/IniciarSesion.dart';

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
      home: LoginPage(), // Página de inicio
    );
  }
}class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Login exitoso
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inicio de sesión exitoso')));

      // Redirigir a AdminMenu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminMenu()), // Asegúrate de que el nombre sea AdminMenu
      );
    } on FirebaseAuthException catch (e) {
      // Manejo de errores
      String message;
      if (e.code == 'user-not-found') {
        message = 'No se encontró un usuario con ese correo.';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta.';
      } else {
        message = 'Error: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)));
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
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildLoginForm(context),
          Spacer(), // Esto empuja el footer hacia abajo
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3, // 65% del ancho
      height: 350, // Ajusta la altura según sea necesario
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent, // Color de fondo azul
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
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'monstergeekoficial@gmail.com',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Text('Contraseña:', style: TextStyle(fontSize: 18)),
          SizedBox(height: 5),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: '****************',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () => _signIn(context), // Cambiado para llamar a _signIn
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                'Acceder',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
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
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return TextButton(
      onPressed: () {
        // Implementar la lógica para cada enlace aquí
      },
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
