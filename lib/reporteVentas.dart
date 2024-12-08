import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistorialVentas extends StatefulWidget {
  @override
  _HistorialVentasState createState() => _HistorialVentasState();
}

class _HistorialVentasState extends State<HistorialVentas> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, dynamic>> _filteredSales = [];
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    // Configurar fechas por defecto para los últimos 30 días
    _startDate = DateTime.now().subtract(Duration(days: 30));
    _endDate = DateTime.now();
    _fetchSales();
  }

  Future<void> _fetchSales() async {
    Query query = FirebaseFirestore.instance.collection('ventas');

    // Filtrar por rango de fechas
    if (_startDate != null) {
      query = query.where('fecha', isGreaterThanOrEqualTo: _startDate);
    }
    if (_endDate != null) {
      query = query.where('fecha', isLessThanOrEqualTo: _endDate);
    }

    QuerySnapshot snapshot = await query.get();
    List<Map<String, dynamic>> sales = snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'fecha': (data['fecha'] as Timestamp).toDate(),
        'total': data['total'],
        'articulos': data['articulos'], // Array de artículos
      };
    }).toList();

    setState(() {
      _filteredSales = sales;
      _total = sales.fold(0.0, (sum, sale) => sum + sale['total']);
    });
  }

  Future<void> _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      await _fetchSales();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Ventas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _selectDateRange,
              child: Text('Seleccionar rango de fechas'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _filteredSales.isEmpty
                  ? Center(child: Text('No se encontraron ventas en este rango.'))
                  : ListView.builder(
                itemCount: _filteredSales.length,
                itemBuilder: (context, index) {
                  var sale = _filteredSales[index];
                  var formattedDate =
                  DateFormat('yyyy-MM-dd HH:mm').format(sale['fecha']);
                  return Card(
                    child: ExpansionTile(
                      title: Text('Venta del $formattedDate'),
                      subtitle: Text(
                          'Total: \$${sale['total'].toStringAsFixed(2)}'),
                      children: [
                        Column(
                          children: (sale['articulos'] as List)
                              .map((item) {
                            return ListTile(
                              title: Text(item['nombre']),
                              subtitle: Text(
                                'Cantidad: ${item['cantidad']} | '
                                    'Subtotal: \$${item['subtotal'].toStringAsFixed(2)}',
                              ),
                            );
                          })
                              .toList()
                              .cast<Widget>(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total General: \$${_total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
