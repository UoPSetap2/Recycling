import 'main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

final myController = TextEditingController();

class RCIScreen extends StatefulWidget {
  const RCIScreen({Key? key}) : super(key: key);

  @override
  _RCIScreenState createState() => _RCIScreenState();
}

class _RCIScreenState extends State<RCIScreen> {
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
            "Portsmouth Recycling Center",
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
<<<<<<< Updated upstream
            "Enter info here...",
=======
            "You must have an appointment to go to the Portsmouth Household Waste Recycling Centre. If you visit without one, you will be turned away.\n\nYou can book an appointment online or call 0300 555 1389.\n\nThe site is open 7 days a week throughout the year, except Christmas Day, Boxing Day and New Year’s Day.\n\nOpening hours:\n9am - 4pm : 1st of October to 28th of February\n9am - 5pm : 1st of March to 31st of March\n9am - 6pm : 1st of April to 20th of September\nThe site is closed daily from 1pm to 1:30pm\n\nAddress:\nPaulsgrove Portway\nPort Solent\nPO6 4UD\n\n\nBefore you visit, make sure you have:\n   - Booked an appointment\n   - Separated different types of materials\n   - Checked you have a valid permit if your vehicle requires one\n   - Got your booking confirmation available for site staff to check\n   - Do NOT turn up early, you may be asked to re-join the queue or return at your stated appointed time.\n\nFrom January 1st 2024, each Hampshire household may deposit up to eight 50-litre rubble bags, or 4 bulky items, free of charge every 4 weeks.\n\n\nAccepted items:\n   - Baths\n   - Batteries\n   - Bedding, quilts, pillows and sleeping bags\n   - Car batteries\n   - Cardboard\n   - Carpets\n   - Christmas trees - real\n   - Electrical equipment and appliances\n   - Fridges/freezers\n   - Garden waste\n   - Knives and scissors\n   - Light bulbs\n   - Mattress\n   - Mobile phones\n   - Printer cartridges\n   - Vapes and e-cigarettes\n   - Wood\n\nRestricted items:\n   - Animal waste\n   - Asbestos\n   - Engine oil\n   - Fire extinguishers\n   - Furniture\n   - Gas bottles\n   - Household and garden chemicals\n   - Paint\n   - Pesticides\n   - Plasterboard\n   - Rubble\n   - Sinks, toilets and shower trays\n   - Soil\n   - Upholstered domestic seating\n\nNot accepted:\n   - Ammunition\n   - Cooking oil\n   - Explosives\n   - Flares\n   - Fuel - petrol or diesel\n   - Halon fire extinguishers\n   - Japanese knotweed\n   - Medicines\n   - Tyres",
>>>>>>> Stashed changes
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
  