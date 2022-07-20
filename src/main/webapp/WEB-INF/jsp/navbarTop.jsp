<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 7/20/2022
  Time: 2:39 PM
  To change this template use File | Settings | File Templates.
--%>
<nav class="navbar navbar-expand-lg flex-md-nowrap p-0 shadow" style="background-color: black" >
    <a class="navbar-brand col-md-3 col-lg-2 mr-0 px-3" href="/toolkit/loginSuccess">
        <img src="/toolkit/images/scge-logo-70w.png" width="70" height="50" ></a>
    <!--div class="input-group col-sm-4"-->
    <form class="form-inline" action="/toolkit/data/search/results" >

        <div class="input-group"  style="padding-top:2%;width: 100%">
            <input  class="form-control form-control-sm border-secondary" type="search" id="commonSearchTerm" name="searchTerm" placeholder="Enter Search Term ...." value=""/>
            <div class="input-group-append">
                <button class="btn btn-outline-secondary btn-sm" type="submit" >
                    <i class="fa fa-search"></i>
                </button>
            </div>

        </div>

        <small class="form-text text-light" style="font-size: 11px;">Examples:&nbsp;<a class="text-light" style="font-size: 11px;" href="/toolkit/data/search/results?searchTerm=Epithelium">Epithelium</a>, <a class="text-light" href="/toolkit/data/search/results?searchTerm=crispr" style="font-size: 11px;" >CRISPR</a>,
            <a class="text-light" style="font-size: 11px;" href="/toolkit/data/search/results?searchTerm=aav" >AAV</a>, <a class="text-light" style="font-size: 11px;" href="/toolkit/data/search/results?searchTerm=ai9" >Ai9</a>
        </small>
    </form>
    <!--/div-->

    <ul class="navbar-nav ml-auto" style="padding-right: 2%">

        <c:if test="${userAttributes.get('name')!=null}">

            <li class="nav-item text-nowrap">   <a class="nav-link" href="/toolkit/db?destination=base" style="font-weight: 400;font-size: 16px;color:#FFFFFF"><i class="fas fa-th"></i>&nbsp;My&nbsp;Dashboard</a></li>
            <%if(access.isAdmin(person)){%>
            <li class="nav-item dropdown text-nowrap">
                <a class="nav-link dropdown-toggle" href="/toolkit/admin" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="font-weight: 400;font-size: 16px;color:#FFFFFF">
                    <i class="fas fa-th"></i>&nbsp;Admin
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="/toolkit/admin/users">Manage Users</a>
                    <a class="dropdown-item" href="/toolkit/admin">Sudo User</a>
                    <a class="dropdown-item" href="/toolkit/admin/groupOverview">Groups Overview</a>
                    <a class="dropdown-item" href="/toolkit/data/studies/search">Study Browser</a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="/toolkit/admin/studyTierUpdates">Study Tier Updates</a>
                </div>
            </li>
            <%}%>
            <!--li class="nav-item" style="padding-top: 5px"><a href="/toolkit/data/dataSubmission"><button type="button" class="btn btn-sm">Upload Docs</button></a>
            </li-->
        </c:if>

        <li class="nav-item text-nowrap my-2 my-sm-0" style="padding-right: 1%">

            <!-- using pageContext requires jsp-api artifact in pom.xml -->
            <c:choose>
                <c:when test="${userAttributes.get('name')!=null}">
                    <img class="rounded-circle" src="${userAttributes.get('picture')}" width="24">
                    <span class="text-light" >&nbsp;${userAttributes.get('name')}&nbsp;&nbsp;</span>
                    <a href="/toolkit/logout" title="Sign out"><button class="btn btn-primary btn-sm">Logout</button></a>

                </c:when>
                <c:otherwise>
                    <a href="/toolkit/login.jsp" title="Consortium Member Sign In"><button class="btn btn-primary btn-sm">Login</button></a>
                </c:otherwise>
            </c:choose>

        </li>
    </ul>


</nav>
