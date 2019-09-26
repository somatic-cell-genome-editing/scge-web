package edu.mcw.scge.service;

import java.io.FileInputStream;
import java.util.Properties;

/**
 * Created by jthota on 9/23/2019.
 */
public class ClientService {
   public static String CLIENT_ID =getProperties().getProperty("CLIENT_ID");
   public static String CLIENT_SECRET=getProperties().getProperty("CLIENT_SECRET");
    public static String REDIRECT_URI=getProperties().getProperty("REDIRECT_URI");

    public static Properties getProperties(){
        Properties props=new Properties();
        FileInputStream fis=null;
        try{
      //   fis=new FileInputStream("C:/git/scge-web/data/properties/client.properties");
           fis=new FileInputStream("/data/properties/client.properties");
            props.load(fis);
            System.out.println("PROPERTIES: "+ props.size());
        }catch (Exception e){
            e.printStackTrace();
        }
        return props;
    }
}
