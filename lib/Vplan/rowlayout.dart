import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;
import 'package:khsplan/scraper/siteparser.dart';
import 'package:khsplan/scraper/change.dart';
import 'package:group_list_view/group_list_view.dart';
import '../themes.dart';

class RowLayout {
  Widget createRowLayout(AsyncSnapshot<List<html.Document>> snapshot, BuildContext context){
    return buildData(snapshot);
  }

  Widget buildData(AsyncSnapshot<List<html.Document>> snapshot) {
    List<List<Change>> days = [];
    //if(snapshot.data[0].body.text)
    for(int x = 0; x<snapshot.data!.length; x++) {
      days.add(SiteParser().getData(snapshot.data![x]));
    }
    days.removeWhere((element) => element.isEmpty||element==[]);

    return GroupListView(
      itemBuilder: (context, index) {
        return MyThemes().buildCard(days[index.section][index.index], context);
      },
      sectionsCount: days.length ,
      groupHeaderBuilder: (BuildContext context, int section) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Text(
                days[section].first.date,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)));
      },
      physics: const BouncingScrollPhysics(),
      countOfItemInSection: (int section) {
        return days[section].length;
      },
    );
  }

}