import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:html/dom.dart';
import 'package:khsplan/scraper/tage.dart';


class SiteParser {
  List<Tage> getData(Document site) {
    List<Tage> tag = [];
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

      tag.add(Tage(stunde,
          tabledata[x].querySelectorAll('td')[0].text.trim(), //Klasse
          tabledata[x].querySelectorAll('td')[1].text.trim(), //Dstd.
          tabledata[x].querySelectorAll('td')[2].text.trim(), //Zeit
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
          tag.sort((a,b) => a.inthour.compareTo(b.inthour));

          break;
        case 2:
          tag.sort((a,b) => b.inthour.compareTo(a.inthour));
          break;
          case 3:
          tag.sort((a,b) => a.klasse.compareTo(b.klasse));
          break;
        case 4:
          tag.sort((a,b) => b.klasse.compareTo(a.klasse));
          break;
      }
    }

    //Filtering for Students Classes
    String nachs = "NACHSCHREIBEN";
    if(Settings.getValue<bool>("keyfiltertoggle", false)) {
      String words = Settings.getValue<String>("keyfilterklasse", "").toUpperCase();
      if(words.isNotEmpty&&words!=""){
        words = '$words $nachs';
        //tag.removeWhere((e) => !e.klasse.toUpperCase().contains(words));
        tag.removeWhere((e) => !words.contains(e.klasse.toUpperCase()));
        }
      }


    //Filtering for Teachers
    if(Settings.getValue<bool>("keyfilterteachertoggle", false)){
      String words = Settings.getValue<String>("keyfilterteacher", "").toUpperCase();

      if(words.isNotEmpty&&words!=""){
        //tag.removeWhere((e) => !words.contains(checkspechar(e)));
        tag.removeWhere((e) => checkspechar(e, words) == true);
      }
    }
    return tag;
  }

  //checks for special characters because the method "contains" cant check e.g "+TES (SET)" for "TES"
  //It needs to be splitted and than compared
  checkspechar(Tage e, String words) {
    String regex = r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+';
    if(e.lehrer.contains(" ")){
      String chach = e.lehrer;
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
    else if(e.lehrer.contains("(")){
      String chach = e.lehrer;
      chach = chach.replaceAll(RegExp(regex, unicode: true), "");
      if(words.contains(chach)){
        return false;
      }
      else{
        return true;
      }
    }
    else {
      if (words.contains(e.lehrer)) {
        return false;
      }
      else{
        return true;
      }
    }
  }
}