using System;
using System.Data;
using System.Configuration;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for WorkflowBURole
/// </summary>
public class WorkflowBURoleBroker : DatabaseBroker
{
	public WorkflowBURoleBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Workflow_BU_Role] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        WorkflowBURole objWorkflowBURole;
		if (obj == null)
		{
			objWorkflowBURole = new WorkflowBURole();
		}
		else
		{
			objWorkflowBURole = (WorkflowBURole)obj;
		}

		objWorkflowBURole.IntCode = Convert.ToInt32(dRow["Workflow_BU_Role_Code"]);
		#region --populate--
		//objWorkflowBURole.GroupLevel = Convert.ToString(dRow["Group_Level"]);
        objWorkflowBURole.GroupLevel = Convert.ToInt32(dRow["Group_Level"]);
		if (dRow["Workflow_BU_Code"] != DBNull.Value)
			objWorkflowBURole.WorkflowBUCode = Convert.ToInt32(dRow["Workflow_BU_Code"]);
		if (dRow["Security_Group_Code"] != DBNull.Value)
			objWorkflowBURole.SecurityGroupCode = Convert.ToInt32(dRow["Security_Group_Code"]);


        if (objWorkflowBURole.SecurityGroupCode > 0)
        {
            objWorkflowBURole.objSecurityGroup.IntCode = objWorkflowBURole.SecurityGroupCode;
            objWorkflowBURole.objSecurityGroup.Fetch();
            objWorkflowBURole.groupName = objWorkflowBURole.objSecurityGroup.securitygroupname;
        }
		#endregion
		return objWorkflowBURole;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		WorkflowBURole objWorkflowBURole = (WorkflowBURole)obj;
		string sql= "insert into [Workflow_BU_Role]([Group_Level], [Workflow_BU_Code], [Security_Group_Code] "
				+ ")  values "
				+ "(" + objWorkflowBURole.GroupLevel+ ", '" + objWorkflowBURole.WorkflowBUCode + "', '" + objWorkflowBURole.SecurityGroupCode + "' "
				+ ")";
		return  sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		WorkflowBURole objWorkflowBURole = (WorkflowBURole)obj;
		string sql="update [Workflow_BU_Role] set [Group_Level] = " + objWorkflowBURole.GroupLevel + ""
				+ ", [Workflow_BU_Code] = '" + objWorkflowBURole.WorkflowBUCode + "' "
				+ ", [Security_Group_Code] = '" + objWorkflowBURole.SecurityGroupCode + "' "
				+ " where Workflow_BU_Role_Code = '" + objWorkflowBURole.IntCode + "'";
		return  sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		WorkflowBURole objWorkflowBURole = (WorkflowBURole)obj;

		string sql= " DELETE FROM [Workflow_BU_Role] WHERE Workflow_BU_Role_Code = " + obj.IntCode ;
		return  sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        WorkflowBURole objWorkflowBURole = (WorkflowBURole)obj;
		string sql= "Update [Workflow_BU_Role] set IsActive='" + objWorkflowBURole.Is_Active + "',lock_time=null, "
					+ " last_updated_time= getdate() where Workflow_BU_Role_Code = '" + objWorkflowBURole.IntCode + "'";
		return  sql;
    }

    public override string GetCountSql(string strSearchString)
    {
		string sql= " SELECT Count(*) FROM [Workflow_BU_Role] WHERE 1=1 " + strSearchString;
		return  sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		string sql= " SELECT * FROM [Workflow_BU_Role] WHERE  Workflow_BU_Role_Code = " + obj.IntCode;
		return  sql;
    }  
}
