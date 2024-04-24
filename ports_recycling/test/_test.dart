import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ports_recycling/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseService implements FirebaseService {
  @override
  Future<List<Marker>> getMarkersFromFirestore() async {
    // Return a list of mock markers
    return [Marker(markerId: MarkerId('1'))];
  }

  @override
  Future<List<String>> getDocumentTitles() async {
    // Return a list of mock document titles
    return ['title1', 'title2'];
  }

  @override
  Future<Object?> getRecyclingMaterial(String materialName) async {
    // Return a mock recycling material
    return {'canBeRecycled': true, 'disposalInfo': 'Dispose responsibly'};
  }

  @override
  Future<String> getDeviceId() async {
    // Return a mock device ID
    return 'mockDeviceId';
  }

  @override
  Future<bool?> addDeviceIdToAddresses(
      String placeId, bool notifications) async {
    // Return a mock result
    return true;
  }

  @override
  Future<String?> getFormattedAddress(String deviceId) async {
    // Return a mock formatted address
    return '123 Mock Street';
  }

  @override
  Future<String?> getPostcode(String deviceId) async {
    // Return a mock postcode
    return 'MOCK123';
  }

  @override
  Future<GeoPoint?> getLocation(String deviceId) async {
    // Return a mock location
    return GeoPoint(0, 0);
  }

  @override
  Future<bool?> getNotifications(String deviceId) async {
    // Return a mock notification setting
    return true;
  }

  @override
  Future<String?> getPlaceId(String deviceId) async {
    // Return a mock place ID
    return 'mockPlaceId';
  }

  @override
  Future<bool> deleteAddressData(String deviceId) async {
    // Return a mock result
    return true;
  }

  @override
  Future<Map<String, dynamic>?> getCollectionDatesForDevice(
      String deviceId) async {
    // Return a mock collection dates
    return {
      'recyclingDates': ['2022-01-01'],
      'wasteDates': ['2022-01-02']
    };
  }

  @override
  Future<Map<String, dynamic>?> getCollectionDatesLocally(
      String postcode) async {
    // Return a mock collection dates
    return {
      'recyclingDates': ['2022-01-01'],
      'wasteDates': ['2022-01-02']
    };
  }

  @override
  Future<bool> checkDeviceHasSavedInfo(String deviceId) async {
    // Return a mock result
    return true;
  }
}

void main() {
  // Ensure Flutter engine is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  // Declare a FirebaseService instance
  late FirebaseService firebaseService;

  setUpAll(() async {
    // Initialize the FirebaseService instance with the mock implementation
    firebaseService = MockFirebaseService();
  });

  test('getMarkersFromFirestore test', () async {
    List<Marker> markers = await firebaseService.getMarkersFromFirestore();
    expect(markers, isNotNull);
    expect(markers, isNotEmpty);
  });

  test('getDocumentTitles test', () async {
    List<String> titles = await firebaseService.getDocumentTitles();
    expect(titles, isNotNull);
    expect(titles, isNotEmpty);
  });

  test('getRecyclingMaterial test', () async {
    var material = await firebaseService.getRecyclingMaterial('materialName');
    expect(material, isNotNull);
  });

  test('getDeviceId test', () async {
    String deviceId = await firebaseService.getDeviceId();
    expect(deviceId, isNotNull);
  });

  test('addDeviceIdToAddresses test', () async {
    bool? result =
        await firebaseService.addDeviceIdToAddresses('placeId', true);
    expect(result, isNotNull);
    expect(result, isTrue);
  });

  test('getFormattedAddress test', () async {
    String? address = await firebaseService.getFormattedAddress('deviceId');
    expect(address, isNotNull);
  });

  test('getPostcode test', () async {
    String? postcode = await firebaseService.getPostcode('deviceId');
    expect(postcode, isNotNull);
  });

  test('getLocation test', () async {
    GeoPoint? location = await firebaseService.getLocation('deviceId');
    expect(location, isNotNull);
  });

  test('getNotifications test', () async {
    bool? notifications = await firebaseService.getNotifications('deviceId');
    expect(notifications, isNotNull);
  });

  test('getPlaceId test', () async {
    String? placeId = await firebaseService.getPlaceId('deviceId');
    expect(placeId, isNotNull);
  });

  test('deleteAddressData test', () async {
    bool result = await firebaseService.deleteAddressData('deviceId');
    expect(result, isTrue);
  });

  test('getCollectionDatesForDevice test', () async {
    var dates = await firebaseService.getCollectionDatesForDevice('deviceId');
    expect(dates, isNotNull);
  });

  test('getCollectionDatesLocally test', () async {
    var dates = await firebaseService.getCollectionDatesLocally('postcode');
    expect(dates, isNotNull);
  });

  test('checkDeviceHasSavedInfo test', () async {
    bool result = await firebaseService.checkDeviceHasSavedInfo('deviceId');
    expect(result, isTrue);
  });
}
