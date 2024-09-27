import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CompassScreen extends StatefulWidget {
  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  MagnetometerEvent _magneticEvent = MagnetometerEvent(0, 0, 0, DateTime.now());
  StreamSubscription? subscription;
  double turns = 0;
  double prevValue = 0;

  @override
  void initState() {
    super.initState();
    subscription = magnetometerEvents.listen((event) {
      setState(() {
        _magneticEvent = event;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  double calculateDegrees(double x, double y) {
    double heading = atan2(x, y);
    heading = (heading * 180 / pi) -90;

    if (heading > 0) {
      heading -= 360;
    }

    heading = heading < 0 ? (360 + heading) : heading;

    double diff = heading - prevValue;
    if (diff.abs() > 180) {
      if (prevValue > heading) {
        diff = 360 - (heading - prevValue).abs();
      } else {
        diff = 360 - (prevValue - heading).abs();
        diff = diff * -1;
      }
    }
    turns += (diff / 360);
    prevValue = heading;
    return heading * -1;
  }

  @override
  Widget build(BuildContext context) {
    final degrees = calculateDegrees(_magneticEvent.x, _magneticEvent.y);
    final angle = -1 * pi / 180 * degrees;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Compass'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${degrees.toStringAsFixed(0)} °'),
            Expanded(
              child: Center(
                  child: Stack(
                children: [
                  Icon(Icons.circle_outlined, size: 300),
                  AnimatedRotation(
                    turns: turns,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 300,
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
