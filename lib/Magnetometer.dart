import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Ripple {
  double radius;
  double speed;
  double opacity; // Added opacity property

  Ripple({required this.radius, required this.speed, this.opacity = 1.0});
}

class MagnetometerScreen extends StatefulWidget {
  @override
  State<MagnetometerScreen> createState() => _MagnetometerScreenState();
}

class _MagnetometerScreenState extends State<MagnetometerScreen> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  static const int _maxRipples = 10; // Maximum number of ripples
  static const double _maxRippleSpeed = 10.0; // Maximum speed for ripples

  MagnetometerEvent? _magnetometerEvent;
  int? _magnetometerLastInterval;
  DateTime? _magnetometerUpdateTime;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Duration sensorInterval = SensorInterval.normalInterval;

  // List to hold active ripples
  List<Ripple> _ripples = [];

  @override
  void initState() {
    super.initState();

    _streamSubscriptions.add(
      magnetometerEventStream(samplingPeriod: sensorInterval).listen(
        (MagnetometerEvent event) {
          final now = event.timestamp;
          setState(() {
            _magnetometerEvent = event;
            if (_magnetometerUpdateTime != null) {
              final interval = now.difference(_magnetometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _magnetometerLastInterval = interval.inMilliseconds;
              }
            }

            // Calculate the speed for new ripples based on magnetometer magnitude
            double calculatedSpeed = (event.x.abs() + event.y.abs() + event.z.abs()) / 10;
            double rippleSpeed = calculatedSpeed.clamp(0.0, _maxRippleSpeed); // Apply speed limit

            // Spawn a new ripple only if the limit is not reached
            if (_ripples.length < _maxRipples) {
              _ripples.add(Ripple(radius: 1, speed: rippleSpeed)); // Start with a small radius
            }

            // Clean up ripples that are too big
            _ripples.removeWhere((ripple) => ripple.radius > 200);
          });

          _magnetometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Magnetometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );

    // Start a timer to update the ripples more frequently
    Timer?.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        // Update the radius and opacity of each ripple
        for (var ripple in _ripples) {
          ripple.radius += ripple.speed; // Smooth growth based on speed
          ripple.opacity = 1.0 - (ripple.radius / 200.0).clamp(0.0, 1.0); // Decrease opacity
        }
      });
    });
  }

  @override
  void dispose() {
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Magnetometer Ripple Effect'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Stack(
          children: [
            CustomPaint(
              painter: RipplePainter(ripples: _ripples),
              child: Container(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    _buildSensorValueRow('X:', _magnetometerEvent?.x),
                    SizedBox(width: 8),
                    _buildSensorValueRow('Y:', _magnetometerEvent?.y),
                    SizedBox(width: 8),
                    _buildSensorValueRow('Z:', _magnetometerEvent?.z),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                const SizedBox(height: 16),
                Text(
                  '${_magnetometerLastInterval?.toString() ?? '?'} ms',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorValueRow(String label, double? value) {
    return Text(
      value != null ? label + " " + value.toStringAsFixed(1) : '?',
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final List<Ripple> ripples;

  RipplePainter({required this.ripples});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Draw each ripple with its current opacity
    for (var ripple in ripples) {
      paint.color = Colors.blue.withOpacity(ripple.opacity); // Set opacity
      canvas.drawCircle(size.center(Offset.zero), ripple.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint to show ripple growth and fading
  }
}
