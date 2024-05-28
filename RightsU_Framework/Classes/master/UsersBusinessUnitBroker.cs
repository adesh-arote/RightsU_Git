using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for UsersBusinessUnit
/// </summary>
public class UsersBusinessUnitBroker : DatabaseBroker
{
	public UsersBusinessUnitBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Users_Business_Unit] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        UsersBusinessUnit objUsersBusinessUnit;
		if (obj == null)
		{
			objUsersBusinessUnit = new UsersBusinessUnit();
		}
		else
		{
			objUsersBusinessUnit = (UsersBusinessUnit)obj;
		}

		objUsersBusinessUnit.IntCode = Convert.ToInt32(dRow["Users_Business_Unit_code"]);
		#region --populate--
		if (dRow["Users_Code"] != DBNull.Value)
			objUsersBusinessUnit.UsersCode = Convert.ToInt32(dRow["Users_Code"]);
		if (dRow["Business_Unit_code"] != DBNull.Value)
			objUsersBusinessUnit.BusinessUnitCode = Convert.ToInt32(dRow["Business_Unit_code"]);
		#endregion
		return objUsersBusinessUnit;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		UsersBusinessUnit objUsersBusinessUnit = (UsersBusinessUnit)obj;
		string sql= "insert into [Users_Business_Unit]([Users_Code], [Business_Unit_code])  values "
				+ "('" + objUsersBusinessUnit.UsersCode + "', '" + objUsersBusinessUnit.BusinessUnitCode + "')";
		return  sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		UsersBusinessUnit objUsersBusinessUnit = (UsersBusinessUnit)obj;
		string sql="update [Users_Business_Unit] set [Users_Code] = '" + objUsersBusinessUnit.UsersCode + "' "
				+ ", [Business_Unit_code] = '" + objUsersBusinessUnit.BusinessUnitCode + "' "
				+ " where Users_Business_Unit_code = '" + objUsersBusinessUnit.IntCode + "'";
		return  sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		UsersBusinessUnit objUsersBusinessUnit = (UsersBusinessUnit)obj;

		string sql= " DELETE FROM [Users_Business_Unit] WHERE Users_Business_Unit_code = " + obj.IntCode ;
		return  sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetCountSql(string strSearchString)
    {
		string sql= " SELECT Count(*) FROM [Users_Business_Unit] WHERE 1=1 " + strSearchString;
		return  sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		string sql= " SELECT * FROM [Users_Business_Unit] WHERE  Users_Business_Unit_code = " + obj.IntCode;
		return  sql;
    }  
}
