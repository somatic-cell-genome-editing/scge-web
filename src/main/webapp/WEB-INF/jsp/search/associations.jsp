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
<%if( hit.get("category").toString().equalsIgnoreCase("Experiment") && !hit.get("category").toString().equalsIgnoreCase("Publication")){%>
<div style="padding-top: 1%">

    <details>
        <summary>Show Project</summary>
        <ul>
            <%for(Map.Entry entry:studyNames.entrySet()){%>
            <li><a class="search-results-anchor" href="/toolkit/data/experiments/study/<%=entry.getKey()%>"><%=entry.getValue()%></a>
            </li>

            <%}%>
        </ul>

    </details>

</div>

<%}}%>
<%  if(experimentNames.size()>0 && !hit.get("category").toString().equalsIgnoreCase("Publication")){%>
<div style="padding-top: 1%">

    <details>
        <summary>Show Experiments (<%=experimentNames.size()%>)</summary>
        <ul>

            <%for(Map.Entry entry:experimentNames.entrySet()){%>

            <li><a class="search-results-anchor" href="/toolkit/data/experiments/experiment/<%=entry.getKey()%>"><%=entry.getValue()%></a>
            </li>

            <%}%>

        </ul>

    </details>

</div>
<%}%>

