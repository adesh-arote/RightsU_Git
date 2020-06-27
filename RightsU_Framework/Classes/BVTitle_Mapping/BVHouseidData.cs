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
public class BVHouseidData : Persistent
{
    public BVHouseidData()
    {
        OrderByColumnName = "BV_HouseId_Data_Code";
        OrderByCondition = "DESC";
        tableName = "BV_HouseId_Data";
        pkColName = "BV_HouseId_Data_Code";
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

    private string _Program_Episode_ID;
    public string Program_Episode_ID
    {
        get { return this._Program_Episode_ID; }
        set { this._Program_Episode_ID = value; }
    }
    

    private string _EpisodeNumbers;
    public string EpisodeNumbers
    {
        get { return this._EpisodeNumbers; }
        set { this._EpisodeNumbers = value; }
    }

    private string _HouseType;
    public string HouseType
    {
        get { return this._HouseType; }
        set { this._HouseType = value; }
    }

    private int _HouseTypeCode;
    public int HouseTypeCode
    {
        get { return this._HouseTypeCode; }
        set { this._HouseTypeCode = value; }
    }

    private int _UploadFileCode;
    public int UploadFileCode
    {
        get { return this._UploadFileCode; }
        set { this._UploadFileCode = value; }
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

    private string _IsIgnore;
    public string IsIgnore
    {
        get { return this._IsIgnore; }
        set { this._IsIgnore = value; }
    }

    private string _Schedule_Item_Log_Date;
    public string Schedule_Item_Log_Date
    {
        get { return this._Schedule_Item_Log_Date; }
        set { this._Schedule_Item_Log_Date = value; }
    }
    private string _Schedule_Item_Log_Time;
    public string Schedule_Item_Log_Time
    {
        get { return this._Schedule_Item_Log_Time; }
        set { this._Schedule_Item_Log_Time = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new BVHouseidDataBroker();
    }

    public override void LoadObjects()
    { }

    public override void UnloadObjects()
    {
        if (this.IsMapped == "Y")
            UpdateHouseIDForTitle(this.IntCode, this.MappedDealTitleCode);
    }

    #endregion

    public string UpdateHouseIDForTitle(int BVHouseIdDataCode, int MappedTitleCode)
    {
        SqlTransaction objSqlTrans = (SqlTransaction)this.SqlTrans;
        return (((BVHouseidDataBroker)this.GetBroker())).UpdateHouseIDForTitle(BVHouseIdDataCode, MappedTitleCode, ref objSqlTrans);
    }

    //public void ReprocessScheduleUnmappedHouseId(int fileCode)
    //{
    //    SqlTransaction objSqlTrans = (SqlTransaction)this.SqlTrans;
    //    (((BVHouseidDataBroker)this.GetBroker())).ReprocessScheduleUnmappedHouseId(fileCode, ref objSqlTrans);
    //}

    public void ReprocessScheduleUnmappedHouseId(string BVTitle_T, ref SqlTransaction objSqlTrans)
    {
        string strSql = "SELECT distinct File_Code, Channel_Code FROM Temp_BV_Schedule WHERE LTRIM(RTRIM(Program_Title)) "
        + " in (" + BVTitle_T.Trim() + ") order by File_Code";
        DataSet ds = new DataSet();

        // ds = DatabaseBroker.ProcessSelectUsingTrans(strSql, ref objSqlTrans);
        ds = DatabaseBroker.ProcessSelectDirectly(strSql);

        //if (ds.Tables[0].Rows.Count > 0)
        //{
        //    foreach (DataRow dtRow in ds.Tables[0].Rows)
        //    {
        //        int File_Code = Convert.ToInt32(dtRow["File_Code"]);
        //        int Channel_Code = Convert.ToInt32(dtRow["Channel_Code"]);

        //        (((BVHouseidDataBroker)this.GetBroker())).ReprocessScheduleUnmappedHouseId(File_Code, Channel_Code, ref objSqlTrans);
        //    }
        //}
    }

    public void ReprocessAsRun(string BVTitle_T, ref SqlTransaction objSqlTrans)
    {
        string strSql = " SELECT  DISTINCT FileCode, ChannelCode FROM temp_ASRUN "
        + " WHERE LTRIM(RTRIM(Title)) in (" + BVTitle_T.Trim() + ") order by FileCode";

        DataSet ds = new DataSet();
        ds = DatabaseBroker.ProcessSelectUsingTrans(strSql, ref objSqlTrans);

        if (ds.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow dtRow in ds.Tables[0].Rows)
            {
                int File_Code = Convert.ToInt32(dtRow["FileCode"]);
                int Channel_Code = Convert.ToInt32(dtRow["ChannelCode"]);

                (((BVHouseidDataBroker)this.GetBroker())).ReprocessAsRun(File_Code, Channel_Code, ref objSqlTrans);
            }
        }
    }
}
