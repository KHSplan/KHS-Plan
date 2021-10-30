package com.example.khsplan.settings;


import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;

import com.example.khsplan.R;


public class Settings extends AppCompatActivity {

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.settings_activity);
        if (savedInstanceState == null) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.settingsfragment, new SettingsFragment())
                    .commit();

        }
    }


}


