<% Map<Long, String> studyNames= new TreeMap<>();
    Map<Long,String> experimentNames=new TreeMap<>();
    if(hit.get("studyNames")!=null) {
        Map<Long, String> studyMap=  (Map<Long, String>) hit.get("studyNames");
        for(Map.Entry entry:studyMap.entrySet()){
            studyNames.put(Long.parseLong( entry.getKey().toString()),(String) entry.getValue());
        }

    }
    if(hit.get("experimentNames")!=null){
        Map<Long, String> expMap=(Map<Long, String>) hit.get("experimentNames");
        for(Map.Entry entry:expMap.entrySet()){
            experimentNames.put(Long.parseLong( entry.getKey().toString()),(String) entry.getValue());
        }
    }
    if(studyNames.size()>0 || experimentNames.size()>0){%>
<%if( hit.get("category").toString().equalsIgnoreCase("Experiment")){%>
<div style="padding-top: 1%">

    <details>
        <summary>Show Project</summary>
        <p>
            <%for(Map.Entry entry:studyNames.entrySet()){%>
            <span style="margin-left: 2%;"><a class="search-results-anchor" href="/toolkit/data/experiments/study/<%=entry.getKey()%>"><%=entry.getValue()%></a></span>
            <br>

            <%}%>
        </p>

    </details>

</div>

<%}}%>
<%  if(experimentNames.size()>0){%>
<div style="padding-top: 1%">

    <details>
        <summary>Show Experiments (<%=experimentNames.size()%>)</summary>
        <p>

            <%for(Map.Entry entry:experimentNames.entrySet()){%>

            <span style="margin-left: 2%;"><a class="search-results-anchor" href="/toolkit/data/experiments/experiment/<%=entry.getKey()%>"><%=entry.getValue()%></a></span>
            <br>

            <%}%>

        </p>

    </details>

</div>
<%}%>

