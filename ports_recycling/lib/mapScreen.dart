import 'package:flutter/services.dart';
import 'firebase.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  List<Marker> markers = [];

  final LatLng _center = const LatLng(50.79869842529297, -1.0990136861801147);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12.0,
        ),
        markers: Set<Marker>.from(markers),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    await addMarkersToMap();
  }

  void _addMarker(LatLng position, String title, String properties,
      BitmapDescriptor colour) {
    markers.add(
      Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(title: title, snippet: properties),
        icon: colour,
      ),
    );
  }

  addMarkersToMap() async {
    try {
      List<Marker> newMarkers = await getMarkersFromFirestore();
      for (Marker marker in newMarkers) {
        _addMarker(marker.position, marker.infoWindow.title ?? '',
            marker.infoWindow.snippet ?? '', marker.icon);
      }
      print('Successfully added markers from Firestore.');

      // Call setState to update the map with the new markers
      setState(() {});
    } catch (e) {
      print('Failed to add markers from Firestore: $e');
    }
  }
}
