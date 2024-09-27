import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late String streetViewImageUrl;
  Location location = Location();
  LatLng currentLocation = LatLng(0.0, 0.0);
  bool hasLocation = false;
  MapController mapController = MapController();
  final double maxZoomLevel = 18.0;

  @override
  void initState() {
    super.initState();
    streetViewImageUrl = '';
    _getCurrentLocation();
  }

  Future<void> fetchStreetViewImage(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://openstreetview.org/api/imagery?lat=$lat&lon=$lon&max_results=1',
        ),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['imagery'].isNotEmpty) {
          setState(() {
            streetViewImageUrl = data['imagery'][0]['url'];
          });
        } else {
          setState(() {
            streetViewImageUrl = '';
          });
        }
      } else {
        throw Exception('Failed to load street view image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching street view image: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Request permission
      var permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.granted) {
        LocationData locationData = await location.getLocation();
        setState(() {
          currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
          hasLocation = true; 
        });
        

        mapController.move(currentLocation, 15.0); 
        fetchStreetViewImage(currentLocation.latitude, currentLocation.longitude); 
      } else {
        print('Location permission denied');
      }
    } catch (e) {
      print('Could not get location: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng mapCenter = hasLocation ? currentLocation : LatLng(20.0, 0.0); 

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0), 
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _getCurrentLocation(); 
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: mapController, 
              options: MapOptions(
                center: mapCenter, 
                zoom: 15.0, 
                maxZoom: maxZoomLevel,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    if (hasLocation)
                      Marker(
                        point: currentLocation,
                        builder: (ctx) => const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 244, 54, 54),
                          size: 30,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (streetViewImageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                streetViewImageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
