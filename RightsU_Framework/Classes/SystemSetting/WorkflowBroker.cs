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
/// Summary description for WorkflowBroker
/// </summary>
public class WorkflowBroker: DatabaseBroker
{
	public WorkflowBroker()
	{
        
	}

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Workflow objWorkflow = (Workflow)obj;
        SqlTransaction sqlTrans1 = (SqlTransaction)objWorkflow.SqlTrans;
        string strSql = "select count (*) from Workflow where workflow_name ='" + objWorkflow.workflowName.Trim().Replace("'", "''") + "' and workflow_code <> " + objWorkflow.IntCode;
        int recCount = 0;
        if (objWorkflow.IsTransactionRequired)
            recCount = Convert.ToInt32(ProcessScalar(strSql, ref sqlTrans1));
        else
            recCount = Convert.ToInt32(ProcessScalar(strSql));
        if (recCount > 0)
        {
            objWorkflow.IsEndOfTrans = true;
            throw new DuplicateRecordException("Approval Workflow" + " Name " + "already exists");
            return true;
        }
        else
            return false;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return "select count(*) from Workflow where workflow_code > 0" + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Workflow objWorkflow = (Workflow)obj;
        return "Delete from Workflow where workflow_code = " + objWorkflow.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        Workflow objWorkflow = (Workflow)obj;
        string strSql = "insert into Workflow (workflow_name,remarks,last_action_by, Workflow_Type, Lock_Time,Last_Updated_Time,Business_Unit_Code ) " +
            " values (N'" + objWorkflow.workflowName.Trim().Replace("'", "''") + "',N'" + objWorkflow.remarks.Trim().Replace("'", "''") + 
            "'," + objWorkflow.LastUpdatedBy + ",'" + objWorkflow.Workflow_Type + "',null,null," + objWorkflow.Business_Unit_Code + ")";
        return strSql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = " ";
        if (!objCriteria.IsPagingRequired)
            sql = "Select * from Workflow where workflow_code > 0  " + strSearchString + " ORDER BY workflow_name asc";
        else
        {
            int p1 = objCriteria.GetPagingP1();
            int p2 = objCriteria.GetPagingP2();
            sql = "select * from ( Select Top " + p1 + " * From (SELECT TOP " + p2 + " * from Workflow where workflow_code > 0"
                + strSearchString + "  Order By "
                + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition
                + ") As a1 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByReverseCondition
                + " ) as a3 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition;


        }
        return sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        Workflow objWorkflow = (Workflow)obj;
        string strSql = "Select * from Workflow where workflow_code = " + objWorkflow.IntCode;
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Workflow objWorkflow = (Workflow)obj;
        string strSql = "update Workflow set workflow_name = N'" + objWorkflow.workflowName.Trim().Replace("'", "''")
                       + "',remarks=N'" + objWorkflow.remarks.Trim().Replace("'", "''")
                       + "',lock_time=null,last_updated_time=getdate(),last_action_by=" + objWorkflow.LastUpdatedBy
                       + ", Workflow_Type = '" + objWorkflow.Workflow_Type
                       + "', Business_Unit_Code = " + objWorkflow.Business_Unit_Code
                       + " where workflow_code = " + objWorkflow.IntCode;
        return strSql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Workflow objWorkflow;
        if (obj == null)
        {
            objWorkflow = new Workflow();
        }
        else
        {
            objWorkflow = (Workflow)obj;
        }
        objWorkflow.IntCode = Convert.ToInt32(dRow["workflow_code"]);
        objWorkflow.workflowName = Convert.ToString(dRow["workflow_name"]);
        objWorkflow.remarks = Convert.ToString(dRow["remarks"]);        

        if (dRow["lock_time"] != DBNull.Value)
            objWorkflow.LockTime = Convert.ToString(dRow["lock_time"]);

        if (dRow["last_updated_time"] != DBNull.Value)
            objWorkflow.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);

        if (dRow["Workflow_Type"] != DBNull.Value)
            objWorkflow.Workflow_Type = Convert.ToChar(dRow["Workflow_Type"]);

        if (dRow["Last_Action_By"] != DBNull.Value)
            objWorkflow.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);

        if (dRow["Lock_Time"] != DBNull.Value)
            objWorkflow.LockTime = Convert.ToString(dRow["Lock_Time"]);

        if (dRow["Business_Unit_Code"] != DBNull.Value)
            objWorkflow.Business_Unit_Code = Convert.ToInt32(dRow["Business_Unit_Code"]);

        return objWorkflow;
    }
    override public string getRecordStatus(Persistent obj, out int userCode)
    {
        return DBUtil.GetRecordStatus(myConnection, obj, "Workflow", "workflow_code", out userCode);
    }

    override public void unlockRecord(Persistent obj)
    {
        DBUtil.RefreshOrUnlockRecord(myConnection, obj, "Workflow", "workflow_code", false);
    }

    override public void refreshRecord(Persistent obj)
    {
        DBUtil.RefreshOrUnlockRecord(myConnection, obj, "Workflow", "workflow_code", true);
    }

    internal bool UsedInAssignWrkFlw(int workFlowCode)
    {
        string strSql = "select count(*) from Workflow_Module where workflow_code=" + workFlowCode;
        int resCount = (int)ProcessScalar(strSql);
        if (resCount > 0)
            return true;
        else
            return false;        
    }

    internal string GetSecGrpName(int moduleCode, int workFlowCode, int appRightCode)
    {
        string strSql = "select dbo.fn_CheckWFForApproval(" + workFlowCode + "," + moduleCode + "," + appRightCode + ")";
        string res = Convert.ToString(ProcessScalar(strSql));
        return res;    
    }
}
