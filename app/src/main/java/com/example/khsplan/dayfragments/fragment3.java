package com.example.khsplan.dayfragments;
import android.content.Context;
import android.os.Bundle;

import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.RecyclerView;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;

import com.example.khsplan.R;
import com.example.khsplan.Tage;
import com.example.khsplan.scraper;

import java.util.ArrayList;


public class fragment3 extends Fragment {
    final String url3 = "https://www.karl-heine-schule-leipzig.de/Vertretung/V_DC_003.html";
    public RecyclerView recyclerView;
    public ArrayList<Tage> drittertag = new ArrayList<>();
    Context context;
    public ProgressBar progressbar;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view;
        view = inflater.inflate(R.layout.fragment3_layout, container, false);
        recyclerView = view.findViewById(R.id.recView3);
        context = view.getContext();
        progressbar = view.findViewById(R.id.progressbar3);
        new scraper(url3, drittertag, recyclerView, context, progressbar).execute();
        return view;
    }

}