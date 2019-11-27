
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

