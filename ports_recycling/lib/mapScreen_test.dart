import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/services.dart';
import 'package:ports_recycling/mapScreen.dart';

class MockGoogleMapController extends Mock implements GoogleMapController {}

void main() {
  late MapScreen mapScreen;
  late MockGoogleMapController mockController;

  setUp(() {
    mapScreen = MapScreen();
    mockController = MockGoogleMapController();
  });

  testWidgets('Test _onMapCreated', (WidgetTester tester) async {
    // Mock the rootBundle.loadString method
    const csvData = '1,50.123,1.234,Property 1\n2,51.123,2.234,Property 2\n';
    final mockRootBundle = MockRootBundle();
    when(mockRootBundle.loadString(any)).thenAnswer((_) async => csvData);
    mapScreen.rootBundle = mockRootBundle;

    await tester.pumpWidget(MaterialApp(home: mapScreen));

    await mapScreen._onMapCreated(mockController);

    // Verify that the markers are added correctly
    expect(mapScreen.markers.length, 2);
    expect(mapScreen.markers[0].position, LatLng(50.123, 1.234));
    expect(mapScreen.markers[0].infoWindow.title, 'Recycling Point 1');
    expect(mapScreen.markers[0].infoWindow.snippet, 'Property 1');
    expect(mapScreen.markers[1].position, LatLng(51.123, 2.234));
    expect(mapScreen.markers[1].infoWindow.title, 'Recycling Point 2');
    expect(mapScreen.markers[1].infoWindow.snippet, 'Property 2');

    // Verify that the recycling center marker is added correctly
    expect(mapScreen.markers.last.position,
        LatLng(50.839080810546875, -1.0951703786849976));
    expect(mapScreen.markers.last.infoWindow.title, 'Recycling Center');
    expect(mapScreen.markers.last.infoWindow.snippet,
        'Paulsgrove Portway,\nPort Solent,\nPO6 4UD');
  });
}

class MockRootBundle extends Mock implements AssetBundle {}
