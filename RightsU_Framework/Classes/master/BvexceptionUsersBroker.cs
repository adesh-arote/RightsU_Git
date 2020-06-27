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
/// Summary description for BvexceptionUsers
/// </summary>
public class BvexceptionUsersBroker : DatabaseBroker
{
	public BvexceptionUsersBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [BVException_Users] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        BvexceptionUsers objBvexceptionUsers;
		if (obj == null)
		{
			objBvexceptionUsers = new BvexceptionUsers();
		}
		else
		{
			objBvexceptionUsers = (BvexceptionUsers)obj;
		}

		objBvexceptionUsers.IntCode = Convert.ToInt32(dRow["bv_exception_users_code"]);
		#region --populate--
		if (dRow["bv_exception_code"] != DBNull.Value)
			objBvexceptionUsers.BvExceptionCode = Convert.ToInt32(dRow["bv_exception_code"]);
		if (dRow["users_code"] != DBNull.Value)
			objBvexceptionUsers.UsersCode = Convert.ToInt32(dRow["users_code"]);
		#endregion
		return objBvexceptionUsers;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		BvexceptionUsers objBvexceptionUsers = (BvexceptionUsers)obj;
		string sql = "insert into [BVException_Users]([bv_exception_code], [users_code]) values('" + objBvexceptionUsers.BvExceptionCode + "', '" 
            + objBvexceptionUsers.UsersCode + "');";
        return sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		BvexceptionUsers objBvexceptionUsers = (BvexceptionUsers)obj;
		string sql = "update [BVException_Users] set [bv_exception_code] = '" + objBvexceptionUsers.BvExceptionCode + "', [users_code] = '" 
            + objBvexceptionUsers.UsersCode + "' where bv_exception_users_code = '" + objBvexceptionUsers.IntCode + "';";
        return sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		BvexceptionUsers objBvexceptionUsers = (BvexceptionUsers)obj;

		return " DELETE FROM [BVException_Users] WHERE bv_exception_users_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        BvexceptionUsers objBvexceptionUsers = (BvexceptionUsers)obj;
        return "Update [BVException_Users] set Is_Active='" + objBvexceptionUsers.Is_Active 
        + "',lock_time=null, last_updated_time= getdate() where bv_exception_users_code = '" + objBvexceptionUsers.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [BVException_Users] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [BVException_Users] WHERE  bv_exception_users_code = " + obj.IntCode;
    }  
}
