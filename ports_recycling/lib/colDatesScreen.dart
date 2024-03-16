import 'main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

final myController = TextEditingController();

class CollDates extends StatefulWidget {
  const CollDates({Key? key}) : super(key: key);

  @override
  _CollDatesState createState() => _CollDatesState();
}

class _CollDatesState extends State<CollDates> {
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
            "Your upcoming collections",
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
            "This will be a table of dates from db",
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

        // Padding(
        //   padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
        //   child:
        // AddressSearchBar(
        //               controller: searchController,
        //               onSelected: (placeId) {
        //                 selectAddress(placeId!);
        //               },
        //             ),
        // ),


Padding(
  padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
child:
MaterialButton(
                  onPressed: () {                
                     Navigator.pop(
                    context);
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
                    "Back",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
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

    // The following dissects the selected address into each line, also providing the coordinates and postcode
        final formattedAddress = response.result.formattedAddress;
        final lines = formattedAddress?.split(', ');
        final addressLines = lines?.sublist(0, lines.length - 1);
        var postcode = addressLines!.last;
        List<String> splitPostcode = postcode.split(' ');
        postcode = '';
        for (int i = 1; i < splitPostcode.length; i++) {
          postcode = postcode + splitPostcode[i];
          if (i == 1) {
            postcode += ' ';
          } 
        }

        print('Selected address:');
        for (int i = 0; i < addressLines.length - 1; i++) {
          print(addressLines[i]);
        }
        print('Postcode: $postcode');
        print('Latitude: ${location?.lat}');
        print('Longitude: ${location?.lng}');

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
            hintText: "Search for an item",
          ),
          onChanged: (value) {
            //searchPlaces(value);
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
}
