// Importing Firebase libraries
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'mapScreen.dart';
import 'package:device_info/device_info.dart';
import 'package:geocoding/geocoding.dart';

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
// Could change so that it checks whether there is a point already

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

THIS HAS BEEN CALLED ALREADY IN THE 'mapScreen.dart' FILE, NO NEED TO CALL IT AGAIN UNLESS ADDING MORE

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
  collection made, need csv with info 

// NEEDS CSV FILE
  
*/
Future<void> addCollectionDatesFromCSV(String csvFile) async {
  // Load the CSV file
  String csvData = await rootBundle.loadString(csvFile);

  // Parse the CSV data
  List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);

  // Loop through the rows
  for (List<dynamic> row in rows) {
    // Get the data for this row
    String postcode = row[0];
    List<DateTime> recyclingDates = (row[1] as String)
        .split(',')
        .map((date) => DateTime.parse(date))
        .toList();
    List<DateTime> wasteDates = (row[2] as String)
        .split(',')
        .map((date) => DateTime.parse(date))
        .toList();

    // Create a map of the data
    Map<String, dynamic> data = {
      'recyclingDates': recyclingDates
          .map((date) =>
              DateTime(date.year, date.month, date.day).toIso8601String())
          .toList(),
      'wasteDates': wasteDates
          .map((date) =>
              DateTime(date.year, date.month, date.day).toIso8601String())
          .toList(),
    };

    // Try to add the data to Firestore
    try {
      await FirebaseFirestore.instance
          .collection('CollectionDates')
          .doc(postcode)
          .set(data);
      print('Successfully added collection dates for $postcode.');
    } catch (e) {
      print('Failed to add collection dates: $e');
    }
  }
}

/*
- Function to pull the collection dates
 - Needs to use the user's set postcode and pull the document for that postcode, then display the dates within that document
 - Possibly need a sperate function to check the user has a set postcode, if not then the frontend should go back and ask for one
*/

// Need to sort out how to best acquire postcode from user
Future<Map<String, List<DateTime>>> getCollectionDates(String postcode) async {
  // Try to get the document for the postcode
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('CollectionDates')
      .doc(postcode)
      .get();

  // Check if the document exists
  if (!doc.exists) {
    throw Exception('No collection dates found for postcode $postcode.');
  }

  // Get the collection dates
  List<DateTime> recyclingDates = (doc['recyclingDates'] as List)
      .map((date) => DateTime.parse(date))
      .toList();
  List<DateTime> wasteDates =
      (doc['wasteDates'] as List).map((date) => DateTime.parse(date)).toList();

  // Return the collection dates
  return {
    'recyclingDates': recyclingDates,
    'wasteDates': wasteDates,
  };
}

/*
- Function to input materials/items that can be recycled
  - A collection for materials, 1 document per material that stores a description, can it be recycled (boolean), how to dispose of it and/or what bin it goes in
*/
//Need a csv
Future<void> addRecyclingMaterialsFromCSV(String csvFile) async {
  // Load the CSV file
  String csvData = await rootBundle.loadString(csvFile);

  // Parse the CSV data
  List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);

  // Loop through the rows
  for (List<dynamic> row in rows) {
    // Get the data for this row
    String materialName = row[0];
    String description = row[1];
    bool canBeRecycled = row[2].toLowerCase() == 'true';
    String disposalInfo = row[3];

    // Create a map of the data
    Map<String, dynamic> data = {
      'description': description,
      'canBeRecycled': canBeRecycled,
      'disposalInfo': disposalInfo,
    };

    // Try to add the data to Firestore
    try {
      await FirebaseFirestore.instance
          .collection('RecyclingMaterials')
          .doc(materialName)
          .set(data);
      print('Successfully added recycling material $materialName.');
    } catch (e) {
      print('Failed to add recycling material: $e');
    }
  }
}

/*
- Function to pull materials/items that can be recycled
   - The user uses this to search materials/items. Needs to take whatever they search and return the document for the material that matches
   - This would look great with some kind of autocomplete search function, but not yet sure how to implement this
*/
Future<DocumentSnapshot> getRecyclingMaterial(String searchTerm) async {
  // Try to get the document for the material
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('RecyclingMaterials')
      .doc(searchTerm)
      .get();

  // Check if the document exists
  if (!doc.exists) {
    throw Exception('No material found for search term $searchTerm.');
  }

  // Return the document
  return doc;
}

