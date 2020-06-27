using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for BusinessUnit
/// </summary>
public class BusinessUnitBroker : DatabaseBroker
{
	public BusinessUnitBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Business_Unit] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        BusinessUnit objBusinessUnit;
		if (obj == null)
		{
			objBusinessUnit = new BusinessUnit();
		}
		else
		{
			objBusinessUnit = (BusinessUnit)obj;
		}

		objBusinessUnit.IntCode = Convert.ToInt32(dRow["Business_Unit_code"]);
		#region --populate--
        objBusinessUnit.BusinessUnitName = Convert.ToString(dRow["Business_Unit_name"]);
        objBusinessUnit.IsActive = Convert.ToString(dRow["Is_Active"]);
		#endregion
		return objBusinessUnit;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		BusinessUnit objBusinessUnit = (BusinessUnit)obj;
		string sql= "insert into [Business_Unit]([Business_Unit_name])  values "
				+ "('" + objBusinessUnit.BusinessUnitName.Trim().Replace("'", "''") + "')";
		return  sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		BusinessUnit objBusinessUnit = (BusinessUnit)obj;
		string sql="update [Business_Unit] set [Business_Unit_name] = '" + objBusinessUnit.BusinessUnitName.Trim().Replace("'", "''") + "' "
				+ " where Business_Unit_code = '" + objBusinessUnit.IntCode + "'";
		return  sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		BusinessUnit objBusinessUnit = (BusinessUnit)obj;

		string sql= " DELETE FROM [Business_Unit] WHERE Business_Unit_code = " + obj.IntCode ;
		return  sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        BusinessUnit objBusinessUnit = (BusinessUnit)obj;
		string sql= "Update [Business_Unit] set IsActive='" + objBusinessUnit.IsActive + "',lock_time=null, "
					+ " last_updated_time= getdate() where Business_Unit_code = '" + objBusinessUnit.IntCode + "'";
		return  sql;
    }

    public override string GetCountSql(string strSearchString)
    {
		string sql= " SELECT Count(*) FROM [Business_Unit] WHERE 1=1 " + strSearchString;
		return  sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		string sql= " SELECT * FROM [Business_Unit] WHERE  Business_Unit_code = " + obj.IntCode;
		return  sql;
    }  
}
