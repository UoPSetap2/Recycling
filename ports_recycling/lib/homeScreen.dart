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
              child:
              Padding(
              padding: EdgeInsets.fromLTRB(10,25,10,10),
              child: 
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
                  height: 150,
                  minWidth: 120,
                  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.calendar_month,
        size: 48, // Adjust the size of the icon as needed
        color: Colors.white,
      ),
      const SizedBox(height: 8), // Add some space between the icon and text
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
              child:
              Padding(
              padding: EdgeInsets.fromLTRB(10,25,10,10),
              child: 
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
                  height: 150,
                  minWidth: 120,
                  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.question_mark,
        size: 48, // Adjust the size of the icon as needed
        color: Colors.white,
      ),
      const SizedBox(height: 8), // Add some space between the icon and text
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
              child:
              Padding(
              padding: EdgeInsets.fromLTRB(10,40,10,10),
              child: 
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
                  height: 150,
                  minWidth: 120,
                  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.info,
        size: 48, // Adjust the size of the icon as needed
        color: Colors.white,
      ),
      const SizedBox(height: 8), // Add some space between the icon and text
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
              child:
              Padding(
              padding: EdgeInsets.fromLTRB(10,40,10,10),
              child: 
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
                  height: 150,
                  minWidth: 120,
                  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.recycling,
        size: 48, // Adjust the size of the icon as needed
        color: Colors.white,
      ),
      const SizedBox(height: 8), // Add some space between the icon and text
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
              padding: EdgeInsets.fromLTRB(10,40,10,0),
              child: 
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
                  height: 75,
                  minWidth: 280,
                  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.search,
        size: 48, // Adjust the size of the icon as needed
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
        )
      )

        

      ],
    ),
  ),

    ]
  )
));
  }
}
