// ignore_for_file: prefer_const_constructors
// Importing necessary libraries

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ports_recycling/mapScreen.dart';
import 'firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'setupScreen.dart';
import 'homeScreen.dart';
import 'mapScreen.dart';

bool splashScreen = true;
String splashScreenName = "Welcome";
Map<String, dynamic> localAddress = {};

Future<void> main() async {
  // Ensuring that widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing Firebase app with given options
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCphWQpqNdWuQFK6oJZW5Dn99R30i9VQs0",
      authDomain: "recyclingapp-205a6.firebaseapp.com",
      projectId: "recyclingapp-205a6",
      storageBucket: "recyclingapp-205a6.appspot.com",
      messagingSenderId: "269106504135",
      appId: "1:269106504135:web:6399dc546fa4fe495f79e2",
    ),
  );

  if (await getFormattedAddress(await getDeviceId()) != null) {
    splashScreen = false;
  }


  // Running the app
  runApp(MyApp());
}

/// Flutter code sample for [BottomNavigationBar].

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App settings and navigation
      home: splashScreen ? SetupScreen() : BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    MapScreen(),
    const SetupScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text('BottomNavigationBar Sample'),
      //),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
