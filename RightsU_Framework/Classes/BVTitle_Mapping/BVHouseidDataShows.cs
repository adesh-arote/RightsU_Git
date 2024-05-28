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
/// Summary description for Title
/// </summary>
public class  BVHouseidDataShows : Persistent
{
	public  BVHouseidDataShows()
	{
		OrderByColumnName = "BV_HouseId_Data_Shows_Code";
		OrderByCondition = "DESC"; 
		tableName = "BV_HouseId_Data_Shows";
		pkColName = "BV_HouseId_Data_Shows_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _HouseIds;
	public string HouseIds
	{
		get { return this._HouseIds; }
		set { this._HouseIds = value; }
	}

	private string _BVTitle;
	public string BVTitle
	{
		get { return this._BVTitle; }
		set { this._BVTitle = value; }
	}

	private string _EpisodeNo;
	public string EpisodeNo
	{
		get { return this._EpisodeNo; }
		set { this._EpisodeNo = value; }
	}

	private int _HouseID_Type_Code;
	public int HouseID_Type_Code
	{
		get { return this._HouseID_Type_Code; }
		set { this._HouseID_Type_Code = value; }
	}

	private int _MappedDealTitleCode;
	public int MappedDealTitleCode
	{
		get { return this._MappedDealTitleCode; }
		set { this._MappedDealTitleCode = value; }
	}

	private string _IsMapped;
	public string IsMapped
	{
		get { return this._IsMapped; }
		set { this._IsMapped = value; }
	}

	private int _ParentBVHouseidDataCode;
	public int ParentBVHouseidDataCode
	{
		get { return this._ParentBVHouseidDataCode; }
		set { this._ParentBVHouseidDataCode = value; }
	}

	private string _UploadFileCode;
	public string UploadFileCode
	{
		get { return this._UploadFileCode; }
		set { this._UploadFileCode = value; }
	}

    private string _IsIgnore = "N";
    public string IsIgnore
    {
        get { return this._IsIgnore; }
        set { this._IsIgnore = value; }
    }
    	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new BVHouseidDataShowsBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {

		if (this.IsMapped == "Y")
			UpdateHouseIDForTitle(this.MappedDealTitleCode, this.EpisodeNo, this.HouseID_Type_Code, this.IntCode);
    }
    
    #endregion    

    #region ------- SCHEDULE ASRUN REPROCESS OLD LOGIC -------
    /*
    public void ReprocessScheduleUnmappedHouseId(string BVTitle_T, ref SqlTransaction objSqlTrans) 
	{
        string strSqlMain = "SELECT distinct File_Code, Channel_Code FROM Temp_BV_Schedule_Show WHERE LTRIM(RTRIM(Program_Title))  "
        + " in (" + BVTitle_T.Trim() + ") order by File_Code ";
        //DataSet ds = new DataSet();
        //ds = DatabaseBroker.ProcessSelectUsingTrans(strSqlMain, ref objSqlTrans);

        
        //---------DELETE SCHEDULE IGNORED HOUSEID AND BV_TITLE
        int File_Code_temp = 0;
        string IsCheckAllRecords = "Y";
        (((BVHouseidDataShowsBroker)this.GetBroker())).Schedule_Delete_IgnoredTitles(File_Code_temp, IsCheckAllRecords, ref objSqlTrans);
        //if (ds.Tables[0].Rows.Count > 0)
        //{
        //    foreach (DataRow dtRow in ds.Tables[0].Rows)
        //    {
        //        int File_Code = Convert.ToInt32(dtRow["File_Code"]);
        //        (((BVHouseidDataShowsBroker)this.GetBroker())).Schedule_Delete_IgnoredTitles(File_Code, ref objSqlTrans);
        //    }
        //}
        //---------END DELETE SCHEDULE IGNORED HOUSEID AND BV_TITLE

        DataSet dsFinal = new DataSet();
        dsFinal = DatabaseBroker.ProcessSelectUsingTrans(strSqlMain, ref objSqlTrans);
        if (dsFinal.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow dtRow in dsFinal.Tables[0].Rows)
            {
                int File_Code = Convert.ToInt32(dtRow["File_Code"]);
                int Channel_Code = Convert.ToInt32(dtRow["Channel_Code"]);

                (((BVHouseidDataShowsBroker)this.GetBroker())).ReprocessScheduleUnmappedHouseId(File_Code, Channel_Code, ref objSqlTrans);
            }
        }
	}

	public void ReprocessAsRun(string BVTitle_T, ref SqlTransaction objSqlTrans) {
        string strSqlMain = " SELECT  DISTINCT FileCode, ChannelCode FROM temp_ASRUN_Shows "
        + " WHERE LTRIM(RTRIM(Title)) in (" + BVTitle_T.Trim() + ") order by FileCode";

        //DataSet ds = new DataSet();
        //ds = DatabaseBroker.ProcessSelectUsingTrans(strSqlMain, ref objSqlTrans);

        //---------DELETE ASRUN IGNORED HOUSEID AND BV_TITLE
        int File_Code_temp = 0;
        string IsCheckAllRecords = "Y";
        (((BVHouseidDataShowsBroker)this.GetBroker())).AsRun_Delete_IgnoredTitles(File_Code_temp, IsCheckAllRecords, ref objSqlTrans);
        //if (ds.Tables[0].Rows.Count > 0)
        //{
        //    foreach (DataRow dtRow in ds.Tables[0].Rows)
        //    {
        //        int File_Code = Convert.ToInt32(dtRow["FileCode"]);
        //        (((BVHouseidDataShowsBroker)this.GetBroker())).AsRun_Delete_IgnoredTitles(File_Code, ref objSqlTrans);
        //    }
        //}
        //---------END ASRUN SCHEDULE IGNORED HOUSEID AND BV_TITLE

        DataSet dsFinal = new DataSet();
        dsFinal = DatabaseBroker.ProcessSelectUsingTrans(strSqlMain, ref objSqlTrans);
        if (dsFinal.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow dtRow in dsFinal.Tables[0].Rows)
            {
                int File_Code = Convert.ToInt32(dtRow["FileCode"]);
                int Channel_Code = Convert.ToInt32(dtRow["ChannelCode"]);

                (((BVHouseidDataShowsBroker)this.GetBroker())).ReprocessAsRun(File_Code, Channel_Code, ref objSqlTrans);
            }
        }
    }
    */
    #endregion

    #region ------- SCHEDULE ASRUN REPROCESS NEW LOGIC -------

    public void ReprocessSchedule_And_AsRun(string strBV_HouseId_Data_Shows_Codes, string BVTitle_T, ref SqlTransaction objSqlTrans)
    {
        //string strSqlMain = " EXEC USP_ScheduleAsRun_GetFileCode_Reprocess '" + strBV_HouseId_Data_Shows_Codes.Replace("'", "").Trim() + "','" + BVTitle_T.Replace("'", "").Trim() + "' ";
        string strSqlMain = " EXEC USP_ScheduleAsRun_GetFileCode_Reprocess '" + strBV_HouseId_Data_Shows_Codes.Replace("'", "").Trim() + "','" + BVTitle_T.Trim() + "' ";

        //---------DELETE SCHEDULE IGNORED HOUSEID AND BV_TITLE
        int File_Code_temp = 0;
        string IsCheckAllRecords = "Y";
        //------ HERE NO NEED TO SEND File_Code
        (((BVHouseidDataShowsBroker)this.GetBroker())).Schedule_Delete_IgnoredTitles(File_Code_temp, IsCheckAllRecords, ref objSqlTrans);
        //---------END DELETE SCHEDULE IGNORED HOUSEID AND BV_TITLE

        DataSet dsFinal = new DataSet();
        dsFinal = DatabaseBroker.ProcessSelectUsingTrans(strSqlMain, ref objSqlTrans);
        if (dsFinal.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow dtRow in dsFinal.Tables[0].Rows)
            {
                int File_Code = Convert.ToInt32(dtRow["FileCode_Schedeule_Show"]);
                int Channel_Code = Convert.ToInt32(dtRow["ChannelCode_Schedeule_Show"]);

                (((BVHouseidDataShowsBroker)this.GetBroker())).ReprocessScheduleUnmappedHouseId(File_Code, Channel_Code, ref objSqlTrans);
            }
        }

        if (dsFinal.Tables[1].Rows.Count > 0)
        {
            foreach (DataRow dtRow in dsFinal.Tables[1].Rows)
            {
                int File_Code = Convert.ToInt32(dtRow["FileCode_AsRuns_Show"]);
                int Channel_Code = Convert.ToInt32(dtRow["ChannelCode_AsRuns_Show"]);

                (((BVHouseidDataShowsBroker)this.GetBroker())).ReprocessAsRun(File_Code, Channel_Code, ref objSqlTrans);
            }
        }
    }

    #endregion

    public string UpdateHouseIDForTitle(int MappedTitleCode, string EpisodeNo,int HouseID_Type_Code, int BVHouseIdDataCode) 
	{
		SqlTransaction objSqlTrans = (SqlTransaction)this.SqlTrans;
		return (((BVHouseidDataShowsBroker)this.GetBroker())).UpdateHouseIDForTitle(MappedTitleCode, EpisodeNo, HouseID_Type_Code, BVHouseIdDataCode, ref objSqlTrans);
	}

    public void UpdateIgnoreBVTitles(ref SqlTransaction objSqlTrans)
    {
        (((BVHouseidDataShowsBroker)this.GetBroker())).UpdateIgnoreBVTitles(ref objSqlTrans);
    }
}
