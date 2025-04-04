import 'package:flutter/material.dart';
import 'role_router_screen.dart';
import 'dart:async';
class SuccessScreen extends StatefulWidget {
  final String asignatura;
  final String fecha;

  SuccessScreen({required this.asignatura, required this.fecha});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _flashScreen();
    _showToast();
  }

  void _flashScreen() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        backgroundColor = backgroundColor == Colors.green ? Colors.white : Colors.green;
      });

      if (timer.tick == 4) timer.cancel(); // 2 ciclos verde/blanco
    });
  }

  void _showToast() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final snackBar = SnackBar(
      content: Text(
        '✅ Asistencia registrada correctamente',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green[700],
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
      margin: const EdgeInsets.only(
        top: 60,
        left: 20,
        right: 20,
      ), // ⬆️ esto lo posiciona arriba
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  });
}

  @override
  Widget build(BuildContext context) {
    // ✅ Color dinámico según fondo
    final bool isGreen = backgroundColor == Colors.green;
    final Color textColor = isGreen ? Colors.white : Colors.black87;
    final Color iconColor = isGreen ? Colors.white : Colors.green;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text('Asistencia Registrada')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: iconColor),
            SizedBox(height: 20),
            Text(
              '✅ Asistencia registrada',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text('📘 Asignatura: ${widget.asignatura}', style: TextStyle(color: textColor)),
            Text('🕓 Fecha: ${widget.fecha}', style: TextStyle(color: textColor)),
            SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(Icons.home),
              label: Text('Volver al inicio'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => RoleRouterScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
