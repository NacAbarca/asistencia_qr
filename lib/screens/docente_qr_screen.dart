import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class DocenteQRScreen extends StatefulWidget {
  @override
  _DocenteQRScreenState createState() => _DocenteQRScreenState();
}

class _DocenteQRScreenState extends State<DocenteQRScreen> {
  String selectedAsignatura = 'Matemáticas';
  String qrData = '';
  final uuid = Uuid();

  List<String> asignaturas = [
    'Matemáticas',
    'Lengua',
    'Historia',
    'Ciencias',
    'Educación Física',
  ];

  void generarQR() {
    final now = DateTime.now();
    final fechaHora = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final data = {
      'id': uuid.v4(),
      'asignatura': selectedAsignatura,
      'fecha_hora': fechaHora,
    };

    setState(() {
      qrData = jsonEncode(data); // ✅ Serializamos en JSON válido
      print("📦 QR generado: $qrData"); // 👈🏼 Esto imprime el contenido exacto
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generar Código QR')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedAsignatura,
              onChanged: (value) {
                setState(() {
                  selectedAsignatura = value!;
                });
              },
              items: asignaturas.map((asignatura) {
                return DropdownMenuItem(
                  value: asignatura,
                  child: Text(asignatura),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: generarQR,
              icon: Icon(Icons.qr_code),
              label: Text('Generar QR'),
            ),
            SizedBox(height: 40),
            if (qrData.isNotEmpty)
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250.0,
              ),
            if (qrData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'QR generado para $selectedAsignatura',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
