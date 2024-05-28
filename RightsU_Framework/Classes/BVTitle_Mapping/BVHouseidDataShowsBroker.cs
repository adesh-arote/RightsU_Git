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
/// Summary description for BVHouseidDataShows
/// </summary>
public class BVHouseidDataShowsBroker : DatabaseBroker
{
	public BVHouseidDataShowsBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [BV_HouseId_Data_Shows] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        BVHouseidDataShows objBVHouseidDataShows;
		if (obj == null)
		{
			objBVHouseidDataShows = new BVHouseidDataShows();
		}
		else
		{
			objBVHouseidDataShows = (BVHouseidDataShows)obj;
		}

		objBVHouseidDataShows.IntCode = Convert.ToInt32(dRow["BV_HouseId_Data_Shows_Code"]);
		#region --populate--
		objBVHouseidDataShows.HouseIds = Convert.ToString(dRow["House_Ids"]);
		objBVHouseidDataShows.BVTitle = Convert.ToString(dRow["BV_Title"]);
		objBVHouseidDataShows.EpisodeNo = Convert.ToString(dRow["Episode_No"]);

		if (dRow["HouseID_Type_Code"] != DBNull.Value)
			objBVHouseidDataShows.HouseID_Type_Code = Convert.ToInt32(dRow["HouseID_Type_Code"]);

		if (dRow["Mapped_Deal_Title_Code"] != DBNull.Value)
			objBVHouseidDataShows.MappedDealTitleCode = Convert.ToInt32(dRow["Mapped_Deal_Title_Code"]);
		objBVHouseidDataShows.IsMapped = Convert.ToString(dRow["Is_Mapped"]);
        if (dRow["Parent_BV_HouseId_Data_Code"] != DBNull.Value)
            objBVHouseidDataShows.ParentBVHouseidDataCode = Convert.ToInt32(dRow["Parent_BV_HouseId_Data_Code"]);
        else
            objBVHouseidDataShows.ParentBVHouseidDataCode = 0;
		objBVHouseidDataShows.UploadFileCode = Convert.ToString(dRow["upload_file_code"]);

        if (dRow["IsIgnore"] != DBNull.Value)
            objBVHouseidDataShows.IsIgnore = Convert.ToString(dRow["IsIgnore"]);
        else
            objBVHouseidDataShows.IsIgnore = "N";
		#endregion
		return objBVHouseidDataShows;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		BVHouseidDataShows objBVHouseidDataShows = (BVHouseidDataShows)obj;
        
