import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AgregarcomicsLote());
}

class AgregarcomicsLote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Geek',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: AgregarComicsLote(),
    );
  }
}

class AgregarComicsLote extends StatefulWidget {
  @override
  _AgregarComicsState createState() => _AgregarComicsState();
}

class _AgregarComicsState extends State<AgregarComicsLote> {
  // Controladores de texto
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _serieController = TextEditingController();
  final TextEditingController _piezasController = TextEditingController(text: '1');
  final TextEditingController _precioController = TextEditingController(text: '30');

  // FocusNode para el campo de la serie
  final FocusNode _serieFocusNode = FocusNode();

  // Variable para manejar la selección de la marca
  String _marcaSeleccionada = 'Marvel'; // Valor por defecto
  bool _isLoading = false; // Controla el estado de carga

  Future<void> _guardarArticulo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String marca = _marcaSeleccionada == 'Otro' ? _marcaController.text.trim() : _marcaSeleccionada;
      String serie = _serieController.text.trim();
      int piezas = int.tryParse(_piezasController.text) ?? 0;
      double precio = double.tryParse(_precioController.text) ?? 0.0;

      // Validar campos obligatorios
      if (serie.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La serie no puede estar vacía')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (precio <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El precio debe ser mayor a 0')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Realiza una búsqueda precisa en la base de datos
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('comics_lote')
          .where('serie', isEqualTo: serie)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Si existe, actualiza el stock disponible
        DocumentSnapshot existingDoc = querySnapshot.docs.first;
        int existingPiezas = existingDoc['piezas'] ?? 0;

        await FirebaseFirestore.instance
            .collection('comics_lote')
            .doc(existingDoc.id)
            .update({'piezas': existingPiezas + piezas});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stock actualizado correctamente')),
        );
      } else {
        // Si no existe, crea un nuevo documento
        await FirebaseFirestore.instance.collection('comics_lote').add({
          'marca': marca,
          'serie': serie,
          'piezas': piezas,
          'precio': precio,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Artículo agregado exitosamente')),
        );
      }

      // Limpiar los campos de serie y piezas, pero mantener la marca y el precio
      _serieController.clear();
      _piezasController.text = '1';

      // Si "Otro" está seleccionado, mantener el texto ingresado en la marca
      if (_marcaSeleccionada != 'Otro') {
        _marcaSeleccionada = 'Marvel'; // Mantener la selección si no es "Otro"
      }

      // Mantener el foco en el campo de la serie
      FocusScope.of(context).requestFocus(_serieFocusNode);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Geek', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agregar Comics',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Marca:', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _marcaSeleccionada,
                    onChanged: (String? newValue) {
                      setState(() {
                        _marcaSeleccionada = newValue!;
                        if (_marcaSeleccionada != 'Otro') {
                          _marcaController.clear();
                        }
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
              if (_marcaSeleccionada == 'Otro')
                _buildTextField('Escribe la marca', _marcaController, null),
              SizedBox(height: 10),
              _buildTextField('Serie', _serieController, _serieFocusNode),
              SizedBox(height: 10),
              _buildTextField('Precio', _precioController, null),
              SizedBox(height: 10),
              _buildTextField('Piezas disponibles', _piezasController, null),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _guardarArticulo,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Guardar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, FocusNode? focusNode) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onSubmitted: (_) => _guardarArticulo(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
