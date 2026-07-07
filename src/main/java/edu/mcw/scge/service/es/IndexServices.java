package edu.mcw.scge.service.es;

import co.elastic.clients.elasticsearch._types.FieldValue;
import co.elastic.clients.elasticsearch._types.SortOrder;
import co.elastic.clients.elasticsearch._types.aggregations.Aggregate;
import co.elastic.clients.elasticsearch._types.aggregations.Aggregation;
import co.elastic.clients.elasticsearch._types.aggregations.LongTermsBucket;
import co.elastic.clients.elasticsearch._types.aggregations.StringTermsBucket;
import co.elastic.clients.elasticsearch._types.query_dsl.Operator;
import co.elastic.clients.elasticsearch._types.query_dsl.Query;
import co.elastic.clients.elasticsearch._types.query_dsl.TextQueryType;
import co.elastic.clients.elasticsearch.core.SearchRequest;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import co.elastic.clients.elasticsearch.core.search.Highlight;
import co.elastic.clients.elasticsearch.core.search.HighlightField;
import co.elastic.clients.elasticsearch.core.search.Hit;
import co.elastic.clients.util.NamedValue;
import com.google.gson.Gson;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.web.SCGEContext;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@SuppressWarnings({"rawtypes", "unchecked"})
public class IndexServices {
    private static String searchIndex;
    Gson gson=new Gson();
    Access access=new Access();

    public SearchResponse<Map> getSearchResults(List<String> categories, String searchTerm, Map<String, String> filterMap, boolean DCCNIHMember, boolean consortiumMember) throws IOException {
        searchIndex= SCGEContext.getESIndexName();
        SearchRequest.Builder srb=new SearchRequest.Builder();
        srb.index(searchIndex);
        srb.query(this.buildBoolQuery(categories, searchTerm, filterMap, DCCNIHMember, consortiumMember));
        srb.aggregations("category", this.buildSearchAggregations("category"));
        this.addAggregations(srb, categories);
        srb.highlight(this.buildHighlights());
        srb.size(10000);
        if(searchTerm.equals("") && categories!=null && categories.size()==1 && (categories.get(0).equalsIgnoreCase("Project")|| categories.get(0).equalsIgnoreCase("Experiment"))){
            try {
                srb.sort(s -> s.field(f -> f.field("lastModifiedDate").order(SortOrder.Desc)));
            }catch (Exception exception){}
        }else{
            if(searchTerm.equals("")) {
                srb.sort(s -> s.field(f -> f.field("name.keyword")));
            }
        }
        return ESClient.getClient().search(srb.build(), Map.class);
    }

    public void addAggregations(SearchRequest.Builder srb, List<String> categories){
        srb.aggregations("editorType", this.buildSearchAggregations("editorType"));
        srb.aggregations("editorSubType", this.buildSearchAggregations("editorSubType"));
        srb.aggregations("editorSpecies", this.buildSearchAggregations("editorSpecies"));

        srb.aggregations("modelType", this.buildSearchAggregations("modelType"));
        srb.aggregations("modelSubtype", this.buildSearchAggregations("modelSubtype"));
        srb.aggregations("modelOrganism", this.buildSearchAggregations("modelOrganism"));

        srb.aggregations("transgeneReporter", this.buildSearchAggregations("transgeneReporter"));

        srb.aggregations("deliveryType", this.buildSearchAggregations("deliveryType"));
        srb.aggregations("deliverySubtype", this.buildSearchAggregations("deliverySubtype"));
        srb.aggregations("deliverySpecies", this.buildSearchAggregations("deliverySpecies"));
        srb.aggregations("tissueTerm", this.buildSearchAggregations("tissueTerm"));
        srb.aggregations("guideSpecies", this.buildSearchAggregations("guideSpecies"));
        srb.aggregations("guideCompatibility", this.buildSearchAggregations("guideCompatibility"));
        srb.aggregations("guideTargetLocus", this.buildSearchAggregations("guideTargetLocus"));

        srb.aggregations("vectorType", this.buildSearchAggregations("vectorType"));
        srb.aggregations("vectorSubtype", this.buildSearchAggregations("vectorSubtype"));
        srb.aggregations("experimentType", this.buildSearchAggregations("experimentType"));

        srb.aggregations("experimentName", this.buildSearchAggregations("experimentName"));

        srb.aggregations("pi", this.buildSearchAggregations("pi"));
        srb.aggregations("initiative", this.buildSearchAggregations("initiative"));
        srb.aggregations("studyType", this.buildSearchAggregations("studyType"));
    }

