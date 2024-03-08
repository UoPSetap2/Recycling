// Importing Firebase libraries
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
Future<void> addBinInformation(String binType, List<String> items) async {
  // Creating a map of bin data
  Map<String, dynamic> binData = {
    'binType': binType,
    'items': items,
  };

  // Trying to add bin data to Firestore
  try {
    await FirebaseFirestore.instance.collection('BinInformation').add(binData);
  } catch (e) {
    // Printing the error if any
    print('Failed to add bin information: $e');
  }
}
