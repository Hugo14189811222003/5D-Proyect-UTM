import 'package:flutter/material.dart';
import 'dart:math';
import 'package:proyect_app/Apis/apiMonitoreo/apiMonitoreo.dart';
import 'package:proyect_app/models/monitoreo/modeloMonitoreo.dart';

class circlePorce1 extends StatelessWidget {
  final int mascotaId;

  const circlePorce1({super.key, required this.mascotaId});

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
  final int mascotaId;

  const MonitoreoScreen({super.key, required this.mascotaId});

  @override
  _MonitoreoScreenState createState() => _MonitoreoScreenState();
}

class _MonitoreoScreenState extends State<MonitoreoScreen> {
  double pulso = 0.0; // Inicializar pulso en 0
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
        pulso = filtrados.last.pulso.toDouble(); // Último pulso de esa mascota
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        pulso = 0.0; // Si no hay datos, pulso en 0
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator() // Mostrar carga mientras se obtienen los datos
          : TemperatureCircle(
              pulso: pulso, // Mostrar el pulso de la mascota seleccionada
              minTemp: 0,
              maxTemp: 200, // Ajusta el máximo según los valores que puedas obtener
            ),
    );
  }
}

class TemperatureCircle extends StatelessWidget {
  final double pulso;
  final double minTemp;
  final double maxTemp;

  const TemperatureCircle({
    Key? key,
    required this.pulso,
    required this.minTemp,
    required this.maxTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = ((pulso - minTemp) / (maxTemp - minTemp))
        .clamp(0.0, 1.0); // Normaliza el valor entre 0 y 1

    return SizedBox(
      width: 150,
      height: 150,
      child: CustomPaint(
        painter: CirclePercentagePainter(percentage),
        child: Center(
          child: Text(
            '${pulso.toStringAsFixed(0)} BPM', // Mostramos el pulso en BPM
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