    public Highlight buildHighlights(){
        List<String> fields = new ArrayList<>(searchFields());
        Highlight.Builder hb=new Highlight.Builder();
        for(String field:fields){
            hb.fields(NamedValue.of(field, HighlightField.of(f -> f)));
        }
        hb.fields(NamedValue.of("*", HighlightField.of(f -> f)));
        return hb.build();
    }

    public Aggregation buildAggregations(String fieldName){
        if(fieldName.equalsIgnoreCase("organism")){
            return Aggregation.of(a -> a
                    .aggregations("animalModels", sub -> sub.terms(t -> t.field("animalModels.keyword")))
                    .terms(t -> t.field(fieldName+".keyword").order(NamedValue.of("_key", SortOrder.Asc)))
            );
        }
        return Aggregation.of(a -> a.terms(t -> t.field(fieldName+".keyword").order(NamedValue.of("_key", SortOrder.Asc))));
    }

    public Aggregation buildSearchAggregations(String fieldName){
        String field;
        if(fieldName!=null && !fieldName.equalsIgnoreCase("category") && !fieldName.equals("")){
            field=fieldName;
        }else {
            field="category";
        }
        return Aggregation.of(a -> a.terms(t -> t.field(field+".keyword").size(1000).order(NamedValue.of("_key", SortOrder.Asc))));
    }

    public Aggregation buildFilterAggregations(String fieldName, String selectedCategory){
        return Aggregation.of(a -> a.terms(t -> t.field(fieldName+".keyword").size(1000).order(NamedValue.of("_key", SortOrder.Asc))));
    }

    /**
     * Builds the view model the JSPs consume for hit rendering. Each entry is the hit's source map
     * (same shape as the old getSourceAsMap()) augmented with a "_highlights" entry holding the
     * highlight fragments (field -> list of highlighted fragment strings).
     */
    public List<Map<String, Object>> getHits(SearchResponse<Map> sr){
        List<Map<String, Object>> results=new ArrayList<>();
        for(Hit<Map> hit: sr.hits().hits()){
            Map<String, Object> source=hit.source();
            Map<String, Object> row= (source!=null) ? new LinkedHashMap<>(source) : new LinkedHashMap<>();
            row.put("_highlights", hit.highlight());
            results.add(row);
        }
        return results;
    }

    /**
     * Builds the aggregation view model the facet JSPs consume via EL. Shape:
     * aggName -> { "buckets": [ { "key": String, "docCount": long }, ... ] }
     * This nested-map structure preserves the existing EL (agg.value.buckets, bkt.key, bkt.docCount).
     */
    public Map<String, Object> getAggregationView(SearchResponse<Map> sr){
        Map<String, Object> view=new LinkedHashMap<>();
        if(sr.aggregations()==null) return view;
        for(Map.Entry<String, Aggregate> e: sr.aggregations().entrySet()){
            List<Map<String, Object>> buckets=new ArrayList<>();
            Aggregate agg=e.getValue();
            if(agg.isSterms()){
                for(StringTermsBucket b: agg.sterms().buckets().array()){
                    Map<String, Object> bkt=new LinkedHashMap<>();
                    bkt.put("key", b.key().stringValue());
                    bkt.put("docCount", b.docCount());
                    buckets.add(bkt);
                }
            }else if(agg.isLterms()){
                for(LongTermsBucket b: agg.lterms().buckets().array()){
                    Map<String, Object> bkt=new LinkedHashMap<>();
                    bkt.put("key", b.key());
                    bkt.put("docCount", b.docCount());
                    buckets.add(bkt);
                }
            }
            Map<String, Object> aggMap=new LinkedHashMap<>();
            aggMap.put("buckets", buckets);
            view.put(e.getKey(), aggMap);
        }
        return view;
    }

