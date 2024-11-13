import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monstergeek/AdminMenu.dart';
import 'package:monstergeek/IniciarSesion.dart';
import 'package:monstergeek/main.dart';

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
      home: Princial(), // Página de inicio
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Variable para controlar la visibilidad de la contraseña

  Future<void> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Inicio de sesión exitoso')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminMenu()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No se encontró un usuario con ese correo.';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta.';
      } else {
        message = 'Error: ${e.message}';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
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
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildLoginForm(context),
          Spacer(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 400,
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
            obscureText: !_isPasswordVisible, // Cambia la visibilidad según el estado
            decoration: InputDecoration(
              hintText: '****************',
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: _isPasswordVisible,
                onChanged: (value) {
                  setState(() {
                    _isPasswordVisible = value!;
                  });
                },
              ),
              Text('Mostrar contraseña'),
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => _signIn(context),
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
