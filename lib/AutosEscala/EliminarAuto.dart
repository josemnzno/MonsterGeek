import 'dart:html'; // Para ImageElement y platformViewRegistry
import 'dart:ui_web';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      home: EliminarAuto(),
    );
  }
}

class EliminarAuto extends StatefulWidget {
  @override
  _EliminarAutoState createState() => _EliminarAutoState();
}

class _EliminarAutoState extends State<EliminarAuto> {
  List<Map<String, dynamic>> _articulos = []; // Lista de artículos
  List<Map<String, dynamic>> _articulosOriginal = []; // Lista original
  final TextEditingController _buscarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarArticulos(); // Cargar los artículos al iniciar
  }

  Future<void> _cargarArticulos() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('autos').get();
      setState(() {
        _articulos = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
        _articulosOriginal = List.from(_articulos); // Guardar la lista original
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar artículos: $e')));
    }
  }

  Future<void> _eliminarArticulo(
      String id,
      String? imagenUrl,
      String descripcion,
      String serie,
      String marca,
      String modelo,
      String precio,
      ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.62,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imagenUrl != null && imagenUrl.isNotEmpty)
                    HtmlImageView(imageUrl: imagenUrl)
                  else
                    Icon(Icons.image_not_supported, size: 100),
                  SizedBox(height: 10),
                  Text('Marca: $marca'),
                  SizedBox(height: 10),
                  Text('Modelo: $modelo'),
                  SizedBox(height: 10),
                  Text('Serie: $serie'),
                  SizedBox(height: 10),
                  Text('Descripción: $descripcion'),
                  SizedBox(height: 10),
                  Text('Precio: $precio'),
                  SizedBox(height: 10),
                ],
              ),
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
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  // Borrar la imagen de Firebase Storage si existe
                  if (imagenUrl != null && imagenUrl.isNotEmpty) {
                    await FirebaseStorage.instance.refFromURL(imagenUrl).delete();
                  }

                  // Eliminar el documento de Firestore
                  await FirebaseFirestore.instance.collection('autos').doc(id).delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Artículo eliminado exitosamente')),
                  );

                  // Recargar la lista de artículos
                  _cargarArticulos();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar el artículo: $e')),
                  );
                }
                Navigator.of(context).pop();
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
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarArticulo(
                      articulo['id'],
                      articulo['imagenUrl'],
                      articulo['descripcion'],
                      articulo['serie'],
                      articulo['marca'],
                      articulo['modelo'],
                      articulo['precio'].toString(), // Asegúrate de pasar el precio como cadena
                    ),
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
      final serieLower = articulo['serie']?.toString().toLowerCase() ?? ''; // Agrega la serie a la búsqueda
      final searchLower = query.toLowerCase();

      return marcaLower.contains(searchLower) ||
          modeloLower.contains(searchLower) ||
          serieLower.contains(searchLower); // Filtra también por serie
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
          (int viewId) => ImageElement()
        ..src = imageUrl
        ..style.objectFit = 'contain',
    );

    return SizedBox(
      width: 200, // Ancho fijo
      height: 200, // Alto fijo
      child: HtmlElementView(viewType: viewId),
    );
  }
}

