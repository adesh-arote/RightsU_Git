using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

public partial class SAP_Export_File_Upload : ParentPage
{
    public int PageNo
    {
        get
        {
            if (ViewState["PageNo"] == null)
                ViewState["PageNo"] = 1;
            return (int)ViewState["PageNo"];
        }
        set { ViewState["PageNo"] = value; }
    }
    public int moduleCode
    {
        get
        {
            if (ViewState["moduleCode"] == null)
                ViewState["moduleCode"] = 0;
            return (int)ViewState["moduleCode"];
        }
        set { ViewState["moduleCode"] = value; }
    }

    private List<USP_Uploaded_File_List_Result> lstUploaded_Files
    {
        get
        {
            if (Session["lstUploaded_Files"] == null)
                Session["lstUploaded_Files"] = new List<USP_Uploaded_File_List_Result>();
            return (List<USP_Uploaded_File_List_Result>)Session["lstUploaded_Files"];
        }
        set
        {
            Session["lstUploaded_Files"] = value;
        }

    }
   

    protected void Page_Load(object sender, EventArgs e)
    {
        hdnDateWatermarkFormat.Value = "DD/MM/YYYY";
        if (!IsPostBack)
        {
            Session["lstUploaded_Files_Details"] = null;
            Session["lst_BV_WBS"] = null;
            lblHeader.Text = "SAP WBS Export";
            if (Request.QueryString["Page_No"] != null)
                PageNo = Convert.ToInt32(Request.QueryString["Page_No"]);
            if (Request.QueryString["moduleCode"] != null && Convert.ToInt32(Request.QueryString["moduleCode"]) == GlobalParams.ModuleCodeFor_BV_WBS_Export)
            {
                moduleCode = Convert.ToInt32(Request.QueryString["moduleCode"]);
                lblHeader.Text = "BV WBS Export";
            }
            string pageSize = "10";
            if (Request.QueryString["Page_Size"] != null)
                pageSize = Convert.ToString(Request.QueryString["Page_Size"]);
            txtPageSize.Text = pageSize;
            BindGridView(true);
        }

        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "assignDate", "AssignDateJQuery();", true);
    }

    private void BindGridView(bool isFirstTime = false)
    {
        if (isFirstTime)
        {
            string type = "SAP_EXP";
            if (moduleCode == GlobalParams.ModuleCodeFor_BV_WBS_Export)
                type = "BV_WBS_EXP";
           // lstUploaded_Files = new USP_Service().USP_Uploaded_File_List().Where(x => x.Upload_Type.Trim().ToUpper() == type).ToList();
        }
        if (txtPageSize.Text == "" || txtPageSize.Text == "0" || txtPageSize.Text == "00")
            txtPageSize.Text = "10";
        int RecordCount = lstUploaded_Files.Count;
        int RecordPerPage = Convert.ToInt32(txtPageSize.Text);

        GlobalUtil.ShowBatchWisePaging("", RecordPerPage, 5, lblTotal, PageNo, dtLst, RecordCount);
        int noOfRecordSkip = RecordPerPage * (PageNo - 1);
        int noOfRecordTake = 0;
        if (RecordCount < (noOfRecordSkip + RecordPerPage))
            noOfRecordTake = RecordCount - noOfRecordSkip;
        else
            noOfRecordTake = RecordPerPage;
        gvSAP_WBS_List.DataSource = lstUploaded_Files.Skip(noOfRecordSkip).Take(noOfRecordTake);
        gvSAP_WBS_List.DataBind();

        DBUtil.AddDummyRowIfDataSourceEmpty(gvSAP_WBS_List, new USP_Uploaded_File_List_Result());
    }

    #region --- gvSAP_Receipt_List Gridview ---
    protected void gvSAP_WBS_List_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.Equals("VIEW_DETAILS"))
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int File_Code = 0;
            File_Code = Convert.ToInt32(gvSAP_WBS_List.DataKeys[rowIndex].Values["File_Code"]);
            Response.Redirect("SAP_Export_File_Upload_Details.aspx?File_Code=" + File_Code + "&moduleCode=" + moduleCode + "&Page_No=" + PageNo + "&Page_Size=" + txtPageSize.Text.Trim());
        }
    }
    #endregion

    #region --- Paging ---
    protected void btnApply_Click(object sender, EventArgs e)
    {
        PageNo = 1;
        BindGridView();
    }

    protected void dtLst_ItemCommand(object source, DataListCommandEventArgs e)
    {
        PageNo = Convert.ToInt32(e.CommandArgument);
        gvSAP_WBS_List.EditIndex = -1;
        BindGridView();
    }

    protected void dtLst_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
        {
            Button btnPage = (Button)e.Item.FindControl("btnPager");

            if (PageNo == Convert.ToInt32(btnPage.CommandArgument))
            {
                btnPage.Enabled = false;
                btnPage.CssClass = "pagingbtn";
            }
        }
    }
    #endregion

    #region --- Button Events ---
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DateTime dtFrom = DateTime.MinValue;
        DateTime dtTo = DateTime.MaxValue;
        string strFileName = txtFile_Name.Text.Trim().ToUpper();

        if (!txtfrom.Text.Trim().Equals("") && !txtfrom.Text.Trim().Equals(hdnDateWatermarkFormat.Value))
            dtFrom = Convert.ToDateTime(GlobalUtil.MakedateFormat(txtfrom.Text.Trim()));

        if (!txtto.Text.Trim().Equals("") && !txtto.Text.Trim().Equals(hdnDateWatermarkFormat.Value))
            dtTo = Convert.ToDateTime(GlobalUtil.MakedateFormat(txtto.Text.Trim())).AddDays(1);

        //lstUploaded_Files = new USP_Service().USP_Uploaded_File_List().Where(w => w.Upload_Type.Trim().ToUpper() == "SAP_EXP" &&
           // w.File_Name.ToUpper().Contains(strFileName) && w.Upload_Date >= dtFrom && w.Upload_Date <= dtTo).ToList();

        BindGridView();
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        txtto.Text = "";
        txtfrom.Text = "";
        txtFile_Name.Text = "";
        BindGridView(true);
    }
    #endregion

    protected void txtPageSize_TextChanged(object sender, EventArgs e)
    {
        PageNo = 1;
        BindGridView();
    }
}
