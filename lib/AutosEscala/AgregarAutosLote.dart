import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AgregarArticuloSimple());
}

class AgregarArticuloSimple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agregar Artículo',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: AgregarArticulo(),
    );
  }
}

class AgregarArticulo extends StatefulWidget {
  @override
  _AgregarArticuloState createState() => _AgregarArticuloState();
}

class _AgregarArticuloState extends State<AgregarArticulo> {
  bool _isLoading = false;

  // Función para seleccionar y procesar el archivo Excel
  Future<void> _cargarArchivoExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
      );

      if (result != null) {
        setState(() {
          _isLoading = true;
        });

        Uint8List? bytes = result.files.first.bytes;
        if (bytes == null) throw Exception("No se pudo leer el archivo");

        var excel = Excel.decodeBytes(bytes);

        // Leer la primera hoja del archivo Excel
        var sheet = excel.tables[excel.tables.keys.first];

        if (sheet != null) {
          for (var row in sheet.rows.skip(1)) {
            // Suponiendo que las columnas son:
            // Código, Precio Venta, Inventario
            String? codigo = row[0]?.value?.toString();

            // Procesar Precio Venta para eliminar el símbolo "$"
            String? precioRaw = row[1]?.value?.toString();
            double? precioVenta = precioRaw != null
                ? double.tryParse(precioRaw.replaceAll(RegExp(r'[^0-9.]'), ''))
                : 0.0;

            // Procesar Inventario como entero
            int? inventario = 0;
            if (row[2]?.value != null) {
              inventario = int.tryParse(row[2]!.value.toString().split('.')[0]);
            }
            if (inventario == null) inventario = 0;

            if (codigo != null) {
              await _guardarArticuloEnFirebase(
                codigo: codigo,
                precioVenta: precioVenta ?? 0.0,
                inventario: inventario,
              );
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Artículos importados exitosamente')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar el archivo: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para guardar un artículo en Firebase
  Future<void> _guardarArticuloEnFirebase({
    required String codigo,
    required double precioVenta,
    required int inventario,
  }) async {
    try {
      // Verificar si ya existe un artículo con el mismo código
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('articulos')
          .where('codigo', isEqualTo: codigo)
          .get();

      if (query.docs.isNotEmpty) {
        // Si existe, actualizar el inventario
        DocumentSnapshot doc = query.docs.first;
        await doc.reference.update({
          'inventario': (doc['inventario'] as int) + inventario,
          'precioVenta': precioVenta, // Actualizar el precio si cambia
        });
      } else {
        // Si no existe, agregar un nuevo artículo
        await FirebaseFirestore.instance.collection('articulos').add({
          'codigo': codigo,
          'precioVenta': precioVenta,
          'inventario': inventario,
        });
      }
    } catch (e) {
      print('Error al guardar en Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Artículo desde Excel'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: _cargarArchivoExcel,
          child: Text('Cargar Archivo Excel'),
        ),
      ),
    );
  }
}
