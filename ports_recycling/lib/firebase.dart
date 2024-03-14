// Importing Firebase libraries
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'mapScreen.dart';

// Initializing Firebase
final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Function to add a user to the 'Users' collection in Firestore
Future<void> addUser(
    Timestamp collectionDate, String postcode, String userID) async {
  // Creating a map of user data
  Map<String, dynamic> userData = {
    'collectionDate': collectionDate,
    'postcode': postcode,
    'userID': userID
  };

  // Trying to add user data to Firestore
  try {
    await FirebaseFirestore.instance.collection('Users').add(userData);
  } catch (e) {
    // Printing the error if any
    print('Failed to add user: $e');
  }
}

// Function to add a collection point to the 'CollectionPoints' collection in Firestore
Future<void> addCollectionPoint(
    GeoPoint location, String pointId, String type) async {
  // Creating a map of collection point data
  Map<String, dynamic> testData = {
    'location': location,
    'pointId': pointId,
    'type': type,
  };

  // Trying to add collection point data to Firestore
  try {
    await FirebaseFirestore.instance
        .collection('CollectionPoints')
        .add(testData);
  } catch (e) {
    // Printing the error if any
    print('Failed to add collection point: $e');
  }
}

// Function to add bin information to the 'BinInformation' collection in Firestore

/* What we need for the database

- Function to add the recycling points to the database
  - I'm thinking this is 1 collection with each document representing 1 recycling point, containing the fields latitude, longitude and description
  - See RecyclingPoints.csv

*/

// Function to add recycling points to the 'RecyclingPoints' collection in Firestore
Future<void> addRecyclingPoint(String description, GeoPoint location) async {
  // Creating a map of bin data
  Map<String, dynamic> pointData = {
    'Description': description,
    'Location': location,
  };

  // Trying to add data to Firestore
  try {
    await FirebaseFirestore.instance
        .collection('RecyclingPoints')
        .add(pointData);
  } catch (e) {
    // Printing the error if any
    print('Failed to add information: $e');
  }
}

// Function to loop through the recycling points and add them to the database

Future<void> addRecyclingPointsFromCSV() async {
  // Load and parse the CSV file
  String csvData = await rootBundle.loadString('assets/RecyclingPoints.csv');
  List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);

  // Loop through each row in the CSV file
  for (int i = 1; i < csvTable.length; i++) {
    // Get the data for this row
    String description = csvTable[i][3];
    GeoPoint location = GeoPoint(csvTable[i][1], csvTable[i][2]);

    // Add the recycling point to Firestore
    await addRecyclingPoint(description, location);
  }
}

/*
- Function to pull the recycling points from the database, used in the 'mapScreen.dart' file
  - Needs to loop through all the points, calling the '_addMarker' function on each one, see line 49 in 'mapScreen.dart' file for more info.

THIS HAS BEEN CALLED DO NOT USE AGAIN

  try {
    // Call the addRecyclingPointsFromCSV function
    await addRecyclingPointsFromCSV();
  } catch (e) {
    print('Failed to add recycling points: $e');
  }

*/
// This function is called in the 'mapScreen.dart' file
Future<List<Marker>> getMarkersFromFirestore() async {
  // Get a reference to the collection
  CollectionReference recyclingPoints =
      FirebaseFirestore.instance.collection('RecyclingPoints');

  // Get all documents in the collection
  QuerySnapshot querySnapshot = await recyclingPoints.get();

  // Create a list to hold the markers
  List<Marker> markers = [];

  // Loop through the documents
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    // Get the data for this document
    GeoPoint location = doc['Location'];
    String description = doc['Description'];

    // Create a marker for this document
    Marker marker = Marker(
      markerId: MarkerId(location.toString()),
      position: LatLng(location.latitude, location.longitude),
      infoWindow: InfoWindow(
        title: "Recycling Point",
        snippet: description,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    // Add the marker to the list
    markers.add(marker);
  }

  // Return the list of markers
  return markers;
}
/*
- Function to input the collection dates
  - 1 collection with each document representing a postcode, there are 2 fields within the document, 1 is a list of recycling collection dates, the other is a list of general waste collection dates.

- Function to pull the collection dates
 - Needs to use the user's set postcode and pull the document for that postcode, then display the dates within that document
 - Possibly need a sperate function to check the user has a set postcode, if not then the frontend should go back and ask for one

- Function to input materials/items that can be recycled
  - A collection for materials, 1 document per material that stores a description, can it be recycled (boolean), how to dispose of it and/or what bin it goes in

- Function to pull materials/items that can be recycled
   - The user uses this to search materials/items. Needs to take whatever they search and return the document for the material that matches
   - This would look great with some kind of autocomplete search function, but not yet sure how to implement this

- Function to input user/device home address and postcode - This is only to input their home address, if the user does not tick home address then the inputted address will be saved locally and forgotten when the app is closed.
  - On the startup screen, this function takes the inputted address (Seperates the fields, especially postcode needs to be seperate)
  - It would be good to find the latitude and longitude coordinates of the address so we can pin their address to the map. 
  - A collection for addresses, each document is every MAC address that has used the system, within each document is the address, coordinates of the address and if notifications are enabled (boolean)
  - This also needs a mechanism to update the home address and possibly delete it.

- Function to pull user/device home address and postcode
  - Will need to check if there is an address set, this gets used on startup and if no address is set then the startup screen is shown, if there is this will be skipped
  - Postcode needs to be pulled on the collection dates screen
  - Coordinates need to be pulled on the map
  - If there is no address set, the user needs to be asked for one before they can see collection dates



There might be more needed, let me know if you think of anything else.
The Bin Information screen is the only other page that could use the database, however I dont think it's necessary.
All the other screens can be done entierly in frontend with static data because it will never need to be changed.

Need to look into notifications too.
  - Maybe a function to query if there are any bin collections for the next day? This isn't needed for the time being but might be useful in future.



*/