import 'package:device_info/device_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ports_recycling/firebase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return super.noSuchMethod(
      Invocation.method(#collection, [path]),
      returnValue: MockCollectionReference(),
    ) as CollectionReference<Map<String, dynamic>>;
  }
}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {
  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) {
    return super.noSuchMethod(
      Invocation.method(#get, [options]),
      returnValue: Future.value(MockQuerySnapshot()),
    ) as Future<QuerySnapshot<Map<String, dynamic>>>;
  }

  @override
  DocumentReference<Map<String, dynamic>> doc([String? documentID]) {
    return super.noSuchMethod(
      Invocation.method(#doc, [documentID]),
      returnValue: MockDocumentReference(),
    ) as DocumentReference<Map<String, dynamic>>;
  }
}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {
  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs {
    return super.noSuchMethod(
      Invocation.getter(#docs),
      returnValue: [MockQueryDocumentSnapshot()],
    ) as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
  }
}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  @override
  String get id {
    return super.noSuchMethod(
      Invocation.getter(#id),
      returnValue: 'docID',
    ) as String;
  }
}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([GetOptions? options]) {
    return super.noSuchMethod(
      Invocation.method(#get, [options]),
      returnValue: Future.value(MockDocumentSnapshot()),
    ) as Future<DocumentSnapshot<Map<String, dynamic>>>;
  }
}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  Map<String, dynamic>? data() {
    return super.noSuchMethod(
      Invocation.method(#data, []),
      returnValue: {
        'canBeRecycled': true,
        'disposalInfo': 'Dispose in recycling bin'
      },
    ) as Map<String, dynamic>?;
  }

  @override
  bool get exists {
    return super.noSuchMethod(
      Invocation.getter(#exists),
      returnValue: false, // Provide a default return value
    ) as bool;
  }
}

class MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {}

void main() {
  final firestore = MockFirebaseFirestore();
  final collectionReference = MockCollectionReference();
  final querySnapshot = MockQuerySnapshot();
  final queryDocumentSnapshot = MockQueryDocumentSnapshot();
  final geoPoint = GeoPoint(0, 0);
  final documentReference = MockDocumentReference();
  final documentSnapshot = MockDocumentSnapshot();
  final deviceId = 'test_device_id';
  final expectedAddress = 'test_formatted_address';
  final mockCollectionReference = MockCollectionReference();
  final expectedPostcode = 'test_postcode';

  final documentSnapshotExists = MockDocumentSnapshot();
  final documentSnapshotNotExists = MockDocumentSnapshot();

  when(firestore.collection('RecyclingMaterials'))
      .thenReturn(collectionReference);
  when(collectionReference.get()).thenAnswer((_) async => querySnapshot);
  when(querySnapshot.docs).thenReturn([queryDocumentSnapshot]);
  when(queryDocumentSnapshot.id).thenReturn('docID');

  test('getDocumentTitles returns a list of document IDs', () async {
    List<String> titles = await getDocumentTitles(firestore);

    expect(titles, isA<List<String>>(), reason: 'titles is not a List<String>');
    expect(titles.length, equals(1), reason: 'titles list length is not 1');
    expect(titles[0], equals('docID'),
        reason: 'First title does not match expected document ID');
  });

  when(firestore.collection('RecyclingPoints')).thenReturn(collectionReference);
  when(collectionReference.get()).thenAnswer((_) async => querySnapshot);
  when(querySnapshot.docs).thenReturn([queryDocumentSnapshot]);
  when(queryDocumentSnapshot['Location']).thenReturn(geoPoint);
  when(queryDocumentSnapshot['Description']).thenReturn('description');
  test('getMarkersFromFirestore returns a list of markers', () async {
    List<Marker> markers = await getMarkersFromFirestore(firestore);

    expect(markers, isA<List<Marker>>(),
        reason: 'markers is not a List<Marker>');
    expect(markers.length, equals(1), reason: 'markers list length is not 1');
    expect(markers[0].markerId, equals(MarkerId(geoPoint.toString())),
        reason: 'markerId does not match');
    expect(markers[0].position,
        equals(LatLng(geoPoint.latitude, geoPoint.longitude)),
        reason: 'marker position does not match');
    expect(markers[0].infoWindow.title, equals('Recycling Point'),
        reason: 'infoWindow title does not match');
    expect(markers[0].infoWindow.snippet, equals('description'),
        reason: 'infoWindow snippet does not match');
  });

  test('getRecyclingMaterial returns correct data when document exists',
      () async {});

  test('testing getDeviceId', () async {});

  test('addDeviceIdToAddresses adds address to Firestore', () async {});

  test('getFormattedAddress retrieves the correct address', () async {});

  test('getPostcode retrieves the correct postcode', () async {});

  test('testing getLocation', () async {});

  test('testing getNotifications', () async {});

  test('testing getPlaceId', () async {});

  test('testing deleteAddressData', () async {});

  test('testing getCollectionDatesForDevice', () async {});

  test('getRecyclingMaterial returns correct data when document exists',
      () async {});
  test('checkDeviceHasSavedInfo returns correct value', () async {});
}
