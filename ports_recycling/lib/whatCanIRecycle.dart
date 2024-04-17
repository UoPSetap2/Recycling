import 'main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

final myController = TextEditingController();

class WCIRScreen extends StatefulWidget {
  const WCIRScreen({Key? key}) : super(key: key);

  @override
  _WCIRScreenState createState() => _WCIRScreenState();
}

class _WCIRScreenState extends State<WCIRScreen> {
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
            "What can I recycle?",
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
            "Do recycle:\n  - Food & drinks cans\n  - Plastic bottles with lids on\n  -Card\n  - Paper (not shredded)\n  - Aerosols\n\nDo NOT recycle:\n  - Glass\n  - Textiles\n  - Rubbish bags & plastic bags\n  -Cartons & cups\n  - Polystyrene\n  - Other plastics\n  - Foil\n  - Shredded paper\n  - Wrappers and packets",
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
        

Padding(
  padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
child:
MaterialButton(
                  onPressed: () {                
                     Navigator.pop(
                    context,
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
                    "Back",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
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
}
  