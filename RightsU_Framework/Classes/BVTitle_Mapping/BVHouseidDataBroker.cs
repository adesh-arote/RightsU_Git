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
/// Summary description for BVHouseidData
/// </summary>
public class BVHouseidDataBroker : DatabaseBroker
{
	public BVHouseidDataBroker() { }

	public override string GetSelectSql(Criteria objCriteria, string strSearchString) {
		string sqlStr = "SELECT *, dbo.fn_GetEpisodeNos(BV_HouseId_Data_Code) EpisodeNumbers FROM [BV_HouseId_Data] where 1=1 " + strSearchString;
		
        if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		
        return objCriteria.getPagingSQL(sqlStr);
	}

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        BVHouseidData objBVHouseidData;

        if (obj == null)
            objBVHouseidData = new BVHouseidData();
        else
            objBVHouseidData = (BVHouseidData)obj;

        objBVHouseidData.IntCode = Convert.ToInt32(dRow["BV_HouseId_Data_Code"]);
        #region --populate--
        objBVHouseidData.HouseIds = Convert.ToString(dRow["House_Ids"]);
        objBVHouseidData.BVTitle = Convert.ToString(dRow["BV_Title"]);
        objBVHouseidData.EpisodeNo = Convert.ToString(dRow["Episode_No"]);
        objBVHouseidData.Program_Episode_ID = Convert.ToString(dRow["Program_Episode_ID"]);
        objBVHouseidData.HouseType = Convert.ToString(dRow["House_Type"]);
        if (dRow["Mapped_Deal_Title_Code"] != DBNull.Value)
            objBVHouseidData.MappedDealTitleCode = Convert.ToInt32(dRow["Mapped_Deal_Title_Code"]);
        objBVHouseidData.IsMapped = Convert.ToString(dRow["Is_Mapped"]);

        objBVHouseidData.IsIgnore = Convert.ToString(dRow["IsIgnore"]);
        

        if (dRow["upload_file_code"] != DBNull.Value)
            objBVHouseidData.UploadFileCode = Convert.ToInt32(dRow["upload_file_code"]);

        
            objBVHouseidData.Schedule_Item_Log_Date = Convert.ToString(dRow["Schedule_Item_Log_Date"]);


            objBVHouseidData.Schedule_Item_Log_Time = Convert.ToString(dRow["Schedule_Item_Log_Time"]);

        objBVHouseidData.HouseTypeCode = this.getHouseTypeCode(objBVHouseidData.HouseType);

        if (dRow["EpisodeNumbers"] != DBNull.Value)
            objBVHouseidData.EpisodeNumbers = Convert.ToString(dRow["EpisodeNumbers"]);

        #endregion
        return objBVHouseidData;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        BVHouseidData objBVHouseidData = (BVHouseidData)obj;

        //string strSelect = " SELECT COUNT(*) FROM Deal_Movie_Contents DMC  " +
        //               " inner join Deal_Movie_Contents_HouseID DMCH on DMC.deal_movie_content_code = DMCH.deal_movie_content_code   " +
        //               " inner join Deal_Movie DM on DMC.deal_movie_code = DM.deal_movie_code  " +
        //               " where DM.title_code not in (" + objBVHouseidData.MappedDealTitleCode + ") " +
        //               " and DMCH.House_ID_Type_Code in (" + objBVHouseidData.HouseTypeCode + ")  " +
        //               " and DMCH.House_ID in (SELECT number FROM dbo.fn_Split_withdelemiter('" + objBVHouseidData.HouseIds + "',',')) ";

