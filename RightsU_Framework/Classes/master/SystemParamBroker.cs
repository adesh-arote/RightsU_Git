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
/// Summary description for SystemParam
/// </summary>
public class SystemParamBroker : DatabaseBroker
{
	public SystemParamBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [system_parameter_new] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);
         
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        SystemParam objSystemParam;
		if (obj == null)
		{
			objSystemParam = new SystemParam();
		}
		else
		{
			objSystemParam = (SystemParam)obj;
		}

		objSystemParam.IntCode = Convert.ToInt32(dRow["id"]);
		#region --populate--
		objSystemParam.ParameterName = Convert.ToString(dRow["parameter_name"]);
		objSystemParam.ParameterValue = Convert.ToString(dRow["parameter_value"]);
      if (dRow["channel_Code"] != DBNull.Value)
         objSystemParam.ChannelCode = Convert.ToInt32(dRow["channel_Code"]);
      if (dRow["Type"] != DBNull.Value)
         objSystemParam.Type = Convert.ToString(dRow["Type"]);
      if (dRow["Last_Updated_Time"] != DBNull.Value)
          objSystemParam.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
		#endregion
		return objSystemParam;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		SystemParam objSystemParam = (SystemParam)obj;
        return "insert into [system_parameter_new]([parameter_name], [parameter_value],[Inserted_On], [Inserted_By], [Lock_Time] , [Last_Updated_Time],[Last_Action_By]) values('" 
            + objSystemParam.ParameterName.Trim().Replace("'", "''") + "', '" + objSystemParam.ParameterValue.Trim().Replace("'", "''")
            + "',GetDate(),'" + objSystemParam.InsertedBy + "',null,GetDate(),'" + objSystemParam.InsertedBy + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		SystemParam objSystemParam = (SystemParam)obj;
        return "update [system_parameter_new] set [parameter_name] = '" + objSystemParam.ParameterName.Trim().Replace("'", "''") + "',[Lock_Time] = Null, [Last_Updated_Time] = GetDate(), [Last_Action_By] = '" + objSystemParam.LastActionBy + "', [parameter_value] = '" + objSystemParam.ParameterValue.Trim().Replace("'", "''") + "' where id = '" + objSystemParam.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		SystemParam objSystemParam = (SystemParam)obj;

		return " DELETE FROM [system_parameter_new] WHERE id = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        SystemParam objSystemParam = (SystemParam)obj;
return "Update [system_parameter_new] set Is_Active='" + objSystemParam.Is_Active + "',lock_time=null, last_updated_time= getdate() where id = '" + objSystemParam.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [system_parameter_new] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [system_parameter_new] WHERE  id = " + obj.IntCode;
    }  
}
