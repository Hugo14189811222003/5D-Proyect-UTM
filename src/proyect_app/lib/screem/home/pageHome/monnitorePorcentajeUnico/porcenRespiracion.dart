import 'package:flutter/material.dart';
import 'dart:math';
import 'package:proyect_app/Apis/apiMonitoreo/apiMonitoreo.dart';
import 'package:proyect_app/models/monitoreo/modeloMonitoreo.dart';

void main() {
  runApp(const circlePorce2Res(mascotaId: 1)); // Aquí pasas el ID de la mascota
}

class circlePorce2Res extends StatelessWidget {
  final int mascotaId;

  const circlePorce2Res({super.key, required this.mascotaId});

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
  double respiracion = 0.0; // Inicializar respiración en 0
  bool isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    fetchMonitoreo(); // Llamar a la API al iniciar
  }

  Future<void> fetchMonitoreo() async {
  List<Monitoreo> monitoreos = await getMonitoreo(1); // Obtener datos de la API

  List<Monitoreo> filtrados = monitoreos.where((m) => m.mascotaId == widget.mascotaId).toList();

  if (mounted) { // 👈 Verificar que el widget sigue montado antes de llamar setState()
    setState(() {
      if (filtrados.isNotEmpty) {
        respiracion = filtrados.last.respiracion.toDouble(); // Última temperatura registrada
      } else {
        respiracion = 0.0; // Si no hay datos, temperatura en 0
      }
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator() // Mostrar carga mientras se obtienen los datos
          : TemperatureCircle(
              respiracion: respiracion, // Mostrar la respiración de la mascota seleccionada
              minTemp: 0,
              maxTemp: 100, // Ajusta el máximo según los valores que puedas obtener
            ),
    );
  }
}

class TemperatureCircle extends StatelessWidget {
  final double respiracion;
  final double minTemp;
  final double maxTemp;

  const TemperatureCircle({
    Key? key,
    required this.respiracion,
    required this.minTemp,
    required this.maxTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = ((respiracion - minTemp) / (maxTemp - minTemp))
        .clamp(0.0, 1.0); // Normaliza el valor entre 0 y 1

    return SizedBox(
      width: 150,
      height: 150,
      child: CustomPaint(
        painter: CirclePercentagePainter(percentage),
        child: Center(
          child: Text(
            '${respiracion.toStringAsFixed(0)} RPM', // Mostramos la respiración en "RPM"
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
      ..shader = LinearGradient(
        colors: [Colors.green], // El color se ajusta a rojo
        stops: const [1.0],
      ).createShader(Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2))
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
