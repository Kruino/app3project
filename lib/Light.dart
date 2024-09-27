import 'dart:async';
import 'package:ambient_light/ambient_light.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LightScreen extends StatefulWidget {
  @override
  _LightScreenState createState() => _LightScreenState();
}

Color luxToOrangeColor(double lux) {
  const double minLux = 0;
  const double maxLux = 1000;

  double normalizedLux = ((lux * 2) - minLux) / (maxLux - minLux);
  normalizedLux = normalizedLux.clamp(0, 1);


  int red = (255 * normalizedLux).toInt(); 
  int green = (165 * normalizedLux).toInt();
  int blue = 0;

  return Color.fromARGB(255, red, green, blue);
}

class _LightScreenState extends State<LightScreen> {
  double _light = 0.0;
  StreamSubscription? _lightSubscription;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _lightSubscription = AmbientLight().ambientLightStream.listen((double lightLevel) {
      setState(() {
        _light = lightLevel;
      });
    });
  }

  @override
  void dispose() {
    _lightSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Text('Ambient Light Sensor'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        color: luxToOrangeColor(_light), 
        child: Center(
          child: Text(
            '${_light.toStringAsFixed(0)} lux',
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LightScreen(),
  ));
}
