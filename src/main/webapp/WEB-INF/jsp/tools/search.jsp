<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 5/14/2020
  Time: 8:14 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .jumbotron{
        /*	background:linear-gradient(to bottom, white 0%, #D6EAF8 100%); */
      /*  background:linear-gradient(to bottom, white 0%, #D6EAF8 100%);
        background-color: #D1F2EB;*/
    }
</style>
<style>
    .ui-autocomplete {
        height: 200px; overflow-y: scroll; overflow-x: hidden;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);}
</style>
<script>

    $(function () {

        $("#modelsSearchTerm").autocomplete({

            delay:500,
            source: function(request, response) {

                $.ajax({
                    url:"",
                    type: "POST",
                    data: {term: request.term
                       },
                    max: 100,
                    dataType: "json",
                    success: function(data) {

                        response(data);
                    }
                });
            }

        });
    })
</script>

        <div class="" style="text-align: center;padding-top:0.5%;width:50%;" align="center">
            <div  align="center">
            <form  action="/toolkit/data/search/results">
            <div class="form-group row"  align="center" >
                <div class="input-group col-lg-2">
                    <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/logo-png-1.png" border="0" alt="SCGE"/>
                </div>
                <div class="input-group col-lg-10">
                <div class="input-group" align="center">
                    <input  name="searchTerm" class="form-control form-control-lg border-secondary" type="search"  placeholder="Enter Search Term ...." value=""/>
                        <div class="input-group-append">
                            <button class="btn btn-outline-secondary" type="submit" >
                                <i class="fa fa-search"></i>
                            </button>
                        </div>

                </div>

                    <small class="form-text text-muted" style="font-size: 11px">Examples:<a href="/toolkit/data/search/results?searchTerm=Epithelium">Epithelium</a> <a href="/toolkit/data/search/results?searchTerm=crispr" >CRISPR</a>,
                        <a href="/toolkit/data/search/results?searchTerm=aav" >AAV</a>, <a href="/toolkit/data/search/results?searchTerm=ai9" >Ai9</a>
                    </small>
                </div>
            </div>
            </form>
            </div>
        </div>


