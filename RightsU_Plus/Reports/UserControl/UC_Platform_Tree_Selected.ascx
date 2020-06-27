<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UC_Platform_Tree_Selected.ascx.cs" Inherits="RightsU_WebApp.UserControl.UC_Platform_Tree_Selected" %>

<script type="text/javascript">
    //this function is executed whenever user clicks on the node text
    function ToggleCheckBox1(senderId) {
        //debugger
        var nodeIndex = GetNodeIndex1(senderId, LINK);
        var checkBoxId = TREEVIEW_ID_New + "n" + nodeIndex + "CheckBox";
        var checkBox = document.getElementById(checkBoxId);
        checkBox.checked = !checkBox.checked;

        ToggleChildCheckBoxes1(checkBox);
        ToggleParentCheckBox1(checkBox);
    }

    //checkbox click event handler
    function checkBox_Click1(eventElement) {
        //debugger
        ToggleChildCheckBoxes1(eventElement.target);
        ToggleParentCheckBox1(eventElement.target);
    }

    //returns the index of the clicked link or the checkbox
    function GetNodeIndex1(elementId, elementType) {
        //debugger
        var nodeIndex;
        if (elementType == LINK) {
            nodeIndex = elementId.substring((TREEVIEW_ID_New + "t").length);
        }
        else if (elementType == CHECKBOX) {
            nodeIndex = elementId.substring((TREEVIEW_ID_New + "n").length, elementId.indexOf("CheckBox"));
        }
        return nodeIndex;
    }

    //checks or unchecks the nested checkboxes
    function ToggleChildCheckBoxes1(checkBox) {
        //debugger
        checkBox.style.backgroundColor = "";
        var postfix = "n";
        var childContainerId = TREEVIEW_ID_New + postfix + GetNodeIndex1(checkBox.id, CHECKBOX) + "Nodes";
        var childContainer = document.getElementById(childContainerId);
        if (childContainer) {
            var childCheckBoxes = childContainer.getElementsByTagName("input");
            for (var i = 0; i < childCheckBoxes.length; i++) {
                
                if (!childCheckBoxes[i].disabled) {
                    childCheckBoxes[i].checked = checkBox.checked;
                    var innerChildContainerId = TREEVIEW_ID_New + postfix + GetNodeIndex1(childCheckBoxes[i].id, CHECKBOX) + "Nodes";
                    var innerChildContainer = document.getElementById(innerChildContainerId);
                    if (innerChildContainer) {
                        var innerChildCheckBoxes = innerChildContainer.getElementsByTagName("input");
                        if (innerChildCheckBoxes.length > 0) {
                            if (checkBox.checked) {
                                childCheckBoxes[i].indeterminate = false;
                                childCheckBoxes[i].checked = checkBox.checked
                            }
                            else
                                childCheckBoxes[i].indeterminate = checkBox.checked;
                        }
                    }
                }
                if (!checkBox.checked) childCheckBoxes[i].style.backgroundColor = "";
            }
        }
    }

    //unchecks the parent checkboxes if the current one is unchecked
    function ToggleParentCheckBox1(checkBox) {
        //debugger
        if (checkBox.checked == false) {
            var parentContainer = GetParentNodeById1(checkBox, TREEVIEW_ID_New);
            if (parentContainer) {
                var parentCheckBoxId = parentContainer.id.substring(0, parentContainer.id.search("Nodes")) + "CheckBox";
                if ($get(parentCheckBoxId) && $get(parentCheckBoxId).type == "checkbox") {
                    $get(parentCheckBoxId).checked = false;
                    ToggleParentCheckBox1($get(parentCheckBoxId));
                }
            }
        }
        //            else {
        CheckParentCheckBoxes1(checkBox)
        //            }
    }

    function ChangeColorForPartiallyselected1(checkBox) {
        //debugger
        var parentContainer = GetParentNodeById1(checkBox, TREEVIEW_ID_New);
        if (parentContainer) {
            var parentCheckBoxId = parentContainer.id.substring(0, parentContainer.id.search("Nodes")) + "CheckBox";
            var parentCheckBox = $get(parentCheckBoxId);
            if (parentCheckBox && parentCheckBox.type == "checkbox") {

                var postfix = "n";
                var childContainerId = TREEVIEW_ID_New + postfix + GetNodeIndex1(parentCheckBoxId, CHECKBOX) + "Nodes";
                var childContainer = document.getElementById(childContainerId);

                if (childContainer) {
                    var count = 0;
                    var childCheckBoxes = childContainer.getElementsByTagName("input");
                    for (var i = 0; i < childCheckBoxes.length; i++) {
                        if (!childCheckBoxes[i].checked)
                            count++;
                    }
                }
                if (count >= 1 && count != childCheckBoxes.length) parentCheckBox.indeterminate = true;
                else parentCheckBox.indeterminate = false;

                ChangeColorForPartiallyselected1(parentCheckBox);
            }
        }
    }


    function CheckParentCheckBoxes1(checkBox) {
        //debugger
        var parentContainer = GetParentNodeById1(checkBox, TREEVIEW_ID_New);
        if (parentContainer) {

            var parentCheckBoxId = parentContainer.id.substring(0, parentContainer.id.search("Nodes")) + "CheckBox";
            var parentCheckBox = $get(parentCheckBoxId);
            if (parentCheckBox && parentCheckBox.type == "checkbox") {

                var postfix = "n";
                var childContainerId = TREEVIEW_ID_New + postfix + GetNodeIndex1(parentCheckBoxId, CHECKBOX) + "Nodes";
                var childContainer = document.getElementById(childContainerId);

                if (childContainer) {
                    var count = 0;
                    var childCheckBoxes = childContainer.getElementsByTagName("input");
                    for (var i = 0; i < childCheckBoxes.length; i++) {
                        if (!childCheckBoxes[i].checked)
                            count++;
                    }
                }

                //if (count >= 1 && count != childCheckBoxes.length) {
                //    parentCheckBox.style.backgroundColor = "#7CC4D0";
                //    var styleString = "background-color:#7CC4D0;font-weight:bold;font-style:italic";
                //    parentCheckBox.setAttribute('style', styleString);
                //} else parentCheckBox.style.backgroundColor = "";

                if (count >= 1 && count != childCheckBoxes.length) parentCheckBox.indeterminate = true;
                else parentCheckBox.indeterminate = false;

                if (!parentCheckBox.disabled) {
                    if (count == childCheckBoxes.length)
                        parentCheckBox.checked = false;
                    else
                        parentCheckBox.checked = true;
                }

                CheckParentCheckBoxes1(parentCheckBox);
            }
        }
    }

    //returns the ID of the parent container if the current checkbox is unchecked
    function GetParentNodeById1(element, id) {
        //debugger
        var parent = element.parentNode;
        if (parent == null || parent.id == null) {
            return false;
        }
        if (parent.id.search(id) == -1) {
            return GetParentNodeById1(parent, id);
        }
        else {
            return parent;
        }
    }
