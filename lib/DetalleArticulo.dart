import 'package:flutter/material.dart';

class DetalleArticulo extends StatelessWidget {
  final Map<String, dynamic> articulo;

  const DetalleArticulo({Key? key, required this.articulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(articulo['modelo']),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                articulo['imagenUrl'],
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              articulo['modelo'],
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '\$${articulo['precio']}',
              style: TextStyle(fontSize: 20.0, color: Colors.grey[700]),
            ),
            SizedBox(height: 16.0),
            Divider(),
            Text(
              'Descripción:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              articulo['descripcion'] ?? 'Sin descripción disponible.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Divider(),
            // Agregar más detalles si están disponibles en la base de datos
            if (articulo.containsKey('categoria'))
              Text(
                'Categoría: ${articulo['categoria']}',
                style: TextStyle(fontSize: 16.0),
              ),
            if (articulo.containsKey('disponibilidad'))
              Text(
                'Disponibilidad: ${articulo['disponibilidad'] ? "En stock" : "Agotado"}',
                style: TextStyle(fontSize: 16.0),
              ),
          ],
        ),
      ),
    );
  }
}
