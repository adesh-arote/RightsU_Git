using System;
using System.Data;
using System.Configuration;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for BVException
/// </summary>
public class BVExceptionBroker : DatabaseBroker
{
    public BVExceptionBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [BVException] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        BVException objBVException;
        if (obj == null)
        {
            objBVException = new BVException();
        }
        else
        {
            objBVException = (BVException)obj;
        }

        objBVException.IntCode = Convert.ToInt32(dRow["bv_exception_code"]);
        #region --populate--
        objBVException.BvExceptionType = Convert.ToString(dRow["bv_exception_type"]);
        if (dRow["inserted_by"] != DBNull.Value)
            objBVException.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
        if (dRow["inserted_on"] != DBNull.Value)
            objBVException.InsertedOn = Convert.ToString(dRow["inserted_on"]);
        if (dRow["lock_time"] != DBNull.Value)
            objBVException.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objBVException.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objBVException.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
        objBVException.Is_Active = Convert.ToString(dRow["is_active"]);
        #endregion
        return objBVException;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        BVException objBVException = (BVException)obj;
        string sql = "select COUNT(*) from BVException Bv "
        + " inner join BVException_Channel bvc on bv.bv_exception_code = bvc.bv_exception_code "
        + " inner join BVException_Users bvu on bv.bv_exception_code = bvu.bv_exception_code "
        + " where bv.bv_exception_code not in ('" + obj.IntCode + "') "
        + " and Bv.bv_exception_type in ('"+ objBVException.BvExceptionType +"') "
        + " and bvc.channel_code  in (" + objBVException.ChannelCodeList.Replace('~',',') + ") "
        + " and bvu.users_code in ("+objBVException.UsersCodeList.Replace('~',',') +")";
        int count = 0;
        DataSet ds = ProcessSelectDirectly(sql);
        if (ds.Tables[0].Rows.Count > 0)
        {
            count = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
        }
        if (count > 0)
            return true;
        else
            return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        BVException objBVException = (BVException)obj;
        string sql = "insert into [BVException]([bv_exception_type], [inserted_by], [inserted_on], [lock_time], "
            + "[last_updated_time], [last_action_by], [is_active]) values('" + objBVException.BvExceptionType.Trim() + "', '"
            + objBVException.InsertedBy + "', GetDate(),  Null, GetDate(), '" + objBVException.InsertedBy + "',  '"
            + objBVException.Is_Active + "');";
        return sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        BVException objBVException = (BVException)obj;
        string sql = "update [BVException] set [bv_exception_type] = '" + objBVException.BvExceptionType.Trim().Replace("'", "''")
            + "', [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '"
            + objBVException.LastActionBy + "', [is_active] = '" + objBVException.Is_Active
            + "' where bv_exception_code = '" + objBVException.IntCode + "';";
        return sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        BVException objBVException = (BVException)obj;
        if (objBVException.arrBvexceptionChannel_Del.Count > 0)
            DBUtil.DeleteChild("BvexceptionChannel", objBVException.arrBvexceptionChannel_Del, objBVException.IntCode, (SqlTransaction)objBVException.SqlTrans);
        if (objBVException.arrBvexceptionUsers_Del.Count > 0)
            DBUtil.DeleteChild("BvexceptionUsers", objBVException.arrBvexceptionUsers_Del, objBVException.IntCode, (SqlTransaction)objBVException.SqlTrans);
        return " delete from [BVException] WHERE bv_exception_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        BVException objBVException = (BVException)obj;
        return "Update [BVException] set Is_Active='" + objBVException.Is_Active + "',lock_time=null,"
            + " last_updated_time= getdate() where bv_exception_code = '" + objBVException.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [BVException] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [BVException] WHERE  bv_exception_code = " + obj.IntCode;
    }

    internal DataSet getChannelNames(string ChannelName)
    {
        string sql = "select channel_name from Channel where channel_code in (select channel_code from BVException_Channel"
                   + " where bv_exception_code in (select bv_exception_code from BVException where is_active='Y')) "
                   + "and channel_name like '" + ChannelName + "%'";
        DataSet ds = ProcessSelectDirectly(sql);
        return ds;
    }
}
