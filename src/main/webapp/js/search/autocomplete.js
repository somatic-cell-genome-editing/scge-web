$(function () {

    $("#commonSearchTerm").autocomplete({

        //    delay:500,
        source: function(request, response) {
            $.ajax({
                url:"/toolkit/data/autocomplete",
                type: "GET",
                data: {searchTerm: request.term
                },
                max: 100,
                dataType: "json",
                success: function(data) {
                    response(data)
                }
            });
        }

    })
        .autocomplete( "instance" )._renderItem = function( ul, item ) {
      //  console.log(item);
        return $( "<li>" )
            .attr( "data-value", item.value.replace("<strong>").replace("</strong>") )
            .append( "<div>" + item.label+"</div>" )
            .appendTo( ul );

    };
    $( "#commonSearchTerm" ).on( "autocompleteclose", function() {
        $(this).val(stripHTML($(this).val()))
    } );


    /*   $( "#searchTerm" ).autocomplete({

           select: function( event, ui ) {
               var _item= ui.item.label.replace("<strong>", "")
               console.log("SEKECTED:"+_item.replace("</strong>", ""));
              return (_item);
           }
       });*/
});

function stripHTML(oldString) {
    return oldString.replace(/(<([^>]+)>)/ig,"");
}