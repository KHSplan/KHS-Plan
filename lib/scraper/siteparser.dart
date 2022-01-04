import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:html/dom.dart';
import 'package:khsplan/scraper/tage.dart';


class SiteParser {
  List<Tage> getData(Document site) {
    List<Tage> tag = [];
    List<Tage> cach = [];
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
          tabledata[x].querySelectorAll('td')[0].text.trim(),
          tabledata[x].querySelectorAll('td')[1].text.trim(),
          tabledata[x].querySelectorAll('td')[2].text.trim(),
          tabledata[x].querySelectorAll('td')[3].text.trim(),
          tabledata[x].querySelectorAll('td')[4].text.trim(),
          tabledata[x].querySelectorAll('td')[5].text.trim(),
          tabledata[x].querySelectorAll('td')[6].text.trim(),
          tabledata[x].querySelectorAll('td')[7].text.trim(),
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

    //Filtering for Klasse
    if(Settings.getValue<bool>("keyfiltertoggle", false)){
      String words = Settings.getValue<String>("keyfilterklasse", "").toUpperCase();
      if(words.isNotEmpty&&words!=""){
        if(words.contains(",")){
          List<String> filter = words.split(",");
          for(int x=0;x<tag.length; x++) {
            for (var element in filter) {
              if(element==tag[x].klasse.toUpperCase()){
                cach.add(tag[x]);
              }
            }
          }
          return cach;
        }else{
            tag.removeWhere((element) => !element.klasse.contains(words));
        }
      }
    }

    //Filtering for Teacher
    if(Settings.getValue<bool>("keyfilterteachertoggle", false)){
      String words = Settings.getValue<String>("keyfilterteacher", "").toUpperCase();
      if(words.isNotEmpty&&words!=""){
        if(words.contains(",")){
          List<String> filter = words.split(",");
          for(int x=0;x<tag.length; x++) {
            for(var e in filter) {
              if(e.contains(tag[x].lehrer.toUpperCase())){
                cach.add(tag[x]);
              }
            }
          }
          return cach;
        }else{
          tag.removeWhere((element) => !element.lehrer.contains(words));
        }
      }
    }
    return tag;
  }
}

