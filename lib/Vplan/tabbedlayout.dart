import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;
import 'package:khsplan/scraper/siteparser.dart';
import 'package:khsplan/scraper/tage.dart';
import 'package:khsplan/themes.dart';


class TabbedLayout{
  final SiteParser _getSiteData = SiteParser();
  Widget createTabbedLayout(AsyncSnapshot<List<html.Document>> snapshot, BuildContext context){
    return DefaultTabController(length: snapshot.data!.length,
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
          children:
          tabMaker(snapshot),
          physics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }

  List<Widget> tabBarMaker(AsyncSnapshot<List<html.Document>> snapshot) {
    List<Tab> tabs = [];
    for(int x = 0; x<snapshot.data!.length; x++) {
      tabs.add(Tab(text: snapshot.data![x].querySelector('h1.list-table-caption')!.text
          .toString()));
    }
    return tabs;
  }

  //Create Tabs with contetnt for each site
  List<Widget> tabMaker(AsyncSnapshot<List<html.Document>> snapshot) {
    List<Widget> tabwidgets = [];
    for(int x = 0; x<snapshot.data!.length; x++) {
      tabwidgets.add(_buildDay(snapshot.data![x]));
    }
    return tabwidgets;
  }

  //Widget to create Tabs of each day and their contents

  //Get Contents of a day
  Widget _buildDay(html.Document site) {
    List<Tage> days = _getSiteData.getData(site);
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

}