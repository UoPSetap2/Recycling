import 'package:flutter/material.dart';
import 'package:ports_recycling/binInfo.dart';
import 'package:ports_recycling/colDatesScreen.dart';
import 'package:ports_recycling/firebase.dart';
import 'package:ports_recycling/itemSearch.dart';
import 'package:ports_recycling/rciScreen.dart';
import 'package:ports_recycling/whatCanIRecycle.dart';
import 'main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

FirebaseService firebaseService = RealFirebaseService();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    firebaseService.checkDeviceHasSavedInfo(deviceId).then((hasSavedInfo) {
      if (hasSavedInfo) {
        firebaseService.getNotifications(deviceId).then((notifications) {
          if (notifications != null && notifications) {
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
                      .compareTo(DateTime.parse(b
                          .replaceAll('/', '-')
                          .split('-')
                          .reversed
                          .join('-'))));

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
                      .compareTo(DateTime.parse(b
                          .replaceAll('/', '-')
                          .split('-')
                          .reversed
                          .join('-'))));

                  for (int i = 0; i < 5; i++) {
                    recyclingDates.add("---");
                    wasteDates.add("---");
                  }
                }
              });
            });

            DateTime today = DateTime.now();
            today = DateTime(today.year, today.month, today.day);
            DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
            tomorrow = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

            if (wasteDates[0] != "Loading..." &&
                recyclingDates[0] != "Loading...") {
              DateTime wasteDate = DateTime.parse(wasteDates[0]
                  .replaceAll('/', '-')
                  .split('-')
                  .reversed
                  .join('-'));
              DateTime recyclingDate = DateTime.parse(recyclingDates[0]
                  .replaceAll('/', '-')
                  .split('-')
                  .reversed
                  .join('-'));
              if (wasteDate == today ||
                  recyclingDate == today ||
                  wasteDate == tomorrow ||
                  recyclingDate == tomorrow) {
                showNotification();
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: const Color(0xffffffff),
            body: Stack(children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 65, 20, 30),
                      child: Text(
                        "Recycling Home",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 32,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 25, 10, 10),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        if (await firebaseService
                                                .checkDeviceHasSavedInfo(
                                                    deviceId) ||
                                            localAddress.isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CollDates()),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Error"),
                                                content: Text(
                                                    "No address selected. Please go to settings and enter an address to find your collection dates"),
                                                actions: [
                                                  TextButton(
                                                    child: Text("OK"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      color: Colors.green,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: const BorderSide(
                                            color: Colors.white, width: 2.5),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      textColor: Colors.white,
                                      height: 150,
                                      minWidth: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            size:
                                                48, // Adjust the size of the icon as needed
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Add some space between the icon and text
                                          Text(
                                            "Find Collection Dates",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 25, 10, 10),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const WCIRScreen()),
                                        );
                                      },
                                      color: Colors.green,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: const BorderSide(
                                            color: Colors.white, width: 2.5),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      textColor: Colors.white,
                                      height: 150,
                                      minWidth: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.question_mark,
                                            size:
                                                48, // Adjust the size of the icon as needed
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Add some space between the icon and text
                                          Text(
                                            "What can I recycle?",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 40, 10, 10),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BinInfo()),
                                        );
                                      },
                                      color: Colors.green,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: const BorderSide(
                                            color: Colors.white, width: 2.5),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      textColor: Colors.white,
                                      height: 150,
                                      minWidth: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info,
                                            size:
                                                48, // Adjust the size of the icon as needed
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Add some space between the icon and text
                                          Text(
                                            "Bin Information",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 40, 10, 10),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const RCIScreen()),
                                        );
                                      },
                                      color: Colors.green,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: const BorderSide(
                                            color: Colors.white, width: 2.5),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      textColor: Colors.white,
                                      height: 150,
                                      minWidth: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.recycling,
                                            size:
                                                48, // Adjust the size of the icon as needed
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Add some space between the icon and text
                                          Text(
                                            "Recycling Center Information",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ItemSearch()),
                                  );
                                },
                                color: Colors.green,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: const BorderSide(
                                      color: Colors.white, width: 2.5),
                                ),
                                padding: const EdgeInsets.all(12),
                                textColor: Colors.white,
                                height: 75,
                                minWidth: 280,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size:
                                          48, // Adjust the size of the icon as needed
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Item Search",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ])));
  }
}

final AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

Future<void> showNotification() async {
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name', // Corrected the parameter name
    //'your channel description',
    icon: '@mipmap/ic_launcher', // Corrected the parameter name
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'Upcoming Collection',
    'You have a collection soon, make sure to put the bins out!',
    platformChannelSpecifics,
    payload: 'item x',
  );
}
