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
    public SearchResponse getSearchResults(String category, String searchTerm, String type, String subType, boolean DCCNIHMember) throws IOException {

        SearchSourceBuilder srb=new SearchSourceBuilder();
        System.out.println(searchTerm);
        srb.query(this.buildBoolQuery(category, searchTerm, type, subType, DCCNIHMember));
        srb.aggregation(this.buildSearchAggregations("category"));
        srb.highlighter(this.buildHighlights());
        srb.size(1000);
    //  SearchRequest searchRequest=new SearchRequest("scge_search_test");
       SearchRequest searchRequest=new SearchRequest("scge_search_prod");
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
    public AggregationBuilder buildSearchAggregations(String fieldName){
        AggregationBuilder aggs= null;
        if(fieldName==null)
            fieldName="category";
        aggs= AggregationBuilders.terms(fieldName).field(fieldName+".keyword")
                .subAggregation(AggregationBuilders.terms("type").field("type.keyword")
                .subAggregation(AggregationBuilders.terms("subtype").field("subType.keyword")))
                .order(BucketOrder.key(true));

        return aggs;
    }
    public  Map<String, List<Terms.Bucket>> getSearchAggregations(SearchResponse sr){
        Map<String, List<Terms.Bucket>> aggregations=new HashMap<>();
        Terms categoryAggs=sr.getAggregations().get("category");
        aggregations.put("categoryAggs", (List<Terms.Bucket>) categoryAggs.getBuckets());
        for(Terms.Bucket b:categoryAggs.getBuckets()){
           Terms typeAggs= b.getAggregations().get("type");
          System.out.println(b.getKey() + "\t"+ b.getDocCount());
           aggregations.put(b.getKey()+"TypeAggs", (List<Terms.Bucket>) typeAggs.getBuckets());
           for(Terms.Bucket bkt: typeAggs.getBuckets()) {
               Terms subtypeAggs = bkt.getAggregations().get("subtype");
               aggregations.put(bkt.getKey() + "SubtypeAggs", (List<Terms.Bucket>) subtypeAggs.getBuckets());
               System.out.println(bkt.getKey() + "_type" + "\t" + bkt.getDocCount() +"\tsubtypeAggsSize: "+subtypeAggs.getBuckets().size());

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

    public BoolQueryBuilder buildBoolQuery(String category, String searchTerm , String type, String subType, boolean DCCNIHMember){
        BoolQueryBuilder q=new BoolQueryBuilder();
        q.must(buildQuery(searchTerm));
        if(category!=null && !category.equals("")) {
            q.filter(QueryBuilders.termQuery("category.keyword", category));

            if (type != null && !type.equals("")) {
                q.filter(QueryBuilders.termQuery("type.keyword", type));
            }
            if (subType != null && !subType.equals("")) {
                q.filter(QueryBuilders.termQuery("subType.keyword", subType));
            }
        }
        if(!DCCNIHMember) {
            q.filter(QueryBuilders.boolQuery().must(QueryBuilders.boolQuery().
                    should(QueryBuilders.termQuery("tier", 4)).should(QueryBuilders.termQuery("tier", 3))));
        }
        System.out.println(q);
        return q;
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
                            "models.strainCode").type(MultiMatchQueryBuilder.Type.BEST_FIELDS).operator(Operator.AND));
        }else{
            q.add(QueryBuilders.matchAllQuery());
        }
        return q;
    }

}
