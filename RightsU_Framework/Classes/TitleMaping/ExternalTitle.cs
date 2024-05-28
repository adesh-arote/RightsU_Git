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
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for Title
/// </summary>
public class ExternalTitle : Persistent
{
    public ExternalTitle()
    {
        OrderByColumnName = "external_title_code";
        OrderByCondition = "ASC";
        tableName = "External_Title";
        pkColName = "external_title_code";
    }

    #region ---------------Attributes And Prperties---------------

    public int ExternalTitleCode
    {
        get { return this.IntCode; }
        set { this.IntCode = value; }
    }

    private string _TitleName;
    public string TitleName
    {
        get { return this._TitleName; }
        set { this._TitleName = value; }
    }

    private string _CompleteTitleName;
    public string CompleteTitleName
    {
        get { return this._CompleteTitleName; }
        set { this._CompleteTitleName = value; }

    }
    private string _MasterFormat;
    public string MasterFormat
    {
        get { return this._MasterFormat; }
        set { this._MasterFormat = value; }
    }

    private DateTime _ReleaseDate;
    public DateTime ReleaseDate
    {
        get { return this._ReleaseDate; }
        set { this._ReleaseDate = value; }
    }

    private DateTime _RightsExpiry;
    public DateTime RightsExpiry
    {
        get { return this._RightsExpiry; }
        set { this._RightsExpiry = value; }
    }

    private string _TitleType;
    public string TitleType
    {
        get { return this._TitleType; }
        set { this._TitleType = value; }
    }

    private string _BoxSingle;
    public string BoxSingle
    {
        get { return this._BoxSingle; }
        set { this._BoxSingle = value; }
    }

    private string _SAPInternalOrder;
    public string SAPInternalOrder
    {
        get { return this._SAPInternalOrder; }
        set { this._SAPInternalOrder = value; }
    }

    private int _DealMovieCode;
    public int DealMovieCode
    {
        get { return this._DealMovieCode; }
        set { this._DealMovieCode = value; }
    }


    public string PromotionTitleName
    {
        get
        {
            if (this.IntCode > 0)
            {
                string str = this.TitleName + " - " + this.MasterFormat + " - " + (this.TitleType == "O" ? "Original" : "Dubbed");
                return str;
            }
            return "";
        }
    }
    private TitlePromotion _objTitlePromotion;
    public TitlePromotion objTitlePromotion
    {
        get
        {
            if (this._objTitlePromotion == null)
                this._objTitlePromotion = new TitlePromotion();
            return this._objTitlePromotion;
        }
        set { this._objTitlePromotion = value; }
    }
    //private TitleMapping _objTitleMapping;
    //public TitleMapping objTitleMapping
    //{
    //    get
    //    {
    //        if (this._objTitleMapping == null)
    //            this._objTitleMapping = new TitleMapping();
    //        return this._objTitleMapping;
    //    }
    //    set { this._objTitleMapping = value; }
    //}
    private int _TitlePromotionCode;
    public int TitlePromotionCode
    {
        get { return _TitlePromotionCode; }
        set
        {
            _TitlePromotionCode = value;
            if (objTitlePromotion != null && objTitlePromotion.IntCode != value)
            {
                objTitlePromotion.IntCode = value;
                objTitlePromotion.Fetch();
            }
        }
    }
    //private int _TitleMappingCode;
    //public int TitleMappingCode
    //{
    //    get { return _TitleMappingCode; }
    //    set
    //    {
    //        _TitleMappingCode = value;
    //        if (objTitleMapping != null && objTitleMapping.IntCode != value)
    //        {
    //            objTitleMapping.IntCode = value;
    //            objTitleMapping.Fetch();
    //        }
    //    }
    //}
    public string DealNo { get; set; }
    public string DealTitleName { get; set; }
    public string EffectiveStDt { get; set; }
    public bool isChecked { get; set; }
    public DateTime ReleaseDateFromTitleMappingPage { get; set; }

    public string BoxSetMapp_TitleName
    {
        get
        {
            if (this.IntCode > 0)
            {
                string str = this.TitleName + " - " + (this.TitleType == "O" ? "Original" : "Dubbed") + " - " + this.MasterFormat;
                return str;
            }
            return "";
        }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ExternalTitleBroker();
    }

    public override void LoadObjects()
    {
        if (this.TitlePromotionCode > 0)
        {
            objTitlePromotion.IntCode = this.TitlePromotionCode;
            objTitlePromotion.Fetch();
        }
    }

    public override void UnloadObjects()
    {

    }
    public string GetCountSql(string strSearchString)
    {
        return ((ExternalTitleBroker)GetBroker()).GetCountSql(strSearchString);
    }
    #endregion
}
