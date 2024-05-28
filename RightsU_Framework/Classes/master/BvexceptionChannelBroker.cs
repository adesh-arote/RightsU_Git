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
/// Summary description for BvexceptionChannel
/// </summary>
public class BvexceptionChannelBroker : DatabaseBroker
{
	public BvexceptionChannelBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [BVException_Channel] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        BvexceptionChannel objBvexceptionChannel;
		if (obj == null)
		{
			objBvexceptionChannel = new BvexceptionChannel();
		}
		else
		{
			objBvexceptionChannel = (BvexceptionChannel)obj;
		}

		objBvexceptionChannel.IntCode = Convert.ToInt32(dRow["bv_exception_channel_code"]);
		#region --populate--
		if (dRow["bv_exception_code"] != DBNull.Value)
			objBvexceptionChannel.BvExceptionCode = Convert.ToInt32(dRow["bv_exception_code"]);
		if (dRow["channel_code"] != DBNull.Value)
			objBvexceptionChannel.ChannelCode = Convert.ToInt32(dRow["channel_code"]);
		#endregion
		return objBvexceptionChannel;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		BvexceptionChannel objBvexceptionChannel = (BvexceptionChannel)obj;
		string sql = "insert into [BVException_Channel]([bv_exception_code], [channel_code]) values('" + objBvexceptionChannel.BvExceptionCode 
            + "', '" + objBvexceptionChannel.ChannelCode + "');";
        return sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		BvexceptionChannel objBvexceptionChannel = (BvexceptionChannel)obj;
		string sql="update [BVException_Channel] set [bv_exception_code] = '" + objBvexceptionChannel.BvExceptionCode + "', [channel_code] = '" 
            + objBvexceptionChannel.ChannelCode + "' where bv_exception_channel_code = '" + objBvexceptionChannel.IntCode + "';";
        return sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		BvexceptionChannel objBvexceptionChannel = (BvexceptionChannel)obj;

		return " DELETE FROM [BVException_Channel] WHERE bv_exception_channel_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        BvexceptionChannel objBvexceptionChannel = (BvexceptionChannel)obj;
        return "Update [BVException_Channel] set Is_Active='" + objBvexceptionChannel.Is_Active 
        + "',lock_time=null, last_updated_time= getdate() where bv_exception_channel_code = '" + objBvexceptionChannel.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [BVException_Channel] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [BVException_Channel] WHERE  bv_exception_channel_code = " + obj.IntCode;
    }  
}
