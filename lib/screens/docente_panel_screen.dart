import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/auth_utils.dart'; // Ajustá la ruta si es distinta
import 'package:csv/csv.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'login_screen.dart';

class DocentePanelScreen extends StatefulWidget {
  const DocentePanelScreen({super.key});

  @override
  State<DocentePanelScreen> createState() => _DocentePanelScreenState();
}

class _DocentePanelScreenState extends State<DocentePanelScreen> {

  String? asignaturaSeleccionada;
  List<String> asignaturasDocente = [];

  @override
  void initState() {
    super.initState();
    cargarAsignaturasDocente();
  }

  Future<void> cerrarSesionYVolverAlLogin(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> cargarAsignaturasDocente() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    final data = doc.data();
    if (data != null && data['asignaturas'] != null) {
      setState(() {
        asignaturasDocente = List<String>.from(data['asignaturas']);
        asignaturaSeleccionada = asignaturasDocente.first;
      });
    }
  }


  Future<void> exportarCSV() async {
    final query = await FirebaseFirestore.instance
        .collection('asistencias')
        .where('asignatura', isEqualTo: asignaturaSeleccionada)
        .orderBy('fecha_hora', descending: false)
        .get();

    List<List<String>> rows = [
      ['Nombre', 'Asignatura', 'Fecha y Hora', 'Tipo'],
    ];

    for (var doc in query.docs) {
      final data = doc.data();
      rows.add([
        data['nombre_estudiante'] ?? '',
        data['asignatura'] ?? '',
        data['fecha_hora'] ?? '',
        data['tipo'] ?? '',
      ]);
    }

    final csvString = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csvString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "asistencias_${asignaturaSeleccionada}.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }





  @override
  Widget build(BuildContext context) {
    if (asignaturaSeleccionada == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Panel Docente')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencias - $asignaturaSeleccionada'),
        actions: [
          DropdownButton<String>(
            value: asignaturaSeleccionada,
            onChanged: (val) {
              setState(() {
                asignaturaSeleccionada = val!;
              });
            },
            items: asignaturasDocente
                .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                .toList(),
          ),
          IconButton(
            icon: Icon(Icons.download),
            tooltip: 'Exportar CSV',
            onPressed: exportarCSV,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => cerrarSesionYVolverAlLogin(context),
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('asistencias')
            .where('asignatura', isEqualTo: asignaturaSeleccionada)
            .orderBy('fecha_hora', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text('No hay asistencias aún'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(data['nombre_estudiante'] ?? 'Sin nombre'),
                subtitle: Text('${data['fecha_hora']} - ${data['tipo'] ?? 'entrada'}'),
              );
            },
          );
        },
      ),
    );
  }
}
