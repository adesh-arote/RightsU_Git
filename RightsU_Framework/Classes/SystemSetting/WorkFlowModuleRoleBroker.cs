using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for WrkFlwModuleBroker
/// </summary>
public class WorkFlowModuleRoleBroker:DatabaseBroker
{
    public WorkFlowModuleRoleBroker()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        //Workflow objWorkflow = (Workflow)obj;
        //SqlTransaction sqlTrans1 = (SqlTransaction)objWorkflow.SqlTrans;
        //string strSql = "select count (*) from Workflow where workflow_name ='" + objWorkflow.workflowName.Trim().Replace("'", "''") + "' and workflow_code <> " + objWorkflow.IntCode;
        //int recCount = 0;
        //if (objWorkflow.IsTransactionRequired)
        //    recCount = Convert.ToInt32(ProcessScalar(strSql, ref sqlTrans1));
        //else
        //    recCount = Convert.ToInt32(ProcessScalar(strSql));
        //if (recCount > 0)
        //{
        //    objWorkflow.IsEndOfTrans = true;
        //    throw new DuplicateRecordException(System.Web.HttpContext.GetGlobalResourceObject("SRMS", "approvalWorkflow") + " Name " + System.Web.HttpContext.GetGlobalResourceObject("SRMS", "msgExists"));
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
        return "select count(*) from Workflow_Module_Role where workflow_module_role_code > 0" + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        WorkFlowModuleRole objWrkflwModRole = (WorkFlowModuleRole)obj;
        return "Delete from Workflow_Module_Role where workflow_module_role_code = " + objWrkflwModRole.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        WorkFlowModuleRole objWrkflwModRole = (WorkFlowModuleRole)obj;
        string strSql = "insert into Workflow_Module_Role (workflow_module_code,workflow_role_code,group_level,group_code,reminder_days) values (" + objWrkflwModRole.workflowModuleCode
                            + "," + objWrkflwModRole.objWorkflowRole.IntCode
                            + "," + objWrkflwModRole.groupLevel
                            + "," + objWrkflwModRole.objSecurityGroup.IntCode
                            + "," + objWrkflwModRole.reminderDays
                            + ")";
        return strSql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = " ";
        if (!objCriteria.IsPagingRequired)
            sql = "Select * from Workflow_Module_Role where workflow_module_role_code > 0  " + strSearchString + " order by " + objCriteria.getASCstr();
        else
        {
            int p1 = objCriteria.GetPagingP1();
            int p2 = objCriteria.GetPagingP2();
            sql = "select * from ( Select Top " + p1 + " * From (SELECT TOP " + p2 + " * from Workflow_Module_Role where workflow_module_role_code > 0"
                + strSearchString + "  Order By "
                + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition
                + ") As a1 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByReverseCondition
                + " ) as a3 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition;


        }
        return sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        WorkFlowModuleRole objWrkflwModRole = (WorkFlowModuleRole)obj;
        string strSql = "Select * from Workflow_Module_Role where workflow_module_role_code = " + objWrkflwModRole.IntCode;
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        WorkFlowModuleRole objWrkflwModRole = (WorkFlowModuleRole)obj;
        string strSql = "update Workflow_Module_Role set workflow_module_code = " + objWrkflwModRole.workflowModuleCode
                       + ",workflow_role_code=" + objWrkflwModRole.objWorkflowRole.IntCode
                       + ",group_level=" + objWrkflwModRole.groupLevel
                       + ",group_code=" + objWrkflwModRole.objSecurityGroup.IntCode
                       + ",reminder_days=" + objWrkflwModRole.reminderDays
                       + " where workflow_module_role_code = " + objWrkflwModRole.IntCode;
        return strSql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {

        WorkFlowModuleRole objWrkflwModRole;
        if (obj == null)
        {
            objWrkflwModRole = new WorkFlowModuleRole();
        }
        else
        {
            objWrkflwModRole = (WorkFlowModuleRole)obj;
        }
        objWrkflwModRole.IntCode = Convert.ToInt32(dRow["workflow_module_role_code"]);

        objWrkflwModRole.workflowModuleCode = Convert.ToInt32(dRow["workflow_module_code"]);
        objWrkflwModRole.objWorkflowRole.IntCode = Convert.ToInt32(dRow["workflow_role_code"]);
        objWrkflwModRole.groupLevel = Convert.ToInt32(dRow["group_level"]);
        objWrkflwModRole.objSecurityGroup.IntCode = Convert.ToInt32(dRow["group_code"]);
        objWrkflwModRole.reminderDays = Convert.ToInt32(dRow["reminder_days"]);

        return objWrkflwModRole;
    }
}