/*
- Function to input user/device home address and postcode - This is only to input their home address, if the user does not tick home address then the inputted address will be saved locally and forgotten when the app is closed.
  - On the startup screen, this function takes the inputted address (Seperates the fields, especially postcode needs to be seperate)
  - It would be good to find the latitude and longitude coordinates of the address so we can pin their address to the map. 
  - A collection for addresses, each document is every MAC address that has used the system, within each document is the address, coordinates of the address and if notifications are enabled (boolean)
  - This also needs a mechanism to update the home address and possibly delete it.
*/
// Gets unique decive id

Future<String> getDeviceId() async {
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  if (Platform.isAndroid) {
    var build = await deviceInfoPlugin.androidInfo;
    return build.androidId; //UUID for Android
  } else if (Platform.isIOS) {
    var data = await deviceInfoPlugin.iosInfo;
    return data.identifierForVendor; //UUID for iOS
  } else {
    throw Exception('Platform not supported');
  }
}

// Example implementation
Future<void> addDeviceIdToAddresses(String address, double latitude,
    double longitude, bool notifications) async {
  // Get the device ID
  String deviceId = await getDeviceId();

  // Get a reference to the document with the device ID
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);

  // Check if the document exists
  DocumentSnapshot doc = await docRef.get();
  if (!doc.exists) {
    // If the document does not exist, add it
    GeoPoint location = GeoPoint(latitude, longitude);
    Map<String, dynamic> data = {
      'address':
          address, // This should be provided by the user through the frontend
      'location':
          location, // This should be the user's location, which can be obtained through the frontend
      'notifications':
          notifications, // This should be provided by the user through the frontend
    };
    await docRef.set(data);
  }
}

// To retrieve user info
Future<DocumentSnapshot> getUserAddressData() async {
  // Get the device ID
  String deviceId = await getDeviceId();

  // Get a reference to the document with the device ID
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);

  // Try to get the document
  DocumentSnapshot doc = await docRef.get();

  // Check if the document exists
  if (!doc.exists) {
    throw Exception('No address data found for device ID $deviceId.');
  }

  // Return the document
  return doc;
}

// Delete user address
Future<void> deleteAddressData() async {
  // Get the device ID
  String deviceId = await getDeviceId();

  // Get a reference to the document with the device ID
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);

  // Delete the document
  await docRef.delete();
}

/*
- Function to pull user/device home address and postcode
  - Will need to check if there is an address set, this gets used on startup and if no address is set then the startup screen is shown, if there is this will be skipped
  - Postcode needs to be pulled on the collection dates screen
  - Coordinates need to be pulled on the map
  - If there is no address set, the user needs to be asked for one before they can see collection dates
*/
// Checks if user has address set, can be used on frontend to navigate screens
Future<bool> hasAddressSet() async {
  // Get the device ID
  String deviceId = await getDeviceId();

  // Get a reference to the document with the device ID
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);

  // Try to get the document
  DocumentSnapshot doc = await docRef.get();

  // Check if the document exists and the 'address' field is not null or empty
  if (doc.exists && doc['address'] != null && doc['address'].isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

// Cannot do this it is only IOS compatible
// Is there a collection dates screen? I don't know what needs to be done by pulls postcode on collection dates screen? This function just gets the postcode from the database for a user
Future<String> getPostcodeFromDeviceId() async {
  // Get the device ID
  String deviceId = await getDeviceId();

  // Get a reference to the document with the device ID
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);

  // Try to get the document
  DocumentSnapshot doc = await docRef.get();

  // Check if the document exists
  if (!doc.exists) {
    throw Exception('No address data found for device ID $deviceId.');
  }

  // Get the location from the document data
  GeoPoint location = doc['location'] as GeoPoint;

  // Perform reverse geocoding
  List<Placemark> placemarks =
      await placemarkFromCoordinates(location.latitude, location.longitude);

  // Check if any placemarks were found
  if (placemarks.isEmpty) {
    throw Exception('No placemarks found for location $location.');
  }

  // Check if the postcode is not null
  String? postcode = placemarks.first.postalCode;
  if (postcode == null) {
    throw Exception('No postcode found for location $location.');
  }

  // Return the postcode
  return postcode;
}
/*


There might be more needed, let me know if you think of anything else.
The Bin Information screen is the only other page that could use the database, however I dont think it's necessary.
All the other screens can be done entierly in frontend with static data because it will never need to be changed.

Need to look into notifications too.
  - Maybe a function to query if there are any bin collections for the next day? This isn't needed for the time being but might be useful in future.



*/
