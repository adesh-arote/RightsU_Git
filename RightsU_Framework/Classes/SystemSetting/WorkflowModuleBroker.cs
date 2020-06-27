using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for WorkflowModuleBroker
/// </summary>
public class WorkflowModuleBroker:DatabaseBroker
{
	public WorkflowModuleBroker()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;

        //WorkflowModule objWrkflowMod = (WorkflowModule)obj;
        //strMessage = "Can not delete this record, reference exists";
        //bool res = !DBUtil.HasRecords(myConnection, "Module_Workflow_Detail", "module_code", Convert.ToString(objWrkflowMod.objSysModule.IntCode));
        //return res;

    }

    public override bool CheckDuplicate(Persistent obj)
    {
        //WorkflowModule objWorkflowMod = (WorkflowModule)obj;
        //SqlTransaction sqlTrans1 = (SqlTransaction)objWorkflowMod.SqlTrans;
        //string strSql = "select count (*) from Workflow_Module where module_code =" + objWorkflowMod.objSysModule.IntCode + " and system_end_date is null and workflow_module_code <> " + objWorkflowMod.IntCode;
        //int recCount = 0;
        //if (objWorkflowMod.IsTransactionRequired)
        //    recCount = Convert.ToInt32(ProcessScalar(strSql, ref sqlTrans1));
        //else
        //    recCount = Convert.ToInt32(ProcessScalar(strSql));
        //if (recCount > 0)
        //{
        //    objWorkflowMod.IsEndOfTrans = true;
        //    throw new DuplicateRecordException("This module is already assigned a workflow");
        //    return true;
        //}
        //else
            return false;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return "select count(*) from Workflow_Module where workflow_module_code > 0" + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        WorkflowModule objWrkFlwModule = (WorkflowModule)obj;
        return "Delete from Workflow_Module where workflow_module_code = " + objWrkFlwModule.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        WorkflowModule objWrkFlwModule = (WorkflowModule)obj;        
        string tempEffStartDate = "";
        string tempSysEndDate = "";
        if ((objWrkFlwModule.effStartDate == "") || (objWrkFlwModule.effStartDate == null))        
            tempEffStartDate = "null";        
        else        
            tempEffStartDate = "'" + GlobalUtil.MakedateFormat(objWrkFlwModule.effStartDate) + "'";

        if ((objWrkFlwModule.sysEndDate == "")||(objWrkFlwModule.sysEndDate == null))        
            tempSysEndDate = "null";        
        else
            tempSysEndDate = "'" + GlobalUtil.MakedateFormat(objWrkFlwModule.sysEndDate) + "'";

        string strSql = "insert into Workflow_Module (workflow_code,module_code,ideal_process_days,effective_start_date,system_end_date,is_active,last_action_by,Business_Unit_Code ) values (" + objWrkFlwModule.Workflow_Code
                         + "," + objWrkFlwModule.moduleCode
                         + "," + objWrkFlwModule.idealProcessDays
                         + "," + tempEffStartDate
                         + "," + tempSysEndDate
                         + ",'" + objWrkFlwModule.isWrkFlwActive
                         + "'," + objWrkFlwModule.LastUpdatedBy
                         +","+ objWrkFlwModule.Business_Unit_Code
                         + ")";
        return strSql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = " ";
        if (!objCriteria.IsPagingRequired)
            sql = "Select * from Workflow_Module where workflow_module_code > 0  " + strSearchString + " order by " + objCriteria.getASCstr();
        else
        {
            int p1 = objCriteria.GetPagingP1();
            int p2 = objCriteria.GetPagingP2();
            sql = "select * from ( Select Top " + p1 + " * From (SELECT TOP " + p2 + " * from Workflow_Module where workflow_module_code > 0"
                + strSearchString + "  Order By "
                + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition
                + ") As a1 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByReverseCondition
                + " ) as a3 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition;


        }
        return sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        WorkflowModule objWrkFlwModule = (WorkflowModule)obj;
        string strSql = "Select * from Workflow_Module where workflow_module_code = " + objWrkFlwModule.IntCode;
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        WorkflowModule objWrkFlwModule = (WorkflowModule)obj;
        string tempEffStartDate = "";
        string tempSysEndDate = "";
        if ((objWrkFlwModule.effStartDate == "")|| (objWrkFlwModule.effStartDate == null))
            tempEffStartDate = "null";
        else
            tempEffStartDate = "'" + GlobalUtil.MakedateFormat(objWrkFlwModule.effStartDate) + "'";

        if ((objWrkFlwModule.sysEndDate == "") || (objWrkFlwModule.sysEndDate == null))
            tempSysEndDate = "null";
        else
            tempSysEndDate = "'" + GlobalUtil.MakedateFormat(objWrkFlwModule.sysEndDate) + "'";

        string strSql = "update Workflow_Module set workflow_code = " + objWrkFlwModule.objWorkflow.IntCode
                       + ",module_code=" + objWrkFlwModule.objSysModule.IntCode
                       + ",ideal_process_days=" + objWrkFlwModule.idealProcessDays
                       + ",effective_start_date=" + tempEffStartDate
                       + ",system_end_date=" + tempSysEndDate
                       + ",is_active='" + objWrkFlwModule.isWrkFlwActive
                       + "',lock_time=null,last_updated_time=getdate(),last_action_by=" + objWrkFlwModule.LastUpdatedBy
                       + " ,Business_Unit_Code = " + objWrkFlwModule.Business_Unit_Code
                       + " where workflow_module_code = " + objWrkFlwModule.IntCode;
        return strSql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        WorkflowModule objWrkFlwModule;
        if (obj == null)
        {
            objWrkFlwModule = new WorkflowModule();
        }
        else
        {
            objWrkFlwModule = (WorkflowModule)obj;
        }
        objWrkFlwModule.IntCode = Convert.ToInt32(dRow["workflow_module_code"]);
        objWrkFlwModule.objWorkflow.IntCode = Convert.ToInt32(dRow["workflow_code"]);
        objWrkFlwModule.objSysModule.IntCode = Convert.ToInt32(dRow["module_code"]);
        objWrkFlwModule.moduleCode = Convert.ToInt32(dRow["module_code"]); 

        objWrkFlwModule.idealProcessDays = Convert.ToInt32(dRow["ideal_process_days"]);

        if (dRow["effective_start_date"] == DBNull.Value)
            objWrkFlwModule.effStartDate = "";
        else
        {
            DateTime tempEffStartDate = Convert.ToDateTime(dRow["effective_start_date"]);
            objWrkFlwModule.effStartDate = tempEffStartDate.ToString("dd/MM/yyyy");
        }
        if (dRow["system_end_date"] == DBNull.Value)
            objWrkFlwModule.sysEndDate = "";
        else
        {
            DateTime tempSysEndDate = Convert.ToDateTime(dRow["system_end_date"]);
            objWrkFlwModule.sysEndDate = tempSysEndDate.ToString("dd/MM/yyyy");
        }
        objWrkFlwModule.isWrkFlwActive = Convert.ToChar(dRow["is_active"]);        

        if (dRow["lock_time"] != DBNull.Value)
            objWrkFlwModule.LockTime = Convert.ToString(dRow["lock_time"]);

        if (dRow["last_updated_time"] != DBNull.Value)
            objWrkFlwModule.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);

         if (dRow["Workflow_Code"] != DBNull.Value)
             objWrkFlwModule.Workflow_Code = Convert.ToInt32(dRow["Workflow_Code"]);

         if (dRow["Business_Unit_Code"] != DBNull.Value)
             objWrkFlwModule.Business_Unit_Code = Convert.ToInt32(dRow["Business_Unit_Code"]);

        return objWrkFlwModule;
    }
    override public string getRecordStatus(Persistent obj, out int userCode)
    {
        return DBUtil.GetRecordStatus(myConnection, obj, "Workflow_Module", "workflow_module_code", out userCode);
    }

    override public void unlockRecord(Persistent obj)
    {
        DBUtil.RefreshOrUnlockRecord(myConnection, obj, "Workflow_Module", "workflow_module_code", false);
    }

    override public void refreshRecord(Persistent obj)
    {
        DBUtil.RefreshOrUnlockRecord(myConnection, obj, "Workflow_Module", "workflow_module_code", true);
    }

    internal void DeleteChildHistory(int wrkFlwModCode, ref SqlTransaction objTrans, string workflowType)
    {
        //string strSql = "delete  from Workflow_Module_Role where workflow_module_code=" + wrkFlwModCode + " delete from Workflow_Module where workflow_module_code=" + wrkFlwModCode;

        string strSql = " delete from Workflow_Module_BU_Role where Workflow_Module_BU_Code in( select Workflow_Module_BU_Code from Workflow_Module_BU "
                            + " where Workflow_Module_Code in ( " + wrkFlwModCode + ") )"
                            + " delete  from Workflow_Module_BU where Workflow_Module_Code in ( " + wrkFlwModCode + ") "
                            + " delete  from Workflow_Module_Role where workflow_module_code = " + wrkFlwModCode + ""
                            + " delete  from Workflow_Module where Workflow_Module_Code in ( " + wrkFlwModCode + ")";
        //int rowAffected = this.ProcessNonQuery(strSql, false, ref objTrans);
        if (workflowType == "F")
        {
            int rowAffected = 0;
            if (objTrans != null)
                rowAffected = this.ProcessNonQuery(strSql, false, ref objTrans);
            else
                rowAffected = this.ProcessNonQuery(strSql, false);
        }
        else
        {
            int rowAffected = this.ProcessNonQuery(strSql, false);
        }
    }

    internal bool IsWorkFlowAssignForModule(int moduleCode) {
        return DBUtil.HasRecords(myConnection, "Workflow_Module", "module_code", moduleCode.ToString());
    }

    /// <summary>
    /// workFlowCode =-1 ----No WorkFlow attached till Creation Date
    /// workFlowCode = 0 ----Deal has no ACTIVE workFlow on the Current Date
    /// workFlowCode > 0 ----workflow code 
    /// </summary>
    /// <param name="moduleCode"></param>
    /// <param name="dealDate"></param>
    /// <returns></returns>
    public int getEffeciveWorkFlowCode(int moduleCode,string checkDate)
    {
        string sql = "SELECT dbo.fn_GetEffectiveWorkFlowCode(" + moduleCode + ",'" + checkDate + "')";
        int workFlowCode = (int)ProcessScalar(sql);
        return workFlowCode;
    }

    internal bool IsWorkFlowAssignForModuleGroup(int moduleCode, int groupCode) {
        string sql;
        sql = "SELECT count(*) as c FROM Workflow_Module WM INNER JOIN Workflow_Module_Role WMR ON WMR.workflow_module_code = WM.workflow_module_code "
            + "WHERE module_code = " + moduleCode + " AND group_code = " + groupCode + " ";
        return DBUtil.GetCountForSQL(myConnection, sql) > 0;
    }
    public string getWorkflowType(int Workflow_Code)
    {
        string sql = "select Workflow_Type from Workflow  where Workflow_Code = " + Workflow_Code + "";
        string WType = DatabaseBroker.ProcessScalarReturnString(sql);
        return WType;
    }
}
