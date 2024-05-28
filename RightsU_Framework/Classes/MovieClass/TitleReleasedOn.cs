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
public class TitleReleasedOn : Persistent
{
    public TitleReleasedOn()
    {
        OrderByColumnName = "title_released_on_code";
        OrderByCondition = "ASC";
        tableName = "Title_Released_On";
        pkColName = "title_released_on_code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _TitleCode;
    public int TitleCode
    {
        get { return this._TitleCode; }
        set { this._TitleCode = value; }
    }

    private int _PlatformCode;
    public int PlatformCode
    {
        get { return this._PlatformCode; }
        set { this._PlatformCode = value; }
    }

    private string _ReleasedOnDate;
    public string ReleasedOnDate
    {
        get { return this._ReleasedOnDate; }
        set { this._ReleasedOnDate = value; }
    }

    private string _ReleaseType;
    public string ReleaseType
    {
        get { return this._ReleaseType; }
        set { this._ReleaseType = value; }
    }

    private int _TerritoryCode;
    public int TerritoryCode
    {
        get { return this._TerritoryCode; }
        set { this._TerritoryCode = value; }
    }

    private int _CountryCode;
    public int CountryCode
    {
        get { return this._CountryCode; }
        set { this._CountryCode = value; }
    }

    private string _IsShowEditDeleteBtn;
    public string IsShowEditDeleteBtn
    {
        get { return this._IsShowEditDeleteBtn; }
        set { this._IsShowEditDeleteBtn = value; }
    }

    private TerritoryDetails _objTerritoryGroupDetails;
    public TerritoryDetails objTerritoryGroupDetails
    {
        get
        {
            if (this._objTerritoryGroupDetails == null)
                this._objTerritoryGroupDetails = new TerritoryDetails();
            return this._objTerritoryGroupDetails;
        }
        set { this._objTerritoryGroupDetails = value; }
    }

    private Platform _objPlatform;
    public Platform objPlatform
    {
        get
        {
            if (this._objPlatform == null)
                this._objPlatform = new Platform();
            return this._objPlatform;
        }
        set { this._objPlatform = value; }
    }

    private Title _objTitle;
    public Title objTitle
    {
        get
        {
            if (this._objTitle == null)
                this._objTitle = new Title();
            return this._objTitle;
        }
        set { this._objTitle = value; }
    }

    private string _IsNewlyAdded;
    public string IsNewlyAdded
    {
        get { return this._IsNewlyAdded; }
        set { this._IsNewlyAdded = value; }
    }

    //------------------
    private string _PlatformNames;
    public string PlatformNames
    {
        get { return this._PlatformNames; }
        set { this._PlatformNames = value; }
    }

    private int _GroupCode;
    public int GroupCode
    {
        get { return this._GroupCode; }
        set { this._GroupCode = value; }
    }

    private int _TerritoryName;
    public int TerritoryName
    {
        get { return this._TerritoryName; }
        set { this._TerritoryName = value; }
    }

    private int _CountryName;
    public int CountryName
    {
        get { return this._CountryName; }
        set { this._CountryName = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new TitleReleasedOnBroker();
    }

    public override void LoadObjects()
    {

        //if (this.TitleCode > 0)
        //{
        //    this.objTerritoryGroupDetails.IntCode = this.TitleCode;
        //    this.objTerritoryGroupDetails.Fetch();
        //}

        if (this.PlatformCode > 0)
        {
            this.objPlatform.IntCode = this.PlatformCode;
            this.objPlatform.Fetch();
        }
        if (this.TitleCode > 0)
        {
            this.objTitle.IntCode = this.TitleCode;
            this.objTitle.Fetch();
        }

    }

    public override void UnloadObjects()
    {
        //if (this.IntCode == 0)
        //{ 

        if (this.IsNewlyAdded == YesNo.Y.ToString())
        {
            SqlTransaction objSqlTrans = (SqlTransaction)this.SqlTrans;
            ((TitleReleasedOnBroker)this.GetBroker()).TitleRelease(this.TitleCode, this.ReleasedOnDate, this.PlatformCode, this.ReleaseType, this.TerritoryCode, this.CountryCode, ref objSqlTrans);
        }

        //}
    }

    #endregion
}
