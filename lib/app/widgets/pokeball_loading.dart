import 'package:flutter/material.dart';

class PokeballLoading extends StatefulWidget {
  const PokeballLoading({super.key, this.size = 48.0});

  final double size;

  @override
  State<PokeballLoading> createState() => _PokeballLoadingState();
}

class _PokeballLoadingState extends State<PokeballLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _PokeballPainter(),
      ),
    );
  }
}

class _PokeballPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Fondo blanco superior
    final topHalfPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159, // -π
      3.14159, // π
      true,
      topHalfPaint,
    );

    // Fondo rojo inferior
    final bottomHalfPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      3.14159, // π
      true,
      bottomHalfPaint,
    );

    // Black center line
    final blackLinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.15;

    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      blackLinePaint,
    );

    // White center circle
    final centerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.35, centerCirclePaint);

    // Black border of center circle
    final centerCircleBorderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.1;

    canvas.drawCircle(center, radius * 0.35, centerCircleBorderPaint);

    // Small inner circle
    final innerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.15, innerCirclePaint);

    // Borde negro exterior
    final outerBorderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08;

    canvas.drawCircle(center, radius - (radius * 0.04), outerBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
