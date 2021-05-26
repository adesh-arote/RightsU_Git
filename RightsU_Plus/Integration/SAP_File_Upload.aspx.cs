using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
//using RightsU_BLL;
//using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

public partial class SAP_File_Upload : ParentPage
{
    private readonly USP_Service objProcedureService = new USP_Service();

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
            if (Request.QueryString["Page_No"] != null)
                PageNo = Convert.ToInt32(Request.QueryString["Page_No"]);

            string pageSize = "10";
            if (Request.QueryString["Page_Size"] != null)
                pageSize = Convert.ToString(Request.QueryString["Page_Size"]);

            lblHeader.Text = "SAP WBS Import";
            txtPageSize.Text = pageSize;
            BindGridView(true);
        }

        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "assignDate", "AssignDateJQuery();", true);
    }

    private void BindGridView(bool isFirstTime = false)
    {
        if (isFirstTime)
        {
            //lstUploaded_Files = new USP_Service().USP_Uploaded_File_List().Where(x => x.Upload_Type == "SAP_IMP").ToList();
        }

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
            int File_Code = 0, Upload_Detail_Code = 0;
            string Is_Error = "";

            File_Code = Convert.ToInt32(gvSAP_WBS_List.DataKeys[rowIndex].Values["File_Code"]);
            //Upload_Detail_Code = Convert.ToInt32(gvSAP_WBS_List.DataKeys[rowIndex].Values["Upload_Detail_Code"]);
            Is_Error = Convert.ToString(gvSAP_WBS_List.DataKeys[rowIndex].Values["Is_Error"]).Trim();

            if (Upload_Detail_Code > 0 && Is_Error.Equals("Y"))
            {
                gvErrorPopup.DataSource = objProcedureService.USP_Uploaded_File_Error_List(File_Code).ToList();
                gvErrorPopup.DataBind();
                DBUtil.AddDummyRowIfDataSourceEmpty(gvErrorPopup, new USP_Uploaded_File_Error_List_Result());
                upErrorPopup.Update();
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "popup", "OpenPopup('ErrorPopup');", true);
            }
            else
                Response.Redirect("SAP_File_Upload_Details.aspx?File_Code=" + File_Code + "&Page_No=" + PageNo + "&Page_Size=" + txtPageSize.Text.Trim());
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

       // lstUploaded_Files = new USP_Service().USP_Uploaded_File_List().Where(w => w.File_Name.ToUpper().Contains(strFileName) && w.Upload_Date >= dtFrom && w.Upload_Date <= dtTo).ToList();
        BindGridView();
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        //lstUploaded_Files = new USP_Service().USP_Uploaded_File_List().ToList();
        txtto.Text = "";
        txtfrom.Text = "";
        txtFile_Name.Text = "";
        BindGridView();
    }
    #endregion

    protected void txtPageSize_TextChanged(object sender, EventArgs e)
    {
        PageNo = 1;
        BindGridView();
    }
}
