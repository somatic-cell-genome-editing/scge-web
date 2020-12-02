package edu.mcw.scge.service.es;

import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.AggregationBuilder;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.BucketOrder;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.builder.SearchSourceBuilder;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class IndexServices {
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
}
