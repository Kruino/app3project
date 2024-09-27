import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';

class ProximitySensor {
  static EventChannel _streamChannel = EventChannel('proximity_sensor');
  static MethodChannel _methodChannel =
      MethodChannel('proximity_sensor_enable');

  static Stream<int> get events {
    return _streamChannel.receiveBroadcastStream().map((event) {
      return event;
    });
  }

  static Future<void> setProximityScreenOff(bool enabled) async {
    await _methodChannel
        .invokeMethod<void>('enableProximityScreenOff', <String, dynamic>{
      'enabled': enabled,
    });
  }
}
class ProximityScreen extends StatefulWidget {
  @override
  State<ProximityScreen> createState() => _ProximityScreenState();
}

class _ProximityScreenState extends State<ProximityScreen> {
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };

    // --------------------------------------------------------------------
    // You only need to make this call if you want to turn off the screen.
    await ProximitySensor.setProximityScreenOff(true).onError((error, stackTrace) {
      print("could not enable screen off functionality");
      return null;
    });
    // --------------------------------------------------------------------

    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Proximity'),
        ),
        body: Center(
          child: Text('Place hand close to the top of the screen'),
        ),
      );
  }
}