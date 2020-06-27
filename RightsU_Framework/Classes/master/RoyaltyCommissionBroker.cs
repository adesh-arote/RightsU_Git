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
using System.Data.SqlClient;

/// <summary>
/// Summary description for RoyaltyCommission
/// </summary>
public class RoyaltyCommissionBroker : DatabaseBroker
{
	public RoyaltyCommissionBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Royalty_Commission] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RoyaltyCommission objRoyaltyCommission;
		if (obj == null)
		{
			objRoyaltyCommission = new RoyaltyCommission();
		}
		else
		{
			objRoyaltyCommission = (RoyaltyCommission)obj;
		}

		objRoyaltyCommission.IntCode = Convert.ToInt32(dRow["royalty_commission_code"]);
		#region --populate--
		objRoyaltyCommission.RoyaltyCommissionName = Convert.ToString(dRow["royalty_commission_name"]);
		objRoyaltyCommission.Is_Active = Convert.ToString(dRow["is_active"]);
		if (dRow["inserted_on"] != DBNull.Value)
			objRoyaltyCommission.InsertedOn = Convert.ToString(dRow["inserted_on"]);
		if (dRow["inserted_by"] != DBNull.Value)
			objRoyaltyCommission.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
		if (dRow["lock_time"] != DBNull.Value)
            objRoyaltyCommission.LockTime = Convert.ToString(dRow["lock_time"]);
		if (dRow["last_updated_time"] != DBNull.Value)
            objRoyaltyCommission.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
		if (dRow["last_action_by"] != DBNull.Value)
			objRoyaltyCommission.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
		#endregion
		return objRoyaltyCommission;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        RoyaltyCommission objRoyaltyCommission = (RoyaltyCommission)obj;
        if(objRoyaltyCommission.IsTransactionRequired)
            return GlobalUtil.IsDuplicateSqlTrans(ref obj, "Royalty_Commission", "Royalty_Commission_name", Convert.ToString(objRoyaltyCommission.RoyaltyCommissionName), "royalty_commission_code", objRoyaltyCommission.IntCode, " Record Already Exits", "",true);
        else
            return GlobalUtil.IsDuplicate(myConnection, "Royalty_Commission", "Royalty_Commission_name", objRoyaltyCommission.RoyaltyCommissionName, "royalty_commission_code", objRoyaltyCommission.IntCode, " Record Already Exits", "");
        
    }

    public override string GetInsertSql(Persistent obj)
    {
		RoyaltyCommission objRoyaltyCommission = (RoyaltyCommission)obj;
		return "insert into [Royalty_Commission]([royalty_commission_name], [is_active], [inserted_on], [inserted_by], [lock_time], [last_updated_time], [last_action_by]) values('" + objRoyaltyCommission.RoyaltyCommissionName.Trim().Replace("'", "''") + "',  '" + objRoyaltyCommission.Is_Active + "', GetDate(), '" + objRoyaltyCommission.InsertedBy + "',  Null, GetDate(), '" + objRoyaltyCommission.InsertedBy + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		RoyaltyCommission objRoyaltyCommission = (RoyaltyCommission)obj;
		return "update [Royalty_Commission] set [royalty_commission_name] = '" + objRoyaltyCommission.RoyaltyCommissionName.Trim().Replace("'", "''") + "', [is_active] = '" + objRoyaltyCommission.Is_Active + "', [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '" + objRoyaltyCommission.LastActionBy + "' where royalty_commission_code = '" + objRoyaltyCommission.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		RoyaltyCommission objRoyaltyCommission = (RoyaltyCommission)obj;
		if (objRoyaltyCommission.arrRoyaltyCommissionDetails.Count > 0)
			DBUtil.DeleteChild("RoyaltyCommissionDetails", objRoyaltyCommission.arrRoyaltyCommissionDetails, objRoyaltyCommission.IntCode, (SqlTransaction)objRoyaltyCommission.SqlTrans);

		return " DELETE FROM [Royalty_Commission] WHERE royalty_commission_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        RoyaltyCommission objRoyaltyCommission = (RoyaltyCommission)obj;
    return "Update [Royalty_Commission] set Is_Active='" + objRoyaltyCommission.Is_Active + "',lock_time=null, last_updated_time= getdate() where royalty_commission_code = '" + objRoyaltyCommission.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [Royalty_Commission] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [Royalty_Commission] WHERE  royalty_commission_code = " + obj.IntCode;
    }  
}
