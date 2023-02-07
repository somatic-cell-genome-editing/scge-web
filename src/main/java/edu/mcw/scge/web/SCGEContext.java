package edu.mcw.scge.web;

import org.apache.commons.logging.LogFactory;

import javax.servlet.ServletRequest;
import java.net.InetAddress;
import java.net.UnknownHostException;

public class SCGEContext {
    private static boolean isProduction; // true iff host is HANCOCK or OWEN
    private static boolean isTest; // true iff host is local development machine
    private static boolean isDev; // true iff host is HANSEN (DEV)
    private static String hostname;

    static void parseHostName() throws UnknownHostException {
        if( hostname!=null )
            return;
        try {

            hostname = InetAddress.getLocalHost().getHostName().toLowerCase();
            isProduction = hostname.contains("morn");
            isDev = hostname.contains("leeta");
            isTest = hostname.contains("saru");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static boolean isProduction() throws UnknownHostException {
        parseHostName();
        return isProduction;
    }


    public static boolean isDev() throws UnknownHostException {
        parseHostName();
        return isDev;
    }
    public static boolean isTest() throws UnknownHostException {
        parseHostName();
        return isTest;
    }

    public static String getESIndexName() {
        try {
            if( isProduction() ) {
                return"scge_search_prod";
            }

            if( isDev() ) {
                return "scge_search_dev";
            }
            if( isTest() ) {
                return "scge_search_test";
            }

        } catch( UnknownHostException e ) {
            return null;
        }
        return "scge_search_dev";
    }

}
