import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreen();
}

BuildContext? contextvalue;

bool active = false;
void _showAlertDialog(BuildContext context, String url) {
  if (active == false) {
    active = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Open link'),
          content: Text(url),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                active = false;
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _launchURL(url);
                active = false;
              },
              child: Text('Open'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> _launchURL(String url) async {
  Uri urlConverted = Uri.parse(url);
  if (!await launchUrl(urlConverted)) {
    throw 'Could not launch $url';
  }
}

class _ScannerScreen extends State<ScannerScreen> {
  Barcode? _barcode;

  @override
  void initState() {
    super.initState(); // Call the superclass's initState method
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        '',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });

      _showAlertDialog(contextvalue as BuildContext, _barcode?.displayValue as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    contextvalue = context;
    return Scaffold(
        extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Scanner'),
         backgroundColor: Colors.transparent,
        elevation: 0, ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),
        ],
      ),
    );
  }
}
