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

public partial class SystemSetting_ApprovalWorkflow_View : ParentPage
{
    #region ------ Attributes ------

    private int pageNo;
    private string mode;
    private int recCode;
    private string srNo;
    private int loginUserId;
    private Boolean isUsedInAssignWrkFlw;

    string approvalWorkflow = "";
    string roleLevel = "";
    string msgAdd = "";
    string msgUpdate = "";
    string msgDelete = "";
    string msgAskDelete = "";

    #endregion

    #region ------- Properties ------
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

    #endregion

    public User objLoginedUser { get; set; }


    #region ------ Event Handlers ------

    protected void Page_Load(object sender, EventArgs e)
    {
        objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);

        loginUserId = objLoginedUser.Users_Code;
        pageNo = Convert.ToInt32(Request.QueryString["pageNo"]);
        mode = Convert.ToString(Request.QueryString["mode"]);
        recCode = Convert.ToInt32(Request.QueryString["RecNo"]);
        srNo = Convert.ToString(Request.QueryString["srNo"]);
        GetGlobalRes();
        if (!Page.IsPostBack)
        {
            Page.Header.DataBind();
            lblAddEdit.Text = "View " + approvalWorkflow;
            isUsedInAssignWrkFlw = (new Workflow()).UsedInAssignWrkFlw(recCode);
            ShowData();
            //if (lblType.Text == "Flat")
                BindGrid();
            //else
            //{
            //    BindWorkflowBusinessUnitGrid();
            //    BindBusinessRoleGrid();
            //}
            txtWrkflwName.Focus();
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Session["WFGRIDDATA"] = null;
        Response.Redirect("ApprovalWorkflow.aspx?resMsg=C&pageNo=" + pageNo);
    }

    #endregion

    #region ------- Methods -------

    private void GetGlobalRes()
    {
        approvalWorkflow = "Approval Workflow";
        roleLevel = "Role Level";
        msgAdd = "added successfully";
        msgUpdate = "updated successfully";
        msgDelete = "deleted successfully";
        msgAskDelete = "Are you sure, you want to delete this record? ";

    }

    private void ShowData()
    {
        Workflow objWorkflow = new Workflow();
        objWorkflow.IntCode = recCode;
        objWorkflow.FetchDeep();
        lblSrNo.Text = srNo;
        txtWrkflwName.Text = objWorkflow.workflowName;
        txtDesc.Text = objWorkflow.remarks;
       // lblType.Text = objWorkflow.Workflow_Type == 'F' ? "Flat" : "Business Unit";
        BusinessUnit objBU = new BusinessUnit();
        objBU.IntCode = objWorkflow.Business_Unit_Code;
        objBU.Fetch();
        lblBusinessUnit.Text = objBU.BusinessUnitName;
        lblBusinessCode.Text = Convert.ToString( objBU.IntCode);

        //if (objWorkflow.Workflow_Type == 'F')
        //{
            tdFlatWorkflow.Style.Add("display", "block");
            tdBusinessUnitWorkflow.Style.Add("display", "none");
            WorkflowRole objWrkFlwRole = new WorkflowRole();
            ArrayList arrTemp = new ArrayList();

            // Updating record status flag of workflow role
            for (int i = 0; i < objWorkflow.arrWorkflowRole.Count; i++)
            {
                objWrkFlwRole = (WorkflowRole)objWorkflow.arrWorkflowRole[i];
                objWrkFlwRole.recStatus = GlobalParams.LINE_ITEM_EXISTING;
                arrTemp.Add(objWrkFlwRole);
            }
            Session["WFGRIDDATA"] = arrTemp;
        //}
        //else
        //{
        //    tdFlatWorkflow.Style.Add("display", "none");
        //    tdBusinessUnitWorkflow.Style.Add("display", "block");
        //    WorkflowBU objWorkflowBU = new WorkflowBU();
        //    ArrayList arrTemp = new ArrayList();

        //    // Updating record status flag of workflow role
        //    for (int i = 0; i < objWorkflow.arrWorkflowBusinessUnit.Count; i++)
        //    {
        //        objWorkflowBU = (WorkflowBU)objWorkflow.arrWorkflowBusinessUnit[i];
        //        //objWrkFlwRole.recStatus = GlobalParams.LINE_ITEM_EXISTING;
        //        arrTemp.Add(objWorkflowBU);
        //    }
        //    arrWorkflowBU= arrTemp;
        //}
    }
    private void BindGrid()
    {
        ArrayList arrGridData = returnArray();
        ArrayList arrTemp = new ArrayList();
        // adjust group level
        WorkflowRole objWrkFlwRole = new WorkflowRole();
        int groupLevelTemp = 1;
        for (int i = 0; i < arrGridData.Count; i++)
        {
            objWrkFlwRole = (WorkflowRole)arrGridData[i];
            if ((mode == "EDIT") && (objWrkFlwRole.recStatus == GlobalParams.LINE_ITEM_DELETED))
            {
                continue;
            }
            objWrkFlwRole.groupLevel = groupLevelTemp;
            groupLevelTemp = groupLevelTemp + 1;
            arrGridData.RemoveAt(i);
            arrGridData.Insert(i, objWrkFlwRole);
            arrTemp.Add(objWrkFlwRole);
        }
        gvWrkflwAddEdit.DataSource = arrTemp;
        gvWrkflwAddEdit.DataBind();
        DBUtil.AddDummyRowIfDataSourceEmpty(gvWrkflwAddEdit, new WorkflowRole());
        //if (arrTemp.Count == 0)
        //    btnSave.Visible = false;
        //else
        //    btnSave.Visible = true;
    }

