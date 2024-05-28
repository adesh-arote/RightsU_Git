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
using System.Linq;
using RightsU_Entities;

public partial class SystemSetting_AssignWorkflow_View : ParentPage
{
    public User objLoginedUser { get; set; }

    #region ------ Attributes ------

    private int pageNo;
    private string mode;
    private int recCode;
    private string moduleName;
    private int BusinessCode;
    private int loginUserId;

    string assignWorkflow = "";
    string effectiveStartDate = "";
    string roleLevel = "";
    string msgAdd = "";
    string msgUpdate = "";
    string msgUpgraded = "";

    #endregion

    #region ------ Event Handlers ------

    public int WrkflwModRoleCount
    {
        get
        {
            if (ViewState["WrkflwModRoleCount"] == null) return 0;
            return (int)ViewState["WrkflwModRoleCount"];
        }
        set
        {
            ViewState["WrkflwModRoleCount"] = value;
        }
    }
    public ArrayList arrWorkflowBU
    {
        set { Session["arrWorkflowBU"] = value; }
        get
        {
            if (Session["arrWorkflowBU"] == null)
            {
                Session["arrWorkflowBU"] = new ArrayList();
            }
            return (ArrayList)Session["arrWorkflowBU"];
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);

        loginUserId = objLoginedUser.Users_Code;
        pageNo = Convert.ToInt32(Request.QueryString["pageNo"]);
        mode = Convert.ToString(Request.QueryString["mode"]);
        recCode = Convert.ToInt32(Request.QueryString["RecCode"]);
        moduleName = Convert.ToString(Request.QueryString["moduleName"]);
        BusinessCode = Convert.ToInt32(Request.QueryString["BusinessCode"]);
        GetGlobalRes();
        if (!Page.IsPostBack)
        {
            Page.Header.DataBind();
            DBUtil.AddDummyRowIfDataSourceEmpty(gvAssignWrkFlw, new WorkFlowModuleRole());

            GetGlobalRes();
            lblOpType.Text = "View " + assignWorkflow;
            SetVisibility();
            ShowData();

        }

    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("AssignWorkflow.aspx?resMsg=C&pageNo=" + pageNo);
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        Response.Redirect("AssignWorkflow.aspx?pageNo=" + pageNo);
    }

    #endregion

    #region ------ Methods ------

    private void GetGlobalRes()
    {
        assignWorkflow = "Assign Workflow";
        effectiveStartDate = "Effective Start Date";
        msgAdd = "added successfully";
        msgUpdate = "updated successfully";
        msgUpgraded = "upgraded successfully";
    }

    private void ShowData()
    {
        recCode = Convert.ToInt32(Request.QueryString["RecCode"]);
        WorkflowModule objWorkflowModule = new WorkflowModule();
        objWorkflowModule.IntCode = recCode;
        objWorkflowModule.FetchDeep();
        //if (objWorkflowModule.objWorkflow.Workflow_Type == 'F')
        //{
        //lblType.Text = "Flat";
        BusinessUnit objBU = new BusinessUnit();
        objBU.IntCode = objWorkflowModule.objWorkflow.Business_Unit_Code;
        objBU.Fetch();
        lblBusinessUnit.Text = objBU.BusinessUnitName;
        //gvWorkflowBusobjBUinessUnit.Visible = false;
        // gvAssignWrkFlw.Visible = true;
        Session["ObjWorkflowModule"] = objWorkflowModule;
        lblDisModuleName.Text = objWorkflowModule.objSysModule.moduleName;
        lblWrkflwName.Text = objWorkflowModule.objWorkflow.workflowName.ToString();
        lblEffStartDate.Text = objWorkflowModule.effStartDate;
        //lblIdealPrcDays.Text = objWorkflowModule.idealProcessDays.ToString();
        gvAssignWrkFlw.DataSource = objWorkflowModule.arrWrkflwModRole;
        gvAssignWrkFlw.DataBind();
        //}
        //else
        //{
        //    lblType.Text = "Business Unit";
        //    lblDisModuleName.Text = objWorkflowModule.objSysModule.moduleName;
        //    lblWrkflwName.Text = objWorkflowModule.objWorkflow.workflowName.ToString();
        //    lblWrkflwName.Text = objWorkflowModule.objWorkflow.workflowName.ToString();
        //    lblEffStartDate.Text = objWorkflowModule.effStartDate;
        //    lblIdealPrcDays.Text = objWorkflowModule.idealProcessDays.ToString();
        //    gvWorkflowBusinessUnit.Visible = true;
        //    gvAssignWrkFlw.Visible = false;
        //    arrWorkflowBU.Add(objWorkflowModule.arrWrkflwModBU);
        //    gvWorkflowBusinessUnit.DataSource = objWorkflowModule.arrWrkflwModBU;
        //    gvWorkflowBusinessUnit.DataBind();

        //    foreach (GridViewRow gvRow in gvWorkflowBusinessUnit.Rows)
        //    {
        //        GridView gvWorkflowBusinessUnitRole = (GridView)gvRow.FindControl("gvWorkflowBusinessUnitRole");
        //        Label lblBusinessUnitCode = (Label)gvRow.FindControl("lblBusinessUnitCode");
        //        if (gvWorkflowBusinessUnitRole != null)
        //        {
        //            WorkflowModuleBU objWorkflowModuleBU = (WorkflowModuleBU)(from WorkflowModuleBU obj in objWorkflowModule.arrWrkflwModBU
        //                                                                      where obj.BusinessUnitCode == Convert.ToInt32(lblBusinessUnitCode.Text)
        //                                                                      select obj).FirstOrDefault();
        //            if (objWorkflowModuleBU != null)
        //            {
        //                gvWorkflowBusinessUnitRole.DataSource = objWorkflowModuleBU.arrWorkflowModuleBURole;
        //                gvWorkflowBusinessUnitRole.DataBind();
        //            }
        //        }

        //    }

        //    DBUtil.AddDummyRowIfDataSourceEmpty(gvWorkflowBusinessUnit, new WorkflowModuleBU());
        //}
    }

    private void SetVisibility()
    {
        lblWrkflwName.Text = "Workflow Name";
    }

    #endregion
    #region Code added by Priti
    protected void gvWorkflowBusinessUnit_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit &&
        (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            GridView gvWorkflowBusinessUnitRole = (GridView)e.Row.FindControl("gvWorkflowBusinessUnitRole");
            gvWorkflowBusinessUnitRole.DataBind();
        }
    }
    protected void gvWorkflowBusinessUnitRole_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit &&
         (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            Label lblIUserName = (Label)e.Row.FindControl("lblIUserName");
            Label lblSecGroupCode = (Label)e.Row.FindControl("lblSecGroupCode");
            if (lblSecGroupCode != null && lblSecGroupCode.Text != "")
            {
                //Users objUser = new Users();
                //lblIUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(lblSecGroupCode.Text));
                //lblIUserName.Text = lblIUserName.Text.Trim(' ');
                //lblIUserName.Text = lblIUserName.Text.Trim(',');
            }
        }
    }

    protected void gvAssignWrkFlw_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit &&
        (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            Label lblIUserName = (Label)e.Row.FindControl("lblUserName");
            Label lblSecGroupCode = (Label)e.Row.FindControl("lblGroupCode");
            
            if (lblSecGroupCode != null && lblSecGroupCode.Text != "")
            {
                Users objUser = new Users();
                lblIUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(lblSecGroupCode.Text), BusinessCode );
                lblIUserName.Text = lblIUserName.Text.Trim(' ');
                lblIUserName.Text = lblIUserName.Text.Trim(',');
            }
        }
    }
    #endregion

}
