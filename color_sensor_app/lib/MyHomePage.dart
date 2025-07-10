import 'package:color_sensor/ColorScreen.dart';
import 'package:color_sensor/MapScreen.dart';
import 'package:flutter/material.dart';
import 'package:color_sensor/settings.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    MapScreen(),
    ColorScreen(),
    account(), // Account page added
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blind Companion'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ClipPath(
        // clipper: MyClipper(),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 97, 63, 30),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_rounded),
              //icon: const Icon(Icons.navigation),
              label: 'Location',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.color_lens_sharp),
              label: 'Color detection',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => account()),
      );
    }
  }
}
