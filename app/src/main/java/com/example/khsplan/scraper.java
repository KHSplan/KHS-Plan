package com.example.khsplan;


import android.content.Context;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.view.View;
import android.view.animation.AnimationUtils;
import android.widget.ProgressBar;

import androidx.preference.PreferenceManager;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;

import java.util.ArrayList;
import java.util.Arrays;


public class scraper extends AsyncTask<Void, Void, ArrayList<Tage>> {
    public final String url1;
    public static org.jsoup.nodes.Document site1 = null;
    public static ArrayList<Tage> tag;
    public final RecyclerView recyclerView;
    public final Context context;
    public static ProgressBar progressbar;
    public int sorting;
    public boolean filterbool;
    public String[] filter;


    public scraper(String url1, ArrayList<Tage> tag, RecyclerView recyclerView, Context context, ProgressBar progressbar) {
        this.url1 = url1;
        this.recyclerView = recyclerView;
        this.context = context;
        scraper.progressbar = progressbar;

    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        progressbar.setVisibility(View.VISIBLE);
        progressbar.startAnimation(AnimationUtils.loadAnimation(context, android.R.anim.fade_in));
    }

    int counter1;
    ArrayList<Tage> cach = new ArrayList<>();

    @Override
    protected ArrayList<Tage> doInBackground(Void... voids) {
        counter1 = counter(url1);
        if(counter1 == 0) {
            return null;
        }
        try {
            site1 = Jsoup.connect(url1).get();
            for (Element row : site1.select("table.list-table")) {
                for (int x = 0; x < counter1; x++) {
                    int y = x + 1;
                    //Convert Stunde to ID to sort it
                    String idTempString = row.select("tr:nth-of-type(" + y + ") > td:nth-of-type(2)").text();
                    int hour;
                    if (idTempString.equals("")) {
                        continue;
                    } else {
                        idTempString = idTempString.replace(".", "");
                        hour = Integer.parseInt(idTempString);
                    }
                    //Add items to ArrayList
                    cach.add(new Tage(hour,
                            row.select("tr:nth-of-type(" + y + ") > td:nth-of-type(1)").text(),
                            row.select("tr:nth-of-type(" + y + ") > td:nth-of-type(2)").text(),
                            row.select("tr:nth-of-type(" + y + ") > td:nth-of-type(3)").text(),
                            row.select("tr:nth-of-type(" + y + ") > td:nth-of-type(4)").text(),
                            row.select("tr:nth-of-type(" + y + ") > td:nth-of-type(5)").text(),
                            row.select("tr:nth-of-type(" + y + ") > td:nth-of-type(6)").text(),
                            row.select("tr:nth-of-type(" + y + ") > td:nth-of-type(7)").text(),
                            row.select("tr:nth-of-type(" + y + ") > td:nth-of-type(8)").text()));
                    //Filter
                    //sortSettings = Settings.load_setting();
                    load_filter_setting();
                    if(filterbool) {
                        for (byte i = 0; i < cach.size(); i++) {
                            if (!Arrays.asList(filter).contains(cach.get(i).getKlasse())) {
                                cach.remove(i);
                            }
                        }
                    }
                    System.out.println(sorting);
                    load_sort_setting();
                    System.out.println(sorting);
                    cach.sort((o1, o2) -> {
                        switch (sorting) {
                            //Sortiere Stunde (Niedrig->Hoch)
                            case 1:
                                return Integer.compare(o1.getID(), o2.getID());
                            //Sortiere Stunde (Hoch->Niedrig)
                            case 2:
                                return Integer.compare(o2.getID(), o1.getID());
                            //Sortiere Klasse Alphabetisch (a->z)
                            case 3:
                                return o1.getKlasse().compareTo(o2.getKlasse());
                            //Sortiere Klasse Alphabetisch entgegengesetzt (z->a)
                            case 4:
                                return o2.getKlasse().compareTo(o1.getKlasse());

                        }
                        //Im normalfall nicht Sortieren
                        return 0;
                    });
                    //cach.sort(Comparator.comparing(Tage::getID));

                }

            }


        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return cach;
    }


    @Override
    protected void onPostExecute(ArrayList<Tage> unused) {
        super.onPostExecute(unused);
        //System.out.println(unused.get(0).getKlasse());
        //tag.addAll(unused);
        if(unused == null){
            return;
        }
        setAdapter(unused);
        progressbar.startAnimation(AnimationUtils.loadAnimation(context, android.R.anim.fade_out));
        progressbar.setVisibility(View.GONE);
    }

    public static int counter(String url) {
        //Get hoe many Items/Rows are in the Table
        int counter1 = 1;
        try {
            site1 = Jsoup.connect(url).get();
            for (Element row : site1.select("table.list-table")) {
                boolean stoponend = true;
                while (stoponend) {
                    if (row.select("tr:nth-of-type(" + counter1 + ")").text().equals("")) {
                        stoponend = false;
                    } else {
                        counter1 = counter1 + 1;
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        //System.out.println(counter1);
        return counter1 - 1;
    }
    private void setAdapter(ArrayList<Tage> tag) {
        recycleAdapter adapter = new recycleAdapter(tag);
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(context.getApplicationContext());
        recyclerView.setLayoutManager(layoutManager);
        recyclerView.setItemAnimator(new DefaultItemAnimator());
        recyclerView.setAdapter(adapter);
    }
    private void load_sort_setting() {
        SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(context);
        String sortString = sp.getString("sorting","Nicht Sortieren");
        switch (sortString) {
            case "0":
            case "Nicht Sortiert":
                sorting = 0;
                break;
            case "1":
            case "Stunde":
                sorting = 1;
                break;
            case "2":
            case "Stunde Umgekehrt":
                sorting = 2;
                break;
            case "3":
            case "Klass Alphabetisch":
                sorting = 3;
                break;
            case "4":
            case "Klasse Alphbetisch umgekehrt":
                sorting = 4;
                break;
            default:
                sorting = 1;
        }
    }

    private void load_filter_setting() {
        SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(context);
        filterbool = sp.getBoolean("FILTERBOOL", false);
        String klassenFilter = sp.getString("FILTERSTRING", "");
        if(klassenFilter.equals("")){
            filterbool = false;
        }
        if(klassenFilter.contains("'")){
            klassenFilter.replace("'","");
        }
        filter = klassenFilter.split(",");
    }
}