import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ports_recycling/firebase.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

late Future<Map<String, dynamic>?> dates;
List<dynamic> recyclingDates = ["Loading..."];
List<dynamic> wasteDates = ["Loading..."];

FirebaseService firebaseService = RealFirebaseService();

Future<Map<String, dynamic>?> getDates() async {
  if (await firebaseService.checkDeviceHasSavedInfo(deviceId)) {
    dates = firebaseService.getCollectionDatesForDevice(deviceId);
  } else {
    dates = firebaseService.getCollectionDatesLocally(localAddress['postcode']);
  }
  return dates;
}

// Assuming getDates and _buildTable functions remain the same

class CollDates extends StatefulWidget {
  @override
  _CollDatesState createState() => _CollDatesState();
}

class _CollDatesState extends State<CollDates> {
  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    currentDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    getDates().then((dates) {
      setState(() {
        if (dates != null) {
          recyclingDates = dates?['recyclingDates'];
          recyclingDates = recyclingDates
              .where((date) =>
                  DateTime.parse(date
                          .replaceAll('/', '-')
                          .split('-')
                          .reversed
                          .join('-'))
                      .isAfter(currentDate) ||
                  DateTime.parse(date
                          .replaceAll('/', '-')
                          .split('-')
                          .reversed
                          .join('-'))
                      .isAtSameMomentAs(currentDate))
              .toList();
          recyclingDates.sort((a, b) => DateTime.parse(
                  a.replaceAll('/', '-').split('-').reversed.join('-'))
              .compareTo(DateTime.parse(
                  b.replaceAll('/', '-').split('-').reversed.join('-'))));

          wasteDates = dates?['wasteDates'];
          wasteDates = wasteDates
              .where((date) =>
                  DateTime.parse(date
                          .replaceAll('/', '-')
                          .split('-')
                          .reversed
                          .join('-'))
                      .isAfter(currentDate) ||
                  DateTime.parse(date
                          .replaceAll('/', '-')
                          .split('-')
                          .reversed
                          .join('-'))
                      .isAtSameMomentAs(currentDate))
              .toList();
          wasteDates.sort((a, b) => DateTime.parse(
                  a.replaceAll('/', '-').split('-').reversed.join('-'))
              .compareTo(DateTime.parse(
                  b.replaceAll('/', '-').split('-').reversed.join('-'))));

          for (int i = 0; i < 5; i++) {
            recyclingDates.add("---");
            wasteDates.add("---");
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 55, 20, 30),
          child: Text(
            "Collection Dates",
            textAlign: TextAlign.center,
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
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text(
            "Your next collections",
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
        Container(
          width: 310,
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(width: 2, color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          child: Card(
            margin: const EdgeInsets.all(10),
            elevation: 0,
            color: Colors.green,
            child: Column(
              children: [
                Text(
                  "Your next recycling collection",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                if (recyclingDates[0] == "Loading...") Text(recyclingDates[0]),
                if (recyclingDates[0] != "Loading...")
                  Text(
                    DateFormat('EEEE d MMMM yyyy').format(DateTime.parse(
                        recyclingDates[0]
                            .replaceAll('/', '-')
                            .split('-')
                            .reversed
                            .join('-'))),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Container(
          width: 310,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 2, color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          child: Card(
            margin: const EdgeInsets.all(10),
            elevation: 0,
            color: Colors.grey,
            child: Column(
              children: [
                Text(
                  "Your next general waste collection",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                if (wasteDates[0] == "Loading...") Text(wasteDates[0]),
                if (wasteDates[0] != "Loading...")
                  Text(
                    DateFormat('EEEE d MMMM yyyy').format(DateTime.parse(
                        wasteDates[0]
                            .replaceAll('/', '-')
                            .split('-')
                            .reversed
                            .join('-'))),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
          child: Text(
            "Future collections are as follows:",
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
        Container(
          //width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          margin: const EdgeInsets.fromLTRB(25, 10, 25, 0),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(
                    //color: Colors.white,
                    ),
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Recycling",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "General waste",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              for (int i = 1; i < recyclingDates.length && i <= 5; i++)
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                i == recyclingDates.length - 1 || i == 5
                                    ? BorderRadius.only(
                                        bottomLeft: Radius.circular(18))
                                    : BorderRadius.only(
                                        bottomLeft: Radius.circular(0))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            recyclingDates[i],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                i == recyclingDates.length - 1 || i == 5
                                    ? BorderRadius.only(
                                        bottomRight: Radius.circular(18))
                                    : BorderRadius.only(
                                        bottomRight: Radius.circular(0))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            wasteDates[i],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: MaterialButton(
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
      ]),
    );
  }
}
