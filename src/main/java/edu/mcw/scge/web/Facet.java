package edu.mcw.scge.web;

import java.util.*;

public class Facet {
    // Declaring the static map
    public static Map<String, String> displayNames;
    public static List<String> facetParams;

    // Instantiating the static map
    static
    {
        displayNames = new HashMap<>();
        displayNames.put("editorType", "Genome Editor Type");
        displayNames.put("editorSubType", "Genome Editor Subtype");
        displayNames.put("editorSpecies", "Genome Editor Species");

        displayNames.put("deliveryType", "Delivery System Type");
        displayNames.put("deliverySubtype", "Delivery System Subtype");

        displayNames.put("modelType", "Model Type");
        displayNames.put("modelSubtype", "Model Subtype");
        displayNames.put("modelOrganism", "Model Organism");
        displayNames.put("transgeneReporter", "Transgene Reporter");

        displayNames.put("tissueTerm", "Target Tissue");
        displayNames.put("guideTargetLocus", "Guide Target Locus");
        displayNames.put("guideCompatibility", "Guide Compatibility");
        displayNames.put("guideSpecies", "Guide Species");


        displayNames.put("vectorName", "Vector Name");
        displayNames.put("vectorSubtype", "Vector Subtype");
        displayNames.put("vectorType", "Vector Type");


        displayNames.put("access", "Access");
        displayNames.put("status", "Status");
        displayNames.put("pi", "Principal Investigator");
        displayNames.put("initiative", "Inititative");
        displayNames.put("studyType", "Study Type");
        displayNames.put("experimentType", "Experiment Type");
        displayNames.put("experimentName", "Experiment");

        facetParams=
        new ArrayList<>(Arrays.asList("editorType","editorSubType","editorSpecies",
                "deliveryType","deliverySubtype",
                "modelType","modelOrganism", "transgeneReporter","modelSubtype",
                "tissueTerm","guideTargetLocus","guideSpecies","guideCompatibility",
                "vectorName","vectorSubtype","vectorType",
                "access","status","pi","initiative","studyType",
                "experimentType", "experimentName"
        ));


    }

}