</script>

<script type="text/javascript">

    //var TREEVIEW_ID_New = ""; 
    //the constants used by GetNodeIndex()
    var LINK = 0;
    var CHECKBOX = 1;
    function SetHiddenField1(TREEVIEWID) {
        //debugger
        var hdnClientid = '<%= hdnTRId.ClientID %>';
        document.getElementById(hdnClientid).value = TREEVIEWID;
    }

    function callOnPageLoad1() {
        //debugger
        TREEVIEW_ID_New = "CphdBody_uctabSelectedplt_trView"; //the ID of the TreeView control
        var hdnClientid = '<%= hdnTRId.ClientID %>';
        var trId = document.getElementById(hdnClientid).value;

        if (trId) {
            var count = trId.match(new RegExp("_", "g")).length;

            if (count > 1)
                TREEVIEW_ID_New = trId;
        }

        var links = document.getElementsByTagName("a");
        //alert(links.length);

        for (var i = 0; i < links.length; i++) {
            // if (!links[i].className.trim()) alert(links[i].className);

            if (links[i].className == TREEVIEW_ID_New + "_0") {
                //alert(links.length);
                links[i].href = "javascript:ToggleCheckBox1(\"" + links[i].id + "\");";
            }
        }

        var checkBoxes = document.getElementsByTagName("input");

        if (checkBoxes != null) {
            //alert(checkBoxes);
            for (var i = 0; i < checkBoxes.length; i++) {
                if (checkBoxes[i].type == "checkbox") {
                    //alert(checkBoxes[i].id);                        
                    var chkID = checkBoxes[i].id;
                    //var IdCompare = chkID.substring(0, TREEVIEW_ID_New.length);
                    if (chkID.indexOf(TREEVIEW_ID_New) > -1) {
                        $addHandler(checkBoxes[i], "click", checkBox_Click1);
                    }
                    ChangeColorForPartiallyselected1(checkBoxes[i]);
                }
            }
        }

    }

</script>

<asp:TreeView ID="trView" runat="server" CssClass="main" ImageSet="XPFileExplorer"
    NodeIndent="15" ShowCheckBoxes="All">
    <ParentNodeStyle Font-Bold="False" />
    <HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
    <SelectedNodeStyle BackColor="#B5B5B5" Font-Underline="False" HorizontalPadding="0px"
        VerticalPadding="0px" />
    <NodeStyle Font-Names="Tahoma" Font-Size="8pt" ForeColor="Black" HorizontalPadding="2px"
        NodeSpacing="0px" VerticalPadding="2px" />
</asp:TreeView>
<asp:HiddenField ID="hdnTRId" runat="server" />