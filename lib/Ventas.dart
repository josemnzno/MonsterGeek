import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GenerarVenta extends StatefulWidget {
  @override
  _GenerarVentaState createState() => _GenerarVentaState();
}

class _GenerarVentaState extends State<GenerarVenta> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _selectedItems = [];
  double _total = 0.0;

  Future<Map<String, dynamic>?> _searchItem(String query) async {
    List<String> collections = [
      'autos',
      'comics',
      'comics_lote',
      'figuras',
      'articulos'
    ];

    for (String collection in collections) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('serie', isEqualTo: query) // Busca por la serie
          .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        var data = doc.data() as Map<String, dynamic>?;
        return {
          'id': doc.id,
          'nombre': data != null && data.containsKey('nombre')
              ? data['nombre']
              : 'Sin nombre',
          'precio': data?['precio'] ?? 0.0,
          'serie': data?['serie'] ?? 'Sin serie', // Agrega la serie
          'piezas': data?['piezas'] ?? 0, // Agrega las piezas
          'coleccion': collection
        };
      }
    }

    return null; // No se encontró el artículo
  }

  void _addItem(Map<String, dynamic> item, int quantity) {
    double subtotal = item['precio'] * quantity;

    setState(() {
      _selectedItems.add({
        ...item,
        'cantidad': quantity,
        'subtotal': subtotal
      });
      _total += subtotal;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _total -= _selectedItems[index]['subtotal'];
      _selectedItems.removeAt(index);
    });
  }

  Future<void> _saveSale() async {
    CollectionReference sales = FirebaseFirestore.instance.collection('ventas');

    await sales.add({
      'fecha': DateTime.now(),
      'total': _total,
      'articulos': _selectedItems.map((item) {
        return {
          'nombre': item['nombre'],
          'cantidad': item['cantidad'],
          'precio_unitario': item['precio'],
          'subtotal': item['subtotal'],
          'coleccion': item['coleccion'],
          'id': item['id']
        };
      }).toList(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Venta generada correctamente')),
    );

    setState(() {
      _selectedItems.clear();
      _total = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generar Venta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar artículo',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    String query = _searchController.text.trim();
                    if (query.isNotEmpty) {
                      Map<String, dynamic>? item = await _searchItem(query);
                      if (item != null) {
                        _showQuantityDialog(item);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Artículo no encontrado')),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedItems.length,
                itemBuilder: (context, index) {
                  var item = _selectedItems[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['nombre']),
                      subtitle: Text(
                          'Serie: ${item['serie']}\n' +
                              'Piezas: ${item['piezas']}\n' +
                              'Cantidad: ${item['cantidad']}\n' +
                              'Subtotal: \$${item['subtotal'].toStringAsFixed(
                                  2)}'
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeItem(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text('Total: \$${_total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedItems.isNotEmpty ? _saveSale : null,
              child: Text('Generar Venta'),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuantityDialog(Map<String, dynamic> item) {
    final TextEditingController _quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cantidad para ${item['nombre']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Precio: \$${item['precio']}'),
              Text('Serie: ${item['serie']}'), // Muestra la serie
                Text('Inventario disponible: ${item['piezas']}'),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Cantidad'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                int quantity = int.tryParse(_quantityController.text) ?? 0;
                if (quantity > 0 && (item['coleccion'] != 'articulos' ||
                    quantity <= item['piezas'])) {
                  _addItem(item, quantity);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(
                        'Cantidad inválida${item['coleccion'] == 'articulos'
                            ? ' o supera el inventario disponible'
                            : ''}')),
                  );
                }
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
}
