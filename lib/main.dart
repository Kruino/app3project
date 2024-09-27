import 'package:app3project/Accelerometer.dart';
import 'package:app3project/Barometer.dart';
import 'package:app3project/Compass.dart';
import 'package:app3project/Magnetometer.dart';
import 'package:app3project/Map.dart';
import 'package:app3project/Proximity.dart';
import 'package:app3project/ScannerScreen.dart';
import 'package:app3project/Light.dart';
import 'package:app3project/PlaneScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

// ignore: unused_element
late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    _cameras = await availableCameras();
  } catch (e) {}

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pages Example',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
      ),
      home: const FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool isOn = false;

  void toggleSwitch() {
    setState(() {
      isOn = !isOn;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.only(start: 10, end: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // First row of buttons
              Row(
                children: [
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 47, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(
                            color: Colors.blue, // Border color for Gyroscope
                            width: 2,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlaneScreen()),
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.device_unknown, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Gyroscope',
                              style: TextStyle(
                                color: Color.fromARGB(255, 199, 199, 199),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between buttons
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 47, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(
                            color:
                                Colors.yellow, // Border color for Light sensor
                            width: 2,
                          ),
                        ),
                        onPressed: () {
                          // Navigate to the Second Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LightScreen()),
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lightbulb,
                                color: Colors.white), // Light sensor icon
                            SizedBox(
                                height: 10), // Spacing between icon and text
                            Text(
                              'Light sensor',
                              style: TextStyle(
                                color: Color.fromARGB(255, 199, 199, 199),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Add spacing between rows
              // Second row of buttons
              Row(
                children: [
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 47, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(
                            color: Colors.green, // Border color for Scanner
                            width: 2,
                          ),
                        ),
                        onPressed: () {
                          // Navigate to the Second Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScannerScreen()),
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_2_rounded,
                                color: Colors.white), // Scanner icon
                            SizedBox(
                                height: 10), // Spacing between icon and text
                            Text(
                              'Scanner',
                              style: TextStyle(
                                color: Color.fromARGB(255, 199, 199, 199),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between buttons
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 47, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(
                            color: Colors.red, // Border color for Proximity
                            width: 2,
                          ),
                        ),
                        onPressed: () {
                          // Navigate to the Second Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProximityScreen()),
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.near_me,
                                color: Colors.white), // Proximity icon
                            SizedBox(
                                height: 10), // Spacing between icon and text
                            Text(
                              'Proximity',
                              style: TextStyle(
                                color: Color.fromARGB(255, 199, 199, 199),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Add spacing between rows
              Row(
                children: [
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 47, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BarometerScreen()),
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.air_outlined, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Barometer',
                              style: TextStyle(
                                color: Color.fromARGB(255, 199, 199, 199),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 47, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide(
                            color: (isOn ? Colors.green : Colors.yellow),
                            width: (isOn ? 7 : 2),
                          ),
                        ),
                        onPressed: () {
                          if (isOn) {
                            toggleSwitch();
                            TorchLight.disableTorch();
                          } else {
                            toggleSwitch();
                            TorchLight.enableTorch();
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                                isOn
                                    ? Icons.flashlight_on_outlined
                                    : Icons.flashlight_off_rounded,
                                color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Flash Light',
                              style: TextStyle(
                                color: Color.fromARGB(255, 199, 199, 199),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 47, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(
                            color: Colors.purple,
                            width: 2,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccelerometerScreen()),
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.speed_outlined, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Accelerometer',
                              style: TextStyle(
                                color: Color.fromARGB(255, 199, 199, 199),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 47, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(
                            color: Colors.teal,
                            width: 2,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MagnetometerScreen()),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.blur_circular, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Magnetometer',
                              style: TextStyle(
                                color: Color.fromARGB(255, 199, 199, 199),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 47, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 44, 176, 39),
                            width: 2,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapScreen()),
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map,
                                color: Colors.white), // Accelerometer icon
                            SizedBox(
                                height: 10), // Spacing between icon and text
                            Text(
                              'Map',
                              style: TextStyle(
                                color: Color.fromARGB(255, 199, 199, 199),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 47, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 44, 176, 39),
                            width: 2,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompassScreen()),
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.compare_arrows_sharp,
                                color: Colors.white), // Accelerometer icon
                            SizedBox(
                                height: 10), // Spacing between icon and text
                            Text(
                              'Compass',
                              style: TextStyle(
                                color: Color.fromARGB(255, 199, 199, 199),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
