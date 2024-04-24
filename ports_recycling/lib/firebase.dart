// Importing Firebase libraries
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:device_info/device_info.dart';
import 'settingsScreen.dart';
import 'dart:async';

// Define the abstract class
abstract class FirebaseService {
  Future<List<Marker>> getMarkersFromFirestore();
  Future<List<String>> getDocumentTitles();
  Future<Object?> getRecyclingMaterial(String materialName);
  Future<String> getDeviceId();
  Future<bool?> addDeviceIdToAddresses(String placeId, bool notifications);
  Future<String?> getFormattedAddress(String deviceId);
  Future<String?> getPostcode(String deviceId);
  Future<GeoPoint?> getLocation(String deviceId);
  Future<bool?> getNotifications(String deviceId);
  Future<String?> getPlaceId(String deviceId);
  Future<bool> deleteAddressData(String deviceId);
  Future<Map<String, dynamic>?> getCollectionDatesForDevice(String deviceId);
  Future<Map<String, dynamic>?> getCollectionDatesLocally(String postcode);
  Future<bool> checkDeviceHasSavedInfo(String deviceId);
}

// Create the real implementation
class RealFirebaseService implements FirebaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<Marker>> getMarkersFromFirestore() async {
    // Your existing implementation goes here
    CollectionReference recyclingPoints =
        firestore.collection('RecyclingPoints');
    QuerySnapshot querySnapshot = await recyclingPoints.get();
    List<Marker> markers = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      GeoPoint location = doc['Location'];
      String description = doc['Description'];
      Marker marker = Marker(
        markerId: MarkerId(location.toString()),
        position: LatLng(location.latitude, location.longitude),
        infoWindow: InfoWindow(
          title: "Recycling Point",
          snippet: description,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      markers.add(marker);
    }
    return markers;
  }

  @override
  Future<List<String>> getDocumentTitles() async {
    CollectionReference recyclingMaterials =
        firestore.collection('RecyclingMaterials');
    QuerySnapshot querySnapshot = await recyclingMaterials.get();
    List<String> titles = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      String title = doc.id;
      titles.add(title);
    }
    return titles;
  }

  @override
  Future<Object?> getRecyclingMaterial(String materialName) async {
    DocumentSnapshot doc = await firestore
        .collection('RecyclingMaterials')
        .doc(materialName)
        .get();
    if (!doc.exists) {
      print('No material found for $materialName.');
      return null;
    }
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return {
      'canBeRecycled': data['canBeRecycled'],
      'disposalInfo': data['disposalInfo'],
    };
  }

  @override
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

  @override
  Future<bool?> addDeviceIdToAddresses(
      String placeId, bool notifications) async {
    print(placeId);
    Map<String, dynamic>? addressDetails = await selectAddress(placeId);
    if (addressDetails == null ||
        addressDetails['formattedAddress'] == null ||
        addressDetails['postcode'] == null ||
        addressDetails['location'] == null) {
      print('Invalid address details.');
      return false;
    }
    String deviceId = await getDeviceId();
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
    Map<String, dynamic> data = {
      'formattedAddress': addressDetails['formattedAddress'],
      'postcode': addressDetails['postcode'],
      'location': addressDetails['location'],
      'placeId': placeId,
      'notifications': notifications,
    };
    await docRef.set(data);
    return true;
  }

  @override
  Future<String?> getFormattedAddress(String deviceId) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
    DocumentSnapshot doc = await docRef.get();
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return data?['formattedAddress'];
  }

  @override
  Future<String?> getPostcode(String deviceId) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
    DocumentSnapshot doc = await docRef.get();
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return data?['postcode'];
  }

  @override
  Future<GeoPoint?> getLocation(String deviceId) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
    DocumentSnapshot doc = await docRef.get();
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return data?['location'];
  }

  @override
  Future<bool?> getNotifications(String deviceId) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
    DocumentSnapshot doc = await docRef.get();
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return data?['notifications'];
  }

  @override
  Future<String?> getPlaceId(String deviceId) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
    DocumentSnapshot doc = await docRef.get();
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return data?['placeId'];
  }

  @override
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

  @override
  Future<Map<String, dynamic>?> getCollectionDatesForDevice(
      String deviceId) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
    DocumentSnapshot doc = await docRef.get();
    if (!doc.exists ||
        (doc.data() as Map<String, dynamic>)['postcode'] == null) {
      print('No document found with this device ID or no postcode set.');
      return null;
    }
    String postcode = (doc.data() as Map<String, dynamic>)['postcode'];
    print(postcode);
    DocumentReference postcodeDoc =
        FirebaseFirestore.instance.collection('CollectionDates').doc(postcode);
    DocumentSnapshot collectionDoc = await postcodeDoc.get();
    if (!collectionDoc.exists) {
      print('No document found with the postcode $postcode');
      return null;
    } else {
      Map<String, dynamic> data = collectionDoc.data() as Map<String, dynamic>;
      return {
        'recyclingDates': data['recyclingDates'],
        'wasteDates': data['wasteDates'],
      };
    }
  }

  @override
  Future<Map<String, dynamic>?> getCollectionDatesLocally(
      String postcode) async {
    DocumentReference postcodeDoc =
        firestore.collection('CollectionDates').doc(postcode);
    DocumentSnapshot collectionDoc = await postcodeDoc.get();
    if (!collectionDoc.exists) {
      print('No document found with the postcode $postcode');
      return null;
    } else {
      Map<String, dynamic> data = collectionDoc.data() as Map<String, dynamic>;
      return {
        'recyclingDates': data['recyclingDates'],
        'wasteDates': data['wasteDates'],
      };
    }
  }

  @override
  Future<bool> checkDeviceHasSavedInfo(String deviceId) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
    DocumentSnapshot doc = await docRef.get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }
}


