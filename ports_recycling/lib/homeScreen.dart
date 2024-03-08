import 'package:flutter/material.dart';
import 'main.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {


return WillPopScope(
  onWillPop: () async => false,
  child: Scaffold(
  backgroundColor: const Color(0xffffffff),
  body: Stack(
    children: [
  
  SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(40, 20, 40, 60),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 55, 20, 30),
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

        MaterialButton(
                  onPressed: () {},
                  color: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.white, width: 2.5),
                  ),
                  padding: const EdgeInsets.all(12),
                  textColor: Colors.white,
                  height: 60,
                  minWidth: 150,
                  child: const Text(
                    "Find Collection Dates",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),

                MaterialButton(
                  onPressed: () {},
                  color: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.white, width: 2.5),
                  ),
                  padding: const EdgeInsets.all(12),
                  textColor: Colors.white,
                  height: 60,
                  minWidth: 150,
                  child: const Text(
                    "What can I recycle?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),

                MaterialButton(
                  onPressed: () {},
                  color: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.white, width: 2.5),
                  ),
                  padding: const EdgeInsets.all(12),
                  textColor: Colors.white,
                  height: 60,
                  minWidth: 150,
                  child: const Text(
                    "Bin Information",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),

                MaterialButton(
                  onPressed: () {},
                  color: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.white, width: 2.5),
                  ),
                  padding: const EdgeInsets.all(12),
                  textColor: Colors.white,
                  height: 60,
                  minWidth: 150,
                  child: const Text(
                    "Recycling Center\nInformation",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),

                MaterialButton(
                  onPressed: () {},
                  color: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.white, width: 2.5),
                  ),
                  padding: const EdgeInsets.all(12),
                  textColor: Colors.white,
                  height: 60,
                  minWidth: 150,
                  child: const Text(
                    "Item Search",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),

      ],
    ),
  ),

    ]
  )
));
  }
}
