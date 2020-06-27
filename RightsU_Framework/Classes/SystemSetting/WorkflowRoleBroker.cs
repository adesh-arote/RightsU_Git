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
/// Summary description for WorkflowRoleBroker
/// </summary>
public class WorkflowRoleBroker : DatabaseBroker
{
	public WorkflowRoleBroker()
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
        return false;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return "select count(*) from Workflow_Role where workflow_role_code > 0" + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        WorkflowRole objWorkflowRole = (WorkflowRole)obj;
        return "Delete from Workflow_Role where workflow_role_code = " + objWorkflowRole.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        WorkflowRole objWorkflowRole = (WorkflowRole)obj;
        string strSql = "insert into Workflow_Role (group_level,workflow_code,group_code,primary_user_code) values (" + objWorkflowRole.groupLevel + "," + objWorkflowRole.workflowCode + "," + objWorkflowRole.objSecurityGroup.IntCode + ",0)";
        return strSql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = " ";
        if (!objCriteria.IsPagingRequired)
            sql = "Select * from Workflow_Role where group_level > 0  " + strSearchString + " ORDER BY workflow_role_code asc";
        else
        {
            int p1 = objCriteria.GetPagingP1();
            int p2 = objCriteria.GetPagingP2();
            sql = "select * from ( Select Top " + p1 + " * From (SELECT TOP " + p2 + " * from Workflow_Role where workflow_role_code > 0"
                + strSearchString + "  Order By "
                + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition
                + ") As a1 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByReverseCondition
                + " ) as a3 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition;


        }
        return sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        WorkflowRole objWorkflowRole = (WorkflowRole)obj;
        string strSql = "Select * from Workflow_Role where workflow_role_code = " + objWorkflowRole.IntCode;
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        WorkflowRole objWorkflowRole = (WorkflowRole)obj;
        string strSql = "update Workflow_Role set group_level = " + objWorkflowRole.groupLevel
                       + ",workflow_code=" + objWorkflowRole.workflowCode
                       + ",group_code=" + objWorkflowRole.objSecurityGroup.IntCode
                       + ",primary_user_code = 0" 
                       + " where workflow_role_code = " + objWorkflowRole.IntCode;
        return strSql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        WorkflowRole objWorkflowRole;
        if (obj == null)
        {
            objWorkflowRole = new WorkflowRole();
        }
        else
        {
            objWorkflowRole = (WorkflowRole)obj;
        }
        objWorkflowRole.IntCode = Convert.ToInt32(dRow["workflow_role_code"]);
        objWorkflowRole.groupLevel = Convert.ToInt32(dRow["group_level"]);
        objWorkflowRole.workflowCode = Convert.ToInt32(dRow["workflow_code"]);
        objWorkflowRole.objSecurityGroup.IntCode = Convert.ToInt32(dRow["group_code"]);
        if (objWorkflowRole.objSecurityGroup.IntCode > 0)
        {
            objWorkflowRole.objSecurityGroup.Fetch();
            objWorkflowRole.groupName = objWorkflowRole.objSecurityGroup.securitygroupname;
        }
        objWorkflowRole.objPrimaryUser.IntCode = Convert.ToInt32(dRow["primary_user_code"]);
        if (objWorkflowRole.objPrimaryUser.IntCode > 0)
        {
            objWorkflowRole.objPrimaryUser.Fetch();
            objWorkflowRole.userName = objWorkflowRole.objPrimaryUser.firstName;
        }

        return objWorkflowRole;
    }

    public DataSet getWorkFlow_NextGroupCode(int wfcode, int currentLevel)
    {
        string sql = "SELECT TOP 1 * FROM Workflow_Role WHERE workflow_code=" + wfcode
                   + " AND group_level > " + currentLevel + " ORDER BY group_level";
        DataSet ds = ProcessSelectDirectly(sql);
        return ds;
    }
}
