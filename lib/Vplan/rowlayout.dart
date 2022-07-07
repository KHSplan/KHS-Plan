import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;
import 'package:khsplan/scraper/siteparser.dart';
import 'package:khsplan/scraper/change.dart';
import 'package:group_list_view/group_list_view.dart';
import '../themes.dart';

class RowLayout {
  Widget createRowLayout(AsyncSnapshot<List<List<Change>>> snapshot, BuildContext context){

    return buildData(snapshot);
  }

  Widget buildData(AsyncSnapshot<List<List<Change>>> snap) {
    //if(snapshot.data[0].body.text)
    List<List<Change>> snapshot = [];
    //if(snapshot.data[0].body.text)
    for(int x = 0; x<snap.data!.length; x++) {
      snapshot.add(snap.data![x]);
    }
    snapshot.removeWhere((element) => element.isEmpty||element==[]);
    for(var snaps in snapshot) {
      for(var s in snaps) {
        print(s.date);
      }
    }

    return GroupListView(
      itemBuilder: (context, index) {
        return MyThemes().buildCard(snapshot[index.section][index.index], context);
      },
      sectionsCount: snapshot.length ,
      groupHeaderBuilder: (BuildContext context, int section) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Text(
                snapshot[section].first.date,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)));
      },
      physics: const BouncingScrollPhysics(),
      countOfItemInSection: (int section) {
        return snapshot[section].length;
      },
    );
  }

}