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
/// Summary description for WorkflowModuleBURole
/// </summary>
public class WorkflowModuleBURoleBroker : DatabaseBroker
{
	public WorkflowModuleBURoleBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Workflow_Module_BU_Role] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        WorkflowModuleBURole objWorkflowModuleBURole;
		if (obj == null)
		{
			objWorkflowModuleBURole = new WorkflowModuleBURole();
		}
		else
		{
			objWorkflowModuleBURole = (WorkflowModuleBURole)obj;
		}

		objWorkflowModuleBURole.IntCode = Convert.ToInt32(dRow["Workflow_Module_BU_Role_Code"]);
		#region --populate--
		if (dRow["Workflow_Module_BU_Code"] != DBNull.Value)
			objWorkflowModuleBURole.WorkflowModuleBUCode = Convert.ToInt32(dRow["Workflow_Module_BU_Code"]);
		if (dRow["Workflow_BU_Role_Code"] != DBNull.Value)
			objWorkflowModuleBURole.WorkflowBURoleCode = Convert.ToInt32(dRow["Workflow_BU_Role_Code"]);
		objWorkflowModuleBURole.GroupLevel = Convert.ToString(dRow["Group_Level"]);
		if (dRow["Security_Group_Code"] != DBNull.Value)
			objWorkflowModuleBURole.SecurityGroupCode = Convert.ToInt32(dRow["Security_Group_Code"]);
		#endregion
		return objWorkflowModuleBURole;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		WorkflowModuleBURole objWorkflowModuleBURole = (WorkflowModuleBURole)obj;
		string sql= "insert into [Workflow_Module_BU_Role]([Workflow_Module_BU_Code], [Workflow_BU_Role_Code], [Group_Level] "
				+ ", [Security_Group_Code])  values "
				+ "('" + objWorkflowModuleBURole.WorkflowModuleBUCode + "', '" + objWorkflowModuleBURole.WorkflowBURoleCode + "', '" + objWorkflowModuleBURole.GroupLevel.Trim().Replace("'", "''") + "' "
				+ ", '" + objWorkflowModuleBURole.SecurityGroupCode + "')";
		return  sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		WorkflowModuleBURole objWorkflowModuleBURole = (WorkflowModuleBURole)obj;
		string sql="update [Workflow_Module_BU_Role] set [Workflow_Module_BU_Code] = '" + objWorkflowModuleBURole.WorkflowModuleBUCode + "' "
				+ ", [Workflow_BU_Role_Code] = '" + objWorkflowModuleBURole.WorkflowBURoleCode + "' "
				+ ", [Group_Level] = '" + objWorkflowModuleBURole.GroupLevel.Trim().Replace("'", "''") + "' "
				+ ", [Security_Group_Code] = '" + objWorkflowModuleBURole.SecurityGroupCode + "' "
				+ " where Workflow_Module_BU_Role_Code = '" + objWorkflowModuleBURole.IntCode + "'";
		return  sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		WorkflowModuleBURole objWorkflowModuleBURole = (WorkflowModuleBURole)obj;

		string sql= " DELETE FROM [Workflow_Module_BU_Role] WHERE Workflow_Module_BU_Role_Code = " + obj.IntCode ;
		return  sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        WorkflowModuleBURole objWorkflowModuleBURole = (WorkflowModuleBURole)obj;
		string sql= "Update [Workflow_Module_BU_Role] set IsActive='" + objWorkflowModuleBURole.Is_Active + "',lock_time=null, "
					+ " last_updated_time= getdate() where Workflow_Module_BU_Role_Code = '" + objWorkflowModuleBURole.IntCode + "'";
		return  sql;
    }

    public override string GetCountSql(string strSearchString)
    {
		string sql= " SELECT Count(*) FROM [Workflow_Module_BU_Role] WHERE 1=1 " + strSearchString;
		return  sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		string sql= " SELECT * FROM [Workflow_Module_BU_Role] WHERE  Workflow_Module_BU_Role_Code = " + obj.IntCode;
		return  sql;
    }  
}
