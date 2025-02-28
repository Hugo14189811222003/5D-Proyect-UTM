import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const circlePorce());
}

class circlePorce extends StatelessWidget {
  const circlePorce({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: TemperatureCircle(temperature: 0, minTemp: 0, maxTemp: 100),
        ),
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
      ..shader = LinearGradient(
        colors: [const Color.fromARGB(255, 14, 203, 162)],
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
