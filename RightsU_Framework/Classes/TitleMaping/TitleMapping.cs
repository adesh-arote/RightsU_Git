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
public class TitleMapping : Persistent
{
    public TitleMapping()
    {
        OrderByColumnName = "title_mapping_code";
        OrderByCondition = "ASC";
        tableName = "Title_Mapping";
        pkColName = "title_mapping_code";
    }

    #region ---------------Attributes And Prperties---------------

    public int TitleMappingCode
    {
        get { return this.IntCode; }
        set { this.IntCode = value; }
    }

    private int _ExternalTitleCode;
    public int ExternalTitleCode
    {
        get { return this._ExternalTitleCode; }
        set { this._ExternalTitleCode = value; }
    }

    private int _DealMoiveCode;
    public int DealMoiveCode
    {
        get { return this._DealMoiveCode; }
        set { this._DealMoiveCode = value; }
    }

    private DateTime _EffectiveStartDate;
    public DateTime EffectiveStartDate
    {
        get { return this._EffectiveStartDate; }
        set { this._EffectiveStartDate = value; }
    }

    private DateTime _EffectiveEndDate;
    public DateTime EffectiveEndDate
    {
        get { return this._EffectiveEndDate; }
        set { this._EffectiveEndDate = value; }
    }

    private ExternalTitle _objExternalTitle;
    public ExternalTitle objExternalTitle
    {
        get
        {
            if (this._objExternalTitle == null)
                this._objExternalTitle = new ExternalTitle();
            return this._objExternalTitle;
        }
        set { this._objExternalTitle = value; }
    }
    public string DealTitleName { get; set; }

    private DateTime _EffectiveStartDateForMovement;
    public DateTime EffectiveStartDateForMovement
    {
        get { return this._EffectiveStartDateForMovement; }
        set { this._EffectiveStartDateForMovement = value; }
    }
    private DateTime _MaxDateFromRoyalty;
    public DateTime MaxDateFromRoyalty
    {
        get { return this._MaxDateFromRoyalty; }
        set { this._MaxDateFromRoyalty = value; }
    }
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new TitleMappingBroker();
    }

    public override void LoadObjects()
    {
        if (this.ExternalTitleCode > 0)
        {
            this.objExternalTitle.IntCode = this.ExternalTitleCode;
            this.objExternalTitle.Fetch();
        }
    }

    public override void UnloadObjects()
    {
        insertMovieDealCode(Convert.ToInt32(this.DealMoiveCode), Convert.ToInt32(this.ExternalTitleCode), (SqlTransaction)this.SqlTrans);

    }
    public string GetCountSql(string strSearchString)
    {
        return ((TitleMappingBroker)GetBroker()).GetCountSql(strSearchString);
    }
    public void insertMovieDealCode(int DealMovieCode, int ExternalTitleCode, SqlTransaction SqlTrans)
    {
        (new TitleMappingBroker()).insertMovieDealCode(DealMovieCode, ExternalTitleCode, SqlTrans);
    }

    public DateTime DateofDealsign(int DealMovieCode)
    {
        return (new TitleMappingBroker()).DateofDealsign(DealMovieCode);
    }

    #endregion
}
