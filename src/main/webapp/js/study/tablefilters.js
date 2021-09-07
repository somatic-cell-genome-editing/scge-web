$(function() {
    for(var i=1;i<10; i++) {
        $("#myTable-"+i).tablesorter({
            theme: 'blue',
            cssChildRow:"tablesorter-childRow",
            widgets: ["zebra", "filter"],

            // headers: { 5: { sorter: false, filter: false } },

            widgetOptions : {

                // extra css class applied to the table row containing the filters & the inputs within that row
                filter_cssFilter   : '',

                // If there are child rows in the table (rows with class name from "cssChildRow" option)
                // and this option is true and a match is found anywhere in the child row, then it will make that row
                // visible; default is false
                filter_childRows   : false,

                // if true, filters are collapsed initially, but can be revealed by hovering over the grey bar immediately
                // below the header row. Additionally, tabbing through the document will open the filter row when an input gets focus
                filter_hideFilters : false,

                // Set this option to false to make the searches case sensitive
                filter_ignoreCase  : true,

                // jQuery selector string of an element used to reset the filters
                filter_reset : '.reset',

                // Use the $.tablesorter.storage utility to save the most recent filters
                filter_saveFilters : true,

                // Delay in milliseconds before the filter widget starts searching; This option prevents searching for
                // every character while typing and should make searching large tables faster.
                filter_searchDelay : 300,

                // Set this option to true to use the filter to find text from the start of the column
                // So typing in "a" will find "albert" but not "frank", both have a's; default is false
                filter_startsWith  : false,

                // Add select box to 4th column (zero-based index)
                // each option has an associated function that returns a boolean
                // function variables:
                // e = exact text from cell
                // n = normalized value returned by the column parser
                // f = search filter input value
                // i = column index
                filter_functions : {

                    // Add select menu to this column
                    // set the column value to true, and/or add "filter-select" class name to header
                    // '.first-name' : true,

                    // Exact match only
                    1 : function(e, n, f, i, $r, c, data) {
                        return e === f;
                    }


                }

            }
        });

    }
    $('.tablesorter-childRow td').hide();

    $('.tablesorter').delegate('.toggle', 'click' ,function() {
        if($(this).find('.fa').hasClass("fa-plus-circle")){
            $(this).find('.fa').removeClass("fa-plus-circle");
            $(this).find('.fa').addClass("fa-minus-circle");
            $(this).find('.fa').css('color', 'red');
            $(this).find('.fa').prop('title', 'Click to collapse');
        }else{
            $(this).find('.fa').removeClass("fa-minus-circle");
            $(this).find('.fa').addClass("fa-plus-circle");
            $(this).find('.fa').css('color', 'green');
            $(this).find('.fa').prop('title', 'Click to expand');
        }
        // use "nextUntil" to toggle multiple child rows
        // toggle table cells instead of the row
        $(this).closest('tr').nextUntil('tr:not(.tablesorter-childRow)').find('td').toggle();
        // in v2.5.12, the parent row now has the class tablesorter-hasChildRow
        // so you can use this code as well
        // $(this).closest('tr').nextUntil('tr.tablesorter-hasChildRow').find('td').toggle();

        return false;
    });
    $('button[data-filter-column]').click(function() {
        /*** first method *** data-filter-column="1" data-filter-text="!son"
         add search value to Discount column (zero based index) input */
        var filters = [],
            $t = $(this),
            col = $t.data('filter-column'), // zero-based index
            txt = $t.data('filter-text') || $t.text(); // text to add to filter

        filters[col] = txt;
        // using "table.hasFilters" here to make sure we aren't targeting a sticky header
        $.tablesorter.setFilters( $('#table'), filters, true ); // new v2.9

        /** old method (prior to tablsorter v2.9 ***
         var filters = $('table.tablesorter').find('input.tablesorter-filter');
         filters.val(''); // clear all filters
         filters.eq(col).val(txt).trigger('search', false);
         ******/

        /*** second method ***
         this method bypasses the filter inputs, so the "filter_columnFilters"
         option can be set to false (no column filters showing)
         ******/
        /*
        var columns = [];
        columns[5] = '2?%'; // or define the array this way [ '', '', '', '', '', '2?%' ]
        $('table').trigger('search', [ columns ]);
        */

        return false;
    });
});