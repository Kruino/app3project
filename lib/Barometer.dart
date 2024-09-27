import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BarometerScreen extends StatefulWidget {
  @override
  State<BarometerScreen> createState() => _BarometerScreenState();
}

class _BarometerScreenState extends State<BarometerScreen> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);

  BarometerEvent? _barometerEvent;
  int? _barometerLastInterval;
  DateTime? _barometerUpdateTime;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Duration sensorInterval = SensorInterval.normalInterval;

  double _minPressure = 950; // Low pressure for gradient
  double _maxPressure = 1050; // High pressure for gradient

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      barometerEventStream(samplingPeriod: sensorInterval).listen(
        (BarometerEvent event) {
          final now = event.timestamp;
          setState(() {
            _barometerEvent = event;
            if (_barometerUpdateTime != null) {
              final interval = now.difference(_barometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _barometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _barometerUpdateTime = now;
        },
        onError: (e) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Barometer Sensor"),
                );
              },
            );
          }
        },
        cancelOnError: true,
      ),
    );
  }

  @override
  void dispose() {
    // Cancel all active subscriptions when the widget is disposed
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  // Function to map pressure value to color gradient
  Color _mapPressureToColor(double pressure) {
    // Normalize the pressure between the range
    double t = (pressure - _minPressure) / (_maxPressure - _minPressure);
    // Ensure t is within [0, 1]
    t = t.clamp(0.0, 1.0);

    // Map to a gradient from blue (low pressure) to red (high pressure)
    return Color.lerp(Colors.blue, Colors.red, t)!;
  }

  @override
  Widget build(BuildContext context) {
    double? pressure = _barometerEvent?.pressure;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Barometer'),
        backgroundColor: Colors.transparent,
        elevation: 0, 
      ),
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        color: pressure != null ? _mapPressureToColor(pressure) : Colors.grey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: pressure != null ? pressure : 0,
                ),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return Text(
                    '${value.toStringAsFixed(1)} hPa',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              Text(
                '${_barometerLastInterval?.toString() ?? '?'} ms',
                style: const TextStyle(fontSize: 20, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
