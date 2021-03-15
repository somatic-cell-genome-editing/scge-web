$(function () {
    var $treeView= $("#jstree_results");
    $treeView.jstree({
        "core" : {
            "animation" : 0,
            "check_callback" : true,
            "themes" : { "icons": false },
            "dblclick_toggle":false,
            "expand_selected_onload":false

        },

        "types":{
            "#" : {
                "max_children" : 1,
                "max_depth" : 4,
                "valid_children" : ["root"]
            }

        },
      /*  "types" : {
            "default" : {
             /*   "icon" :'{{"icon":"fa fa-dna fa-2x"}}'*/
          /*      "icon":'fa fa-cog fa-1x'
            }
        },*/
        "plugins" : [
            /*   "types" , "themes", "html_data", "checkbox", "ui"*/
             "dnd", "search",
            "state", "types", "wholerow"
        ]
    });
 //   $treeView.jstree("open_all");
    //To Drag content overflow of a div
    /* if($treeView.offsetWidth < $treeView.scrollWidth){
         $('ul').on('click', function () {
             $(this).css("cursor","move");
             $(this).draggable();
         })
     }*/
    $treeView.on('select_node.jstree', function(e, data){
        data.instance.toggle_node(data.selected);
    });
 /*   $treeView.jstree({"themes":objTheme,"plugins":arrPlugins,"core":objCore}).
    bind("open_node.jstree",function(event,data){closeOld(data)});*/
});
function closeOld(data)
{
    var nn = data.rslt.obj;
    var thisLvl = nn;
    var levels = new Array();
    var iex = 0;
    while (-1 != thisLvl)
    {
        levels.push(thisLvl);
        thisLvl = data.inst._get_parent(thisLvl);
        iex++;
    }

    if (0 < ignoreExp)
    {
        ignoreExp--;
        return;
    }

    $("#jstree_results").jstree("close_all");
    ignoreExp = iex;
    var len = levels.length - 1;
    for (var i=len;i >=0;i--) $('#jstree_results').jstree('open_node',levels[i]);
}