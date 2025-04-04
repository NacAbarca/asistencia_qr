import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:html' as html;

class SupervisoraScreen extends StatefulWidget {

  const SupervisoraScreen({super.key});

  @override
  State<SupervisoraScreen> createState() => _SupervisoraScreenState();
}

class _SupervisoraScreenState extends State<SupervisoraScreen> {
  
  String filtroAsignatura = 'Todos';
  List<String> asignaturasDisponibles = ['Todos'];
  bool loadingAsignaturas = true;

  @override
  void initState() {
    super.initState();
    insertarAsistenciasDePrueba(); // 👈 solo para test, luego lo quitás
    cargarAsignaturas();
  }

  Widget resumenDashboard(List<QueryDocumentSnapshot> docs) {
    final totalAsistencias = docs.length;
    final estudiantes = <String>{};
    final asignaturas = <String>{};
    final entradasPorDia = <String, int>{};

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      estudiantes.add(data['uid_estudiante'] ?? '');
      asignaturas.add(data['asignatura'] ?? '');

      final fecha = (data['fecha_hora'] ?? '').toString().split('T').first;
      if (fecha.isNotEmpty) {
        entradasPorDia[fecha] = (entradasPorDia[fecha] ?? 0) + 1;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📊 Resumen General', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              Text('🟢 Total asistencias: $totalAsistencias'),
              Text('👥 Estudiantes únicos: ${estudiantes.length}'),
              Text('📘 Asignaturas distintas: ${asignaturas.length}'),
            ],
          ),
          SizedBox(height: 20),
          Text('📈 Entradas por fecha:'),
          SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: entradasPorDia.entries.map((e) {
              return Chip(
                label: Text('${e.key.split("-").sublist(1).join("/")} : ${e.value}'),
                backgroundColor: Colors.blue.shade50,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  Future<void> cargarAsignaturas() async {
    final snapshot = await FirebaseFirestore.instance.collection('asistencias').get();
    final todas = snapshot.docs.map((d) => d['asignatura']).toSet().cast<String>().toList();
    setState(() {
      asignaturasDisponibles.addAll(todas);
      loadingAsignaturas = false;
    });
  }

  Stream<QuerySnapshot> obtenerStream() {
    final ref = FirebaseFirestore.instance.collection('asistencias');

    if (filtroAsignatura != 'Todos') {
      return ref
          .where('asignatura', isEqualTo: filtroAsignatura)
          .orderBy('fecha_hora', descending: true)
          .snapshots();
    }

    return ref.orderBy('fecha_hora', descending: true).snapshots();
  }

  void insertarAsistenciasDePrueba() async {
    final firestore = FirebaseFirestore.instance;

    final List<Map<String, dynamic>> asistencias = [
      {
        'nombre_estudiante': 'Carlos Mendoza',
        'uid_estudiante': 'test123',
        'asignatura': 'Lengua',
        'fecha_hora': '2025-04-01T09:00:00',
        'tipo': 'entrada',
      },
      {
        'nombre_estudiante': 'Sofía Torres',
        'uid_estudiante': 'test124',
        'asignatura': 'Lengua',
        'fecha_hora': '2025-04-01T09:03:00',
        'tipo': 'entrada',
      },
      {
        'nombre_estudiante': 'Lucía González',
        'uid_estudiante': 'test125',
        'asignatura': 'Matemáticas',
        'fecha_hora': '2025-04-02T10:00:00',
        'tipo': 'entrada',
      },
      {
        'nombre_estudiante': 'Carlos Mendoza',
        'uid_estudiante': 'test123',
        'asignatura': 'Historia',
        'fecha_hora': '2025-04-03T09:55:00',
        'tipo': 'salida',
      },
      {
        'nombre_estudiante': 'Ana Ríos',
        'uid_estudiante': 'test126',
        'asignatura': 'Física',
        'fecha_hora': '2025-04-03T11:00:00',
        'tipo': 'entrada',
      },
    ];

    for (var data in asistencias) {
      await firestore.collection('asistencias').add(data);
    }

    print('✅ Datos de prueba insertados');

  }

  Future<void> exportarCSV() async {
    Query query = FirebaseFirestore.instance.collection('asistencias');

    if (filtroAsignatura != 'Todos') {
      query = query.where('asignatura', isEqualTo: filtroAsignatura);
    }

    final snapshot = await query.get();

    List<List<String>> rows = [
      ['Nombre', 'Asignatura', 'Fecha y Hora', 'Tipo'],
    ];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
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
      ..setAttribute("download", "asistencias_supervisora.csv")
      ..click();
    html.Url.revokeObjectUrl(url);

    void insertarAsistenciasDePrueba() async {
      final firestore = FirebaseFirestore.instance;

      final List<Map<String, dynamic>> asistencias = [
        {
          'nombre_estudiante': 'Carlos Mendoza',
          'uid_estudiante': 'test123',
          'asignatura': 'Lengua',
          'fecha_hora': '2025-04-01T09:00:00',
          'tipo': 'entrada',
        },
        {
          'nombre_estudiante': 'Sofía Torres',
          'uid_estudiante': 'test124',
          'asignatura': 'Lengua',
          'fecha_hora': '2025-04-01T09:03:00',
          'tipo': 'entrada',
        },
        {
          'nombre_estudiante': 'Lucía González',
          'uid_estudiante': 'test125',
          'asignatura': 'Matemáticas',
          'fecha_hora': '2025-04-02T10:00:00',
          'tipo': 'entrada',
        },
        {
          'nombre_estudiante': 'Carlos Mendoza',
          'uid_estudiante': 'test123',
          'asignatura': 'Historia',
          'fecha_hora': '2025-04-03T09:55:00',
          'tipo': 'salida',
        },
        {
          'nombre_estudiante': 'Ana Ríos',
          'uid_estudiante': 'test126',
          'asignatura': 'Física',
          'fecha_hora': '2025-04-03T11:00:00',
          'tipo': 'entrada',
        },
      ];

      for (var data in asistencias) {
        await firestore.collection('asistencias').add(data);
      }
      print('✅ Datos de prueba insertados');
    }

  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Asistencias'),
        actions: [
          if (!loadingAsignaturas)
            DropdownButton<String>(
              value: filtroAsignatura,
              onChanged: (val) {
                setState(() => filtroAsignatura = val!);
              },
              items: asignaturasDisponibles
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
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacementNamed(context, '/'); // O a tu LoginScreen
            },
),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: obtenerStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text('No hay asistencias aún'));

          return ListView(
            padding: EdgeInsets.symmetric(vertical: 10),
            children: [
              resumenDashboard(docs),
              Divider(),
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  leading: Icon(Icons.badge),
                  title: Text(data['nombre_estudiante'] ?? 'Sin nombre'),
                  subtitle: Text('${data['asignatura']} - ${data['fecha_hora']}'),
                  trailing: Text(data['tipo'] ?? ''),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
