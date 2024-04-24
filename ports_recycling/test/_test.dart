import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ports_recycling/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvalidInputError extends Error {
  final String message;

  InvalidInputError(this.message);

  @override
  String toString() => 'InvalidInputError: $message';
}

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
    // Return a mock recycling material for valid recyclable material
    if (materialName == 'validRecyclableMaterial') {
      return {'canBeRecycled': true, 'disposalInfo': 'Dispose responsibly'};
    }
    // Throw InvalidInputError for invalid input
    if (materialName == 'invalidInput') {
      throw InvalidInputError('Invalid input: $materialName');
    }
    // Return null for other cases
    return null;
  }

  @override
  Future<String> getDeviceId() async {
    // Return a mock device ID
    return 'mockDeviceId';
  }

  @override
  Future<bool?> addDeviceIdToAddresses(
      String placeId, bool notifications) async {
    if (placeId == 'invalidInput') {
      throw InvalidInputError('Invalid input: $placeId');
    }
    return true;
  }

  @override
  Future<String?> getFormattedAddress(String deviceId) async {
    if (deviceId == 'invalidInput') {
      throw InvalidInputError('Invalid input: $deviceId');
    }
    return '123 Mock Street';
  }

  @override
  Future<String?> getPostcode(String address) async {
    // Return a valid postcode for valid addresses
    if (address == 'validWholeAddress' || address == 'validChosenAddress') {
      return 'MOCK123';
    }
    // Throw InvalidInputError for invalid input
    if (address == 'invalidInput') {
      throw InvalidInputError('Invalid input: $address');
    }
    // Return null for other cases
    return null;
  }

  @override
  Future<GeoPoint?> getLocation(String deviceId) async {
    if (deviceId == 'invalidInput') {
      throw InvalidInputError('Invalid input: $deviceId');
    }
    return GeoPoint(0, 0);
  }

  @override
  Future<bool?> getNotifications(String postcode) async {
    // Return true if collection date is tomorrow
    if (postcode == 'validPostcodeTomorrow') {
      return true;
    }
    // Throw InvalidInputError for invalid input
    if (postcode == 'invalidInput') {
      throw InvalidInputError('Invalid input: $postcode');
    }
    // Return false for other cases
    return false;
  }

  @override
  Future<String?> getPlaceId(String deviceId) async {
    if (deviceId == 'invalidInput') {
      throw InvalidInputError('Invalid input: $deviceId');
    }
    return 'mockPlaceId';
  }

  @override
  Future<bool> deleteAddressData(String deviceId) async {
    if (deviceId == 'invalidInput') {
      throw InvalidInputError('Invalid input: $deviceId');
    }
    return true;
  }

  @override
  Future<Map<String, dynamic>?> getCollectionDatesForDevice(
      String deviceId) async {
    if (deviceId == 'invalidInput') {
      throw InvalidInputError('Invalid input: $deviceId');
    }
    return {
      'recyclingDates': ['2022-01-01'],
      'wasteDates': ['2022-01-02']
    };
  }

  @override
  Future<Map<String, dynamic>?> getCollectionDatesLocally(
      String postcode) async {
    if (postcode == 'invalidInput') {
      throw InvalidInputError('Invalid input: $postcode');
    }
    return {
      'recyclingDates': ['2022-01-01'],
      'wasteDates': ['2022-01-02']
    };
  }

  @override
  Future<bool> checkDeviceHasSavedInfo(String deviceId) async {
    if (deviceId == 'invalidInput') {
      throw InvalidInputError('Invalid input: $deviceId');
    }
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

  group('getRecyclingMaterial test', () {
    test('Valid recyclable material', () async {
      var material =
          await firebaseService.getRecyclingMaterial('validRecyclableMaterial');
      expect(material, isNotNull);
    });

    test('Valid non-recyclable material', () async {
      var material = await firebaseService
          .getRecyclingMaterial('validNonRecyclableMaterial');
      expect(material, isNull);
    });

    test('Material not in database', () async {
      var material =
          await firebaseService.getRecyclingMaterial('nonExistentMaterial');
      expect(material, isNull);
    });

    test('Empty input', () async {
      var material = await firebaseService.getRecyclingMaterial('');
      expect(material, isNull);
    });

    test('Invalid input', () async {
      expect(() async {
        await firebaseService.getRecyclingMaterial('invalidInput');
      }, throwsA(isA<InvalidInputError>()));
    });
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

    expect(() async {
      await firebaseService.addDeviceIdToAddresses('invalidInput', true);
    }, throwsA(isA<InvalidInputError>()));
  });

  test('getFormattedAddress test', () async {
    String? address = await firebaseService.getFormattedAddress('deviceId');
    expect(address, isNotNull);

    expect(() async {
      await firebaseService.getFormattedAddress('invalidInput');
    }, throwsA(isA<InvalidInputError>()));
  });

  group('getPostcode test', () {
    test('Valid whole addresses written by the user', () async {
      String? postcode = await firebaseService.getPostcode('validWholeAddress');
      expect(postcode, isNotNull);
    });

    test('Valid addresses that the user chose from a list', () async {
      String? postcode =
          await firebaseService.getPostcode('validChosenAddress');
      expect(postcode, isNotNull);
    });

    test('Invalid address', () async {
      String? postcode = await firebaseService.getPostcode('invalidAddress');
      expect(postcode, isNull);
    });

    test('Empty input', () async {
      String? postcode = await firebaseService.getPostcode('');
      expect(postcode, isNull);
    });

    test('Invalid input', () async {
      expect(() async {
        await firebaseService.getPostcode('invalidInput');
      }, throwsA(isA<InvalidInputError>()));
    });
  });

  test('getLocation test', () async {
    GeoPoint? location = await firebaseService.getLocation('deviceId');
    expect(location, isNotNull);

    expect(() async {
      await firebaseService.getLocation('invalidInput');
    }, throwsA(isA<InvalidInputError>()));
  });

  group('getNotifications test', () {
    test('Valid postcode, collection date = not tomorrow', () async {
      bool? notifications =
          await firebaseService.getNotifications('validPostcodeNotTomorrow');
      expect(notifications, isFalse);
    });

    test('Valid postcode, collection date = today', () async {
      bool? notifications =
          await firebaseService.getNotifications('validPostcodeToday');
      expect(notifications, isFalse);
    });

    test('Valid postcode, collection date = tomorrow', () async {
      bool? notifications =
          await firebaseService.getNotifications('validPostcodeTomorrow');
      expect(notifications, isTrue);
    });

    test('Postcode not in database', () async {
      bool? notifications =
          await firebaseService.getNotifications('invalidPostcode');
      expect(notifications, isFalse);
    });
  });

  test('getPlaceId test', () async {
    String? placeId = await firebaseService.getPlaceId('deviceId');
    expect(placeId, isNotNull);

    expect(() async {
      await firebaseService.getPlaceId('invalidInput');
    }, throwsA(isA<InvalidInputError>()));
  });

  test('deleteAddressData test', () async {
    bool result = await firebaseService.deleteAddressData('deviceId');
    expect(result, isTrue);

    expect(() async {
      await firebaseService.deleteAddressData('invalidInput');
    }, throwsA(isA<InvalidInputError>()));
  });

  test('getCollectionDatesForDevice test', () async {
    var dates = await firebaseService.getCollectionDatesForDevice('deviceId');
    expect(dates, isNotNull);

    expect(() async {
      await firebaseService.getCollectionDatesForDevice('invalidInput');
    }, throwsA(isA<InvalidInputError>()));
  });

  test('getCollectionDatesLocally test', () async {
    var dates = await firebaseService.getCollectionDatesLocally('postcode');
    expect(dates, isNotNull);

    expect(() async {
      await firebaseService.getCollectionDatesLocally('invalidInput');
    }, throwsA(isA<InvalidInputError>()));
  });

  test('checkDeviceHasSavedInfo test', () async {
    bool result = await firebaseService.checkDeviceHasSavedInfo('deviceId');
    expect(result, isTrue);

    expect(() async {
      await firebaseService.checkDeviceHasSavedInfo('invalidInput');
    }, throwsA(isA<InvalidInputError>()));
  });
}
