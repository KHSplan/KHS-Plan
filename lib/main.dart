/*
TODO:
- Settings: about
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:html/dom.dart' as dom;
import 'package:khsplan/Vplan/rowlayout.dart';
import 'package:khsplan/scraper/change.dart';
import 'package:khsplan/scraper/getURLs.dart';
import 'package:khsplan/scraper/getwebsites.dart';
import 'package:khsplan/Vplan/tabbedlayout.dart';
import 'package:khsplan/scraper/siteparser.dart';
import 'package:khsplan/settings/oldsettings.dart';
import 'package:khsplan/settings/settings.dart';
//import 'package:khsplan/settings/settings.dart';
import 'package:khsplan/themes.dart';
//import 'package:khsplan/timetable/timetable.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'login.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final settingsBox = Hive.box('settings');

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KHS Plan',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: startup(context)
    );
  }

  startup(BuildContext context) {
    if (settingsBox.get("isLoggedIn", defaultValue: false)) {
      if (settingsBox.get("stayloggedin", defaultValue: true)
          &&settingsBox.get("isLoggedIn", defaultValue: false)){
        return const MyHomePage();
      }
      else {
        return const Login();
      }
    }
    return const Login();
  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();

}

class MyHomePageState extends State<MyHomePage>  {
  //inal GetWebsites _getWebsites = GetWebsites();

  late Future<List<dom.Document>> URLlist;
  late List<List<Change>> DocList;

  @override
  void initState() {
    URLlist = getURLs().getUrls();
    DocList = SiteParser().getData(URLlist) as List<List<Change>>; //List<Change>
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
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
              onPressed: () async {
                const url = "https://www.karl-heine-schule-leipzig.de/Vertretung/";
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              icon: const Icon(Icons.open_in_browser),
            ),
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
      body: rowOrTabbedLayout(DocList),
      /*
      drawer: Drawer(
        child: drawerElements(),
      ),
       */
    );
  }


  //Get sites => Document, store them in a Document list
  /*
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
              if (kDebugMode) {
                print("Fehler:${snapshot.error}");
              }
              return Center(
                child: Text("Fehler beim Darstellen: ${snapshot.error}"),
              );
            }
            //create tabs
            return rowOrTabbedLayout(snapshot);
        }
      },
    );
  }
  
   */

  Widget rowOrTabbedLayout(List<List<Change>> snapshot) {
    final settingsBox = Hive.box('settings');
    if(settingsBox.get("rowOrTabbed", defaultValue: false)){
      return TabbedLayout().createTabbedLayout(snapshot, context);
    }else{
      return RowLayout().createRowLayout(snapshot, context);
    }
  }

  Future<void> refresh() async {
    setState((){

    });
    //print("Do something!!");
  }
/*
  thememode() {
    print("IM DOING IT WRONG");
    if(Settings.getValue<bool>("keydarkmode", true)){
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

 */
}