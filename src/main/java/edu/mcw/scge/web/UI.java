package edu.mcw.scge.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class UI {

    public static String correctInitiative(String initiative)  {
        if (initiative.equals("Rodent Testing Center")) {
            return "Animal Reporter and Testing Center Initiative";
        }else if (initiative.equals("Large Animal Reporter")) {
             return "Animal Reporter and Testing Center Initiative";
        }else if (initiative.equals("Large Animal Testing Center")) {
            return "Large Animal Testing Centers (LATC)";
        }else if (initiative.equals("Cell & Tissue Platform")) {
            return "Biological Effects Initiative";
        }else if (initiative.equals("In Vivo Cell Tracking")) {
            return "Biological Effects Initiative";
        }else if (initiative.equals("Delivery Vehicle Initiative")) {
            return "Delivery Systems Initiative";
        }else if (initiative.equals("New Editors Initiative")) {
            return "Genome Editors Initiative";
        }

        return initiative;

    }


    public static String formatFASTA(String str) {



        if (str == null) {
            return "";
        }

        if (str.length()< 79) {
            return str;
        }


        int start =0;
        int end = 79;

        int runs = str.length() / 80;


        String ret = "";
        for (int i=0; i<runs; i++)  {
            ret +=str.substring(start,end) + "\n";
            start +=80;
            end +=80;

        }
        if (str.length() > start) {
            ret += str.substring(start);
        }

        return ret;

    }

    public static String replacePhiSymbol(String namePre){

        if (namePre == null) {
            return "";
        }
        String namePost = "";
        for (int i =0; i< namePre.length(); i++) {

            char c = namePre.charAt(i);
            int code = (int) c;

            if (code == 934) {
                namePost += "&#x3D5;";
            }else {
                namePost += c;
            }
        }
        return namePost;

    }


    public static String formatDate(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        return sdf.format(date);

    }


    public static String getRGBValue(String scale, int currentValue, int maxValue) {

        if (maxValue < 1) {
            maxValue=1;
        }

        double value = ((double) currentValue/ (double) maxValue );   // first you should normalize to a number between 0 and 1

        //red scale
        int aR = 232;
        int aG = 228;
        int aB=213;  // rgb for our 1st color (blue in this case)
        int bR = 128;
        int bG = 0;
        int bB=0;    // rbg for our 2nd color (red in this case)

        if (scale.equals("blue")) {
            aR = 232;
            aG = 228;
            aB=213;  // rgb for our 1st color (blue in this case)
            bR = 0;
            bG = 128;
            bB=0;    // rbg for our 2nd color (red in this case)

        }else if (scale.equals("green")) {
            aR = 232;
            aG = 228;
            aB=213;  // rgb for our 1st color (blue in this case)
            bR = 0;
            bG = 0;
            bB=128;    // rbg for our 2nd color (red in this case)
        }


        double red = (bR - aR) * value + aR;      // evaluated as -255*value + 255
        double green = (bG - aG) * value + aG;      // evaluates as 0
        double blue  = (bB - aB) * value + aB;      // evaluates as 255*value + 0

        return "rgb(" + (int) red + "," + (int) green + "," + (int) blue + ")";

    }

    public static String buildMap() {
        String map = "";
        return map;




    }


}
