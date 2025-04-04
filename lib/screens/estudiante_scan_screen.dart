import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'role_router_screen.dart';
import 'error_screen.dart';
import 'success_screen.dart';
import 'dart:convert';

class EstudianteScanScreen extends StatefulWidget {
  @override
  _EstudianteScanScreenState createState() => _EstudianteScanScreenState();
}

class _EstudianteScanScreenState extends State<EstudianteScanScreen> {
  bool yaEscaneado = false;
  String mensaje = '';

  void registrarAsistencia(String raw) async {
  try {
    final dataMap = jsonDecode(raw);

    final String asignatura = dataMap['asignatura'] ?? 'Desconocida';
    final String fecha = DateTime.now().toIso8601String();

    await FirebaseFirestore.instance.collection('asistencias').add({
      'uid_estudiante': FirebaseAuth.instance.currentUser!.uid,
      'nombre_estudiante': FirebaseAuth.instance.currentUser!.displayName,
      'asignatura': asignatura,
      'fecha_hora': fecha,
      'tipo': 'entrada',
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
          asignatura: asignatura,
          fecha: fecha,
        ),
      ),
    );
  } catch (e) {
    print('❌ Error al registrar asistencia: $e');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ErrorScreen()),
    );
  }

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Escanear QR')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final value = barcode.rawValue;
                  if (!yaEscaneado && value != null) {
                    yaEscaneado = true;
                    registrarAsistencia(value);
                    Future.delayed(Duration(seconds: 2), () => 
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => 
                          RoleRouterScreen()
                        ),
                    )
                    );
                    break;
                  }
                }
              },
            ),

          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                mensaje,
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
