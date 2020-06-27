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

public partial class SystemSetting_ApprovalWorkflowAddEdit : ParentPage
{


    public User objLoginedUser { get; set; }

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
            arrWorkflowBU = new ArrayList();
            BusinessUnit objBusinessUnit = new BusinessUnit();
            objBusinessUnit.OrderByColumnName = "Business_Unit_Name";
            DBUtil.BindDropDownList(ref ddlBusinessUnit, objBusinessUnit, "", "BusinessUnitName", "IntCode", true, "");
            if (mode == "ADD")
            {
                lblAddEdit.Text = "Add " + approvalWorkflow;
                lblSrNo.Text = "New";
                Session["WFGRIDDATA"] = null;
                Session["WFBusinessUnit"] = null;
            }
            else
            {
                lblAddEdit.Text = "Edit " + approvalWorkflow;
                btnSave.Text = "Update";
                
                isUsedInAssignWrkFlw = (new Workflow()).UsedInAssignWrkFlw(recCode);
                if (isUsedInAssignWrkFlw)
                    btnAdd.Visible = false;
                ShowData();
                //rdoType.Enabled = false;
            }
           
            BindGrid();
            txtWrkflwName.Focus();
            SetRemainingChars();
        }
        RegisterJS();
        if (gvWrkflwAddEdit.Rows.Count > 1)
        {
            ddlBusinessUnit.Enabled = false;
        }
        else
        {
            ddlBusinessUnit.Enabled = true;
        }
    }


    protected void gvWrkflwAddEdit_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Save":
                saveRecord(e);
                break;
            default:
                return;
        }
    }
    protected void gvWrkflwAddEdit_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        // Old Code

        //ArrayList arrGridData;
        //arrGridData = (ArrayList)Session["WFGRIDDATA"];
        //WorkflowRole objWrkFlwRole = new WorkflowRole();
        //objWrkFlwRole = (WorkflowRole)arrGridData[e.RowIndex];
        //if ((mode == "EDIT") && (objWrkFlwRole.recStatus == GlobalParams.LINE_ITEM_EXISTING))
        //{            
        //    objWrkFlwRole.recStatus = GlobalParams.LINE_ITEM_DELETED;
        //    arrGridData.RemoveAt(e.RowIndex);
        //    arrGridData.Insert(e.RowIndex, objWrkFlwRole);
        //}            
        //else
        //    arrGridData.RemoveAt(e.RowIndex);
        //CreateMessageAlert(btnAdd, roleLevel + " " + msgDelete);
        //BindGrid();



        ArrayList arrGridData;
        arrGridData = (ArrayList)Session["WFGRIDDATA"];
        if (mode == "EDIT")
        {
            Label lblHdnSecGrp = (Label)gvWrkflwAddEdit.Rows[e.RowIndex].FindControl("lblHdnSecGrp");


            int delIndex = GetActualIndex(Convert.ToInt32(lblHdnSecGrp.Text));

            //WorkflowRole objWrkFlwRole = (WorkflowRole)arrGridData[e.RowIndex];
            WorkflowRole objWrkFlwRole = (WorkflowRole)arrGridData[delIndex];
           // if ((objWrkFlwRole.recStatus == GlobalParams.LINE_ITEM_EXISTING) || (objWrkFlwRole.recStatus == GlobalParams.LINE_ITEM_MODIFIED))
           // {
                objWrkFlwRole.recStatus = GlobalParams.LINE_ITEM_DELETED;
                arrGridData.RemoveAt(delIndex);
                arrGridData.Insert(delIndex, objWrkFlwRole);
                // Session["WFGRIDDATA"] = arrGridData;
            //}
            //else
            //{
                //arrGridData.RemoveAt(delIndex);
            //}
        }
        else
            arrGridData.RemoveAt(e.RowIndex);

        CreateMessageAlert(btnAdd, roleLevel + " " + msgDelete);
        BindGrid();




    }
    protected void gvWrkflwAddEdit_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit && (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            Label lblIUserName = (Label)e.Row.FindControl("lblIUserName");
            Label lblHdnSecGrp = (Label)e.Row.FindControl("lblHdnSecGrp");
           // Label lblBusinessUnitCOde = (Label)e.Row.FindControl("lblBusinessUnitCOde");
            
            if (lblHdnSecGrp != null && lblHdnSecGrp.Text != "")
            {
                Users objUser = new Users();
                //lblIUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(lblHdnSecGrp.Text), Convert.ToInt32(lblBusinessUnitCOde.Text));
                lblIUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(lblHdnSecGrp.Text), Convert.ToInt32(ddlBusinessUnit.SelectedValue));
                lblIUserName.Text = lblIUserName.Text.Trim(' ');
                lblIUserName.Text = lblIUserName.Text.Trim(',');
            }

            Button btnDelete = (Button)e.Row.FindControl("btnDelete");
            Button btnEdit = (Button)e.Row.FindControl("btnEdit");
            if (isUsedInAssignWrkFlw)
            {
                btnDelete.Visible = false;
                btnEdit.Visible = false;
            }
            else
            {
                btnEdit.Attributes.Add("Onclick", "javascript:return canEditRecordAjax(" + hdnEditRecord.ClientID + ")");
                btnDelete.Attributes.Add("Onclick", "javascript:return canEditForDeleteAjax(" + hdnEditRecord.ClientID + ",'" + msgAskDelete + "',this);");
            }
            //if (gvWrkflwAddEdit.Rows.Count > 1)
            //{
            //    ddlBusinessUnit.Enabled = false;
            //}
        }
        if (e.Row.RowState == DataControlRowState.Edit || e.Row.RowState == (DataControlRowState.Edit | DataControlRowState.Alternate))
        {
            DropDownList ddlESecGroup = (DropDownList)e.Row.FindControl("ddlESecGroup");
            //DropDownList ddlEPrimaryUser = (DropDownList)e.Row.FindControl("ddlEPrimaryUser");
            Button btnUpdate = (Button)e.Row.FindControl("btnUpdate");

            ddlESecGroup.Attributes.Add("OnKeyPress", "fnEnterKey('" + btnUpdate.ClientID + "');");
            //ddlEPrimaryUser.Attributes.Add("OnKeyPress", "fnEnterKey('" + btnUpdate.ClientID + "');");

        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            DropDownList ddlFSecGroup = (DropDownList)e.Row.FindControl("ddlFSecGroup");
           // DropDownList ddlFPrimaryUser = (DropDownList)e.Row.FindControl("ddlFPrimaryUser");
            Button btnSave = (Button)e.Row.FindControl("btnSave");

            ddlFSecGroup.Attributes.Add("OnKeyPress", "fnEnterKey('" + btnSave.ClientID + "');");
            //ddlFPrimaryUser.Attributes.Add("OnKeyPress", "fnEnterKey('" + btnSave.ClientID + "');");
        }

    }
    protected void gvWrkflwAddEdit_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvWrkflwAddEdit.EditIndex = e.NewEditIndex;
        BindGrid();
        gvWrkflwAddEdit.FooterRow.Visible = false;

        DropDownList ddlESecGroup = (DropDownList)gvWrkflwAddEdit.Rows[e.NewEditIndex].FindControl("ddlESecGroup");
        //DropDownList ddlEPrimaryUser = (DropDownList)gvWrkflwAddEdit.Rows[e.NewEditIndex].FindControl("ddlEPrimaryUser");
        Label lblEUserName = (Label)gvWrkflwAddEdit.Rows[e.NewEditIndex].FindControl("lblEUserName");

        // Finding actual index where object is

        int editIndex;
        if (mode == "EDIT")
        {
            Label lblHdnESecGrp = (Label)gvWrkflwAddEdit.Rows[e.NewEditIndex].FindControl("lblHdnESecGrp");
            editIndex = GetActualIndex(Convert.ToInt32(lblHdnESecGrp.Text));
        }
        else
        {
            editIndex = e.NewEditIndex;
        }

        // Old code 
        //WorkflowRole objWrkFlwRole = (WorkflowRole)((ArrayList)Session["WFGRIDDATA"])[e.NewEditIndex];
        WorkflowRole objWrkFlwRole = (WorkflowRole)((ArrayList)Session["WFGRIDDATA"])[editIndex];

        string filter = "";
        if ((Session["WFGRIDDATA"] != null) && (((ArrayList)Session["WFGRIDDATA"])).Count > 1)
            filter = GetGroupCodes(objWrkFlwRole.objSecurityGroup.IntCode);
        SecurityGroup objSG = new SecurityGroup();
        objSG.OrderByColumnName = "security_group_name";
        DBUtil.BindDropDownList(ref ddlESecGroup, objSG, filter + " and (is_active='Y' or security_group_code=" + objWrkFlwRole.objSecurityGroup.IntCode + ")  and Security_Group_Code in (select Security_Group_Code from Users where 1=1) ", "securityGroupName", "IntCode", true, "");
        ddlESecGroup.SelectedValue = Convert.ToString(objWrkFlwRole.objSecurityGroup.IntCode);
        //BindUserDropDown(ref ddlEPrimaryUser, Convert.ToInt32(objWrkFlwRole.objSecurityGroup.IntCode), objWrkFlwRole.objPrimaryUser.IntCode);
       // ddlEPrimaryUser.SelectedValue = Convert.ToString(objWrkFlwRole.objPrimaryUser.IntCode);
        Users objUser = new Users();
        lblEUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(ddlESecGroup.SelectedValue), Convert.ToInt32(ddlBusinessUnit.SelectedValue) );
        lblEUserName.Text = lblEUserName.Text.Trim(' ');
        lblEUserName.Text = lblEUserName.Text.Trim(',');

        Button btnUpdate = (Button)gvWrkflwAddEdit.Rows[e.NewEditIndex].FindControl("btnUpdate");
        EnDisAddAndSave(false);
        smAppWfAddEdit.SetFocus(ddlESecGroup);
        hdnEditRecord.Value = "0#" + btnUpdate.ClientID;
    }
    protected void gvWrkflwAddEdit_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        hdnEditRecord.Value = "";
        EnDisAddAndSave(true);
        gvWrkflwAddEdit.EditIndex = -1;
        smAppWfAddEdit.SetFocus(btnAdd);
        BindGrid();
    }
    protected void gvWrkflwAddEdit_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        DropDownList ddlESecGroup = (DropDownList)gvWrkflwAddEdit.Rows[e.RowIndex].FindControl("ddlESecGroup");
        //DropDownList ddlEPrimaryUser = (DropDownList)gvWrkflwAddEdit.Rows[e.RowIndex].FindControl("ddlEPrimaryUser");

        ArrayList arrTemp = new ArrayList();
        arrTemp = (ArrayList)Session["WFGRIDDATA"];

        // Old code
        //WorkflowRole objWrkFlwRole = (WorkflowRole)arrTemp[e.RowIndex];


        int updateIndex;
        if (mode == "EDIT")
        {
            Label lblHdnESecGrp = (Label)gvWrkflwAddEdit.Rows[e.RowIndex].FindControl("lblHdnESecGrp");
            updateIndex = GetActualIndex(Convert.ToInt32(lblHdnESecGrp.Text));
        }
        else
        {
            updateIndex = e.RowIndex;
        }

        // Old code
        //arrTemp.RemoveAt(e.RowIndex);



        WorkflowRole objWrkFlwRole = (WorkflowRole)arrTemp[updateIndex];

        objWrkFlwRole.objSecurityGroup.IntCode = Convert.ToInt32(ddlESecGroup.SelectedValue);
        objWrkFlwRole.groupName = ddlESecGroup.SelectedItem.Text;
        //objWrkFlwRole.objPrimaryUser.IntCode = Convert.ToInt32(ddlEPrimaryUser.SelectedValue);
        //objWrkFlwRole.objPrimaryUser.userName = ddlEPrimaryUser.SelectedItem.Text;
        //objWrkFlwRole.userName = ddlEPrimaryUser.SelectedItem.Text;

        arrTemp.RemoveAt(updateIndex);

        if ((mode == "EDIT") && (objWrkFlwRole.recStatus == GlobalParams.LINE_ITEM_EXISTING))
        {
            objWrkFlwRole.recStatus = GlobalParams.LINE_ITEM_MODIFIED;
        }

        // Old code
        //arrTemp.Insert(e.RowIndex, objWrkFlwRole);
        arrTemp.Insert(updateIndex, objWrkFlwRole);

        CreateMessageAlert(btnAdd, roleLevel + " " + msgUpdate);
        gvWrkflwAddEdit.EditIndex = -1;
        hdnEditRecord.Value = "";
        EnDisAddAndSave(true);
        BindGrid();
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            //if (txtWrkflwName.Text == "")
            //{
            //    CreateMessageAlert(txtWrkflwName, "Please enter Workflow Name");
            //    return;
            //}
            //if (txtDesc.Text == "")
            //{
            //    CreateMessageAlert(txtDesc, "Please enter Description");
            //    return;
            //}
            //if (ddlBusinessUnit.SelectedValue == "0")
            //{
            //    CreateMessageAlert(ddlBusinessUnit, "Please select Business Unit");
            //    return;
            //}

            Workflow objWorkflow = new Workflow();
            if (mode == "EDIT")
            {
                objWorkflow.IntCode = recCode;
                objWorkflow.Fetch();
                objWorkflow.IsDirty = true;
            }
            objWorkflow.workflowName = txtWrkflwName.Text;
            objWorkflow.remarks = txtDesc.Text;
            objWorkflow.Business_Unit_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);
            objWorkflow.Workflow_Type = 'F';
            objWorkflow.LastUpdatedBy = loginUserId;
            //if (rdoType.SelectedValue == "F")
            //{
                objWorkflow.arrWorkflowRole = (ArrayList)Session["WFGRIDDATA"];
            //}
            //else
            //{
            //    objWorkflow.arrWorkflowBusinessUnit = arrWorkflowBU;
            //}
            objWorkflow.IsTransactionRequired = true;
            objWorkflow.IsBeginningOfTrans = true;
            objWorkflow.IsProxy = false;
            objWorkflow.IsEndOfTrans = true;
            string resMsg = objWorkflow.Save();
            hdnEditRecord.Value = "";
            hdnEditRecordBU.Value = "";
            if ((resMsg != GlobalParams.RECORD_ADDED) && (resMsg != GlobalParams.RECORD_UPDATED))
                CreateMessageAlert(txtWrkflwName, resMsg);
            else
            {
                if (mode == "EDIT")
                {
                    ReleaseRecord();
                }
                Session["WFGRIDDATA"] = null;
                arrWorkflowBU = null;
                if (resMsg == GlobalParams.RECORD_ADDED || resMsg == GlobalParams.RECORD_UPDATED || resMsg == "C")
                {
                    if (resMsg == GlobalParams.RECORD_ADDED)
                    {
                        TransferAlertMessage(approvalWorkflow + " " + msgAdd, "ApprovalWorkflow.aspx?pageNo=" + pageNo + "");
                    }
                    else if (resMsg == GlobalParams.RECORD_UPDATED)
                    {
                        TransferAlertMessage(approvalWorkflow + " " + msgUpdate, "ApprovalWorkflow.aspx?pageNo=" + pageNo + "");
                    }
                }
            }
        }
        catch (DuplicateRecordException ex)
        {
            CreateMessageAlert(txtWrkflwName, ex.Message);
            SetRemainingChars();
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        if (mode == "EDIT")
        {
            ReleaseRecord();
        }
        Session["WFGRIDDATA"] = null;
        arrWorkflowBU = null;
        Response.Redirect("ApprovalWorkflow.aspx?resMsg=C&pageNo=" + pageNo);
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        //lblCharMsgWrkflwName.Text = "";
        //lblCharMsgDesc.Text = "";        
        //if (ddlBusinessUnit.SelectedValue == "0")
        //{
        //    CreateMessageAlert(ddlBusinessUnit, "Please select Business Unit");
        //    return;
        //}
        gvWrkflwAddEdit.EditIndex = -1;
        BindGrid();
        gvWrkflwAddEdit.FooterRow.Visible = true;
        DropDownList ddlFSecGroup = (DropDownList)gvWrkflwAddEdit.FooterRow.FindControl("ddlFSecGroup");
        //DropDownList ddlFPrimaryUser = (DropDownList)gvWrkflwAddEdit.FooterRow.FindControl("ddlFPrimaryUser");
        ddlFSecGroup.Items.Clear();
        string filter = "";
        if ((Session["WFGRIDDATA"] != null) && (((ArrayList)Session["WFGRIDDATA"])).Count != 0)
            filter = GetGroupCodes(0);
        SecurityGroup objSG = new SecurityGroup();
        objSG.OrderByColumnName = "security_group_name";
        DBUtil.BindDropDownList(ref ddlFSecGroup, objSG, filter + " and is_active='Y' and Security_Group_Code in (select Security_Group_Code from Users where 1=1)", "securityGroupName", "IntCode", true, "");
       // ddlFPrimaryUser.Items.Insert(0, new ListItem("--Please Select--", "0"));
        EnDisAddAndSave(false);
        smAppWfAddEdit.SetFocus(ddlFSecGroup);
        Button btnSave = (Button)gvWrkflwAddEdit.FooterRow.FindControl("btnSave");
        hdnEditRecord.Value = "0#" + btnSave.ClientID;
        SetRemainingChars();
        //rdoType.Enabled = false;
        //upWorkdlowType.Update();
    }
    protected void ddlFSecGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList ddlFSecGroup = (DropDownList)sender;

        int secGrpCode = Convert.ToInt32(ddlFSecGroup.SelectedValue);
        Label lblFUserName = (Label)gvWrkflwAddEdit.FooterRow.FindControl("lblFUserName");
        Users objUsers = new Users();
        lblFUserName.Text = objUsers.GetUserNameCommaSeperated(secGrpCode, Convert.ToInt32(ddlBusinessUnit.SelectedValue));
        lblFUserName.Text = lblFUserName.Text.Trim(' ');
        lblFUserName.Text = lblFUserName.Text.Trim(',');

        //int secGrpCode = Convert.ToInt32(ddlFSecGroup.SelectedValue);
        //DropDownList ddlFPrimaryUser = (DropDownList)gvWrkflwAddEdit.FooterRow.FindControl("ddlFPrimaryUser");
        //BindUserDropDown(ref ddlFPrimaryUser, secGrpCode, 0);
        //if (ddlFSecGroup.SelectedIndex > 0)
        //{
        //    smAppWfAddEdit.SetFocus(ddlFPrimaryUser);
        //}
        //else
        //{
        //    smAppWfAddEdit.SetFocus(ddlFSecGroup);
        //}
    }
    protected void ddlESecGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        //DropDownList ddlESecGroup = (DropDownList)sender;
        //int secGrpCode = Convert.ToInt32(ddlESecGroup.SelectedValue);
        //DropDownList ddlEPrimaryUser = (DropDownList)gvWrkflwAddEdit.Rows[gvWrkflwAddEdit.EditIndex].FindControl("ddlEPrimaryUser");
        //BindUserDropDown(ref ddlEPrimaryUser, secGrpCode, 0);
        //if (ddlESecGroup.SelectedIndex > 0)
        //{
        //    smAppWfAddEdit.SetFocus(ddlEPrimaryUser);
        //}
        //else
        //{
        //    smAppWfAddEdit.SetFocus(ddlESecGroup);
        //}

        DropDownList ddlESecGroup = (DropDownList)sender;
        int secGrpCode = Convert.ToInt32(ddlESecGroup.SelectedValue);
        Label lblEUserName = (Label)gvWrkflwAddEdit.Rows[gvWrkflwAddEdit.EditIndex].FindControl("lblEUserName");
        Users objUser = new Users();
        lblEUserName.Text = objUser.GetUserNameCommaSeperated(secGrpCode, Convert.ToInt32(ddlBusinessUnit.SelectedValue));
        lblEUserName.Text = lblEUserName.Text.Trim(' ');
        lblEUserName.Text = lblEUserName.Text.Trim(',');
    }

    #endregion

    #region ------- Methods -------

    private void SetRemainingChars()
    {
        lblCharMsgWrkflwName.Text = Convert.ToString(txtWrkflwName.MaxLength - txtWrkflwName.Text.Length) + " character(s) left...";
        lblCharMsgDesc.Text = Convert.ToString(txtDesc.MaxLength - txtDesc.Text.Length) + " character(s) left...";
    }

    private void BindUserDropDown(ref DropDownList ddlPrimaryUser, int grpCode, int userCode)
    {
        Users objUserTemp = new Users();
        objUserTemp.OrderByColumnName = "first_name";
        objUserTemp.OrderByCondition = "ASC";
        DBUtil.BindDropDownList(ref ddlPrimaryUser, objUserTemp, "and (is_active='Y' or users_code=" + userCode + ") and security_group_code=" + grpCode, "userName", "IntCode", true, "");
    }

    private void GetGlobalRes()
    {
        approvalWorkflow = "Approval Workflow";
        roleLevel = "Role Level";
        msgAdd = "added successfully";
        msgUpdate = "updated successfully";
        msgDelete = "deleted successfully";
        msgAskDelete = "Are you sure, you want to delete this record? ";

    }

    private void RegisterJS()
    {
        //btnAdd.Attributes.Add("OnClick", "javascript:return canEditRecordAjax(" + hdnEditRecord.ClientID + ")");
        //btnAdd.Attributes.Add("OnClick", "javascript:return CheckCurrency(" + hdnEditRecord.ClientID + ")");


        btnSave.Attributes.Add("OnClick", "javascript:return canEditRecordAjax(" + hdnEditRecord.ClientID + ")");
        btnCancel.Attributes.Add("OnClick", "javascript:return canEditRecordAjax(" + hdnEditRecord.ClientID + ")");
        
        //txtWrkflwName.Attributes.Add("onkeyup", "countChar('" + txtWrkflwName.ClientID + "','" + lblCharMsgWrkflwName.ClientID + "','" + txtWrkflwName.MaxLength + "');");
        //  txtWrkflwName.Attributes.Add("onpaste", "countChar('" + txtWrkflwName.ClientID + "','" + lblCharMsgWrkflwName.ClientID + "','" + txtWrkflwName.MaxLength + "');");
        //txtCurrency.Attributes.Add("onKeyPress", "doNotAllowTag();fnEnterKey('" + btnAdd.ClientID + "');return canEditRecordAjax(" + hdnEditRecord.ClientID + ")");
        txtWrkflwName.Attributes.Add("onKeyPress", "doNotAllowTag();fnEnterKey('" + (btnAdd.Visible ? btnAdd.ClientID : (btnSave.Visible ? btnSave.ClientID : btnCancel.ClientID)) + "');");

        // txtDesc.Attributes.Add("onkeyup", "countChar('" + txtDesc.ClientID + "','" + lblCharMsgDesc.ClientID + "','" + txtDesc.MaxLength + "');");
        //  txtDesc.Attributes.Add("onpaste", "countChar('" + txtDesc.ClientID + "','" + lblCharMsgDesc.ClientID + "','" + txtDesc.MaxLength + "');");
        //txtCurrency.Attributes.Add("onKeyPress", "doNotAllowTag();fnEnterKey('" + btnAdd.ClientID + "');return canEditRecordAjax(" + hdnEditRecord.ClientID + ")");
        txtDesc.Attributes.Add("onKeyPress", "doNotAllowTag();fnEnterKey('" + (btnAdd.Visible ? btnAdd.ClientID : (btnSave.Visible ? btnSave.ClientID : btnCancel.ClientID)) + "');");

    }
    private void ShowData()
    {
        Workflow objWorkflow = new Workflow();
        objWorkflow.IntCode = recCode;
        objWorkflow.FetchDeep();
        //if (objWorkflow.Workflow_Type == 'F')
        //{
        //    rdoType.SelectedValue = "F";
            tdFlatWorkflow.Style.Add("display", "block");
            tdBusinessUnitWorkflow.Style.Add("display", "none");
            lblSrNo.Text = srNo;
            txtWrkflwName.Text = objWorkflow.workflowName;
            txtDesc.Text = objWorkflow.remarks;
            if (mode != "ADD")
            {
                ddlBusinessUnit.SelectedValue = Convert.ToString(objWorkflow.Business_Unit_Code);
            }
            //ddlBusinessUnit.SelectedValue = co

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
        //    rdoType.SelectedValue = "B";
        //    tdFlatWorkflow.Style.Add("display", "none");
        //    tdBusinessUnitWorkflow.Style.Add("display", "block");
        //    lblSrNo.Text = srNo;
        //    txtWrkflwName.Text = objWorkflow.workflowName;
        //    txtDesc.Text = objWorkflow.remarks;

            
        //    ArrayList arrTemp = new ArrayList();

        //    // Updating record status flag of workflow role

        //    foreach (WorkflowBU obj in objWorkflow.arrWorkflowBusinessUnit)
        //    {
        //        arrTemp.Add(obj);
        //    }
           
        //    arrWorkflowBU = arrTemp;
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
        //if (arrTemp.Count > 0)
        //    rdoType.Enabled = false;
        //else
        //    rdoType.Enabled = true;
        if (arrTemp.Count > 0)
            ddlBusinessUnit.Enabled = false;
        gvWrkflwAddEdit.DataSource = arrTemp;
        gvWrkflwAddEdit.DataBind();
        DBUtil.AddDummyRowIfDataSourceEmpty(gvWrkflwAddEdit, new WorkflowRole());
        
        //if (arrTemp.Count == 0)
        //    btnSave.Visible = false;
        //else
        //    btnSave.Visible = true;
    }
    private void StopTimer()
    {
        string strMsg = "ReleaseLock();";
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertKey", strMsg, true);
    }
    private void saveRecord(GridViewCommandEventArgs e)
    {
        ArrayList arrGridData = returnArray();

        DropDownList ddlFSecGroup = (DropDownList)gvWrkflwAddEdit.FooterRow.FindControl("ddlFSecGroup");
        Label lblFUserName = (Label)gvWrkflwAddEdit.FooterRow.FindControl("lblFUserName");
        if (lblFUserName.Text == "")
        {
            CreateMessageAlert("User(s) cannot be blank.");
            return;
        }

        WorkflowRole objWrkFlwRole = new WorkflowRole();
        objWrkFlwRole.groupLevel = arrGridData.Count + 1;
        objWrkFlwRole.objSecurityGroup.IntCode = Convert.ToInt32(ddlFSecGroup.SelectedValue);
        objWrkFlwRole.groupName = ddlFSecGroup.SelectedItem.Text;
        //objWrkFlwRole.objPrimaryUser.IntCode = Convert.ToInt32(ddlFPrimaryUser.SelectedValue);
        //objWrkFlwRole.objPrimaryUser.userName = ddlFPrimaryUser.SelectedItem.Text;
        //objWrkFlwRole.userName = ddlFPrimaryUser.SelectedItem.Text;

        if (mode == "EDIT")
        {
            objWrkFlwRole.recStatus = GlobalParams.LINE_ITEM_NEWLY_ADDED;
        }

        arrGridData.Add(objWrkFlwRole);
        Session["WFGRIDDATA"] = arrGridData;
        CreateMessageAlert(btnAdd, roleLevel + " " + msgAdd);
        hdnEditRecord.Value = "";
        EnDisAddAndSave(true);
        BindGrid();
    }
    private void ReleaseRecord()
    {
        Workflow objWorkflow = new Workflow();
        objWorkflow.IntCode = recCode;
        StopTimer();
        objWorkflow.unlockRecord();
        hdnId.Value = "";
    }
    private ArrayList returnArray()
    {
        ArrayList arrTemp;
        if ((Session["WFGRIDDATA"] == null) || (((ArrayList)Session["WFGRIDDATA"])).Count == 0)
            arrTemp = new ArrayList();
        else
            arrTemp = (ArrayList)Session["WFGRIDDATA"];

        //if ((Session["WFBusinessUnit"] == null) || (((ArrayList)Session["WFBusinessUnit"])).Count == 0)
        //    arrTemp = new ArrayList();
        //else
        //    arrTemp = (ArrayList)Session["WFBusinessUnit"];

         return arrTemp;
    }
    
    private string GetGroupCodes(int editCode)
    {
        ArrayList arrTemp = new ArrayList();
        WorkflowRole objTemp = new WorkflowRole();
        string strTemp = "and security_group_code not in(";
        if(Session["WFGRIDDATA"] !=null)
            arrTemp = (ArrayList)Session["WFGRIDDATA"];
        else
            arrTemp = (ArrayList)Session["WFBusinessUnit"];
        for (int i = 0; i < arrTemp.Count; i++)
        {
            objTemp = (WorkflowRole)arrTemp[i];
            if (objTemp.recStatus != GlobalParams.LINE_ITEM_DELETED)
            {
                if ((editCode != 0) && (editCode == objTemp.objSecurityGroup.IntCode))
                {
                    //if (i == arrTemp.Count - 1)
                    //    strTemp = strTemp.Substring(0, strTemp.Length - 1) + ")";
                    continue;
                }


                if (i == arrTemp.Count - 1)
                    strTemp = strTemp + objTemp.objSecurityGroup.IntCode.ToString() + ")";
                else
                    strTemp = strTemp + objTemp.objSecurityGroup.IntCode.ToString() + ",";
            }
        }
        if (strTemp == "and security_group_code not in(")
            strTemp = "";
        if (strTemp.EndsWith(","))
            strTemp = strTemp.Substring(0, strTemp.Length - 1) + ")";

        return strTemp;
    }

    private void EnDisAddAndSave(Boolean isEnabled)
    {
        btnAdd.Enabled = isEnabled;
        btnSave.Enabled = isEnabled;
    }

    private int GetActualIndex(int groupCode)
    {
        ArrayList arrTemp = returnArray();
        WorkflowRole objWrkFlwRole = new WorkflowRole();

        for (int i = 0; i < arrTemp.Count; i++)
        {
            objWrkFlwRole = (WorkflowRole)arrTemp[i];
            if ((objWrkFlwRole.objSecurityGroup.IntCode == groupCode) && (objWrkFlwRole.recStatus != GlobalParams.LINE_ITEM_DELETED))
            {
                return i;
            }
        }
        return 0;
    }

    #endregion

    #region Newly added methods for Business Unit-- By Priti

    //private int GetActualIndexBU(int groupCode)
    //{
    //    ArrayList arrTemp = new ArrayList();
    //    arrTemp = arrWorkflowBU;

    //   // WorkflowBURole objWorkflowBURole = new WorkflowBURole();
    //    WorkflowBU objWorkflowBU = new WorkflowBU();

    //    for (int i = 0; i < arrTemp.Count; i++)
    //    {
    //        objWorkflowBU = (WorkflowBU)arrTemp[i];
    //        for (int j = 0; j < objWorkflowBU.arrWorkflowBusinessUnitRole.Count; j++)
    //        {
    //            WorkflowBURole objWorkflowBURole = new WorkflowBURole();
    //            objWorkflowBURole = (WorkflowBURole)objWorkflowBU.arrWorkflowBusinessUnitRole[j];
    //            if ((objWorkflowBURole.objSecurityGroup.IntCode == groupCode)) //&& (objWrkFlwRole.recStatus != GlobalParams.LINE_ITEM_DELETED)
    //            {
    //                return j;
    //            }
    //        }
    //        //foreach (WorkflowBURole objWorkflowBURole in objWorkflowBU.arrWorkflowBusinessUnitRole)
    //        //{
    //        //    if ((objWorkflowBURole.objSecurityGroup.IntCode == groupCode)) //&& (objWrkFlwRole.recStatus != GlobalParams.LINE_ITEM_DELETED)
    //        //    {
    //        //        return i;
    //        //    }
    //        //}
    //    }
    //    return 0;
    //}

    //private string GetGroupCodesBU(int editCode, int BusinessUnitCode)
    //{
    //    ArrayList arrTemp = new ArrayList();
    //    arrTemp.AddRange(arrWorkflowBU);

    //    WorkflowBU objTemp = new WorkflowBU();
    //    string strTemp = "and security_group_code not in(";
       
    //    for (int i = 0; i < arrTemp.Count; i++)
    //    {
    //        objTemp = (WorkflowBU)arrTemp[i];
    //        foreach (WorkflowBURole objw in objTemp.arrWorkflowBusinessUnitRole)
    //        {
    //            if (objw.BusinessUnitCode == BusinessUnitCode)
    //            {
    //                if (objw.recordStatus != "D")
    //                {
    //                    if ((editCode != 0) && (editCode == objw.objSecurityGroup.IntCode))
    //                    {
    //                        continue;
    //                    }
    //                    //if (i == objTemp.arrWorkflowBusinessUnitRole.Count - 1)
    //                    //    strTemp = strTemp + objw.objSecurityGroup.IntCode.ToString() + ")";
    //                    //else
    //                        strTemp = strTemp + objw.objSecurityGroup.IntCode.ToString() + ",";
    //                }
    //            }
    //        }
    //    }
    //    if (strTemp == "and security_group_code not in(")
    //        strTemp = "";
    //    if (strTemp.EndsWith(","))
    //        strTemp = strTemp.Substring(0, strTemp.Length - 1) + ")";
    //    if (strTemp.EndsWith(")"))
    //        strTemp = strTemp.Substring(0, strTemp.Length - 1) + ")";

    //    return strTemp;
    //}
    protected void rdoType_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (rdoType.SelectedValue != "F")
        //{
        //    tdFlatWorkflow.Style.Add("display", "none");
        //    tdBusinessUnitWorkflow.Style.Add("display", "block");
        //    BindWorkflowBusinessUnitGrid();
        //    BindWorkflowBusinessUnitRoleGrid(0, "Edit");
        //}
        //else
        //{
        //    tdFlatWorkflow.Style.Add("display", "block");
        //    tdBusinessUnitWorkflow.Style.Add("display", "none");
        //}
    }

    private void BindWorkflowBusinessUnitGrid()
    {
        //Criteria objCrt = new Criteria();
        //objCrt.ClassRef = new BusinessUnit();

        //ArrayList arrCount = new ArrayList();
        //arrCount = objCrt.Execute(" and Is_Active = 'Y'");
        //gvWorkflowBusinessUnit.DataSource = arrCount;
        //gvWorkflowBusinessUnit.DataBind();
    }

    private void BindWorkflowBusinessUnitRoleGrid(int Index, string status)
    {
        //if (status == "Edit")
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
        //                    foreach (WorkflowBURole objWorkBUrole in objw.arrWorkflowBusinessUnitRole)
        //                    {
        //                        objWorkBUrole.BusinessUnitCode = Convert.ToInt32(lblBusinessUnitCode.Text);
        //                    }
        //                    arrTempBuRole.AddRange(objw.arrWorkflowBusinessUnitRole);
        //                }
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
        //else
        //{
        //    GridView gvWorkflowBusinessUnitRole = null;
        //    if (Index == 0 || Index == -1)
        //        gvWorkflowBusinessUnitRole = (GridView)gvWorkflowBusinessUnit.Rows[Convert.ToInt32(hdnWorkFlowBURow.Value)].FindControl("gvWorkflowBusinessUnitRole");
        //    else
        //    {
        //        //gvWorkflowBusinessUnitRole = (GridView)gvWorkflowBusinessUnit.Rows[Index].FindControl("gvWorkflowBusinessUnitRole");
        //        gvWorkflowBusinessUnitRole = (GridView)gvWorkflowBusinessUnit.Rows[Convert.ToInt32(hdnWorkFlowBURow.Value)].FindControl("gvWorkflowBusinessUnitRole");
        //    }

        //    if (arrWorkflowBU.Count > 0)
        //    {
        //        ArrayList arrTempBuRole = new ArrayList();

        //        //arrTempBuRole = (ArrayList)(from WorkflowBU obj in arrWorkflowBU
        //        //                            where obj.BusinessUnitCode == Convert.ToInt32(hdnBusinessUnitCode.Value)
        //        //                            select obj.arrWorkflowBusinessUnitRole);

        //        WorkflowBU objw = (WorkflowBU)(from WorkflowBU obj in arrWorkflowBU
        //                                       where obj.BusinessUnitCode == Convert.ToInt32(hdnBusinessUnitCode.Value)
        //                                       select obj).FirstOrDefault();
        //        if (objw != null)
        //        {
        //            arrTempBuRole.AddRange(objw.arrWorkflowBusinessUnitRole);
        //        }
        //        rdoType.Enabled = false;
        //        gvWorkflowBusinessUnitRole.DataSource = arrTempBuRole;
        //        gvWorkflowBusinessUnitRole.DataBind();
        //        DBUtil.AddDummyRowIfDataSourceEmpty(gvWorkflowBusinessUnitRole, new WorkflowBURole());
        //    }
        //    else
        //    {
        //        ArrayList arrTemp = new ArrayList();
        //        gvWorkflowBusinessUnitRole.DataSource = arrTemp;
        //        gvWorkflowBusinessUnitRole.DataBind();
        //        DBUtil.AddDummyRowIfDataSourceEmpty(gvWorkflowBusinessUnitRole, new WorkflowBURole());
        //    }
        //}
    }

    private void BindWorkflowBusinessUnitRoleGridEmpty()
    {
        //ArrayList arrTemp = new ArrayList();
        ////GridView gvWorkflowBusinessUnitRole = (GridView)gvWorkflowBusinessUnit.Rows[Convert.ToInt32(hdnWorkFlowBURow.Value)].FindControl("gvWorkflowBusinessUnitRole");
        //gvWorkflowBusinessUnit.DataSource = arrTemp;
        //gvWorkflowBusinessUnit.DataBind();
        //DBUtil.AddDummyRowIfDataSourceEmpty(gvWorkflowBusinessUnit, new WorkflowBU());
    }
    protected void ddlFSecGroupBU_SelectedIndexChanged(object sender, EventArgs e)
    {
        //DropDownList ddlFSecGroup = (DropDownList)sender;
        //GridView gvWorkflowBusinessUnitRole = (GridView)((DropDownList)sender).Parent.Parent.Parent.Parent;

        //int secGrpCode = Convert.ToInt32(ddlFSecGroup.SelectedValue);
        //Label lblFUserName = (Label)gvWorkflowBusinessUnitRole.FooterRow.FindControl("lblFUserName");
        //Users objUsers = new Users();
        //lblFUserName.Text = objUsers.GetUserNameCommaSeperated(secGrpCode);
        //lblFUserName.Text = lblFUserName.Text.Trim(' ');
        //lblFUserName.Text = lblFUserName.Text.Trim(',');
    }
    protected void SaveWorkflowBusinessUnitRole(GridViewCommandEventArgs e, GridViewRow gv)
    {
       // DropDownList ddlFSecGroup = (DropDownList)gv.FindControl("ddlFSecGroup");
       // WorkflowBURole objWorkflowBURole = new WorkflowBURole();

       // //var r = (from WorkflowBURole objw in ObjWorkflowBU.arrWorkflowBusinessUnitRole
       // //         where objw.BusinessUnitCode == Convert.ToInt32(hdnBusinessUnitCode.Value)
       // //         select objw
       // //                                           ).ToList();

       // WorkflowBU objWorkflowBU = (WorkflowBU)(from WorkflowBU obj in arrWorkflowBU
       //                                         where obj.BusinessUnitCode == Convert.ToInt32(hdnBusinessUnitCode.Value)
       //                                         select obj).FirstOrDefault();
       // if (objWorkflowBU == null)
       // {
       //     objWorkflowBU = new WorkflowBU();
       // }

       //// WorkflowBU objWorkflowBU = new WorkflowBU();
       // objWorkflowBU.BusinessUnitCode = Convert.ToInt32(hdnBusinessUnitCode.Value);
       // int cnt = 0;
       // if (objWorkflowBU != null)
       // {
       //     cnt = objWorkflowBU.arrWorkflowBusinessUnitRole.Count;
       //     if (cnt > 1)
       //     {

       //     }
       // }

       // objWorkflowBURole.GroupLevel = cnt + 1;
       // objWorkflowBURole.SecurityGroupCode = Convert.ToInt32(ddlFSecGroup.SelectedValue);
       // objWorkflowBURole.objSecurityGroup.IntCode = Convert.ToInt32(ddlFSecGroup.SelectedValue);
       // objWorkflowBURole.groupName = ddlFSecGroup.SelectedItem.Text;
       // objWorkflowBURole.BusinessUnitCode = Convert.ToInt32(hdnBusinessUnitCode.Value);
       // objWorkflowBU.arrWorkflowBusinessUnitRole.Add(objWorkflowBURole);
       // //ObjWorkflowBU.arrWorkflowBusinessUnitRole.Add(objWorkflowBURole);
       // if (objWorkflowBURole.GroupLevel == 1)
       // {
       //     arrWorkflowBU.Add(objWorkflowBU);
       // }
       // BindWorkflowBusinessUnitRoleGrid(0,"");
    }

    protected void ddlESecGroupBU_SelectedIndexChanged(object sender, EventArgs e)
    {
        //DropDownList ddlESecGroup = (DropDownList)sender;
        //GridView gvWorkflowBusinessUnitRole = (GridView)((DropDownList)sender).Parent.Parent.Parent.Parent;

        //int secGrpCode = Convert.ToInt32(ddlESecGroup.SelectedValue);
        //Label lblEUserName = (Label)gvWorkflowBusinessUnitRole.Rows[gvWorkflowBusinessUnitRole.EditIndex].FindControl("lblEUserName");

        //Users objUser = new Users();
        //lblEUserName.Text = objUser.GetUserNameCommaSeperated(secGrpCode);
        //lblEUserName.Text = lblEUserName.Text.Trim(' ');
        //lblEUserName.Text = lblEUserName.Text.Trim(',');
    }

    private void DisableButtonsOnBU(Boolean isEnabled, Button btn)
    {
       // btn.Enabled = isEnabled;
       //// btnSave.Enabled = isEnabled;
    }
    #region GridView Events
    protected void gvWorkflowBusinessUnit_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit &&
        (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            //GridView gvWorkflowBusinessUnitRole = (GridView)e.Row.FindControl("gvWorkflowBusinessUnitRole");
            //gvWorkflowBusinessUnitRole.DataBind();
        }
    }
    protected void gvWorkflowBusinessUnit_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        //if (e.CommandName == "AddBusinessUnit")
        //{
        //   // rdoType.Enabled = false;
        //   // upWorkdlowType.Update();
        //    int BusinessUnitCode = Convert.ToInt32(e.CommandArgument);
        //    hdnBusinessUnitCode.Value = Convert.ToString(e.CommandArgument);
        //    string isNew = "";

        //    GridViewRow row = (GridViewRow)(((Button)e.CommandSource).NamingContainer);
        //    hdnWorkFlowBURow.Value = Convert.ToString(row.RowIndex);
        //    GridView gvWorkflowBusinessUnitRole = (GridView)gvWorkflowBusinessUnit.Rows[Convert.ToInt32(hdnWorkFlowBURow.Value)].FindControl("gvWorkflowBusinessUnitRole");
        //    gvWorkflowBusinessUnitRole.EditIndex = -1;
        //    if (isNew == "Y")
        //    {
        //        ArrayList arrTemp = new ArrayList();
        //        //GridView gvWorkflowBusinessUnitRole = (GridView)gvWorkflowBusinessUnit.Rows[Convert.ToInt32(hdnWorkFlowBURow.Value)].FindControl("gvWorkflowBusinessUnitRole");
        //        gvWorkflowBusinessUnitRole.DataSource = arrTemp;
        //        gvWorkflowBusinessUnitRole.DataBind();
        //        DBUtil.AddDummyRowIfDataSourceEmpty(gvWorkflowBusinessUnitRole, new WorkflowBURole());
        //    }
        //    else
        //        BindWorkflowBusinessUnitRoleGrid(0,"");
        //    gvWorkflowBusinessUnitRole.FooterRow.Visible = true;

        //    DropDownList ddlFSecGroup = (DropDownList)gvWorkflowBusinessUnitRole.FooterRow.FindControl("ddlFSecGroup");
        //    ddlFSecGroup.Items.Clear();
        //    string filter = "";
        //    //if ((Session["WFBusinessUnit"] != null) && (((ArrayList)Session["WFBusinessUnit"])).Count != 0)
        //    //    filter = GetGroupCodes(0);

        //    if (arrWorkflowBU.Count != 0)
        //        filter = GetGroupCodesBU(0, BusinessUnitCode);
        //    SecurityGroup objSecurityGroup = new SecurityGroup();
        //    objSecurityGroup.OrderByColumnName = "security_group_name";
        //    DBUtil.BindDropDownList(ref ddlFSecGroup, objSecurityGroup, filter + " and Security_Group_Code in (select Security_Group_Code from Users where 1=1) " , "securitygroupname", "IntCode", true, "");

        //   // GridView gvWorkflowBusinessUnit = (GridView)sender;
        //    foreach (GridViewRow gvRow in gvWorkflowBusinessUnit.Rows)
        //    {
        //        Button btnBusinessUnitAdd = (Button)gvRow.FindControl("btnBusinessUnitAdd");
        //        DisableButtonsOnBU(false, btnBusinessUnitAdd);
        //    }
        //    Button btnSave = (Button)gvWorkflowBusinessUnitRole.FooterRow.FindControl("btnSave");
        //    hdnEditRecordBU.Value = "0#" + btnSave.ClientID;
        //}
    }
    protected void gvWorkflowBusinessUnitRole_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit &&
         (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            //Button btnDelete = (Button)e.Row.FindControl("btnDelete");
            //Button btnEdit = (Button)e.Row.FindControl("btnEdit");
            //if (isUsedInAssignWrkFlw)
            //{
            //    btnDelete.Visible = false;
            //    btnEdit.Visible = false;
            //}
            //else
            //{
            //    btnEdit.Attributes.Add("Onclick", "javascript:return canEditRecordAjax(" + hdnEditRecordBU.ClientID + ")");
            //    btnDelete.Attributes.Add("Onclick", "javascript:return canEditForDeleteAjax(" + hdnEditRecordBU.ClientID + ",'" + msgAskDelete + "',this);");
            //}

            //Label lblIUserName = (Label)e.Row.FindControl("lblIUserName");
            //Label lblSecGroupCode = (Label)e.Row.FindControl("lblSecGroupCode");
            //if (lblSecGroupCode != null && lblSecGroupCode.Text != "")
            //{
            //    Users objUser = new Users();
            //    lblIUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(lblSecGroupCode.Text));
            //    lblIUserName.Text = lblIUserName.Text.Trim(' ');
            //    lblIUserName.Text = lblIUserName.Text.Trim(',');
            //}
        }
    }
    protected void gvWorkflowBusinessUnitRole_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        //if (e.CommandName == "Save")
        //{
        //    Control ctl = e.CommandSource as Control;
        //    GridViewRow CurrentRow = ctl.NamingContainer as GridViewRow;
        //    SaveWorkflowBusinessUnitRole(e, CurrentRow);
        //    hdnEditRecordBU.Value = "";
        //    foreach (GridViewRow gvRow in gvWorkflowBusinessUnit.Rows)
        //    {
        //        Button btnBusinessUnitAdd = (Button)gvRow.FindControl("btnBusinessUnitAdd");
        //        DisableButtonsOnBU(true, btnBusinessUnitAdd);
        //    }
        //}
    }

    protected void gvWorkflowBusinessUnitRole_OnRowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        //GridView gvWorkflowBusinessUnitRole = (GridView)sender;
        //Button btnDelete = (Button)gvWorkflowBusinessUnitRole.Rows[e.RowIndex].FindControl("btnDelete");
        //int code = Convert.ToInt32(btnDelete.CommandArgument);
        //hdnBusinessUnitCode.Value = Convert.ToString(code);

        // WorkflowBU objw = (WorkflowBU)(from WorkflowBU obj in arrWorkflowBU
        //                               where obj.BusinessUnitCode == Convert.ToInt32(hdnBusinessUnitCode.Value)
        //                               select obj).FirstOrDefault();

        // if (objw != null)
        // {
        //     objw.arrWorkflowBusinessUnitRole_Del.Add(objw.arrWorkflowBusinessUnitRole[e.RowIndex]);

        //     int groupLevelTemp = 1;
        //     WorkflowBURole obj = (WorkflowBURole)objw.arrWorkflowBusinessUnitRole[e.RowIndex];
        //     obj.recordStatus = "D";

        //     objw.arrWorkflowBusinessUnitRole.RemoveAt(e.RowIndex);

        //     ArrayList objArrFinal = new ArrayList();
        //     objArrFinal.AddRange(objw.arrWorkflowBusinessUnitRole_Del);
        //     objArrFinal.AddRange(objw.arrWorkflowBusinessUnitRole);

        //     foreach (WorkflowBURole objrole in objArrFinal)
        //     {
        //         if (objrole.recordStatus == "D")
        //             continue;
        //         objrole.GroupLevel = groupLevelTemp;
        //         groupLevelTemp = groupLevelTemp + 1;
        //     }


        //     hdnEditRecordBU.Value = "";
             
        //     if (objw.arrWorkflowBusinessUnitRole.Count > 0)
        //     {
        //        // BindWorkflowBusinessUnitRoleGrid(e.RowIndex, "");
                
        //         gvWorkflowBusinessUnitRole.DataSource = objw.arrWorkflowBusinessUnitRole; ;
        //         gvWorkflowBusinessUnitRole.DataBind();
        //     }
        //     else
        //     {
        //         ArrayList arrTemp = new ArrayList();
        //         gvWorkflowBusinessUnitRole.DataSource = arrTemp;
        //         gvWorkflowBusinessUnitRole.DataBind();
        //         DBUtil.AddDummyRowIfDataSourceEmpty(gvWorkflowBusinessUnitRole, new WorkflowBURole());
        //     }
        // }
        // string isCheck = "Y";
        // foreach (GridViewRow gvRow in gvWorkflowBusinessUnit.Rows)
        // {
        //     Button btnBusinessUnitAdd = (Button)gvRow.FindControl("btnBusinessUnitAdd");
        //     GridView gvWorkflowBusinessUnitRole1 = (GridView)gvRow.FindControl("gvWorkflowBusinessUnitRole");
        //     DisableButtonsOnBU(true, btnBusinessUnitAdd);
        //     if (gvWorkflowBusinessUnitRole1.Rows.Count > 1)
        //     {
        //         isCheck = "N";
        //     }
        // }
        // if (isCheck == "Y")
        //     rdoType.Enabled = true;
        // else
        //     rdoType.Enabled = false;
    }
    protected void gvWorkflowBusinessUnitRole_RowEditing(object sender, GridViewEditEventArgs e)
    {
       // GridView gvWorkflowBusinessUnitRole = (GridView)sender;
       // gvWorkflowBusinessUnitRole.EditIndex = e.NewEditIndex;
       // Button btnEdit = (Button)gvWorkflowBusinessUnitRole.Rows[e.NewEditIndex].FindControl("btnEdit");
       // int code = Convert.ToInt32(btnEdit.CommandArgument);
       // hdnBusinessUnitCode.Value = Convert.ToString(code);
       //// hdnWorkFlowBURow.Value = Convert.ToString(e.NewEditIndex);

       // BindWorkflowBusinessUnitRoleGrid(e.NewEditIndex,"");
       // gvWorkflowBusinessUnitRole.FooterRow.Visible = false;

       // DropDownList ddlESecGroup = (DropDownList)gvWorkflowBusinessUnitRole.Rows[e.NewEditIndex].FindControl("ddlESecGroup");
       // Label lblEUserName = (Label)gvWorkflowBusinessUnitRole.Rows[e.NewEditIndex].FindControl("lblEUserName");
       // int editIndex;

       // if (mode == "EDIT")
       // {
       //     Label lblHdnESecGrp = (Label)gvWorkflowBusinessUnitRole.Rows[e.NewEditIndex].FindControl("lblHdnESecGrp");
       //     editIndex = GetActualIndexBU(Convert.ToInt32(lblHdnESecGrp.Text));
       // }
       // else
       // {
       //     editIndex = e.NewEditIndex;
       // }

       // //ArrayList arrWorkflowBURole = ObjWorkflowBU.arrWorkflowBusinessUnitRole;

       // WorkflowBU objw = (WorkflowBU)(from WorkflowBU obj in arrWorkflowBU
       //                                where obj.BusinessUnitCode == Convert.ToInt32(hdnBusinessUnitCode.Value)
       //                                select obj).FirstOrDefault();

       // if (objw != null)
       // {
       //     WorkflowBURole objWorkflowBURole = (WorkflowBURole)objw.arrWorkflowBusinessUnitRole[editIndex];

       //     string filter = "";
       //     filter = GetGroupCodesBU(objWorkflowBURole.objSecurityGroup.IntCode, objw.BusinessUnitCode);

       //     SecurityGroup objSG = new SecurityGroup();
       //     objSG.OrderByColumnName = "Security_Group_Name";
       //     DBUtil.BindDropDownList(ref ddlESecGroup, objSG, filter + " and Security_Group_Code in (select Security_Group_Code from Users where 1=1)" , "securitygroupname", "IntCode", true, "");
       //     ddlESecGroup.SelectedValue = Convert.ToString(objWorkflowBURole.objSecurityGroup.IntCode);

       //     Users objUser = new Users();
       //     lblEUserName.Text = objUser.GetUserNameCommaSeperated(Convert.ToInt32(ddlESecGroup.SelectedValue));
       //     lblEUserName.Text = lblEUserName.Text.Trim(' ');
       //     lblEUserName.Text = lblEUserName.Text.Trim(',');

       //     Button btnUpdate = (Button)gvWorkflowBusinessUnitRole.Rows[e.NewEditIndex].FindControl("btnUpdate");
       //     EnDisAddAndSave(false);
       //     smAppWfAddEdit.SetFocus(ddlESecGroup);
       //     hdnEditRecordBU.Value = "0#" + btnUpdate.ClientID;
       //     foreach (GridViewRow gvRow in gvWorkflowBusinessUnit.Rows)
       //     {
       //         Button btnBusinessUnitAdd = (Button)gvRow.FindControl("btnBusinessUnitAdd");
       //         DisableButtonsOnBU(false, btnBusinessUnitAdd);
       //     }
       // }

    }
    protected void gvWorkflowBusinessUnitRole_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        //GridView gvWorkflowBusinessUnitRole = (GridView)sender;
        //hdnEditRecordBU.Value = "";
        //gvWorkflowBusinessUnitRole.EditIndex = -1;
        //BindWorkflowBusinessUnitRoleGrid(e.RowIndex,"");
        //foreach (GridViewRow gvRow in gvWorkflowBusinessUnit.Rows)
        //{
        //    Button btnBusinessUnitAdd = (Button)gvRow.FindControl("btnBusinessUnitAdd");
        //    DisableButtonsOnBU(true, btnBusinessUnitAdd);
        //}
    }
    protected void gvWorkflowBusinessUnitRole_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        //GridView gvWorkflowBusinessUnitRole = (GridView)sender;

        //DropDownList ddlESecGroup = (DropDownList)gvWorkflowBusinessUnitRole.Rows[e.RowIndex].FindControl("ddlESecGroup");

        ////ArrayList arrTemp = new ArrayList();
        ////arrTemp = (ArrayList)Session["WFBusinessUnit"];

        //int updateIndex;
        //if (mode == "EDIT")
        //{
        //    Label lblHdnESecGrp = (Label)gvWorkflowBusinessUnitRole.Rows[e.RowIndex].FindControl("lblHdnESecGrp");
        //    updateIndex = GetActualIndexBU(Convert.ToInt32(lblHdnESecGrp.Text));
        //}
        //else
        //{
        //    updateIndex = e.RowIndex;
        //}

        // WorkflowBU objw = (WorkflowBU)(from WorkflowBU obj in arrWorkflowBU
        //                               where obj.BusinessUnitCode == Convert.ToInt32(hdnBusinessUnitCode.Value)
        //                               select obj).FirstOrDefault();

        // if (objw != null)
        // {
        //     WorkflowBURole objWorkflowBURole = (WorkflowBURole)objw.arrWorkflowBusinessUnitRole[updateIndex];

        //     objWorkflowBURole.objSecurityGroup.IntCode = Convert.ToInt32(ddlESecGroup.SelectedValue);
        //     objWorkflowBURole.groupName = ddlESecGroup.SelectedItem.Text;

        //     objw.arrWorkflowBusinessUnitRole.RemoveAt(updateIndex);

        //     objw.arrWorkflowBusinessUnitRole.Insert(updateIndex, objWorkflowBURole);

        //     gvWorkflowBusinessUnitRole.EditIndex = -1;
        //     hdnEditRecordBU.Value = "";
        //     BindWorkflowBusinessUnitRoleGrid(e.RowIndex,"");
        // }
        // foreach (GridViewRow gvRow in gvWorkflowBusinessUnit.Rows)
        // {
        //     Button btnBusinessUnitAdd = (Button)gvRow.FindControl("btnBusinessUnitAdd");
        //     DisableButtonsOnBU(true, btnBusinessUnitAdd);
        // }
    }
    #endregion

    #endregion

}
