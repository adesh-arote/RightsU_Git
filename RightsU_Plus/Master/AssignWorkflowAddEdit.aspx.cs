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

public partial class SystemSetting_AssignWorkflowAddEdit : ParentPage
{
    #region ------ Attributes ------

    private int pageNo;
    private string mode;
    private int recCode;
    private string moduleName;
    private int loginUserId;
    private int businessUnitCode;

    string assignWorkflow = "";
    string effectiveStartDate = "";
    string roleLevel = "";
    string msgAdd = "";
    string msgUpdate = "";
    string msgUpgraded = "";

    #endregion

    public User objLoginedUser { get; set; }

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
        recCode = Convert.ToInt32(Request.QueryString["RecNo"]);
        moduleName = Convert.ToString(Request.QueryString["moduleName"]);
        businessUnitCode = Convert.ToInt32(Request.QueryString["BusinessCode"]);

        GetGlobalRes();

        if (!Page.IsPostBack)
        {
            Page.Header.DataBind();
            hdnDateWatermarkFormat.Value = "DD/MM/YYYY";
            arrWorkflowBU = new ArrayList();
            gvAssignWrkFlw.Visible = false;
            gvWorkflowBusinessUnit.Visible = false;

            BindDropDown();
            ddlModuleName.Focus();
            GetGlobalRes();

            if (mode != "VIEWHIS")
                divView.Attributes.Add("style", "display:none");

            if (mode == "ASSIGN")
            {
                lblOpType.Text = assignWorkflow;
                txtEffStartDate.Text = DateTime.Now.ToString("dd/MM/yyyy");
                btnAssign.Visible = false;
                SetVisibility();
            }
            else if (mode == "EDIT")
            {
                lblOpType.Text = "Edit " + assignWorkflow;
                btnAssign.Text = "Update";
                SetVisibility();
                ShowData();
            }
            else if (mode == "UPGRADE")
            {
                lblOpType.Text = "Upgrade " + assignWorkflow;
                ShowData();
                btnAssign.Text = "Upgrade";
                btnAssign.Visible = false;
                lblWrkflwName.Text = "Old Workflow Name";
            }
            else
            {
                divMain.Attributes.Add("style", "display:none");
                lblView.Text = "View History for " + moduleName;
                BindViewGrid();
            }

            DBUtil.AddDummyRowIfDataSourceEmpty(gvAssignWrkFlw, new WorkFlowModuleRole());
        }

