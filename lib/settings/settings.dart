import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khsplan/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MySettings extends StatefulWidget {
  const MySettings({Key? key}) : super(key: key);

  @override
  MySettingsState createState() => MySettingsState();
}

class MySettingsState extends State<MySettings> {
  final settingsBox = Hive.box('settings');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Einstellungen"),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          uiSettings(), sortSettings(), filterSettings(), devSettings()
        ],
      )
    );
  }

  uiSettings() {
    bool _overwriteSysTheme = settingsBox.get("overwriteSysTheme", defaultValue: false);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Text("Aussehen")),
          SwitchListTile(
            title: const Text("Thema überschreiben"),
              value: _overwriteSysTheme,
              onChanged: (bool val) {
                if (kDebugMode) {
                  print("overwriteSysTheme: $val");
                }
                setState((){
                  _overwriteSysTheme = val;
                });
                settingsBox.put("overwriteSysTheme", val);})

        ],

      ),
    );
  }

  sortSettings() {
    return Card(
      child: Column(

      ),
    );
  }

  filterSettings() {
    return Card(
      child: Column(

      ),
    );
  }

  devSettings() {
    bool _stayloggedin = settingsBox.get("stayloggedin", defaultValue: true);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Text("Erweiterte Einstellungen")),
          SwitchListTile(
              title: const Text("Bleibe eingeloggt"),
              value: _stayloggedin,
              onChanged: (bool val) {
                if (kDebugMode) {
                  print("stayloggedin: $val");
                }
                setState((){
                  _stayloggedin = val;
                });
                settingsBox.put("stayloggedin", val);})
        ],

      ),
    );
  }

}