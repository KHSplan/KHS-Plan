import 'package:flutter/material.dart';
import 'package:khsplan/main.dart';
import 'package:khsplan/scraper/settings.dart';

class Timetable extends StatefulWidget{
  const Timetable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<Timetable> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
            actions: <Widget> [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MySettings()),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
            ],
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "Montag"),
                Tab(text: "Dienstag"),
                Tab(text: "Mittwoch"),
                Tab(text: "Donnerstag"),
                Tab(text: "Freitag"),
              ],
            ),
            title: const Text("Stundenplan")
        ),
        drawer: drawerElements(),
        body: const Text("Hii"),
      ),
    );
  }

  ListView drawerElements() {
    return ListView( children: [
      ListTile(
        title: const Text("Vertretungsplan"),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        },
      ),
      ListTile(
          title: const Text("Stundenplan"),
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Timetable()),
            );
          }
      ),
      const Divider(),

      ListTile(
        title: const Text("Einstellungen"),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MySettings()),
          );
        },
      ),
      const ListTile(
        title: Text("Impressum"),
      ),

    ],);
  }
}
