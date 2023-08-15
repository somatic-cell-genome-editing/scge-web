package edu.mcw.scge.web.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by IntelliJ IDEA.
 * User: jdepons
 * Date: Feb 19, 2009
 * Time: 12:08:22 PM
 * To change this template use File | Settings | File Templates.
 */
public class Stamp {

    public static SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd - hh:mm:ss.SSS");
    public static void it(String desc) {
        System.out.println(sf.format(new Date()) + " - " + desc);
    }
}

