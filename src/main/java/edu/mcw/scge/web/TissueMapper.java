package edu.mcw.scge.web;

import java.util.LinkedHashMap;

public class TissueMapper {



    LinkedHashMap<String,String> rootTissues = new LinkedHashMap<String,String>();
    LinkedHashMap<String,LinkedHashMap<String,String>> childTerms = new LinkedHashMap<String,LinkedHashMap<String,String>>();
    LinkedHashMap<String,LinkedHashMap<String,String>> editing = new LinkedHashMap<String,LinkedHashMap<String,String>>();
    LinkedHashMap<String,LinkedHashMap<String,String>> delivery = new LinkedHashMap<String,LinkedHashMap<String,String>>();
    LinkedHashMap<String,Long> targets = new LinkedHashMap<String,Long>();



    public TissueMapper() {

        rootTissues.put("Connective Tissue", "UBERON:0002384");
        rootTissues.put("Reproductive", "UBERON:0000990");
        rootTissues.put("Renal/Urinary", "UBERON:0001008");
        rootTissues.put("Endocrine", "UBERON:0000949");
        rootTissues.put("Haemolymphoid", "UBERON:0002193");
        rootTissues.put("Gastrointestinal", "UBERON:0005409");
        rootTissues.put("Liver and Biliary", "UBERON:0002423");
        rootTissues.put("Respiratory", "UBERON:0001004");
        rootTissues.put("Cardiovascular", "UBERON:0004535");
        rootTissues.put("Musculoskeletal", "UBERON:0002204");
        rootTissues.put("Integumentary", "UBERON:0002416");
        rootTissues.put("Nervous", "UBERON:0001016");
        rootTissues.put("Sensory", "UBERON:0001032");
        rootTissues.put("Hematopoietic", "UBERON:0002390");

        for (String tissue: rootTissues.keySet()) {
            childTerms.put(tissue, new LinkedHashMap<String,String>());

        }

        for (String tissue: rootTissues.keySet()) {
            editing.put(tissue, new LinkedHashMap<String,String>());

        }
        //editing.put("unknown", new LinkedHashMap<String,String>());

        for (String tissue: rootTissues.keySet()) {
            delivery.put(tissue, new LinkedHashMap<String,String>());

        }
        //delivery.put("unknown", new LinkedHashMap<String,String>());


    }

    public LinkedHashMap<String,String> getRootTissues() {
        return rootTissues;
    }

    public LinkedHashMap<String,LinkedHashMap<String,String>> getEditing() {
        return editing;
    }

    public boolean hasEditing(String rootTerm, String childTerm)  {
        LinkedHashMap<String,String> child = editing.get(rootTerm);

        for (String key: child.keySet()) {
            if (key == childTerm) {
                return true;
            }
        }

        return false;
    }

    public String getEditingURL(String rootTerm, String childTerm)  {
        LinkedHashMap<String,String> child = editing.get(rootTerm);

        for (String key: child.keySet()) {
            if (key.equals(childTerm)) {
                return child.get(key);
            }
        }
        return "";
    }

    public LinkedHashMap<String,LinkedHashMap<String,String>> getChildTerms() {
        return childTerms;
    }

    public boolean hasDelivery(String rootTerm, String childTerm) {

        LinkedHashMap<String,String> child = delivery.get(rootTerm);

        for (String key: child.keySet()) {

            if (key.equals(childTerm)) {
                return true;
            }
        }

        return false;

    }

    public String getDeliveryURL(String rootTerm, String childTerm) {
        LinkedHashMap<String,String> child = delivery.get(rootTerm);

        for (String key: child.keySet()) {

            if (key.equals(childTerm)) {
                return child.get(key);
            }
        }

        return "";

    }

    public LinkedHashMap<String,LinkedHashMap<String,String>> getDelivery(String rootTerm) {
        return delivery;
    }

    public void addEditing(String tissue, String childTerm,String url) {

        LinkedHashMap<String,String> children = editing.get(tissue);
        if( children!=null ) {
            children.put(childTerm, url);
            editing.put(tissue, children);
        }

        LinkedHashMap<String,String> childs = childTerms.get(tissue);
        if( childs!=null ) {
            childs.put(childTerm, url);
            childTerms.put(tissue, childs);
        }
    }

    public void addDelivery(String tissue, String childTerm, String url) {
        System.out.println("TISSUE:"+tissue +"\tCHILDTERM:"+ childTerm+"\tURL:"+ url);
        if(tissue!=null) {
            LinkedHashMap<String, String> children = delivery.get(tissue);
            if (children != null) {
                children.put(childTerm, url);
                delivery.put(tissue, children);
            }
            LinkedHashMap<String, String> childs = childTerms.get(tissue);
            if (childs != null) {
                childs.put(childTerm, url);
                childTerms.put(tissue, childs);
            }
        }

//        childTerms.put(tissue,children);

    }

}
