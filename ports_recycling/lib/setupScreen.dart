import 'main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

final myController = TextEditingController();

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late GoogleMapController mapController;
  TextEditingController searchController = TextEditingController();
  late PlacesAutocompleteResponse searchResults;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: Stack(
          children: [
            SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 55, 20, 30),
          child: Text(
            "Welcome",
            textAlign: TextAlign.start,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 32,
              color: Color(0xff000000),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
          child: Text(
            "Search for your address",
            textAlign: TextAlign.start,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 20,
              color: Color(0xff000000),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
          child:
        AddressSearchBar(
                      controller: searchController,
                      onSelected: (placeId) {
                        selectAddress(placeId!);
                      },
                    ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child:
        Row(
          children: [
            const Flexible(
              flex: 3,
              fit: FlexFit.tight,
          child: Text(
            "Set as your home address",
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 18,
              color: Color(0xff000000),
            ),
          ),
        ),

        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SwitchExample(),
        ),
          ],
        ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child:
        Row(
          children: [
            const Flexible(
              fit: FlexFit.tight,
              flex: 3,
          child: Text(
            "Recieve collection notifications for this address",
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 18,
              color: Color(0xff000000),
            ),
          ),
        ),

        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SwitchExample()
        ),
          ],
        ),
        ),

Padding(
  padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
child:
MaterialButton(
                  onPressed: () {                
                     Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavigationBarExample()),
                  );
                  },
                  color: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.white, width: 2.5),
                  ),
                  padding: const EdgeInsets.all(12),
                  textColor: Colors.white,
                  height: 20,
                  minWidth: 150,
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
),

              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child:
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavigationBarExample()),
                  );
                },
                child: Text(
                  "Skip for now",
                  style: TextStyle(color:Colors.green),
                ),
              ),
              ),

      ],
    ),
  ),
          ],
        ),
      ),
    );
  }

  // ... existing code

  void selectAddress(String placeId) async {
    final places = GoogleMapsPlaces(apiKey: 'AIzaSyDFTy0iz-fmqTKm8wMkOYuVTgK4eEPr94c');
    PlacesDetailsResponse response = await places.getDetailsByPlaceId(placeId);
    final location = response.result.geometry?.location;

    // You can use the location.latitude and location.longitude to do further processing
    print(
        'Selected address: ${response.result.formattedAddress} (${location?.lat}, ${location?.lng})');
  }
}

class AddressSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String?> onSelected;

  AddressSearchBar({required this.controller, required this.onSelected});

  @override
  _AddressSearchBarState createState() => _AddressSearchBarState();
}

class _AddressSearchBarState extends State<AddressSearchBar> {
  PlacesAutocompleteResponse searchResults = PlacesAutocompleteResponse(status: '', predictions: []);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Search for your address",
          ),
          onChanged: (value) {
            searchPlaces(value);
          },
        ),
        if (searchResults.predictions.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: searchResults.predictions
                  .map((Prediction prediction) => ListTile(
                        title: Text(prediction.description ?? ''),
                        onTap: () {
                          widget.controller.text = prediction.description ?? '';
                          widget.onSelected(prediction.placeId ?? '');
                          setState(() {
                            searchResults = PlacesAutocompleteResponse(status: '', predictions: []); // Reset to an empty response
                          });
                        },
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  void searchPlaces(String query) async {
    final places = GoogleMapsPlaces(apiKey: 'AIzaSyDFTy0iz-fmqTKm8wMkOYuVTgK4eEPr94c');
    PlacesAutocompleteResponse response = await places.autocomplete(
      query,
      language: 'en',
      types: ['address'],
    );

    setState(() {
      searchResults = response;
    });
  }
}


class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.green,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}