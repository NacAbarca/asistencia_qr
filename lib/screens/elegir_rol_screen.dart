import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'role_router_screen.dart';

class ElegirRolScreen extends StatelessWidget {
  final String userId;
  ElegirRolScreen({required this.userId});

  Future<void> setRol(BuildContext context, String rol) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(userId).update({
      'rol': rol, // ✅ Usamos el parámetro dinámico
      'last_seen': DateTime.now().toIso8601String(),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RoleRouterScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¡Bienvenido por primera vez!', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Selecciona tu rol:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => setRol(context, 'estudiante'),
              icon: Icon(Icons.school),
              label: Text('Estudiante'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => setRol(context, 'docente'),
              icon: Icon(Icons.person),
              label: Text('Docente'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => setRol(context, 'supervisora'),
              icon: Icon(Icons.admin_panel_settings),
              label: Text('Supervisora'),
            ),
          ],
        ),
      ),
    );
  }
}
