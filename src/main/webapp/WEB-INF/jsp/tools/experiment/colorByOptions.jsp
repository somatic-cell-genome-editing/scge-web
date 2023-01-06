<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 1/5/2023
  Time: 4:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%
    List<String> options = new ArrayList<>();
    if(plots.size()>1)
        options.add("Condition");
    options.add("None");

    if (tableColumns.get("tissueTerm") !=null && ( (List<String>)tableColumns.get("tissueTerm")).size()>1
            && ( (List<String>)tableColumns.get("tissueTerm")).size()!=records.size()) {
        options.add("Tissue");
    }
    if (tableColumns.get("cellTypeTerm") !=null && ( (List<String>)tableColumns.get("cellTypeTerm")).size()>1
            && ( (List<String>)tableColumns.get("cellTypeTerm")).size()!=records.size()) {
        options.add("Cell Type");
    }
    if (tableColumns.get("sex") !=null && ( (List<String>)tableColumns.get("sex")).size()>1
            && ( (List<String>)tableColumns.get("sex")).size()!=records.size()) {
        options.add("Sex");
    }
    if (tableColumns.get("editorSymbol") !=null && ( (List<String>)tableColumns.get("editorSymbol")).size()>1
            && ( (List<String>)tableColumns.get("editorSymbol")).size()!=records.size()) {
        options.add("Editor");
    }
    if (tableColumns.get("hrDonor") !=null && ( (List<String>)tableColumns.get("hrDonor")).size()>1
            && ( (List<String>)tableColumns.get("hrDonor")).size()!=records.size()) {
        options.add("Hr Donor");
    }
    if (tableColumns.get("modalDisplayName") !=null && ( (List<String>)tableColumns.get("modalDisplayName")).size()>1
            && ( (List<String>)tableColumns.get("modalDisplayName")).size()!=records.size()) {
        options.add("Model");
    }
    if (tableColumns.get("deliverySystemName") !=null && ( (List<String>)tableColumns.get("deliverySystemName")).size()>1
            && ( (List<String>)tableColumns.get("deliverySystemName")).size()!=records.size()) {
        options.add("Delivery System");
    }
    if (tableColumns.get("targetLocus") !=null && ( (List<String>)tableColumns.get("targetLocus")).size()>1
            && ( (List<String>)tableColumns.get("targetLocus")).size()!=records.size()) {
        options.add("Target Locus");
    }
    if (tableColumns.get("guide") !=null && ( (List<String>)tableColumns.get("guide")).size()>1
            && ( (List<String>)tableColumns.get("guide")).size()!=records.size()) {
        options.add("Guide");
    }
    if (tableColumns.get("vector") !=null && ( (List<String>)tableColumns.get("vector")).size()>1
            && ( (List<String>)tableColumns.get("vector")).size()!=records.size()) {
        options.add("Vector");
    }
    if (tableColumns.get("units") !=null && ( (List<String>)tableColumns.get("units")).size()>1
            && ( (List<String>)tableColumns.get("units")).size()!=records.size()) {
        //    options.add("Units");
    }%>
