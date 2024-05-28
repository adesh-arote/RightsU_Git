using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

public partial class SAP_File_Upload_Details : ParentPage
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

    public int File_Code
    {
        get
        {
            if (ViewState["File_Code"] == null)
                ViewState["File_Code"] = 0;
            return (int)ViewState["File_Code"];
        }
        set { ViewState["File_Code"] = value; }
    }

    private List<USP_Uploaded_File_Detail_Result> lstUploaded_Files_Details
    {
        get
        {
            if (Session["lstUploaded_Files_Details"] == null)
                Session["lstUploaded_Files_Details"] = new List<USP_Uploaded_File_Detail_Result>();
            return (List<USP_Uploaded_File_Detail_Result>)Session["lstUploaded_Files_Details"];
        }
        set
        {
            Session["lstUploaded_Files_Details"] = value;
        }

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblHeader.Text = "SAP WBS Import Details";

            if (Request.QueryString["File_Code"] != null)
                File_Code = Convert.ToInt32(Request.QueryString["File_Code"]);

            txtPageSize.Text = "10";
            BindGridView(true);
        }
    }

    private void BindGridView(bool isFirstTime = false)
   {
        if (isFirstTime)
        {
            lstUploaded_Files_Details = new USP_Service(ObjLoginEntity.ConnectionStringName).USP_Uploaded_File_Detail(File_Code).ToList();
        }
        if (txtPageSize.Text == "" || txtPageSize.Text == "0" || txtPageSize.Text == "00")
            txtPageSize.Text = "10";
        int RecordCount = lstUploaded_Files_Details.Count;
        int RecordPerPage = Convert.ToInt32(txtPageSize.Text);

        GlobalUtil.ShowBatchWisePaging("", RecordPerPage, 5, lblTotal, PageNo, dtLst, RecordCount);


        int noOfRecordSkip = RecordPerPage * (PageNo - 1);
        int noOfRecordTake = 0;
        if (RecordCount < (noOfRecordSkip + RecordPerPage))
            noOfRecordTake = RecordCount - noOfRecordSkip;
        else
            noOfRecordTake = RecordPerPage;

        gvSAP_WBS_Details_List.DataSource = lstUploaded_Files_Details.Skip(noOfRecordSkip).Take(noOfRecordTake);
        gvSAP_WBS_Details_List.DataBind();
        DBUtil.AddDummyRowIfDataSourceEmpty(gvSAP_WBS_Details_List, new USP_Uploaded_File_Detail_Result());
    }

    #region --- gvSAP_WBS_Details_List_RowCommand Gridview ---
    protected void gvSAP_WBS_Details_List_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.Equals("VIEW_ERROR"))
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int Upload_Detail_Code = 0;
            Upload_Detail_Code = Convert.ToInt32(gvSAP_WBS_Details_List.DataKeys[rowIndex].Values["Upload_Detail_Code"]);
            gvErrorPopup.DataSource = new USP_Service(ObjLoginEntity.ConnectionStringName).USP_Uploaded_File_Error_List(Upload_Detail_Code).ToList();
            gvErrorPopup.DataBind();
            DBUtil.AddDummyRowIfDataSourceEmpty(gvErrorPopup, new USP_Uploaded_File_Error_List_Result());
            upErrorPopup.Update();
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "popup", "OpenPopup('ErrorPopup');", true);
        }
    }
    #endregion

    #region --- Paging ---
    //protected void btnApply_Click(object sender, EventArgs e)
    //{
    //    PageNo = 1;
    //    BindGridView();
    //}

    protected void dtLst_ItemCommand(object source, DataListCommandEventArgs e)
    {
        PageNo = Convert.ToInt32(e.CommandArgument);
        gvSAP_WBS_Details_List.EditIndex = -1;
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
        string strSearchText = txtSearch.Text.Trim().ToUpper();

        lstUploaded_Files_Details = new USP_Service(ObjLoginEntity.ConnectionStringName).USP_Uploaded_File_Detail(File_Code).Where(w => w.WBS_Code.ToUpper().Contains(strSearchText)
             || w.WBS_Description.ToUpper().Contains(strSearchText) || w.Short_ID.ToUpper().Contains(strSearchText)
             || w.Status.ToUpper().Contains(strSearchText) || w.Sport_Type.ToUpper().Contains(strSearchText)).ToList();

        BindGridView();
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        lstUploaded_Files_Details = new USP_Service(ObjLoginEntity.ConnectionStringName).USP_Uploaded_File_Detail(File_Code).ToList();
        txtSearch.Text = "";
        BindGridView();
    }

    protected void btnBackToList_Click(object sender, EventArgs e)
    {
        int page_no = 1;
        string pageSize = "10";

        if (Request.QueryString["Page_No"] != null)
            page_no = Convert.ToInt32(Request.QueryString["Page_No"]);

        if (Request.QueryString["Page_Size"] != null)
            pageSize = Convert.ToString(Request.QueryString["Page_Size"]);

        Response.Redirect("SAP_File_Upload.aspx?Page_No=" + page_no + "&Page_Size=" + pageSize);
    }
    #endregion

    protected void txtPageSize_TextChanged(object sender, EventArgs e)
    {
        PageNo = 1;
        BindGridView();
    }

}
