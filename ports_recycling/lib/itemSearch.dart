import 'package:ports_recycling/firebase.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

final myController = TextEditingController();

FirebaseService firebaseService = RealFirebaseService();

class ItemSearch extends StatefulWidget {
  const ItemSearch({Key? key}) : super(key: key);

  @override
  _ItemSearchState createState() => _ItemSearchState();
}

class _ItemSearchState extends State<ItemSearch> {
  late GoogleMapController mapController;
  TextEditingController searchController = TextEditingController();
  late PlacesAutocompleteResponse searchResults;

  String materialName = "";
  Map<String, dynamic> materialInfo = {};

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
                      "Search for an item",
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
                      "Enter an item",
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
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child:
                        MaterialSearchBar(onSelected: (selectedMaterial) async {
                      setState(() {
                        materialName = selectedMaterial;
                      });

                      firebaseService
                          .getRecyclingMaterial(materialName)
                          .then((result) {
                        setState(() {
                          materialInfo = result as Map<String, dynamic>;
                        });
                      });
                    }), // Insert the MaterialSearchBar here
                  ),
                  if (materialName != "")
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        materialName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  if (materialInfo != {})
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        children: materialInfo.entries.map((entry) {
                          return ListTile(
                            title: Text(getText(entry.key)),
                            subtitle: Text(getText(entry.value.toString())),
                          );
                        }).toList(),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
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
    final places =
        GoogleMapsPlaces(apiKey: 'AIzaSyAY5ze0DWYSopAw0ongFHOMlNx_c6VmvSA');
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

class MaterialSearchBar extends StatefulWidget {
  final Function(String) onSelected; // Callback for item selection

  MaterialSearchBar({required this.onSelected}); // Constructor

  @override
  _MaterialSearchBarState createState() => _MaterialSearchBarState();
}

class _MaterialSearchBarState extends State<MaterialSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Search for a material, e.g. cardboard",
          ),
          onChanged: (value) {
            print('Search query: $value'); // Debug print
            setState(() {
              // Update the suggestions list here
              // You can replace this with your Firestore query
              getFilteredSuggestions(value).then((suggestions) {
                setState(() {
                  _suggestions = suggestions;
                  print('Suggestions: $_suggestions'); // Debug print
                });
              });
            });
          },
        ),
        // Display suggestions list here (use ListView.builder)
        if (_suggestions.isNotEmpty)
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
              children: _suggestions.map((suggestion) {
                return ListTile(
                  title: Text(suggestion),
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    _suggestions = [];
                    _searchController.clear();
                    // Call the onSelected callback with the selected suggestion
                    widget.onSelected(suggestion);
                  },
                );
              }).toList(), // Add .toList() to convert the result to List<Widget>
            ),
          ),
      ],
    );
  }

  Future<List<String>> getFilteredSuggestions(String query) async {
    // Simulated list of suggestions
    List<String> allMaterials = await firebaseService.getDocumentTitles();
    // Filter suggestions based on query
    return allMaterials
        .where(
            (material) => material.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

String getText(input) {
  if (input == "canBeRecycled") {
    return "Can this be recycled?";
  } else if (input == "true") {
    return "Yes";
  } else if (input == "false") {
    return "No";
  } else if (input == "disposalInfo") {
    return "Disposal information:";
  } else {
    return input;
  }
}
