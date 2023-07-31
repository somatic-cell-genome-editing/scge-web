<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 7/18/2023
  Time: 9:28 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<c:forEach items="${aggregations}" var="agg">
  <c:if test="${fn:length(agg.value.buckets)>0 && agg.key=='initiative'}">
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
  <c:if test="${fn:length(agg.value.buckets)>0 && agg.key=='pi'}">
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
                <c:set var="lastName" value="${fn:substring(bkt.key, 0,fn:indexOf(bkt.key, ' '))}"/>
                <c:set var="firstName" value="${fn:substring(bkt.key,fn:indexOf(bkt.key, ' '),fn:length(bkt.key))}"/>

                <label class="form-check-label" for="${bkt.key}">
                    ${lastName},${firstName}&nbsp;(${bkt.docCount})
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
  <c:if test="${fn:length(agg.value.buckets)>0 && agg.key=='experimentType'}">
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
  <c:if test="${fn:length(agg.value.buckets)>0 && agg.key=='modelType'}">
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
  <c:if test="${fn:length(agg.value.buckets)>0 && agg.key=='modelOrganism'}">
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
  <c:if test="${fn:length(agg.value.buckets)>0 && agg.key=='experimentName'}">
    <div class="accordion-group">
      <div class="pl-3  accordion-heading card-header">
        <a class="accordion-toggle  search-results-anchor" data-toggle="collapse" href="#collapse${agg.key}">
            ${facets.get(agg.key)}<span class="float-right"><i class="fas fa-angle-up"></i></span>
        </a>
      </div>
      <div id="collapse${agg.key}" class="accordion-body collapse">
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