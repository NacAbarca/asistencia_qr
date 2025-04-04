import 'dart:async';
import 'package:flutter/material.dart';
import 'role_router_screen.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _flashRed();
    _showToast();
  }

  void _flashRed() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        backgroundColor = backgroundColor == Colors.red ? Colors.white : Colors.red;
      });

      if (timer.tick == 4) timer.cancel();
    });
  }

  void _showToast() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = SnackBar(
        content: Text(
          '❌ QR inválido o no reconocido',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[800],
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        margin: const EdgeInsets.only(
          top: 60,
          left: 20,
          right: 20,
        ), // 👈 esto lo sube
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
    // Elegimos color de texto dinámicamente
    final bool isDark = backgroundColor == Colors.red;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color iconColor = isDark ? Colors.white : Colors.red;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text('Error de QR')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 100, color: iconColor),
            SizedBox(height: 20),
            Text(
              '❌ Código QR inválido',
              style: TextStyle(fontSize: 18, color: textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(Icons.refresh),
              label: Text('Volver a escanear'),
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
