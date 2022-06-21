//TODO: When multiple functions create a container for each function (e.g: V-plan, timetable.dart.dart...)

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../main.dart';




class MyOldSettings extends StatefulWidget{

  //static const keydarkmode = "keydarkmode";
  static const rowOrTabbed = "rowOrTabbed";
  static const sortfor = "sortfor";
  static const sorttoggle = "sorttoggle";
  static const togglefilter = "togglefilter";
  static const classFilter = "classFilter";
  static const toggleMentorFilter = "toggleMentorFilter";
  static const mentorFilter = "mentorFilter";
  static const stayloggedin = "stayloggedin";


  const MyOldSettings({Key? key}) : super(key: key);

  @override
  _MyOldSettingsState createState() => _MyOldSettingsState();

}

class _MyOldSettingsState extends State<MyOldSettings>{

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Einstellungen"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _appearance(),
          _sortSetting(),
          _filtertoggle(),
          _filterteachertoggle(),
          _stayloggedin(),
        ],
      ),
    );
  }

  Widget _appearance() {
    return SettingsGroup(
        title: "Ändere aussehen",
        children: [
          _rowortabbed(),
          //_darkmodesettings()
        ]);
  }

  Widget _rowortabbed() {
    return DropDownSettingsTile(
        title: "Wähle darstellungs Modus aus",
        settingKey: "rowOrTabbed",
        selected: true,
        values: const <bool, String>{
          true: "Tabs",
          false: "Liste"
        });

  }

  /*
  Widget _darkmodesettings() {
    return SwitchSettingsTile(
      title: "Dunkler Modus",
      subtitle: "Aktiviert/Deaktiviert Dunklen Modus",
      settingKey: "keydarkmode",
      /*onChange: (keydarkmode){
          MyHomePageState().thememode();
      },

       */
      //defaultValue: getThemeMode(),
    );
  }
   */



  Widget _sortSetting(){
    return SettingsGroup(
      title: "Sortieren und Filtern",
      children: [
        SwitchSettingsTile(
          title: "Sortieren Aktivieren",
          settingKey: "sorttoggle",
          childrenIfEnabled: [
            DropDownSettingsTile(
                title: "Sortiere Nach",
                settingKey: "sortfor",
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
          '\nDie Klasse(n) einfach eingeben.'
          '\nBei mehreren mit einem freizeichen (" ") trennen',
      settingKey: "togglefilter",
      childrenIfEnabled: [
        _filterklasse()
      ],
    );
  }

  Widget _filterklasse(){
    return TextInputSettingsTile(
        title: "Klassen Filter",
        settingKey: "classFilter");
  }
  Widget _filterteachertoggle() {
    return SwitchSettingsTile(
      title: "Filtern nach Lehrer ",
      subtitle: 'Aktiviert/Deaktiviert Filtern.'
          '\nBitte den kürzel des Lehrer oder der Lehrerin ein:'
          '\nEntweder: "NAM" oder "NAM XYZ" ohne Klammern.',
      settingKey: "toggleMentorFilter",
      childrenIfEnabled: [
        _filterteacher()
      ],
    );
  }

  Widget _filterteacher(){
    return TextInputSettingsTile(
        title: "Lehrer Filter",
        settingKey: "mentorFilter");
  }

  Widget _stayloggedin(){
    return SwitchSettingsTile(
        title: "Bleibe Eingeloggt",
        defaultValue: true,
        enabled: true,
        subtitle: "Nach beenden der App Passwort nicht wieder eingeben",
        settingKey: "stayloggedin");
  }

  getThemeMode() {
    if(ThemeMode.system == ThemeMode.dark){
      return true;
    }
    return false;
  }


}