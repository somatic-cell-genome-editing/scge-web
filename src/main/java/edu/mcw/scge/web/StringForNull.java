package edu.mcw.scge.web;

public class StringForNull {

    public static String parse(String val) {
        if (val==null || val.equals("")) {
            return "";
        }else {
            return val;
        }

    }

    public static String parseInt(int value) {
        if (value==0) {
            return "";
        }else {
            return value + "";
        }
    }


    public static String parseLong(long value) {
        if (value==0) {
            return "";
        }else {
            return value + "";
        }
    }

}
