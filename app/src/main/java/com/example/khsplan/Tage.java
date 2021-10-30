package com.example.khsplan;

public class Tage {
    private int id;
    private String klasse, stunde, zeit, fach, art, leher, raum, mitteilung;

    public Tage(int id, String klasse, String stunde, String zeit, String fach, String art, String leher, String raum, String mitteilung) {
        this.id = id;
        this.klasse = klasse;
        this.stunde = stunde;
        this.zeit = zeit;
        this.fach = fach;
        this.art = art;
        this.leher = leher;
        this.raum = raum;
        this.mitteilung = mitteilung;
    }
    public int getID() {
        return id;
    }

    public String getKlasse() {
        return klasse;
    }

    public String getStunde() {
        return stunde;
    }

    public String getZeit() {
        return zeit;
    }

    public String getFach() {
        return fach;
    }

    public String getArt() {
        return art;
    }

    public String getLeher() {
        return leher;
    }

    public String getRaum() {
        return raum;
    }

    public String getMitteilung() {
        return mitteilung;
    }

    public void setKlasse(String klasse) {
        this.klasse = klasse;
    }
}
