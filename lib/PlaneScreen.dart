import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PlaneScreen extends StatefulWidget {
  @override
  _PlaneScreenState createState() => _PlaneScreenState();
}

class _PlaneScreenState extends State<PlaneScreen> {
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  double _accelX = 0.0;
  double _accelY = 0.0;
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  final double _gyroFactor = 0.98; 
  final double _accelFactor = 0.5;
  final double _lowPassFilterFactor = 0.1;

  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;

  @override
  void initState() {
    super.initState();
    _listenToSensors();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _listenToSensors() {
    // Listen to gyroscope events for smooth rotation
    _gyroSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        x = _applyLowPassFilter(x, event.x);
        y = _applyLowPassFilter(y, event.y);
        z = _applyLowPassFilter(z, event.z);

        // Apply a complementary filter between the gyro and accelerometer
        _rotationX += x * _gyroFactor;
        _rotationY += y * _gyroFactor;
      });
    });

    // Listen to accelerometer for absolute orientation (to avoid drift)
    _accelSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        // Use accelerometer data to stabilize the rotation
        _accelX = (atan2(event.y, event.z) * 180 / pi);
        _accelY = (atan2(event.x, event.z) * 180 / pi);

        // Combine accelerometer and gyroscope data using complementary filter
        _rotationX = _rotationX * (1.0 - _accelFactor) + _accelX * _accelFactor;
        _rotationY = _rotationY * (1.0 - _accelFactor) + _accelY * _accelFactor;
      });
    });
  }

  // A low-pass filter to smooth out sudden spikes in sensor values
  double _applyLowPassFilter(double previousValue, double newValue) {
    return previousValue + (_lowPassFilterFactor * (newValue - previousValue));
  }

  @override
  void dispose() {
    // Cancel the stream subscriptions when the widget is disposed
    _gyroSubscription?.cancel();
    _accelSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gyroscope'),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
              child: Center(
                  child: Transform(
            // Rotate the plane based on both gyroscope and accelerometer data
            transform: Matrix4.identity()
              ..rotateX(_rotationX * pi / 180) // Convert degrees to radians
              ..rotateY(_rotationY * pi / 180),
            alignment: FractionalOffset.center,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 104, 186, 253),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 54, 54, 54).withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 30,
                    offset: Offset(_rotationY * 2,
                        _rotationX * 2), // Offset the shadow dynamically
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'X: ${x.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Y: ${y.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Z: ${z.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ))),
          Container(
            height: 0, // Forced height for the bottom part
            width: double.infinity, // Full width
            color: const Color.fromARGB(255, 49, 49, 49),
            child: Center(child: Text("Bottom Box - Fixed Height")),
          ),
        ],
      )),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PlaneScreen(),
  ));
}
