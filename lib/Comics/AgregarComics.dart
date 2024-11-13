import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:html' as html; // Importa dart:html para la web
import 'dart:async'; // Importa para usar Completer

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Agregarcomics());
}

class Agregarcomics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Geek',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: AgregarComics(),
    );
  }
}

class AgregarComics extends StatefulWidget {
  @override
  _AgregarComicsState createState() => _AgregarComicsState();
}class _AgregarComicsState extends State<AgregarComics> {
  html.File? _selectedImage; // Variable para almacenar la imagen seleccionada

  // Controladores de texto
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _serieController = TextEditingController();
  final TextEditingController _piezasController = TextEditingController(text: '1');
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController(text: 'Comic');
  final TextEditingController _precioController = TextEditingController();

  // Variable para manejar la selección de la marca
  String _marcaSeleccionada = 'Marvel'; // Valor por defecto

  bool _isLoading = false; // Controla el estado de carga (si el botón está bloqueado)

  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          _selectedImage = files.first; // Asigna la imagen seleccionada
        });
      }
    });
  }

  Future<String> _getImageUrl(html.File file) async {
    final reader = html.FileReader();
    final completer = Completer<String>();

    reader.readAsDataUrl(file); // Lee la imagen como Data URL
    reader.onLoadEnd.listen((event) {
      completer.complete(reader.result as String); // Devuelve la URL de la imagen
    });

    return completer.future;
  }

  Future<String?> _subirImagen() async {
    if (_selectedImage == null) return null;

    try {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(_selectedImage!); // Lee la imagen como ArrayBuffer

      await reader.onLoadEnd.first;

      // Convierte el resultado en un Blob
      final data = reader.result as List<int>;
      final blob = html.Blob([data], 'image/${_selectedImage!.type.split('/')[1]}');

      // Obtén una referencia al almacenamiento de Firebase
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('imagenes_comics/${DateTime.now().toString()}');

      // Sube el blob
      await storageRef.putBlob(blob);

      // Obtén la URL de la imagen subida
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error al subir la imagen: $e');
      return null;
    }
  }

  void _guardarArticulo() async {
    setState(() {
      _isLoading = true; // Deshabilita el botón mientras se guarda el artículo
    });

    try {
      // Sube la imagen y obtén la URL
      String? imagenUrl = await _subirImagen();

      // Crear un documento en la colección "autos"
      await FirebaseFirestore.instance.collection('comics').add({
        'marca': _marcaSeleccionada == 'Otro' ? _marcaController.text : _marcaSeleccionada,
        'serie': _serieController.text,
        'piezas': int.tryParse(_piezasController.text) ?? 0,
        'modelo': _modeloController.text,
        'descripcion': _descripcionController.text,
        'precio': double.tryParse(_precioController.text) ?? 0.0,
        'imagenUrl': imagenUrl,
      });

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Artículo agregado exitosamente')),
      );

      // Limpiar los campos, pero mantener los valores de piezas, descripción y escala
      _marcaController.clear();
      _serieController.clear();
      _precioController.clear();
      _modeloController.clear();

      setState(() {
        _selectedImage = null; // Limpiar la imagen seleccionada
        _isLoading = false; // Rehabilitar el botón
      });
    } catch (e) {
      // Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar el artículo: $e')),
      );
      setState(() {
        _isLoading = false; // Rehabilitar el botón
      });
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
        iconTheme: IconThemeData(
          color: Colors.white,  // Cambiar el color del icono (flecha de retroceso) a blanco
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              color: Colors.lightBlueAccent,
              padding: EdgeInsets.all(100),
              width: 1000,  // Aquí ajustas el ancho del cuadro
              height: 800, // Aquí ajustas la altura del cuadro
              child: Row(
                children: [
                  // Formulario de entrada de datos
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agregar Comic',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Dropdown para la marca
                        Row(
                          children: [
                            Text('Marca:', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 10),
                            DropdownButton<String>(
                              value: _marcaSeleccionada,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _marcaSeleccionada = newValue!;
                                });
                              },
                              items: <String>['Marvel', 'DC', 'Otro']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        // Si selecciona 'Otro', se muestra el campo de texto
                        if (_marcaSeleccionada == 'Otro')
                          _buildTextField('Escribe la marca', _marcaController),
                        SizedBox(height: 10),
                        _buildTextField('Serie', _serieController),
                        SizedBox(height: 10),
                        _buildTextField('Precio', _precioController),
                        SizedBox(height: 10),
                        _buildTextField('Año', _modeloController),
                        SizedBox(height: 10),
                        _buildTextField('Tipo', _descripcionController),
                        SizedBox(height: 10),
                        _buildTextField('Piezas disponibles', _piezasController),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.yellow,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          ),
                          onPressed: _isLoading ? null : _guardarArticulo, // Bloquear el botón mientras se carga
                          child: _isLoading
                              ? CircularProgressIndicator() // Mostrar cargando
                              : Text('Agregar', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Área para la imagen
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 400,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: _selectedImage != null
                            ? FutureBuilder<String>(
                          future: _getImageUrl(_selectedImage!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              return Image.network(snapshot.data!, fit: BoxFit.cover);
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error al cargar la imagen'));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        )
                            : Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Row(
      children: [
        Text(
          '$label:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            ),
          ),
        ),
      ],
    );
  }
}
