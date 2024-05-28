using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for Title
/// </summary>
public class Channel : Persistent
{
    public Channel()
    {
        OrderByColumnName = "Channel_Name";
        OrderByCondition = "ASC";
        tableName = "Channel";
        pkColName = "Channel_Code";
    }
    public Channel(int IntCode):this()
    {
        this.IntCode = IntCode;
    }
    public Channel(string stringChannelName): this()
    {
        this.ChannelName = stringChannelName;
    }

    #region ---------------Attributes And Prperties---------------


    private string _ChannelName;
    public string ChannelName
    {
        get { return this._ChannelName; }
        set { this._ChannelName = value; }
    }

    private string _ChannelId;
    public string ChannelId
    {
        get { return this._ChannelId; }
        set { this._ChannelId = value; }
    }

    private int _GenresCode;
    public int GenresCode
    {
        get { return this._GenresCode; }
        set { this._GenresCode = value; }
    }

    private int _EntityCode;
    public int EntityCode
    {
        get { return this._EntityCode; }
        set { this._EntityCode = value; }
    }


    private string _EntityType;
    public string EntityType
    {
        get { return this._EntityType; }
        set { this._EntityType = value; }
    }

    private Genres _objGenres;
    public Genres objGenres
    {
        get
        {
            if (this._objGenres == null)
                this._objGenres = new Genres();
            return this._objGenres;
        }
        set { this._objGenres = value; }
    }

    private string _CountryNames;
    public string CountryNames
    {
        get { return this._CountryNames; }
        set { this._CountryNames = value; }
    }

    private ArrayList _arrCountryNames;
    public ArrayList arrCountryNames
    {
        get
        {
            if (this._arrCountryNames == null)
                this._arrCountryNames = new ArrayList();
            return this._arrCountryNames;
        }
        set
        {
            this._arrCountryNames = value;
        }
    }

    private Territory _objTerritory;
    public Territory objTerritory
    {
        get
        {
            if (this._objTerritory == null)
                this._objTerritory = new Territory();
            return this._objTerritory;
        }
        set { this._objTerritory = value; }
    }

    private ChannelTerritory _objChannelTerritory;
    public ChannelTerritory objChannelTerritory
    {
        get
        {
            if (this._objChannelTerritory == null)
                this._objChannelTerritory = new ChannelTerritory();
            return this._objChannelTerritory;
        }
        set
        {
            this._objChannelTerritory = value;
        }
    }

    private ArrayList _arrChannelEntity_Del;
    public ArrayList arrChannelEntity_Del
    {
        get
        {
            if (this._arrChannelEntity_Del == null)
                this._arrChannelEntity_Del = new ArrayList();
            return this._arrChannelEntity_Del;
        }
        set { this._arrChannelEntity_Del = value; }
    }

    private ArrayList _arrChannelEntity;
    public ArrayList arrChannelEntity
    {
        get
        {
            if (this._arrChannelEntity == null)
                this._arrChannelEntity = new ArrayList();
            return this._arrChannelEntity;
        }
        set { this._arrChannelEntity = value; }
    }

    private ArrayList _arrChannelTerritory_Del;
    public ArrayList arrChannelTerritory_Del
    {
        get
        {
            if (this._arrChannelTerritory_Del == null)
                this._arrChannelTerritory_Del = new ArrayList();
            return this._arrChannelTerritory_Del;
        }
        set { this._arrChannelTerritory_Del = value; }
    }

    private ArrayList _arrChannelTerritory;
    public ArrayList arrChannelTerritory
    {
        get
        {
            if (this._arrChannelTerritory == null)
                this._arrChannelTerritory = new ArrayList();
            return this._arrChannelTerritory;
        }
        set { this._arrChannelTerritory = value; }
    }

    private Entity _objEntity;
    public Entity objEntity
    {
        get
        {
            if (this._objEntity == null)
                this._objEntity = new Entity();
            return this._objEntity;
        }
        set { this._objEntity = value; }
    }

    private Vendor _objVendor;
    public Vendor objVendor
    {
        get
        {
            if (this._objVendor == null)
                this._objVendor = new Vendor();
            return this._objVendor;
        }
        set { this._objVendor = value; }
    }

    /*Added By sharad to Check Reference OF Channel on Feb 2008  */

    private int _channelReferenceOfOwn;
    public int channelReferenceOfOwn
    {
        get { return this._channelReferenceOfOwn; }
        set { this._channelReferenceOfOwn = value; }
    }
    private int _channelReferenceOfOthers;
    public int channelReferenceOfOthers
    {
        get { return this._channelReferenceOfOthers; }
        set { this._channelReferenceOfOthers = value; }
    }

    /* End added By sharad to Check Reference OF Channel on Feb 2008  */

    //added by shamli on Jan 2012

    private string _ScheduleScFilePath;
    public string ScheduleScFilePath
    {
       get { return this._ScheduleScFilePath; }
       set { this._ScheduleScFilePath = value; }
    }