        //string strExec = " Exec USP_ValidateDuplicateHouseId " + objBVHouseidData.MappedDealTitleCode + "," + objBVHouseidData.IntCode;
        //SqlTransaction objTrans =(SqlTransaction)objBVHouseidData.SqlTrans;
        //int count = 0;
        //DataSet ds = ProcessSelectUsingTrans(strExec, ref objTrans);
        //if (ds.Tables[0].Rows.Count > 0)
        //{
        //    count = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
        //}
        //if (count > 0)
        //return false;
        //else
        return false;
    }

	public override string GetInsertSql(Persistent obj) {
		BVHouseidData objBVHouseidData = (BVHouseidData)obj;
        return "insert into [BV_HouseId_Data]([House_Ids], [BV_Title], [Episode_No], [House_Type],[Mapped_Deal_Title_Code], [Is_Mapped] [IsIgnore]) values('" + objBVHouseidData.HouseIds.Trim().Replace("'", "''") + "', '" + objBVHouseidData.BVTitle.Trim().Replace("'", "''") + "', '" + objBVHouseidData.EpisodeNo.Trim().Replace("'", "''") + "', '" + objBVHouseidData.HouseType.Trim().Replace("'", "''") + "', '" + objBVHouseidData.MappedDealTitleCode + "', '" + objBVHouseidData.IsMapped.Trim().Replace("'", "''") + "', '" + objBVHouseidData.IsIgnore + "');";
	}

	public override string GetUpdateSql(Persistent obj) {
		BVHouseidData objBVHouseidData = (BVHouseidData)obj;
        return "update [BV_HouseId_Data] set [House_Ids] = '" + objBVHouseidData.HouseIds.Trim().Replace("'", "''") + "', [BV_Title] = '" + objBVHouseidData.BVTitle.Trim().Replace("'", "''") + "', [Episode_No] = '" + objBVHouseidData.EpisodeNo.Trim().Replace("'", "''") + "', [House_Type] = '" + objBVHouseidData.HouseType.Trim().Replace("'", "''") + "', [Mapped_Deal_Title_Code] = '" + objBVHouseidData.MappedDealTitleCode + "', [Is_Mapped] = '" + objBVHouseidData.IsMapped.Trim().Replace("'", "''") + "', [IsIgnore] = '" + objBVHouseidData.IsIgnore + "' where BV_HouseId_Data_Code = '" + objBVHouseidData.IntCode + "';";
	}

	public override bool CanDelete(Persistent obj, out string strMessage) {
		strMessage = "";
		return true;
	}

	public override string GetDeleteSql(Persistent obj) {
		BVHouseidData objBVHouseidData = (BVHouseidData)obj;
		return " DELETE FROM [BV_HouseId_Data] WHERE BV_HouseId_Data_Code = " + obj.IntCode;
	}

	public override string GetActivateDeactivateSql(Persistent obj) {
		BVHouseidData objBVHouseidData = (BVHouseidData)obj;
		return "Update [BV_HouseId_Data] set Is_Active='" + objBVHouseidData.Is_Active + "',lock_time=null, last_updated_time= getdate() where BV_HouseId_Data_Code = '" + objBVHouseidData.IntCode + "'";
	}

	public override string GetCountSql(string strSearchString) {
		return " SELECT Count(*) FROM [BV_HouseId_Data] WHERE 1=1 " + strSearchString;
	}

	public override string GetSelectSqlOnCode(Persistent obj) {
		return " SELECT *, dbo.fn_GetEpisodeNos(BV_HouseId_Data_Code) EpisodeNumbers FROM [BV_HouseId_Data] WHERE  BV_HouseId_Data_Code = " + obj.IntCode;
	}

	private int getHouseTypeCode(string HouseType) {
		string strhouseTypeCode = " select top 1 HouseID_Type_Code from HouseID_Type HT where HT.HouseID_Type_Name = '" + HouseType + "'";
		return DatabaseBroker.ProcessScalarDirectly(strhouseTypeCode);
	}

	internal string UpdateHouseIDForTitle(int BVHouseIdDataCode, int MappedTitleCode,ref SqlTransaction objSqlTrans) 
	{
		string strExec = " Exec USP_UpdateContentHouseID " + BVHouseIdDataCode + "," + MappedTitleCode;
		//return ProcessScalarUsingTrans(strExec,ref objSqlTrans);
        return ProcessScalarReturnString(strExec);
	}

    //internal void ReprocessScheduleUnmappedHouseId(int fileCode, ref SqlTransaction objSqlTrans) 
    //{
    //    int intChnannelCode = Convert.ToInt32(DatabaseBroker.ProcessScalarUsingTrans("select ChannelCode from Upload_Files where File_code = " + fileCode,ref objSqlTrans));
    //    string strExec = " Exec usp_Schedule_ReProcess " + fileCode + "," + intChnannelCode;
    //    ProcessScalarUsingTrans(strExec,ref objSqlTrans);
    //}

    internal void ReprocessScheduleUnmappedHouseId(int File_Code, int Channel_Code, ref SqlTransaction objSqlTrans)
    {
        string strExec = " Exec usp_Schedule_ReProcess " + File_Code + "," + Channel_Code;
        //ProcessScalarUsingTrans(strExec, ref objSqlTrans);
        ProcessScalarReturnString(strExec);
    }

    //internal void ReprocessAsRun(int fileCode, ref SqlTransaction objSqlTrans)
    //{
    //    int intChnannelCode = Convert.ToInt32(DatabaseBroker.ProcessScalarUsingTrans("select ChannelCode from Upload_Files where File_code = " + fileCode, ref objSqlTrans));
    //    string strExec = " Exec [usp_AsRun_Reprocess] " + fileCode + "," + intChnannelCode;
    //    ProcessScalarUsingTrans(strExec, ref objSqlTrans);
    //}

    internal void ReprocessAsRun(int File_Code, int Channel_Code, ref SqlTransaction objSqlTrans)
    {
        string strExec = " Exec [usp_AsRun_Reprocess] " + File_Code + "," + Channel_Code;
        ProcessScalarUsingTrans(strExec, ref objSqlTrans);
    }
}
