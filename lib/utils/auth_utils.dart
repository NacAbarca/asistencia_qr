import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart'; // Asegurate que esta ruta sea correcta

Future<void> cerrarSesionYVolverAlLogin(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
  );
}
