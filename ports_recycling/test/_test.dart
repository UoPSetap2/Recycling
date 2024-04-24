import 'package:device_info/device_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ports_recycling/firebase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

class MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {}

void main() {
  final firestore = MockFirebaseFirestore();
  final collectionReference = MockCollectionReference();
  final querySnapshot = MockQuerySnapshot();
  final queryDocumentSnapshot = MockQueryDocumentSnapshot();
  final geoPoint = GeoPoint(0, 0);

  when(firestore.collection('RecyclingMaterials'))
      .thenReturn(collectionReference);
  when(collectionReference.get()).thenAnswer((_) async => querySnapshot);
  when(querySnapshot.docs).thenReturn([queryDocumentSnapshot]);
  when(queryDocumentSnapshot.id).thenReturn('docID');

  test('getDocumentTitles returns a list of document IDs', () async {
    List<String> titles = await getDocumentTitles(firestore);

    expect(titles, isA<List<String>>());
    expect(titles.length, equals(1));
    expect(titles[0], equals('docID'));
  });

  when(firestore.collection('RecyclingPoints')).thenReturn(collectionReference);
  when(collectionReference.get()).thenAnswer((_) async => querySnapshot);
  when(querySnapshot.docs).thenReturn([queryDocumentSnapshot]);
  when(queryDocumentSnapshot['Location']).thenReturn(geoPoint);
  when(queryDocumentSnapshot['Description']).thenReturn('description');

  test('getMarkersFromFirestore returns a list of markers', () async {
    List<Marker> markers = await getMarkersFromFirestore(firestore);

    expect(markers, isA<List<Marker>>());
    expect(markers.length, equals(1));
    expect(markers[0].markerId, equals(MarkerId(geoPoint.toString())));
    expect(markers[0].position,
        equals(LatLng(geoPoint.latitude, geoPoint.longitude)));
    expect(markers[0].infoWindow.title, equals('Recycling Point'));
    expect(markers[0].infoWindow.snippet, equals('description'));
  });

  test('testing getRecyclingMaterial', () async {});

  test('testing getDeviceId', () async {});

  test('testing addDeviceIdToAddresses', () async {});

  test('testing getFormattedAddress', () async {});

  test('testing getPostcode', () async {});

  test('testing getLocation', () async {});

  test('testing getNotifications', () async {});

  test('testing getPlaceId', () async {});

  test('testing deleteAddressData', () async {});

  test('testing getCollectionDatesForDevice', () async {});

  test('testing getCollectionDatesLocally', () async {});

  test('testing checkDeviceHasSavedInfo', () async {});
}
