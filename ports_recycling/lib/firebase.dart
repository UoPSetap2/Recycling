// Importing Firebase libraries
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:device_info/device_info.dart';
import 'setupScreen.dart';

// Initializing Firebase
final FirebaseFirestore firestore = FirebaseFirestore.instance;

/*
What we need for the database:

1. Function to add the recycling points to the database:
   - This is 1 collection with each document representing 1 recycling point, containing the fields latitude, longitude and description.
   - See RecyclingPoints.csv.

2. Function to pull the recycling points from the database, used in the 'mapScreen.dart' file:
   - Needs to loop through all the points, calling the '_addMarker' function on each one. See line 49 in 'mapScreen.dart' file for more info.

3. Function to pull materials/items that can be recycled:
   - The user uses this to search materials/items. Needs to take whatever they search and return the document for the material that matches.
   - This would look great with some kind of autocomplete search function, but not yet sure how to implement this.

4. Function to input user/device home address and postcode:
   - This is only to input their home address. If the user does not tick home address then the inputted address will be saved locally and forgotten when the app is closed.
   - On the startup screen, this function takes the inputted address (Separates the fields, especially postcode needs to be separate).
   - It would be good to find the latitude and longitude coordinates of the address so we can pin their address to the map.
   - A collection for addresses, each document is every MAC address that has used the system, within each document is the address, coordinates of the address and if notifications are enabled (boolean).

5. Function to input the collection dates:
   - 1 collection with each document representing a postcode. There are 2 fields within the document, 1 is a list of recycling collection dates, the other is a list of general waste collection dates.
   - This also needs a mechanism to update the home address and possibly delete it.

6. Function to pull user/device home address and postcode:
   - Will need to check if there is an address set. This gets used on startup and if no address is set then the startup screen is shown, if there is this will be skipped.
   - Postcode needs to be pulled on the collection dates screen.
   - Coordinates need to be pulled on the map.
   - If there is no address set, the user needs to be asked for one before they can see collection dates.
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
Future<bool> recyclingPointExists(GeoPoint location) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('RecyclingPoints')
      .where('Location.latitude', isEqualTo: location.latitude)
      .where('Location.longitude', isEqualTo: location.longitude)
      .get();

  return snapshot.docs.isNotEmpty;
}

Future<void> addRecyclingPointsFromCSV() async {
  String csvData = await rootBundle.loadString('assets/RecyclingPoints.csv');
  List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);

  for (int i = 1; i < csvTable.length; i++) {
    String description = csvTable[i][3];
    GeoPoint location = GeoPoint(csvTable[i][1], csvTable[i][2]);

    bool exists = await recyclingPointExists(location);
    if (!exists) {
      await addRecyclingPoint(description, location);
    }
  }
}

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

// Function to add recycling materials to the 'RecyclingMaterials' collection in Firestore
Future<void> addRecyclingMaterialsFromCSV() async {
  print('Loading CSV file...');
  // Load and parse the CSV file
  String csvData = await rootBundle.loadString('assets/Materials.csv');
  List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);

  // Get a reference to the Firestore collection
  CollectionReference materials =
      FirebaseFirestore.instance.collection('RecyclingMaterials');

  // Loop through each row in the CSV file
  for (int i = 1; i < csvTable.length; i++) {
    // Get the data for this row
    String materialName = csvTable[i][0];
    bool canBeRecycled = csvTable[i][1].toLowerCase() == 'true';
    String disposalInfo = csvTable[i][2];

    // Add the material to Firestore
    print('Adding material: $materialName');
    await materials.doc(materialName).set({
      'canBeRecycled': canBeRecycled,
      'disposalInfo': disposalInfo,
    });
  }
  print('Finished adding materials.');
}

// Function to query the database and return a List<String> of the title of every document
Future<List<String>> getDocumentTitles() async {
  // Get a reference to the collection
  CollectionReference recyclingMaterials =
      FirebaseFirestore.instance.collection('RecyclingMaterials');

  // Get all documents in the collection
  QuerySnapshot querySnapshot = await recyclingMaterials.get();

  // Create a list to hold the titles
  List<String> titles = [];

  // Loop through the documents
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    // Get the title for this document
    String title = doc.id;

    // Add the title to the list
    titles.add(title);
  }

  // Return the list of titles
  return titles;
}


// Function for searching materials
Future<Object?> getRecyclingMaterial(String materialName) async {
  // Try to get the document for the material
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('RecyclingMaterials')
      .doc(materialName)
      .get();

  // Check if the document exists
  if (!doc.exists) {
    print('No material found for $materialName.');
    return null;
  }

  // Return the document's data
  // return doc.data();

  Map<String, dynamic> data =
    doc.data() as Map<String, dynamic>;
    return {
      'canBeRecycled': data['canBeRecycled'],
      'disposalInfo': data['disposalInfo'],
    };
}

// This function retrieves the device ID
Future<String> getDeviceId() async {
  // I'm creating a new DeviceInfoPlugin object
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  // I'm checking if the platform is Android
  if (Platform.isAndroid) {
    // If it's Android, I'm getting the Android device info
    var build = await deviceInfoPlugin.androidInfo;

    // I'm returning the Android device ID
    return build.androidId; //UUID for Android
  } else if (Platform.isIOS) {
    // I'm checking if the platform is iOS
    // If it's iOS, I'm getting the iOS device info
    var data = await deviceInfoPlugin.iosInfo;

    // I'm returning the iOS device ID
    return data.identifierForVendor; //UUID for iOS
  } else {
    // If the platform is neither Android nor iOS, I'm throwing an exception
    throw Exception('Platform not supported');
  }
}

// This function adds the device ID to the 'Addresses' collection in Firestore
Future<bool?> addDeviceIdToAddresses(String placeId, bool notifications) async {
  // I'm getting the address details by calling the 'selectAddress' function
  Map<String, dynamic>? addressDetails = await selectAddress(placeId);

  // I'm checking if the address details are valid
  if (addressDetails == null ||
      addressDetails['formattedAddress'] == null ||
      addressDetails['postcode'] == null ||
      addressDetails['location'] == null) {
    // If the address details are not valid, I'm printing an error message and returning false
    print('Invalid address details.');
    return false;
  }

  // I'm getting the device ID by calling the 'getDeviceId' function
  String deviceId = await getDeviceId();

  // I'm getting a reference to the Firestore document with the device ID
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);

  // I'm checking if the document exists
  DocumentSnapshot doc = await docRef.get();
  if (!doc.exists) {
    // If the document does not exist, I'm adding it
    Map<String, dynamic> data = {
      'formattedAddress': addressDetails['formattedAddress'],
      'postcode': addressDetails['postcode'],
      'location': addressDetails['location'],
      'notifications': notifications,
    };
    // I'm setting the document data
    await docRef.set(data);
  } else {
    // If the document already exists, I'm printing a message and returning null
    print('A document with this device ID already exists.');
    return null;
  }

  // If everything went well, I'm returning true
  return true;
}

// This function retrieves the formatted address for a given device ID
Future<String?> getFormattedAddress(String deviceId) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
  DocumentSnapshot doc = await docRef.get();
  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  return data?['formattedAddress'];
}

// This function retrieves the postcode for a given device ID
Future<String?> getPostcode(String deviceId) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
  DocumentSnapshot doc = await docRef.get();
  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  return data?['postcode'];
}

// This function retrieves the location for a given device ID
Future<GeoPoint?> getLocation(String deviceId) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
  DocumentSnapshot doc = await docRef.get();
  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  return data?['location'];
}

// This function retrieves the notifications setting for a given device ID
Future<bool?> getNotifications(String deviceId) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
  DocumentSnapshot doc = await docRef.get();
  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  return data?['notifications'];
}

// This function deletes the address data for a given device ID
Future<bool> deleteAddressData(String deviceId) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
  DocumentSnapshot doc = await docRef.get();
  if (doc.exists) {
    await docRef.delete();
    return true;
  } else {
    print('No document found with this device ID.');
    return false;
  }
}

// Gets collection dates for a given device ID
Future<Map<String, dynamic>?> getCollectionDatesForDevice(
    String deviceId) async {
  // I'm getting a reference to the Firestore document with the device ID
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);

  // I'm trying to get the document
  DocumentSnapshot doc = await docRef.get();

  // I'm checking if the document exists and the 'postcode' field is not null
  if (!doc.exists || (doc.data() as Map<String, dynamic>)['postcode'] == null) {
    // If the document does not exist or the 'postcode' field is null, I'm printing a message and returning null
    print('No document found with this device ID or no postcode set.');
    return null;
  }

  // I'm getting the postcode from the document
  String postcode = (doc.data() as Map<String, dynamic>)['postcode'];
  print(postcode);

  // I'm getting a reference to the Firestore document for the correct postcode
  DocumentReference postcodeDoc =
      FirebaseFirestore.instance.collection('CollectionDates').doc(postcode);
  
  // I'm trying to get the document
  DocumentSnapshot collectionDoc = await postcodeDoc.get();

  // I'm checking if the document exists
  if (!collectionDoc.exists) {
    // If the document does not exist or the 'postcode' field is null, I'm printing a message and returning null
    print('No document found with the postcode $postcode');
    return null;
  } else {
    // If documents were found, I'm returning the 'recyclingDates' and 'wasteDates' fields of the first document
    Map<String, dynamic> data =
        collectionDoc.data() as Map<String, dynamic>;
    return {
      'recyclingDates': data['recyclingDates'],
      'wasteDates': data['wasteDates'],
    };
  }

  // // I'm trying to get the documents where the 'postcode' field matches the given postcode
  // QuerySnapshot querySnapshot =
  //     await collectionRef.where('postcode', isEqualTo: postcode).get();

  // // I'm checking if any documents were found
  // if (querySnapshot.docs.isEmpty) {
  //   // If no documents were found, I'm printing a message and returning null
  //   print('No collection dates found for this postcode.');
  //   print(querySnapshot);
  //   return null;
  // } 
}