    public Query buildBoolQuery(List<String> categories, String searchTerm , Map<String, String> filterMap, boolean DCCNIHMember, boolean consortiumMember){
        co.elastic.clients.elasticsearch._types.query_dsl.BoolQuery.Builder q=new co.elastic.clients.elasticsearch._types.query_dsl.BoolQuery.Builder();
        q.must(buildQuery(searchTerm));

        if(!DCCNIHMember && consortiumMember ) {
            q.filter(Query.of(f -> f.term(t -> t.field("accessLevel.keyword").value("consortium"))));
            q.filter(Query.of(f -> f.bool(bb -> bb
                    .must(m -> m.bool(inner -> inner
                            .should(s -> s.term(t -> t.field("tier").value(4)))
                            .should(s -> s.term(t -> t.field("tier").value(3))))))));
        }
        if(!consortiumMember){
            q.filter(Query.of(f -> f.term(t -> t.field("accessLevel.keyword").value("public"))));
            q.filter(Query.of(f -> f.term(t -> t.field("tier").value(4))));
        }

        if(DCCNIHMember ){
            q.filter(Query.of(f -> f.term(t -> t.field("accessLevel.keyword").value("consortium"))));
        }
        if( categories!=null && categories.size()>0) {
            List<FieldValue> values=categories.stream().map(c -> FieldValue.of(c)).collect(Collectors.toList());
            q.filter(Query.of(f -> f.terms(t -> t.field("category.keyword").terms(tf -> tf.value(values)))));
        }
        if(filterMap!=null && filterMap.size()>0)
            for(String key:filterMap.keySet()){
                List<FieldValue> values=Arrays.stream(filterMap.get(key).split(",")).map(v -> FieldValue.of(v)).collect(Collectors.toList());
                q.filter(Query.of(f -> f.terms(t -> t.field(key+".keyword").terms(tf -> tf.value(values)))));
            }

        return Query.of(query -> query.bool(q.build()));
    }

    public SearchResponse<Map> getFilteredAggregations(List<String> categories, String searchTerm,
                                                       Map<String, String> filterMap, boolean DCCNIHMember, boolean consortiumMember) throws IOException {
        searchIndex= SCGEContext.getESIndexName();
        SearchRequest.Builder srb=new SearchRequest.Builder();
        srb.index(searchIndex);
        srb.query(this.buildBoolQuery(categories, searchTerm, null, DCCNIHMember, consortiumMember));

        if(filterMap.size()==1) {
            String key=filterMap.entrySet().iterator().next().getKey();
            srb.aggregations(key.replace(".type", "").trim(), this.buildFilterAggregations(key, ""));
        }
        srb.aggregations("category", this.buildAggregations("category"));

        srb.size(0);
        return ESClient.getClient().search(srb.build(), Map.class);
    }

