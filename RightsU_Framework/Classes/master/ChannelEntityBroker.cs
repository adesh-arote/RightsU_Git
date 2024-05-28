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
/// Summary description for ChannelEntity
/// </summary>
public class ChannelEntityBroker : DatabaseBroker
{
	public ChannelEntityBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [channel_entity] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ChannelEntity objChannelEntity;
		if (obj == null)
		{
			objChannelEntity = new ChannelEntity();
		}
		else
		{
			objChannelEntity = (ChannelEntity)obj;
		}

		objChannelEntity.IntCode = Convert.ToInt32(dRow["channel_entity_code"]);
		#region --populate--
		if (dRow["channel_code"] != DBNull.Value)
			objChannelEntity.ChannelCode = Convert.ToInt32(dRow["channel_code"]);
		if (dRow["entity_code"] != DBNull.Value)
			objChannelEntity.EntityCode = Convert.ToInt32(dRow["entity_code"]);
		if (dRow["effective_start_date"] != DBNull.Value)
			//objChannelEntity.EffectiveStartDate = Convert.ToDateTime(dRow["effective_start_date"]);
			objChannelEntity.EffectiveStartDate = Convert.ToDateTime(dRow["effective_start_date"]).ToString("dd/MM/yyyy");
		if (dRow["system_end_date"] != DBNull.Value)
			objChannelEntity.SystemEndDate = Convert.ToDateTime(dRow["system_end_date"]).ToString("dd/MM/yyyy");			
		if (dRow["last_updated_time"] != DBNull.Value)
            objChannelEntity.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
		if (dRow["last_action_by"] != DBNull.Value)
			objChannelEntity.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
		#endregion
		return objChannelEntity;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		ChannelEntity objChannelEntity = (ChannelEntity)obj;
		string str = "insert into [channel_entity]([channel_code], [entity_code], [effective_start_date],[System_End_Date]) values('" + objChannelEntity.ChannelCode + "', '" + objChannelEntity.EntityCode + "', '" + GlobalUtil.GetFormatedDateTime(objChannelEntity.EffectiveStartDate) + "',null);";
		str = "update [channel_entity] set [System_End_Date]=dateadd(d,-1,'" + GlobalUtil.GetFormatedDateTime(objChannelEntity.EffectiveStartDate) + "') where channel_entity_code in(select max(channel_entity_code) from [channel_entity] where channel_code='" + objChannelEntity.ChannelCode + " ')" + str;
		return str;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		ChannelEntity objChannelEntity = (ChannelEntity)obj;
		//string str= "update [channel_entity] set [channel_code] = '" + objChannelEntity.ChannelCode + "', [entity_code] = '" + objChannelEntity.EntityCode + "', [effective_start_date] = '" +  objChannelEntity.EffectiveStartDate + "', [system_end_date] = '" + objChannelEntity.SystemEndDate + "', [last_updated_time] = GetDate(), [last_action_by] = '" + objChannelEntity.LastActionBy + "' where channel_entity_code = '" + objChannelEntity.IntCode + "';";

		string str = "update [channel_entity] set [channel_code] = '" + objChannelEntity.ChannelCode + "', [entity_code] = '" + objChannelEntity.EntityCode + "', [effective_start_date] = '" + GlobalUtil.GetFormatedDateTime(objChannelEntity.EffectiveStartDate) + "', [last_updated_time] = GetDate(), [last_action_by] = '" + objChannelEntity.LastActionBy + "' where channel_entity_code = '" + objChannelEntity.IntCode + "';";

		str += "update Channel_entity set system_end_date=dateadd(d,-1,'" + GlobalUtil.GetFormatedDateTime(objChannelEntity.EffectiveStartDate)+ "')"
			 + " where system_end_date=(select max(isnull(system_end_date,dateadd(d,-1,'" + GlobalUtil.GetFormatedDateTime(objChannelEntity.EffectiveStartDate) + "'))) from Channel_entity where 1=1 "
			 + " and Channel_entity_code!='" + objChannelEntity.IntCode + "' and effective_start_date < '" + GlobalUtil.GetFormatedDateTime(objChannelEntity.EffectiveStartDate)  + "'  and [channel_Code] = '" + objChannelEntity.ChannelCode + "')and [Channel_Code] = '" + objChannelEntity.ChannelCode + "'";
		return str; 
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		ChannelEntity objChannelEntity = (ChannelEntity)obj;

		return " DELETE FROM [channel_entity] WHERE channel_entity_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [channel_entity] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [channel_entity] WHERE  channel_entity_code = " + obj.IntCode;
    }  
}
