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
/// Summary description for RoyaltyRecoupment
/// </summary>
public class RoyaltyRecoupmentBroker : DatabaseBroker
{
    public RoyaltyRecoupmentBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Royalty_Recoupment] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RoyaltyRecoupment objRoyaltyRecoupment;
        if (obj == null)
        {
            objRoyaltyRecoupment = new RoyaltyRecoupment();
        }
        else
        {
            objRoyaltyRecoupment = (RoyaltyRecoupment)obj;
        }

        objRoyaltyRecoupment.IntCode = Convert.ToInt32(dRow["royalty_recoupment_code"]);
        #region --populate--
        objRoyaltyRecoupment.RoyaltyRecoupmentName = Convert.ToString(dRow["royalty_recoupment_name"]);
        objRoyaltyRecoupment.Is_Active = Convert.ToString(dRow["is_active"]);
        if (dRow["inserted_on"] != DBNull.Value)
            objRoyaltyRecoupment.InsertedOn = Convert.ToString(dRow["inserted_on"]);
        if (dRow["inserted_by"] != DBNull.Value)
            objRoyaltyRecoupment.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
        if (dRow["lock_time"] != DBNull.Value)
            objRoyaltyRecoupment.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objRoyaltyRecoupment.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objRoyaltyRecoupment.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
        #endregion
        return objRoyaltyRecoupment;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        RoyaltyRecoupment objRoyaltyRecoupment = (RoyaltyRecoupment)obj;
        if (objRoyaltyRecoupment.IsTransactionRequired)     
            return GlobalUtil.IsDuplicateSqlTrans(ref obj, "Royalty_Recoupment", "Royalty_Recoupment_name", Convert.ToString(objRoyaltyRecoupment.RoyaltyRecoupmentName), "royalty_recoupment_code", objRoyaltyRecoupment.IntCode, " Record Already Exits", "", true);
        else
            return GlobalUtil.IsDuplicate(myConnection, "Royalty_Recoupment", "Royalty_Recoupment_name", objRoyaltyRecoupment.RoyaltyRecoupmentName, "royalty_recoupment_code", objRoyaltyRecoupment.IntCode, " Record Already Exits", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        RoyaltyRecoupment objRoyaltyRecoupment = (RoyaltyRecoupment)obj;
        return "insert into [Royalty_Recoupment]([royalty_recoupment_name], [is_active], [inserted_on], [inserted_by], [lock_time], [last_updated_time], [last_action_by]) values(N'" + objRoyaltyRecoupment.RoyaltyRecoupmentName.Trim().Replace("'", "''") + "',  '" + objRoyaltyRecoupment.Is_Active + "', GetDate(), '" + objRoyaltyRecoupment.InsertedBy + "',  Null, GetDate(), '" + objRoyaltyRecoupment.InsertedBy + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        RoyaltyRecoupment objRoyaltyRecoupment = (RoyaltyRecoupment)obj;
        return "update [Royalty_Recoupment] set [royalty_recoupment_name] = N'" + objRoyaltyRecoupment.RoyaltyRecoupmentName.Trim().Replace("'", "''") + "', [is_active] = '" + objRoyaltyRecoupment.Is_Active + "', [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '" + objRoyaltyRecoupment.LastActionBy + "' where royalty_recoupment_code = '" + objRoyaltyRecoupment.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        RoyaltyRecoupment objRoyaltyRecoupment = (RoyaltyRecoupment)obj;
        if (objRoyaltyRecoupment.arrRoyaltyRecoupmentDetails.Count > 0)
            DBUtil.DeleteChild("RoyaltyRecoupmentDetails", objRoyaltyRecoupment.arrRoyaltyRecoupmentDetails, objRoyaltyRecoupment.IntCode, (SqlTransaction)objRoyaltyRecoupment.SqlTrans);

        return " DELETE FROM [Royalty_Recoupment] WHERE royalty_recoupment_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        RoyaltyRecoupment objRoyaltyRecoupment = (RoyaltyRecoupment)obj;
        return "Update [Royalty_Recoupment] set Is_Active='" + objRoyaltyRecoupment.Is_Active + "',lock_time=null, last_updated_time= getdate() where royalty_recoupment_code = '" + objRoyaltyRecoupment.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Royalty_Recoupment] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Royalty_Recoupment] WHERE  royalty_recoupment_code = " + obj.IntCode;
    }
}
