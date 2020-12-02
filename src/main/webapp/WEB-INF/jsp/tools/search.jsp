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

<div class="">
    <form  action="results">
        <div class="" >

            <div class="container">

                <div class="form-row row">

                    <div class="form-group col-md-2">
                        <input type="hidden" id="modelsAspect" value="all">


                    </div>
                    <div class="form-group col-md-8">
                        <small class="form-text text-muted" style="font-size: 14px">Enter a tissue or editor or animal model or delivery system.</small>
                        <div class="input-group" >

                            <input  name="searchTerm" class="form-control form-control-lg border-secondary" type="search"  placeholder="Enter Search Term ...." value=""/>

                            <div class="input-group-append">

                                <button class="btn btn-outline-secondary" type="submit" >
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                        <small class="form-text text-muted" style="font-size: 11px">Examples: <a href="" >Brain</a>, <a href="" >CRISPER</a>,
                            <a href="" >AAV</a>, <a href="" >Ai9</a>
                        </small>
                    </div>
                </div>
            </div>

        </div>
    </form>
</div>
