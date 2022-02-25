/*
TODO:
- Settings: about
 */
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:html/dom.dart' as html;
import 'package:khsplan/Vplan/rowlayout.dart';
import 'package:khsplan/scraper/getwebsites.dart';
import 'package:khsplan/Vplan/tabbedlayout.dart';
import 'package:khsplan/scraper/settings.dart';
import 'package:khsplan/themes.dart';
import 'package:khsplan/timetable/timetable.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'login.dart';

void main() async {
  await Settings.init(
      cacheProvider: SharePreferenceCache()
    //cacheProvider: _isUsingHive ? HiveCache() : SharePreferenceCache(),
  );
  runApp(const MyApp());
}


setloginbool() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("savelogin", true);
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KHS Plan',
      themeMode: MyHomePageState().thememode(),
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: FutureBuilder<bool>(
        future: checkbool(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return const MyHomePage();
            }else {
              return const Login();
            }
          }
          return const MyHomePage();
        }
      ),
    );
  }

  Future<bool> checkbool() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savelogin = prefs.getBool("savelogin") ?? false;
    return savelogin;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();

}

class MyHomePageState extends State<MyHomePage>  {
  final GetWebsites _getWebsites = GetWebsites();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: thememode(),
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: baseUI(),//getSites(),
    );
  }


  Widget baseUI() {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Vertretungsplan"),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MySettings()),
                );
              },
              icon: const Icon(Icons.settings),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                initState();
              },
            ),
          ]
      ),
      body: getSites(),

    );
  }



  //Get sites => Document, store them in a Document list
  Widget getSites() {
    return FutureBuilder<List<html.Document>>(
      //gets Dates of each date in other class and puts it in an List -> snapshot
      future: _getWebsites.getWebsite(),
      builder: (BuildContext context, AsyncSnapshot<List<html.Document>> snapshot) {
        //Cases for Connections
        switch(snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Center(
              //TODO: Make better loading screen
              child: RefreshProgressIndicator(),
            );
          case ConnectionState.none:
            return const Center(
              child: Text("Keine Verbindung"),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Center(
                child: Text('Fehler'),
              );
            }
            //create tabs
            return buildrefresh(snapshot);
        }
      },
    );
  }
  Widget buildrefresh(AsyncSnapshot<List<html.Document>> snapshot) {
    return RefreshIndicator(
      onRefresh: () {
        return refresh();
      },
      child: rowortabbedLayout(snapshot),
    );
  }

  Widget rowortabbedLayout(AsyncSnapshot<List<html.Document>> snapshot) {
    if(Settings.getValue<bool>("keyrowortabbed", true)){
      return TabbedLayout().createTabbedLayout(snapshot, context);
    }else{
      return RowLayout().createRowLayout(snapshot, context);
    }
  }

  Future<void> refresh() async {
    setState((){});
    print("Do something!");
  }
  Future<void> setstaterefresh() async {
    setState((){});
    print("Do something!");
  }

  thememode() {
    if(Settings.getValue<bool>("keydarkmode", true)){
      return ThemeMode.dark;
    }else{
      return ThemeMode.light;
    }
  }
}





