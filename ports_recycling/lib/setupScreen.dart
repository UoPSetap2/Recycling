import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ports_recycling/firebase.dart';

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
  String? address = "";
  late bool homeAddress;
  late bool notifications;
  String? formattedAddress = "";

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
                      "Enter your address",
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
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
                    child: address == ""
                        ? AddressSearchBar(
                            controller: searchController,
                            onSelected: (placeId) {
                              setState(() {
                                searchController.clear();
                                address = placeId!;
                              });

                              getStringAddress(address!).then((value) {
                                setState(() {
                                  formattedAddress = value;
                                });
                              });
                              // Instead of calling select address, display the selected address here
                              // selectAddress(address);
                              
                              
                            },
                          )
                        : Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child:
                            Text(
                            formattedAddress!,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 18,
                              color: Color(0xff000000),
                            ),
                          ),),
                          Expanded(
                            flex: 1,
                            child:
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                address = "";
                              });
                              print("Edit");
                            },
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16),
                            ),
                          ),),
                          ],
                        )
                        
                        
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
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
                          child: SwitchExample(
                                  onChanged: (value) {
                                    homeAddress = value;
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
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
                          child: SwitchExample(
                                  onChanged: (value) {
                                    notifications = value;
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                    child: MaterialButton(
                      onPressed: () {

                        // Save address info to DB
                        addDeviceIdToAddresses(address!, notifications);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BottomNavigationBarExample()),
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BottomNavigationBarExample()),
                        );
                      },
                      child: Text(
                        "Skip for now",
                        style: TextStyle(color: Colors.green),
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
}

class AddressSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String?> onSelected;

  AddressSearchBar({required this.controller, required this.onSelected});

  @override
  _AddressSearchBarState createState() => _AddressSearchBarState();
}

class _AddressSearchBarState extends State<AddressSearchBar> {
  PlacesAutocompleteResponse searchResults =
      PlacesAutocompleteResponse(status: '', predictions: []);

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
                            searchResults = PlacesAutocompleteResponse(
                                status: '',
                                predictions: []); // Reset to an empty response
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
    final places =
        GoogleMapsPlaces(apiKey: 'AIzaSyDFTy0iz-fmqTKm8wMkOYuVTgK4eEPr94c');
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
  final ValueChanged<bool>? onChanged;

  const SwitchExample({Key? key, this.onChanged}) : super(key: key);

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
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}

// Function put here so I can Import it due to visibility issues
// I'm defining a function that takes a place ID as input and returns a map containing the
// formatted address, postcode, and location (latitude and longitude) of the place.
Future<Map<String, dynamic>?> selectAddress(String placeId) async {
  // I'm creating a GoogleMapsPlaces object with my API key
  final places =
      GoogleMapsPlaces(apiKey: 'AIzaSyDFTy0iz-fmqTKm8wMkOYuVTgK4eEPr94c');

  // I'm using the GoogleMapsPlaces object to get the details of the place with the given ID
  PlacesDetailsResponse response = await places.getDetailsByPlaceId(placeId);

  // I'm getting the location (latitude and longitude) of the place
  final location = response.result.geometry?.location;

  // If the location is null (which means the place doesn't have a location), I return null
  if (location == null) {
    return null;
  }

  // I'm getting the formatted address of the place
  final formattedAddress = response.result.formattedAddress;

  // I'm splitting the formatted address into lines
  final lines = formattedAddress?.split(', ');

  // I'm getting all lines except the last one (which is the postcode)
  final addressLines = lines?.sublist(0, lines.length - 1);

  // I'm getting the postcode
  var postcode = addressLines!.last;

  // I'm splitting the postcode into words
  List<String> splitPostcode = postcode.split(' ');

  // I'm reassembling the postcode from the second word onwards
  postcode = '';
  for (int i = 1; i < splitPostcode.length; i++) {
    postcode = postcode + splitPostcode[i];
    if (i == 1) {
      postcode += ' ';
    }
  }

  print(postcode);

  // I'm returning a map containing the formatted address, postcode, and location
  return {
    'formattedAddress': formattedAddress,
    'postcode': postcode,
    'location': GeoPoint(location.lat, location.lng),
  };

}

Future<String?> getStringAddress(String placeId) async {
  // I'm creating a GoogleMapsPlaces object with my API key
  final places =
      GoogleMapsPlaces(apiKey: 'AIzaSyDFTy0iz-fmqTKm8wMkOYuVTgK4eEPr94c');

  // I'm using the GoogleMapsPlaces object to get the details of the place with the given ID
  PlacesDetailsResponse response = await places.getDetailsByPlaceId(placeId);

  // I'm getting the location (latitude and longitude) of the place
  final location = response.result.geometry?.location;

  // If the location is null (which means the place doesn't have a location), I return an empty string
  if (location == null) {
    return "";
  }
  // I'm getting the formatted address of the place
  return response.result.formattedAddress?.replaceAll(', ', ',\n');

}
