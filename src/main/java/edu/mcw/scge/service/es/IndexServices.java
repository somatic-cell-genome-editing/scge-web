package edu.mcw.scge.service.es;

import com.google.gson.Gson;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.web.SCGEContext;
import org.apache.commons.codec.language.bm.Rule;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.index.query.*;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.AggregationBuilder;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.BucketOrder;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.search.sort.SortOrder;

import javax.management.Query;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class IndexServices {
    private static String searchIndex;
    Gson gson=new Gson();
    Access access=new Access();
    public SearchResponse getSearchResults(List<String>  categories, String searchTerm, Map<String, String> filterMap,boolean DCCNIHMember, boolean consortiumMember) throws IOException {
        searchIndex= SCGEContext.getESIndexName();
        SearchSourceBuilder srb=new SearchSourceBuilder();
        srb.query(this.buildBoolQuery(categories, searchTerm, filterMap, DCCNIHMember,consortiumMember));
       srb.aggregation(this.buildSearchAggregations("category"));
         buildAggregations(srb, categories);
        srb.highlighter(this.buildHighlights());
        srb.size(10000);
        if(searchTerm.equals("") && categories.size()==1 && (categories.get(0).equalsIgnoreCase("Project")|| categories.get(0).equalsIgnoreCase("Experiment"))){
          //  srb.sort("name.keyword");
            try {
                srb.sort("lastModifiedDate", SortOrder.DESC);
            }catch (Exception exception){}

        }else{
            if(searchTerm.equals("")) {
                srb.sort("name.keyword");
            }
        }
       SearchRequest searchRequest=new SearchRequest(searchIndex);
       searchRequest.source(srb);

       SearchResponse sr= ESClient.getClient().search(searchRequest, RequestOptions.DEFAULT);
      /*  for(SearchHit hit:sr.getHits().getHits()){
            System.out.println(hit.getHighlightFields().keySet().toString());
        }*/
       return sr;

    }
    public void buildAggregations(SearchSourceBuilder srb, List<String> categories){
        if(categories!=null && categories.size()==1 || (categories==null || (categories.size()==0))){
            if(categories==null || categories.get(0).equalsIgnoreCase("Genome Editor")
                    || categories.get(0).equalsIgnoreCase("Delivery System")
            ||categories.get(0).equalsIgnoreCase("Vector")
                    ||categories.get(0).equalsIgnoreCase("Experiment")){
                srb.aggregation(this.buildSearchAggregations("editorType"));
                srb.aggregation(this.buildSearchAggregations("editorSubType"));
                srb.aggregation(this.buildSearchAggregations("editorSpecies"));
            }
            if(categories==null ||  categories.get(0).equalsIgnoreCase("Model System")
                    || categories.get(0).equalsIgnoreCase("Delivery System")
            || categories.get(0).equalsIgnoreCase("Vector")
                    ||categories.get(0).equalsIgnoreCase("Experiment")
                    ||categories.get(0).equalsIgnoreCase("Protocol")){
                srb.aggregation(this.buildSearchAggregations("modelType"));
                srb.aggregation(this.buildSearchAggregations("modelSubtype"));
                srb.aggregation(this.buildSearchAggregations("modelOrganism"));
                if(categories==null || categories.get(0).equalsIgnoreCase("Model System"))
                srb.aggregation(this.buildSearchAggregations("transgeneReporter"));
            }
            if(categories==null || categories.get(0).equalsIgnoreCase("Delivery System")
                    ||categories.get(0).equalsIgnoreCase("Experiment")){
                srb.aggregation(this.buildSearchAggregations("deliveryType"));
                srb.aggregation(this.buildSearchAggregations("deliverySubtype"));
                srb.aggregation(this.buildSearchAggregations("deliverySpecies"));

            }
            if(categories==null || categories.get(0).equalsIgnoreCase("Delivery System") ||
                    categories.get(0).equalsIgnoreCase("Guide") ||
                    categories.get(0).equalsIgnoreCase("Vector")
                    ||categories.get(0).equalsIgnoreCase("Experiment")) {
                srb.aggregation(this.buildSearchAggregations("tissueTerm"));
            }
            if(categories==null || categories.get(0).equalsIgnoreCase("Guide")) {
                srb.aggregation(this.buildSearchAggregations("guideSpecies"));
                srb.aggregation(this.buildSearchAggregations("guideCompatibility"));

             //   srb.aggregation(this.buildSearchAggregations("target"));

            }
            if(categories==null || categories.get(0).equalsIgnoreCase("Guide") ||
                    categories.get(0).equalsIgnoreCase("Vector")
                    ||categories.get(0).equalsIgnoreCase("Experiment")) {
                srb.aggregation(this.buildSearchAggregations("guideTargetLocus"));

            }
            if(categories==null || categories.get(0).equalsIgnoreCase("Vector")) {
                //      srb.aggregation(this.buildSearchAggregations(  "vectorName"));
                srb.aggregation(this.buildSearchAggregations(  "vectorType"));
                srb.aggregation(this.buildSearchAggregations(   "vectorSubtype"));
            }
            if(categories==null || categories.get(0).equalsIgnoreCase("Study") || categories.get(0).equalsIgnoreCase("Experiment")
                    || categories.get(0).equalsIgnoreCase("Protocol")) {
                srb.aggregation(this.buildSearchAggregations("experimentType"));
            }
            if(categories==null || categories.get(0).equalsIgnoreCase("Protocol")) {
                srb.aggregation(this.buildSearchAggregations("experimentName"));
            }
            srb.aggregation(this.buildSearchAggregations("pi"));
            srb.aggregation(this.buildSearchAggregations("initiative"));
            srb.aggregation(this.buildSearchAggregations("studyType"));

        }
        if(categories!=null && categories.size()==2){
            srb.aggregation(this.buildSearchAggregations("experimentType"));
            srb.aggregation(this.buildSearchAggregations("pi"));
            srb.aggregation(this.buildSearchAggregations("access"));
            srb.aggregation(this.buildSearchAggregations("status"));
            srb.aggregation(this.buildSearchAggregations("initiative"));
            srb.aggregation(this.buildSearchAggregations("studyType"));
        }

    }
    public HighlightBuilder buildHighlights(){
       // List<String> fields= Stream.concat(searchFields().stream(), mustFields().stream()).collect(Collectors.toList());
        List<String> fields = new ArrayList<>(searchFields());
        HighlightBuilder hb=new HighlightBuilder();
       for(String field:fields){

            hb.field(field);
        }
      hb.field("*");
      // hb.numOfFragments(1);
     //  hb.field("*");
      //  System.out.println(gson.toJson(hb));
        return hb;
    }

    public AggregationBuilder buildAggregations(String fieldName){
        AggregationBuilder aggs= null;
        aggs= AggregationBuilders.terms(fieldName).field(fieldName+".keyword")
                .order(BucketOrder.key(true));
        if(fieldName.equalsIgnoreCase("organism")){
            aggs.subAggregation(AggregationBuilders.terms("animalModels").field("animalModels"+".keyword"));
        }
        return aggs;
    }
    public AggregationBuilder buildSearchAggregations(String fieldName){
        AggregationBuilder aggs= null;
        if(fieldName!=null && !fieldName.equalsIgnoreCase("category") &&
                !fieldName.equals("")){
            aggs= AggregationBuilders.terms(fieldName).field(fieldName+".keyword") .size(1000).order(BucketOrder.key(true));

        }else {
                fieldName="category";
            aggs = AggregationBuilders.terms(fieldName).field(fieldName + ".keyword") .size(1000).order(BucketOrder.key(true));
        }
        return aggs;
    }
    public AggregationBuilder buildFilterAggregations(String fieldName, String selectedCategory){
        AggregationBuilder aggs= null;

            aggs= AggregationBuilders.terms(fieldName.replace(".type","").trim()).field(fieldName+".keyword").size(1000).order(BucketOrder.key(true));



        return aggs;
    }
    public  Map<String, List<Terms.Bucket>> getSearchAggregations(SearchResponse sr){
        Map<String, List<Terms.Bucket>> aggregations=new HashMap<>();
        /********************Category aggs*****************************/
        Terms categoryAggs=sr.getAggregations().get("category");
        if(categoryAggs!=null)
        aggregations.put("catBkts", (List<Terms.Bucket>) categoryAggs.getBuckets());
        /********************Category specific aggs *****************************/
        addAllCategorySpecificAggs(sr, aggregations);
        /********************experiment aggs *****************************/
        addAllModelAggs(sr, aggregations);
        addAllEditorAggs(sr,aggregations);
        addAllDeliveryAggs(sr,aggregations);
        addAllGuideAggs(sr, aggregations);
        addAllVectorAggs(sr,aggregations);
        addAllStudyAggs(sr, aggregations);
        return aggregations;
    }
    public void addAllStudyAggs(SearchResponse sr,  Map<String, List<Terms.Bucket>> aggregations){
        Terms piAggs=sr.getAggregations().get("pi");
        if(piAggs!=null)
            aggregations.put("piBkts", (List<Terms.Bucket>) piAggs.getBuckets());
        Terms accessAggs=sr.getAggregations().get("access");

        if(accessAggs!=null)
            aggregations.put("accessBkts", (List<Terms.Bucket>) accessAggs.getBuckets());
        Terms statusAggs=sr.getAggregations().get("status");

        if(statusAggs!=null)
            aggregations.put("statusBkts", (List<Terms.Bucket>) statusAggs.getBuckets());

    }
    public void addAllModelAggs(SearchResponse sr,  Map<String, List<Terms.Bucket>> aggregations){
        Terms modelAggs=sr.getAggregations().get("modelType");
        if(modelAggs!=null)
            aggregations.put("modelBkts", (List<Terms.Bucket>) modelAggs.getBuckets());
        Terms modelSpeciesAggs=sr.getAggregations().get("modelOrganism");
        if(modelSpeciesAggs!=null)
            aggregations.put("modelSpeciesBkts", (List<Terms.Bucket>) modelSpeciesAggs.getBuckets());
        Terms reporterAggs=sr.getAggregations().get("transgeneReporter");
        if(reporterAggs!=null)
            aggregations.put("reporterBkts", (List<Terms.Bucket>) reporterAggs.getBuckets());
    }
    public void addAllEditorAggs(SearchResponse sr,  Map<String, List<Terms.Bucket>> aggregations){
        Terms editorAggs=sr.getAggregations().get("editorType");
        if(editorAggs!=null)
            aggregations.put("editorBkts", (List<Terms.Bucket>) editorAggs.getBuckets());
        Terms editorSubTypeAggs=sr.getAggregations().get("editorSubType");
        if(editorSubTypeAggs!=null)
            aggregations.put("editorSubTypeBkts", (List<Terms.Bucket>) editorSubTypeAggs.getBuckets());
        Terms editorSpeciesAggs=sr.getAggregations().get("editorSpecies");
        if(editorSpeciesAggs!=null)
            aggregations.put("editorSpeciesBkts", (List<Terms.Bucket>) editorSpeciesAggs.getBuckets());
    }
    public void addAllDeliveryAggs(SearchResponse sr,  Map<String, List<Terms.Bucket>> aggregations){
        Terms deliveyAggs=sr.getAggregations().get("deliveryType");
        if(deliveyAggs!=null)
            aggregations.put("deliveryBkts", (List<Terms.Bucket>) deliveyAggs.getBuckets());
    }
    public void addAllGuideAggs(SearchResponse sr,  Map<String, List<Terms.Bucket>> aggregations){
        Terms guidesTargetLocusAggs=sr.getAggregations().get("guideTargetLocus");
        if(guidesTargetLocusAggs!=null)
            aggregations.put("guidesBkts", (List<Terms.Bucket>) guidesTargetLocusAggs.getBuckets());
    }
    public void addAllVectorAggs(SearchResponse sr,  Map<String, List<Terms.Bucket>> aggregations){
        Terms vectorTypeAggs=sr.getAggregations().get("vectorType");
        if(vectorTypeAggs!=null)
            aggregations.put("vectorTypeBkts", (List<Terms.Bucket>) vectorTypeAggs.getBuckets());
        Terms vectorSubTypeAggs=sr.getAggregations().get("vectorSubtype");
        if(vectorSubTypeAggs!=null)
            aggregations.put("vectorSubTypeBkts", (List<Terms.Bucket>) vectorSubTypeAggs.getBuckets());
        Terms vectorAggs=sr.getAggregations().get("vectorName");
        if(vectorAggs!=null)
            aggregations.put("vectorBkts", (List<Terms.Bucket>) vectorAggs.getBuckets());
    }
    public void addAllCategorySpecificAggs(SearchResponse sr,  Map<String, List<Terms.Bucket>> aggregations){
        Terms typeAggs=sr.getAggregations().get("type");
        if(typeAggs!=null)
            aggregations.put("typeBkts", (List<Terms.Bucket>) typeAggs.getBuckets());

        Terms subtypeAggs=sr.getAggregations().get("subType");
        if(subtypeAggs!=null)
            aggregations.put("subtypeBkts", (List<Terms.Bucket>) subtypeAggs.getBuckets());
        Terms speciesAggs=sr.getAggregations().get("species");
        if(speciesAggs!=null)
            aggregations.put("speciesBkts", (List<Terms.Bucket>) speciesAggs.getBuckets());

        Terms targetAggs=sr.getAggregations().get("tissueTerm");
        if(targetAggs!=null)
            aggregations.put("targetBkts", (List<Terms.Bucket>) targetAggs.getBuckets());

        Terms grnaLabIdAggs=sr.getAggregations().get("externalId");
        if(grnaLabIdAggs!=null)
            aggregations.put("grnaLabIdBkts", (List<Terms.Bucket>) grnaLabIdAggs.getBuckets());

        Terms withExperimentsAggs=sr.getAggregations().get("withExperiments");
        if(withExperimentsAggs!=null)
            aggregations.put("withExperimentsBkts", (List<Terms.Bucket>) withExperimentsAggs.getBuckets());


    }
    public  Map<String, List<Terms.Bucket>> getSearchAggregationsBKUP(SearchResponse sr){
        Map<String, List<Terms.Bucket>> aggregations=new HashMap<>();
        Terms categoryAggs=sr.getAggregations().get("category");
        aggregations.put("categoryAggs", (List<Terms.Bucket>) categoryAggs.getBuckets());
        for(Terms.Bucket b:categoryAggs.getBuckets()){
            if(  b.getAggregations()!=null) {
                Terms typeAggs = b.getAggregations().get("type");
              //  System.out.println(b.getKey() + "\t" + b.getDocCount());
                if (typeAggs != null) {
                    aggregations.put(b.getKey() + "TypeAggs", (List<Terms.Bucket>) typeAggs.getBuckets());
                    for (Terms.Bucket bkt : typeAggs.getBuckets()) {
                        Terms subtypeAggs = bkt.getAggregations().get("subtype");
                        aggregations.put(bkt.getKey() + "SubtypeAggs", (List<Terms.Bucket>) subtypeAggs.getBuckets());
                       // System.out.println(bkt.getKey() + "_type" + "\t" + bkt.getDocCount() + "\tsubtypeAggsSize: " + subtypeAggs.getBuckets().size());

                    }
                }
            }
        }

        return aggregations;
    }
    public  Map<String, List<Terms.Bucket>> getAggregations(SearchResponse sr){
        Map<String, List<Terms.Bucket>> aggregations=new HashMap<>();
        Terms editorAggs=sr.getAggregations().get("editor");
        aggregations.put("editorAggs", (List<Terms.Bucket>) editorAggs.getBuckets());
        Terms deliveryAggs=sr.getAggregations().get("deliveryVehicles");
        aggregations.put("deliveryAggs", (List<Terms.Bucket>) deliveryAggs.getBuckets());
        Terms tissueAggs=sr.getAggregations().get("targetTissue");
        aggregations.put("tissueAggs", (List<Terms.Bucket>) tissueAggs.getBuckets());
        Terms organismAggs=sr.getAggregations().get("organism");
        aggregations.put("organismAggs", (List<Terms.Bucket>) organismAggs.getBuckets());
      /*  for(Terms.Bucket bkt:organismAggs.getBuckets()){
            aggregations.put((String) bkt.getKey().toString().toLowerCase() , bkt.getAggregations().get("animalModels"));
        }*/
        return aggregations;
    }

    public BoolQueryBuilder buildBoolQuery(List<String> categories, String searchTerm , Map<String, String> filterMap, boolean DCCNIHMember,boolean consortiumMember){
        BoolQueryBuilder q=new BoolQueryBuilder();
        q.must(buildQuery(searchTerm));

     if(!DCCNIHMember && consortiumMember ) {
            q.filter(QueryBuilders.termQuery("accessLevel.keyword", "consortium"));
            q.filter(QueryBuilders.boolQuery().must(QueryBuilders.boolQuery().
                    should(QueryBuilders.termQuery("tier", 4)).should(QueryBuilders.termQuery("tier", 3))));
        }
        if(!consortiumMember){
           q.filter(QueryBuilders.termQuery("accessLevel.keyword", "public"));
           q.filter((QueryBuilders.termQuery("tier", 4)));

        }

        if(DCCNIHMember ){
            q.filter(QueryBuilders.termQuery("accessLevel.keyword", "consortium"));
        }
        if( categories!=null &&categories.size()>0) {
            q.filter(QueryBuilders.termsQuery("category.keyword", categories.toArray()));


        }
        if(filterMap!=null && filterMap.size()>0)
            for(String key:filterMap.keySet()){
                q.filter(QueryBuilders.termsQuery(key+".keyword", filterMap.get(key).split(",")));

            }

        return q;
    }
    public SearchResponse getFilteredAggregations(List<String> categories, String searchTerm,
                                                  Map<String, String> filterMap,boolean DCCNIHMember, boolean consortiumMember) throws IOException {

        SearchSourceBuilder srb=new SearchSourceBuilder();
        srb.query(this.buildBoolQuery(categories, searchTerm, null, DCCNIHMember,consortiumMember));

        if(filterMap.size()==1) {
            srb.aggregation(this.buildFilterAggregations(filterMap.entrySet().iterator().next().getKey(), ""));
        }
        srb.aggregation(this.buildAggregations("category"));

        srb.size(0);
        SearchRequest searchRequest=new SearchRequest(searchIndex);
        searchRequest.source(srb);

        return ESClient.getClient().search(searchRequest, RequestOptions.DEFAULT);

    }
    public QueryBuilder buildQuery(String term){
        DisMaxQueryBuilder q=new DisMaxQueryBuilder();

        if(term!=null && !term.equals("")) {
            String searchTerm=term.toLowerCase().trim();
            if(searchTerm.toLowerCase().contains(" and ")){
                String searchString=String.join(" ", searchTerm.toLowerCase().split(" and "));
                q.add(QueryBuilders.multiMatchQuery(searchString)
                        .type(MultiMatchQueryBuilder.Type.CROSS_FIELDS)
                        .operator(Operator.AND)
                        .analyzer("stop")

                );

                q.add(QueryBuilders.multiMatchQuery(searchString)
                        .type(MultiMatchQueryBuilder.Type.CROSS_FIELDS)
                        .type(MultiMatchQueryBuilder.Type.PHRASE)
                        .analyzer("stop")
                        .boost(1000)
                );

            }else if(searchTerm.toLowerCase().contains(" or ")){
                String searchString=String.join(" ", searchTerm.toLowerCase().split(" or "));
                q.add(QueryBuilders.multiMatchQuery(searchString)
                                .type(MultiMatchQueryBuilder.Type.CROSS_FIELDS)
                                .operator(Operator.OR)
                        .analyzer("stop")

                );

            }else if(!searchTerm.toLowerCase().contains(" and ") && searchTerm.toLowerCase().contains(" ") ) {
            q.add(QueryBuilders.multiMatchQuery(searchTerm)
                    .type(MultiMatchQueryBuilder.Type.CROSS_FIELDS)
                    .operator(Operator.AND)

            );
                q.add(QueryBuilders.multiMatchQuery(searchTerm)
                        .type(MultiMatchQueryBuilder.Type.CROSS_FIELDS)
                        .operator(Operator.AND)
                        .type(MultiMatchQueryBuilder.Type.PHRASE)
                        .analyzer("stop")
                        .boost(1000)
                );

            }else { if (isNumeric(searchTerm)) {
                q.add(QueryBuilders.termQuery("id", searchTerm));
                q.add(QueryBuilders.termQuery("studyId", searchTerm));
            } else {
                q.add(QueryBuilders.multiMatchQuery(searchTerm, IndexServices.searchFields().toArray(new String[0]))
                        .type(MultiMatchQueryBuilder.Type.CROSS_FIELDS)
                        .type(MultiMatchQueryBuilder.Type.PHRASE)
                        .analyzer("stop")
                );
                q.add(QueryBuilders.multiMatchQuery(searchTerm, IndexServices.searchFields().toArray(new String[0]))
                        .type(MultiMatchQueryBuilder.Type.CROSS_FIELDS)
                        .operator(Operator.AND)
                        .analyzer("stop")
                );
            }
        }

            q.add(QueryBuilders.termQuery("symbol.custom", searchTerm).boost(1000));
            q.add(QueryBuilders.termQuery("name.custom", searchTerm).boost(1000));
            q.add(QueryBuilders.termQuery("pi", searchTerm).boost(1000));

            q.add(QueryBuilders.matchPhraseQuery("symbol", searchTerm).boost(400));
            q.add(QueryBuilders.matchPhraseQuery("name", searchTerm).boost(400));

            q.add(QueryBuilders.matchPhrasePrefixQuery("symbol.custom", searchTerm).boost(100));
            q.add(QueryBuilders.matchPhrasePrefixQuery("name.custom", searchTerm).boost(100));



            q.add(QueryBuilders.matchPhrasePrefixQuery("pi", searchTerm).boost(500));
            q.add(QueryBuilders.matchPhraseQuery("pi", searchTerm).boost(200));
            q.add(QueryBuilders.termQuery("currentGrantNumber.keyword", searchTerm));
            q.add(QueryBuilders.termQuery("formerGrantNumbers.keyword", searchTerm));


        }else{
            q.add(QueryBuilders.matchAllQuery());
        }

        return q;
    }
    public boolean isNumeric(String searchTerm){
        try{
            if(Long.parseLong(searchTerm)>0)
                return true;
        }catch (Exception e){}
        return false;
    }
    public static List<String> mustFields(){
        return Arrays.asList(
              "name", "name.ngram", "symbol", "symbol.ngram",
                "type", "subType","tissueTerm",
                "termSynonyms"



        );
    }
    public static List<String> searchFields(){
        return Arrays.asList(
              // "name", "name.ngram", "symbol", "symbol.ngram",
              //  "type", "subType",

               "name", "name.ngram", "symbol", "symbol.ngram", "name.custom", "symbol.custom",
                "species", "sex",
                "description",
                "study", "labName" , "pi", "initiative",
                 "externalId", "aliases", "generatedDescription",

                "editorType" , "editorSubType" ,  "editorSymbol" ,  "editorAlias" , "editorSpecies" ,
                 "editorPamPreference" , "substrateTarget" , "activity" , "fusion" , "dsbCleavageType" , "editorSource" ,

                 "deliveryType" ,"deliverySubType", "deliverySystemName","deliverySource" ,
                 "modelType" , "modelName" , "modelOrganism" , "transgene" , "transgeneReporter" , "strainCode",

                 "guideSpecies", "guideTargetLocus", "guideTargetLocus.ngram", "guideTargetSequence", "guidePam", "grnaLabId","grnaLabId.ngram", "guide", "guideSource","guideCompatibility",

                 "vectorName", "vectorType", "vectorSubtype", "genomeSerotype", "capsidSerotype", "capsidVariant", "vectorSource", "vectorLabId",
                "vectorAnnotatedMap", "titerMethod", "modifications", "proteinSequence",

                "tissueIds", "tissueTerm", "termSynonyms",
                "site", "sequence", "pam", "detectionMethod","target",
               "experimentName","experimentType"
              //  , "currentGrantNumber.keyword", "formerGrantNumbers.keyword"

              /* "studyNames",
                "experimentNames"*/



         );
    }
}
