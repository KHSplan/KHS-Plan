import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;
import 'package:khsplan/scraper/siteparser.dart';
import 'package:khsplan/scraper/change.dart';
import 'package:khsplan/themes.dart';


class TabbedLayout{
  Widget createTabbedLayout(AsyncSnapshot<List<List<Change>>> snap, BuildContext context){
    List<List<Change>> snapshot = [];
    //if(snapshot.data[0].body.text)
    for(int x = 0; x<snap.data!.length; x++) {
      snapshot.add(snap.data![x]);
    }
    return DefaultTabController(length: snapshot.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            isScrollable: true,
            tabs:
            //Tab names
            tabBarMaker(snapshot),
          ),
        ),
        body:
        TabBarView(
          physics: const BouncingScrollPhysics(),
          children:
          tabMaker(snapshot),
        ),
      ),
    );
  }

  List<Widget> tabBarMaker(List<List<Change>> snapshot) {
    List<Tab> tabs = [];
    for(var x in snapshot) {
      tabs.add(Tab(text: x[0].date.toString()));
    }
    return tabs;
  }

  //Create Tabs with contetnt for each site
  List<Widget> tabMaker(List<List<Change>> allsnapshot) {
    List<Widget> tabwidgets = [];
    for(var snapshot in allsnapshot) {
      for(var snap in snapshot) {
        tabwidgets.add(_buildDay(snap));
      }
    }
    return tabwidgets;
  }

  //Widget to create Tabs of each day and their contents

  //Get Contents of a day
  Widget _buildDay(site) {
    List<Change> days = site;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(10),
      itemCount: days.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        //Build cards for each content
        return MyThemes().buildCard(days[index], context);
      },
    );
  }

  List<Widget> ifNull() {
    List<Widget> ifnull = [];
    for(int n = 0; n<3; n++){
      ifnull.add(const Text("nichts"));
    }
    return ifnull;
  }

}