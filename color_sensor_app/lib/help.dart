import 'package:flutter/material.dart';

class help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "How to Use This App?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "1. Tap on the 'location' button to find your current location.\n"
                "2. Explore the app to detect colors around you.\n"
                "3. Use the 'Color Detection' feature to identify colors.\n"
                "4. Navigate through the menu to access additional tools.\n"
                "5. Your surroundings and detected colors will be announced through audio feedback.\n"
                "We hope this application enhances your navigation and color recognition experience!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
