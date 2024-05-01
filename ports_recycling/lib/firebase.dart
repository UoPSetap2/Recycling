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
