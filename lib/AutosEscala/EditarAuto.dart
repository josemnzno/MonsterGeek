import 'dart:ui_web';
import 'dart:html'; // Para ImageElement y platformViewRegistry
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

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
      home: EditarAuto(),
    );
  }
}

class EditarAuto extends StatefulWidget {
  @override
  _EditarAutoState createState() => _EditarAutoState();
}

class _EditarAutoState extends State<EditarAuto> {
  List<Map<String, dynamic>> _articulos = [];
  List<Map<String, dynamic>> _articulosOriginal = [];
  final TextEditingController _buscarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarArticulos();
  }

  Future<void> _cargarArticulos() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('autos').get();
      setState(() {
        _articulos = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
        _articulosOriginal = List.from(_articulos);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar artículos: $e')));
    }
  }

  Future<void> _editarArticulo(Map<String, dynamic> articulo) async {
    TextEditingController marcaController = TextEditingController(text: articulo['marca']);
    TextEditingController modeloController = TextEditingController(text: articulo['modelo']);
    TextEditingController serieController = TextEditingController(text: articulo['serie']);
    TextEditingController descripcionController = TextEditingController(text: articulo['descripcion']);
    TextEditingController precioController = TextEditingController(text: articulo['precio'].toString());
    TextEditingController piezasController = TextEditingController(text: articulo['piezas'].toString());

    String? imagenUrlActual = articulo['imagenUrl'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Artículo'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (imagenUrlActual != null && imagenUrlActual.isNotEmpty)
                  HtmlImageView(imageUrl: imagenUrlActual),
                SizedBox(height: 16), // Separador entre la imagen y los campos de texto
                TextField(
                  controller: marcaController,
                  decoration: InputDecoration(labelText: 'Marca'),
                ),
                TextField(
                  controller: modeloController,
                  decoration: InputDecoration(labelText: 'Modelo'),
                ),
                TextField(
                  controller: serieController,
                  decoration: InputDecoration(labelText: 'Serie'),
                ),
                TextField(
                  controller: descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: precioController,
                  decoration: InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: piezasController,
                  decoration: InputDecoration(labelText: 'Piezas'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar', style: TextStyle(color: Colors.blue)),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('autos').doc(articulo['id']).update({
                    'marca': marcaController.text,
                    'modelo': modeloController.text,
                    'serie': serieController.text,
                    'descripcion': descripcionController.text,
                    'precio': double.parse(precioController.text),
                    'piezas': int.parse(piezasController.text),
                    'imagenUrl': imagenUrlActual, // Solo conserva la URL de la imagen actual
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Artículo editado exitosamente')));
                  _cargarArticulos();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al editar el artículo: $e')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Artículos'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _buscarController,
              decoration: InputDecoration(
                labelText: 'Buscar Artículo',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filtrarArticulos(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _articulos.length,
              itemBuilder: (context, index) {
                final articulo = _articulos[index];
                return ListTile(
                  title: Text(articulo['marca']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Modelo: ${articulo['modelo']}'),
                      Text('Serie: ${articulo['serie'] ?? 'Sin serie'}'),
                    ],
                  ),
                  leading: articulo['imagenUrl'] != null && articulo['imagenUrl'].isNotEmpty
                      ? HtmlImageView(imageUrl: articulo['imagenUrl'])
                      : Icon(Icons.image_not_supported, size: 50),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editarArticulo(articulo),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _filtrarArticulos(String query) {
    final filteredArticulos = _articulosOriginal.where((articulo) {
      final marcaLower = articulo['marca'].toString().toLowerCase();
      final modeloLower = articulo['modelo'].toString().toLowerCase();
      final serieLower = articulo['serie']?.toString().toLowerCase() ?? '';
      final searchLower = query.toLowerCase();

      return marcaLower.contains(searchLower) || modeloLower.contains(searchLower) || serieLower.contains(searchLower);
    }).toList();

    setState(() {
      _articulos = filteredArticulos;
    });
  }
}

class HtmlImageView extends StatelessWidget {
  final String imageUrl;

  HtmlImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    String viewId = imageUrl.hashCode.toString();
    platformViewRegistry.registerViewFactory(
      viewId,
          (int viewId) => ImageElement()..src = imageUrl..style.objectFit = 'contain',
    );

    return SizedBox(
      width: 200,
      height: 200,
      child: HtmlElementView(viewType: viewId),
    );
  }
}
