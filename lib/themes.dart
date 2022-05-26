import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:khsplan/scraper/tage.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),

  );

  //Set looks of a card with each content
  //TODO: Fix length/make cards bigger
  Widget buildCard(Tage snap) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: choosecardcolor(snap),
      elevation: 5,
      child:
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(snap.stunde, style: const TextStyle(fontSize: 16), ),
                  Text(snap.klasse, style: const TextStyle(fontSize: 16), ),
                  Text(snap.lehrer, style: const TextStyle(fontSize: 16), ),
                  Text(snap.fach, style: const TextStyle(fontSize: 16),),
                ],
              ),
              Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: [
                  Text("Raum: "+snap.raum + "\t", style: const TextStyle(fontSize: 16),),
                  Expanded(
                    child: Text(snap.art + "\t" + snap.mitteilung, style: const TextStyle(fontSize: 16),),
                  ),

                ],
              ),
            ],
          ),),
    );
  }

  choosecardcolor(Tage snap) {
    bool _isDarkmode = Settings.getValue<bool>("keydarkmode", true);
    String type = snap.art.toUpperCase();
    if(_isDarkmode) {
      //When Darkmode is on
      if (type.contains("ENTFÄLLT")) {
        return Colors.red;
      }
      else if (type.contains("VERSCHOBEN")) {
        return Colors.blue;
      }
      else if (type.contains("RAUMÄNDERUNG")) {
        return Colors.green;
      }
      else if (type.contains("ZUSATZUNTERRICHT")) {
        return Colors.cyan;
      }
      else if (type.contains("AUFGABEN")) {
        return Colors.deepPurple;
      }
      else if (type.contains("AUFGABEN")) {
        return Colors.orange;
      }
      else {
        return Colors.teal;
      }
    }
    else{
      if (type.contains("ENTFÄLLT")) {
        return Colors.redAccent;
      }
      else if (type.contains("VERSCHOBEN")) {
        return Colors.lightBlueAccent;
      }
      else if (type.contains("RAUMÄNDERUNG")) {
        return Colors.greenAccent;
      }
      else if (type.contains("ZUSATZUNTERRICHT")) {
        return Colors.cyanAccent;
      }
      else if (type.contains("AUFGABEN")) {
        return Colors.deepPurpleAccent;
      }
      else if (type.contains("AUFGABEN")) {
        return Colors.orangeAccent;
      }
      else {
        return Colors.tealAccent;
      }
    }
}
}