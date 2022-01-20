import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  final double size;
  const ClockView({Key? key, required this.size}) : super(key: key);

  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
      t.cancel();
    }
  
      if (mounted) setState(() {});
    });
    return Container(
      width: widget.size,
      height: widget.size,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();

 // 360 degree div(/) 60 sec = 6 degree in 1 sec
//   var secDegree = DateTime.now().second * 6;

//   var minDegree = DateTime.now().minute * 6;
// // 360 degree (/) [60 sec * 60 min] = 0.1
//   var hourDegree = DateTime.now().second * 0.1;

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()..color = const Color(0xFF444974);
    var outlineBrush = Paint()
      ..color = const Color(0xFFdde2eb)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 25;

    var hourHandBrush = Paint()
      ..shader = const RadialGradient(
              colors: <Color>[Colors.lightBlueAccent, Colors.pink])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 24;

    var minHandBrush = Paint()
      ..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.orange])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 30;

    var secHandBrush = Paint()
      ..shader =
          const RadialGradient(colors: [Colors.brown, Colors.purpleAccent])
              .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 60;

    canvas.drawCircle(center, radius * 0.75, fillBrush);
    canvas.drawCircle(center, radius * 0.75, outlineBrush);

    var dashBrush = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    var outerCircleRadius = radius;
    var innerCircleRadius = radius * 0.9;
    for (double i = 0; i < 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }

    var hourHandX = centerX +
        (radius * 0.4) *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerY +
        (radius * 0.4) *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minHandX =
        centerX + (radius * 0.6) * cos(dateTime.minute * 6 * pi / 180);
    var minHandY =
        centerY + (radius * 0.6) * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX =
        centerX + (radius * 0.6) * cos(dateTime.second * 6 * pi / 180);
    var secHandY =
        centerY + (radius * 0.6) * sin(dateTime.second * 6 * pi / 180);

    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, radius * 0.02, outlineBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
