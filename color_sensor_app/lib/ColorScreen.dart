import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_database/firebase_database.dart';

class ColorScreen extends StatefulWidget {
  @override
  State<ColorScreen> createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  final FlutterTts flutterTts = FlutterTts();
  late DatabaseReference starCountRef;
  String color = 'Unknown';

  void speakColor(String color) {
    flutterTts.setLanguage('en-US');
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.speak('The color is $color');
  }

  @override
  void initState() {
    super.initState();
    starCountRef = FirebaseDatabase.instance.ref('/MyApp/Color');
    starCountRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          color = event.snapshot.value as String;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: IconButton(
              icon: const Icon(
                Icons.palette,
                size: 80.0,
                color: Colors.black,
              ),
              onPressed: () {
                speakColor(color);
              },
            ),
          ),
        ),
      ),
    );
  }
}
