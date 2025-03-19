import 'package:flutter/material.dart';
import 'package:proyect_app/Apis/apiMonitoreo/apiMonitoreo.dart';
import 'dart:math';
import 'package:proyect_app/models/monitoreo/modeloMonitoreo.dart';

class CircleApp extends StatelessWidget {
  final int mascotaId;

  const CircleApp({super.key, required this.mascotaId}); // Recibiendo el ID de la mascota

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: MonitoreoScreen(mascotaId: mascotaId), // Pasando el mascotaId a MonitoreoScreen
        ),
      ),
    );
  }
}

class MonitoreoScreen extends StatefulWidget {
  final int mascotaId; // Recibiendo el ID de la mascota

  const MonitoreoScreen({super.key, required this.mascotaId}); // Recibiendo el ID en el constructor

  @override
  _MonitoreoScreenState createState() => _MonitoreoScreenState();
}

class _MonitoreoScreenState extends State<MonitoreoScreen> {
  double temperatura = 0.0; // Inicializar temperatura en 0
  bool isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    fetchMonitoreo(); // Llamar a la API al iniciar
  }

  Future<void> fetchMonitoreo() async {
    List<Monitoreo> monitoreos = await getMonitoreo(1); // Obtener datos de la API

    // Filtrar los datos por mascotaId
    List<Monitoreo> filtrados = monitoreos.where((m) => m.mascotaId == widget.mascotaId).toList();

    if (filtrados.isNotEmpty) {
      setState(() {
        temperatura = filtrados.last.temperatura.toDouble(); // Última temperatura de esa mascota
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        temperatura = 0.0; // Si no hay datos, temperatura en 0
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator() // Mostrar carga mientras se obtienen los datos
          : TemperatureCircle(
              temperature: temperatura, // Mostrar la temperatura de la mascota seleccionada
              minTemp: 0,
              maxTemp: 100,
            ),
    );
  }
}

class TemperatureCircle extends StatelessWidget {
  final double temperature;
  final double minTemp;
  final double maxTemp;

  const TemperatureCircle({
    Key? key,
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = ((temperature - minTemp) / (maxTemp - minTemp))
        .clamp(0.0, 1.0); // Normaliza el valor entre 0 y 1

    return SizedBox(
      width: 150,
      height: 150,
      child: CustomPaint(
        painter: CirclePercentagePainter(percentage),
        child: Center(
          child: Text(
            '${temperature.toStringAsFixed(1)}°C',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class CirclePercentagePainter extends CustomPainter {
  final double percentage;

  CirclePercentagePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    Paint foregroundPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    Offset center = size.center(Offset.zero);
    double radius = size.width / 2 - 5;
    double startAngle = -pi / 2;
    double sweepAngle = 2 * pi * percentage;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(CirclePercentagePainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
