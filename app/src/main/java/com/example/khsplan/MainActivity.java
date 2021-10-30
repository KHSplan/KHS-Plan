/*
TODO:
Refresh on swipe

Notifications

 */
package com.example.khsplan;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;
import androidx.viewpager2.widget.ViewPager2;

import com.example.khsplan.dayfragments.FragmentAdapter;
import com.example.khsplan.settings.Settings;
import com.google.android.material.tabs.TabLayout;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {
    public TabLayout tabLayout;
    ViewPager2 pager2;
    FragmentAdapter fragmentAdapter;
    public ArrayList<wochentagename> wochentag = new ArrayList<>();

    //Init Menu
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.pref_menu, menu);
        return true;
    }
    //When Menu is Clicked Launch Menu activity
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.settingsmenu:
                startActivity(new Intent(this, Settings.class));
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }

    }



    @SuppressLint("CutPasteId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //Declare Vars
        setContentView(R.layout.activity_main);
        tabLayout = findViewById(R.id.tab_layout);
        pager2 = findViewById(R.id.view_pager2);

        FragmentManager fm = getSupportFragmentManager();
        fragmentAdapter = new FragmentAdapter(fm, getLifecycle());
        pager2.setAdapter(fragmentAdapter);



        //create Tablayout
        new dayscraper(tabLayout, pager2, fragmentAdapter).execute();

        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                pager2.setCurrentItem(tab.getPosition());
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });

        pager2.registerOnPageChangeCallback(new ViewPager2.OnPageChangeCallback() {
            @Override
            public void onPageSelected(int position) {
                tabLayout.selectTab(tabLayout.getTabAt(position));
            }
        });

    }

    public class dayscraper extends AsyncTask<Void, Void, ArrayList<wochentagename>> {

        private final TabLayout tabLayout;
        private final ViewPager2 pager2;
        private final FragmentAdapter fragmentAdapter;

        public dayscraper(TabLayout tabLayout, ViewPager2 pager2, FragmentAdapter fragmentAdapter) {
            this.tabLayout = tabLayout;
            this.pager2 = pager2;
            this.fragmentAdapter = fragmentAdapter;
        }

        @Override
        protected ArrayList<wochentagename> doInBackground(Void... voids) {
            ArrayList<wochentagename> cach;
            cach = new ArrayList<>();
            for (byte x = 1; x < 6; x++) {
                try {
                    Document seite = Jsoup.connect("https://www.karl-heine-schule-leipzig.de/Vertretung/V_DC_00" + x + ".html").get();
                    cach.add(new wochentagename(seite.select("h1.list-table-caption").text()));
                } catch (Exception e) {
                    cach.add(new wochentagename("Nicht Verfügbar"));
                    e.printStackTrace();
                }
            }
            return cach;
        }

        @Override
        protected void onPostExecute(ArrayList<wochentagename> cach) {
            super.onPostExecute(cach);

            tabLayout.addTab(tabLayout.newTab().setText(cach.get(0).getWochentag()));
            tabLayout.addTab(tabLayout.newTab().setText(cach.get(1).getWochentag()));
            tabLayout.addTab(tabLayout.newTab().setText(cach.get(2).getWochentag()));
            tabLayout.addTab(tabLayout.newTab().setText(cach.get(3).getWochentag()));
            tabLayout.addTab(tabLayout.newTab().setText(cach.get(4).getWochentag()));
        }
    }


    private static class wochentagename {
        private String wochentag;
        public wochentagename(String wochentag) {
            this.wochentag = wochentag;
        }
        public String getWochentag() {
            return wochentag;
        }
    }
}