    public Query buildQuery(String term){
        List<Query> queries=new ArrayList<>();

        if(term!=null && !term.equals("")) {
            String searchTerm=term.toLowerCase().trim();
            if(searchTerm.contains(" and ")){
                String searchString=String.join(" ", searchTerm.split(" and "));
                queries.add(Query.of(q -> q.multiMatch(mm -> mm.query(searchString)
                        .type(TextQueryType.CrossFields)
                        .operator(Operator.And)
                        .analyzer("stop"))));
                queries.add(Query.of(q -> q.multiMatch(mm -> mm.query(searchString)
                        .type(TextQueryType.Phrase)
                        .analyzer("stop")
                        .boost(1000f))));
            }else if(searchTerm.contains(" or ")){
                String searchString=String.join(" ", searchTerm.split(" or "));
                queries.add(Query.of(q -> q.multiMatch(mm -> mm.query(searchString)
                        .type(TextQueryType.CrossFields)
                        .operator(Operator.Or)
                        .analyzer("stop"))));
            }else if(!searchTerm.contains(" and ") && searchTerm.contains(" ") ) {
                queries.add(Query.of(q -> q.multiMatch(mm -> mm.query(searchTerm)
                        .type(TextQueryType.CrossFields)
                        .operator(Operator.And))));
                queries.add(Query.of(q -> q.multiMatch(mm -> mm.query(searchTerm)
                        .type(TextQueryType.Phrase)
                        .operator(Operator.And)
                        .analyzer("stop")
                        .boost(1000f))));
            }else {
                if (isNumeric(searchTerm)) {
                    queries.add(Query.of(q -> q.term(t -> t.field("id").value(searchTerm))));
                    queries.add(Query.of(q -> q.term(t -> t.field("studyId").value(searchTerm))));
                    queries.add(Query.of(q -> q.term(t -> t.field("studyIds").value(searchTerm))));
                } else {
                    List<String> sf=searchFields();
                    queries.add(Query.of(q -> q.multiMatch(mm -> mm.query(searchTerm).fields(sf)
                            .type(TextQueryType.Phrase)
                            .analyzer("stop"))));
                    queries.add(Query.of(q -> q.multiMatch(mm -> mm.query(searchTerm).fields(sf)
                            .type(TextQueryType.CrossFields)
                            .operator(Operator.And)
                            .analyzer("stop"))));
                }
            }

            queries.add(Query.of(q -> q.term(t -> t.field("symbol.custom").value(searchTerm).boost(1000f))));
            queries.add(Query.of(q -> q.term(t -> t.field("name.custom").value(searchTerm).boost(1000f))));
            queries.add(Query.of(q -> q.term(t -> t.field("pi").value(searchTerm).boost(1000f))));

            queries.add(Query.of(q -> q.matchPhrase(mp -> mp.field("symbol").query(searchTerm).boost(400f))));
            queries.add(Query.of(q -> q.matchPhrase(mp -> mp.field("name").query(searchTerm).boost(400f))));

            queries.add(Query.of(q -> q.matchPhrasePrefix(mp -> mp.field("symbol.custom").query(searchTerm).boost(100f))));
            queries.add(Query.of(q -> q.matchPhrasePrefix(mp -> mp.field("name.custom").query(searchTerm).boost(100f))));

            queries.add(Query.of(q -> q.matchPhrasePrefix(mp -> mp.field("pi").query(searchTerm).boost(500f))));
            queries.add(Query.of(q -> q.matchPhrase(mp -> mp.field("pi").query(searchTerm).boost(200f))));
            queries.add(Query.of(q -> q.term(t -> t.field("currentGrantNumber.keyword").value(searchTerm))));
            queries.add(Query.of(q -> q.term(t -> t.field("formerGrantNumbers.keyword").value(searchTerm))));
            queries.add(Query.of(q -> q.term(t -> t.field("description").value(searchTerm))));
            queries.add(Query.of(q -> q.term(t -> t.field("articleIds.id.keyword").value(searchTerm).caseInsensitive(true))));
            queries.add(Query.of(q -> q.term(t -> t.field("authorList.lastName.keyword").value(searchTerm).caseInsensitive(true))));
            queries.add(Query.of(q -> q.term(t -> t.field("authorList.firstName.keyword").value(searchTerm).caseInsensitive(true))));

        }else{
            queries.add(Query.of(q -> q.matchAll(m -> m)));
        }

        return Query.of(q -> q.disMax(d -> d.queries(queries)));
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
