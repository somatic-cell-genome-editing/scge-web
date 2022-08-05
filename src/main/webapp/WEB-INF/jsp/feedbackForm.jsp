<div id="hiddenBtns" class="hiddenBtns" style="display: block;">
    <button type="button" class="openLikeBtn" onclick="openForm()"></button>
</div>

<div class="chat-popup" id="messageVue">
    <form class="form-container">
        <img src="/toolkit/images/close30.png" id="close" onclick="closeForm()" class="closeForm"/>
        <h2 id="headMsg">Contact SCGE</h2>
        <input type="hidden" name="subject" value="Help and Feedback Form">
        <input type="hidden" name="found" value="0">

        <label><b>Your email</b></label>
        <br><input type="email" name="email" v-model="email" >
        <br>
        <br><label><b style="">Message</b></label>
        <textarea placeholder="Type message.." name="comment" v-model="message"></textarea>

        <button type="button" id="sendEmail" class="btn" v-on:click="sendMail">Send</button>

    </form>
</div>




<script src="https://unpkg.com/vue@2"></script>
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script>
    function openForm() {
        document.getElementById("messageVue").style.display = "block";
        document.getElementById("headMsg").innerText = 'We value your feedback';
    }

    function closeForm() {
        document.getElementById("messageVue").style.display = "none";
        document.getElementById("sendEmail").disabled = false;
    }

    // window.onload = function () {
    var messageVue = new Vue({
        el: '#messageVue',
        data: {
            email: '',
            message: '',
        },
        methods: {
            sendMail: function () {
                if (this.message === '' || !this.message) {
                    alert("There is no message entered.");
                    return;
                }
                if (this.email === '' || !this.email) {
                    alert("No email provided.");
                    return;
                }
                if (!emailValidate(this.email)) {
                    alert("Not a valid email address.");
                    return;
                }
                document.getElementById("sendEmail").disabled = true;


                axios.post('/toolkit/data/feedback?${_csrf.parameterName}=${_csrf.token}',
                    {
                        email: messageVue.email,
                        message: messageVue.message,
                        webPage: window.location.href
                    })
                    .then(function (response) {
                        closeForm();
                        messageVue.email="";
                        messageVue.message="";
                        alert("Thank you!  Your message has been sent to the SCGE.")
                    }).catch(function (error) {
                    console.log(error)
                })
            }
        } // end methods
    });

    function emailValidate(message) {
        var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(message);
    }


    if (sessionStorage.getItem("sawFeedback") === "true") {

    }else {
        sessionStorage.setItem('sawFeedback', 'true');
        setTimeout("openForm()",4000);
    }



</script>
