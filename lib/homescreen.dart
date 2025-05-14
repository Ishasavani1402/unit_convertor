// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, sort_child_properties_last
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String inputunit = 'meters';
  String outputunit = 'meters';
  String inputvalue = '';
  String outputvalue = '';
  double inputfactor = 0.0;
  double outputfactor = 0.0;

  List<Unit> units = [
    Unit(name: 'centemeters', value: 0.01),
    Unit(name: 'meters', value: 1.0),
    Unit(name: 'feet', value: 0.3048),
    Unit(name: 'milimeters', value: 0.01),
  ];

  void unitcnvrtion() {
    final input = double.tryParse(inputvalue) ?? 0.0;
    final result =
        ((input * inputfactor / outputfactor) * 100).roundToDouble() / 100.0;
    setState(() {
      outputvalue = result.toString();
    });
  }

  Widget dropdown(String selectedunit, Function(String) onchanged) {
    return DropdownButton(
      value: selectedunit,
      borderRadius: BorderRadius.circular(10),
      dropdownColor: Colors.grey,
      onChanged: (String? newvalue) {
        if (newvalue != null) {
          onchanged(newvalue);
        }
      },
      items:
          units.map((unit) {
            return DropdownMenuItem(child: Text(unit.name), value: unit.name);
          }).toList(),
    );
  }

  @override
  void initState() {
     
    super.initState();
    inputfactor = units.firstWhere((u) => u.name == inputunit).value;
    outputfactor = units.firstWhere((u) => u.name == outputunit).value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                inputvalue = value;
                unitcnvrtion();
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter unit",
                hintStyle: TextStyle(
                  fontSize: 15,

                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                fillColor: const Color.fromARGB(255, 211, 211, 211),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: dropdown(inputunit, (newunit) {
                    setState(() {
                      inputunit = newunit;
                      inputfactor =
                          units.firstWhere((u) => u.name == inputunit).value;
                      unitcnvrtion();
                    });
                  }),
                ),
                SizedBox(width: 10),
                Icon(Icons.swap_horiz),
                SizedBox(width: 10),
                Expanded(
                  child: dropdown(outputunit, (newunit) {
                    setState(() {
                      outputunit = newunit;
                      outputfactor =
                          units.firstWhere((u) => u.name == outputunit).value;
                      unitcnvrtion();
                    });
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          AnimatedContainer(
            width: 300,
            duration: Duration(seconds: 2),
            curve: Curves.bounceInOut,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Text(
                  "Result",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: Duration(seconds: 2),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Text(
                    "$outputvalue $outputunit",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    key: ValueKey<String>(outputvalue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Unit {
  final String name;
  final double value;

  Unit({required this.name, required this.value});
}
