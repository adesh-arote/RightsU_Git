


$(function () {
    debugger;
    var items = $('#v-nav>ul>li').each(function () {
         
        $(this).click(function () {
            //remove previous class and add it to clicked tab
            items.removeClass('current1');
            $(this).addClass('current1');

            //hide all content divs and show current one

            $('#v-nav>div.tab-content').hide().eq(items.index($(this))).fadeIn(100);

            //  $('#v-nav>div.tab-content').hide().eq(items.index($(this))).show();
            window.location.hash = $(this).attr('tab');
        });
    });

    if (location.hash) {
        showTab(location.hash);
    }
    else {
        showTab("tab1");
    }

    function showTab(tab) {
        debugger;
        $("#v-nav ul li[tab*='" + tab + "']").click();
        //$("#v-nav ul li[tab='" + tab + "']").click();

        //$("#v-nav ul li:[tab*=" + tab + "]").click();
    }

    // Bind the event hashchange, using jquery-hashchange-plugin
    $(window).hashchange(function () {
        showTab(location.hash.replace("#", ""));
    })

    // Trigger the event hashchange on page load, using jquery-hashchange-plugin
    $(window).hashchange();
});