        RegisterJS();
    }

    protected void ddlWorkflowName_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (mode == "EDIT")
            ddlWorkflowName.SelectedValue = ((WorkflowModule)Session["ObjWorkflowModule"]).objWorkflow.IntCode.ToString();

        GridBind();
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "assignDate", "AssignDateJQuery();", true);
    }

    private string CheckForApproval()
    {
        int moduleCode;
        int workFlowCode;
        int appRightCode = GlobalParams.RightCodeForApprove;

        if ((mode == "EDIT") || (mode == "UPGRADE"))
            moduleCode = ((WorkflowModule)Session["ObjWorkflowModule"]).objSysModule.IntCode;
        else
            moduleCode = Convert.ToInt32(ddlModuleName.SelectedValue);

        if (mode == "UPGRADE")
            workFlowCode = Convert.ToInt32(ddlNewWrkflwName.SelectedValue);
        else
            workFlowCode = Convert.ToInt32(ddlWorkflowName.SelectedValue);


        string secGrpName = (new Workflow()).GetSecGrpName(moduleCode, workFlowCode, appRightCode);
        return secGrpName;
    }
    protected void ddlNewWrkflwName_SelectedIndexChanged(object sender, EventArgs e)
    {
        //string secGrpName=CheckForApproval();
        //if (secGrpName != "")
        //{
        //    CreateMessageAlert(ddlNewWrkflwName, "Workflow(" + ddlNewWrkflwName.SelectedItem.Text + ") has no approval right for the Security Group(s) " + secGrpName + ", therefore cannot be selected");
        //    ddlNewWrkflwName.SelectedIndex = 0;
        //    GetEmptyGrid();
        //}
        //else
        //{
        GridBind();
        //smAssWfAddEdit.SetFocus(imgCal);
        //}
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "assignDate", "AssignDateJQuery();", true);
    }
    protected void btnAssign_Click(object sender, EventArgs e)
    {
        try
        {
            #region Flat Workflow Part
            string resMsg = "";
            DateTime tempEffStartDate = Convert.ToDateTime(GlobalUtil.MakedateFormat(txtEffStartDate.Text.Trim()));
            int BusinessUnitCode = 0;

            if (mode == "ASSIGN")
            {
                DateTime currFormattedDate = Convert.ToDateTime(GlobalUtil.MakedateFormat(System.DateTime.Now.ToString("dd/MM/yyyy")));

                // Checking for if deal memo exists but still workflow not assigned
                //start   replaced by sachin tempdate should be today and greater
                string tempDate = DateTime.Now.AddDays(-1).ToString("dd/MM/yyyy");// GetDateInStr(Convert.ToInt32(ddlModuleName.SelectedValue), Convert.ToInt32(ddlBusinessUnit.SelectedValue));

                if ((tempDate != "") && (DateTime.Compare(GetDate(tempDate), tempEffStartDate) >= 0))
                {
                    CreateMessageAlert(ddlNewWrkflwName, effectiveStartDate + " should be greater than " + tempDate + " beacuse deal memo available till/for this date");
                    return;
                }
                //end
            }

            WorkflowModule objWrkflwModule = new WorkflowModule();

            if ((mode == "EDIT") || (mode == "UPGRADE"))
            {
                if (mode == "EDIT")
                {
                    objWrkflwModule.IntCode = recCode;
                    objWrkflwModule.FetchDeep();
                    string resDateMsg = GetDateRange(objWrkflwModule.objSysModule.IntCode, txtEffStartDate.Text);

                    if (resDateMsg != "")
                    {
                        CreateMessageAlert(ddlNewWrkflwName, effectiveStartDate + " " + resDateMsg);
                        return;
                    }

                    WorkFlowModuleRole objFirstWFModuleRole = new WorkFlowModuleRole();
                    objFirstWFModuleRole = (WorkFlowModuleRole)objWrkflwModule.arrWrkflwModRole[0];

                    // Updating latest history of module's workflow
                    WorkflowModule objTemp = new WorkflowModule();
                    Criteria objCrTemp = new Criteria();
                    objTemp.OrderByColumnName = "workflow_module_code";
                    objTemp.OrderByCondition = "ASC";
                    objCrTemp.ClassRef = objTemp;
                    ArrayList arr = objCrTemp.Execute("and module_code=" + objWrkflwModule.objSysModule.IntCode);

                    if ((DateTime.Compare(Convert.ToDateTime(GlobalUtil.MakedateFormat(objWrkflwModule.effStartDate)), tempEffStartDate) != 0) && (arr.Count > 1))
                    {
                        objTemp = new WorkflowModule();
                        objTemp = (WorkflowModule)arr[arr.Count - 2];
                        objTemp.sysEndDate = tempEffStartDate.AddDays(-1).ToString("dd/MM/yyyy");
                        objTemp.IsDirty = true;
                        objTemp.IsTransactionRequired = true;
                        objTemp.IsBeginningOfTrans = true;
                        objTemp.Save();
                        objFirstWFModuleRole.SqlTrans = objTemp.SqlTrans;
                    }
                    else
                    {
                        objFirstWFModuleRole.IsBeginningOfTrans = true;
                    }
                    // delete all old child records 

                    objFirstWFModuleRole.IsTransactionRequired = true;
                    objFirstWFModuleRole.IsDeleted = true;
                    objFirstWFModuleRole.Save();
                    WorkFlowModuleRole objDelWFModuleRole = new WorkFlowModuleRole();

                    for (int i = 1; i < objWrkflwModule.arrWrkflwModRole.Count; i++)
                    {
                        objDelWFModuleRole = (WorkFlowModuleRole)objWrkflwModule.arrWrkflwModRole[i];
                        objDelWFModuleRole.SqlTrans = objFirstWFModuleRole.SqlTrans;
                        objDelWFModuleRole.IsTransactionRequired = true;
                        objDelWFModuleRole.IsDeleted = true;
                        objDelWFModuleRole.Save();
                    }

                    objWrkflwModule.IsDirty = true;
                    objWrkflwModule.SqlTrans = objFirstWFModuleRole.SqlTrans;
                    objWrkflwModule.arrWrkflwModRole.Clear();
                }
                else
                {
                    WorkflowModule objInActiveWrkflwMod = new WorkflowModule();
                    objInActiveWrkflwMod.IntCode = recCode;
                    objInActiveWrkflwMod.FetchDeep();
                    BusinessUnitCode = objInActiveWrkflwMod.Business_Unit_Code;
                    // date change to current date 
                    string tempDate = DateTime.Now.AddDays(-1).ToString("dd/MM/yyyy");

                    if ((tempDate != "") && (DateTime.Compare(GetDate(tempDate), tempEffStartDate) >= 0))
                    {
                        //if (DateTime.Compare(Convert.ToDateTime(GlobalUtil.MakedateFormat(DateTime.Now.AddDays(-1).ToString("dd/MM/yyyy"))), tempEffStartDate) >= 0)
                        //{
                        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "assignDate", "AssignDateJQuery();", true);
                        CreateMessageAlert(ddlNewWrkflwName, effectiveStartDate + " should be greater than (" + DateTime.Now.AddDays(-1).ToString("dd/MM/yyyy") + ")");
                        return;
                    }

                    string resDateMsg = GetDateOnUpgrade(objInActiveWrkflwMod.objSysModule.IntCode, txtEffStartDate.Text);

                    if (resDateMsg != "")
                    {
                        CreateMessageAlert(ddlNewWrkflwName, effectiveStartDate + " " + resDateMsg);
                        return;
                    }

                    objInActiveWrkflwMod.isWrkFlwActive = 'N';
                    objInActiveWrkflwMod.sysEndDate = tempEffStartDate.AddDays(-1).ToString("dd/MM/yyyy");
                    objInActiveWrkflwMod.IsTransactionRequired = true;
                    objInActiveWrkflwMod.IsBeginningOfTrans = true;
                    objInActiveWrkflwMod.IsDirty = true;
                    objInActiveWrkflwMod.Save();

                    objWrkflwModule.objSysModule.IntCode = objInActiveWrkflwMod.objSysModule.IntCode;
                    objWrkflwModule.objWorkflow.IntCode = Convert.ToInt32(ddlNewWrkflwName.SelectedValue);
                    objWrkflwModule.SqlTrans = objInActiveWrkflwMod.SqlTrans;
                }
            }

            if ((mode == "ASSIGN") || (mode == "EDIT"))
            {
                if (mode == "ASSIGN")
                {
                    objWrkflwModule.objSysModule.IntCode = Convert.ToInt32(ddlModuleName.SelectedValue);
                    objWrkflwModule.moduleCode = Convert.ToInt32(ddlModuleName.SelectedValue);
                    objWrkflwModule.Business_Unit_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);
                }

                objWrkflwModule.objWorkflow.IntCode = Convert.ToInt32(ddlWorkflowName.SelectedValue);
            }

            //objWrkflwModule.idealProcessDays = Convert.ToInt32(lblIdealPrcDays.Text);
            objWrkflwModule.effStartDate = txtEffStartDate.Text.Trim();
            objWrkflwModule.isWrkFlwActive = 'Y';
            // objWrkflwModule.moduleCode = Convert.ToInt32(ddlModuleName.SelectedValue);

            if ((mode == "EDIT") || (mode == "UPGRADE"))
            {
                objWrkflwModule.Workflow_Code = Convert.ToInt32(ddlNewWrkflwName.SelectedValue);
                objWrkflwModule.moduleCode = objWrkflwModule.objSysModule.IntCode;
                objWrkflwModule.Business_Unit_Code = BusinessUnitCode;
            }
            else
            {
                objWrkflwModule.Workflow_Code = Convert.ToInt32(ddlWorkflowName.SelectedValue);
            }

            objWrkflwModule.LastUpdatedBy = loginUserId;
            WorkFlowModuleRole objWrkflwModRole;

            foreach (GridViewRow row in gvAssignWrkFlw.Rows)
            {
                if (WrkflwModRoleCount > 0)
                {
                    //Convert.ToInt32(gvAssignWrkFlw.DataKeys[row.RowIndex].Values[0]);
                    Label lblWrkflwIntCode = (Label)row.FindControl("lblWrkflwIntCode");
                    Label lblGroupLevel = (Label)row.FindControl("lblGroupLevel");
                    Label lblGroupCode = (Label)row.FindControl("lblGroupCode");
                    //TextBox txtReminder = (TextBox)row.FindControl("txtReminder");
                    objWrkflwModRole = new WorkFlowModuleRole();
                    objWrkflwModRole.objWorkflowRole.IntCode = Convert.ToInt32(lblWrkflwIntCode.Text);
                    //objWrkflwModule.moduleCode = Convert.ToInt32(ddlModuleName.SelectedValue);
                    objWrkflwModRole.groupLevel = Convert.ToInt32(lblGroupLevel.Text);
                    objWrkflwModRole.objSecurityGroup.IntCode = Convert.ToInt32(lblGroupCode.Text);
                    objWrkflwModRole.reminderDays = 0;//Convert.ToInt32(txtReminder.Text);
                    objWrkflwModule.arrWrkflwModRole.Add(objWrkflwModRole);
                }
            }
            objWrkflwModule.IsTransactionRequired = true;

            if (mode == "ASSIGN")
                objWrkflwModule.IsBeginningOfTrans = true;

            objWrkflwModule.IsProxy = false;
            objWrkflwModule.IsEndOfTrans = true;
            resMsg = objWrkflwModule.Save();
            hdnEditRecord.Value = "";

            if ((resMsg != GlobalParams.RECORD_ADDED) && (resMsg != GlobalParams.RECORD_UPDATED))
                CreateMessageAlert(ddlModuleName, resMsg);
            else
            {
                if ((mode == "EDIT") || mode == "UPGRADE")
                {
                    Session["ObjWorkflowModule"] = null;
                    ReleaseRecord();

                    if (mode == "UPGRADE")
                        resMsg = "UP";
                }

                if (resMsg == GlobalParams.RECORD_ADDED || resMsg == GlobalParams.RECORD_UPDATED || resMsg == "UP" || resMsg == "C")
                {
                    if (resMsg == GlobalParams.RECORD_ADDED)
                    {
                        TransferAlertMessage(assignWorkflow + " " + msgAdd, "AssignWorkflow.aspx?pageNo=" + pageNo);
                    }
                    else if (resMsg == GlobalParams.RECORD_UPDATED)
                    {
                        TransferAlertMessage(assignWorkflow + " " + msgUpdate, "AssignWorkflow.aspx?pageNo=" + pageNo);
                    }
                    else if (resMsg == "UP")
                    {
                        TransferAlertMessage(assignWorkflow + " " + msgUpgraded, "AssignWorkflow.aspx?pageNo=" + pageNo);
                    }
                }
            }
            #endregion
        }
        catch (Exception ex)
        {
            if (mode == "UPGRADE")
                CreateMessageAlert(ddlNewWrkflwName, ex.Message);
            else
                CreateMessageAlert(ddlModuleName, ex.Message);
        }
        finally
        {
           // upAssWfAddEdit.Update();
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "assignDate", "AssignDateJQuery();", true);
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        if ((mode == "EDIT") || (mode == "UPGRADE"))
        {
            Session["ObjWorkflowModule"] = null;
            ReleaseRecord();
        }

        arrWorkflowBU = null;
        Response.Redirect("AssignWorkflow.aspx?resMsg=C&pageNo=" + pageNo);
    }
    protected void gvAssignWrkFlw_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            Label lblIUserName = (Label)e.Row.FindControl("lblUserName");
            Label lblGroupCode = (Label)e.Row.FindControl("lblGroupCode");

            if (lblGroupCode != null && lblGroupCode.Text != "")
            {
                Users objUser = new Users();

                if (mode == "UPGRADE")
                    lblIUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(lblGroupCode.Text), Convert.ToInt32(lblBusinessCode.Text));
                else
                    lblIUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(lblGroupCode.Text), Convert.ToInt32(ddlBusinessUnit.SelectedValue));

                lblIUserName.Text = lblIUserName.Text.Trim(' ');
                lblIUserName.Text = lblIUserName.Text.Trim(',');
            }
        }
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        Response.Redirect("AssignWorkflow.aspx?pageNo=" + pageNo);
    }

    protected void ddlModuleName_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (Convert.ToInt32(ddlModuleName.SelectedValue) > 0)
        {
            //int idealPrsDays = GetIdealProcessDays(Convert.ToInt32(ddlModuleName.SelectedValue));
            //if (idealPrsDays > 0)
            //{                
            // trWrkflw.Attributes.Add("style", "display:block");
            // trIdealPrsDays.Attributes.Add("style", "display:block");
            //lblIdealPrcDays.Text = idealPrsDays.ToString();
            //}
            //else
            //{
            //    lblIdealPrcDays.Text = "";
            //    ddlModuleName.SelectedIndex = 0;
            //    CreateMessageAlert(ddlModuleName, "Module has no Ideal Process Days, therefore cannot be selected");
            //}

            if ((mode == "ASSIGN") && (ddlWorkflowName.SelectedIndex > 0))
            {
                ddlWorkflowName.SelectedIndex = 0;
                GetEmptyGrid();
                btnAssign.Visible = false;
            }

            //Code to bind Business Unit
            ddlBusinessUnit.Items.Clear();
            string sqlStr = "";
            string filter = "";
            sqlStr = "declare @Business_Unit_Code varchar(MAX) = '' "
                    + " select @Business_Unit_Code = @Business_Unit_Code + CONVERT( varchar(20), Business_Unit_Code) + ',' from Workflow_Module where Module_Code = " + ddlModuleName.SelectedValue + ""
                    + " select @Business_Unit_Code ";
            string BusinessCodes = DatabaseBroker.ProcessScalarReturnString(sqlStr);

            if (BusinessCodes != "")
            {
                BusinessCodes = BusinessCodes.Trim(',');
                filter = filter + " and Business_Unit_Code not IN (" + BusinessCodes + ")";
            }

            BusinessUnit objBusinessUnit = new BusinessUnit();
            objBusinessUnit.OrderByColumnName = "Business_Unit_Name";
            DBUtil.BindDropDownList(ref ddlBusinessUnit, objBusinessUnit, filter, "BusinessUnitName", "IntCode", true, "");
            //Code to bind Business Unit
        }
        else
        {
            ddlWorkflowName.SelectedIndex = 0;
            trWrkflw.Attributes.Add("style", "display:none");
            //  trIdealPrsDays.Attributes.Add("style", "display:none");
            //  lblIdealPrcDays.Text = "";

            // Clear the grid

            GetEmptyGrid();
            btnAssign.Visible = false;
        }
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "assignDate", "AssignDateJQuery();", true);
    }

    protected void ddlBusinessUnit_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (mode != "UPGRADE")
        {
            if (ddlModuleName.SelectedValue == "0")
            {
                CreateMessageAlert(ddlModuleName, "Select module name.");
                return;
            }

            ddlWorkflowName.Items.Clear();
            DBUtil.BindDropDownList(ref ddlWorkflowName, new Workflow(), " and Business_Unit_Code in(" + ddlBusinessUnit.SelectedValue + ") ", "workflowName", "IntCode", true, "");
            trWrkflw.Visible = true;
        }
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "assignDate", "AssignDateJQuery();", true);
    }

    private void GetEmptyGrid()
    {
        gvAssignWrkFlw.DataSource = null;
        gvAssignWrkFlw.DataBind();
        DBUtil.AddDummyRowIfDataSourceEmpty(gvAssignWrkFlw, new WorkFlowModuleRole());
    }

    #endregion

    #region ------ Methods ------

    private int GetIdealProcessDays(int moduleCode)
    {
        //ArrayList arr = DBUtil.FillArrayList(new StageWiseDefinition(), "and module_code=" + moduleCode, false);
        //if (arr.Count > 0)
        //{
        //    return Convert.ToInt32(((StageWiseDefinition)arr[0]).idealDays);
        //}
        return 0;
    }

    private void RegisterJS()
    {
        //txtEffStartDate.Attributes.Add("readonly", "true");
        //ddlWorkflowName.Attributes.Add("onchange", "CheckWorkFlow();");
        //txtIdealPrcDays.Attributes.Add("onKeyPress", "fnEnterKey('" + btnAssign.ClientID + "');ValidateDays(this);");
        //btnAssign.Attributes.Add("onclick", "ValidateDays();");
    }

    private void BindDropDown()
    {
        if (mode == "ASSIGN")
        {
            SystemModule objSysMod = new SystemModule();
            objSysMod.OrderByColumnName = "module_name";
            objSysMod.OrderByCondition = "ASC";
            //order by module_name asc
            // DBUtil.BindDropDownList(ref ddlModuleName, objSysMod, "and can_workflow_assign='Y' and module_code not in(select module_code from Workflow_Module) ", "moduleName", "IntCode", true, "");

            int WorkflowBusinessCount = 0;
            int BusinessCount = 0;
            string filter = "";
            string sql = "declare @Module_Code varchar(MAX) = '' "
                         + " select @Module_Code = @Module_Code + CONVERT(varchar(20), Module_Code) + ',' from System_Module where Can_Workflow_Assign = 'Y' "
                         + " and Is_Active = 'Y'"
                         + "select @Module_Code ";
            string moduleCodes = DatabaseBroker.ProcessScalarReturnString(sql);

            if (moduleCodes != "")
                moduleCodes = moduleCodes.Trim(',');

            string[] ModuleCode = moduleCodes.Split(',');

            for (int i = 0; i < ModuleCode.Length; i++)
            {
                if (ModuleCode[i] != "")
                {
                    WorkflowBusinessCount = DatabaseBroker.ProcessScalarDirectly("select COUNT(Business_Unit_Code) from Workflow_Module  where Module_Code = " + ModuleCode[i] + " and Is_Active = 'Y' ");
                    BusinessCount = DatabaseBroker.ProcessScalarDirectly("select COUNT(Business_Unit_Code) from Business_Unit where  Is_Active = 'Y'");

                    if (WorkflowBusinessCount == BusinessCount)
                        filter = filter + ModuleCode[i] + ",";
                }
            }

            //string sqlStr = " declare @Module_Code varchar(MAX) = '' "
            //                + " select @Module_Code = @Module_Code + CONVERT(varchar(20), Module_Code) + ',' from System_Module where Can_Workflow_Assign = 'Y' "
            //                + " and  Module_Code in ( "
            //                + " select Module_Code from Workflow_Module where Business_Unit_Code  in( "
            //                + " select Business_Unit_Code from Business_Unit where Is_Active = 'Y' "
            //                + " )  "
            //                + " and Is_Active = 'Y' )"
            //                + " select @Module_Code ";

            //string filter = "";
            //filter = DatabaseBroker.ProcessScalarReturnString(sqlStr);

            if (filter != "")
                filter = filter.Trim(',');
            else
                filter = "0";

            DBUtil.BindDropDownList(ref ddlModuleName, objSysMod, "and can_workflow_assign='Y' and Module_Code not in (" + filter + ")  ", "moduleName", "IntCode", true, "");
        }

        string str = "- - - Please Select - - -";
        ddlBusinessUnit.Items.Insert(0, new System.Web.UI.WebControls.ListItem(str, "0"));
        ddlWorkflowName.Items.Insert(0, new System.Web.UI.WebControls.ListItem(str, "0"));
    }

    private void GridBind()
    {
        Workflow objWorkflow = new Workflow();

        if ((mode == "ASSIGN") || (mode == "EDIT"))
            objWorkflow.IntCode = Convert.ToInt32(ddlWorkflowName.SelectedValue);
        else
            objWorkflow.IntCode = Convert.ToInt32(ddlNewWrkflwName.SelectedValue);

        if (objWorkflow.IntCode != 0)
            objWorkflow.FetchDeep();

        //lblType.Text = objWorkflow.Workflow_Type == 'F' ? "Flat" : "Business Unit";
        //BusinessUnit objBU = new BusinessUnit();
        //objBU.IntCode = objWorkflow.Business_Unit_Code;
        //objBU.Fetch();
        //lblBusinessUnit.Text = objBU.BusinessUnitName;

        //if (objWorkflow.Workflow_Type == 'F')
        //{
        gvAssignWrkFlw.Visible = true;
        gvWorkflowBusinessUnit.Visible = false;
        WorkflowModule objWFModule = new WorkflowModule();

        foreach (WorkflowRole objWFRole in objWorkflow.arrWorkflowRole)
        {
            WorkFlowModuleRole objWFModuleRole = new WorkFlowModuleRole();
            objWFModuleRole.objWorkflowRole = objWFRole;
            objWFModule.arrWrkflwModRole.Add(objWFModuleRole);
        }

        gvAssignWrkFlw.DataSource = objWFModule.arrWrkflwModRole;
        WrkflwModRoleCount = objWFModule.arrWrkflwModRole.Count;
        gvAssignWrkFlw.DataBind();
        DBUtil.AddDummyRowIfDataSourceEmpty(gvAssignWrkFlw, new WorkFlowModuleRole());

        //if (objWFModule.arrWrkflwModRole.Count > 0)
        btnAssign.Visible = true;

        //}
        //else
        //{
        //    gvAssignWrkFlw.Visible = false;
        //    gvWorkflowBusinessUnit.Visible = true;

        //    WorkflowModule objWFModule = new WorkflowModule();
        //    foreach (WorkflowBU objWFRole in objWorkflow.arrWorkflowBusinessUnit)
        //    {
        //        WorkflowModuleBU objWorkflowModuleBU = new WorkflowModuleBU();
        //        objWorkflowModuleBU.objWorkflowBU = objWFRole;
        //        objWorkflowModuleBU.BusinessUnitCode = objWFRole.BusinessUnitCode;
        //        objWorkflowModuleBU.WorkflowBUCode = objWFRole.IntCode;
        //        BusinessUnit objBusinessUnit = new BusinessUnit();
        //        objBusinessUnit.IntCode = objWFRole.BusinessUnitCode;
        //        objBusinessUnit.Fetch();
        //        objWorkflowModuleBU.BusinessUnitName = objBusinessUnit.BusinessUnitName;
        //        objWFModule.arrWrkflwModBU.Add(objWorkflowModuleBU);

        //        foreach (WorkflowBURole objBU in objWFRole.arrWorkflowBusinessUnitRole)
        //        {
        //            WorkflowModuleBURole objWorkflowModuleBURole = new WorkflowModuleBURole();
        //            objWorkflowModuleBURole.objWorkflowBURole = objBU;
        //            objWorkflowModuleBURole.WorkflowBURoleCode = objBU.IntCode;
        //            objWorkflowModuleBURole.SecurityGroupCode = objBU.SecurityGroupCode;
        //            objWorkflowModuleBURole.GroupLevel = Convert.ToString(objBU.GroupLevel);
        //            objWorkflowModuleBURole.groupName = objBU.objSecurityGroup.securitygroupname;
        //            objWorkflowModuleBU.arrWorkflowModuleBURole.Add(objWorkflowModuleBURole);
        //        }
        //        arrWorkflowBU.Add(objWorkflowModuleBU);
        //    }

        //    gvWorkflowBusinessUnit.DataSource = objWFModule.arrWrkflwModBU;
        //    gvWorkflowBusinessUnit.DataBind();

        //    foreach (GridViewRow gvRow in gvWorkflowBusinessUnit.Rows)
        //    {
        //        GridView gvWorkflowBusinessUnitRole = (GridView)gvRow.FindControl("gvWorkflowBusinessUnitRole");
        //        Label lblBusinessUnitCode = (Label)gvRow.FindControl("lblBusinessUnitCode");
        //        if (gvWorkflowBusinessUnitRole != null)
        //        {
        //            WorkflowModuleBU objWorkflowModuleBU = (WorkflowModuleBU)(from WorkflowModuleBU obj in objWFModule.arrWrkflwModBU
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
        //    if (objWFModule.arrWrkflwModBU.Count > 0)
        //        btnAssign.Visible = true;
        //    else
        //        btnAssign.Visible = false;

        //    btnAssign.Visible = true;
        //}
    }
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
        WorkflowModule objWorkflowModule = new WorkflowModule();
        objWorkflowModule.IntCode = recCode;
        objWorkflowModule.FetchDeep();
        Session["ObjWorkflowModule"] = objWorkflowModule;

        //if (mode == "EDIT")
        //{
        //    string filter = "and can_workflow_assign='Y' and module_code not in(select module_code from Workflow_Module where module_code<>" + objWorkflowModule.objSysModule.IntCode + ") order by module_name asc";
        //    DBUtil.BindDropDownList(ref ddlModuleName, new SystemModule(), filter, "moduleName", "IntCode", true, "");
        //    ddlModuleName.SelectedValue = objWorkflowModule.objSysModule.IntCode.ToString();
        //    ddlWorkflowName.SelectedValue = objWorkflowModule.objWorkflow.IntCode.ToString();
        //    txtEffStartDate.Text = objWorkflowModule.effStartDate;
        //    txtIdealPrcDays.Text = objWorkflowModule.idealProcessDays.ToString();
        //    gvAssignWrkFlw.DataSource = objWorkflowModule.arrWrkflwModRole;
        //    gvAssignWrkFlw.DataBind();
        //}

        if (mode == "EDIT")
        {
            //string filter = "and can_workflow_assign='Y' and module_code not in(select module_code from Workflow_Module where module_code<>" + objWorkflowModule.objSysModule.IntCode + ") order by module_name asc";
            //DBUtil.BindDropDownList(ref ddlModuleName, new SystemModule(), filter, "moduleName", "IntCode", true, "");
            //ddlModuleName.SelectedValue = objWorkflowModule.objSysModule.IntCode.ToString();            

            ddlModuleName.Attributes.Add("style", "display:none");
            spModuleName.Visible = false;
            lblDisModuleName.Text = objWorkflowModule.objSysModule.moduleName;
            ddlWorkflowName.SelectedValue = objWorkflowModule.objWorkflow.IntCode.ToString();
            txtEffStartDate.Text = objWorkflowModule.effStartDate;
            //txtIdealPrcDays.Text = objWorkflowModule.idealProcessDays.ToString();
            // lblIdealPrcDays.Text = objWorkflowModule.idealProcessDays.ToString();
            gvAssignWrkFlw.DataSource = objWorkflowModule.arrWrkflwModRole;
            gvAssignWrkFlw.DataBind();
        }

        if (mode == "UPGRADE")
        {
            lblBusinessUnitNew.Visible = true;
            ddlBusinessUnit.Visible = false;
            Span1.Visible = false;
            rfvBusinessUnit.Enabled = false;
            rfvWorkflowName.Enabled = false;

            BusinessUnit objBU = new BusinessUnit();
            objBU.IntCode = objWorkflowModule.objWorkflow.Business_Unit_Code;
            lblBusinessCode.Text = Convert.ToString(objWorkflowModule.objWorkflow.Business_Unit_Code);
            objBU.Fetch();

            lblBusinessUnitNew.Text = objBU.BusinessUnitName;
            ddlModuleName.Attributes.Add("style", "display:none");
            ddlWorkflowName.Attributes.Add("style", "display:none");
            spModuleName.Visible = false;
            spWrkflwName.Visible = false;
            lblDisModuleName.Text = objWorkflowModule.objSysModule.moduleName;
            lblDisWrkflwName.Text = objWorkflowModule.objWorkflow.workflowName;
            string filter = "and workflow_code<> " + objWorkflowModule.objWorkflow.IntCode + " and Workflow_Code in ( "
                            + " select Workflow_Code from Workflow where Business_Unit_Code = " + objWorkflowModule.objWorkflow.Business_Unit_Code + ") ";

            // DBUtil.BindDropDownList(ref ddlNewWrkflwName, new Workflow(), "and workflow_code<>" + objWorkflowModule.objWorkflow.IntCode, "workflowName", "IntCode", true, "");
            DBUtil.BindDropDownList(ref ddlNewWrkflwName, new Workflow(), filter, "workflowName", "IntCode", true, "");
            //  lblIdealPrcDays.Text = objWorkflowModule.idealProcessDays.ToString();
            txtEffStartDate.Text = Convert.ToDateTime(GlobalUtil.MakedateFormat(objWorkflowModule.effStartDate)).AddDays(1).ToString("dd/MM/yyyy");
            btnAssign.Visible = true;
        }
    }
    private void ReleaseRecord()
    {
        WorkflowModule objWrkFlwModule = new WorkflowModule();
        objWrkFlwModule.IntCode = recCode;
        StopTimer();
        objWrkFlwModule.unlockRecord();
        hdnId.Value = "";
    }

    private void StopTimer()
    {
        string strMsg = "ReleaseLock();";
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertKey", strMsg, true);
    }
    private void SetVisibility()
    {
        lblWrkflwName.Text = "Workflow Name";
        trWrkflwName.Attributes.Add("style", "display:none");

        if (mode != "EDIT")
        {
            // trWrkflw.Attributes.Add("style", "display:none");
            // trIdealPrsDays.Attributes.Add("style", "display:none");
        }
    }
    private void BindViewGrid()
    {
        int recId = Convert.ToInt32(Request.QueryString["RecCode"]);
        WorkflowModule objWrkflwMod = new WorkflowModule();
        Criteria objCr = new Criteria();
        objCr.ClassRef = objWrkflwMod;
        objCr.IsSubClassRequired = true;
        ArrayList arr = objCr.Execute("and module_code=(select module_code from workflow_module where workflow_module_code = "
            + recId + ") and workflow_module_code<>" + recId + " and Business_Unit_Code=" + businessUnitCode);
        gvWrkflwModView.DataSource = arr;
        gvWrkflwModView.DataBind();
    }
    private object GetTableDls(int moduleCode)
    {
        ModuleValidation objModVal = new ModuleValidation();
        Criteria objCr = new Criteria();
        objCr.ClassRef = objModVal;
        ArrayList arrModVal = objCr.Execute("and module_code=" + moduleCode);

        if (arrModVal.Count > 0)
        {
            objModVal = (ModuleValidation)arrModVal[0];
            return objModVal;
        }
        else
            return null;
    }
    private string GetDateInStr(int moduleCode, int businessUnitCode)
    {
        string strSql = "";
        string res = ""; ;

        //if (mode != "ASSIGN")
        //{
        //strSql = "select isnull(Convert(varchar,max(entry_date),103),'') from Module_Workflow_Detail where module_code=" + moduleCode; //Commented by priti
        strSql = "select isnull(Convert(varchar,max(entry_date),103),'') from Module_Workflow_Detail where module_code=" + moduleCode + " and Module_Code in (select Module_Code from Workflow_Module where Business_Unit_Code = " + businessUnitCode + ")";
        res = Convert.ToString((new WorkflowModuleBroker()).ProcessScalar(strSql));
        //}
        //if (res == "")
        //{
        //    object objTemp = GetTableDls(moduleCode);
        //    if (objTemp != null)
        //    {
        //        ModuleValidation objModVal = (ModuleValidation)objTemp;
        //        strSql = "select isnull(Convert(varchar,max(" + objModVal.dateColName + "),103),'') from " + objModVal.tableName;
        //        res = Convert.ToString((new WorkflowModuleBroker()).ProcessScalar(strSql));
        //    }
        //}
        return res;
    }
    private DateTime GetDate(string strDate)
    {
        return Convert.ToDateTime(GlobalUtil.MakedateFormat(strDate));
    }
    //private string GetDateRange(string currDate, int moduleCode)
    private string GetDateRange(int moduleCode, string effStartDate)
    {
        string dateRangeMsg = "";
        string strSql1 = "select isnull(Convert(varchar,min(entry_date),103),'') from Module_Workflow_Detail where module_code=" + moduleCode;
        string res1 = Convert.ToString((new WorkflowModuleBroker()).ProcessScalar(strSql1));
        object objTemp = GetTableDls(moduleCode);
        string res2 = "";

        if (objTemp != null)
        {
            ModuleValidation objModVal = (ModuleValidation)objTemp;
            string filter = "";

            if (res1 != "")
                filter = " where " + objModVal.primaryColName + " not in (select record_code from Module_Workflow_Detail where module_code=" + moduleCode + ")";

            string strSql2 = "select isnull(Convert(varchar,max(" + objModVal.dateColName + "),103),'') from " + objModVal.tableName + " " + filter;
            res2 = Convert.ToString((new WorkflowModuleBroker()).ProcessScalar(strSql2));
        }

        if ((res1 == "") && (res2 == ""))
        {
            return dateRangeMsg;
        }
        else if ((res1 != "") && (res2 == ""))
        {
            if (DateTime.Compare(Convert.ToDateTime(GlobalUtil.MakedateFormat(res1)), Convert.ToDateTime(GlobalUtil.MakedateFormat(effStartDate))) < 0)
            {
                dateRangeMsg = "should be less than or equal to " + res1;
                return dateRangeMsg;
            }
        }
        else if ((res1 == "") && (res2 != ""))
        {
            if (DateTime.Compare(Convert.ToDateTime(GlobalUtil.MakedateFormat(effStartDate)), Convert.ToDateTime(GlobalUtil.MakedateFormat(res2))) <= 0)
            {
                dateRangeMsg = "should be greater than " + res2;
                return dateRangeMsg;
            }
        }

        if ((res1 != "") && (res2 != ""))
        {
            if (DateTime.Compare(Convert.ToDateTime(GlobalUtil.MakedateFormat(res2)), Convert.ToDateTime(GlobalUtil.MakedateFormat(effStartDate))) >= 0 || DateTime.Compare(Convert.ToDateTime(GlobalUtil.MakedateFormat(effStartDate)), Convert.ToDateTime(GlobalUtil.MakedateFormat(res1))) > 0)
                dateRangeMsg = "should be greater than " + res2 + " and should be less than or equal to " + res1;

            return dateRangeMsg;
        }

        return dateRangeMsg;
    }
    private string GetDateOnUpgrade(int moduleCode, string effStartDate)
    {
        string dateMsg = "";
        string strSql = "select isnull(Convert(varchar,max(entry_date),103),'') from Module_Workflow_Detail where module_code=" + moduleCode;
        string resDate = Convert.ToString((new WorkflowModuleBroker()).ProcessScalar(strSql));

        if (resDate != "")
        {
            if (DateTime.Compare(Convert.ToDateTime(GlobalUtil.MakedateFormat(resDate)), Convert.ToDateTime(GlobalUtil.MakedateFormat(effStartDate))) >= 0)
            {
                dateMsg = "should be greater than " + resDate;
                return dateMsg;
            }
        }
        return dateMsg;
    }

    #endregion

    #region Business Unit code added by Priti
    //private void BindWorkflowBusinessUnitGrid()
    //{
    //    Criteria objCrt = new Criteria();
    //    objCrt.ClassRef = new BusinessUnit();

    //    ArrayList arrCount = new ArrayList();
    //    arrCount = objCrt.Execute(" and Is_Active = 'Y'");
    //    gvWorkflowBusinessUnit.DataSource = arrCount;
    //    gvWorkflowBusinessUnit.DataBind();
    //}
    //private void BindBusinessRoleGrid()
    //{
    //    foreach (GridViewRow gvRow in gvWorkflowBusinessUnit.Rows)
    //    {
    //        GridView gvWorkflowBusinessUnitRole = (GridView)gvRow.FindControl("gvWorkflowBusinessUnitRole");
    //        Label lblBusinessUnitCode = (Label)gvRow.FindControl("lblBusinessUnitCode");
    //        if (gvWorkflowBusinessUnitRole != null)
    //        {
    //            if (arrWorkflowBU.Count > 0)
    //            {
    //                ArrayList arrTempBuRole = new ArrayList();
    //                WorkflowBU objw = (WorkflowBU)(from WorkflowBU obj in arrWorkflowBU
    //                                               where obj.BusinessUnitCode == Convert.ToInt32(lblBusinessUnitCode.Text)
    //                                               select obj).FirstOrDefault();
    //                if (objw != null)
    //                {
    //                    arrTempBuRole.AddRange(objw.arrWorkflowBusinessUnitRole);
    //                }
    //                else
    //                    gvRow.Visible = false;
    //                gvWorkflowBusinessUnitRole.DataSource = arrTempBuRole;
    //                gvWorkflowBusinessUnitRole.DataBind();
    //                DBUtil.AddDummyRowIfDataSourceEmpty(gvWorkflowBusinessUnitRole, new WorkflowBURole());
    //            }
    //            else
    //            {
    //                ArrayList arrTemp = new ArrayList();
    //                gvWorkflowBusinessUnitRole.DataSource = arrTemp;
    //                gvWorkflowBusinessUnitRole.DataBind();
    //                DBUtil.AddDummyRowIfDataSourceEmpty(gvWorkflowBusinessUnitRole, new WorkflowBURole());
    //            }
    //        }
    //    }
    //}
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
                lblIUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(lblSecGroupCode.Text), 0);
                lblIUserName.Text = lblIUserName.Text.Trim(' ');
                lblIUserName.Text = lblIUserName.Text.Trim(',');
            }
        }
    }

    protected void gvWrkflwModView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit &&
        (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            Label lblBusinessUnitCode = (Label)e.Row.FindControl("lblBusinessUnitCode");
            Label lblBusinessUnit = (Label)e.Row.FindControl("lblBusinessUnit");

            if (lblBusinessUnitCode != null && lblBusinessUnitCode.Text != "0")
            {
                BusinessUnit objBU = new BusinessUnit();
                objBU.IntCode = Convert.ToInt32(lblBusinessUnitCode.Text);
                objBU.Fetch();
                lblBusinessUnit.Text = objBU.BusinessUnitName;
            }
        }
    }
    #endregion

}
