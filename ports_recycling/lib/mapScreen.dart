import 'package:flutter/services.dart';

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
  String csv = "assets/RecyclingPoints.csv";
  String fileData = await rootBundle.loadString(csv);

  List<String> rows = fileData.split("\n");

  for (int i = 1; i < rows.length; i++) {
    String row = rows[i];
    List<String> itemInRow = row.split(",");

    // 16 is the recycling center itself
    if (i != 16) {
      _addMarker(LatLng(double.parse(itemInRow[1]), double.parse(itemInRow[2])), "Recycling Point ${itemInRow[0]}", itemInRow[3], BitmapDescriptor.defaultMarker);
    }
  }

  //This adds the recycling center to the map in green, with the address as the description
  _addMarker(const LatLng(50.839080810546875, -1.0951703786849976), "Recycling Center", "Paulsgrove Portway,\nPort Solent,\nPO6 4UD", BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

  setState(() {
    mapController = controller;
  });
}

  void _addMarker(LatLng position, String title, String properties, BitmapDescriptor colour) {
    markers.add(
      Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
          title: title,
          snippet: properties),
        icon: colour,
      ),
    );
  }
}
