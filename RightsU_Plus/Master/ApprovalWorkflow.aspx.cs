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
using RightsU_Entities;

public partial class SystemSetting_ApprovalWorkflow : ParentPage
{
    #region ------ Attributes -----

    Users objUser = new Users();
    public User objLoginedUser { get; set; }
   // public User objLoginedUser { get; set; }
    int loginUserId;

    int moduleCode = GlobalParams.ModuleCodeForApprovalWorkflow;
    ArrayList arrUserRight;
    ArrayList arrRights = new ArrayList();

    string approvalWorkflow = "";
    string roleLevel = "";
    string msgAdd = "";
    string msgUpdate = "";
    string msgDelete = "";
    string msgAskDelete = "";
    string recInUseMsg = "";
    string recChangedMsg = "";
    string recDeletedMsg = "";
    string msgAskDeleteWrkflw = "";

    #endregion

    #region ----- Properties -----

    public int pageNo
    {
        get
        {
            if (ViewState["pageNo"] == null)
                return 1;
            else
                return (int)ViewState["pageNo"];
        }
        set { ViewState["pageNo"] = value; }
    }

    #endregion

    #region ------ Event Handlers -------

    protected void Page_Load(object sender, EventArgs e)
    {
        objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);

        ((Home)this.Page.Master).setVal("ApprovalWorkflow");