/*
// This function is called in the 'mapScreen.dart' file
Future<List<Marker>> getMarkersFromFirestore(
    FirebaseFirestore firestore) async {
  // Get a reference to the collection
  CollectionReference recyclingPoints = firestore.collection('RecyclingPoints');

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
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    // Add the marker to the list
    markers.add(marker);
  }

  // Return the list of markers
  return markers;
}

// Function to query the database and return a List<String> of the title of every document
Future<List<String>> getDocumentTitles(FirebaseFirestore firestore) async {
  // Get a reference to the collection
  CollectionReference recyclingMaterials =
      firestore.collection('RecyclingMaterials');

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
Future<Object?> getRecyclingMaterial(
    FirebaseFirestore firestore, String materialName) async {
  // Try to get the document for the material
  DocumentSnapshot doc =
      await firestore.collection('RecyclingMaterials').doc(materialName).get();

  // Check if the document exists
  if (!doc.exists) {
    print('No material found for $materialName.');
    return null;
  }

  // Return the document's data
  // return doc.data();

  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  return {
    'canBeRecycled': data['canBeRecycled'],
    'disposalInfo': data['disposalInfo'],
  };
}

// This function retrieves the device ID
Future<String> getDeviceId(FirebaseFirestore firestore) async {
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
Future<bool?> addDeviceIdToAddresses(
    FirebaseFirestore firestore, String placeId, bool notifications) async {
  // I'm getting the address details by calling the 'selectAddress' function
  print(placeId);
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
  String deviceId = await getDeviceId(firestore);

  // I'm getting a reference to the Firestore document with the device ID
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);

  // I'm mapping the document data
  Map<String, dynamic> data = {
    'formattedAddress': addressDetails['formattedAddress'],
    'postcode': addressDetails['postcode'],
    'location': addressDetails['location'],
    'placeId': placeId,
    'notifications': notifications,
  };

  // I'm setting the document data
  await docRef.set(data);

  // If everything went well, I'm returning true
  return true;
}

// This function retrieves the formatted address for a given device ID
Future<String?> getFormattedAddress(
    FirebaseFirestore firestore, String deviceId) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
  DocumentSnapshot doc = await docRef.get();
  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  return data?['formattedAddress'];
}

// This function retrieves the postcode for a given device ID
Future<String?> getPostcode(
    FirebaseFirestore firestore, String deviceId) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
  DocumentSnapshot doc = await docRef.get();
  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  return data?['postcode'];
}

// This function retrieves the location for a given device ID
Future<GeoPoint?> getLocation(
    FirebaseFirestore firestore, String deviceId) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
  DocumentSnapshot doc = await docRef.get();
  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  return data?['location'];
}

// This function retrieves the notifications setting for a given device ID
Future<bool?> getNotifications(
    FirebaseFirestore firestore, String deviceId) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
  DocumentSnapshot doc = await docRef.get();
  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  return data?['notifications'];
}

// This function retrieves the placeId value for a given device ID
Future<String?> getPlaceId(FirebaseFirestore firestore, String deviceId) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);
  DocumentSnapshot doc = await docRef.get();
  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  return data?['placeId'];
}

// This function deletes the address data for a given device ID
Future<bool> deleteAddressData(
    FirebaseFirestore firestore, String deviceId) async {
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
    FirebaseFirestore firestore, String deviceId) async {
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
    Map<String, dynamic> data = collectionDoc.data() as Map<String, dynamic>;
    return {
      'recyclingDates': data['recyclingDates'],
      'wasteDates': data['wasteDates'],
    };
  }
}

// Gets collection dates for a given device ID
Future<Map<String, dynamic>?> getCollectionDatesLocally(
    FirebaseFirestore firestore, String postcode) async {
  // I'm getting a reference to the Firestore document for the correct postcode
  DocumentReference postcodeDoc =
      firestore.collection('CollectionDates').doc(postcode);

  // I'm trying to get the document
  DocumentSnapshot collectionDoc = await postcodeDoc.get();

  // I'm checking if the document exists
  if (!collectionDoc.exists) {
    // If the document does not exist or the 'postcode' field is null, I'm printing a message and returning null
    print('No document found with the postcode $postcode');
    return null;
  } else {
    // If documents were found, I'm returning the 'recyclingDates' and 'wasteDates' fields of the first document
    Map<String, dynamic> data = collectionDoc.data() as Map<String, dynamic>;
    return {
      'recyclingDates': data['recyclingDates'],
      'wasteDates': data['wasteDates'],
    };
  }
}

Future<bool> checkDeviceHasSavedInfo(
    FirebaseFirestore firestore, String deviceId) async {
  // I'm getting a reference to the Firestore document with the device ID
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Addresses').doc(deviceId);

  // I'm trying to get the document
  DocumentSnapshot doc = await docRef.get();

  // I'm checking if the document exists
  if (doc.exists) {
    // If the document does exist, I'm returning true
    return true;
  } else {
    // If the document does not exist, I'm returning false
    return false;
  }
}
*/