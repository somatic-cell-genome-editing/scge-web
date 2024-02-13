$(function() {
    $("#myTable").tablesorter({
        widthFixed : true,
        theme : 'blue',
        widgets: ['zebra','resizable', 'stickyHeaders'],
        widgetOptions: {
            // jQuery selector or object to attach sticky header to
            stickyHeaders_attachTo: $('.table-wrapper'),

        }
    });
    var toggler = document.getElementsByClassName("caret");
    var i;

    for (i = 0; i < toggler.length; i++) {
        toggler[i].addEventListener("click", function() {
            this.parentElement.querySelector(".nested").classList.toggle("active");
            this.classList.toggle("caret-down");
        });
    }
});
function signOut() {
    var auth2 = gapi.auth2.getAuthInstance();
    auth2.signOut().then(function () {
        console.log('User signed out.');
    });
    

    var redirectURL='/scge/home';
    var form = $('<form action="' + redirectURL + '">');
    $('body').append(form);
    form.submit();
}