        //If BV_Title is ignore then it is not mapped to any title, hence not need to chk Duplicate.
        if (objBVHouseidDataShows.IsIgnore == "N")
        {
            string strExec = " Exec USP_ValidateDuplicateHouseId_Shows " + objBVHouseidDataShows.MappedDealTitleCode + "," + objBVHouseidDataShows.EpisodeNo + "," + objBVHouseidDataShows.HouseID_Type_Code + "," + objBVHouseidDataShows.IntCode;
            SqlTransaction objTrans = (SqlTransaction)objBVHouseidDataShows.SqlTrans;

            int count = 0;
            DataSet ds = ProcessSelectUsingTrans(strExec, ref objTrans);
            if (ds.Tables[0].Rows.Count > 0)
            {
                count = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
            }
            if (count > 0)
                return true;
            else
                return false;
        }
        else
        {
            return false;
        }
    }

    public override string GetInsertSql(Persistent obj)
    {
		BVHouseidDataShows objBVHouseidDataShows = (BVHouseidDataShows)obj;
		return "insert into [BV_HouseId_Data_Shows]([House_Ids], [BV_Title], [Episode_No], [HouseID_Type_Code], [Mapped_Deal_Title_Code], [Is_Mapped], [Parent_BV_HouseId_Data_Code], [upload_file_code]) values('" + objBVHouseidDataShows.HouseIds.Trim().Replace("'", "''") + "', '" + objBVHouseidDataShows.BVTitle.Trim().Replace("'", "''") + "', '" + objBVHouseidDataShows.EpisodeNo.Trim().Replace("'", "''") + "', '" + objBVHouseidDataShows.HouseID_Type_Code + "', '" + objBVHouseidDataShows.MappedDealTitleCode + "', '" + objBVHouseidDataShows.IsMapped.Trim().Replace("'", "''") + "', '" + objBVHouseidDataShows.ParentBVHouseidDataCode + "', '" + objBVHouseidDataShows.UploadFileCode.Trim().Replace("'", "''") + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		BVHouseidDataShows objBVHouseidDataShows = (BVHouseidDataShows)obj;
        if (objBVHouseidDataShows.IsIgnore == "Y")
        {
            objBVHouseidDataShows.IsMapped = "N";
        }

        string strSql = "";
        if (objBVHouseidDataShows.IsIgnore == "N")
        {
            strSql = " update [BV_HouseId_Data_Shows] set [House_Ids] = '" + objBVHouseidDataShows.HouseIds.Trim().Replace("'", "''") + "', "
            + " [BV_Title] = '" + objBVHouseidDataShows.BVTitle.Trim().Replace("'", "''") + "', "
            + " [Episode_No] = '" + objBVHouseidDataShows.EpisodeNo.Trim().Replace("'", "''") + "', "
            + " [HouseID_Type_Code] = '" + objBVHouseidDataShows.HouseID_Type_Code + "', "
            + " [Mapped_Deal_Title_Code] = '" + objBVHouseidDataShows.MappedDealTitleCode + "', "
            + " [Is_Mapped] = '" + objBVHouseidDataShows.IsMapped.Trim().Replace("'", "''") + "', "
            + " [Parent_BV_HouseId_Data_Code] = '" + objBVHouseidDataShows.ParentBVHouseidDataCode + "', "
            + " [upload_file_code] = '" + objBVHouseidDataShows.UploadFileCode.Trim().Replace("'", "''") + "', "
            + " [IsIgnore] = '" + objBVHouseidDataShows.IsIgnore.Trim() + "' "
            + " where BV_HouseId_Data_Shows_Code = '" + objBVHouseidDataShows.IntCode + "'; ";
        }
        else if (objBVHouseidDataShows.IsIgnore == "Y")
        {
            strSql = " UPDATE [BV_HouseId_Data_Shows] set "
            + " [Is_Mapped] = '" + objBVHouseidDataShows.IsMapped.Trim().Replace("'", "''") + "', "
            + " [IsIgnore] = '" + objBVHouseidDataShows.IsIgnore.Trim() + "' "
            + " where BV_HouseId_Data_Shows_Code = '" + objBVHouseidDataShows.IntCode + "'; ";
        }
        return strSql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		BVHouseidDataShows objBVHouseidDataShows = (BVHouseidDataShows)obj;

		return " DELETE FROM [BV_HouseId_Data_Shows] WHERE BV_HouseId_Data_Shows_Code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        BVHouseidDataShows objBVHouseidDataShows = (BVHouseidDataShows)obj;
return "Update [BV_HouseId_Data_Shows] set Is_Active='" + objBVHouseidDataShows.Is_Active + "',lock_time=null, last_updated_time= getdate() where BV_HouseId_Data_Shows_Code = '" + objBVHouseidDataShows.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [BV_HouseId_Data_Shows] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [BV_HouseId_Data_Shows] WHERE  BV_HouseId_Data_Shows_Code = " + obj.IntCode;
    }

	private int getHouseTypeCode(string HouseType) {
		string strhouseTypeCode = " select top 1 HouseID_Type_Code from HouseID_Type HT where HT.HouseID_Type_Name = '" + HouseType + "'";
		return DatabaseBroker.ProcessScalarDirectly(strhouseTypeCode);
	}

	internal string UpdateHouseIDForTitle(int MappedTitleCode, string EpisodeNo, int HouseID_Type_Code, int BVHouseIdDataCode, ref SqlTransaction objSqlTrans) 
	{
		string strExec = " Exec USP_UpdateContentHouseID_Shows " + MappedTitleCode +"," + EpisodeNo + "," + HouseID_Type_Code + "," + BVHouseIdDataCode;
		return ProcessScalarUsingTrans(strExec, ref objSqlTrans);
	}

	internal void ReprocessScheduleUnmappedHouseId(int File_Code, int Channel_Code, ref SqlTransaction objSqlTrans) {
		string strExec = " Exec usp_Schedule_ReProcess_Shows " + File_Code + "," + Channel_Code;
		ProcessScalarUsingTrans(strExec, ref objSqlTrans);
	}

	internal void ReprocessAsRun(int File_Code, int Channel_Code, ref SqlTransaction objSqlTrans) {
		string strExec = " Exec [usp_AsRun_Reprocess_Shows] " + File_Code + "," + Channel_Code;
		ProcessScalarUsingTrans(strExec, ref objSqlTrans);
	}
    
    internal void UpdateIgnoreBVTitles(ref SqlTransaction objSqlTrans)
    {
        string strSql = " EXEC USP_ScheduleAsRun_Ignore_BVTitle ";
        ProcessNonQuery(strSql, false, ref objSqlTrans);
    }

    internal void Schedule_Delete_IgnoredTitles(int File_Code, string IsCheckAllRecords, ref SqlTransaction objSqlTrans)
    {
        string strDelete = " EXEC USP_Schedule_Delete_IgnoredTitles " + File_Code + ", '" + IsCheckAllRecords + "' ";
        ProcessNonQuery(strDelete, false, ref objSqlTrans);
    }

    internal void AsRun_Delete_IgnoredTitles(int File_Code, string IsCheckAllRecords, ref SqlTransaction objSqlTrans)
    {
        string strDelete = " EXEC USP_AsRun_Delete_IgnoredTitles " + File_Code + ", '" + IsCheckAllRecords + "' ";
        ProcessNonQuery(strDelete, false, ref objSqlTrans);
    }
}