        loginUserId = objLoginedUser.Users_Code;
        GetGlobalRes();
        if (!Page.IsPostBack)
        {
            Page.Header.DataBind();
            GetUserRights();
            SetVisibilityForAdd();
            string resMsg = "";
            if (Request.QueryString["resMsg"] != null)
                resMsg = Request.QueryString["resMsg"];

            if (resMsg == GlobalParams.RECORD_ADDED || resMsg == GlobalParams.RECORD_UPDATED || resMsg == "C")
            {
                pageNo = Convert.ToInt32(Request.QueryString["pageNo"]);
                if (resMsg == GlobalParams.RECORD_ADDED)
                {
                    CreateMessageAlert(this, btnAdd, approvalWorkflow + " " + msgAdd);
                }
                else if (resMsg == GlobalParams.RECORD_UPDATED)
                {
                    CreateMessageAlert(this, btnAdd, approvalWorkflow + " " + msgUpdate);
                }
            }
            btnAdd.Focus();

            //Added By Sharad for Add Right Validation on 27/12/2010
            SecurityGroup objSecGr = new SecurityGroup();
            arrUserRight = objSecGr.getArrUserRightCodes(objLoginedUser.Security_Group.Security_Group_Code, moduleCode, "");
            ArrayList arrRights = new ArrayList();
            arrRights.Add(new AttribValue((object)btnAdd, GlobalParams.RightCodeForAdd.ToString()));

            GlobalParams.HideRightsButton(arrUserRight, moduleCode, arrRights, false, objLoginedUser.Security_Group_Code.Value);
            //Added By Sharad for Add Right Validation on 27/12/2010

            BindGrid();
        }
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        Response.Redirect("ApprovalWorkflowAddEdit.aspx?mode=ADD&pageNo=" + pageNo);
    }
    protected void dtLst_ItemCommand(object source, DataListCommandEventArgs e)
    {
        gvAppWorkflow.EditIndex = -1;
        pageNo = Convert.ToInt32(e.CommandArgument);
        BindGrid();
    }
    protected void dtLst_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
        {
            Button btnpage = (Button)e.Item.FindControl("btnPager");
            btnpage.Attributes.Add("OnClick", "javascript:return canEditRecordAjax(" + hdnEditRecord.ClientID + ")");
            if (pageNo == Convert.ToInt32(btnpage.CommandArgument))
            {
                btnpage.Enabled = false;
                btnpage.CssClass = "pagingbtn";
            }
        }
    }
    protected void gvAppWorkflow_RowEditing(object sender, GridViewEditEventArgs e)
    {
        int userCode;
        Workflow objWorkflow = new Workflow();
        objWorkflow.IntCode = Convert.ToInt32(gvAppWorkflow.DataKeys[e.NewEditIndex].Values[0]);
        objWorkflow.LastUpdatedTime = Convert.ToString(gvAppWorkflow.DataKeys[e.NewEditIndex].Values[1]);
        objWorkflow.LastUpdatedBy = loginUserId;
        string strStatus = objWorkflow.getRecordStatus(out userCode);
        if (userCode > 0)
        {
            objUser.IntCode = userCode;
            objUser.Fetch();
            if (userCode == loginUserId)
            {
                strStatus = GlobalParams.RECORD_STATUS_UPDATABLE;
            }
        }
        if (strStatus == GlobalParams.RECORD_STATUS_LOCKED)
        {
            CreateMessageAlert(btnAdd, recInUseMsg + " by " + objUser.userName);
            BindGrid();

        }
        else if (strStatus == GlobalParams.RECORD_STATUS_CHANGED)
        {
            CreateMessageAlert(btnAdd, recChangedMsg + " by " + objUser.userName);
            BindGrid();
        }
        else if (strStatus == GlobalParams.RECORD_STATUS_DELETED)
        {
            CreateMessageAlert(btnAdd, recDeletedMsg);
            BindGrid();
        }
        else
        {
            BindGrid();
            string code = Convert.ToString(gvAppWorkflow.DataKeys[e.NewEditIndex].Values[0]);
            Label lblSrNo = (Label)gvAppWorkflow.Rows[e.NewEditIndex].FindControl("lblSrNo");
            Response.Redirect("ApprovalWorkflowAddEdit.aspx?RecNo=" + code + "&mode=EDIT&srNo=" + lblSrNo.Text + "&pageNo=" + pageNo);
        }
    }
    protected void gvAppWorkflow_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int userCode;
        string msg;
        Workflow objWorkflow = new Workflow();
        objWorkflow.IntCode = Convert.ToInt32(gvAppWorkflow.DataKeys[e.RowIndex].Values[0]);
        objWorkflow.LastUpdatedTime = Convert.ToString(gvAppWorkflow.DataKeys[e.RowIndex].Values[1]);
        objWorkflow.LastUpdatedBy = loginUserId;
        string strStatus = objWorkflow.getRecordStatus(out userCode);
        if (userCode > 0)
        {
            objUser.IntCode = userCode;
            objUser.Fetch();
            if (userCode == loginUserId)
            {
                strStatus = GlobalParams.RECORD_STATUS_UPDATABLE;
            }
        }
        if (strStatus == GlobalParams.RECORD_STATUS_LOCKED)
        {
            CreateMessageAlert(btnAdd, recInUseMsg + " by " + objUser.userName);
            BindGrid();
        }
        else if (strStatus == GlobalParams.RECORD_STATUS_CHANGED)
        {
            CreateMessageAlert(btnAdd, recChangedMsg + " by " + objUser.userName);
            BindGrid();
        }
        else if (strStatus == "D")
        {
            CreateMessageAlert(btnAdd, recDeletedMsg);
            BindGrid();
        }
        else
        {
            try
            {
                objWorkflow.FetchDeep();
                if (objWorkflow.arrWorkflowRole.Count > 0)
                {
                    WorkflowRole objFirstWorkflowRole = new WorkflowRole();
                    objFirstWorkflowRole = (WorkflowRole)objWorkflow.arrWorkflowRole[0];
                    objFirstWorkflowRole.IsTransactionRequired = true;
                    objFirstWorkflowRole.IsBeginningOfTrans = true;
                    objFirstWorkflowRole.IsDeleted = true;
                    objFirstWorkflowRole.Save();
                    if (objWorkflow.arrWorkflowRole.Count > 1)
                    {
                        WorkflowRole objTempWorkflowRole = new WorkflowRole();
                        for (int i = 1; i < objWorkflow.arrWorkflowRole.Count; i++)
                        {
                            objTempWorkflowRole = (WorkflowRole)objWorkflow.arrWorkflowRole[i];
                            objTempWorkflowRole.SqlTrans = objFirstWorkflowRole.SqlTrans;
                            objTempWorkflowRole.IsTransactionRequired = true;
                            objTempWorkflowRole.IsDeleted = true;
                            objTempWorkflowRole.Save();
                        }
                    }
                    objWorkflow.SqlTrans = objFirstWorkflowRole.SqlTrans;
                }
                else
                {
                    objWorkflow.IsBeginningOfTrans = true;
                }
                objWorkflow.IsTransactionRequired = true;
                objWorkflow.IsDeleted = true;
                objWorkflow.IsEndOfTrans = true;
                msg = objWorkflow.Save();
                if (msg == GlobalParams.RECORD_DELETED)
                {
                    CreateMessageAlert(btnAdd, approvalWorkflow + " " + msgDelete);
                    //BindGrid();
                }
                else
                {
                    CreateMessageAlert(btnAdd, msg);
                }
                BindGrid();
            }
            catch (RecordNotFoundException ex)
            {
                CreateMessageAlert(btnAdd, ex.Message);
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                if (ex.Number == 547)
                {
                    string[] arrStr = ex.Message.Split(new char[] { '"' });
                    string strAction = arrStr[0].ToString();
                    if (strAction.ToUpper().Contains("DELETE"))
                    {
                        string delMsg = GlobalParams.getDeleteMsg(approvalWorkflow, arrStr[5].ToString());
                        CreateMessageAlert(btnAdd, delMsg);
                    }
                    else
                    {
                        throw ex;
                    }
                }
                else
                {
                    throw ex;
                }
            }
        }
    }
    protected void gvAppWorkflow_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit && (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            Button btnDelete = (Button)e.Row.FindControl("btnDelete");
            Button btnEdit = (Button)e.Row.FindControl("btnEdit");
            Button btnView = (Button)e.Row.FindControl("btnView");
            int workFlowCode = Convert.ToInt32(gvAppWorkflow.DataKeys[e.Row.RowIndex].Values[0]);

            Label lblBusinessUnitName = (Label)e.Row.FindControl("lblBusinessUnitName");
            Label lblBusinessUnit = (Label)e.Row.FindControl("lblBusinessUnit");
            if (lblBusinessUnit.Text != "" && lblBusinessUnit.Text != "0")
            {
                BusinessUnit objBU = new BusinessUnit();
                objBU.IntCode = Convert.ToInt32(lblBusinessUnit.Text);
                objBU.Fetch();
                lblBusinessUnitName.Text = objBU.BusinessUnitName;
            }

            //btnDelete.Attributes.Add("Onclick", "javascript:return canEditForDeleteAjax(" + hdnEditRecord.ClientID + ",'All the " + roleLevel + " added for this " + approvalWorkflow + " will also get deleted, " + msgAskDelete + "',this);");
            btnDelete.Attributes.Add("Onclick", "javascript:return canEditForDeleteAjax(" + hdnEditRecord.ClientID + ",'" + msgAskDeleteWrkflw + "',this);");
            SetVisibilityForEditNDelete(btnEdit, btnDelete, btnView);
            
            // Hide the delete button(s) if workflow is being used in Assign Workflow
            if ((new Workflow()).UsedInAssignWrkFlw(workFlowCode))
            {
                btnDelete.Visible = false;
                btnEdit.Visible = false;
            }


        }

    }

    #endregion

    #region ------- Methods -------

    private void BindGrid()
    {
        if (pageNo == 0)
        {
            pageNo = 1;
        }
        Criteria objCrt = new Criteria();
        Workflow objWorkflow = new Workflow();
        ArrayList arrWorkflow = new ArrayList();
        objCrt.ClassRef = objWorkflow;
        objCrt.IsPagingRequired = true;
        int recCount, ipages = 0;
        ArrayList arrList = GlobalUtil.getArrBatchWisePaging(new Workflow(), "", objCrt.RecordPerPage, objCrt.PagesPerBatch, lblTotal, pageNo, out ipages, out recCount);
        if (ipages < pageNo)
        {
            pageNo = ipages;
        }
        dtLst.DataSource = arrList;
        dtLst.DataBind();
        objCrt.RecordCount = recCount;
        objCrt.PageNo = pageNo;
        arrWorkflow = objCrt.Execute("");
        gvAppWorkflow.DataSource = arrWorkflow;
        gvAppWorkflow.DataBind();
        DBUtil.AddDummyRowIfDataSourceEmpty(gvAppWorkflow, new Workflow());
    }
    private void GetGlobalRes()
    {
        approvalWorkflow = "Approval Workflow";
        roleLevel = "Role Level";
        msgAdd = "added successfully";
        msgUpdate = "updated successfully";
        msgDelete = "deleted successfully";
        msgAskDelete = "Are you sure, you want to delete this record? ";
        recInUseMsg = "Record is in use";
        recChangedMsg = "Record has been changed";
        recDeletedMsg = "Record has been deleted";
        msgAskDeleteWrkflw = "Are you sure, you want to delete this Approval Workflow?";
    }
    private void SetVisibilityForAdd()
    {
        arrRights.Add(new AttribValue((object)btnAdd, GlobalParams.RightCodeForAdd.ToString()));
    
        GlobalParams.HideRightsButton(arrUserRight, moduleCode, arrRights, false, objLoginedUser.Security_Group_Code.Value);
    }
    private void GetUserRights()
    {
        SecurityGroup objSecGr = new SecurityGroup();
        arrUserRight = objSecGr.getArrUserRightCodes(objLoginedUser.Security_Group_Code.Value, moduleCode, "");
    }
    private void SetVisibilityForEditNDelete(Button btnEdit, Button btnDelete, Button btnView)
    {
        arrRights.Clear();
        arrRights.Add(new AttribValue((object)btnEdit, GlobalParams.RightCodeForEdit.ToString()));
        arrRights.Add(new AttribValue((object)btnDelete, GlobalParams.RightCodeForDelete.ToString()));
        arrRights.Add(new AttribValue((object)btnView, GlobalParams.RightCodeForView.ToString()));
        GlobalParams.HideRightsButton(arrUserRight, moduleCode, arrRights, false, objLoginedUser.Security_Group_Code.Value);
    }

    #endregion

   

    protected void gvAppWorkflow_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "View":
                View(Convert.ToInt32(e.CommandArgument));
                break;
            default:
                return;
        }

    }

    private void View(int RowIndex)
    {
        Label lblSrNo = (Label)gvAppWorkflow.Rows[RowIndex].FindControl("lblSrNo");
        string code = Convert.ToString(gvAppWorkflow.DataKeys[RowIndex].Values[0]);

        // Getting whether record is deleted or not
        Workflow objWrkflw = new Workflow();
        Criteria objCr = new Criteria();
        objCr.ClassRef = objWrkflw;
        ArrayList arr = objCr.Execute("and workflow_code=" + code);
        if (arr.Count > 0)
        {
            Response.Redirect("ApprovalWorkflow_View.aspx?pageNo=" + pageNo + "&RecNo=" + code + "&srNo=" + lblSrNo.Text);
        }
        else
        {
            CreateMessageAlert(btnAdd, recDeletedMsg);
            BindGrid();
        }
        
    }
}
