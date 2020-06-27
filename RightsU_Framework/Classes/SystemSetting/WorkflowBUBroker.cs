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
/// Summary description for WorkflowBU
/// </summary>
public class WorkflowBUBroker : DatabaseBroker
{
	public WorkflowBUBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Workflow_BU] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        WorkflowBU objWorkflowBU;
		if (obj == null)
		{
			objWorkflowBU = new WorkflowBU();
		}
		else
		{
			objWorkflowBU = (WorkflowBU)obj;
		}

		objWorkflowBU.IntCode = Convert.ToInt32(dRow["Workflow_BU_Code"]);
		#region --populate--
		if (dRow["Workflow_Code"] != DBNull.Value)
			objWorkflowBU.WorkflowCode = Convert.ToInt32(dRow["Workflow_Code"]);
		if (dRow["Business_Unit_Code"] != DBNull.Value)
			objWorkflowBU.BusinessUnitCode = Convert.ToInt32(dRow["Business_Unit_Code"]);
		#endregion
		return objWorkflowBU;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		WorkflowBU objWorkflowBU = (WorkflowBU)obj;
		string sql= "insert into [Workflow_BU]([Workflow_Code], [Business_Unit_Code])  values "
				+ "('" + objWorkflowBU.WorkflowCode + "', '" + objWorkflowBU.BusinessUnitCode + "')";
		return  sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		WorkflowBU objWorkflowBU = (WorkflowBU)obj;
		string sql="update [Workflow_BU] set [Workflow_Code] = '" + objWorkflowBU.WorkflowCode + "' "
				+ ", [Business_Unit_Code] = '" + objWorkflowBU.BusinessUnitCode + "' "
				+ " where Workflow_BU_Code = '" + objWorkflowBU.IntCode + "'";
		return  sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		WorkflowBU objWorkflowBU = (WorkflowBU)obj;

		string sql= " DELETE FROM [Workflow_BU] WHERE Workflow_BU_Code = " + obj.IntCode ;
		return  sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        WorkflowBU objWorkflowBU = (WorkflowBU)obj;
		string sql= "Update [Workflow_BU] set IsActive='" + objWorkflowBU.Is_Active + "',lock_time=null, "
					+ " last_updated_time= getdate() where Workflow_BU_Code = '" + objWorkflowBU.IntCode + "'";
		return  sql;
    }

    public override string GetCountSql(string strSearchString)
    {
		string sql= " SELECT Count(*) FROM [Workflow_BU] WHERE 1=1 " + strSearchString;
		return  sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		string sql= " SELECT * FROM [Workflow_BU] WHERE  Workflow_BU_Code = " + obj.IntCode;
		return  sql;
    }  
}
