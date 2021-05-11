package edu.mcw.scge.service.es;

import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.index.query.*;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.AggregationBuilder;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.BucketOrder;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;

import javax.management.Query;
import java.io.IOException;
import java.util.*;

public class IndexServices {
    public SearchResponse getSearchResults(String category, String searchTerm, Map<String, String> filterMap,boolean DCCNIHMember) throws IOException {

        SearchSourceBuilder srb=new SearchSourceBuilder();
        System.out.println("SEARCH TERM:"+searchTerm+"\tCategory:" +category);
        srb.query(this.buildBoolQuery(category, searchTerm, filterMap, DCCNIHMember));
        srb.aggregation(this.buildSearchAggregations("category", category));
        if(!category.equals("")) {
            /*********************EXPERIMENT************************/
            srb.aggregation(this.buildSearchAggregations("models.type", null));
            srb.aggregation(this.buildSearchAggregations("deliveries.type", null));
            srb.aggregation(this.buildSearchAggregations("editor.type", null));
            srb.aggregation(this.buildSearchAggregations("guides.targetLocus", null));
            /*********************common**************************/
            srb.aggregation(this.buildSearchAggregations("type", null));
            srb.aggregation(this.buildSearchAggregations("subType", null));
            srb.aggregation(this.buildSearchAggregations("species", null));
            srb.aggregation(this.buildSearchAggregations("target", null));
            srb.aggregation(this.buildSearchAggregations("withExperiments", null));

            /*********************guide**************************/
            srb.aggregation(this.buildSearchAggregations("targetLocus", null));
            srb.aggregation(this.buildSearchAggregations("grnaLabId", null));






        }
        srb.highlighter(this.buildHighlights());
        srb.size(1000);
    //  SearchRequest searchRequest=new SearchRequest("scge_search_test");
       SearchRequest searchRequest=new SearchRequest("scge_search_test");
       searchRequest.source(srb);

        return ESClient.getClient().search(searchRequest, RequestOptions.DEFAULT);

    }
    public HighlightBuilder buildHighlights(){
        List<String> fields=new ArrayList<>(Arrays.asList(
               "name", "type", "subType","aliases","externalId","symbol","additionalData", "experimentalTags",
                "species","pam","description","site", "detectionMethod","sequence","target",
                "study.study",
                "study.labName" ,
                "study.pi",
                "editors.type" ,
                "editors.subType" ,
                "editors.symbol" ,
                "editors.alias" ,
                "editors.species" ,
                "editors.pamPreference" ,
                "editors.substrateTarget" ,
                "editors.activity" ,
                "editors.fusion" ,
                "editors.dsbCleavageType" ,
                "editors.source" ,
                "deliveries.type" ,
                "deliveries.name" ,
                "deliveries.source" ,
                "deliveries.description" ,
                "models.type" ,
                "models.name" ,
                "models.organism" ,
                "models.transgene" ,
                "models.transgeneReporter" ,
                "models.description" ,
                "models.strainCode",
                "guides.species",
                "guides.targetLocus",
                "guides.targetSequence",
                "guides.pam",
                "guides.grnaLabId",

                "guides.guide",
                "guides.source",
                "guides.guideDescription",
                "name.ngram"
        ));

        HighlightBuilder hb=new HighlightBuilder();
        for(String field:fields){
            hb.field(field);
        }
        return hb;
    }

