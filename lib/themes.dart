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
      //color: _chooseColor(snap.art.toString()),
      child:
          //Leading stunden nummer implement + https://stackoverflow.com/questions/70147048/how-can-i-make-a-better-card-ui-spacing-in-flutter \t\t
      //make text with
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(snap.stunde, style: const TextStyle(fontSize: 16),),
                  Text(snap.klasse, style: const TextStyle(fontSize: 16),),
                  Text(snap.fach, style: const TextStyle(fontSize: 16),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Raum: "+snap.raum, style: const TextStyle(fontSize: 16),),
                  Text(snap.art, style: const TextStyle(fontSize: 16),),
                  Text(snap.lehrer, style: const TextStyle(fontSize: 16),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(snap.mitteilung, style: const TextStyle(fontSize: 16),),
                ],
              ),
            ],
          ),),
    );
  }

  choosecardcolor(Tage snap) {
    bool _isDarkmode = Settings.getValue<bool>("keydarkmode", true);
    if(_isDarkmode) {
      //When Darkmode is on
      if (snap.art.toUpperCase().contains("ENTFÄLLT")) {
        return Colors.red;
      }
      else if (snap.art.toUpperCase().contains("VERSCHOBEN")) {
        return Colors.blue;
      }
      else if (snap.art.toUpperCase().contains("RAUMÄNDERUNG")) {
        return Colors.cyan;
      }
      else if (snap.art.toUpperCase().contains("ZUSATZUNTERRICHT")) {
        return Colors.green;
      }
    }
    else{
      if (snap.art.toUpperCase().contains("ENTFÄLLT")) {
        return Colors.redAccent;
      }
      else if (snap.art.toUpperCase().contains("VERSCHOBEN")) {
        return Colors.lightBlueAccent;
      }
      else if (snap.art.toUpperCase().contains("RAUMÄNDERUNG")) {
        return Colors.cyanAccent;
      }
      else if (snap.art.toUpperCase().contains("ZUSATZUNTERRICHT")) {
        return Colors.greenAccent;
      }
    }
}
}