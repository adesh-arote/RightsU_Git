using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Collections;
using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for ModuleWorkFlowDetailBroker
/// </summary>
public class ModuleWorkFlowDetailBroker : DatabaseBroker
{
    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return "SELECT COUNT(*) FROM Module_Workflow_Detail WHERE module_workflow_detail_code > -1 " + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        return "DELETE FROM Module_Workflow_Detail WHERE module_workflow_detail_code=" + obj.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        ModuleWorkFlowDetail objModuleWFDtl = (ModuleWorkFlowDetail)obj;
        string tmpNextLevelGroupCode = "null";

        if (objModuleWFDtl.objNextLevelGroup != null && objModuleWFDtl.objNextLevelGroup.IntCode > 0)
        {
            tmpNextLevelGroupCode = objModuleWFDtl.objNextLevelGroup.IntCode.ToString();
        }
        string sql = "INSERT INTO Module_Workflow_Detail(module_code,record_code,group_code,primary_user_code,role_level,is_done,next_level_group,entry_date) " +
                     "VALUES(" + objModuleWFDtl.objModule.IntCode + "," + objModuleWFDtl.recordCode
                     + "," + objModuleWFDtl.objSecurityGroup.IntCode + "," + objModuleWFDtl.objPrimaryUser.IntCode
                     + "," + objModuleWFDtl.roleLevel + ",'" + objModuleWFDtl.isDone + "'," + tmpNextLevelGroupCode + ",'" + objModuleWFDtl.entryDate + "')";
        return sql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = "SELECT * FROM Module_Workflow_Detail WHERE module_workflow_detail_code > -1 " + strSearchString;
        if (objCriteria.IsPagingRequired)
        {
            sql = objCriteria.getPagingSQL(sql);
            return sql;
        }
        return sql + " ORDER BY " + objCriteria.getASCstr();
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "SELECT * FROM Module_Workflow_Detail WHERE module_workflow_detail_code=" + obj.IntCode;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        ModuleWorkFlowDetail objModuleWFDtl = (ModuleWorkFlowDetail)obj;
        string tmpNextLevelGroupCode = "null";
        if (objModuleWFDtl.objNextLevelGroup != null && objModuleWFDtl.objNextLevelGroup.IntCode > 0)
        {
            tmpNextLevelGroupCode = objModuleWFDtl.objNextLevelGroup.IntCode.ToString();
        }
        string sql = "UPDATE Module_Workflow_Detail SET " +
                     "module_code=" + objModuleWFDtl.objModule.IntCode
                     + ",record_code=" + objModuleWFDtl.recordCode
                     + ",group_code=" + objModuleWFDtl.objSecurityGroup.IntCode
                     + ",primary_user_code=" + objModuleWFDtl.objPrimaryUser.IntCode
                     + ",role_level=" + objModuleWFDtl.roleLevel
                     + ",is_done='" + objModuleWFDtl.isDone
                     + "',next_level_group=" + tmpNextLevelGroupCode
                     + ",entry_date='" + objModuleWFDtl.entryDate
                     + "' WHERE module_workflow_detail_code=" + objModuleWFDtl.IntCode;
        return sql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ModuleWorkFlowDetail objModuleWFDtl;
        if (obj == null)
        {
            objModuleWFDtl = new ModuleWorkFlowDetail();
        }
        else
        {
            objModuleWFDtl = (ModuleWorkFlowDetail)obj;
        }
        objModuleWFDtl.IntCode = Convert.ToInt32(dRow["module_workflow_detail_code"]);
        objModuleWFDtl.objModule.IntCode = Convert.ToInt32(dRow["module_code"]);
        objModuleWFDtl.recordCode = Convert.ToInt32(dRow["record_code"]);
        objModuleWFDtl.objSecurityGroup.IntCode = Convert.ToInt32(dRow["group_code"]);
        objModuleWFDtl.objPrimaryUser.IntCode = Convert.ToInt32(dRow["primary_user_code"]);
        objModuleWFDtl.roleLevel = Convert.ToInt32(dRow["role_level"]);
        objModuleWFDtl.isDone = Convert.ToString(dRow["is_done"]);
        if (dRow["next_level_group"] != DBNull.Value)
        {
            objModuleWFDtl.objNextLevelGroup.IntCode = Convert.ToInt32(dRow["next_level_group"]);
        }
        if (dRow["entry_date"] != DBNull.Value)
        {
            DateTime tmpEntryDate = Convert.ToDateTime(dRow["entry_date"]);
            objModuleWFDtl.entryDate = tmpEntryDate.Date.ToShortDateString();
        }
        return objModuleWFDtl;
    }

    public bool IsModuleWorkFlowLevelDone(int moduleCode, int recordCode, int level)
    {
        bool retunVal = false;
        string sql = "SELECT count(*) FROM Module_Workflow_Detail WHERE " +
                     "module_code=" + moduleCode + " AND record_code=" + recordCode
                     + " AND role_level=" + level + " AND is_done='N'";

        int cnt = (int)ProcessScalar(sql);
        if (cnt == 0) retunVal = true;
        return retunVal;
    }

    public DataSet getdsNextApprover(int moduleCode, int recordCode, string strSearch)
    {
        string sql = "SELECT TOP 1 * FROM Module_Workflow_Detail " +
                   "WHERE module_code=" + moduleCode + " AND record_code=" + recordCode + strSearch +
                   "ORDER BY role_level";
        DataSet dsWFDtl = ProcessSelectDirectly(sql);
        return dsWFDtl;
    }

    //public bool getProcessApproverAction(Persistent obj, DataSet dsWFDtl, string isLvlDone, int userCode, string usrStatus, string strRemarks,string updTblName,string updColName,string updPrimColName,string mailBody )
    //{
    //    bool isMailSent = true;
    //    //----------------------------------------------------------------------
    //    int moduleCode = Convert.ToInt32(dsWFDtl.Tables[0].Rows[0]["module_code"]);
    //    int recordCode = Convert.ToInt32(dsWFDtl.Tables[0].Rows[0]["record_code"]);
    //    int roleLevel = Convert.ToInt32(dsWFDtl.Tables[0].Rows[0]["role_level"]);
    //    int nextLevelGrCode = 0;
    //    if (dsWFDtl.Tables[0].Rows[0]["next_level_group"] != DBNull.Value)
    //    {
    //        nextLevelGrCode = Convert.ToInt32(dsWFDtl.Tables[0].Rows[0]["next_level_group"]);
    //    }
    //    //----------------------------------------------------------------------
    //    ArrayList arrWFDtl = new ArrayList();
    //    ModuleWorkFlowDetail objmoduleWFDtl = new ModuleWorkFlowDetail();
    //    if (dsWFDtl.Tables.Count > 0 && dsWFDtl.Tables[0].Rows.Count > 0)
    //    {
    //        foreach (DataRow drow in dsWFDtl.Tables[0].Rows)
    //        {
    //            objmoduleWFDtl.GetBroker().PopulateObject(drow, objmoduleWFDtl);
    //        }
    //        objmoduleWFDtl.IsDirty = true;
    //        objmoduleWFDtl.IsTransactionRequired = true;
    //        objmoduleWFDtl.IsBeginningOfTrans = true;
    //        objmoduleWFDtl.isDone = isLvlDone;
    //        objmoduleWFDtl.IsEndOfTrans = false;
    //        objmoduleWFDtl.Save();

    //        //1.--Send for First Level Approval Sets status 'S' ------------------
    //        if (usrStatus == GlobalParams.WorkFlowStatus_SendForAuth || usrStatus == GlobalParams.WorkFlowStatus_ReSendForAuth)
    //        {
    //            UpdateMaterialOrderStatus(recordCode, usrStatus, (SqlTransaction)objmoduleWFDtl.SqlTrans);
    //        }
    //        //2.--Approved by intermidiate level Sets Waiting For Next status 'W~RoleLevel'--------
    //        else if (usrStatus == GlobalParams.WorkFlowStatus_Approved && nextLevelGrCode > 0)
    //        {
    //            string NextStatus = GlobalParams.WorkFlowStatus_Waiting + "~" + Convert.ToString((roleLevel + 1));
    //            UpdateMaterialOrderStatus(recordCode, NextStatus, (SqlTransaction)objmoduleWFDtl.SqlTrans);
    //        }
    //        //3.--Approved by all level i.e. On completion Sets status 'A'--------
    //        else if (usrStatus == GlobalParams.WorkFlowStatus_Approved && nextLevelGrCode == 0)
    //        {
    //            UpdateMaterialOrderStatus(recordCode, GlobalParams.WorkFlowStatus_Approved, (SqlTransaction)objmoduleWFDtl.SqlTrans);
    //        }
    //        //4.--On Rejection Sets status 'R~RoleLevel'--------------------------
    //        else if (usrStatus == GlobalParams.WorkFlowStatus_Declined)
    //        {
    //            string currentStatus = GlobalParams.WorkFlowStatus_Declined + "~" + roleLevel;
    //            new ModuleWorkFlowDetail().UpdateWorkflowDetailOnRejection(moduleCode, recordCode, (SqlTransaction)objmoduleWFDtl.SqlTrans);
    //            UpdateMaterialOrderStatus(recordCode, currentStatus, (SqlTransaction)objmoduleWFDtl.SqlTrans);
    //        }

    //        string userHistorySatus = usrStatus;
    //        if (usrStatus != GlobalParams.WorkFlowStatus_SendForAuth)
    //        {
    //            userHistorySatus = usrStatus + "~" + roleLevel;
    //        }
    //        ModuleStatusHistory objModStatusHist = new ModuleStatusHistory();
    //        objModStatusHist.objModule.IntCode = moduleCode;
    //        objModStatusHist.recordCode = recordCode;
    //        objModStatusHist.status = userHistorySatus;
    //        objModStatusHist.objStatusChangedBy.IntCode = userCode;
    //        objModStatusHist.remarks = strRemarks;
    //        objModStatusHist.IsTransactionRequired = true;
    //        objModStatusHist.IsProxy = true;
    //        objModStatusHist.SqlTrans = objmoduleWFDtl.SqlTrans;
    //        objModStatusHist.IsEndOfTrans = true;
    //        objModStatusHist.Save();

    //        if (dsWFDtl.Tables[0].Rows[0]["next_level_group"] != DBNull.Value && usrStatus != GlobalParams.WorkFlowStatus_Declined)
    //        {
    //            isMailSent = sendMailToNextUser(obj, moduleCode, recordCode, nextLevelGrCode, "", null, usrStatus);
    //        }
    //    }
    //    return isMailSent;
    //}

    //private void UpdateMaterialOrderStatus(string updTblName,string updColName,string updPrimColName,int recordCode, string currOrderStatus, SqlTransaction sqlTrans)
    //{
    //    string sql = "UPDATE "+ updTblName +" SET "+ updColName +"='" + currOrderStatus + "' WHERE "+ updPrimColName +"=" + recordCode;
    //    if (sqlTrans != null)
    //    {
    //        ProcessNonQuery(sql, false, ref sqlTrans);
    //    }
    //    else
    //    {
    //        ProcessNonQuery(sql, false);
    //    }
    //}
    public void UpdateWorkflowDetailOnRejection(int moduleCode, int recordCode, SqlTransaction sqlTrans)
    {
        string sql = "UPDATE Module_Workflow_Detail SET is_done='N' WHERE " +
                   "module_code=" + moduleCode + " AND record_code=" + recordCode;
        if (sqlTrans != null)
        {
            ProcessNonQuery(sql, false, ref sqlTrans);
        }
        else
        {
            ProcessNonQuery(sql, false);
        }
    }

    public int getDeleteWorkFlowModuleDetails(int moduleCode, int recordCode, SqlTransaction sqlTrans)
    {
        string sql = "DELETE FROM Module_Workflow_Detail WHERE module_code=" + moduleCode
                    + " AND record_code=" + recordCode;
        int res;
        try
        {
            if (sqlTrans != null)
            {
                res = ProcessNonQuery(sql, false, ref sqlTrans);
            }
            else
            {
                res = ProcessNonQuery(sql, false);
            }
        }
        catch (SqlException ex)
        {
            throw ex;
        }
        return res;
    }

}
