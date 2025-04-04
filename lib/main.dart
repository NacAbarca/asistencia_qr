
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'screens/docente_qr_screen.dart';
// import 'screens/estudiante_scan_screen.dart';
import 'screens/login_screen.dart';
// import 'screens/role_router_screen.dart';
// import 'screens/docente_panel_screen.dart';
// import 'screens/test_screen.dart';

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 👈 generado por flutterfire


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asistencia QR',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), // o RoleRouterScreen()
    );
  }
}



