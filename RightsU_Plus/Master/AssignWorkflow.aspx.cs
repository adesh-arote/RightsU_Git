using System;
using System.Data;
using System.Data.SqlClient;
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

public partial class SystemSetting_AssignWorkflow : ParentPage
{
    public User objLoginedUser { get; set; }

    #region ------ Attributes -----

    Users objUser = new Users();
    int loginUserId;

    int moduleCode = GlobalParams.ModuleCodeForAssignWorkflow;
    ArrayList arrUserRight;
    ArrayList arrRights = new ArrayList();

    string assignWorkflow = "";
    string msgAdd = "";
    string msgUpdate = "";
    string msgDelete = "";
    string msgUpgraded = "";
    string msgAskDelete = "";
    string recInUseMsg = "";
    string recChangedMsg = "";
    string recDeletedMsg = "";

    #endregion



    #region ------ Properties ------

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

    #region ------ Event Handlers ------

    protected void Page_Load(object sender, EventArgs e)
    {
        objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);

        ((Home)this.Page.Master).setVal("AssignWorkflow");

        loginUserId = objLoginedUser.Users_Code;
        GetGlobalRes();

        if (!Page.IsPostBack)
        {
            //GetUserRights();
            //SetVisibilityForAssign();
            Page.Header.DataBind();
            pageNo = Convert.ToInt32(Request.QueryString["pageNo"]);
            string resMsg = "";

            if (Request.QueryString["resMsg"] != null)
                resMsg = Request.QueryString["resMsg"];

            if (resMsg == GlobalParams.RECORD_ADDED || resMsg == GlobalParams.RECORD_UPDATED || resMsg == "UP" || resMsg == "C")
            {
                if (resMsg == GlobalParams.RECORD_ADDED)
                {
                    CreateMessageAlert(this, btnAssign, assignWorkflow + " " + msgAdd);
                }
                else if (resMsg == GlobalParams.RECORD_UPDATED)
                {
                    CreateMessageAlert(this, btnAssign, assignWorkflow + " " + msgUpdate);
                }
                else if (resMsg == "UP")
                {
                    CreateMessageAlert(this, btnAssign, assignWorkflow + " " + msgUpgraded);
                }
            }

            btnAssign.Focus();
            BindGrid();
        }
    }
    protected void dtLst_ItemCommand(object source, DataListCommandEventArgs e)
    {
        gvAssWorkflow.EditIndex = -1;
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
    protected void gvAssWorkflow_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Upgrade":
                UpgradeRecord(Convert.ToInt32(e.CommandArgument));
                break;

            case "ViewHis":
                ViewHistory(Convert.ToInt32(e.CommandArgument));
                break;

            case "View":
                View(Convert.ToInt32(e.CommandArgument));
                break;

            default:
                return;
        }
    }

    private void View(int RowIndex)
    {
        Label lblModName = (Label)gvAssWorkflow.Rows[RowIndex].FindControl("lblModName");
        Label lblBusinessUnitCode = (Label)gvAssWorkflow.Rows[RowIndex].FindControl("lblBusinessUnitCode");

        string moduleName = lblModName.Text;
        string code = Convert.ToString(gvAssWorkflow.DataKeys[RowIndex].Values[0]);
        string BusinessCode = lblBusinessUnitCode.Text;

        // Getting whether record is deleted or not
        WorkflowModule objWrkflwModule = new WorkflowModule();
        Criteria objCr = new Criteria();
        objCr.ClassRef = objWrkflwModule;
        ArrayList arr = objCr.Execute("and workflow_module_code=" + code);

        if (arr.Count > 0)
        {
            Response.Redirect("AssignWorkflow_View.aspx?pageNo=" + pageNo + "&RecCode=" + code + "&moduleName=" + moduleName + "&BusinessCode=" + BusinessCode);
        }
        else
        {
            CreateMessageAlert(btnAssign, recDeletedMsg);
            BindGrid();
        }
    }

    private void ViewHistory(int RowIndex)
    {
        Label lblModName = (Label)gvAssWorkflow.Rows[RowIndex].FindControl("lblModName");
        Label lblBusinessUnitCode = (Label)gvAssWorkflow.Rows[RowIndex].FindControl("lblBusinessUnitCode");
        string moduleName = lblModName.Text;
        string code = Convert.ToString(gvAssWorkflow.DataKeys[RowIndex].Values[0]);
        string BusinessCode = lblBusinessUnitCode.Text;

        // Getting whether record is deleted or not
        WorkflowModule objWrkflwModule = new WorkflowModule();
        Criteria objCr = new Criteria();
        objCr.ClassRef = objWrkflwModule;
        ArrayList arr = objCr.Execute("and workflow_module_code=" + code);

        if (arr.Count > 0)
        {
            Response.Redirect("AssignWorkflowAddEdit.aspx?mode=VIEWHIS&pageNo=" + pageNo + "&RecCode=" + code + "&moduleName=" + moduleName + "&BusinessCode=" + BusinessCode);
        }
        else
        {
            CreateMessageAlert(btnAssign, recDeletedMsg);
            BindGrid();
        }
    }

    private void UpgradeRecord(int RowIndex)
    {
        int userCode;
        WorkflowModule objWrkflwModule = new WorkflowModule();
        objWrkflwModule.IntCode = Convert.ToInt32(gvAssWorkflow.DataKeys[RowIndex].Values[0]);
        objWrkflwModule.LastUpdatedTime = Convert.ToString(gvAssWorkflow.DataKeys[RowIndex].Values[1]);
        objWrkflwModule.LastUpdatedBy = loginUserId;
        string strStatus = objWrkflwModule.getRecordStatus(out userCode);

        if (userCode > 0)
        {
            objUser.IntCode = userCode;
            objUser.Fetch();

            if (userCode == loginUserId)
                strStatus = GlobalParams.RECORD_STATUS_UPDATABLE;
        }

        if (strStatus == GlobalParams.RECORD_STATUS_LOCKED)
        {
            CreateMessageAlert(btnAssign, recInUseMsg + " by " + objUser.userName);
            BindGrid();
        }
        else if (strStatus == GlobalParams.RECORD_STATUS_CHANGED)
        {
            CreateMessageAlert(btnAssign, recChangedMsg + " by " + objUser.userName);
            BindGrid();
        }
        else if (strStatus == GlobalParams.RECORD_STATUS_DELETED)
        {
            CreateMessageAlert(btnAssign, recDeletedMsg);
            BindGrid();
        }
        else
        {
            BindGrid();
            string code = Convert.ToString(gvAssWorkflow.DataKeys[RowIndex].Values[0]);
            Response.Redirect("AssignWorkflowAddEdit.aspx?RecNo=" + code + "&mode=UPGRADE&pageNo=" + pageNo);
        }
    }
    protected void gvAssWorkflow_RowEditing(object sender, GridViewEditEventArgs e)
    {
        int userCode;
        WorkflowModule objWrkflwModule = new WorkflowModule();
        objWrkflwModule.IntCode = Convert.ToInt32(gvAssWorkflow.DataKeys[e.NewEditIndex].Values[0]);
        objWrkflwModule.LastUpdatedTime = Convert.ToString(gvAssWorkflow.DataKeys[e.NewEditIndex].Values[1]);
        objWrkflwModule.LastUpdatedBy = loginUserId;
        string strStatus = objWrkflwModule.getRecordStatus(out userCode);

        if (userCode > 0)
        {
            objUser.IntCode = userCode;
            objUser.Fetch();

            if (userCode == loginUserId)
                strStatus = GlobalParams.RECORD_STATUS_UPDATABLE;
        }

        if (strStatus == GlobalParams.RECORD_STATUS_LOCKED)
        {
            CreateMessageAlert(btnAssign, recInUseMsg + " by " + objUser.userName);
            BindGrid();
        }
        else if (strStatus == GlobalParams.RECORD_STATUS_CHANGED)
        {
            CreateMessageAlert(btnAssign, recChangedMsg + " by " + objUser.userName);
            BindGrid();
        }
        else if (strStatus == GlobalParams.RECORD_STATUS_DELETED)
        {
            CreateMessageAlert(btnAssign, recDeletedMsg);
            BindGrid();
        }
        else
        {
            BindGrid();
            string code = Convert.ToString(gvAssWorkflow.DataKeys[e.NewEditIndex].Values[0]);
            Response.Redirect("AssignWorkflowAddEdit.aspx?RecNo=" + code + "&mode=EDIT&pageNo=" + pageNo);
        }
    }
    protected void gvAssWorkflow_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            Label lblBusinessUnit = (Label)e.Row.FindControl("lblBusinessUnit");
            Label lblBusinessUnitCode = (Label)e.Row.FindControl("lblBusinessUnitCode");

            if (lblBusinessUnitCode.Text != "" && lblBusinessUnitCode.Text != "0")
            {
                BusinessUnit objBu = new BusinessUnit();
                objBu.IntCode = Convert.ToInt32(lblBusinessUnitCode.Text);
                objBu.Fetch();
                lblBusinessUnit.Text = objBu.BusinessUnitName;
            }

            Button btnDelete = (Button)e.Row.FindControl("btnDelete");
            Button btnEdit = (Button)e.Row.FindControl("btnEdit");
            Button btnUpgrade = (Button)e.Row.FindControl("btnUpgrade");
            Button btnViewHis = (Button)e.Row.FindControl("btnViewHis");
            Label lblStatus = (Label)e.Row.FindControl("lblStatus");
            int wrkflwModCode = Convert.ToInt32(gvAssWorkflow.DataKeys[e.Row.RowIndex].Values[0]);
            int moduleCode = Convert.ToInt32(gvAssWorkflow.DataKeys[e.Row.RowIndex].Values[2]);
            btnDelete.Attributes.Add("Onclick", "javascript:return canEditForDeleteAjax(" + hdnEditRecord.ClientID + ",'Workflow history will also get deleted(if exists), " + msgAskDelete + "',this);");

            //SetVisibilityForButtons(btnEdit, btnDelete, btnUpgrade, btnViewHis);
            if (IsUsed(moduleCode))
            {
                btnDelete.Visible = false;
                btnEdit.Visible = false;
            }
            else
            {
                btnDelete.Visible = true;
            }

            if (IsUpgrded(wrkflwModCode))
            {
                lblStatus.Text = "Upgrade";
                btnEdit.Visible = false;
            }
            else
            {
                lblStatus.Text = "Assign";
                btnViewHis.Visible = false;
            }

        }

        e.Row.Attributes.Add("onMouseOver", "this.className='rowOverBg'");
        e.Row.Attributes.Add("onMouseOut", "this.className='rowOutBg'");
    }

    private void SetVisibilityForButtons(Button btnEdit, Button btnDelete, Button btnUpgrade, Button btnViewHis)
    {
        arrRights.Clear();
        arrRights.Add(new AttribValue(btnEdit, GlobalParams.RightCodeForEdit.ToString()));
        arrRights.Add(new AttribValue(btnDelete, GlobalParams.RightCodeForDelete.ToString()));
        arrRights.Add(new AttribValue(btnUpgrade, GlobalParams.RightCodeForUpgrade.ToString()));
        arrRights.Add(new AttribValue(btnViewHis, GlobalParams.RightCodeForViewHistory.ToString()));
       // GlobalParams.HideRightsButton(arrUserRight, moduleCode, objLoginUser, arrRights);
        GlobalParams.HideRightsButton(arrUserRight, moduleCode, arrRights, false, objLoginedUser.Security_Group_Code.Value);
    }

    protected void gvAssWorkflow_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int userCode;
        string msg;
        WorkflowModule objWFModule = new WorkflowModule();
        objWFModule.IntCode = Convert.ToInt32(gvAssWorkflow.DataKeys[e.RowIndex].Values[0]);
        objWFModule.LastUpdatedTime = Convert.ToString(gvAssWorkflow.DataKeys[e.RowIndex].Values[1]);
        objWFModule.LastUpdatedBy = loginUserId;
        string strStatus = objWFModule.getRecordStatus(out userCode);

        if (userCode > 0)
        {
            objUser.IntCode = userCode;
            objUser.Fetch();

            if (userCode == loginUserId)
                strStatus = GlobalParams.RECORD_STATUS_UPDATABLE;
        }

        if (strStatus == GlobalParams.RECORD_STATUS_LOCKED)
        {
            CreateMessageAlert(btnAssign, recInUseMsg + " by " + objUser.userName);
            BindGrid();
        }
        else if (strStatus == GlobalParams.RECORD_STATUS_CHANGED)
        {
            CreateMessageAlert(btnAssign, recChangedMsg + " by " + objUser.userName);
            BindGrid();
        }
        else if (strStatus == "D")
        {
            CreateMessageAlert(btnAssign, recDeletedMsg);
            BindGrid();
        }
        else
        {
            try
            {
                objWFModule.FetchDeep();
                string WorkflowType = objWFModule.getWorkflowType(objWFModule.objWorkflow.IntCode);

                if (WorkflowType == "F")
                {
                    WorkFlowModuleRole objFirstWFModuleRole = new WorkFlowModuleRole();

                    if (objWFModule.arrWrkflwModRole.Count > 0)
                    {
                        //Delete only first child
                        objFirstWFModuleRole = (WorkFlowModuleRole)objWFModule.arrWrkflwModRole[0];
                        objFirstWFModuleRole.IsTransactionRequired = true;
                        objFirstWFModuleRole.IsBeginningOfTrans = true;
                        objFirstWFModuleRole.IsDeleted = true;
                        objFirstWFModuleRole.Save();
                        ////Delete only first child ENds

                        //Delete remaining child
                        if (objWFModule.arrWrkflwModRole.Count > 1)
                        {
                            WorkFlowModuleRole objTempWFModuleRole = new WorkFlowModuleRole();

                            for (int i = 1; i < objWFModule.arrWrkflwModRole.Count; i++)
                            {
                                objTempWFModuleRole = (WorkFlowModuleRole)objWFModule.arrWrkflwModRole[i];
                                objTempWFModuleRole.SqlTrans = objFirstWFModuleRole.SqlTrans;
                                objTempWFModuleRole.IsTransactionRequired = true;
                                objTempWFModuleRole.IsDeleted = true;
                                objTempWFModuleRole.Save();
                            }
                        }
                        //Delete remaining child ends
                    }
                    else
                    {
                        objWFModule.IsBeginningOfTrans = true;
                    }
                    // deleting all history

                    WorkflowModule objDelWFModule = new WorkflowModule();
                    Criteria objDelCr = new Criteria();
                    objDelCr.ClassRef = objDelWFModule;
                    ArrayList arrDel = objDelCr.Execute("and is_active = 'N' and module_code=" + objWFModule.objSysModule.IntCode);
                    SqlTransaction objTrans = null;

                    if (objWFModule.arrWrkflwModRole.Count > 0)
                        objTrans = (SqlTransaction)objFirstWFModuleRole.SqlTrans;

                    if (arrDel.Count > 0)
                    {
                        for (int j = 0; j < arrDel.Count; j++)
                        {
                            objDelWFModule = (WorkflowModule)arrDel[j];
                            objDelWFModule.DeleteChildHistory(objDelWFModule.IntCode, ref objTrans, WorkflowType);
                        }
                    }

                    // Deletion of history ended here
                    if (objWFModule.arrWrkflwModRole.Count > 0)
                        objWFModule.SqlTrans = objFirstWFModuleRole.SqlTrans;

                    objWFModule.IsTransactionRequired = true;
                    objWFModule.IsDeleted = true;
                    objWFModule.IsEndOfTrans = true;
                    msg = objWFModule.Save();

                    if (msg == GlobalParams.RECORD_DELETED)
                        CreateMessageAlert(btnAssign, assignWorkflow + " " + msgDelete);
                    else
                        CreateMessageAlert(btnAssign, msg);

                    BindGrid();
                }
                else
                {
                    //WorkflowModuleBU objWorkflowModuleBUFirst = new WorkflowModuleBU();
                    //WorkflowModuleBURole objFirstWFModuleRole = new WorkflowModuleBURole();
                    //if (objWFModule.arrWrkflwModBU.Count > 0)
                    //{
                    //    //Deleting First child
                    //    objWorkflowModuleBUFirst = (WorkflowModuleBU)objWFModule.arrWrkflwModBU[0];
                    //    foreach (WorkflowModuleBURole obj in objWorkflowModuleBUFirst.arrWorkflowModuleBURole)
                    //    {
                    //        objFirstWFModuleRole = obj;
                    //        objFirstWFModuleRole.IsTransactionRequired = true;
                    //        objFirstWFModuleRole.IsBeginningOfTrans = true;
                    //        objFirstWFModuleRole.IsDeleted = true;
                    //        objFirstWFModuleRole.Save();
                    //    }
                    //    objWorkflowModuleBUFirst.SqlTrans = objFirstWFModuleRole.SqlTrans;
                    //    objWorkflowModuleBUFirst.IsTransactionRequired = true;
                    //    //objWorkflowModuleBUFirst.IsBeginningOfTrans = true;
                    //    objWorkflowModuleBUFirst.IsDeleted = true;
                    //    objWorkflowModuleBUFirst.Save();
                    //    //Deleting First child
                    //}

                    //if (objWFModule.arrWrkflwModBU.Count > 0)
                    //{
                    //    foreach (WorkflowModuleBU objModuleBU in objWFModule.arrWrkflwModBU)
                    //    {
                    //        if (objModuleBU.arrWorkflowModuleBURole.Count > 0)
                    //        {
                    //            foreach (WorkflowModuleBURole obj in objWorkflowModuleBUFirst.arrWorkflowModuleBURole)
                    //            {
                    //                WorkflowModuleBURole objTempWFModuleRole = new WorkflowModuleBURole();

                    //                objTempWFModuleRole = obj;//(WorkflowModuleBURole)objWorkflowModuleBUFirst.arrWorkflowModuleBURole[i];
                    //                objTempWFModuleRole.SqlTrans = objFirstWFModuleRole.SqlTrans;
                    //                objTempWFModuleRole.IsTransactionRequired = true;
                    //                //objTempWFModuleRole.IsBeginningOfTrans = true;
                    //                objTempWFModuleRole.IsDeleted = true;
                    //                objTempWFModuleRole.Save();
                    //            }
                    //        }
                    //        objModuleBU.SqlTrans = objFirstWFModuleRole.SqlTrans;
                    //        objModuleBU.IsTransactionRequired = true;
                    //        // objModuleBU.IsBeginningOfTrans = true;
                    //        objModuleBU.IsDeleted = true;
                    //        objModuleBU.Save();
                    //    }
                    //}

                    WorkflowModuleBU objWorkflowModuleBUFirst = new WorkflowModuleBU();

                    if (objWFModule.arrWrkflwModBU.Count > 0)
                    {
                        foreach (WorkflowModuleBU objModuleBU in objWFModule.arrWrkflwModBU)
                        {
                            objWorkflowModuleBUFirst = objModuleBU;

                            if (objModuleBU.arrWorkflowModuleBURole.Count > 0)
                            {
                                foreach (WorkflowModuleBURole objRole in objWorkflowModuleBUFirst.arrWorkflowModuleBURole)
                                {
                                    // objRole.IsTransactionRequired = true;
                                    //objRole.SqlTrans = objWFModule.SqlTrans;
                                    objRole.IsDeleted = true;
                                    objRole.Save();
                                }
                            }

                            //objModuleBU.IsTransactionRequired = true;
                            //objModuleBU.IsBeginningOfTrans = true;
                            // objModuleBU.SqlTrans = objWFModule.SqlTrans;
                            objModuleBU.IsDeleted = true;
                            objModuleBU.Save();
                        }
                    }

                    // deleting all history

                    WorkflowModule objDelWFModule = new WorkflowModule();
                    Criteria objDelCr = new Criteria();
                    objDelCr.ClassRef = objDelWFModule;
                    ArrayList arrDel = objDelCr.Execute("and is_active = 'N' and module_code=" + objWFModule.objSysModule.IntCode);
                    SqlTransaction objTrans = (SqlTransaction)objDelWFModule.SqlTrans; //(SqlTransaction)objWorkflowModuleBUFirst.SqlTrans;

                    if (arrDel.Count > 0)
                    {
                        for (int j = 0; j < arrDel.Count; j++)
                        {
                            objDelWFModule = (WorkflowModule)arrDel[j];
                            objDelWFModule.DeleteChildHistory(objDelWFModule.IntCode, ref objTrans, WorkflowType);
                        }
                    }

                    // Deletion of history ended here

                    //objWFModule.SqlTrans = (SqlTransaction)objDelWFModule.SqlTrans;//objWorkflowModuleBUFirst.SqlTrans;
                    objWFModule.IsDeleted = true;
                    //objWFModule.IsEndOfTrans = true;
                    msg = objWFModule.Save();

                    if (msg == GlobalParams.RECORD_DELETED)
                        CreateMessageAlert(btnAssign, assignWorkflow + " " + msgDelete);
                    else
                        CreateMessageAlert(btnAssign, msg);

                    BindGrid();

                    // foreach (WorkflowModuleBU objModuleBu in objWFModule.arrWrkflwModBU.ToArray())
                    // {
                    //     if (objModuleBu != null)
                    //     {
                    //         foreach (WorkflowModuleBURole objModuleBURole in objModuleBu.arrWorkflowModuleBURole.ToArray())
                    //         {
                    //             //objModuleBu.arrWorkflowModuleBURole_Del.Add(objModuleBURole);
                    //             //objModuleBu.arrWorkflowModuleBURole.Remove(objModuleBURole);
                    //             objModuleBURole.IsTransactionRequired = true;
                    //             objModuleBURole.IsBeginningOfTrans = true;
                    //             objModuleBURole.IsDeleted = true;
                    //             objModuleBURole.Save();
                    //         }
                    //         objModuleBu.IsTransactionRequired = true;
                    //         objModuleBu.IsBeginningOfTrans = true;
                    //         objModuleBu.IsDeleted = true;
                    //         objModuleBu.Save();
                    //         //objWFModule.arrWrkflwModBU_Del.Add(objModuleBu);
                    //         //objWFModule.arrWrkflwModBU.Remove(objModuleBu);
                    //     }
                    // }

                    // //WorkFlowModuleRole objFirstWFModuleRole = new WorkFlowModuleRole();
                    // //objFirstWFModuleRole = (WorkFlowModuleRole)objWFModule.arrWrkflwModRole[0];
                    // //objFirstWFModuleRole.IsTransactionRequired = true;
                    // //objFirstWFModuleRole.IsBeginningOfTrans = true;
                    // //objFirstWFModuleRole.IsDeleted = true;
                    // //objFirstWFModuleRole.Save();
                    // //if (objWFModule.arrWrkflwModRole.Count > 1)
                    // //{
                    // //    WorkFlowModuleRole objTempWFModuleRole = new WorkFlowModuleRole();
                    // //    for (int i = 1; i < objWFModule.arrWrkflwModRole.Count; i++)
                    // //    {
                    // //        objTempWFModuleRole = (WorkFlowModuleRole)objWFModule.arrWrkflwModRole[i];
                    // //        objTempWFModuleRole.SqlTrans = objFirstWFModuleRole.SqlTrans;
                    // //        objTempWFModuleRole.IsTransactionRequired = true;
                    // //        objTempWFModuleRole.IsDeleted = true;
                    // //        objTempWFModuleRole.Save();
                    // //    }
                    // //}
                    // // deleting all history

                    // WorkflowModule objDelWFModule = new WorkflowModule();
                    // Criteria objDelCr = new Criteria();
                    // objDelCr.ClassRef = objDelWFModule;
                    // ArrayList arrDel = objDelCr.Execute("and is_active = 'N' and module_code=" + objWFModule.objSysModule.IntCode);

                    // if (arrDel.Count > 0)
                    // {
                    //     SqlTransaction objTrans = (SqlTransaction)objWFModule.SqlTrans;
                    //     for (int j = 0; j < arrDel.Count; j++)
                    //     {
                    //         objDelWFModule = (WorkflowModule)arrDel[j];
                    //         objDelWFModule.DeleteChildHistory(objDelWFModule.IntCode, ref objTrans);
                    //     }
                    // }

                    // // Deletion of history ended here

                    //// objWFModule.SqlTrans = objFirstWFModuleRole.SqlTrans;
                    // objWFModule.IsTransactionRequired = true;
                    // objWFModule.IsBeginningOfTrans = true;
                    // objWFModule.IsProxy = false;
                    // objWFModule.IsDeleted = true;
                    // //objWFModule.Save();
                    // msg = objWFModule.Save();
                    // if (msg == GlobalParams.RECORD_DELETED)
                    // {
                    //     CreateMessageAlert(btnAssign, assignWorkflow + " " + msgDelete);
                    //     //BindGrid();
                    // }
                    // else
                    // {
                    //     CreateMessageAlert(btnAssign, msg);
                    // }
                    // BindGrid();
                }
            }
            catch (RecordNotFoundException ex)
            {
                CreateMessageAlert(btnAssign, ex.Message);
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                if (ex.Number == 547)
                {
                    string[] arrStr = ex.Message.Split(new char[] { '"' });
                    string strAction = arrStr[0].ToString();

                    if (strAction.ToUpper().Contains("DELETE"))
                    {
                        string delMsg = GlobalParams.getDeleteMsg(assignWorkflow, arrStr[5].ToString());
                        CreateMessageAlert(btnAssign, delMsg);
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
    protected void btnAssign_Click(object sender, EventArgs e)
    {
        Response.Redirect("AssignWorkflowAddEdit.aspx?mode=ASSIGN&pageNo=" + pageNo);
    }

    #endregion

    #region ------ Methods ------

    private void BindGrid()
    {
        if (pageNo == 0)
            pageNo = 1;

        Criteria objCrt = new Criteria();
        WorkflowModule objWrkflwModule = new WorkflowModule();
        ArrayList arrWrkflwModule = new ArrayList();
        objCrt.ClassRef = objWrkflwModule;
        objCrt.IsPagingRequired = true;
        objCrt.IsSubClassRequired = true;
        int recCount, ipages = 0;
        ArrayList arrList = GlobalUtil.getArrBatchWisePaging(new WorkflowModule(), "and is_active = 'Y'", objCrt.RecordPerPage, objCrt.PagesPerBatch, lblTotal, pageNo, out ipages, out recCount);

        if (ipages < pageNo)
            pageNo = ipages;

        dtLst.DataSource = arrList;
        dtLst.DataBind();
        objCrt.RecordCount = recCount;
        objCrt.PageNo = pageNo;
        arrWrkflwModule = objCrt.Execute("and is_active = 'Y'");
        gvAssWorkflow.DataSource = arrWrkflwModule;
        gvAssWorkflow.DataBind();
        DBUtil.AddDummyRowIfDataSourceEmpty(gvAssWorkflow, new WorkflowModule());
    }
    private void GetUserRights()
    {
        SecurityGroup objSecGr = new SecurityGroup();
        arrUserRight = objSecGr.getArrUserRightCodes(objLoginedUser.Security_Group.Security_Group_Code, moduleCode, "");
    }
    private void SetVisibilityForAssign()
    {
        arrRights.Add(new AttribValue((object)btnAssign, GlobalParams.RightCodeForAssign.ToString()));
      //  GlobalParams.HideRightsButton(arrUserRight, moduleCode, objLoginUser, arrRights);
        GlobalParams.HideRightsButton(arrUserRight, moduleCode, arrRights, false, objLoginedUser.Security_Group_Code.Value);
    }
    private void GetGlobalRes()
    {
        assignWorkflow = "Assign Workflow";
        msgAdd = "added successfully";
        msgUpdate = "updated successfully";
        msgDelete = "deleted successfully";
        msgUpgraded = "upgraded successfully";
        msgAskDelete = "Are you sure, you want to delete this record? ";
        recInUseMsg = "Record is in use";
        recChangedMsg = "Record has been changed";
        recDeletedMsg = "Record has been deleted";
    }
    private Boolean IsUpgrded(int wrkflwModCode)
    {
        string strSql = "select count(*) from workflow_module where module_code=(select module_code from workflow_module where workflow_module_code = " + wrkflwModCode + ")";
        int resCount = (int)(new WorkflowModuleBroker()).ProcessScalar(strSql);

        if (resCount > 1)
            return true;
        else
            return false;
    }
    private Boolean IsUsed(int moduleCode)
    {
        string strSql = "select count(*) from Module_Workflow_Detail where module_code=" + moduleCode;
        int resCount = (int)(new WorkflowModuleBroker()).ProcessScalar(strSql);

        if (resCount > 0)
            return true;
        else
            return false;
    }

    #endregion

}
