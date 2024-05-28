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
/// Summary description for UserChannel
/// </summary>
public class UserChannelBroker : DatabaseBroker
{
	public UserChannelBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Users_Channel] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        UserChannel objUserChannel;
		if (obj == null)
		{
			objUserChannel = new UserChannel();
		}
		else
		{
			objUserChannel = (UserChannel)obj;
		}

		objUserChannel.IntCode = Convert.ToInt32(dRow["users_channel_code"]);
		#region --populate--
		if (dRow["users_code"] != DBNull.Value)
			objUserChannel.UserCode = Convert.ToInt32(dRow["users_code"]);
		if (dRow["channel_code"] != DBNull.Value)
			objUserChannel.ChannelCode = Convert.ToInt32(dRow["channel_code"]);
		objUserChannel.SDefault = Convert.ToChar(dRow["s_default"]);
		#endregion
		return objUserChannel;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		UserChannel objUserChannel = (UserChannel)obj;
        return "insert into [Users_Channel]([users_code], [channel_code], [s_default]) values('" + objUserChannel.UserCode + "', '" + objUserChannel.ChannelCode + "', '" + objUserChannel.SDefault + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		UserChannel objUserChannel = (UserChannel)obj;
        return "update [Users_Channel] set [users_code] = '" + objUserChannel.UserCode + "', [channel_code] = '" + objUserChannel.ChannelCode + "', [s_default] = '" + objUserChannel.SDefault + "' where users_channel_code = '" + objUserChannel.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		UserChannel objUserChannel = (UserChannel)obj;

        return " DELETE FROM [Users_Channel] WHERE users_channel_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [Users_Channel] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [Users_Channel] WHERE  user_channel_code = " + obj.IntCode;
    }  
}
