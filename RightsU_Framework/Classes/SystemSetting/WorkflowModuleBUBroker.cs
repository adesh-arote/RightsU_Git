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
/// Summary description for WorkflowModuleBU
/// </summary>
public class WorkflowModuleBUBroker : DatabaseBroker
{
	public WorkflowModuleBUBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Workflow_Module_BU] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        WorkflowModuleBU objWorkflowModuleBU;
		if (obj == null)
		{
			objWorkflowModuleBU = new WorkflowModuleBU();
		}
		else
		{
			objWorkflowModuleBU = (WorkflowModuleBU)obj;
		}

		objWorkflowModuleBU.IntCode = Convert.ToInt32(dRow["Workflow_Module_BU_Code"]);
		#region --populate--
		if (dRow["Workflow_Module_Code"] != DBNull.Value)
			objWorkflowModuleBU.WorkflowModuleCode = Convert.ToInt32(dRow["Workflow_Module_Code"]);
		if (dRow["Workflow_BU_Code"] != DBNull.Value)
			objWorkflowModuleBU.WorkflowBUCode = Convert.ToInt32(dRow["Workflow_BU_Code"]);
		if (dRow["Business_Unit_Code"] != DBNull.Value)
			objWorkflowModuleBU.BusinessUnitCode = Convert.ToInt32(dRow["Business_Unit_Code"]);
		#endregion
		return objWorkflowModuleBU;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		WorkflowModuleBU objWorkflowModuleBU = (WorkflowModuleBU)obj;
		string sql= "insert into [Workflow_Module_BU]([Workflow_Module_Code], [Workflow_BU_Code], [Business_Unit_Code] "
				+ ")  values "
				+ "('" + objWorkflowModuleBU.WorkflowModuleCode + "', '" + objWorkflowModuleBU.WorkflowBUCode + "', '" + objWorkflowModuleBU.BusinessUnitCode + "' "
				+ ")";
		return  sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		WorkflowModuleBU objWorkflowModuleBU = (WorkflowModuleBU)obj;
		string sql="update [Workflow_Module_BU] set [Workflow_Module_Code] = '" + objWorkflowModuleBU.WorkflowModuleCode + "' "
				+ ", [Workflow_BU_Code] = '" + objWorkflowModuleBU.WorkflowBUCode + "' "
				+ ", [Business_Unit_Code] = '" + objWorkflowModuleBU.BusinessUnitCode + "' "
				+ " where Workflow_Module_BU_Code = '" + objWorkflowModuleBU.IntCode + "'";
		return  sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		WorkflowModuleBU objWorkflowModuleBU = (WorkflowModuleBU)obj;

		string sql= " DELETE FROM [Workflow_Module_BU] WHERE Workflow_Module_BU_Code = " + obj.IntCode ;
		return  sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        WorkflowModuleBU objWorkflowModuleBU = (WorkflowModuleBU)obj;
		string sql= "Update [Workflow_Module_BU] set IsActive='" + objWorkflowModuleBU.Is_Active + "',lock_time=null, "
					+ " last_updated_time= getdate() where Workflow_Module_BU_Code = '" + objWorkflowModuleBU.IntCode + "'";
		return  sql;
    }

    public override string GetCountSql(string strSearchString)
    {
		string sql= " SELECT Count(*) FROM [Workflow_Module_BU] WHERE 1=1 " + strSearchString;
		return  sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		string sql= " SELECT * FROM [Workflow_Module_BU] WHERE  Workflow_Module_BU_Code = " + obj.IntCode;
		return  sql;
    }  
}
