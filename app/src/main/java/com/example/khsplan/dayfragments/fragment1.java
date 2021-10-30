package com.example.khsplan.dayfragments;
import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Bundle;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.RecyclerView;

import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.example.khsplan.R;
import com.example.khsplan.Tage;
import com.example.khsplan.scraper;

import java.util.ArrayList;


public class fragment1 extends Fragment {
    final String url1 = "https://www.karl-heine-schule-leipzig.de/Vertretung/V_DC_001.html";
    public RecyclerView recyclerView;
    public ArrayList<Tage> erstertag = new ArrayList<>();
    Context context;
    public ProgressBar progressbar;
    @SuppressLint("StaticFieldLeak")
    public static scraper scrap;



    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view;
        view = inflater.inflate(R.layout.fragment1_layout, container, false);
        recyclerView = view.findViewById(R.id.recView1);
        context = view.getContext();
        progressbar = view.findViewById(R.id.progressbar1);
        scrap = new scraper(url1, erstertag, recyclerView, context, progressbar);
        scrap.execute();
        return view;

    }


}