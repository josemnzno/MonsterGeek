import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monstergeek/AdminMenu.dart';
import 'package:monstergeek/Mobile/AdminMenuMobile.dart';
import 'package:monstergeek/Mobile/Mobile.dart';
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
      home: PrincipalMobile(), // Página de inicio
    );
  }
}

class LoginPageMobile extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageMobile> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

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
        MaterialPageRoute(builder: (context) => AdminMenuApp()),
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
        iconTheme: IconThemeData(color: Colors.white), // Cambia el color de los íconos a blanco

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildLoginForm(context),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
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
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: '****************',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 10),
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



  Widget _footerLink(String text) {
    return TextButton(
      onPressed: () {
        // Implementar la lógica para cada enlace aquí
      },
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
