package com.example.khsplan.settings;


import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.preference.CheckBoxPreference;
import androidx.preference.EditTextPreference;
import androidx.preference.ListPreference;
import androidx.preference.Preference;
import androidx.preference.PreferenceFragmentCompat;
import androidx.preference.SwitchPreferenceCompat;

import com.example.khsplan.R;

import java.util.Arrays;

public class SettingsFragment extends PreferenceFragmentCompat {
    public static int sortSettings;
    public static String[] searchforklasse;
    public static boolean searchKlasse;

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.settings);
        load_dark_setting();
        load_sort_setting();
        filter_settings();
        filter_for_klasse();
    }
    private void load_sort_setting() {
        SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(getContext());
        //int a = Integer.parseInt(sp.getString("sorting", "false"));
        //System.out.println(a);
        //scraper.sortSettings = a;
        ListPreference lp = (ListPreference) findPreference("sorting");
        assert lp != null;
       lp.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {
           @Override
           public boolean onPreferenceChange(Preference preference, Object newValue) {
               String items = (String)newValue;
               if (preference.getKey().equals("sorting"))
                   switch (items) {
                       case "0":
                           sortSettings = 0;
                           break;
                       case "Nicht Sortiert":
                           sortSettings = 0;
                           break;
                       case "1":
                           sortSettings = 1;
                           break;
                       case "Stunde":
                           sortSettings = 1;
                           break;
                       case "2":
                           sortSettings = 2;
                           break;
                       case "Stunde Umgekehrt":
                           sortSettings = 2;
                           break;
                       case "3":
                           sortSettings = 3;
                           break;
                       case "Klass Alphabetisch":
                           sortSettings = 3;
                           break;
                       case "4":
                           sortSettings = 4;
                       case "Klasse Alphbetisch umgekehrt":
                           sortSettings = 4;
                           break;
                       default:
                           sortSettings = 1;
                   }
                System.out.println(items);
               return true;
           }
       });

    }
    private void load_dark_setting() {
        CheckBoxPreference sp = (CheckBoxPreference) findPreference("nightmode");
        assert sp != null;
        sp.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {
            @Override
            public boolean onPreferenceChange(Preference preference, Object newValue) {
                boolean yes = (boolean) newValue;
                if(yes){
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
                }
                else{
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
                }
                return true;
            }
        });
    }

    private void filter_settings(){
        SwitchPreferenceCompat spc = (SwitchPreferenceCompat) findPreference("FILTERBOOL");
        assert spc!=null;
        spc.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {
            @Override
            public boolean onPreferenceChange(Preference preference, Object newValue) {
                searchKlasse = (boolean) newValue;
                System.out.println(searchKlasse);
                return true;
            }
        });
    }

    private void filter_for_klasse(){
        EditTextPreference etp = (EditTextPreference) findPreference("FILTERSTRING");
        assert etp!=null;
        etp.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {
            @Override
            public boolean onPreferenceChange(Preference preference, Object newValue) {
                String klasse =(String) newValue;
                if(klasse.equals("")){
                    searchKlasse = false;
                }
                if(klasse.contains("'")){
                    klasse.replace("'","");
                }
                searchforklasse = klasse.split(",");
                return true;
            }
        });
    }



    @Override
    public void onResume() {
        load_dark_setting();
        load_sort_setting();
        filter_settings();
        filter_for_klasse();
        super.onResume();
    }

}