    private string _ScheduleScFilePath_Pkg;
    public string ScheduleScFilePath_Pkg
    {
        get { return this._ScheduleScFilePath_Pkg; }
        set { this._ScheduleScFilePath_Pkg = value; }
    }

    private int _BVChannelCode;
    public int BVChannelCode
    {
       get { return this._BVChannelCode; }
       set { this._BVChannelCode = value; }
    }

    private string _HIDPrefix = string.Empty;
    public string HIDPrefix
    {
       get { return this._HIDPrefix; }
       set { this._HIDPrefix = value; }
    }

    private int _HIDDigitsPrefix;
    public int HIDDigitsPrefix
    {
       get { return this._HIDDigitsPrefix; }
       set { this._HIDDigitsPrefix = value; }
    }

    private string _HIDRangeFrom;
    public string HIDRangeFrom
    {
       get { return this._HIDRangeFrom; }
       set { this._HIDRangeFrom = value; }
    }

    private string _HIDRangeTo;
    public string HIDRangeTo
    {
       get { return this._HIDRangeTo; }
       set { this._HIDRangeTo = value; }
    }


    private string _OffsetTimeSchedule;
    public string OffsetTimeSchedule
    {
       get { return this._OffsetTimeSchedule; }
       set { this._OffsetTimeSchedule = value; }
    }

    private string _OffsetTimeAsRun;
    public string OffsetTimeAsRun
    {
       get { return this._OffsetTimeAsRun; }
       set { this._OffsetTimeAsRun = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ChannelBroker();
    }

    public override void LoadObjects()
    {
        this.arrChannelEntity = DBUtil.FillArrayList(new ChannelEntity(), " and channel_code = '" + this.IntCode + "'", true);
        this.arrChannelTerritory = DBUtil.FillArrayList(new ChannelTerritory(), " and Channel_Code = '" + this.IntCode + "'", true);
        string strSql = " and Country_code in (select Country_code from Channel_Territory where Channel_Code=" + this.IntCode + ")";
        this.arrCountryNames = DBUtil.FillArrayList(new Country(), strSql, false);

        string strTerritoryNames = "";

        foreach (ChannelTerritory obj in this.arrChannelTerritory)
        {
            if (strTerritoryNames != "")
                strTerritoryNames += ", ";

            strTerritoryNames += obj.objCountry.CountryName;
        }

        this.CountryNames = strTerritoryNames;

        if (this.GenresCode > 0)
        {
            this.objGenres.IntCode = this.GenresCode;
            this.objGenres.Fetch();
        }

        if (this.EntityType == "O")
        {
            this.objEntity.IntCode = this.EntityCode;
            this.objEntity.Fetch();
        }
        else if ((this.EntityType == "C"))
        {
            this.objVendor.IntCode = this.EntityCode;
            this.objVendor.Fetch();
        }
    }

    public override void UnloadObjects()
    {
        if (arrChannelEntity_Del != null)
        {
            foreach (ChannelEntity objChannelEntity in this.arrChannelEntity_Del)
            {
                objChannelEntity.IsTransactionRequired = true;
                objChannelEntity.SqlTrans = this.SqlTrans;
                objChannelEntity.IsDeleted = true;
                objChannelEntity.Save();
            }
        }

        if (arrChannelEntity != null)
        {
            foreach (ChannelEntity objChannelEntity in this.arrChannelEntity)
            {
                objChannelEntity.ChannelCode = this.IntCode;
                objChannelEntity.IsTransactionRequired = true;
                objChannelEntity.SqlTrans = this.SqlTrans;
                if (objChannelEntity.IntCode > 0)
                    objChannelEntity.IsDirty = true;
                objChannelEntity.Save();
            }
        }

        if (arrChannelTerritory_Del != null)
        {
            foreach (ChannelTerritory objChannelTerritory in this.arrChannelTerritory_Del)
            {
                objChannelTerritory.IsTransactionRequired = true;
                objChannelTerritory.SqlTrans = this.SqlTrans;
                objChannelTerritory.IsDeleted = true;
                objChannelTerritory.Save();
            }
        }

        if (arrChannelTerritory != null)
        {
            foreach (ChannelTerritory objChannelTerritory in this.arrChannelTerritory)
            {
                objChannelTerritory.ChannelCode = this.IntCode;
                objChannelTerritory.IsTransactionRequired = true;
                objChannelTerritory.SqlTrans = this.SqlTrans;
                if (objChannelTerritory.IntCode > 0)
                    objChannelTerritory.IsDirty = true;
                objChannelTerritory.Save();
            }
        }

        if (this.IntCode > 0)
        {
            SqlTransaction objsqltransnew = (SqlTransaction)this.SqlTrans;
            string sql = "update Channel_Entity set  system_end_date= null where effective_start_date in (select max(effective_start_date) from Channel_Entity where Channel_code=" + this.IntCode + ")"
                + " and Channel_code=" + this.IntCode;
            string str = DatabaseBroker.ProcessScalarUsingTrans(sql, ref objsqltransnew);

        }
    }

    #endregion
}
