import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:khsplan/scraper/change.dart';
import 'package:hive_flutter/hive_flutter.dart';


class SiteParser {

  final settingsBox = Hive.box('settings');

  List<List<Change>> getData(List<Document> site) {
    List<Document> seite = site;
    List<List<Change>> days = [];
    for (var docs in seite) {
      List<Change> changes = [];
      final String date =
      docs.querySelector('h1.list-table-caption')!.text.toString();
      if (kDebugMode) {
        print(date);
      }
      //gets Table
      final table = docs.querySelector('table.list-table');
      //gets specifc data
      final tabledata = table!.querySelectorAll('tr');
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
              // (the) change (is also kind of a message)
              entry.querySelectorAll('td')[4].text.trim(),
              // mentor
              entry.querySelectorAll('td')[5].text.trim(),
              // room
              entry.querySelectorAll('td')[6].text.trim(),
              // message
              entry.querySelectorAll('td')[7].text.trim(),
              // date
              date));
        }
        days.add(changes);
      }

      // Sorting the results
      if (settingsBox.get("sorttoggle", defaultValue: false)) {
        for(var day in days) {
          switch (settingsBox.get("sortfor", defaultValue: 1)) {
            case 1:
            // sort classNumber
              day
                  .sort((a, b) => a.lessonNumberInt.compareTo(b.lessonNumberInt));
              break;
            case 2:
            // sort classNumber in reverse order
              day
                  .sort((a, b) => b.lessonNumberInt.compareTo(a.lessonNumberInt));
              break;
            case 3:
            // sort alphabetically
              day
                  .sort((a, b) => a.classIdentifier.compareTo(b.classIdentifier));
              break;
            case 4:
            // sort alphabetically in reverse order
              day
                  .sort((a, b) => b.classIdentifier.compareTo(a.classIdentifier));
              break;
          }
        }
      }
    }

    //Filtering for Students Classes
    for(var day in days){
      if(settingsBox.get("togglefilter", defaultValue: true)) {
        if (settingsBox.get("classFilter ", defaultValue: "")
            .toUpperCase()
            .isNotEmpty &&
            settingsBox.get("classFilter ", defaultValue: "").toUpperCase() !=
                "") {
          List<String> searchTerms =
          settingsBox.get("classFilter ", defaultValue: "")
              .toUpperCase()
              .split(" ");
          day =
              getEntriesWith(day, searchTerms, true); //FIXME: in new version
        }
      }
    }

    //Filtering for Teachers
    for(var day in days) {
      if (settingsBox.get("toggleMentorFilter", defaultValue: false)) {
        if (settingsBox.get("mentorFilter", defaultValue: "")
            .toUpperCase()
            .isNotEmpty &&
            settingsBox.get("mentorFilter", defaultValue: "").toUpperCase() !=
                "") {
          List<String> searchTerms =
          settingsBox.get("mentorFilter", defaultValue: "")
              .toUpperCase()
              .split(" ");
          day = getEntriesWith(day, searchTerms, false);
        }
      }
    }
    return days;
  }

  List<Change> getEntriesWith(
      List<Change> changes, List<String> searchTerms, bool isForClass) {
    List<Change> re = [];
    for (Change value in changes) {
      for (String searchTerm in searchTerms) {
        if (isForClass) {
          if (value.classIdentifier.toUpperCase().contains(searchTerm)) {
            re.add(value);
          }
        } else {
          if (value.mentor.toUpperCase().contains(searchTerm)) re.add(value);
        }
      }
    }
    return re.toSet().toList();
  }
}