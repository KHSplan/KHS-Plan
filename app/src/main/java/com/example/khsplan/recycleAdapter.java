package com.example.khsplan;

import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;


public class recycleAdapter extends RecyclerView.Adapter<recycleAdapter.MyViewHolder> {
    private ArrayList<Tage> tag1;

    public recycleAdapter(ArrayList<Tage> tag1) {
        this.tag1 = tag1;
    }

    public static class MyViewHolder extends RecyclerView.ViewHolder{
        private TextView klasseName, lehrername, stundetxt, fachtxt, arttxt, raumtxt, mitteilungtxt;

        public MyViewHolder(final View view) {
            super(view);
            klasseName = view.findViewById(R.id.klasse);
            lehrername = view.findViewById(R.id.lehrer);
            stundetxt = view.findViewById(R.id.stunde);
            fachtxt = view.findViewById(R.id.Fach);
            arttxt = view.findViewById(R.id.art);
            raumtxt = view.findViewById(R.id.raum);
            mitteilungtxt = view.findViewById(R.id.mitteilung);
        }
    }

    @NonNull
    @Override
    public recycleAdapter.MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_layout, parent, false);
        return new MyViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull recycleAdapter.MyViewHolder holder, int position) {
        String klasse = tag1.get(position).getKlasse();
        holder.klasseName.setText(klasse);
        String lehrer = tag1.get(position).getLeher();
        holder.lehrername.setText(lehrer);
        String stunde = tag1.get(position).getStunde();
        holder.stundetxt.setText(stunde);
        String fach = tag1.get(position).getFach();
        holder.fachtxt.setText(fach);
        String art = tag1.get(position).getArt();
        holder.arttxt.setText(art);
        String raum = tag1.get(position).getRaum();
        holder.raumtxt.setText(raum);
        String mitteilung = tag1.get(position).getMitteilung();
        holder.mitteilungtxt.setText(mitteilung);


        //CardView Colors
        CardView cardview;
        cardview = holder.itemView.findViewById(R.id.cardview);

        if(tag1.get(position).getArt().contains("entfällt")){
            cardview.setCardBackgroundColor(Color.parseColor("#ff7961"));
        }
        else if(tag1.get(position).getArt().contains("verschoben")){
            cardview.setCardBackgroundColor(Color.parseColor("#757de8"));
        }
        else if(tag1.get(position).getArt().contains("Vertreten")){
            cardview.setCardBackgroundColor(Color.parseColor("#ffc947"));
        }
        else if(tag1.get(position).getArt().contains("Raumänderung")){
            cardview.setCardBackgroundColor(Color.parseColor("#60ad5e"));
        }
        else if(tag1.get(position).getArt().contains("Vertretung")){
            cardview.setCardBackgroundColor(Color.parseColor("#80d6ff"));
        }
        else if(tag1.get(position).getArt().contains("Aufgabenstellung")){
            cardview.setCardBackgroundColor(Color.parseColor("#718792"));
        }else{
            cardview.setCardBackgroundColor(Color.parseColor("#63ccff"));
        }
    }

    @Override
    public int getItemCount() {
        return tag1.size();
    }
}
