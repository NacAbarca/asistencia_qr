import 'package:asistencia_qr/screens/docente_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'docente_panel_screen.dart';
import 'estudiante_scan_screen.dart';
import 'supervisora_screen.dart';

class RoleRouterScreen extends StatefulWidget {
  @override
  _RoleRouterScreenState createState() => _RoleRouterScreenState();

}

class _RoleRouterScreenState extends State<RoleRouterScreen> {
  String? rol;

  @override
  void initState() {
    super.initState();
    obtenerRol();
  }

  Future<void> obtenerRol() async {

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final data = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    setState(() {
      rol = data['rol'];
    });

  }

  @override
  Widget build(BuildContext context) {
    if (rol == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (rol == 'estudiante') return EstudianteScanScreen();
    // if (rol == 'docente') return DocentePanelScreen();
    if (rol == 'docente') return DocenteQRScreen();
    if (rol == 'supervisora') return SupervisoraScreen();
    
    return Scaffold(body: Center(child: Text('Rol no reconocido')));
  }


}
