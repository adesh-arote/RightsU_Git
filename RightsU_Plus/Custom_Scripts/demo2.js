
(function () {
    debugger;
   
    var button = document.getElementById('cn-button'),
    wrapper = document.getElementById('cn-wrapper');

    if (button != null)
    {
        classie.add(wrapper, 'opened-nav');
    }

    //open and close menu when the button is clicked
    //var open = false;
    //button.addEventListener('click', handler, false);

    //function handler() {
    //    debugger;
    //    if (!open) {
    //        var d = document.getElementById('cn-button')
    //        d.innerHTML = '<img id="imgDigital" style="border-radius:90px;" src="../UploadFolder/Digital_Media.jpg" />';
    //        //this.innerHTML = "Close";
    //        classie.add(wrapper, 'opened-nav');
    //    }
    //    else {
    //          var d = document.getElementById('cn-button')
    //          d.innerHTML = '<img id="imgDigital" style="border-radius:90px;" src="../UploadFolder/Digital_Media.jpg" />';
    //        classie.remove(wrapper, 'opened-nav');
    //    }
    //    open = !open;
    //}
    function closeWrapper() {
        classie.remove(wrapper, 'opened-nav');
    }

})();
