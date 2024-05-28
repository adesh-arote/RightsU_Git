using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

public partial class SAP_Export_File_Upload_Details : ParentPage
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

    private List<USP_SAP_Export_Detail_Result> lstUploaded_Files_Details
    {
        get
        {
            if (Session["lstUploaded_Files_Details"] == null)
                Session["lstUploaded_Files_Details"] = new List<USP_Uploaded_File_Detail_Result>();
            return (List<USP_SAP_Export_Detail_Result>)Session["lstUploaded_Files_Details"];
        }
        set
        {
            Session["lstUploaded_Files_Details"] = value;
        }
    }
    private List<USP_List_BV_WBS_Result> lst_BV_WBS
    {
        get
        {
            if (Session["lst_BV_WBS"] == null)
                Session["lst_BV_WBS"] = new List<USP_List_BV_WBS_Result>();
            return (List<USP_List_BV_WBS_Result>)Session["lst_BV_WBS"];
        }
        set
        {
            Session["lst_BV_WBS"] = value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPageSize.Text = "10";
            if (Request.QueryString["File_Code"] != null)
                File_Code = Convert.ToInt32(Request.QueryString["File_Code"]);
            if (Request.QueryString["moduleCode"] != null && Convert.ToInt32(Request.QueryString["moduleCode"]) == GlobalParams.ModuleCodeFor_BV_WBS_Export)
            {
                moduleCode = Convert.ToInt32(Request.QueryString["moduleCode"]);
                lblHeader.Text = "BV WBS Export Details";
                BindGridView_BV("F");
            }
            else
            {
                lblHeader.Text = "SAP WBS Export Details";
                BindGridView(true);
            }
        }
    }
    private void BindGridView_BV(string CallFrom = "")
    {
        td_gv_Sap.Visible = false;
        td_gv_BV.Visible = true;
        if (CallFrom == "F")
            lst_BV_WBS = new USP_Service(ObjLoginEntity.ConnectionStringName).USP_List_BV_WBS("D", "", File_Code).ToList();
        if (txtPageSize.Text == "" || txtPageSize.Text == "0" || txtPageSize.Text == "00")
            txtPageSize.Text = "10";
        int RecordCount = lst_BV_WBS.Count;
        int RecordPerPage = Convert.ToInt32(txtPageSize.Text);
        GlobalUtil.ShowBatchWisePaging("", RecordPerPage, 5, lblTotal, PageNo, dtLst, RecordCount);
        int noOfRecordSkip = RecordPerPage * (PageNo - 1);
        int noOfRecordTake = 0;
        if (RecordCount < (noOfRecordSkip + RecordPerPage))
            noOfRecordTake = RecordCount - noOfRecordSkip;
        else
            noOfRecordTake = RecordPerPage;
        gvBV_Export_List.DataSource = lst_BV_WBS.Skip(noOfRecordSkip).Take(noOfRecordTake);
        gvBV_Export_List.DataBind();
        DBUtil.AddDummyRowIfDataSourceEmpty(gvBV_Export_List, new USP_List_BV_WBS_Result());
    }
    private void BindGridView(bool isFirstTime = false)
    {
        td_gv_Sap.Visible = true;
        td_gv_BV.Visible = false;
        if (isFirstTime)
        {
            lstUploaded_Files_Details = new USP_Service(ObjLoginEntity.ConnectionStringName).USP_SAP_Export_Detail(File_Code).ToList();
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
        gvSAP_Export_List.DataSource = lstUploaded_Files_Details.Skip(noOfRecordSkip).Take(noOfRecordTake);
        gvSAP_Export_List.DataBind();

        DBUtil.AddDummyRowIfDataSourceEmpty(gvSAP_Export_List, new USP_SAP_Export_Detail_Result());
    }

    #region --- Paging ---
    protected void btnApply_Click(object sender, EventArgs e)
    {
        PageNo = 1;
        if (moduleCode == GlobalParams.ModuleCodeFor_BV_WBS_Export)
            BindGridView_BV("P");
        else
            BindGridView();
    }

    protected void dtLst_ItemCommand(object source, DataListCommandEventArgs e)
    {
        PageNo = Convert.ToInt32(e.CommandArgument);
        if (moduleCode == GlobalParams.ModuleCodeFor_BV_WBS_Export)
        {
            gvBV_Export_List.EditIndex = -1;
            BindGridView_BV("P");
        }
        else
        {
            gvSAP_Export_List.EditIndex = -1;
            BindGridView();
        }
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
        if (moduleCode == GlobalParams.ModuleCodeFor_BV_WBS_Export)
        {
            lst_BV_WBS = new USP_Service(ObjLoginEntity.ConnectionStringName).USP_List_BV_WBS("D", "", File_Code).Where(w => w.WBS_Code.ToUpper().Contains(strSearchText)
                || (w.Error_Details).Contains(strSearchText) || (w.Response_Type).Contains(strSearchText)).ToList();
            BindGridView_BV("S");
        }
        else
        {
            lstUploaded_Files_Details = new USP_Service(ObjLoginEntity.ConnectionStringName).USP_SAP_Export_Detail(File_Code).Where(w => w.WBS_Code.ToUpper().Contains(strSearchText)
                || w.Error_Details.ToUpper().Contains(strSearchText)).ToList();

            BindGridView();
        }
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        if (moduleCode == GlobalParams.ModuleCodeFor_BV_WBS_Export)
        {
            lst_BV_WBS = new USP_Service(ObjLoginEntity.ConnectionStringName).USP_List_BV_WBS("D", "", File_Code).ToList();
            BindGridView_BV("SA");
        }
        else
        {
            lstUploaded_Files_Details = new USP_Service(ObjLoginEntity.ConnectionStringName).USP_SAP_Export_Detail(File_Code).ToList();
            BindGridView();
        }
    }

    protected void btnBackToList_Click(object sender, EventArgs e)
    {
        int page_no = 1;
        string pageSize = "10";

        if (Request.QueryString["Page_No"] != null)
            page_no = Convert.ToInt32(Request.QueryString["Page_No"]);

        if (Request.QueryString["Page_Size"] != null)
            pageSize = Convert.ToString(Request.QueryString["Page_Size"]);

        Response.Redirect("SAP_Export_File_Upload.aspx?Page_No=" + page_no + "&Page_Size=" + pageSize + "&moduleCode=" + moduleCode);
    }
    #endregion

    protected void txtPageSize_TextChanged(object sender, EventArgs e)
    {
        PageNo = 1;
        BindGridView();
    }

}
