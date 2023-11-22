<%@ page import="org.elasticsearch.search.fetch.subphase.highlight.HighlightField" %>
<%@ page import="org.elasticsearch.common.text.Text" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/14/2021
  Time: 9:11 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div  class="more hideContent" style="overflow-y: auto">
    <span class="header"><strong>Matched Fields:</strong></span>
   <% if(searchHit.getHighlightFields()!=null){
       Set<String> keys=new HashSet<>();
       Map<String, HighlightField> hf=searchHit.getHighlightFields();
        for(String key:hf.keySet()){
            if(!key.contains("accessLevel")){
                if(key.contains(".")){
                    String duplicateKey=key.substring(0, key.indexOf("."));
                    if(!keys.contains(duplicateKey)){
                        keys.add(duplicateKey);
                        %>
                        <b><%=duplicateKey%>&nbsp;:</b>
                        <% for(Text fragment: hf.get(key).getFragments()){%>
                            <%=fragment%>

                        <%}%>
                    <%}else{

                    }%>

               <% }else{
                    if(!keys.contains(key)) {
                        keys.add(key);%>
                            <b><%=key%>&nbsp;:</b>
                        <% for(Text fragment: hf.get(key).getFragments()){%>
                                <%=fragment%>

                        <%}%>
                   <% }
                }

            }

   %>

    <%}}%>

</div>
