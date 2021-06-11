package edu.mcw.scge.storage;

import java.io.File;
import java.util.ArrayList;

public class ImageStore {

    public static String[] getImages(String type, String id, String bucket) {

        File f = new File(StorageProperties.rootLocation+ "/" + type + "/" + id + "/" + bucket);

        String[] files = new String[0];

        if (f.exists())  {
            files= f.list();
        }

        return files;

    }

}
