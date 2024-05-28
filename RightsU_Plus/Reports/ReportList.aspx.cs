using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
using RightsU_BLL;
using System.Linq;
using RightsU_Entities;
using System.Collections.Generic;

public partial class Reports_ReportList : ParentPage
{
    public User objLoginedUser { get; set; }
    #region --- Properties --
    private string SelectedView
    {
        get
        {
            if (ViewState["SelectedView"] == null)
                ViewState["SelectedView"] = "VW_ACQ_DEALS";
            return ViewState["SelectedView"].ToString();
        }
        set
        {
            ViewState["SelectedView"] = value;
        }
    }
    private string SelectedBusinessUnit
    {
        get
        {
            if (ViewState["SelectedBusinessUnit"] == null)
                ViewState["SelectedBusinessUnit"] = "";
            return ViewState["SelectedBusinessUnit"].ToString();
        }
        set
        {
            ViewState["SelectedBusinessUnit"] = value;
        }
    }
    private int ModuleCode
    {
        get
        {
            if (ViewState["ModuleCode"] == null)
                ViewState["ModuleCode"] = "0";
            return Convert.ToInt32(ViewState["ModuleCode"]);
        }
        set
        {
            ViewState["ModuleCode"] = value;
        }
    }
    #endregion

    #region --- Page Events ---
    protected void Page_Load(object sender, EventArgs e)
    {
        objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);
        ((Home)this.Page.Master).setVal("AcqQueryReport");
        if (!IsPostBack)
        {
            Page.Header.DataBind();
            if (Request.QueryString["View_Name"] != null)
                SelectedView = Request.QueryString["View_Name"].ToString();

            if (Request.QueryString["BusinessUnitCode"] != null)
                SelectedBusinessUnit = Request.QueryString["BusinessUnitCode"].ToString();

            if (Request.QueryString["Expired"] != null)
                chkExpired.Checked = Convert.ToBoolean(Request.QueryString["Expired"]);

            if (Request.QueryString["Theatrical"] != null)
                chkTheatricalTerritory.Checked = Convert.ToBoolean(Request.QueryString["Theatrical"]);

            if (Request.QueryString["moduleCode"] != null)
                ModuleCode = Convert.ToInt32(Request.QueryString["moduleCode"]);
            else
                ModuleCode = objLoginedUser.moduleCode;

            FillDDL_VW();
            ddlView.SelectedValue = SelectedView;
            BindBusinessUnit();
            BindQueryGrid();
        }
    }
    #endregion

    #region --- Button Events ---
    protected void btnNew_Click(object sender, EventArgs e)
    {
        SelectedView = ddlView.SelectedValue;
        SelectedBusinessUnit = ddlBusinessUnit.SelectedValue;

        if (SelectedView == "VW_ACQ_DEALS" || SelectedView == "VW_SYN_DEALS")
        {
            string strRedirect = "~/Reports/rptDealQuery.aspx?"
                + "Query_Id=0&View_Name=" + SelectedView + "&BusinessUnitCode=" + SelectedBusinessUnit
                + "&Expired=" + chkExpired.Checked + "&Theatrical=" + chkTheatricalTerritory.Checked;

            Response.Redirect(strRedirect);
        }
        else
          //  MessageShow.CreateMessageAlert(this, "This report is not available:" + SelectedView, "");
            MessageShow.CreateMessageAlert(this, "This report is not available:" + SelectedView, "");
    }
    #endregion

    #region --- gvReport Gridview Events ---
    private void BindQueryGrid()
    {
        string view = ddlView.SelectedValue;
        string strFilter = " and view_name ='" + view + "' and business_unit_code =" + SelectedBusinessUnit
            + " and (Created_By=" + objLoginedUser.Users_Code
            + " OR Visibility='RO' and Security_Group_Code =" + objLoginedUser.Security_Group_Code
            + " OR Visibility='PU')";

        Criteria crit = new Criteria(new ReportQuery(view));
        ArrayList arrRep = crit.Execute(strFilter);
        gvReport.DataSource = arrRep;
        gvReport.DataBind();
        DBUtil.AddDummyRowIfDataSourceEmpty(gvReport, new ReportQuery(view));
    }
    protected void gvReport_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit && (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            Button btnDelete = (Button)e.Row.FindControl("btnDelete");
            Label lblCreatedBy = (Label)(e.Row.FindControl("lblCreatedBy"));
            Users objUserCreatedBy = new Users();

            objUserCreatedBy.IntCode = Convert.ToInt32(lblCreatedBy.Text);

            if (objUserCreatedBy.IntCode == 0)
                objUserCreatedBy.IntCode = objLoginedUser.Users_Code;

            objUserCreatedBy.Fetch();

            lblCreatedBy.Text = objUserCreatedBy.loginName;
            btnDelete.Attributes.Add("Onclick", "javascript:return canEditForDeleteAjax(" + hfIndex.ClientID + ",'Are you sure you want to delete?',this);");

            if (objUserCreatedBy.IntCode != objLoginedUser.Users_Code)
                btnDelete.Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowState == DataControlRowState.Normal)
        {
            e.Row.Attributes.Add("onMouseOver", "this.className='highlight'");
            e.Row.Attributes.Add("onMouseOut", "this.className='border'");
        }
        else if (e.Row.RowState == DataControlRowState.Alternate)
        {
            e.Row.Attributes.Add("onMouseOver", "this.className='highlight'");
            e.Row.Attributes.Add("onMouseOut", "this.className='rowBg'");
        }
    }
    protected void gvReport_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int rowIndex = Convert.ToInt32(e.CommandArgument);
        SelectedView = ddlView.SelectedValue;
        SelectedBusinessUnit = ddlBusinessUnit.SelectedValue;

        if (e.CommandName == "Query")
        {
            int code = Convert.ToInt32(gvReport.DataKeys[rowIndex]["IntCode"]);
            Response.Redirect("~/Reports/rptDealQuery.aspx?View_Name=" + SelectedView + "&Query_Id=" + code + "&BusinessUnitCode=" + SelectedBusinessUnit);
        }
    }
    protected void gvReport_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int code = Convert.ToInt32(gvReport.DataKeys[e.RowIndex]["IntCode"]);
        ReportQuery objReportQuery = new ReportQuery(SelectedView);
        objReportQuery.IntCode = code;
        objReportQuery.IsDirty = false;
        objReportQuery.IsDeleted = true;
        objReportQuery.Save();
        BindQueryGrid();
       CreateMessageAlert(btnNew, "Query deleted successfully!");
     //   CreateMessageAlert("Query deleted successfully!");
    }
    #endregion

    #region --- Dropdown Events ---
    private void FillDDL_VW()
    {
        if (ModuleCode == 55)
        {
            ddlView.Items.Add(new ListItem("Acquisition Deals", "VW_ACQ_DEALS"));
            ddlView.Items.Add(new ListItem("Syndication Deals", "VW_SYN_DEALS"));
            lblTitle.Text = "Query Report List";
        }
        else if (ModuleCode == 64)
        {
            ddlView.Items.Add(new ListItem("International Availabilty", "VW_MOVIE_RIGHTS_STATUS_AVAILABLE_REPORT*I"));
            ddlView.SelectedValue = "VW_MOVIE_RIGHTS_STATUS_AVAILABLE_REPORT*I";
            lblTitle.Text = "Availabilty Query Report List";
            ddlView.Visible = false;
        }
        else if (ModuleCode == 65)
        {
            ddlView.Items.Add(new ListItem("Theatrical Availabilty", "VW_MOVIE_RIGHTS_STATUS_AVAILABLE_REPORT*D"));
            ddlView.SelectedValue = "VW_MOVIE_RIGHTS_STATUS_AVAILABLE_REPORT*D";
            ddlView.Visible = false;
            lblTitle.Text = "Theatrical Availabilty Query Report List";
        }
    }
    private void BindBusinessUnit()
    {
        List<string> lstRights = new USP_Service(ObjLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForQueryReport), objLoginedUser.Security_Group_Code, objLoginedUser.Users_Code).ToList();
        string rights = "";
        if (lstRights.FirstOrDefault() != null)
            rights = lstRights.FirstOrDefault();
        var list = (new Business_Unit_Service(ObjLoginEntity.ConnectionStringName)).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginedUser.Users_Code)).ToList();

        if (rights.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
        {
            Business_Unit allGec = new Business_Unit();
            allGec.Business_Unit_Code = 0;
            allGec.Business_Unit_Name = "All Regional GEC";
            list.Insert(0, allGec);
        }

        //if (rights.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
        //{
        //    Business_Unit allGec = new Business_Unit();
        //    allGec.Business_Unit_Code = 100;
        //    allGec.Business_Unit_Name = "All Business Unit";
        //    list.Insert(0,allGec);
        //}
 
        ddlBusinessUnit.DataSource = list.ToList();
        ddlBusinessUnit.DataTextField = "Business_Unit_Name";
        ddlBusinessUnit.DataValueField = "Business_Unit_Code";
        ddlBusinessUnit.DataBind();

        if (!SelectedBusinessUnit.Equals(""))
            ddlBusinessUnit.SelectedValue = SelectedBusinessUnit;
        else
            SelectedBusinessUnit = ddlBusinessUnit.SelectedValue;
    }
    protected void ddlView_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindQueryGrid();
    }
    #endregion

    protected void ddlBusinessUnit_SelectedIndexChanged(object sender, EventArgs e)
    {
        SelectedBusinessUnit = ddlBusinessUnit.SelectedValue;
        BindQueryGrid();
    }
}
