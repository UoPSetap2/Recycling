import 'main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

final myController = TextEditingController();

class BinInfo extends StatefulWidget {
  const BinInfo({Key? key}) : super(key: key);

  @override
  _BinInfoState createState() => _BinInfoState();
}

class _BinInfoState extends State<BinInfo> {
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
            "Bin Information",
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

            "Mixed glass\n\n  - glass bottles\n  - glass jars\n\nNOT\n  - Lightbulbs\n  - Panes of glass\n  - Mirrors\n  - Drinking glasses\n  - Candle glass jars\n\n\nMixed plastic\n\n  - plastic pots (e.g. yoghurt pots)\n  - plastic tubs (margarine & ice cream tubs, biscuit tubs)\n  - plastic trays (meat trays, fruit and veg trays)\n\nNOT\n  - Black plastics\n  - Plastic films\n  - Plastic wrappers\n  - Carrier bags\n  - Polystyrene\n\n\nCartons\n\n  - Food and drinks cartons\n  - Paper containers with metal ends (crisps tubes type packaging)\n\nNOT\n  - Glass, paper, card\n  - Plastic bottles and bags\n  - Cans, aerosols and foil\n  - textiles\n\n\nBooks and Media\n\n  - Books\n  - CDs and DVD’s\n\nNOT\n  - Newspapers\n  - Catalogues\n  - Phone directories\n\n\nMixed Textiles & Clothes\n\n  - Clothes\n  - Shoes\n  - Handbags\n  - Bed linens\n  - Towels\n  - Etc.\n\nWith The Salvation Army textile banks, it doesn’t matter how old or worn they are, as long as they are clean and placed in a bag before taking them to the bank.\nHowever,with the Hampshire Search and Rescue (HANTSAR) textile banks ensure the materials are in resalable condition.\nThere are other texture banks run by various charities so you will need to check with them for their restrictions, these are not on our map.\n\nThey do NOT take:\n  - Soiled clothing\n  - Duvets ",
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
  