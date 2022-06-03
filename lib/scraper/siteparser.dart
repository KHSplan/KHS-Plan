import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:html/dom.dart';
import 'package:khsplan/scraper/change.dart';


class SiteParser {

  List<Change> getData(Document site) {
    List<Change> changes = [];
    final String date = site.querySelector('h1.list-table-caption')!.text
        .toString();
    //gets Table
    final table = site.querySelector('table.list-table');
    //gets specifc data
    final tabledata = table!.querySelectorAll('tr');

    //Outprint -> Later parsing

    int stunde = 0;
    for(int x = 1; x<tabledata.length;x++) {
      String cach = tabledata[x].querySelectorAll('td')[1].text.trim().toString();
      String test;
      if(cach.contains(".")){
        test = cach.replaceAll(".","");
        if(test.isNotEmpty&&test != ""){
          stunde = int.parse(test);
        }
      }

      // TODO: make it a real parser => make it more flexible
      changes.add(Change(stunde,
          tabledata[x].querySelectorAll('td')[0].text.trim(), //Klasse
          tabledata[x].querySelectorAll('td')[1].text.trim(), //Lesson of Day
          tabledata[x].querySelectorAll('td')[2].text.trim(), //Time of Day
          tabledata[x].querySelectorAll('td')[3].text.trim(), //Fach/Kurs
          tabledata[x].querySelectorAll('td')[4].text.trim(), //Lehrer
          tabledata[x].querySelectorAll('td')[5].text.trim(), //Art
          tabledata[x].querySelectorAll('td')[6].text.trim(), //Raum
          tabledata[x].querySelectorAll('td')[7].text.trim(), //Mitteilung
          date));
    }
    //Sorting
    if(Settings.getValue<bool>("keysorttoggle", false)){
      switch(Settings.getValue("keysortfor", 1)){
        case 1:
          changes.sort((a,b) => a.inthour.compareTo(b.inthour));

          break;
        case 2:
          changes.sort((a,b) => b.inthour.compareTo(a.inthour));
          break;
        case 3:
          changes.sort((a,b) => a.classIdentifier.compareTo(b.classIdentifier));
          break;
        case 4:
          changes.sort((a,b) => b.classIdentifier.compareTo(a.classIdentifier));
          break;
      }
    }

    //Filtering for Students Classes
    String nachs = "NACHSCHREIBEN";
    if(Settings.getValue<bool>("keyfiltertoggle", false)) {
      String words = Settings.getValue<String>("keyfilterklasse", "").toUpperCase();
      if(words.isNotEmpty&&words!=""){
        words = '$words $nachs';
        //changes.removeWhere((e) => !e.klasse.toUpperCase().contains(words));
        changes.removeWhere((e) => !words.contains(e.classIdentifier.toUpperCase()));
      }
    }


    //Filtering for Teachers
    if(Settings.getValue<bool>("keyfilterteachertoggle", false)){
      String words = Settings.getValue<String>("keyfilterteacher", "").toUpperCase();

      if(words.isNotEmpty&&words!=""){
        //changes.removeWhere((e) => !words.contains(checkspechar(e)));
        changes.removeWhere((e) => checkspechar(e, words) == true);
      }
    }
    return changes;
  }

  //checks for special characters because the method "contains" cant check e.g "+TES (SET)" for "TES"
  //It needs to be splitted and than compared.
  checkspechar(Change e, String words) {
    String regex = r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+';
    if(e.mentor.contains(" ")){
      String chach = e.mentor;
      List<String> chachlist = chach.replaceAll(RegExp(regex, unicode: true),'').split(" ");
      for(var e in chachlist){
        if(words.contains(e)){
          return false;
        }
        else{
          return true;
        }
      }
    }
    else if(e.mentor.contains("(")){
      String chach = e.mentor;
      chach = chach.replaceAll(RegExp(regex, unicode: true), "");
      if(words.contains(chach)){
        return false;
      }
      else{
        return true;
      }
    }
    else {
      if (words.contains(e.mentor)) {
        return false;
      }
      else{
        return true;
      }
    }
  }
}