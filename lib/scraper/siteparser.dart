import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:html/dom.dart';
import 'package:khsplan/scraper/change.dart';


class SiteParser {

  List<Change> getData(Document site) {
    List<Change> changes = [];
    final String date =
        site.querySelector('h1.list-table-caption')!.text.toString();
    //gets Table
    final table = site.querySelector('table.list-table');
    //gets specifc data
    final tabledata = table!.querySelectorAll('tr');

    //Outprint -> Later parsing

    int lessonNumberInt = 0;
    for (var entry in tabledata) {
      // the first row isn't like the others
      if (entry.querySelectorAll('td').isNotEmpty) {
        if (entry.querySelectorAll('td')[1].text.isNotEmpty &&
            entry.querySelectorAll('td')[1].text.trim() != "") {
          lessonNumberInt = int.parse(entry
              .querySelectorAll('td')[1]
              .text
              .trim()
              .toString()
              .replaceAll(".", "")); // we have to get rid of this dot
        }

        // TODO: make it a real parser => make it more flexible
        // creates a object out of the change change class
        changes.add(Change(
            // lessonNumberInt
            lessonNumberInt,
            // classIdentifier
            entry.querySelectorAll('td')[0].text.trim(),
            // lessonNumber
            entry.querySelectorAll('td')[1].text.trim(),
            // timeOfDay
            entry.querySelectorAll('td')[2].text.trim(),
            // subject
            entry.querySelectorAll('td')[3].text.trim(),
            // room
            entry.querySelectorAll('td')[4].text.trim(),
            // (the) change (is also kind of a message)
            entry.querySelectorAll('td')[5].text.trim(),
            // mentor
            entry.querySelectorAll('td')[6].text.trim(),
            // message
            entry.querySelectorAll('td')[7].text.trim(),
            // date
            date));
      }

      // Sorting the results
      if (Settings.getValue<bool>("keysorttoggle", false)) {
        switch (Settings.getValue("keysortfor", 1)) {
          case 1:
            // sort classNumber
            changes
                .sort((a, b) => a.lessonNumberInt.compareTo(b.lessonNumberInt));
            break;
          case 2:
            // sort classNumber in reverse order
            changes
                .sort((a, b) => b.lessonNumberInt.compareTo(a.lessonNumberInt));
            break;
          case 3:
            // sort alphabetically
            changes
                .sort((a, b) => a.classIdentifier.compareTo(b.classIdentifier));
            break;
          case 4:
            // sort alphabetically in reverse order
            changes
                .sort((a, b) => b.classIdentifier.compareTo(a.classIdentifier));
            break;
        }
      }
    }

    //Filtering for Students Classes
    if(Settings.getValue<bool>("keyfiltertoggle", false)) {
      String searchTerm =
          Settings.getValue<String>("keyfilterklasse", "").toUpperCase();
      if (searchTerm.isNotEmpty && searchTerm != "") {
        changes.removeWhere(
            (e) => !e.classIdentifier.toUpperCase().contains(searchTerm));
      }
    }

    //Filtering for Teachers
    if(Settings.getValue<bool>("keyfilterteachertoggle", false)) {
      String searchTerm =
          Settings.getValue<String>("keyfilterteacher", "").toUpperCase();
      if (searchTerm.isNotEmpty && searchTerm != "") {
        changes
            .removeWhere((e) => !e.mentor.toUpperCase().contains(searchTerm));
      }
    }
    return changes;
  }
}