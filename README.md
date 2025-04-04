🥷🧾 **¡Claro Ignacio! Aquí va tu `README.md` PROFESIONAL regenerado desde cero**  
Listo para copiar y pegar en tu repo `asistencia_qr` sin errores 🧑‍💻🔥

---

## ✅ CONTENIDO COMPLETO `README.md`

```md
# 📲 Asistencia QR

Sistema web + móvil para control digital de asistencias por escaneo QR, diseñado para instituciones educativas.  
Desarrollado con **Flutter + Firebase** e implementa control de acceso por roles: estudiante, docente y supervisora.

---

## 🚀 Funcionalidades principales

- 🔐 Login con Google (Firebase Auth)
- 👤 Asignación de roles:
  - Estudiante: escanea QR
  - Docente: genera QR
  - Supervisora: ve todo
- 🧾 Generación de códigos QR por asignatura
- 📷 Escaneo con cámara (móvil o web)
- 🗓 Registro automático de fecha y hora
- 📊 Dashboard de supervisión con estadísticas
- 📤 Exportación CSV desde paneles
- 📡 Integración completa con Firebase (Auth + Firestore)

---

## 🎬 Capturas (agregá imágenes)

> Podés incluir imágenes de `screenshots/` aquí

```
📌 login.png
📌 docente_qr.png
📌 estudiante_scan.png
📌 supervisora_dashboard.png
```

---

## 🛠️ Instalación rápida (modo local)

```bash
git clone https://github.com/NacAbarca/asistencia_qr.git
cd asistencia_qr
flutter pub get
```

### 📦 Configurar Firebase

```bash
flutterfire configure
```

📁 Asegurate de tener generado:  
`lib/firebase_options.dart`

---

## ▶️ Ejecutar en navegador o dispositivo

```bash
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS (Mac)
```

---

## 🧠 Flujo de roles

| Rol         | Acción principal                           |
|-------------|---------------------------------------------|
| 👨‍🎓 Estudiante  | Escanea QR para registrar su entrada/salida |
| 👨‍🏫 Docente     | Genera QR por materia, exporta asistencia  |
| 🧑‍💼 Supervisora | Ve todas las asistencias, filtra, exporta   |

---

## 📤 Exportación de datos

- Paneles permiten exportar asistencia como `.csv`
- Compatible con Google Sheets, Excel, etc.

---

## 📚 Stack tecnológico

- Flutter 3.29.2 + Dart 3.7
- Firebase (Auth, Firestore, Hosting)
- qr_flutter + mobile_scanner
- Cloud Firestore en tiempo real
- VSCode + GitHub

---

## 🔐 Seguridad

- 🔒 `.gitignore` protege:
  - `firebase_options.dart`
  - Claves privadas
- Reglas Firestore basadas en rol (se pueden extender)

---

## ✍️ Autor

**Ignacio Abarca**  
🔗 [github.com/NacAbarca](https://github.com/NacAbarca)

---

## 📄 Licencia

MIT © 2025  
Podés usar, mejorar y distribuir este proyecto libremente.

---

## ⭐ ¡Colaborá!

Dejá una estrella ⭐ si este proyecto te ayudó o inspiró.  
Pull Requests y mejoras son bienvenidas.
```

---

## ✅ Recomendación final

🧪 Cargalo en tu repo así:

```bash
cd asistencia_qr
touch README.md
# (Pega el contenido arriba)
git add README.md
git commit -m "📝 Agregado README pro"
git push origin main
```

---

💬 ¿Querés que te prepare también?

> ✅ “`CONTRIBUTING.md` para colaboradores”  
> ✅ “archivo de licencia LICENSE.md”  
> ✅ “workflow automático para `firebase deploy` desde GitHub”  

¡Listo para que tu proyecto sea digno de portafolio y vitrina profesional! 🚀👨‍🏫📲