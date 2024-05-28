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


public class ChannelBroker : DatabaseBroker
{
    public ChannelBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Channel] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Channel objChannel;

        if (obj == null)
            objChannel = new Channel();
        else
            objChannel = (Channel)obj;

        objChannel.IntCode = Convert.ToInt32(dRow["Channel_Code"]);
        #region --populate--
        objChannel.ChannelName = Convert.ToString(dRow["Channel_Name"]);
        objChannel.ChannelId = Convert.ToString(dRow["Channel_Id"]);

        if (dRow["Genres_Code"] != DBNull.Value)
            objChannel.GenresCode = Convert.ToInt32(dRow["Genres_Code"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objChannel.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objChannel.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objChannel.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objChannel.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objChannel.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        if (dRow["entity_code"] != DBNull.Value)
            objChannel.EntityCode = Convert.ToInt32(dRow["entity_code"]);
        if (dRow["entity_type"] != DBNull.Value)
            objChannel.EntityType = Convert.ToString(dRow["entity_type"]);

        objChannel.Is_Active = Convert.ToString(dRow["Is_Active"]);
        objChannel.channelReferenceOfOwn = CheckChannelReferenceOfOwn(objChannel.IntCode);
        objChannel.channelReferenceOfOthers = CheckChannelReferenceOfOthers(objChannel.IntCode);

        //added by shamli
        if (dRow["Schedule_Source_FilePath"] != DBNull.Value)
            objChannel.ScheduleScFilePath = Convert.ToString(dRow["Schedule_Source_FilePath"]);
        if (dRow["Schedule_Source_FilePath"] != DBNull.Value)
            objChannel.ScheduleScFilePath_Pkg = Convert.ToString(dRow["Schedule_Source_FilePath_Pkg"]);
        if (dRow["HouseID_Prefix"] != DBNull.Value)
            objChannel.HIDPrefix = Convert.ToString(dRow["HouseID_Prefix"]);
        if (dRow["HouseIdRange_From"] != DBNull.Value)
            objChannel.HIDRangeFrom = Convert.ToString(dRow["HouseIdRange_From"]);
        if (dRow["HouseIdRange_To"] != DBNull.Value)
            objChannel.HIDRangeTo = Convert.ToString(dRow["HouseIdRange_To"]);
        if (dRow["OffsetTime_Schedule"] != DBNull.Value)
            objChannel.OffsetTimeSchedule = Convert.ToString(dRow["OffsetTime_Schedule"]);
        if (dRow["OffsetTime_AsRun"] != DBNull.Value)
            objChannel.OffsetTimeAsRun = Convert.ToString(dRow["OffsetTime_AsRun"]);
        if (dRow["BV_Channel_Code"] != DBNull.Value)
            objChannel.BVChannelCode = Convert.ToInt32(dRow["BV_Channel_Code"]);
        if (dRow["HouseID_Digits_AfterPrefix"] != DBNull.Value)
            objChannel.HIDDigitsPrefix = Convert.ToInt32(dRow["HouseID_Digits_AfterPrefix"]);

        #endregion
        return objChannel;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Channel objChannel = (Channel)obj;

        if (objChannel.SqlTrans != null)
            return DBUtil.IsDuplicateSqlTrans(ref obj, objChannel.tableName, "Channel_Name", objChannel.ChannelName, objChannel.pkColName, objChannel.IntCode, " already exist", "", true);
        else
            return DBUtil.IsDuplicate(myConnection, objChannel.tableName, "Channel_Name", objChannel.ChannelName, objChannel.pkColName, objChannel.IntCode, " already exist", "", true);
    }

    public override string GetInsertSql(Persistent obj)
    {
        Channel objChannel = (Channel)obj;
        return "insert into [Channel]([Channel_Name], [Channel_Id], [Genres_Code], [Inserted_On], [Inserted_By],[Is_Active],[Entity_Code], " +
               "[Entity_Type],[Schedule_Source_FilePath],[Schedule_Source_FilePath_Pkg],[BV_Channel_Code],[HouseID_Prefix],[HouseID_Digits_AfterPrefix],[HouseIdRange_From], " +
               "[HouseIdRange_To],[OffsetTime_Schedule],[OffsetTime_AsRun]) values(N'" + objChannel.ChannelName.Trim().Replace("'", "''") + "', " +
               "'" + objChannel.ChannelId.Trim().Replace("'", "''") + "', '" + objChannel.GenresCode + "', GetDate(), '"
               + objChannel.InsertedBy + "','Y','" + objChannel.EntityCode + "','" + objChannel.EntityType + "', " +
               " N'" + objChannel.ScheduleScFilePath.Trim().Replace("'", "''") + "', N'" + objChannel.ScheduleScFilePath_Pkg.Trim().Replace("'", "''") + "', '" + objChannel.BVChannelCode + "', '" + objChannel.HIDPrefix.Trim().Replace("'", "''")
               + "', '" + objChannel.HIDDigitsPrefix + "', '" + objChannel.HIDRangeFrom.Trim().Replace("'", "''")
               + "', '" + objChannel.HIDRangeTo.Trim().Replace("'", "''") + "', '" + objChannel.OffsetTimeSchedule.Trim().Replace("'", "''") + "', '" + objChannel.OffsetTimeAsRun.Trim().Replace("'", "''") + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Channel objChannel = (Channel)obj;
        return "update [Channel] set [Channel_Name] = N'" + objChannel.ChannelName.Trim().Replace("'", "''")
           + "', [Channel_Id] = '" + objChannel.ChannelId.Trim().Replace("'", "''")
           + "', [Genres_Code] = '" + objChannel.GenresCode
           + "', [Lock_Time] = Null, [Last_Updated_Time] = GetDate(), [Last_Action_By] = '" + objChannel.LastActionBy
           + "', [Entity_Code] = '" + objChannel.EntityCode + "', [Entity_Type] = '" + objChannel.EntityType
           + "', [Schedule_Source_FilePath] = N'" + objChannel.ScheduleScFilePath.Trim().Replace("'", "''")
           + "', [Schedule_Source_FilePath_Pkg] = N'" + objChannel.ScheduleScFilePath_Pkg.Trim().Replace("'", "''")
           + "', [BV_Channel_Code] = '" + objChannel.BVChannelCode
           + "', [HouseID_Prefix] = '" + objChannel.HIDPrefix.Trim().Replace("'", "''")
           + "', [HouseID_Digits_AfterPrefix] = '" + objChannel.HIDDigitsPrefix
           + "', [HouseIdRange_From] = '" + objChannel.HIDRangeFrom.Trim().Replace("'", "''")
           + "', [HouseIdRange_To] = '" + objChannel.HIDRangeTo.Trim().Replace("'", "''")
           + "', [OffsetTime_Schedule] = '" + objChannel.OffsetTimeSchedule.Trim().Replace("'", "''")
           + "', [OffsetTime_AsRun] = '" + objChannel.OffsetTimeAsRun.Trim().Replace("'", "''")

           + "' where Channel_Code = '" + objChannel.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Channel objChannel = (Channel)obj;
        if (objChannel.arrChannelEntity.Count > 0)
            DBUtil.DeleteChild("channelentity", objChannel.arrChannelEntity, objChannel.IntCode, (SqlTransaction)objChannel.SqlTrans);
        if (objChannel.arrChannelTerritory.Count > 0)
            DBUtil.DeleteChild("ChannelTerritory", objChannel.arrChannelTerritory, objChannel.IntCode, (SqlTransaction)objChannel.SqlTrans);
        return " DELETE FROM [Channel] WHERE Channel_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Channel objChannel = (Channel)obj;
        string strSql = "UPDATE [Channel] SET Is_Active='" + objChannel.Is_Active + "',[Lock_Time]=null,[Last_Updated_Time] = getDate() WHERE Channel_Code=" + objChannel.IntCode;
        return strSql;
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Channel] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Channel] WHERE  Channel_Code = " + obj.IntCode;
    }

    /* Added By sharad for Channel Reference Validation on 8 Feb 2011 */

    public int CheckChannelReferenceOfOwn(int channelCode)
    {
        int getCountForOwn;
        string strSql = "select COUNT(*) from Channel c inner join Deal_Movie_Rights_Channel dmrc on c.channel_code=dmrc.channel_code where c.channel_code=" + channelCode;
        getCountForOwn = DatabaseBroker.ProcessScalarDirectly(strSql);
        return getCountForOwn;
    }

    public int CheckChannelReferenceOfOthers(int channelCode)
    {
        int getCountForOthers;
        string strSql = "select COUNT(*) from Channel c inner join syn_deal_movie_rights_channel sdmrcs on c.channel_code=sdmrcs.channel_code where c.channel_code=" + channelCode;
        getCountForOthers = DatabaseBroker.ProcessScalarDirectly(strSql);
        return getCountForOthers;
    }

    /* Added By sharad for Channel Reference Validation on 8 Feb 2011 */
}
