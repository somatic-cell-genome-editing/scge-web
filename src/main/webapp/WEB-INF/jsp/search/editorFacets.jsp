<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 6/28/2022
  Time: 12:24 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:forEach items="${aggregations}" var="agg">

<%--    <c:if test="${fn:length(agg.value.buckets)>0 && agg.key=='initiative' && category=='Genome Editor'}">--%>
<%--        <div class="accordion-group">--%>
<%--        <div class="pl-3  accordion-heading card-header">--%>
<%--        <c:forEach items="${agg.value.buckets}" var="bkt">--%>
<%--            <c:if test="${bkt.key=='Genome Editors'}">--%>
<%--                <div class="form-check">--%>
<%--                    <input class="form-check-input" type="checkbox" name="${agg.key}" value="${bkt.key}" id="${bkt.key}">--%>
<%--                    <label class="form-check-label" for="${bkt.key}">--%>
<%--                        <strong>SCGE Program Funded Editors</strong>&nbsp;(${bkt.docCount})--%>
<%--                    </label>--%>
<%--                </div>--%>
<%--            </c:if>--%>
<%--        </c:forEach>--%>
<%--        </div>--%>
<%--        </div>--%>
<%--    </c:if>--%>
    <c:if test="${fn:length(agg.value.buckets)>0 && agg.key=='editorType'}">
        <div class="accordion-group">
            <div class="pl-3  accordion-heading card-header">
                <a class="accordion-toggle  search-results-anchor" data-toggle="collapse" href="#collapse${agg.key}">
                        ${facets.get(agg.key)}<span class="float-right"><i class="fas fa-angle-up"></i></span>
                </a>
            </div>
            <div id="collapse${agg.key}" class="accordion-body collapse show">
                <div class="pl-3  accordion-inner">
                    <c:forEach items="${agg.value.buckets}" var="bkt">
                        <c:if test="${bkt.key!=''}">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="${agg.key}" value="${bkt.key}" id="${bkt.key}">
                            <label class="form-check-label" for="${bkt.key}">
                                    ${bkt.key}&nbsp;(${bkt.docCount})
                            </label>
                        </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
</c:forEach>
<c:forEach items="${aggregations}" var="agg">
    <c:if test="${fn:length(agg.value.buckets)>0 && agg.key=='editorSubType'}">
        <div class="accordion-group">
            <div class="pl-3  accordion-heading card-header">
                <a class="accordion-toggle  search-results-anchor" data-toggle="collapse" href="#collapse${agg.key}">
                        ${facets.get(agg.key)}<span class="float-right"><i class="fas fa-angle-up"></i></span>
                </a>
            </div>
            <div id="collapse${agg.key}" class="accordion-body collapse show">
                <div class="pl-3  accordion-inner">
                    <c:forEach items="${agg.value.buckets}" var="bkt">
                        <c:if test="${bkt.key!=''}">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="${agg.key}" value="${bkt.key}" id="${bkt.key}">
                            <label class="form-check-label" for="${bkt.key}">
                                    ${bkt.key}&nbsp;(${bkt.docCount})
                            </label>
                        </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
</c:forEach>
<c:forEach items="${aggregations}" var="agg">
    <c:if test="${fn:length(agg.value.buckets)>0 && agg.key=='editorSpecies'}">
        <div class="accordion-group">
            <div class="pl-3  accordion-heading card-header">
                <a class="accordion-toggle  search-results-anchor" data-toggle="collapse" href="#collapse${agg.key}">
                        ${facets.get(agg.key)}<span class="float-right"><i class="fas fa-angle-up"></i></span>
                </a>
            </div>
            <div id="collapse${agg.key}" class="accordion-body collapse show">
                <div class="pl-3  accordion-inner">
                    <c:forEach items="${agg.value.buckets}" var="bkt">
                        <c:if test="${bkt.key!=''}">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="${agg.key}" value="${bkt.key}" id="${bkt.key}">
                            <label class="form-check-label" for="${bkt.key}">
                                    ${bkt.key}&nbsp;(${bkt.docCount})
                            </label>
                        </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
</c:forEach>