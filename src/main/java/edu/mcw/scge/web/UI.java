package edu.mcw.scge.web;

import java.text.SimpleDateFormat;
import java.util.Date;

public class UI {

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
