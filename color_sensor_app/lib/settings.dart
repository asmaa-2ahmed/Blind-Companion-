import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:color_sensor/help.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class account extends StatefulWidget {
  static const String id = "settings";

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<account> {
  late SharedPreferences _prefs;
  bool _locationSaved = false;

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _locationSaved = _prefs.containsKey('saved_location');
  }

  Future<void> _saveLocation(String location) async {
    await _prefs.setString('saved_location', location);
    setState(() {
      _locationSaved = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Location saved successfully!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => help()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        // Add SafeArea
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Generate QR code for sharing app
                    String appLink = 'http://localhost:49165/';
                    Uint8List qrCode = await generateQRCode(appLink);
                    // Show dialog with QR code
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Share App'),
                        content: SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.memory(qrCode),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Share App via QR',
                    style: const TextStyle(
                      color: Colors.white, // Change text color here
                      fontSize: 18, // Text size
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 97, 63, 30),
                    //primary: Colors.blue, // Change button background color
                    //onPrimary: Colors.white, // Change text color
                    textStyle:
                        const TextStyle(fontSize: 18), // Change text size
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    // Save current location (dummy data for demonstration)
                    String currentLocation =
                        'Latitude: 40.7128, Longitude: -74.0060';
                    await _saveLocation(currentLocation);
                  },
                  child: Text(
                    _locationSaved ? 'Location Saved' : 'Save Current Location',
                    style: TextStyle(
                      color: _locationSaved
                          ? const Color.fromARGB(255, 97, 63, 30)
                          : Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _locationSaved
                        ? Colors.grey
                        : const Color.fromARGB(255, 97, 63, 30),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> generateQRCode(String data) async {
    return QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor: Colors.white,
    ).toImageData(200).then((value) => value!.buffer.asUint8List());
  }
}
