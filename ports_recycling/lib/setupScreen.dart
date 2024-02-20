import 'package:flutter/material.dart';
import 'main.dart';

final myController = TextEditingController();

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
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
            "Welcome",
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
            "Search for your address",
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
        TextField(
          controller: myController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Search for your address",
          ),
        ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child:
        Row(
          children: [
            const Flexible(
              flex: 3,
              fit: FlexFit.tight,
          child: Text(
            "Set as your home address",
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 18,
              color: Color(0xff000000),
            ),
          ),
        ),

        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SwitchExample(),
        ),
          ],
        ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child:
        Row(
          children: [
            const Flexible(
              fit: FlexFit.tight,
              flex: 3,
          child: Text(
            "Recieve collection notifications for this address",
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 18,
              color: Color(0xff000000),
            ),
          ),
        ),

        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SwitchExample()
        ),
          ],
        ),
        ),

Padding(
  padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
child:
MaterialButton(
                  onPressed: () {                
                     Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavigationBarExample()),
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
                    "Save",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
),

              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child:
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavigationBarExample()),
                  );
                },
                child: Text(
                  "Skip for now",
                  style: TextStyle(color:Colors.green),
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

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.green,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}