using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using AjaxControlToolkit;
using System.Collections;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for TransactionParentPage
/// </summary>
public class TransactionParentPage : ParentPage {
    protected override void OnLoad(EventArgs e)
    {
        AddConfirmControlOnPage();
        //-----------
        base.OnLoad(e);
    }

    private void AddConfirmControlOnPage()
    {
        Panel pnlConfirm = new Panel();
        pnlConfirm.ID = "pnlConfirm";
        pnlConfirm.GroupingText = "Confirmation";
        pnlConfirm.Style.Add("display", "none");
        pnlConfirm.CssClass = "modalPopup";
        //pnlConfirm.Attributes.Add("runat", "server");
        #region Panel Content

        HtmlTable tab = new HtmlTable();
        tab.Width = "100%";
        HtmlTableCell cell1 = new HtmlTableCell();
        cell1.Align = "right";
        cell1.Width = "20%";
        HtmlImage img = new HtmlImage();
        img.Src = "~/Images/Confirm.gif";
        img.Align = "left";
        cell1.Controls.Add(img);
        HtmlTableCell cell2 = new HtmlTableCell();
        cell2.Align = "center";
        Label lblConfirmText = new Label();
        lblConfirmText.ID = "lblConfirmText";
        lblConfirmText.Style.Add("text-align", "center");
        //lblConfirmText.Attributes.Add("runat", "server");
        lblConfirmText.Text = "Are you sure you want to delete this record?";
        cell2.Controls.Add(lblConfirmText);
        HtmlTableRow row1 = new HtmlTableRow();
        row1.Align = "Center";
        row1.Cells.Add(cell1);
        row1.Cells.Add(cell2);
        tab.Rows.Add(row1);
        HtmlTableRow row2 = new HtmlTableRow();
        row2.Align = "Center";
        HtmlTableCell cell3 = new HtmlTableCell();
        cell3.Align = "center";
        cell3.ColSpan = 2;
        Button btnConfirmOK = new Button();
        btnConfirmOK.CssClass = "button";
        btnConfirmOK.ID = "btnConfirmOK";
        btnConfirmOK.Text = "  OK  ";
        //btnConfirmOK.Attributes.Add("runat", "server");
        btnConfirmOK.CausesValidation = false;
        btnConfirmOK.Attributes.Add("onblur", "if($get('pnlConfirm').style.display=='') $get('btnConfirmCancel').focus();");
        cell3.Controls.Add(btnConfirmOK);
        Literal ctlLiteral = new Literal();
        ctlLiteral.Text = "&nbsp;&nbsp;&nbsp;";
        cell3.Controls.Add(ctlLiteral);
        Button btnConfirmCancel = new Button();
        btnConfirmCancel.CssClass = "button";
        btnConfirmCancel.ID = "btnConfirmCancel";
        btnConfirmCancel.Text = "Cancel";
        btnConfirmCancel.CausesValidation = false;
        btnConfirmCancel.Attributes.Add("onblur", "if($get('pnlConfirm').style.display=='') $get('btnConfirmOK').focus();");
        //btnConfirmCancel.Attributes.Add("runat", "server");
        cell3.Controls.Add(btnConfirmCancel);
        row2.Cells.Add(cell3);
        tab.Rows.Add(row2);
        pnlConfirm.Controls.Add(tab);

        #endregion
        this.Form.Controls.Add(pnlConfirm);

        ConfirmButtonExtender CBExtDelete = new ConfirmButtonExtender();
        CBExtDelete.ID = "CBExtDelete";
        CBExtDelete.ConfirmText = "Are you sure want to delete this record?";
        CBExtDelete.TargetControlID = "btnJunk";
        CBExtDelete.DisplayModalPopupID = "MPExtConfirm";
        CBExtDelete.OnClientCancel = "HandleConfirmCancel";
        this.Form.Controls.Add(CBExtDelete);

        ModalPopupExtender MPExtConfirm = new ModalPopupExtender();
        MPExtConfirm.ID = "MPExtConfirm";
        MPExtConfirm.TargetControlID = "btnJunk";
        MPExtConfirm.PopupControlID = "pnlConfirm";
        MPExtConfirm.BackgroundCssClass = "modalBackground";
        MPExtConfirm.OkControlID = "btnConfirmOK";
        MPExtConfirm.CancelControlID = "btnConfirmCancel";
        this.Form.Controls.Add(MPExtConfirm);
    }
}
