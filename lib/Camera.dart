import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'; // Import for path provider
import 'dart:io'; // Import for File

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras; // Declare cameras as a final variable

  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  int currentCameraIndex = 0; // Track the current camera index

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    controller = CameraController(
        widget.cameras[currentCameraIndex], ResolutionPreset.max);
    _initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _toggleCamera() async {
    currentCameraIndex =
        (currentCameraIndex + 1) % widget.cameras.length; 
    controller = CameraController(
        widget.cameras[currentCameraIndex], ResolutionPreset.max);
    _initializeControllerFuture =
        controller.initialize();
    setState(() {});
  }

  Future<void> _captureImage() async {
    try {
      await _initializeControllerFuture;

      final XFile image = await controller.takePicture();

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now()}.png';

      await File(imagePath).writeAsBytes(await image.readAsBytes());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to $imagePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                CameraPreview(controller),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _toggleCamera, // Toggle camera button
                        child: const Text('Toggle Camera'),
                      ),
                      ElevatedButton(
                        onPressed: _captureImage, // Capture button
                        child: const Text('Capture'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
