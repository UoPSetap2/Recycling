import 'package:ports_recycling/firebase.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';


late Future<Map<String, dynamic>?> dates;

Future<List<String>> getDates(String type) async {

  dates = getCollectionDatesForDevice(await getDeviceId());
  print((await dates)?['recyclingDates']);
  print((await dates)?['wasteDates']);

return (await dates)?[type]?.cast<String>() ?? [];

}


class CollDates extends StatefulWidget {
  const CollDates({Key? key}) : super(key: key);

  @override
  _CollDatesState createState() => _CollDatesState();
}

class _CollDatesState extends State<CollDates> {
  // late GoogleMapController mapController;
  // TextEditingController searchController = TextEditingController();
  // late PlacesAutocompleteResponse searchResults;

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
                      "Black Bin Collection Dates",
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

                  FutureBuilder(
                    future: _buildTable('wasteDates'),
                    builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return snapshot.data ?? Container();
                      }
                    },
                  ),
                  
                  

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      "Green Bin Collection Dates",
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

                  
                  Column(
                    children: [
                      FutureBuilder(
                        future: _buildTable('recyclingDates'),
                        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return snapshot.data ?? Container();
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),


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



  Future<Widget> _buildTable(String type) async {
    Future<List<String>> dates = getDates(type);
    List<String> datesList = await dates;
    return SizedBox(
      height: 200, // Adjust the height according to your needs
      child: ListView.builder(
        itemCount: datesList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(datesList[index]),
            // You can customize the ListTile as needed
          );
        },
      ),
    );
  }
}