    public SearchResponse getSearchResponse() throws IOException {

        SearchSourceBuilder srb=new SearchSourceBuilder();
        srb.query(QueryBuilders.matchAllQuery());
        srb.aggregation(this.buildAggregations("editor"));
        srb.aggregation(this.buildAggregations("deliveryVehicles"));
        srb.aggregation(this.buildAggregations("organism"));
        srb.aggregation(this.buildAggregations("targetTissue"));
        srb.size(1000);
        SearchRequest searchRequest=new SearchRequest("scge_delivery_dev");
        searchRequest.source(srb);

        return ESClient.getClient().search(searchRequest, RequestOptions.DEFAULT);

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
    public AggregationBuilder buildSearchAggregations(String fieldName, String selectedCategory){
        AggregationBuilder aggs= null;
        if(fieldName!=null && !fieldName.equalsIgnoreCase("category") &&
                !fieldName.equals("")){
            if(fieldName.contains("models") || fieldName.equalsIgnoreCase("deliveries") || fieldName.equalsIgnoreCase("editors")|| fieldName.equalsIgnoreCase("guides"))
         //   aggs= AggregationBuilders.terms(fieldName).field(fieldName+".keyword");
                aggs= AggregationBuilders.terms(fieldName).field(fieldName+".keyword");

            else
            aggs= AggregationBuilders.terms(fieldName).field(fieldName+".keyword");

         //   aggs= AggregationBuilders.terms(fieldName).field(fieldName+".type.keyword");

        }else {
                fieldName="category";
            aggs = AggregationBuilders.terms(fieldName).field(fieldName + ".keyword");
        }
    /*    if(selectedCategory!=null && !selectedCategory.equals("")) {
            aggs.subAggregation(AggregationBuilders.terms("type").field("type.keyword")
                    .subAggregation(AggregationBuilders.terms("subtype").field("subType.keyword"))
            );

            // .order(BucketOrder.key(true));

        }*/
        return aggs;
    }
    public AggregationBuilder buildFilterAggregations(String fieldName, String selectedCategory){
        AggregationBuilder aggs= null;

            aggs= AggregationBuilders.terms(fieldName.replace(".type","").trim()).field(fieldName+".keyword");



        return aggs;
    }
    public  Map<String, List<Terms.Bucket>> getSearchAggregations(SearchResponse sr){
        Map<String, List<Terms.Bucket>> aggregations=new HashMap<>();
        Terms categoryAggs=sr.getAggregations().get("category");
        if(categoryAggs!=null)
        aggregations.put("catBkts", (List<Terms.Bucket>) categoryAggs.getBuckets());
        Terms modelAggs=sr.getAggregations().get("models.type");
        if(modelAggs!=null)
        aggregations.put("modelBkts", (List<Terms.Bucket>) modelAggs.getBuckets());
        Terms editorAggs=sr.getAggregations().get("editors.type");
        if(editorAggs!=null)
        aggregations.put("editorBkts", (List<Terms.Bucket>) editorAggs.getBuckets());
        Terms deliveyAggs=sr.getAggregations().get("deliveries.type");
        if(deliveyAggs!=null)
        aggregations.put("deliveryBkts", (List<Terms.Bucket>) deliveyAggs.getBuckets());
        Terms guidesTargetLocusAggs=sr.getAggregations().get("guides.targetLocus");
        if(guidesTargetLocusAggs!=null)
            aggregations.put("guidesBkts", (List<Terms.Bucket>) guidesTargetLocusAggs.getBuckets());
        Terms typeAggs=sr.getAggregations().get("type");
        if(typeAggs!=null)
            aggregations.put("typeBkts", (List<Terms.Bucket>) typeAggs.getBuckets());

        Terms subtypeAggs=sr.getAggregations().get("subType");
        if(subtypeAggs!=null)
            aggregations.put("subtypeBkts", (List<Terms.Bucket>) subtypeAggs.getBuckets());
/***********************************************************************************************/
        Terms speciesAggs=sr.getAggregations().get("species");
        if(speciesAggs!=null)
            aggregations.put("speciesBkts", (List<Terms.Bucket>) speciesAggs.getBuckets());

        Terms targetAggs=sr.getAggregations().get("target");
        if(targetAggs!=null)
            aggregations.put("targetBkts", (List<Terms.Bucket>) targetAggs.getBuckets());

        Terms grnaLabIdAggs=sr.getAggregations().get("grnaLabId");
        if(targetAggs!=null)
            aggregations.put("grnaLabIdBkts", (List<Terms.Bucket>) grnaLabIdAggs.getBuckets());

        Terms withExperimentsAggs=sr.getAggregations().get("withExperiments");
        if(targetAggs!=null)
            aggregations.put("withExperimentsBkts", (List<Terms.Bucket>) withExperimentsAggs.getBuckets());

        //    List<Terms.Bucket> typeBkts=new ArrayList<>();
    //    List<Terms.Bucket> subtypeBkts=new ArrayList<>();
      /*   if(categoryAggs!=null)
        for(Terms.Bucket b:categoryAggs.getBuckets()){
         if(  b.getAggregations()!=null) {
              Terms typeAggs = b.getAggregations().get("type");
           //   System.out.println(b.getKey() + "\t" + b.getDocCount());
              if (typeAggs != null) {
                  typeBkts.addAll ((List<Terms.Bucket>) typeAggs.getBuckets());
                  for (Terms.Bucket bkt : typeAggs.getBuckets()) {
                      Terms subtypeAggs = bkt.getAggregations().get("subtype");
                      subtypeBkts.addAll ((List<Terms.Bucket>) subtypeAggs.getBuckets());
               //       System.out.println(bkt.getKey() + "_type" + "\t" + bkt.getDocCount() + "\tsubtypeAggsSize: " + subtypeAggs.getBuckets().size());

                  }
              }
          }
        }*/
      /*  aggregations.put("typeBkts", typeBkts);
        aggregations.put("subtypeBkts", subtypeBkts);*/
        return aggregations;
    }
    public  Map<String, List<Terms.Bucket>> getSearchAggregationsBKUP(SearchResponse sr){
        Map<String, List<Terms.Bucket>> aggregations=new HashMap<>();
        Terms categoryAggs=sr.getAggregations().get("category");
        aggregations.put("categoryAggs", (List<Terms.Bucket>) categoryAggs.getBuckets());
        for(Terms.Bucket b:categoryAggs.getBuckets()){
            if(  b.getAggregations()!=null) {
                Terms typeAggs = b.getAggregations().get("type");
                System.out.println(b.getKey() + "\t" + b.getDocCount());
                if (typeAggs != null) {
                    aggregations.put(b.getKey() + "TypeAggs", (List<Terms.Bucket>) typeAggs.getBuckets());
                    for (Terms.Bucket bkt : typeAggs.getBuckets()) {
                        Terms subtypeAggs = bkt.getAggregations().get("subtype");
                        aggregations.put(bkt.getKey() + "SubtypeAggs", (List<Terms.Bucket>) subtypeAggs.getBuckets());
                        System.out.println(bkt.getKey() + "_type" + "\t" + bkt.getDocCount() + "\tsubtypeAggsSize: " + subtypeAggs.getBuckets().size());

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

    public BoolQueryBuilder buildBoolQuery(String category, String searchTerm , Map<String, String> filterMap, boolean DCCNIHMember){
        BoolQueryBuilder q=new BoolQueryBuilder();
        q.must(buildQuery(searchTerm));
        if(category!=null && !category.equals("")) {
            q.filter(QueryBuilders.termQuery("category.keyword", category));
            if(filterMap!=null && filterMap.size()>0)
            for(String key:filterMap.keySet()){
                q.filter(QueryBuilders.termsQuery(key+".keyword", filterMap.get(key).split(",")));

            }

        }
        if(!DCCNIHMember) {
            q.filter(QueryBuilders.boolQuery().must(QueryBuilders.boolQuery().
                    should(QueryBuilders.termQuery("tier", 4)).should(QueryBuilders.termQuery("tier", 3))));
        }

   //    System.out.println(q);
        return q;
    }
    public SearchResponse getFilteredAggregations(String category, String searchTerm,
                                                  Map<String, String> filterMap,boolean DCCNIHMember) throws IOException {

        SearchSourceBuilder srb=new SearchSourceBuilder();
        if(filterMap.size()==1) {
            srb.query(this.buildBoolQuery(category, searchTerm, null, DCCNIHMember));
         //   srb.aggregation(this.buildSearchAggregations("category", category));
            System.out.println("IN FILTERED AGGS: field name:"+ filterMap.entrySet().iterator().next().getKey());
            srb.aggregation(this.buildFilterAggregations(filterMap.entrySet().iterator().next().getKey(), ""));
        }

     //   srb.highlighter(this.buildHighlights());
        srb.size(0);
        //  SearchRequest searchRequest=new SearchRequest("scge_search_test");
        SearchRequest searchRequest=new SearchRequest("scge_search_test");
        searchRequest.source(srb);

        return ESClient.getClient().search(searchRequest, RequestOptions.DEFAULT);

    }
    public QueryBuilder buildQuery(String searchTerm){
        DisMaxQueryBuilder q=new DisMaxQueryBuilder();
        if(searchTerm!=null && !searchTerm.equals("")) {
            q.add(QueryBuilders.
                    boolQuery()
                    .must(
                            QueryBuilders.multiMatchQuery(searchTerm,
                            "name", "type", "subType", "symbol",
                            "description", "experimentalTags", "externalId", "aliases",
                            "target", "species", "site", "sequence", "pam", "detectionMethod","target",
                            "name.ngram", "study.study",
                            "study.labName" ,
                            "study.pi"
                            ,"editors.type" ,
                            "editors.subType" ,
                            "editors.symbol" ,
                            "editors.alias" ,
                            "editors.species" ,
                            "editors.pamPreference" ,
                            "editors.substrateTarget" ,
                            "editors.activity" ,
                            "editors.fusion" ,
                            "editors.dsbCleavageType" ,
                            "editors.source" ,
                            "deliveries.type" ,
                            "deliveries.name" ,
                            "deliveries.source" ,
                            "deliveries.description" ,
                            "models.type" ,
                            "models.name" ,
                            "models.organism" ,
                            "models.transgene" ,
                            "models.transgeneReporter" ,
                            "models.description" ,
                            "models.strainCode").type(MultiMatchQueryBuilder.Type.CROSS_FIELDS).operator(Operator.AND)).filter(
                            QueryBuilders.termQuery("category.keyword", "Experiment")
                    )).boost(100);
          q.add(QueryBuilders.multiMatchQuery(searchTerm, "name", "type", "subType", "symbol",
                    "description", "experimentalTags", "externalId", "aliases",
                    "target", "species", "site", "sequence", "pam", "detectionMethod","target",
                        "name.ngram",
                            "study.study",
                            "study.labName" ,
                            "study.pi"
                    ,       "editors.type" ,
                            "editors.subType" ,
                            "editors.symbol" ,
                            "editors.alias" ,
                            "editors.species" ,
                            "editors.pamPreference" ,
                            "editors.substrateTarget" ,
                            "editors.activity" ,
                            "editors.fusion" ,
                            "editors.dsbCleavageType" ,
                            "editors.source" ,
                            "deliveries.type" ,
                            "deliveries.name" ,
                            "deliveries.source" ,
                            "deliveries.description" ,
                            "models.type" ,
                            "models.name" ,
                            "models.organism" ,
                            "models.transgene" ,
                            "models.transgeneReporter" ,
                            "models.description" ,
                            "models.strainCode").type(MultiMatchQueryBuilder.Type.BEST_FIELDS).fuzziness(1).operator(Operator.AND).boost(20));
            q.add(QueryBuilders.multiMatchQuery(searchTerm, "name", "type", "subType", "symbol",
                    "description", "experimentalTags", "externalId", "aliases",
                    "target", "species", "site", "sequence", "pam", "detectionMethod","target",
                    "name.ngram",
                    "study.study",
                    "study.labName" ,
                    "study.pi"
                    ,       "editors.type" ,
                    "editors.subType" ,
                    "editors.symbol" ,
                    "editors.alias" ,
                    "editors.species" ,
                    "editors.pamPreference" ,
                    "editors.substrateTarget" ,
                    "editors.activity" ,
                    "editors.fusion" ,
                    "editors.dsbCleavageType" ,
                    "editors.source" ,
                    "deliveries.type" ,
                    "deliveries.name" ,
                    "deliveries.source" ,
                    "deliveries.description" ,
                    "models.type" ,
                    "models.name" ,
                    "models.organism" ,
                    "models.transgene" ,
                    "models.transgeneReporter" ,
                    "models.description" ,
                    "models.strainCode").type(MultiMatchQueryBuilder.Type.PHRASE_PREFIX).boost(10));
        }else{
            q.add(QueryBuilders.matchAllQuery());
        }
        return q;
    }

}
