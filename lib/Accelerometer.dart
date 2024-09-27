import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerScreen extends StatefulWidget {
  @override
  State<AccelerometerScreen> createState() => _AccelerometerScreenState();
}

class _AccelerometerScreenState extends State<AccelerometerScreen> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);

  UserAccelerometerEvent? _userAccelerometerEvent;
  AccelerometerEvent? _accelerometerEvent;

  int? _userAccelerometerLastInterval;
  int? _accelerometerLastInterval;
  DateTime? _userAccelerometerUpdateTime;
  DateTime? _accelerometerUpdateTime;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Duration sensorInterval = SensorInterval.normalInterval;

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          final now = DateTime.now();
          setState(() {
            _userAccelerometerEvent = event;
            if (_userAccelerometerUpdateTime != null) {
              final interval = now.difference(_userAccelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _userAccelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _userAccelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support User Accelerometer Sensor"),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          final now = DateTime.now();
          setState(() {
            _accelerometerEvent = event;
            if (_accelerometerUpdateTime != null) {
              final interval = now.difference(_accelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _accelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _accelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support Accelerometer Sensor"),
              );
            },
          );
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

  @override
  Widget build(BuildContext context) {
    // Use accelerometer data to modify gradient
    double x = _accelerometerEvent?.x ?? 0;
    double y = _accelerometerEvent?.y ?? 0;
    double z = _accelerometerEvent?.z ?? 0;

    // Normalize the accelerometer values for color mapping (between 0 and 1)
    double normalizedX = (x + 10) / 20;
    double normalizedY = (y + 10) / 20;
    double normalizedZ = (z + 10) / 20;

    // Create a gradient color that changes with the accelerometer values
    Color color1 = Color.lerp(Colors.blue, const Color.fromARGB(255, 209, 54, 244), normalizedX)!;
    Color color2 = Color.lerp(const Color.fromARGB(255, 33, 109, 232), Colors.purple, normalizedY)!;
    Color color3 = Color.lerp(const Color.fromARGB(255, 0, 140, 255), Colors.cyan, normalizedZ)!;

    return Scaffold(
      extendBodyBehindAppBar: true, // Extends the gradient behind the AppBar
      appBar: AppBar(
        title: const Text('Accelerometer'),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove shadow under the AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color1, color2, color3],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "User Accelerometer",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("X: ${_userAccelerometerEvent?.x.toStringAsFixed(1) ?? '?'}"),
                      SizedBox(width: 10),
                      Text("Y: ${_userAccelerometerEvent?.y.toStringAsFixed(1) ?? '?'}"),
                      SizedBox(width: 10),
                      Text("Z: ${_userAccelerometerEvent?.z.toStringAsFixed(1) ?? '?'}"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('${_userAccelerometerLastInterval?.toString() ?? '?'} ms'),
                  SizedBox(height: 30),
                  Text(
                    "Accelerometer",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("X: ${_accelerometerEvent?.x.toStringAsFixed(1) ?? '?'}"),
                      SizedBox(width: 10),
                      Text("Y: ${_accelerometerEvent?.y.toStringAsFixed(1) ?? '?'}"),
                      SizedBox(width: 10),
                      Text("Z: ${_accelerometerEvent?.z.toStringAsFixed(1) ?? '?'}"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('${_accelerometerLastInterval?.toString() ?? '?'} ms'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
