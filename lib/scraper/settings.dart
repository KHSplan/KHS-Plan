//TODO: When multiple functions create a container for each function (e.g: V-plan, timetable.dart.dart...)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../main.dart';

class MySettings extends StatefulWidget{
  static const keydarkmode = "keydarkmode";
  static const keyrowortabbed = "keyrowortabbed";
  static const keysortfor = "keysortfor";
  static const keysorttoggle = "keysorttoggle";
  static const keyfiltertoggle = "keyfiltertoggle";
  static const keyfilterklasse = "keyfilterklasse";
  static const keyfilterteachertoggle = "keyfilterteachertoggle";
  static const keyfilterteacher = "keyfilterteacher";


  const MySettings({Key? key}) : super(key: key);

  @override
  _MySettingsState createState() => _MySettingsState();

}

class _MySettingsState extends State<MySettings>{

  @override
Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Einstellungen"),
        ),
        //body: _einstellungen(),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _appearance(),
          _sortSetting(),
          _filtertoggle(),
          _filterteachertoggle(),
        ],
      ),
    );
  }

  Widget _appearance() {
    return SettingsGroup(
        title: "Ändere aussehen",
        children: [
          _rowortabbed(),
          _darkmodesettings()
        ]);
  }

  Widget _rowortabbed() {
    return DropDownSettingsTile(
        title: "Wähle darstellungs Modus aus",
        settingKey: "keyrowortabbed",
        selected: true,
        values: const <bool, String>{
          true: "Tabs",
          false: "Liste"
        });

  }

  Widget _darkmodesettings() {
    return SwitchSettingsTile(
      title: "Dunkler Modus",
      subtitle: "Aktiviert/Deaktiviert Dunklen Modus",
      settingKey: "keydarkmode",
      onChange: (keydarkmode){
          MyHomePageState().thememode();
      },
    );
  }



  Widget _sortSetting(){
    return SettingsGroup(
        title: "Sortieren und Filtern",
        children: [
          SwitchSettingsTile(
              title: "Sortieren Aktivieren",
              settingKey: "keysorttoggle",
            childrenIfEnabled: [
              DropDownSettingsTile(
                  title: "Sortiere Nach",
                  settingKey: "keysortfor",
                  selected: 1,
                  values: const <int, String>{
                    1: "Stunde",
                    2: "Stunde umgekehrt",
                    3: "Alphabetisch",
                    4: "Alphabetisch umgekehrt",
                  })
            ],
          )
        ],
    );
  }

  Widget _filtertoggle() {
    return SwitchSettingsTile(
      title: "Filtern nach ",
      subtitle: 'Aktiviert/Deaktiviert Filtern.'
          '\nBitte gebe die Klassen wie folgt ein:'
          '\nEntweder: "BGy18" oder "BGy18,EGy18". Achte auf Groß und Kleinschreibung'
          ' sowie dass du die Klassen mit einem Komma Trennst!',
      settingKey: "keyfiltertoggle",
      childrenIfEnabled: [

        _filterklasse()
      ],
    );
  }

  Widget _filterklasse(){
    return TextInputSettingsTile(
        title: "Klassen Filter",
        settingKey: "keyfilterklasse");
  }
  Widget _filterteachertoggle() {
    return SwitchSettingsTile(
      title: "Filtern nach Lehrer ",
      subtitle: 'Aktiviert/Deaktiviert Filtern.'
          '\nBitte den kürzel des Lehrer oder der Lehrerin ein:'
          '\nEntweder: "NAM" oder "NAM,XYZ" ohne Klammern.',
      settingKey: "keyfilterteachertoggle",
      childrenIfEnabled: [

        _filterteacher()
      ],
    );
  }

  Widget _filterteacher(){
    return TextInputSettingsTile(
        title: "Lehrer Filter",
        settingKey: "keyfilterteacher");
  }


}