    private ArrayList returnArray()
    {
        ArrayList arrTemp;
        if ((Session["WFGRIDDATA"] == null) || (((ArrayList)Session["WFGRIDDATA"])).Count == 0)
            arrTemp = new ArrayList();
        else
            arrTemp = (ArrayList)Session["WFGRIDDATA"];

        return arrTemp;
    }

    #endregion

    #region Code Added for Business Unit --- By priti

    private void BindWorkflowBusinessUnitGrid()
    {
        Criteria objCrt = new Criteria();
        objCrt.ClassRef = new BusinessUnit();

        ArrayList arrCount = new ArrayList();
        arrCount = objCrt.Execute(" and Is_Active = 'Y'");
        gvWorkflowBusinessUnit.DataSource = arrCount;
        gvWorkflowBusinessUnit.DataBind();
    }

    private void BindBusinessRoleGrid()
    {
        foreach (GridViewRow gvRow in gvWorkflowBusinessUnit.Rows)
        {
            GridView gvWorkflowBusinessUnitRole = (GridView)gvRow.FindControl("gvWorkflowBusinessUnitRole");
            Label lblBusinessUnitCode = (Label)gvRow.FindControl("lblBusinessUnitCode");
            if (gvWorkflowBusinessUnitRole != null)
            {
                if (arrWorkflowBU.Count > 0)
                {
                    ArrayList arrTempBuRole = new ArrayList();
                    WorkflowBU objw = (WorkflowBU)(from WorkflowBU obj in arrWorkflowBU
                                                   where obj.BusinessUnitCode == Convert.ToInt32(lblBusinessUnitCode.Text)
                                                   select obj).FirstOrDefault();
                    if (objw != null)
                    {
                        arrTempBuRole.AddRange(objw.arrWorkflowBusinessUnitRole);
                    }
                    else
                        gvRow.Visible = false;
                    gvWorkflowBusinessUnitRole.DataSource = arrTempBuRole;
                    gvWorkflowBusinessUnitRole.DataBind();
                    DBUtil.AddDummyRowIfDataSourceEmpty(gvWorkflowBusinessUnitRole, new WorkflowBURole());
                }
                else
                {
                    ArrayList arrTemp = new ArrayList();
                    gvWorkflowBusinessUnitRole.DataSource = arrTemp;
                    gvWorkflowBusinessUnitRole.DataBind();
                    DBUtil.AddDummyRowIfDataSourceEmpty(gvWorkflowBusinessUnitRole, new WorkflowBURole());
                }
            }
        }
    }

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
                Users objUser = new Users();
               // lblIUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(lblSecGroupCode.Text));
                lblIUserName.Text = lblIUserName.Text.Trim(' ');
                lblIUserName.Text = lblIUserName.Text.Trim(',');
            }
        }
    }
    protected void gvWrkflwAddEdit_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit &&
         (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            Label lblIUserName = (Label)e.Row.FindControl("lblPrimaryUser");
            Label lblSecGroupCode = (Label)e.Row.FindControl("lblHdnSecGrp");
            if (lblSecGroupCode != null && lblSecGroupCode.Text != "")
            {
                Users objUser = new Users();
                lblIUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(lblSecGroupCode.Text), Convert.ToInt32(lblBusinessCode.Text) );
                lblIUserName.Text = lblIUserName.Text.Trim(' ');
                lblIUserName.Text = lblIUserName.Text.Trim(',');
            }
        }
    }
    #endregion

}
