import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS_URL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'GPS y URL'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _locationMessage = "";

  void _getLocation() async {
    try {
      Position position = await obtenerGps();
      String url = "http://www.google.com/maps/place/${position.latitude},${position.longitude}";
      setState(() {
        _locationMessage = "Lat: ${position.latitude}, Long: ${position.longitude}";
      });
      await abrirUrl(url);
    } catch (e) {
      setState(() {
        _locationMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_locationMessage),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text("Obtener Ubicación"),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Position> obtenerGps() async {
  bool bGpsHabilitado = await Geolocator.isLocationServiceEnabled();
  if (!bGpsHabilitado) {
    return Future.error('Por favor habilite el servicio de ubicación.');
  }

  LocationPermission bGpsPermiso = await Geolocator.checkPermission();
  if (bGpsPermiso == LocationPermission.denied) {
    bGpsPermiso = await Geolocator.requestPermission();
    if (bGpsPermiso == LocationPermission.denied) {
      return Future.error('Se denegó el permiso para obtener la ubicación.');
    }
  }
  if (bGpsPermiso == LocationPermission.deniedForever) {
    return Future.error('Se denegó el permiso para obtener la ubicación de forma permanente.');
  }

  return await Geolocator.getCurrentPosition();
}

Future<void> abrirUrl(final String sUrl) async {
  final Uri oUri = Uri.parse(sUrl);
  try {
    await launchUrl(
      oUri, // Ej: http://www.google.com/maps/place/6.2502089,-75.5706711
      mode: LaunchMode.externalApplication,
    );
  } catch (oError) {
    return Future.error('No fue posible abrir la url: $sUrl.');
  }
}


