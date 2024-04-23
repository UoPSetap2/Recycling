import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:ports_recycling/firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockGeoPoint extends Mock implements GeoPoint {}

class MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {}

class MockAndroidDeviceInfo extends Mock implements AndroidDeviceInfo {}

class MockIosDeviceInfo extends Mock implements IosDeviceInfo {}

class MockCollectionReference extends Mock
    with MockCollectionReferenceMixin
    implements CollectionReference<Map<String, dynamic>> {}

mixin MockCollectionReferenceMixin on Mock
    implements CollectionReference<Map<String, dynamic>> {}

void main() {
  setUpAll(() async {
    // Initialize Firebase before running any tests
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
    assert(Firebase.apps.isNotEmpty);
  });

  final firestore = MockFirebaseFirestore();
  final collectionReference = MockCollectionReference();
  final documentReference = MockDocumentReference();
  final querySnapshot = MockQuerySnapshot();
  final queryDocumentSnapshot = MockQueryDocumentSnapshot();
  final documentSnapshot = MockDocumentSnapshot();
  final geoPoint = MockGeoPoint();
  final deviceInfoPlugin = MockDeviceInfoPlugin();
  final androidDeviceInfo = MockAndroidDeviceInfo();
  final iosDeviceInfo = MockIosDeviceInfo();

  when(firestore.collection('testCollection')).thenReturn(collectionReference);
  when(collectionReference.doc(any)).thenReturn(documentReference);
  when(collectionReference.get()).thenAnswer((_) async => querySnapshot);
  when(documentReference.get()).thenAnswer((_) async => documentSnapshot);
  when(querySnapshot.docs).thenReturn([queryDocumentSnapshot]);
  when(queryDocumentSnapshot['Location']).thenReturn(geoPoint);
  when(queryDocumentSnapshot['Description']).thenReturn('Description');
  when(queryDocumentSnapshot.id).thenReturn('Title');
  when(documentSnapshot.exists).thenReturn(true);
  when(documentSnapshot.data()).thenReturn({
    'canBeRecycled': true,
    'disposalInfo': 'Disposal Info',
    'formattedAddress': 'Formatted Address',
    'postcode': 'Postcode',
    'location': geoPoint,
    'placeId': 'Place ID',
    'notifications': true,
    'recyclingDates': ['Recycling Date'],
    'wasteDates': ['Waste Date'],
  });
  when(geoPoint.latitude).thenReturn(0.0);
  when(geoPoint.longitude).thenReturn(0.0);
  when(deviceInfoPlugin.androidInfo).thenAnswer((_) async => androidDeviceInfo);
  when(deviceInfoPlugin.iosInfo).thenAnswer((_) async => iosDeviceInfo);
  when(androidDeviceInfo.androidId).thenReturn('Android ID');
  when(iosDeviceInfo.identifierForVendor).thenReturn('iOS ID');

  test('getMarkersFromFirestore returns a list of markers', () async {
    final firestore = FirebaseFirestore.instance;
    expect(await getMarkersFromFirestore(firestore), isA<List<Marker>>());
  });

  test('getDocumentTitles returns a list of titles', () async {
    final firestore = FirebaseFirestore.instance;
    expect(await getDocumentTitles(firestore), equals(['Title']));
  });

  test('getRecyclingMaterial returns the material data', () async {
    final firestore = FirebaseFirestore.instance;
    expect(
        await getRecyclingMaterial(firestore, 'Material Name'),
        equals({
          'canBeRecycled': true,
          'disposalInfo': 'Disposal Info',
        }));
  });

  test('getDeviceId returns the device ID', () async {
    final firestore = FirebaseFirestore.instance;
    expect(await getDeviceId(firestore), equals('Android ID'));
  });

  test('addDeviceIdToAddresses returns true', () async {
    final firestore = FirebaseFirestore.instance;
    expect(await addDeviceIdToAddresses(firestore, 'Place ID', true),
        equals(true));
  });

  test('getFormattedAddress returns the formatted address', () async {
    final firestore = FirebaseFirestore.instance;
    expect(await getFormattedAddress(firestore, 'Device ID'),
        equals('Formatted Address'));
  });

  test('getPostcode returns the postcode', () async {
    final firestore = FirebaseFirestore.instance;
    expect(await getPostcode(firestore, 'Device ID'), equals('Postcode'));
  });

  test('getLocation returns the location', () async {
    final firestore = FirebaseFirestore.instance;
    expect(await getLocation(firestore, 'Device ID'), equals(geoPoint));
  });

  test('getNotifications returns the notifications setting', () async {
    final firestore = FirebaseFirestore.instance;
    expect(await getNotifications(firestore, 'Device ID'), equals(true));
  });

  test('getPlaceId returns the place ID', () async {
    final firestore = FirebaseFirestore.instance;
    expect(await getPlaceId(firestore, 'Device ID'), equals('Place ID'));
  });

  test('deleteAddressData returns true', () async {
    final firestore = FirebaseFirestore.instance;
    expect(await deleteAddressData(firestore, 'Device ID'), equals(true));
  });

  test('getCollectionDatesForDevice returns the collection dates', () async {
    final firestore = FirebaseFirestore.instance;
    expect(
        await getCollectionDatesForDevice(firestore, 'Device ID'),
        equals({
          'recyclingDates': ['Recycling Date'],
          'wasteDates': ['Waste Date'],
        }));
  });

  test('getCollectionDatesLocally returns the collection dates', () async {
    final firestore = FirebaseFirestore.instance;
    expect(
        await getCollectionDatesLocally(firestore, 'Postcode'),
        equals({
          'recyclingDates': ['Recycling Date'],
          'wasteDates': ['Waste Date'],
        }));
  });

  test('checkDeviceHasSavedInfo returns true', () async {
    final firestore = FirebaseFirestore.instance;
    expect(await checkDeviceHasSavedInfo(firestore, 'Device ID'), equals(true));
  });
}
