import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TestScreen extends StatefulWidget {
  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  User? user;
  String? qrData;
  bool yaEscaneado = false;
  String escaneoMensaje = '';
  String asignatura = 'Lengua';

  final List<String> asignaturas = [
    'Lengua',
    'Matemáticas',
    'Ciencias',
    'Historia',
    'Física',
  ];

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      final googleUser = await GoogleSignIn(
        clientId: '714106175491-co2qlfr5he29jkmeg4fgvc0kfbto9b3q.apps.googleusercontent.com', // 👈🏼 cambia por el tuyo si estás en web
      ).signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      user = userCredential.user;
      setState(() {});
    }
  }

  void generarQR() {
    final ahora = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final data = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'asignatura': asignatura,
      'fecha_hora': ahora,
    };
    setState(() {
      qrData = jsonEncode(data);
    });
  }

  void registrarAsistencia(String raw) async {
    try {
      final dataMap = jsonDecode(raw);
      await FirebaseFirestore.instance.collection('asistencias').add({
        'uid_estudiante': user!.uid,
        'nombre_estudiante': user!.displayName,
        'asignatura': dataMap['asignatura'],
        'fecha_hora': DateTime.now().toIso8601String(),
        'tipo': 'entrada',
      });
      setState(() {
        escaneoMensaje = '✅ Asistencia registrada: ${dataMap['asignatura']}';
      });
    } catch (e) {
      setState(() {
        escaneoMensaje = '❌ Error al leer QR';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Test Asistencia QR')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Test Asistencia QR')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('👤 Sesión activa: ${user!.displayName}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: asignatura,
              onChanged: (val) => setState(() => asignatura = val!),
              items: asignaturas
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
            ),
            ElevatedButton.icon(
              onPressed: generarQR,
              icon: Icon(Icons.qr_code),
              label: Text('Generar QR'),
            ),
            SizedBox(height: 20),
            if (qrData != null)
              Column(
                children: [
                  QrImageView(data: qrData!, size: 200),
                  SizedBox(height: 10),
                  Text('📦 Datos QR: $qrData'),
                ],
              ),
            SizedBox(height: 20),
            Text('📸 Escanear QR', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: MobileScanner(
                onDetect: (capture) {
                  if (yaEscaneado) return;
                  final barcode = capture.barcodes.first;
                  if (barcode.rawValue != null) {
                    yaEscaneado = true;
                    registrarAsistencia(barcode.rawValue!);
                  }
                },
              ),
            ),
            SizedBox(height: 10),
            Text(escaneoMensaje),
            Divider(),
            Text('📄 Asistencias Registradas', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 250,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('asistencias')
                    .orderBy('fecha_hora', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      final data = docs[i].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['nombre_estudiante'] ?? ''),
                        subtitle: Text('${data['asignatura']} - ${data['fecha_hora']}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
