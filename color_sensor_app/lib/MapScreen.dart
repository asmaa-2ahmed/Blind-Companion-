import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_database/firebase_database.dart';

class MapScreen extends StatefulWidget {
  MapScreen();
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double? latFromFirebase;
  double? lngFromFirebase;
  late DatabaseReference addressRef;
  late DatabaseReference linkRef;
  late DatabaseReference longitudeRef;
  late DatabaseReference latitudeRef;

  @override
  void initState() {
    super.initState();
    DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    addressRef = databaseRef.child('/MyApp/Address');
    longitudeRef = addressRef.child('/longitude ');
    latitudeRef = addressRef.child('/latitude ');

    latitudeRef.onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        setState(() {
          latFromFirebase = double.parse(value.toString());
        });
      }
    });

    longitudeRef.onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        setState(() {
          lngFromFirebase = double.parse(value.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: latFromFirebase != null && lngFromFirebase != null
            ? FlutterMap(
                options: MapOptions(
                    center: LatLng(latFromFirebase!, lngFromFirebase!),
                    zoom: 17,
                    maxZoom: 18.49),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(latFromFirebase!, lngFromFirebase!),
                        width: 50,
                        height: 50,
                        builder: (_) => Image.asset(
                          'images/marker_6.png',
                          // width: 70,
                          // height: 70,
                          fit: BoxFit
                              .contain, // Ensure the image fits within the marker size
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}



// Start Follow