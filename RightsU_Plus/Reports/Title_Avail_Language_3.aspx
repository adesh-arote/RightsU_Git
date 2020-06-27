<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" UnobtrusiveValidationMode="None" CodeBehind="Title_Avail_Language_3.aspx.cs" Inherits="RightsU_WebApp.Reports.Title_Avail_Language_3" MasterPageFile="~/Home.Master" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">
  <%--  <link rel="stylesheet" href="../CSS/jquery-ui.css" />
    <link rel="stylesheet" href="../CSS/chosen.min.css" />
    <link rel="stylesheet" href="../CSS/common.css" />
    <link rel="stylesheet" href="../CSS/Master_ASPX.css" />
    <link rel="stylesheet" href="../Master/stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />

    <script type="text/javascript" src="../Master/JS/master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/common.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/HTTP.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery-ui.min.js"></script>
    <script type="text/javascript" src="../JS_Core/common.concat.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/jquery.expander.js"></script>
    <script type="text/javascript" src="../JS_Core/autoNumeric-1.8.1.js"></script>
    <script type="text/javascript" src="../JS_Core/chosen.jquery.min.js"></script>--%>


    <link rel="stylesheet" href="../Master/stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />

   
    <script type="text/javascript" src="../Master/JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/HTTP.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery-ui.min.js"></script>

  

   
    <script type="text/javascript">

        $('.tabbable a').click(function (e) {
            e.preventDefault()
            //$(this).tab('show')
        })

        var dateWatermarkFormat = "DD/MM/YYYY";
        var dateWatermarkColor = '#999';
        var dateNormalkColor = '#000';
        var overlay = $('<div id="overlay" class="overlay_common"></div>');

        $(document).ready(function () {
            debugger;
            $("#<%=lbLanguage.ClientID %>").disabled = false;
            $('#<%=txtMonths.ClientID %>').autoNumeric('init', { vMax: '999', wEmpty: '0', mDec: 0 });
            $('#<%=txtDaysWithin.ClientID %>').autoNumeric('init', { vMax: '999', wEmpty: '0', mDec: 0 });
            $('#<%=txtYearWithin.ClientID %>').autoNumeric('init', { vMax: '999', wEmpty: '0', mDec: 0 });
            $('#<%=txtNextDays.ClientID %>').autoNumeric('init', { vMax: '999', wEmpty: '0', mDec: 0 });
            $('#<%=txtNextmonth.ClientID %>').autoNumeric('init', { vMax: '999', wEmpty: '0', mDec: 0 });
            $('#<%=txtYears.ClientID %>').autoNumeric('init', { vMax: '999', wEmpty: '1', mDec: 0 });

            CalculateDate();

            $('#<%=txtfrom.ClientID %>').datepick('option', 'minDate', $.datepick.today());
            $('#<%=txtto.ClientID %>').datepick('option', 'minDate', $.datepick.today());

            if ($('#<%=txtfrom.ClientID %>').val() != 'DD/MM/YYYY' && $('#<%=txtfrom.ClientID %>').val() != '')
                $('#<%=txtto.ClientID %>').datepick('option', 'minDate', $('#<%=txtfrom.ClientID %>').datepick('getDate')[0] || null);

            if ($('#<%=txtto.ClientID %>').val() != 'DD/MM/YYYY' && $('#<%=txtto.ClientID %>').val() != '')
                $('#<%=txtfrom.ClientID %>').datepick('option', 'maxDate', $('#<%=txtto.ClientID %>').datepick('getDate')[0] || null);

            $('input[type=text]').change(function () {
                $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
            });

            InitializeCollapsiblePanels();
            checkedChangeEvent();
            AssignChosenJQuery();
            Assign_Css();
            CallOnLoad();
            SetMultiselectDDLsAfterPageLoad();
        });

        function checkedChangeEvent() {
            $('input[type=checkbox]').change(function () {
                $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
            });
        }

        function InitializeCollapsiblePanels() {
            var headers = $('#accordion .accordion-header');
            var contentAreas = $('#accordion .ui-accordion-content').not('#divGeneral').hide();

            // add the accordion functionality
            headers.click(function () {
                var panel = $(this).next();
                var isOpen = panel.is(':visible');

                // open or close as necessary
                panel[isOpen ? 'slideUp' : 'slideDown']().trigger(isOpen ? 'hide' : 'show');
                return false;
            });

            //// hook up the expand/collapse all
            //expandLink.click(function () {
            //    var isAllOpen = $(this).data('isAllOpen');

            //    contentAreas[isAllOpen ? 'hide' : 'show']()
            //        .trigger(isAllOpen ? 'hide' : 'show');
            //});

            //// when panels open or close, check to see if they're all open
            //contentAreas.on({
            //    // whenever we open a panel, check to see if they're all open
            //    // if all open, swap the button to collapser
            //    show: function () {
            //        var isAllOpen = !contentAreas.is(':hidden');
            //        if (isAllOpen) {
            //            expandLink.text('Collapse All')
            //                .data('isAllOpen', true);
            //        }
            //    },
            //    // whenever we close a panel, check to see if they're all open
            //    // if not all open, swap the button to expander
            //    hide: function () {
            //        var isAllOpen = !contentAreas.is(':hidden');
            //        if (!isAllOpen) {
            //            expandLink.text('Expand all')
            //            .data('isAllOpen', false);
            //        }
            //    }
            //});
        }
        function clearData() {
            debugger;
            $('#<%=hdnRegionCodes.ClientID %>').val(0);
            //$("#<%=ddlTerritory.ClientID %>").val($('#<%=hdnRegionCodes.ClientID %>').val()).trigger("chosen:updated");
        }
        function Assign_Css() {
            <%--$("#<%=ReportViewer1.ClientID %> table").each(function (i, item) {
                $(item).css('display', 'inline-block');
            });

            $("#<%=ReportViewer1.ClientID %> table.aspNetDisabled").each(function (i, item) {
                $(item).css('display', 'none');
            });--%>
        }

        function ClosePopup() {
            $('#TitlePopup').hide();
            overlay.appendTo(document.body).remove();
            var TitleCode = '';

            if ($('#<%=hdnTitleCodes.ClientID %>').val().split(',').length != 0 && $('#<%=hdnTitleCodes.ClientID %>').val() != '') {
                TitleCode = $('#<%=hdnTitleCodes.ClientID %>').val().split(',');
                $('#spTitleCount').html("(" + TitleCode.length + ")");
            }
            else
                $('#spTitleCount').html("(0)");

            $('#<%=lsMovie.ClientID %>').val(TitleCode).trigger('chosen:updated');
            return false;
        }

        function OpenPopup() {
            overlay.show();
            overlay.appendTo(document.body);
            $('#TitlePopup').show();
            return false;
        }

        function AssignDateJQuery() {
            var dateWatermarkFormat = $('#<%=hdnDateWatermarkFormat.ClientID %>').val();
            var fromDate = $('#<%=txtfrom.ClientID %>').val();
            var toDate = $('#<%=txtto.ClientID %>').val();

            if (fromDate == dateWatermarkFormat) {
                fromDate = "";
                $('#<%=txtfrom.ClientID %>').val(fromDate);
            }

            if (toDate == dateWatermarkFormat) {
                toDate = "";
                $('#<%=txtto.ClientID %>').val(toDate);
            }

            $('.dateRange').datepick({
                onSelect: customRange, dateFormat: 'dd/mm/yyyy', pickerClass: 'demo',
                autoSize: true,
                renderer: $.datepick.themeRollerRenderer,
                onClose: CloserDate,
                onShow: function () {
                    $('.ui-datepicker-cmd-clear').hide();
                }
            });

            function customRange(dates) {
                if (this.id == '<%=txtfrom.ClientID %>') {
                    if ($('#<%=txtfrom.ClientID %>').val() != 'DD/MM/YYYY' && $('#<%=txtfrom.ClientID %>').val() != '') {
                        $('#<%=txtto.ClientID %>').datepick('option', 'minDate', dates[0] || null);
                        $('#<%=txtfrom.ClientID %>').css('color', dateNormalkColor);
                    }
                    else {
                        $('#<%=txtto.ClientID %>').datepick('option', { minDate: null });
                        $('#<%=txtfrom.ClientID %>').val(dateWatermarkFormat);
                        $('#<%=txtfrom.ClientID %>').css('color', dateWatermarkColor);
                    }

                    $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
                }
                else if (this.id == '<%=txtto.ClientID %>') {
                    if ($('#<%=txtto.ClientID %>').val() != 'DD/MM/YYYY' && $('#<%=txtto.ClientID %>').val() != '') {
                        $('#<%=txtfrom.ClientID %>').datepick('option', 'maxDate', dates[0] || null);
                        $('#<%=txtto.ClientID %>').css('color', dateNormalkColor);
                    }
                    else {
                        $('#<%=txtfrom.ClientID %>').datepick('option', { maxDate: null });
                        $('#<%=txtto.ClientID %>').val(dateWatermarkFormat);
                        $('#<%=txtto.ClientID %>').css('color', dateWatermarkColor);
                    }

                    $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
                }
                else if (this.id == '<%=spStartDate.ClientID %>') {
                    var StartDate = $('#<%=spStartDate.ClientID %>').datepick('getDate')[0];
                    var val = monthDiff(new Date(), StartDate);
                    var year = parseInt(val / 12);
                    var month = parseInt(val % 12);
                    StartDate.setMonth(StartDate.getMonth() - month);
                    var initDate = new Date(StartDate.setFullYear(StartDate.getFullYear() - year));
                    // initDate = new Date(initDate.setDate(initDate.getDate() + 1));
                    var days = parseInt((initDate - new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate())) / 86400000);

                    if (initDate.getDate() < new Date().getDate())
                        days = days + 1;

                    $('#<%=txtMonths.ClientID %>').val(month);
                    $('#<%=txtDaysWithin.ClientID %>').val(days);
                    $('#<%=txtYearWithin.ClientID %>').val(year);
                    $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
                }
                else if (this.id == '<%=spEndDate.ClientID %>') {
                    var StartDate = $('#<%=spEndDate.ClientID %>').datepick('getDate')[0];
                    var val = monthDiff(new Date(), StartDate);
                    var year = parseInt(val / 12);
                    var month = parseInt(val % 12);
                    StartDate.setMonth(StartDate.getMonth() - month);
                    var initDate = new Date(StartDate.setFullYear(StartDate.getFullYear() - year));
                    //initDate = new Date(initDate.setDate(initDate.getDate() + 1));
                    var days = parseInt((initDate - new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate())) / 86400000);

                    if (initDate.getDate() < new Date().getDate())
                        days = days + 1;

                    $('#<%=txtNextmonth.ClientID %>').val(month);
                    $('#<%=txtNextDays.ClientID %>').val(days);
                    $('#<%=txtYears.ClientID %>').val(year);
                    $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
                }
}

    $('#<%=spStartDate.ClientID %>').datepick('option', 'minDate', new Date());
            $('#<%=spEndDate.ClientID %>').datepick('option', 'minDate', new Date());
            $('.dateRange').watermark(dateWatermarkFormat);

            if (fromDate != "")
                $('#<%=txtfrom.ClientID %>').val(fromDate);

            if (toDate != "")
                $('#<%=txtto.ClientID %>').val(toDate);
        }

        function monthDiff(startDate, endDate) {
            //endDate.setDate(endDate.getDate() + 1);

            var months = (endDate.getFullYear() - startDate.getFullYear()) * 12;
            months += endDate.getMonth() - startDate.getMonth();

            // Subtract one month if b's date is less that a's.
            if (endDate.getDate() < startDate.getDate())
                months--;

            return months;

        }

        function InitializeStartDate() {
            $('#<%=txtfrom.ClientID %>').datepick('option', 'minDate', $.datepick.today());
            $('#<%=txtto.ClientID %>').datepick('option', 'minDate', $.datepick.today());
            $('#<%=txtfrom.ClientID %>').val(dateWatermarkFormat);
            $('#<%=txtfrom.ClientID %>').css('color', dateWatermarkColor);
            $('#<%=txtto.ClientID %>').val(dateWatermarkFormat);
            $('#<%=txtto.ClientID %>').css('color', dateWatermarkColor);
        }

        function clearDate(date) {
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
            if (date == '<%=txtfrom.ClientID %>') {
                $('#<%=txtto.ClientID %>').datepick('option', { minDate: $.datepick.today() });
                $('#<%=txtfrom.ClientID %>').val(dateWatermarkFormat);
                $('#<%=txtfrom.ClientID %>').css('color', dateWatermarkColor);
            }
            else {
                $('#<%=txtfrom.ClientID %>').datepick('option', { maxDate: null });
                $('#<%=txtto.ClientID %>').val(dateWatermarkFormat);
                $('#<%=txtto.ClientID %>').css('color', dateWatermarkColor);
            }
        }

        function CloserDate(date) {
            if (date.length == 0) {
                if (this.id == '<%=txtfrom.ClientID %>') {
                    $('#<%=txtto.ClientID %>').datepick('option', { minDate: $.datepick.today() });
                    $('#<%=txtfrom.ClientID %>').val(dateWatermarkFormat);
                    $('#<%=txtfrom.ClientID %>').css('color', dateWatermarkColor);
                }
                else if (this.id == '<%=txtto.ClientID %>') {
                    $('#<%=txtfrom.ClientID %>').datepick('option', { maxDate: null });
                    $('#<%=txtto.ClientID %>').val(dateWatermarkFormat);
                    $('#<%=txtto.ClientID %>').css('color', dateWatermarkColor);
                }
        }
    }

    function AssignChosenJQuery() {
        var maxSelectedOption = <%= this.MaxSelectedOption %>

            $('.Chosenlb').chosen({
                width: "95%",
                placeholder_text_multiple: "-- Please Select --",
                placeholder_text_single: "-- Please Select --"
            });

        $('.ChosenTitle').chosen();
        $("#<%=lstRegion.ClientID %>").chosen();
    }

    function triggerChoosen() {
        $(".Chosenlb").trigger("chosen:updated");
        $('.ChosenTitle').trigger("chosen:updated");
    }

    function ValidateTitle() {
        debugger;
        if (Validate()) {

            if ($("[id*=<%=rblPeriodType.ClientID %>] input:checked").val() != "MI") {
                if ($('#<%=txtfrom.ClientID %>').val() == 'DD/MM/YYYY' || $('#<%=txtfrom.ClientID %>').val() == '') {
                    var lsMovie = document.getElementById('<%=lsMovie.ClientID %>');
                    AlertModalPopup(lsMovie, 'Please select Available from date.');
                    return false;
                }

                if ($("[id*=<%=rblPeriodType.ClientID %>] input:checked").val() != "FL") {
                    if ($('#<%=txtto.ClientID %>').val() == 'DD/MM/YYYY' || $('#<%=txtto.ClientID %>').val() == '') {
                        var lsMovie = document.getElementById('<%=lsMovie.ClientID %>');
                        AlertModalPopup(lsMovie, 'Please select Available to date.');
                        return false;
                    }
                }
            }
            else {
                var txtMonths = $get('<%=txtMonths.ClientID %>');
                var txtYears = $get('<%=txtYears.ClientID %>');

                if (txtMonths.value.trim() == '' && txtYears.value.trim() == '') {
                    AlertModalPopup(txtMonths, "Please enter Month and Year");
                    return false;
                }

                var spStartDate = $('#<%=spStartDate.ClientID %>');
                var spEndDate = $('#<%=spEndDate.ClientID %>');

                if (compareDates_DMY(spStartDate.val(), spEndDate.val()) < 0) {
                    var lsMovie = document.getElementById('<%=lsMovie.ClientID %>');
                    AlertModalPopup(lsMovie, 'End Date should be greater than Start Date');
                    return false;
                }
            }

            var lstWithoutExcludedRegion = $get('<%=lstWithoutExcludedRegion.ClientID %>');

            if ($($("[id*=<%=chkRegion.ClientID %>] input:checked")[0]).next().html() == "Must Have" && $("#<%=lstWithoutExcludedRegion.ClientID %>").val() == null) {
                AlertModalPopup(lstWithoutExcludedRegion, 'Please select must have Region.');
                return false;
            }
            if ($($("[id*=<%=chkExact.ClientID %>] input:checked")[0]).next().html() == "Must Have" && $("#CphdBody_uctabSelectedplt_trView :checked").length == 0) {
                var lsMovie = document.getElementById('<%=lsMovie.ClientID %>');
                AlertModalPopup(lsMovie, 'Please select must have Platform.');
                return false;
            }

            if ($('#<%=chkIsOriginalLanguage.ClientID %>').is(":checked") == false && $('#<%=lbSubtitling.ClientID %>').val() == null && $('#<%=lbLanguage.ClientID %>').val() == null) {
                var lsMovie = document.getElementById('<%=lsMovie.ClientID %>');
                AlertModalPopup(lsMovie, 'Please select Title language or subtitling or dubbing.');
                return false;
            }

        }
        else
            return false;

        var TitleCode = '';
        debugger
        if ($('#<%=hdnTitleCodes.ClientID %>').val().split(',').length != 0 && $('#<%=hdnTitleCodes.ClientID %>').val() != '') {
            TitleCode = $('#<%=hdnTitleCodes.ClientID %>').val().split(',');
            $('#spTitleCount').html("(" + TitleCode.length + ")");
        }
        else
            $('#spTitleCount').html("(0)");

        $('#<%=lsMovie.ClientID %>').val(TitleCode).trigger('chosen:updated');

        if ($('#<%=hdnTabVal.ClientID %>').val() == '' || $('#<%=hdnIsCriteriaChange.ClientID %>').val() == 'Y') {

            $('#txtReportName').val('');

            var tmp_rblVisibility = $(":radio[id*=<%=rblVisibility.ClientID %>]")[0];

            tmp_rblVisibility.checked = true
            $('#trReportName').hide();
            $('#trRBVisibility').hide();
            $('#trblank').show();
            //overlay.show();
            //overlay.appendTo(document.body);
            //$('#divConfirmReport').show("fast");
        }
        else {
            $('#<%=liImgResults.ClientID%>').addClass('active');
            $('#<%=liImgCriteria.ClientID%>').removeClass();
            $('#<%=liImgSavedQuery.ClientID%>').removeClass();

            $('#<%=tblCriteria.ClientID%>').attr('style', 'display:none');
            $('#<%=SavedQuery.ClientID%>').attr('style', 'display:none');
            $('#<%=Results.ClientID%>').attr('style', '');
            $('#<%=hdnDupQueryName.ClientID%>').val('');
        }
        return true;
    }

    function Validate() {
        //debugger;
        var IsValid = false;

        if ($('#<%=lsMovie.ClientID %>').val() == '' || $('#<%=lsMovie.ClientID %>').val() == null)
            IsValid = false
        else
            return true;

        if ($('#<%=hdnRegionType.ClientID %>').val() == 'T') {
            if ($('#<%=ddlTerritory.ClientID %>').val() == '' || $('#<%=ddlTerritory.ClientID %>').val() == null)
                IsValid = false
            else
                return true;
        }
        else {
            if ($('#<%=lstLTerritory.ClientID %>').val() == '' || $('#<%=lstLTerritory.ClientID %>').val() == null)
                IsValid = false
            else
                return true;
        }

        if ($("#CphdBody_uctabPTV_trView :checked").length == 0)
            IsValid = false;
        else
            return true;

        if (!IsValid) {
            var ddlBU = $('#ddlBusinessUnit');
            AlertModalPopup(ddlBU, 'Please select atleast one Title, Region or Platform .');
            return false;
        }
    }

    function ValidateMandatoryField() {
        if (!checkblank(document.getElementById('<%=txtSearch.ClientID %>').value)) {
            AlertModalPopup(document.getElementById('<%=btnSearch_tit.ClientID %>'), 'Please enter search criteria');
            return false;
        }
    }

    function ValidateMandatoryField1() {
        if (!checkblank(document.getElementById('<%=txtPlatformSearch.ClientID %>').value)) {
            AlertModalPopup(document.getElementById('<%=btnSearch_plt.ClientID %>'), 'Please enter search criteria');
            return false;
        }
    }

    function ValidateMandatoryField2() {
        if (!checkblank(document.getElementById('<%=txtSelectedPlatformSearch.ClientID %>').value)) {
            AlertModalPopup(document.getElementById('<%=btnSearch_plt_Selected.ClientID %>'), 'Please enter search criteria');
            return false;
        }
    }

    function ConvertDateToCurrentFormat(objDate) {
        var dd = objDate.getDate();
        var mm = objDate.getMonth() + 1; //January is 0!
        var yyyy = objDate.getFullYear();

        if (dd < 10)
            dd = '0' + dd

        if (mm < 10)
            mm = '0' + mm

        var newDate = dd + '/' + mm + '/' + yyyy;
        return newDate;
    }

    function SelectTitles() {
        var tmpGvTitle = document.getElementById('<%=gvTitle.ClientID%>');
        var checkedCnt = 1;
        var chkAllTitle = $('#<%=gvTitle.ClientID %> input[type=checkbox]')[0];

        for (var i = 1; i <= tmpGvTitle.childNodes[1].childElementCount - 1; i++) {
            var chk = $('#<%=gvTitle.ClientID %> input[type=checkbox]')[i];
            var lblIntCode = tmpGvTitle.rows[i].cells[1].childNodes[1].innerHTML

            if (chk.checked == true) {
                // tmpHdnTitle.value += lblIntCode + ",";
                checkedCnt++;
            }
        }

        if (checkedCnt == tmpGvTitle.childNodes[1].childElementCount)
            chkAllTitle.checked = true;
        else chkAllTitle.checked = false;
    }

    function SelectAllTitles() {
        var tmpGvTitle = document.getElementById('<%=gvTitle.ClientID%>');
        var chkAllTitle = $('#<%=gvTitle.ClientID %> input[type=checkbox]')[0];

        for (var i = 1; i <= tmpGvTitle.childNodes[1].childElementCount - 1; i++) {
            var chk = $('#<%=gvTitle.ClientID %> input[type=checkbox]')[i];
            var lblIntCode = tmpGvTitle.rows[i].cells[1].childNodes[1].innerHTML

            if (chkAllTitle.checked == true) {
                //tmpHdnTitle.value += lblIntCode + ",";
                chk.checked = true;
            }
            else {
                chk.checked = false;
            }
        }
    }

    function SelectPeriodType(obj) {
        if ($(":radio[id*=<%=rblPeriodType.ClientID %>]")[0].checked == true) {
            document.getElementById('<%=tblMin.ClientID %>').style.display = '';
            document.getElementById('<%=tblFix.ClientID %>').style.display = 'none';
            document.getElementById('<%=txtMonths.ClientID %>').value = '0';
            document.getElementById('<%=txtYears.ClientID %>').value = '1';
            document.getElementById('<%=txtDaysWithin.ClientID %>').value = '0';
            document.getElementById('<%=txtYearWithin.ClientID %>').value = '0';
            document.getElementById('<%=txtNextmonth.ClientID %>').value = '0';
            document.getElementById('<%=txtNextDays.ClientID %>').value = '0';
            $('#<%=spStartDate.ClientID %>').val('');
            $('#<%=spEndDate.ClientID %>').val('');
            CalculateDate();
        }
        else {
            document.getElementById('<%=tblMin.ClientID %>').style.display = 'none';
            document.getElementById('<%=tblFix.ClientID %>').style.display = '';
            document.getElementById('<%=txtfrom.ClientID %>').value = '';
            document.getElementById('<%=txtto.ClientID %>').value = '';
            InitializeStartDate();
        }

        $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
    }

    function RegionTabSelect(selectedTab) {
        debugger;
        if (selectedTab == $('#<%=hdnRegionType.ClientID %>').val())
            return false;

        $('#<%=hdnRegionType.ClientID %>').val(selectedTab);
        $("#<%=lstRegion.ClientID %>").empty();
        $("#<%=lstRegion.ClientID %>").trigger('chosen:updated');
        $("#<%=lstWithoutExcludedRegion.ClientID %>").empty();
        $("#<%=lstWithoutExcludedRegion.ClientID %>").trigger('chosen:updated');
        $('#spMustExactHaveCountryCount').html('(0)');
        $("[id*=<%=chkRegion.ClientID %>] input").removeAttr('checked');
        $('#<%=hdnMustHaveRegionCode.ClientID %>').val('');


        if ($("[id*=<%=chkRegion.ClientID %>] input:checked").val() == "MH") {
            $("#<%=lstWithoutExcludedRegion.ClientID %>").prop('disabled', false).trigger("chosen:updated");
        }
        else {

            $("#<%=lstWithoutExcludedRegion.ClientID %>").prop('disabled', true).trigger("chosen:updated");
        }

        if (selectedTab == 'T') {
            $('#tbTerritory').show();
            $("#tbCountry").hide();
            $('#<%=lstLTerritory.ClientID %>').val('').trigger('chosen:updated');
            $("#<%=lstRegion.ClientID %>").prop('disabled', false).trigger("chosen:updated");
            $("#tabCountry").removeClass("tabCountry");
            $("#tabTerr").removeClass("tabTerritory");
            $("#tabCountry").addClass("tabTerritory");
            $("#tabTerr").addClass("tabCountry");
            $('#spCountryCount').html('');
            $('#spExclusionCountryCount').html('(0)');
        }
        else {
            if (selectedTab == 'C') {
                $('#<%=hdnExclusionRegionCode.ClientID%>').val('');
            }
            $('#<%=lstLTerritory.ClientID %>.chosen-container').width('320px');
            $('#tbTerritory').hide();
            $("#tbCountry").show();
            $('#<%=ddlTerritory.ClientID %>').val('').trigger('chosen:updated');
            $("#<%=lstRegion.ClientID %>").prop('disabled', true).trigger("chosen:updated");
            $('#<%=divCountries.ClientID %> .expandable').expander('destroy');
            $('#<%=divCountries.ClientID %>').html('');
            $('#<%=divCountries.ClientID %>').hide();
            $("#tabCountry").removeClass("tabTerritory");
            $("#tabTerr").removeClass("tabCountry");
            $("#tabCountry").addClass("tabCountry");
            $("#tabTerr").addClass("tabTerritory");
            $('#spCountryCount').html('(0)');
            $('#spExclusionCountryCount').html('');
        }

        $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
    }



    function LanguageTabSelect(selectedTab) {
        debugger;
        $('#<%=hdnLanguageType.ClientID %>').val(selectedTab);
            $("#<%=lbLanguage.ClientID %>").empty();
       $("#<%=lbLanguage.ClientID %>").trigger('chosen:updated');

       if (selectedTab == 'G') {
           $('#tblLanguageGroup').show();
           $("#tblLanguage").hide();
           $('#<%=lbSubtitling.ClientID %>').val('').trigger('chosen:updated');
                $("#tabLanguageID1").removeClass("tabCountry");
                $("#tabLanguageGropuID1").removeClass("tabTerritory");
                $("#tabLanguageID1").addClass("tabTerritory");
                $("#tabLanguageGropuID1").addClass("tabCountry");
                $("#<%=lbLanguage.ClientID %>").prop('disabled', false).trigger("chosen:updated");
            $('#spLanguageCount').html('');
            $('#spLanguageResult').html('0');
        }
        else {
            $('#<%=lbSubtitling.ClientID %>.chosen-container').width('320px');
                $('#tblLanguageGroup').hide();
                $("#tblLanguage").show();
                $('#<%=ddlLanguageGroup.ClientID %>').val('').trigger('chosen:updated');
            $("#tabLanguageID1").removeClass("tabTerritory");
            $("#tabLanguageGropuID1").removeClass("tabCountry");
            $("#tabLanguageGropuID1").addClass("tabTerritory");
            $("#<%=lbLanguage.ClientID %>").prop('disabled', true).trigger("chosen:updated");
            $('#spLanguageCount').html('(0)');
            $('#spLanguageResult').html('');
        }

        $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
   }

   function PlatformTabSelect(selectedTab) {
       if (selectedTab == 'PG') {
           $("#<%=spPlatform.ClientID %>").removeClass("tabCountry");
                $("#<%=spPlatformGroup.ClientID %>").removeClass("tabTerritory");
                $("#<%=spPlatform.ClientID %>").addClass("tabTerritory");
                $("#<%=spPlatformGroup.ClientID %>").addClass("tabCountry");
                $('#<%=divPlatformGroup.ClientID %>').show();
                $('#<%=divPlatformFilter.ClientID %>').hide();
            }
            else {
                $("#<%=spPlatform.ClientID %>").removeClass("tabTerritory");
                $("#<%=spPlatform.ClientID %>").removeClass("tabCountry");
                $("#<%=spPlatform.ClientID %>").addClass("tabCountry");
                $("#<%=spPlatform.ClientID %>").addClass("tabTerritory");
                $('#<%=divPlatformGroup.ClientID %>').hide();
                $('#<%=divPlatformFilter.ClientID %>').show();
            }
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
        }

        function showCountryList() {
            $("#Panel1").show();
            document.getElementById("Panel1").focus();

            $("#Panel1").focusout(function () {
                hideCountryList();
            });
        }

        function hideCountryList() {
            $("#Panel1").hide();
        }


        function CallOnLoad() {

            debugger;
            if ($('#<%=lsMovie.ClientID %>').val() != null) {
            $('#spTitleCount').html("(" + $('#<%=lsMovie.ClientID %>').val().length + ")");
            $("#<%=hdnTitleCodes.ClientID %>").val($('#<%=lsMovie.ClientID %>').val().join(','));
        }
        else {
            $('#spTitleCount').html("(0)");
            $("#<%=hdnTitleCodes.ClientID %>").val('');
        }


        if ($('#<%=hdnRegionType.ClientID %>').val() == 'T') {
            $("#tabCountry").addClass("tabTerritory");
            $("#<%=lstRegion.ClientID %>").prop('disabled', false).trigger("chosen:updated");
            $("#tabTerr").addClass("tabCountry");
            $('#<%=ddlTerritory.ClientID %>').val($('#<%=hdnRegionCodes.ClientID %>').val().split(',')).trigger('chosen:updated');


                if ($('#<%=ddlTerritory.ClientID %>').val() != null) {
                    var code;
                    if ($('#<%=chkIFTACluster.ClientID %>').is(":checked") == true) {
                        IFTACluster = "IFTA";
                    }
                    else {
                        IFTACluster = "T";
                    }


                    $.ajax({
                        type: "POST",
                        url: '<%=ResolveUrl("~/Web_Service")%>' + '/LoadCountry',// "../WebServices/getExchangeRateWebService.asmx/LoadCountry",
                        data: JSON.stringify({
                            code: $('#<%=ddlTerritory.ClientID %>').val(),
                            IFTACluster: IFTACluster
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true,
                        success: function (response) {
                            var countryList = ''
                            var exclusionRegionCode = '';

                            $("#<%=lstRegion.ClientID %>").empty();
                            $("#<%=lstWithoutExcludedRegion.ClientID %>").empty();

                            $(response).each(function () {
                                if (countryList == '')
                                    countryList = this.CountryName;
                                else
                                    countryList = countryList + ', ' + this.CountryName;

                                $("#<%=lstRegion.ClientID %>").append($("<option />").val(this.IntCode).text(this.CountryName));
                            $("#<%=lstWithoutExcludedRegion.ClientID %>").append($("<option />").val(this.IntCode).text(this.CountryName));
                        })

                            var strHTML = countryList.substring(0, 100);

                            if (strHTML != '') {
                                $('#<%=divCountries.ClientID %>').show();
                            strHTML = strHTML + "...";
                        }
                        else
                            $('#<%=divCountries.ClientID %>').hide();

                            $('#<%=divCountries.ClientID %>').html(strHTML);
                            $('#<%=hdnNames.ClientID %>').val(countryList);
                            $('#divNames').html(countryList.replace(/,/g, "<br>"));

                            if (countryList != '') {
                                var s = '<span id="readMoreRegion" style="color: blue;cursor: pointer;" >read more</span>';
                                $('#<%=divCountries.ClientID %>').append(s);
                        }

                            $("#<%=lstRegion.ClientID %>").val($('#<%=hdnExclusionRegionCode.ClientID %>').val().split(',')).trigger('chosen:updated');

                            $('#<%=lstRegion.ClientID %> option:selected').each(function () {
                                //debugger;
                                if (exclusionRegionCode == '')
                                    exclusionRegionCode = this.value;
                                else
                                    exclusionRegionCode = exclusionRegionCode + ',' + this.value;
                                $('#<%=lstWithoutExcludedRegion.ClientID %> option[value="' + this.value + '"]').remove();
                        });

                            //debugger;
                            if (exclusionRegionCode != '')
                                $('#spExclusionCountryCount').html("(" + exclusionRegionCode.split(',').length + ")");
                            else
                                $('#spExclusionCountryCount').html('(0)');

                            $("#<%=lstWithoutExcludedRegion.ClientID %>").val($('#<%=hdnMustHaveRegionCode.ClientID %>').val().split(',')).trigger('chosen:updated');

                        if ($("#<%=lstWithoutExcludedRegion.ClientID %>").val() != null)
                                $('#spMustExactHaveCountryCount').html("(" + $("#<%=lstWithoutExcludedRegion.ClientID %>").val().length + ")");
                        else
                            $('#spMustExactHaveCountryCount').html('(0)');

                            $('#<%=hdnExclusionRegionCode.ClientID %>').val(exclusionRegionCode);
                        },
                        failure: function (response) { }
                    });
                }

                $('#spCountryCount').html("");
                $('#tbTerritory').show();
                $("#tbCountry").hide();
            }
            else {
                var strHTML = '';

                $("#tabCountry").addClass("tabCountry");
                $("#tabTerr").addClass("tabTerritory");
                $('#<%=lstLTerritory.ClientID %>').val($('#<%=hdnRegionCodes.ClientID %>').val().split(',')).trigger('chosen:updated');

            $('#<%=lstLTerritory.ClientID %> option:selected').each(function () {
                    var s = $(this);
                    strHTML = strHTML + s[0].outerHTML;
                });

                $("#<%=lstWithoutExcludedRegion.ClientID %>").html(strHTML);
                $("#<%=lstWithoutExcludedRegion.ClientID %>").trigger('chosen:updated');
                $("#<%=lstRegion.ClientID %>").prop('disabled', true).trigger("chosen:updated");
                $("#<%=lstWithoutExcludedRegion.ClientID %>").val($('#<%=hdnMustHaveRegionCode.ClientID %>').val().split(',')).trigger('chosen:updated');
                $('#tbTerritory').hide();
                $("#tbCountry").show();

                if ($('#<%=lstLTerritory.ClientID %>').val() != null)
                    $('#spCountryCount').html("(" + $('#<%=lstLTerritory.ClientID %>').val().length + ")");
                else
                    $('#spCountryCount').html("(0)");

                $('#spExclusionCountryCount').html('');

                if ($("#<%=lstWithoutExcludedRegion.ClientID %>").val() != null)
                    $('#spMustExactHaveCountryCount').html("(" + $("#<%=lstWithoutExcludedRegion.ClientID %>").val().length + ")");
                else
                    $('#spMustExactHaveCountryCount').html('(0)');
            }


            if ($("[id*=<%=chkRegion.ClientID %>] input:checked").val() == "MH") {
            $("#<%=lstWithoutExcludedRegion.ClientID %>").prop('disabled', false).trigger("chosen:updated");
        }
        else {

            $("#<%=lstWithoutExcludedRegion.ClientID %>").prop('disabled', true).trigger("chosen:updated");
        }


        if ($('#<%=hdnLanguageType.ClientID %>').val() == 'G') {
            $("#tabLanguageID1").addClass("tabTerritory");
            $("#tabLanguageGropuID1").addClass("tabCountry");
        }
        else {
            // $("#tabLanguageID1").addClass("tabCountry");
            $("#tabLanguageGropuID1").addClass("tabTerritory");
        }

        $('#<%=ddlTerritory.ClientID %>').change(function () {
            debugger;
            $('#<%=hdnRegionCodes.ClientID %>').val($('#<%=ddlTerritory.ClientID %>').val());

            if ($('#<%=hdnRegionType.ClientID %>').val() == 'T') {

                if ($('#<%=chkIFTACluster.ClientID %>').is(":checked") == true) {
                    LoadCountryBasedOnTerritory('IFTA');
                }
                else {

                    LoadCountryBasedOnTerritory('T');

                }


                $('#spExclusionCountryCount').html('(0)');
                $('#spMustExactHaveCountryCount').html('(0)');
                $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
                }
        });

            if ($("[id*=<%=rblPeriodType.ClientID %>] input:checked").val() != "MI") {
            document.getElementById('<%=tblFix.ClientID %>').style.display = "block";
                document.getElementById('<%=tblMin.ClientID %>').style.display = "none";
            }
            else {
                document.getElementById('<%=tblMin.ClientID %>').style.display = "block";
                document.getElementById('<%=tblFix.ClientID %>').style.display = "none";
            }

            function LoadCountryBasedOnTerritory(IFTACluster) {
                debugger;

                $.ajax({
                    type: "POST",
                    url: '<%=ResolveUrl("~/Web_Service")%>' + '/LoadCountry',
                    data: JSON.stringify({
                        code: $('#<%=ddlTerritory.ClientID %>').val(),
                    IFTACluster: IFTACluster
                }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        debugger;
                        var countryList = ''

                        $("#<%=lstRegion.ClientID %>").empty();
                    $("#<%=lstWithoutExcludedRegion.ClientID %>").empty();

                    $(response).each(function () {
                        if (countryList == '')
                            countryList = this.CountryName;
                        else
                            countryList = countryList + ', ' + this.CountryName;

                        $("#<%=lstRegion.ClientID %>").append($("<option />").val(this.IntCode).text(this.CountryName));
                        $("#<%=lstWithoutExcludedRegion.ClientID %>").append($("<option />").val(this.IntCode).text(this.CountryName));
                    })

                    $('#<%=hdnExclusionRegionCode.ClientID %>').val('');
                    $('#<%=hdnMustHaveRegionCode.ClientID %>').val('');

                    var strHTML = countryList.substring(0, 90);

                    if (strHTML != '') {
                        $('#<%=divCountries.ClientID %>').show();
                        strHTML = strHTML + "...";
                    }
                    else
                        $('#<%=divCountries.ClientID %>').hide();

                    $('#<%=divCountries.ClientID %>').html(strHTML);
                    $('#<%=hdnNames.ClientID %>').val(countryList);
                    $('#divNames').html(countryList.replace(/,/g, "<br>"));

                    if (countryList != '') {
                        var s = '<span id="readMoreRegion" style="color: blue;cursor: pointer;" >read more</span>';
                        $('#<%=divCountries.ClientID %>').append(s);
                    }

                    $("#<%=lstRegion.ClientID %>").trigger('chosen:updated');
                    $("#<%=lstWithoutExcludedRegion.ClientID %>").trigger('chosen:updated');
                },
                    failure: function (response) { }
                });
        }

        $("#<%=lsMovie.ClientID %>").on("change", function () {
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y')

            if ($('#<%=lsMovie.ClientID %>').val() != null) {
                $('#spTitleCount').html("(" + $('#<%=lsMovie.ClientID %>').val().length + ")");
                $("#<%=hdnTitleCodes.ClientID %>").val($('#<%=lsMovie.ClientID %>').val().join(','));
                $("#<%=hdnTitleCode_SQ.ClientID %>").val($('#<%=lsMovie.ClientID %>').val().join(','));
            }
            else {
                $('#spTitleCount').html("(0)");
                $("#<%=hdnTitleCodes.ClientID %>").val('');
                $("#<%=hdnTitleCode_SQ.ClientID %>").val('');
            }

            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
        });

        $('#<%=lstLTerritory.ClientID %>').on('change', function (evt, params) {
            //debugger;
            var strHTML = '';
            var regionCode = '';

            $('#<%=hdnRegionCodes.ClientID %>').val('');

            $('#<%=lstLTerritory.ClientID %> option:selected').each(function () {
                var s = $(this);
                strHTML = strHTML + s[0].outerHTML;
                if (regionCode == '')
                    regionCode = s[0].value;
                else
                    regionCode = regionCode + ',' + s[0].value;
            });

            $('#<%=hdnRegionCodes.ClientID %>').val(regionCode);
            $("#<%=lstWithoutExcludedRegion.ClientID %>").html(strHTML);

            if ($('#<%=hdnMustHaveRegionCode.ClientID %>').val() != '') {
                $("#<%=lstWithoutExcludedRegion.ClientID %>").val($('#<%=hdnMustHaveRegionCode.ClientID %>').val().split(',')).trigger('chosen:updated');

                if ($("#<%=lstWithoutExcludedRegion.ClientID %>").val() != null) {
                    $('#<%=hdnMustHaveRegionCode.ClientID %>').val($("#<%=lstWithoutExcludedRegion.ClientID %>").val().join(','));
                    $('#spMustExactHaveCountryCount').html('(' + $('#<%=hdnMustHaveRegionCode.ClientID %>').val().split(',').length + ')');
                }
                else {
                    $('#<%=hdnMustHaveRegionCode.ClientID %>').val('');
                    $('#spMustExactHaveCountryCount').html('(0)');
                }
            }
            else {
                $("#<%=hdnMustHaveRegionCode.ClientID %>lstWithoutExcludedRegion").val('').trigger('chosen:updated');
                $('#spMustExactHaveCountryCount').html('(0)');
            }

            if (regionCode != '')
                $('#spCountryCount').html("(" + regionCode.split(',').length + ")");
            else
                $('#spCountryCount').html("(0)");

            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
        });

        $('#<%=lstRegion.ClientID %>').on('change', function (evt, params) {
            //debugger;
            var strHTML = '';
            var exclusionRegionCode = '';
            var mustHaveRegionCode = '';

            $('#<%=lstWithoutExcludedRegion.ClientID %>').empty();

            $('#<%=lstRegion.ClientID %> option').each(function () {
                var s = $(this);
                strHTML = strHTML + s[0].outerHTML;
            });

            $("#<%=lstWithoutExcludedRegion.ClientID %>").html(strHTML);

            $('#<%=lstRegion.ClientID %> option:selected').each(function () {
                if (exclusionRegionCode == '')
                    exclusionRegionCode = this.value;
                else
                    exclusionRegionCode = exclusionRegionCode + ',' + this.value;

                $('#<%=lstWithoutExcludedRegion.ClientID %> option[value="' + this.value + '"]').remove();
            });

            $('#<%=lstWithoutExcludedRegion.ClientID %>hdnExclusionRegionCode').val(exclusionRegionCode);

            //debugger;
            if (exclusionRegionCode != '')
                $('#spExclusionCountryCount').html("(" + exclusionRegionCode.split(',').length + ")");
            else
                $('#spExclusionCountryCount').html('(0)');

            $("#<%=lstWithoutExcludedRegion.ClientID %>").val($('#<%=hdnMustHaveRegionCode.ClientID %>').val().split(',')).trigger('chosen:updated');

            if ($("#<%=lstWithoutExcludedRegion.ClientID %>").val() != null) {
                mustHaveRegionCode = $("#<%=lstWithoutExcludedRegion.ClientID %>").val().join(',');
                $('#spMustExactHaveCountryCount').html("(" + mustHaveRegionCode.split(',').length + ")");
            }
            else
                $('#spMustExactHaveCountryCount').html('(0)');

            $('#<%=hdnExclusionRegionCode.ClientID %>').val(exclusionRegionCode);
            $('#<%=hdnMustHaveRegionCode.ClientID %>').val(mustHaveRegionCode);
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
        });

        $('#<%=lstWithoutExcludedRegion.ClientID %>').on('change', function (evt, params) {
            var exclusionRegionCode = '';

            $('#<%=lstWithoutExcludedRegion.ClientID %> option:selected').each(function () {
                if (exclusionRegionCode == '')
                    exclusionRegionCode = this.value;
                else
                    exclusionRegionCode = exclusionRegionCode + ',' + this.value;
            });

            if (exclusionRegionCode != '')
                $('#spMustExactHaveCountryCount').html("(" + exclusionRegionCode.split(',').length + ")");
            else
                $('#spMustExactHaveCountryCount').html('(0)');

            $('#<%=hdnMustHaveRegionCode.ClientID %>').val(exclusionRegionCode);
                $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
        });

        $('#<%=ddlLanguageGroup.ClientID %>').val('').trigger('chosen:updated');

        $('#<%=ddlLanguageGroup.ClientID %>').change(function () {
            if ($('#<%=hdnLanguageType.ClientID %>').val() == 'G') {
                $.ajax({
                    type: "POST",
                    url: '<%=ResolveUrl("~/Web_Service")%>' + '/LoadLanguage',//"../WebServices/getExchangeRateWebService.asmx/LoadLanguage",
                        data: JSON.stringify({
                            code: $('#ddlLanguageGroup').val()
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            $("#<%=lbLanguage.ClientID %>").empty();
                            var languageCode = ''

                            $(response).each(function () {
                                if (languageCode == '')
                                    languageCode = this.IntCode;
                                else
                                    languageCode = languageCode + ', ' + this.IntCode;

                                $("#<%=lbLanguage.ClientID %>").append($("<option selected='true' />").val(this.IntCode).text(this.LanguageName));
                            })

                            if (languageCode == '')
                                $('#spLanguageResult').html('(0)');
                            else
                                $('#spLanguageResult').html('(' + languageCode.split(',').length + ')');

                            $('#<%=hdnLanguageCodeExactMust.ClientID %>').val(languageCode);
                            $("#<%=lbLanguage.ClientID %>").trigger('chosen:updated');
                            initlyExpander();
                        },
                        failure: function (response) { }
                    });
                }

            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
        });

        $('#<%=lbSubtitling.ClientID %>').on('change', function (evt, params) {
            var strHTML = '';
            var languageCodes = ''

            $('#<%=lbSubtitling.ClientID %> option:selected').each(function () {
                var s = $(this);

                if (languageCodes == '')
                    languageCodes = s[0].value;
                else
                    languageCodes = languageCodes + ',' + s[0].value;
            });
            $('#<%=hdnSubTit_SQ.ClientID%>').val(languageCodes);
                if (languageCodes == '')
                    $('#spLanguageCount').html('(0)');
                else
                    $('#spLanguageCount').html('(' + languageCodes.split(',').length + ')');

                if ($("#<%=chkSameLanguage.ClientID %>").is(":checked")) {
                    if (languageCodes == '')
                        $('#spLanguageResult').html('(0)');
                    else
                        $('#spLanguageResult').html('(' + languageCodes.split(',').length + ')');

                    $("#<%=lbLanguage.ClientID %>").val(languageCodes.split(',')).trigger('chosen:updated');
                    $('#<%=hdnDubb_SQ.ClientID%>').val(languageCodes);
                }

                $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
            });

            if ($('#<%=lbSubtitling.ClientID %>').val() == null)
            $('#spLanguageCount').html('(0)');
        else
            $('#spLanguageCount').html('(' + $('#<%=lbSubtitling.ClientID %>').val().length + ')');

            $('#<%=chkSameLanguage.ClientID %>').on('change', function (evt, params) {
            if ($("#<%=chkSameLanguage.ClientID %>").is(":checked")) {
                    var languageCodes = ''

                    $('#<%=lbSubtitling.ClientID %> option:selected').each(function () {
                    var s = $(this);

                    if (languageCodes == '')
                        languageCodes = s[0].value;
                    else
                        languageCodes = languageCodes + ',' + s[0].value;
                });

                if (languageCodes == '')
                    $('#spLanguageResult').html('(0)');
                else
                    $('#spLanguageResult').html('(' + languageCodes.split(',').length + ')');

                $("#<%=lbLanguage.ClientID %>").val(languageCodes.split(',')).trigger('chosen:updated');
            }

                $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
            })

            $('#<%=lbLanguage.ClientID %>').on('change', function (evt, params) {
            var languageCodes = '';

            if ($('#<%=lbLanguage.ClientID %>').val() != null) {
                languageCodes = $('#<%=lbLanguage.ClientID %>').val().join(',');
            }

            if (languageCodes == '')
                $('#spLanguageResult').html('(0)');
            else
                $('#spLanguageResult').html('(' + languageCodes.split(',').length + ')');

            $('#<%=hdnLanguageCodeExactMust.ClientID %>').val(languageCodes);
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
            $('#<%=hdnDubb_SQ.ClientID%>').val(languageCodes);
        });

        if ($('#<%=lbLanguage.ClientID %>').val() == null)
            $('#spLanguageResult').html('(0)');
        else
            $('#spLanguageResult').html('(' + $('#<%=lbLanguage.ClientID %>').val().length + ')');

        $("#<%=lbTitleLang.ClientID %>").on("change", function () {
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
            var languageCodes = '';

            if ($('#<%=lbTitleLang.ClientID %>').val() != null) {
                languageCodes = $('#<%=lbTitleLang.ClientID %>').val().join(',');
            }
            $('#<%=hdnTL_SQ.ClientID%>').val(languageCodes);
        });
        $("#<%=ddlExclusive.ClientID %>").on("change", function () {
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
        });

        $("#<%=lbSubLicense.ClientID %>").on("change", function () {
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
            var sbLCodes = '';

            if ($('#<%=lbSubLicense.ClientID %>').val() != null) {
                sbLCodes = $('#<%=lbSubLicense.ClientID %>').val().join(',');
            }
            $('#<%=hdnSL_SQ.ClientID%>').val(sbLCodes);
        });

        $("#<%=chkRestRemarks.ClientID %>").on('change', function () {
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
        });

        $("#<%=chkOtherRemarks.ClientID %>").on('change', function () {
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
        });

       <%-- $("#<%=chkIFTACluster.ClientID %>").on('change', function () {
            debugger;
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
        });--%>




        $("#<%=chkIsOriginalLanguage.ClientID %>").on('change', function () {
            $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
        });
        $("#chkDigital").on('change', function () {
            $('#hdnIsCriteriaChange').val('Y');
        });


    }


    function LoadPlatform() {
        $.ajax({
            type: "POST",
            url: '<%=ResolveUrl("~/Reports/Title_Avail_Language_3.aspx")%>' + '/LoadUserControl', //"../WebServices/getExchangeRateWebService.asmx/LoadUserControl",
                data: JSON.stringify({}),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $('#divMainPlatform').append(response.d);
                },
                failure: function (response) { }
            });
        }

        function initlyExpander() {
            $('div.expandable').expander('destroy').expander({
                slicePoint: 50,  // default is 100
                expandPrefix: '...', // default is '... '
                expandText: '<span style="color:blue">...read more</span>', // default is 'read more'
                collapseTimer: 0,
                userCollapseText: '<span style="color:blue">[^]</span>'  // default is 'read less'
            });
        }

        var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

        function CalculateStartDate() {
            var x = parseInt($('#<%=txtMonths.ClientID %>').val());
            var CurrentDate = new Date();
            StartDate = new Date(CurrentDate.setMonth(CurrentDate.getMonth() + x));
            var day = StartDate.getDate();
            var monthIndex = StartDate.getMonth();
            var year = StartDate.getFullYear();
            $('#<%=spStartDate.ClientID %>').html('Date: ' + day + ' ' + monthNames[monthIndex] + ' ' + year);
}

function CalculateDate() {
    debugger;
    var StartDate = '';
    var EndDate = '';
    var CurrentDate = new Date();
    var month = parseInt(($('#<%=txtMonths.ClientID %>').val() == '') ? "0" : $('#<%=txtMonths.ClientID %>').val());
    var txtDaysWithin = parseInt(($('#<%=txtDaysWithin.ClientID %>').val() == '') ? "0" : $('#<%=txtDaysWithin.ClientID %>').val());
    var txtYearWithin = parseInt(($('#<%=txtYearWithin.ClientID %>').val() == '') ? "0" : $('#<%=txtYearWithin.ClientID %>').val());
    var day = '';

    StartDate = new Date(CurrentDate.setMonth(CurrentDate.getMonth() + month));
    StartDate.setDate(StartDate.getDate() + txtDaysWithin);
    StartDate.setFullYear(StartDate.getFullYear() + txtYearWithin);

    //if (month > 0 || txtYearWithin > 0)
    //    day = new Date(StartDate.setDate(StartDate.getDate() - 1)).getDate();
    //else
    day = StartDate.getDate();

    $('#<%=spStartDate.ClientID %>').val(day + '/' + (StartDate.getMonth() + 1) + '/' + StartDate.getFullYear());
        var CurrentEDate = new Date();
        var year = parseInt(($('#<%=txtYears.ClientID %>').val() == '') ? "0" : $('#<%=txtYears.ClientID %>').val());
        var txtNextmonth = parseInt(($('#<%=txtNextmonth.ClientID %>').val() == '') ? "0" : $('#<%=txtNextmonth.ClientID %>').val());
    var txtNextDays = parseInt(($('#<%=txtNextDays.ClientID %>').val() == '') ? "0" : $('#<%=txtNextDays.ClientID %>').val());

    EndDate = new Date(CurrentEDate.setMonth(CurrentEDate.getMonth() + txtNextmonth));
    EndDate.setDate(EndDate.getDate() + txtNextDays);
    EndDate.setFullYear(EndDate.getFullYear() + year);

    //if (year > 0 || txtNextmonth > 0)
    //    day = new Date(EndDate.setDate(EndDate.getDate() - 1)).getDate();
    //else
    day = EndDate.getDate();
    $('#<%=spEndDate.ClientID %>').val(day + '/' + (EndDate.getMonth() + 1) + '/' + EndDate.getFullYear());
    }

    function SetHiddenTitleCode() {
        if ($('#<%=lsMovie.ClientID %>').val() != '' && $('#<%=lsMovie.ClientID %>').val() != null)
            $('#<%=hdnTitleCodes.ClientID %>').val($('#<%=lsMovie.ClientID %>').val().join(','));
    }

    function MutExChkList(chk) {
        debugger;
        var chkList = chk.parentNode.parentNode.parentNode;
        var chks = chkList.getElementsByTagName("input");

        for (var i = 0; i < chks.length; i++) {
            if (chks[i] != chk && chk.checked) {
                chks[i].checked = false;
            }
            else {
                var response = $('label[for="' + chk.id + '"]').html();

                if (chk.id.indexOf("Region") > -1 && response == "Exact Match" && chk.checked) {
                    $("#<%=lstWithoutExcludedRegion.ClientID %>").prop('disabled', true).trigger("chosen:updated");
                }
                else if (chk.id.indexOf("Region") > -1 && response == "Must Have" && chk.checked) {
                    $("#<%=lstWithoutExcludedRegion.ClientID %>").prop('disabled', false).trigger("chosen:updated");
                }
                else if (chk.id.indexOf("Region") > -1) {
                    $("#<%=lstWithoutExcludedRegion.ClientID %>").prop('disabled', true).trigger("chosen:updated");
                }
    }
}

    $('#<%=hdnIsCriteriaChange.ClientID %>').val('Y');
    }

    function CloseQueryPopup() {
        $('#divConfirmReport').hide();
        overlay.appendTo(document.body).remove();
        return false;
    }

    function validateReportType() {
        //debugger;

        var strtxtReportName = $('#<%=txtReportName.ClientID %>');
        var tmp_rblVisibility = $(":radio[id*=<%=rblVisibility.ClientID %>]")[0];
        if (strtxtReportName.val().trim() == "") {
            AlertModalPopup(strtxtReportName, 'Please enter report name');
            strtxtReportName.focus();
            return false;
        }

        //if (tmp_rdQueryNo[0].checked) {
        //    tmp_rdQueryNo[0].checked = true;
        //    tmp_rdQueryYes[0].checked = false;
        //    tmp_rblVisibility.checked = true;
        //    strtxtReportName.val('');
        //    $('#divConfirmReport').hide();
        //    overlay.appendTo(document.body).remove();
        //}
        return true;
    }

    function SetReportNameVisibility(filter) {
        if (filter == 'Y') {
            $('#trReportName').show();
            $('#trRBVisibility').show();
            $('#trblank').hide();
            var strtxtReportName = $('#<%=txtReportName.ClientID %>');
            var tmp_rblVisibility = $(":radio[id*=<%=rblVisibility.ClientID %>]")[0];
            strtxtReportName.val('');
            strtxtReportName.focus();
            tmp_rblVisibility.checked = true;
        }
        else {
            $('#trReportName').hide();
            $('#trRBVisibility').hide();
            $('#trblank').show();
        }
    }

    function SetMultiselectDDLsAfterPageLoad() {
        debugger;
        var strtxtReportName = $('#<%=txtReportName.ClientID %>');
            debugger;
            if ($('#<%=hdnIsSaveQuery.ClientID %>').val() == "Y") {

            if ($('#<%=hdnDupQueryName.ClientID %>').val() == "Y") {
                AlertModalPopup(strtxtReportName, 'Report name already exists, please use another name');
                strtxtReportName.focus();


                strtxtReportName.val('');
                return false;
            }
            else {
                //Movie
                $("#<%=lsMovie.ClientID %>").val($('#<%=hdnTitleCode_SQ.ClientID %>').val().split(',')).trigger('chosen:updated');
                    if ($("#<%=lsMovie.ClientID %>").val() != null)
                        $('#spTitleCount').html("(" + $("#<%=lsMovie.ClientID %>").val().length + ")");
                else
                    $('#spTitleCount').html('(0)');

                    //Title Lang
                $("#<%=lbTitleLang.ClientID %>").val($('#<%=hdnTL_SQ.ClientID %>').val().split(',')).trigger('chosen:updated');

                    //Sublicense 
                    $("#<%=lbSubLicense.ClientID %>").val($('#<%=hdnSL_SQ.ClientID %>').val().split(',')).trigger('chosen:updated');

                    //Subtitling
                    $("#<%=lbSubtitling .ClientID %>").val($('#<%=hdnSubTit_SQ.ClientID %>').val().split(',')).trigger('chosen:updated');
                    if ($("#<%=lbSubtitling .ClientID %>").val() != null)
                        $('#spLanguageCount').html("(" + $("#<%=lbSubtitling.ClientID %>").val().length + ")");
                else
                    $('#spLanguageCount').html('(0)');

                    //Subtitling
                $("#<%=lbLanguage .ClientID %>").val($('#<%=hdnDubb_SQ.ClientID %>').val().split(',')).trigger('chosen:updated');
                    if ($("#<%=lbLanguage .ClientID %>").val() != null)
                        $('#spLanguageResult').html("(" + $("#<%=lbLanguage.ClientID %>").val().length + ")");
                else
                    $('#spLanguageResult').html('(0)');

                if ($("[id*=<%=rblPeriodType.ClientID %>] input:checked").val() == "MI") {
                        $('#<%=spStartDate.ClientID %>').val($('#<%=hdnStartDate.ClientID %>').val());
                        $('#<%=spEndDate.ClientID %>').val($('#<%=hdnEndDate.ClientID %>').val());

                        var a = $('#<%=hdnEndDate.ClientID %>').val();
                        var b = $('#<%=hdnStartDate.ClientID %>').val();
                        var StartDate = $('#<%=spStartDate.ClientID %>').datepick('getDate')[0];
                        var val = monthDiff(new Date(), StartDate);
                        var year = parseInt(val / 12);
                        var month = parseInt(val % 12);
                        StartDate.setMonth(StartDate.getMonth() - month);
                        var initDate = new Date(StartDate.setFullYear(StartDate.getFullYear() - year));
                        var days = parseInt((initDate - new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate())) / 86400000);

                        if (initDate.getDate() < new Date().getDate())
                            days = days + 1;

                        $('#<%=txtMonths.ClientID %>').val(month);
                        $('#<%=txtDaysWithin.ClientID %>').val(days);
                        $('#<%=txtYearWithin.ClientID %>').val(year);

                        var EndDate = $('#<%=spEndDate.ClientID %>').datepick('getDate')[0];

                        var val_1 = monthDiff(new Date(), EndDate);
                        var year_1 = parseInt(val_1 / 12);
                        var month_1 = parseInt(val_1 % 12);
                        EndDate.setMonth(EndDate.getMonth() - month_1);
                        var initDate_1 = new Date(EndDate.setFullYear(EndDate.getFullYear() - year_1));
                        var days_1 = parseInt((initDate_1 - new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate())) / 86400000);

                        if (initDate_1.getDate() < new Date().getDate())
                            days_1 = days_1 + 1;

                        $('#<%=txtNextmonth.ClientID %>').val(month_1);
                        $('#<%=txtNextDays.ClientID %>').val(days_1);
                        $('#<%=txtYears.ClientID %>').val(year_1);


                    } else {

                        $('#<%=txtfrom.ClientID %>').val($('#<%=hdnStartDate.ClientID %>').val());
                        if ($('#<%=hdnEndDate.ClientID %>').val() == '') {
                            $('#<%=txtto.ClientID %>').val(dateWatermarkFormat);
                            $('#<%=txtto.ClientID %>').css('color', dateWatermarkColor);
                        }
                        else
                            $('#<%=txtto.ClientID %>').val($('#<%=hdnEndDate.ClientID %>').val());
                    }
                }

            }

        }

        function hideTab() {
            debugger;
            $('#<%=liImgResults.ClientID%>').removeClass();
            $('#<%=liImgCriteria.ClientID%>').removeClass();
           $('#<%=liImgSavedQuery.ClientID%>').addClass('active');
           $('#<%=tblCriteria.ClientID%>').attr('style', 'display:none');
           $('#<%=SavedQuery.ClientID%>').attr('style', '');
           $('#<%=Results.ClientID%>').attr('style', 'display:none');
           $('#<%=hdnDupQueryName.ClientID%>').val('');
           $('#<%=hdnTabName.ClientID%>').val('QueryList');
           $('#<%=ddlBusinessUnit.ClientID%>').removeAttr('disabled');
           return false;
       }
       function isNumber(evt) {
           evt = (evt) ? evt : window.event;
           var charCode = (evt.which) ? evt.which : evt.keyCode;
           if (charCode > 31 && (charCode < 48 || charCode > 57) && charCode != 13) {
               return false;
           }
           else {
               return true;
           }
       }
    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0"></asp:ScriptManager>
    <div class="top_area">
        <h2 class="pull-left">
            <asp:Label ID="lblModuleName" runat="server"></asp:Label>
        </h2>
        <div class="right_nav pull-right">
            <ul>
                <li>Business Unit</li>
                <li>
                    <asp:DropDownList ID="ddlBusinessUnit" runat="server" AutoPostBack="true" CssClass="select" OnSelectedIndexChanged="ddlBusinessUnit_SelectedIndexChanged">
                    </asp:DropDownList>
                    <asp:HiddenField ID="hdnIsCriteriaChange" runat="server" />
                </li>
            </ul>
        </div>
    </div>
    <table align='center' border='0' cellpadding='0' cellspacing='0' width='98%'>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <table width='100%' border='0' cellpadding='0' cellspacing='0' align='center' valign='bottom'>
                    <tr>
                        <td valign="bottom">
                            <asp:Panel ID="pnlDealTab" runat="server" Width="100%">
                                <div class="navigation_tabs">
                                    <div class="tabbable">
                                        <ul class="nav nav-tabs nav-tab pull-left">

                                            <li class="active" runat="server" id="liImgSavedQuery">
                                                <%--<span>Saved Query</span>
                                                <input  />--%>
                                                <asp:Button runat="server" ID="imgSavedQuery" OnClientClick="return hideTab('S');" Height="27px" Text="Query List"></asp:Button>
                                                <%--<asp:Button runat="server" ID="imgSavedQuery" OnClick="imgColumns_Click" Text="Saved Query"></asp:Button>--%>
                                                <span></span>
                                            </li>
                                            <li runat="server" id="liImgCriteria">
                                                <asp:Button runat="server" ID="imgCriteria1" Text="Criteria" Height="27px" OnClick="imgCriteria_Click"></asp:Button>
                                                <span></span>
                                            </li>
                                            <li class="" runat="server" id="liImgResults">
                                                <asp:Button runat="server" ID="imgResults" OnClick="imgResults_Click" Text="Result" Height="27px" OnClientClick="return ValidateTitle();"></asp:Button>
                                                <span></span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </asp:Panel>
                        </td>
                    </tr>
                    <tr>
                        <td class="tabBorder" width='100%' border='0' cellpadding='0' cellspacing='0' align='center'
                            valign='top'>
                            <div class="tab-content clearfix table-wrapper scale_table_container">
                                <table id="tblCriteria" runat="server" width='100%' class="table-wrapper" border='0' cellpadding='0' cellspacing='0' align='center' valign='top'>
                                    <tr>
                                        <td style="width: 100%; display: block;">
                                            <div id="accordion" class="ui-accordion ui-widget ui-helper-reset">
                                                <h3 class="accordion-header ui-accordion-header ui-helper-reset ui-state-default ui-accordion-icons ui-corner-all">
                                                    <span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>
                                                    GENERAL
                                                </h3>
                                                <div class="ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom" id="divGeneral">
                                                    <table>
                                                        <tr style="height: 25px;">
                                                            <th style="width: 33%"><b>Title&nbsp;<span id="spTitleCount">(0)</span></b></th>
                                                            <th style="width: 34%"><b>Period</b></th>
                                                            <th style="width: 34%"><b>Additional</b></th>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center; width: 33%;">
                                                                <asp:UpdatePanel runat="server" ID="upTitle" UpdateMode="Conditional">
                                                                    <ContentTemplate>
                                                                        <asp:LinkButton ID="lbSelectTitles" runat="server" OnClientClick="SetHiddenTitleCode();" CommandName="PD"
                                                                            OnClick="lbSelectTitles_Click" Style="font-weight: bold; text-decoration: underline">
                                                                        Search Titles &nbsp;
                                                                        <img src="../Images/icon-search.png" /></asp:LinkButton>
                                                                        <asp:HiddenField runat="server" ID="hdnTitleCodes" />
                                                                        <asp:HiddenField runat="server" ID="hdnTitleCode_SQ" EnableViewState="true" />
                                                                        <asp:HiddenField runat="server" ID="hdnTL_SQ" EnableViewState="true" />
                                                                        <asp:HiddenField runat="server" ID="hdnSL_SQ" EnableViewState="true" />
                                                                        <asp:HiddenField runat="server" ID="hdnSubTit_SQ" EnableViewState="true" />
                                                                        <asp:HiddenField runat="server" ID="hdnDubb_SQ" EnableViewState="true" />
                                                                        <asp:HiddenField runat="server" ID="hdnIsSaveQuery" EnableViewState="true" />
                                                                        <asp:HiddenField runat="server" ID="hdnStartDate" EnableViewState="true" />
                                                                        <asp:HiddenField runat="server" ID="hdnEndDate" EnableViewState="true" />
                                                                        <asp:HiddenField runat="server" ID="hdnDupQueryName" EnableViewState="true" />
                                                                        <asp:HiddenField runat="server" ID="hdnstrCriteria" EnableViewState="true" />
                                                                        <asp:HiddenField runat="server" ID="hdnTabName" />
                                                                        <asp:HiddenField runat="server" ID="hdnIsDidital" />
                                                                        <br />
                                                                        <br />
                                                                        <asp:ListBox ID="lsMovie" runat="server" class="ChosenTitle" onClick="TitleChange();" Width="95%" SelectionMode="Multiple"></asp:ListBox>
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                                <table class="tbleRadio">
                                                                    <tr>
                                                                        <td>
                                                                            <%--<asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal">
                                                                                <asp:ListItem Selected="True" Text="Internal" Value="Y"></asp:ListItem>
                                                                                <asp:ListItem Text="External" Value="no"></asp:ListItem>
                                                                                
                                                                            </asp:RadioButtonList>--%>
                                                                            <asp:CheckBox ID="chkMetadata" runat="server" Text="Include Metadata" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td valign="top" style="width: 33%;">
                                                                <table class="tbleRadio">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:RadioButtonList ID="rblPeriodType" runat="server" RepeatDirection="Horizontal"
                                                                                onClick="SelectPeriodType(this);">
                                                                                <asp:ListItem Selected="True" Text="Minimum" Value="MI"></asp:ListItem>
                                                                                <asp:ListItem Text="Flexi" Value="FL"></asp:ListItem>
                                                                                <asp:ListItem Text="Fixed" Value="FI"></asp:ListItem>
                                                                            </asp:RadioButtonList>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <br />
                                                                <table align="left" cellspacing="0" cellpadding="3" class="" id="tblMin" runat="server">
                                                                    <tr>
                                                                        <td>&nbsp;</td>
                                                                        <td>DD</td>
                                                                        <td>MM</td>
                                                                        <td>YY</td>
                                                                        <td>&nbsp;</td>
                                                                        <td style="text-align: center;">Date</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="">Start within
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtDaysWithin" runat="server" CssClass="text" Width="37px" onblur="CalculateDate();"></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtMonths" runat="server" CssClass="text" Width="37px" onblur="CalculateDate();"></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtYearWithin" runat="server" CssClass="text" Width="37px" onblur="CalculateDate();"></asp:TextBox>
                                                                        </td>
                                                                        <td>&nbsp;&nbsp;&nbsp;Start</td>
                                                                        <td>
                                                                            <asp:TextBox ID="spStartDate" Width="100px" MaxLength="50" CssClass="text dateRange"
                                                                                runat="server" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="">For next
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtNextDays" runat="server" CssClass="text" Width="37px" onblur="CalculateDate();"></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtNextmonth" runat="server" CssClass="text" Width="37px" onblur="CalculateDate();"></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtYears" runat="server" CssClass="text" Width="37px" onblur="CalculateDate();"></asp:TextBox>
                                                                        </td>
                                                                        <td>&nbsp;&nbsp;&nbsp;End</td>
                                                                        <td>
                                                                            <asp:TextBox ID="spEndDate" Width="100px" MaxLength="50" CssClass="text dateRange" runat="server"
                                                                                onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table cellspacing="0" cellpadding="3" id="tblFix" runat="server" style="display: none; width: 100%;">
                                                                    <tr>
                                                                        <td style="width: 5%;">&nbsp;</td>
                                                                        <td style="width: 30%; text-align: right;">Available From :</td>
                                                                        <td style="width: 40%; text-align: center;">
                                                                            <asp:TextBox ID="txtfrom" AutoPostBack="true" Width="100px" MaxLength="50" CssClass="text dateRange" runat="server"
                                                                                onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                                                            <a href="#" onclick="clearDate('CphdBody_txtfrom');">clear</a>
                                                                            <asp:HiddenField ID="hdnDateWatermarkFormat" runat="server" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>&nbsp;</td>
                                                                        <td style="text-align: right;">To :</td>
                                                                        <td style="text-align: center;">
                                                                            <asp:TextBox ID="txtto" AutoPostBack="true" Width="100px" MaxLength="50" CssClass="text dateRange"
                                                                                runat="server" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                                                            <a href="#" onclick="clearDate('CphdBody_txtto');">clear</a>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td align="left" style="text-align: left; width: 33%;">
                                                                <table width="90%" align="center" cellpadding="2" cellspacing="0" class="mainReports">
                                                                    <tr>
                                                                        <td style="width: 35%;">
                                                                            <asp:CheckBox ID="chkIsOriginalLanguage" runat="server" Checked="true" Text="Title Language" />
                                                                        </td>
                                                                        <td class="" style="text-align: left">
                                                                            <asp:ListBox ID="lbTitleLang" runat="server" class="ChosenTitle" Width="90%" SelectionMode="Multiple"></asp:ListBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Exclusivity</td>
                                                                        <td class="" style="text-align: left">
                                                                            <asp:DropDownList ID="ddlExclusive" runat="server" Width="90%" CssClass="select">
                                                                                <asp:ListItem Selected="True" Text="Both" Value="B"></asp:ListItem>
                                                                                <asp:ListItem Text="Exclusive" Value="E"></asp:ListItem>
                                                                                <asp:ListItem Text="Non Exclusive" Value="N"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td></td>
                                                                        <td>
                                                                            <asp:CheckBox ID="chkDigital" runat="server" Checked="true" Text="Self Consumption" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Sub Licensing</td>
                                                                        <td class="" style="text-align: left">
                                                                            <asp:ListBox ID="lbSubLicense" runat="server" class="ChosenTitle" Width="90%" SelectionMode="Multiple"></asp:ListBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2">
                                                                            <asp:CheckBox ID="chkShowRemarks" runat="server" Text="Show Remarks" Visible="false" />
                                                                            <asp:CheckBox ID="chkRestRemarks" runat="server" Text="Restriction Remarks &nbsp;&nbsp;" />
                                                                            <asp:CheckBox ID="chkOtherRemarks" runat="server" Text="Other Remarks" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <h3 class="accordion-header ui-accordion-header ui-helper-reset ui-state-default ui-accordion-icons ui-corner-all">
                                                    <span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>
                                                    REGION
                                                </h3>
                                                <div class="ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom">
                                                    <table>

                                                        <tr style="height: 25px;">
                                                            <td class="pagingborder" style="text-align: center;">
                                                                <b>
                                                                    <span onclick="RegionTabSelect('T')" id="tabTerr">Territory</span>
                                                                    <span id="tabCountry" onclick="RegionTabSelect('C')">Country&nbsp;<span id="spCountryCount"></span></span>
                                                                    <asp:HiddenField ID="hdnRegionType" Value="T" runat="server" />
                                                                </b>
                                                            </td>
                                                            <td class="pagingborder" style="text-align: center;">
                                                                <b>Exclusion &nbsp;<span id="spExclusionCountryCount">(0)</span></b>
                                                            </td>
                                                            <td class="pagingborder" style="text-align: center;">
                                                                <b>
                                                                    <asp:CheckBoxList ID="chkRegion" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                                                        <asp:ListItem Text="Exact Match &nbsp;&nbsp;&nbsp;" Value="EM" onclick="MutExChkList(this);"></asp:ListItem>
                                                                        <asp:ListItem Text="Must Have" Value="MH" onclick="MutExChkList(this);"></asp:ListItem>
                                                                    </asp:CheckBoxList>
                                                                    &nbsp;<span id="spMustExactHaveCountryCount">(0)</span>
                                                                </b>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="" style="text-align: center; width: 33%; vertical-align: top;">
                                                                <table width="90%" align="center" cellpadding="0" cellspacing="0" class="mainReports" id="tbTerritory" style="height: 100px; vertical-align: top;">
                                                                    <tr>

                                                                        <td>

                                                                            <asp:CheckBox ID="chkIFTACluster" runat="server" Text="Is IFTA Cluster" OnCheckedChanged="chkIFTACluster_CheckedChanged" AutoPostBack="True" onclick="clearData()" />

                                                                            <asp:DropDownList ID="ddlTerritory" runat="server" class="Chosenlb"
                                                                                Height="25px" Width="95%">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <div id="divCountries" runat="server" style="height: 40px; overflow-x: auto; display: none;">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table id="tbCountry" width="90%" align="center" cellpadding="0" cellspacing="0"
                                                                    class="mainReports" style="display: none; height: 100px; vertical-align: top;">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:ListBox ID="lstLTerritory" runat="server" class="Chosenlb"
                                                                                Height="25px" Width="95%" SelectionMode="Multiple"></asp:ListBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td class="" style="text-align: center; width: 34%; vertical-align: top; padding-top: 15px;">
                                                                <asp:ListBox ID="lstRegion" runat="server" class="Chosenlb" Height="140px" Width="95%" SelectionMode="Multiple"></asp:ListBox>
                                                            </td>
                                                            <td class="" style="text-align: center; width: 33%; vertical-align: top; padding-top: 15px;">
                                                                <asp:ListBox ID="lstWithoutExcludedRegion" runat="server" class="Chosenlb" Height="140px" Width="95%" SelectionMode="Multiple"></asp:ListBox>
                                                            </td>
                                                            <asp:HiddenField runat="server" ID="hdnRegionCodes" Value="" />
                                                            <asp:HiddenField runat="server" ID="hdnExclusionRegionCode" Value="" />
                                                            <asp:HiddenField runat="server" ID="hdnMustHaveRegionCode" Value="" />
                                                        </tr>
                                                    </table>
                                                </div>
                                                <h3 class="accordion-header ui-accordion-header ui-helper-reset ui-state-default ui-accordion-icons ui-corner-all">
                                                    <span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>
                                                    PLATFORM
                                                </h3>
                                                <div class="ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom">
                                                    <table id="tabpop" runat="server">
                                                        <tr style="height: 25px;">
                                                            <td class="pagingborder" style="text-align: center; width: 50%" colspan="2">
                                                                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                                                    <ContentTemplate>
                                                                        <b>
                                                                            <asp:Button ID="spPlatform" Text="Platform" OnClick="spPlatform_Click" runat="server" />
                                                                            <asp:Button ID="spPlatformGroup" Text="Platform Group" OnClick="spPlatformGroup_Click" runat="server" />
                                                                            <%-- <span onclick="PlatformTabSelect('P')" id="spPlatform">Platform</span>
                                                                <span id="spPlatformGroup" class="tabTerritory" onclick="PlatformTabSelect('PG')">Platform Group</span>--%>
                                                                        </b>
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                            <td class="pagingborder" style="text-align: center; width: 50%" colspan="2">
                                                                <asp:UpdatePanel ID="upExact" runat="server" UpdateMode="Conditional">
                                                                    <ContentTemplate>
                                                                        <b>
                                                                            <asp:CheckBoxList ID="chkExact" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                                                                                OnSelectedIndexChanged="chkExact_SelectedIndexChanged" AutoPostBack="true">
                                                                                <asp:ListItem Text="Exact Match &nbsp;&nbsp;&nbsp;" Value="EM" onclick="MutExChkList(this);"></asp:ListItem>
                                                                                <asp:ListItem Text="Must Have" Value="MH" onclick="MutExChkList(this);"></asp:ListItem>
                                                                            </asp:CheckBoxList>
                                                                        </b>
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" style="text-align: center; width: 50%; height: 250px">
                                                                <asp:UpdatePanel ID="upMainPlatform" runat="server" UpdateMode="Conditional" class="platformTree">
                                                                    <ContentTemplate>
                                                                        <div id="divPlatformFilter" runat="server">
                                                                            <asp:TextBox ID="txtPlatformSearch" runat="server" MaxLength="100"></asp:TextBox>
                                                                            <asp:Button ID="btnSearch_plt" runat="server" CssClass="button" Text="Search"
                                                                                OnClientClick="return ValidateMandatoryField1();" OnClick="btnSearch_plt_Click" />
                                                                            <asp:Button ID="btnShowAll_plt" runat="server" CssClass="button" Text="Show All"
                                                                                OnClick="btnShowAll_plt_Click" />
                                                                        </div>
                                                                        <div id="divPlatformGroup" style="display: none;" runat="server">
                                                                            <asp:DropDownList ID="ddlPlatformGroup" runat="server" class="Chosenlb" AutoPostBack="true"
                                                                                OnSelectedIndexChanged="ddlPlatformGroup_SelectedIndexChanged" />
                                                                        </div>
                                                                        <table width="90%" align="center" cellpadding="0" cellspacing="0" class="mainReports" style="width: 100%">
                                                                            <tr>
                                                                                <td>
                                                                                    <div style="width: 98%; overflow-y: auto; height: 250px" id="divMainPlatform">
                                                                                        <ucPTV:ucTab ID="uctabPTV" runat="server" />
                                                                                        <asp:HiddenField ID="hdnIsMustHave" runat="server" />
                                                                                        <asp:HiddenField ID="hdnPlatformMH" runat="server" />
                                                                                        <asp:HiddenField ID="hdnPlatform" runat="server" />
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                            <td valign="top" colspan="2" style="text-align: center; width: 50%;">
                                                                <asp:UpdatePanel ID="upSelectedPlatform" runat="server" UpdateMode="Conditional" class="platformTree">
                                                                    <ContentTemplate>
                                                                        <div style="margin-top: 10px;">
                                                                            <asp:TextBox ID="txtSelectedPlatformSearch" runat="server" MaxLength="100"></asp:TextBox>
                                                                            <asp:Button ID="btnSearch_plt_Selected" runat="server" CssClass="button" Text="Search"
                                                                                OnClientClick="return ValidateMandatoryField2();" OnClick="btnSearch_plt_Selected_Click" />
                                                                            <asp:Button ID="btnShowAll_plt_Selected" runat="server" CssClass="button" Text="Show All"
                                                                                OnClick="btnShowAll_plt_Selected_Click" />
                                                                        </div>
                                                                        <table width="90%" align="center" cellpadding="0" cellspacing="0" class="mainReports" style="width: 100%">
                                                                            <tr>
                                                                                <td>
                                                                                    <div style="width: 98%; overflow-y: auto; height: 250px">
                                                                                        <ucSelectedPTV:ucTab ID="uctabSelectedplt" runat="server" />
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </ContentTemplate>
                                                                    <Triggers>
                                                                        <asp:AsyncPostBackTrigger ControlID="chkExact" EventName="SelectedIndexChanged" />
                                                                    </Triggers>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>


                                                <h3 class="accordion-header ui-accordion-header ui-helper-reset ui-state-default ui-accordion-icons ui-corner-all">
                                                    <span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>
                                                    LANGUAGE
                                                </h3>
                                                <div class="ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom">
                                                    <table>
                                                        <tr style="height: 25px;">
                                                            <td class="pagingborder" style="text-align: center; width: 50%" colspan="2">
                                                                <span id="tabLanguageGropuID1" onclick="LanguageTabSelect('G')" style="display: none;">Language Group</span>
                                                                <span id="tabLanguageID1"><b>Subtitling Language <span id="spLanguageCount">(0)</span></b></span>
                                                                <asp:HiddenField ID="hdnLanguageType" Value="L" runat="server" />
                                                            </td>
                                                            <td class="pagingborder" style="text-align: center; width: 50%;" colspan="2">
                                                                <b>Dubbing Language <span id="spLanguageResult">(0)</span></b>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center; width: 50%;" colspan="2">
                                                                <table width="90%" align="center" cellpadding="0" cellspacing="0" class="mainReports">
                                                                    <tr id="tblLanguageGroup" style="display: none;">
                                                                        <td>
                                                                            <asp:DropDownList ID="ddlLanguageGroup" runat="server" class="Chosenlb"
                                                                                Height="25px" Width="95%">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr id="tblLanguage">
                                                                        <td>
                                                                            <asp:ListBox ID="lbSubtitling" runat="server" class="Chosenlb" Height="25px" Width="95%" SelectionMode="Multiple"></asp:ListBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>&nbsp;</td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="text-align: center; width: 50%;" colspan="2">
                                                                <table width="90%" align="center" cellpadding="0" cellspacing="0" class="mainReports">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:ListBox ID="lbLanguage" runat="server" class="Chosenlb"
                                                                                Height="140px" Width="95%" SelectionMode="Multiple"></asp:ListBox>
                                                                            <asp:HiddenField ID="hdnLanguageCodeExactMust" runat="server" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <b>
                                                                                <%--<asp:CheckBox ID="chkSubTitling" runat="server" Text="Sub Titling" />
                                                                                    <asp:CheckBox ID="chkDubbing" runat="server" Text="Dubbing" />--%>
                                                                                <asp:CheckBox ID="chkSameLanguage" runat="server" Checked="true"
                                                                                    Text="Select same language for dubbing" />
                                                                            </b>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>

                                            </div>
                                        </td>
                                    </tr>
                                </table>

                                <table id="SavedQuery" runat="server">
                                    <tr>
                                        <td colspan="3">
                                            <div class="paging_area clearfix">
                                                <div class="divBlock">
                                                    <div style="float: left;">
                                                        <span class="pull-left">Total Records:
                                                                    <asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label>&nbsp;
                                                                    <asp:Label ID="lblMdt" runat="server" CssClass="lblmandatory" Text="(*) Mandatory Field" Visible="False"></asp:Label>
                                                        </span>
                                                    </div>
                                                    <div style="float: right;">
                                                        <asp:DataList ID="dtLst" runat="server" RepeatDirection="Horizontal" OnItemCommand="dtLst_ItemCommand"
                                                            OnItemDataBound="dtLst_ItemDataBound">
                                                            <ItemTemplate>
                                                                <asp:Button ID="btnPager" CssClass="pagingbtn" Text='<%#  ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Attrib %>'
                                                                    CommandArgument='<%#  ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Val %>'
                                                                    runat="server" />
                                                            </ItemTemplate>
                                                        </asp:DataList>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <asp:GridView ID="gvSchedule" runat="server" AutoGenerateColumns="False" Width="100%"
                                                class="table table-bordered table-hover" DataKeyNames="Avail_Report_Schedule_Code" OnRowDeleting="gvSchedule_RowDeleting" OnRowCommand="gvSchedule_RowCommand" OnRowDataBound="gvSchedule_RowDataBound">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Report Name">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblReportName" runat="server" Text='<%# Eval("ReportName") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="25%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Inserted By">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblUserName" runat="server" Text='<%# Eval("UserName") %>'></asp:Label>
                                                                <asp:Label ID="lblAvail_Report_Schedule_Code" runat="server" Text='<%# Eval("Avail_Report_Schedule_Code") %>' Style="display: none;"></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="25%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Inserted On">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblInserted_On" runat="server" Text='<%# Eval("Inserted_On") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="25%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Action">
                                                        <ItemTemplate>
                                                            <asp:Button ID="btnGenerate" runat="server" Text="Run Query" CssClass="button" CommandName="GENERATE"
                                                                CommandArgument='<%# DataBinder.Eval(Container, "RowIndex") %>' />
                                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="button" CommandName="DELETE" OnClientClick="javascript:return ShowActiveSms(this, 'Are you sure, you want to delete ?', this);" />

                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle HorizontalAlign="Center" Width="25%" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                            <asp:HiddenField runat="server" ID="hdnTabVal" EnableViewState="true" />
                                        </td>
                                    </tr>
                                </table>

                                <table class="table table-bordered" id="Results" runat="server" style="width: 100%">
                                    <tr>
                                        <td>
                                            <table width='100%' border='0' cellpadding='0' cellspacing='0' align='center' valign='top'>
                                                <tr>
                                                    <td class='normal'>
                                                        <table width="100%" cellpadding="3" cellspacing="0" align="left" border="0" class="paging">
                                                            <tr>
                                                                <td class='white' align="right" width="10%">
                                                                    <%--Query ID:--%>
                                                                    <asp:TextBox ID='txtQid' runat="server" ReadOnly="True" Width="39px"
                                                                        Style="display: none" CssClass="text"></asp:TextBox>
                                                                    <b>Report Name: </b>
                                                                </td>
                                                                <td class='white' width="15%">
                                                                    <asp:TextBox ID='txtReportName' runat="server" CssClass="text" ValidationGroup="SAVE"
                                                                        Width="200px"></asp:TextBox>
                                                                    <asp:HiddenField ID="hdnReportCode" runat="server" />
                                                                </td>
                                                                <td class='white' style="text-align: right;">
                                                                    <b>Visibility: </b>
                                                                </td>
                                                                <td style="padding-left: 10px; width: 275px;">
                                                                    <asp:RadioButtonList ID="rblVisibility" runat="server" RepeatDirection="Horizontal">
                                                                        <asp:ListItem Value="PU" Text="Public" Selected="True"></asp:ListItem>
                                                                        <asp:ListItem Value="RO" Text="Role Based"></asp:ListItem>
                                                                        <asp:ListItem Value="PR" Text="Private"></asp:ListItem>
                                                                    </asp:RadioButtonList>
                                                                </td>
                                                                <td class="normal" align="right">
                                                                    <asp:RequiredFieldValidator ID="rfvQName" runat="server" ControlToValidate="txtReportName"
                                                                        Display="None" ErrorMessage="Please enter Report Name." SetFocusOnError="True"
                                                                        ValidationGroup="SAVE" ForeColor="Black"></asp:RequiredFieldValidator>
                                                                    <%--<AjaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender1" runat="server"
                                                                        TargetControlID="rfvQName">
                                                                    </AjaxToolkit:ValidatorCalloutExtender>--%>
                                                                    &nbsp; &nbsp;
                                                                        <asp:Button Text='Save Query' runat="server" ID="btnSaveQuery" OnClientClick="return validateReportType();" CssClass="btn btn-primary"
                                                                            OnClick="btnSaveQuery_Click" ValidationGroup="SAVE" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" class="normal" colspan="2">
                                                        <table runat="server" id="Reporttable" width="100%" class="search" cellpadding="3"
                                                            cellspacing="0">
                                                            <tr>
                                                                <td align="left" class="normal" id="tdlbl" runat="server">
                                                                    <asp:Label ID="lblrecordcount" runat="server"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table>
                                                <tr id="divReport" runat="server" width="100%" height="540px">
                                                    <td class="normal" style="height: 540px">
                                                        <rsweb:ReportViewer ID="ReportViewer1" runat="server" ShowParameterPrompts="false"
                                                            Style="width: 100%;" Visible="false" CssClass="reportViewer">
                                                        </rsweb:ReportViewer>
                                                    </td>
                                                </tr>
                                            </table>

                                            <%--<rsweb:ReportViewer ID="ReportViewer1" runat="server" ShowParameterPrompts="false"
                                                Style="width: 100%;" Visible="false" CssClass="reportViewer">
                                            </rsweb:ReportViewer>--%>

                                        </td>
                                    </tr>
                                </table>

                            </div>
                        </td>
                    </tr>
                    <%-- <tr>
                        <td>
                            <div class='popup' id="divConfirmReport">
                                <div class='content2' id="divContent2">
                                    <img src="../images/fancy_close.png" alt='quit' class='X' id='Img2' onclick="CloseQueryPopup()" />
                                    <table width='100%' border='0' cellspacing="2" cellpadding="2" align='center' valign='top'>
                                        <tr>
                                            <td style="width: 50%; height: 40px;">Do you want to save this report ? &nbsp;</td>
                                            <td>
                                                <asp:RadioButton runat="server" ID="rdQueryYes" GroupName="rdQuery" Text="Yes" onclick="SetReportNameVisibility('Y');" />&nbsp;
                                                                    <asp:RadioButton runat="server" ID="rdQueryNo" GroupName="rdQuery" Checked="true" Text="No" onclick="SetReportNameVisibility('N');" />
                                            </td>
                                        </tr>
                                        <tr id="trReportName" style="display: none;">
                                            <td style="height: 40px;">Report Name</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="txtReportName" Width="200px" MaxLength="500" CssClass="text"></asp:TextBox>
                                                <br />
                                            </td>
                                        </tr>
                                        <tr id="trRBVisibility" style="display: none;">
                                            <td style="height: 40px;">Visibility</td>
                                            <td>
                                                <asp:RadioButtonList ID="rblVisibility" runat="server" RepeatDirection="Horizontal">

                                                    <asp:ListItem Value="PU" Text="Public" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="RO" Text="Role Based"></asp:ListItem>
                                                    <asp:ListItem Value="PR" Text="Private"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr id="trblank" style="display: block;">
                                            <td colspan="2">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td align="center" colspan="2">
                                                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="button" Style="cursor: pointer;" OnClientClick="return validateReportType();" OnClick="btnSubmitReport_Click" />
                                                &nbsp;<input type="button" value="Close" class="button" style="cursor: pointer;" onclick="CloseQueryPopup()" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>--%>
                </table>
                <asp:UpdatePanel ID="UpTitlePopup" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class='popup' id="TitlePopup" style="display: none;">
                            <div class='content'>
                                <img src="../Images/fancy_close.png" alt='quit' class='X' id='Img1' onclick="ClosePopup()" />
                                <%--<div class="popupHeading" style="float: left;">
                                        <asp:Label runat="server" ID="lblHeadingPopUp" Text="Search Titles"></asp:Label>
                                    </div>--%>
                                <div>
                                    <asp:TextBox ID="txtSearch" runat="server" AutoComplete="off" Width="340px" MaxLength="100" placeholder="Search by Title,Talent,Star Cast,Genre,Director"></asp:TextBox>
                                    <asp:Button ID="btnSearch_tit" runat="server" CssClass="button" Text="Search" OnClientClick="return ValidateMandatoryField();" OnClick="btnSearch_tit_Click" />
                                    <%--<asp:Button ID="btnShowAll_tit" runat="server" CssClass="button" Text="Show All" OnClick="btnShowAll_tit_Click" />--%>
                                </div>
                                <%-- <div class="paging_ErrorPopup">
                                    <div id="divTotalRecord_ErrorPopup">--%>
                                <div class="paging_area clearfix">
                                    <div class="divBlock">
                                        <table style="width: 100%">
                                            <tr>
                                                <td style="text-align: left">
                                                    <span class="pull-left">Total record(s) found :
                                        <asp:Label ID="lblTotal_ErrorPopup" runat="server"></asp:Label></span>
                                                </td>
                                                <td style="text-align: right; width: auto">
                                                    <%-- <div id="divPaging_ErrorPopup">--%>
                                                    <%--<div>--%>
                                                    <asp:DataList ID="dtLst_ErrorPopup" runat="server" RepeatDirection="Horizontal"
                                                        OnItemCommand="dtLst_ErrorPopup_ItemCommand" OnItemDataBound="dtLst_ErrorPopup_ItemDataBound">
                                                        <ItemTemplate>
                                                            <asp:Button ID="btnPager" CssClass="pagingbtn" runat="server"
                                                                Text='<%# ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Attrib %>'
                                                                CommandArgument='<%#  ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Val %>' />
                                                        </ItemTemplate>
                                                    </asp:DataList>
                                                    <%--</div>--%>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <div id="divTitle">
                                    <asp:GridView ID='gvTitle' runat='server' CssClass='main' AllowSorting='True' HeaderStyle-CssClass='tableHd'
                                        CellPadding="3" Width='100%' AutoGenerateColumns='False'
                                        DataKeyNames="IntCode" OnRowDataBound="gvTitle_RowDataBound">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Select">
                                                <HeaderTemplate>
                                                    <asp:CheckBox runat="server" ID="chkSelectAll" onclick="SelectAllTitles()" />
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:CheckBox runat="server" ID="chkSelect" onclick="SelectTitles()" />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Title Name" ItemStyle-VerticalAlign="Middle">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblIntCode" Text='<%#Eval("IntCode") %>' runat="server" Style="display: none"></asp:Label>
                                                    <asp:Label ID="lblTitle_Name" Text='<%#Eval("TitleName") %>' runat="server"></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle Width="30%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Year of Release">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblRelease" Text='<%#Eval("yearOfProduction") %>' runat="server"></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle Width="10%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Genres">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblGenere" runat="server" Text='<%# (Convert.ToString(Eval("Genere")).Length >=22 ? ((Convert.ToString(Eval("Genere"))).Substring(0,22)+ " ...") : Eval("Genere"))%>'
                                                        CssClass='<%#(Convert.ToString(Eval("Genere")).Length >=22 ? "checkbox":"")%>'
                                                        ToolTip='<%# (Convert.ToString(Eval("Genere")).Length >=22 ? Eval("Genere"): "") %>'></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle Width="25%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Talent">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblKeyStar" runat="server" Text='<%# (Convert.ToString(Eval("keyStarCast")).Length >=25 ? ((Convert.ToString(Eval("keyStarCast"))).Substring(0,25)+ " ...") : Eval("keyStarCast"))%>'
                                                        CssClass='<%#(Convert.ToString(Eval("keyStarCast")).Length >=25 ? "checkbox":"")%>'
                                                        ToolTip='<%# (Convert.ToString(Eval("keyStarCast")).Length >=25 ? Eval("keyStarCast"): "") %>'></asp:Label>
                                                    <asp:Label ID="lblKeyStar1" runat="server" Text='<%#Convert.ToString(Eval("keyStarCast"))%>'
                                                        Visible="false"></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle Width="30%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                                <div id="divButtonPanel">
                                    <asp:Button ID="btnSaveTitle" runat="server" Text="Select Titles" CssClass="button"
                                        Style="cursor: pointer;" OnClick="btnSaveTitle_Click" />
                                    <input type="button" value="Close" class="button" style="cursor: pointer;" onclick="ClosePopup()" />
                                </div>
                            </div>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="lbSelectTitles" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnSearch_tit" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="rblPeriodType" EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
                <asp:Panel ID="Panel1" runat="server" Width="150px" Style="max-height: 300px; display: none;" ScrollBars="Vertical"
                    BackColor="White" BorderColor="Black" BorderWidth="1px" BorderStyle="Solid">
                    <div id="divNames" style="margin-top: 15px;">
                    </div>
                    <asp:HiddenField ID="hdnNames" runat="server" />
                </asp:Panel>
                <AjaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" PopupControlID="Panel1"
                    Position="Right" TargetControlID="divCountries">
                </AjaxToolkit:PopupControlExtender>


            </td>
        </tr>
    </table>

    <link rel="stylesheet" href="../CSS/jquery-ui.css" />
    <link rel="stylesheet" href="../CSS/chosen.min.css" />
    <link rel="stylesheet" href="../CSS/common.css" />
    <link rel="stylesheet" href="../CSS/Master_ASPX.css" />

    <script type="text/javascript" src="../Master/JS/master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/common.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/common.concat.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/jquery.expander.js"></script>
    <script type="text/javascript" src="../JS_Core/autoNumeric-1.8.1.js"></script>
    <script type="text/javascript" src="../JS_Core/chosen.jquery.min.js"></script>

     <style type="text/css">
        /*Datepick css start*/
        select, textarea {
            font-family: Arial,Helvetica,Sans-serif;
            font-size: 100%;
            text-align: left;
        }

        #CphdBody_dtLst_ErrorPopup {
            width: auto !Important;
            float: right !Important;
        }

        .demo .ui-datepicker-row-break {
            font-size: 100%;
        }

        .ui-datepicker td {
            padding: 0px;
            vertical-align: inherit;
        }

        .ui-datepicker-header.ui-widget-header.ui-helper-clearfix.ui-corner-all {
            width: 180px;
        }

        table.ui-datepicker-calendar {
            width: 181px;
        }
        /*Datepick css end*/

        input[type=image] {
            float: left;
            border: none;
            border-radius: 0;
            padding: 0;
            margin: 0;
        }

        a#lbSelectTitles img {
            height: 22px;
            position: relative;
            top: 5px;
            background-color: #fff;
            left: 11px;
        }

        .overlay_common {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: #000;
            filter: alpha(opacity=70);
            -moz-opacity: 0.7;
            -khtml-opacity: 0.7;
            opacity: 0.7;
            display: none;
        }

        #overlay {
            z-index: 8000;
        }

        .popup {
            width: 85%;
            margin: auto;
            top: 10%;
            display: none;
            position: absolute;
        }

        #TitlePopup {
            z-index: 8001;
        }

        #divNamesPopup {
            z-index: 8001;
        }

        .content {
            width: 750px;
            height: 505px;
            margin: auto;
            background: #f3f3f3;
            position: relative;
            z-index: 103;
            padding: 10px;
            padding-left: 40px;
            border-radius: 5px;
            box-shadow: 5px 5px 5px #888888;
        }

            .content .X {
                float: right;
                height: 35px;
                left: 22px;
                position: relative;
                top: -25px;
                width: 34px;
            }

                .content .X:hover {
                    cursor: pointer;
                }

        .popupHeading {
            width: 30%;
            min-width: 31%;
            height: 3%;
            color: #686868;
            font-size: 20px;
            font-family: sans-serif;
            text-shadow: 1px 1px 1px #E0E0E0;
        }

        #divTitle {
            width: 100%;
            height: 385px;
            float: left;
            overflow: auto;
            font-weight: normal;
            padding: 3px;
        }

        #divButtonPanel {
            width: 95%;
            float: left;
            padding-top: 10px;
        }

        .chosen-container .chosen-results li.active-result {
            color: black;
            text-align: left;
        }

        .chosen-container .chosen-results li.no-results {
            color: black;
        }

        .chosen-container .chosen-results li.group-result {
            color: black;
            background-color: gainsboro;
        }

        .chosen-container-multi .chosen-choices li.search-field {
            height: 27px !Important;
        }

        /*#ReportViewer1 > iframe {
            height: 91% !important;
        }

        @media screen and (-webkit-min-device-pixel-ratio:0) {
            iframe#ReportFrameReportViewer1 {
                height: 78% !important;
            }
        }*/

        div#oReportDiv {
            overflow: initial !Important;
        }

        #tblMin {
            margin-left: 12%;
        }

        .pagingborder {
            font-family: Corbel;
            font-size: 14px;
            border: 0 !important;
        }

        table.mainReports {
            background-color: #ffffff;
            height: 140px;
            /* padding: 0; */
            /* margin:0; */
            width: 94%;
        }

        /*#ReportViewer1 > iframe {
            height: 91% !important;
        }

        iframe#ReportFrameReportViewer1 {
            height: 78% !important;
        }*/

        div#oReportDiv {
            overflow: initial !Important;
        }

        input#CphdBody_btnSearch {
            height: 30px;
            width: 110px;
        }

        h3.accordion-header.ui-accordion-header {
            background-color: #DEDEDE;
            color: #333;
        }

        .ui-accordion-content > table {
            width: 100%;
            border-spacing: 1px;
            border: 0;
            background-color: #fff;
            color: #555;
        }

            .ui-accordion-content > table > tbody > tr > td {
                border: 1px solid #aaa;
            }

        .ui-accordion .ui-accordion-content {
            padding: 0;
            overflow: visible;
        }

        .ui-tooltip {
            position: absolute;
            top: 50px !important;
            left: 500px !important;
            font-size: 12px;
            max-height: 650px;
            overflow-y: auto;
        }

        .tabCountry, .tabTerritory {
            display: inline-block;
            width: 48%;
            height: 25px;
            float: left;
            font-family: inherit;
            font-weight: normal;
            padding: 5px 3px 0 3px;
            margin: 0;
            border: 0;
            font-size: 15px !important;
            box-shadow: none;
            /*background-color: #ccc !important;*/
        }

        .tabCountry {
            color: #333;
            font-weight: 600;
            text-decoration: underline;
            background-color: #bbb !important;
        }

        .tabTerritory {
            cursor: pointer;
            color: #333;
            background-color: #ccc !important;
        }



        .platformTree table {
            width: initial;
        }

        #lstRegion_chosen > ul, #lstWithoutExcludedRegion_chosen > ul, #lbSubtitling_chosen > ul,
        #lbLanguage_chosen > ul, #lstLTerritory_chosen > ul {
            min-height: 83px;
        }

        /*.reportViewer > iframe {
            height: 91% !important;
        }

        iframe#ReportFrameReportViewer1 {
            height: 78% !important;
        }*/

        div#oReportDiv {
            overflow: initial !Important;
        }

        /*.reportViewer {
            display: inline-block;
            border-style: Solid;
            border-color: #eee;
            border-width: 10px;
            height: 600px !Important;
            width: 100%;
        }

            .reportViewer table {
                width: initial;
            }*/

        #divConfirmReport {
            z-index: 8001;
        }

        #divConfirmReport {
            margin-top: 25px;
            width: 88%;
            height: 150px;
            float: left;
            height: 200px;
        }

        .content2 {
            width: 500px;
            max-height: 300px;
            /*height: 190px;*/
            margin: auto;
            background: #f3f3f3;
            position: relative;
            z-index: 103;
            padding: 10px;
            padding-left: 40px;
            border-radius: 5px; /*box-shadow: 0 2px 5px #000;*/
            box-shadow: 5px 5px 5px #888888;
            font-family: Arial,Helvetica,sans-serif;
            font-size: 12px;
        }

            .content2 .X {
                float: right;
                height: 35px;
                left: 22px;
                position: relative;
                top: -25px;
                width: 34px;
            }

                .content2 .X:hover {
                    cursor: pointer;
                }

        .tbleRadio {
            width: 55%;
            padding: 5px 3px;
            margin-top: 8px;
            margin-left: 5px;
        }

        #CphdBody_divPlatformFilter {
            margin-top: 10px !Important;
        }

        #CphdBody_divPlatformGroup {
            margin-top: 10px !Important;
        }

        .ui-helper-reset {
            font-size: 13px !important;
        }

        #divTotalRecord_ErrorPopup {
            width: 30%;
            float: left;
        }

        #divPaging_ErrorPopup {
            width: 5%;
            padding-right: 16%;
            float: right;
        }

        td span {
            padding: 4px;
        }

        #CphdBody_rblVisibility {
            width: 90% !important;
        }

        #CphdBody_spPlatform {
            border-radius: 0px !important;
            font-size: 12px !important;
        }

        #CphdBody_spPlatformGroup {
            border-radius: 0px !important;
            font-size: 12px !important;
        }

        .nav-tab {
            border-bottom: 0 none;
            height: 25px !important;
        }
        .ui-icon {
            display: inline-block!important;
            vertical-align: middle!important;
            margin-top: -.25em!important;
            position: relative!important;
            text-indent: -99999px!important;
            overflow: hidden!important;
            background-repeat: no-repeat!important;
            left:0em!important;
        }
    </style>

    

    <link rel="stylesheet" href="../CSS/jquery.datepick.css" />
    <link rel="stylesheet" href="../CSS/ui-start.datepick.css" />
    <script type="text/javascript" src="../JS_Core/jquery.plugin.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.watermarkinput.js"></script>
    <script type="text/javascript" src="../JS_Core/watermark.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.datepick.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.datepick.ext.js"></script>

    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);
        function endRequest(sender, args) {
            initlyExpander();
            CallOnLoad();
        }
    </script>
</asp:Content>
