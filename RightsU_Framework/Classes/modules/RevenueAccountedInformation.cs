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


public class RevenueAccountedInformation : Persistent
{
    public RevenueAccountedInformation()
    {
        OrderByColumnName = "syndication_deal_code";
        OrderByCondition = "ASC";
        tableName = "Revenue_Accounted_Info";
        pkColName = "revenue_accounted_info_code";
    }

    #region ---------------Attributes And Prperties---------------

    private int _SyndicationDealCode;
    public int SyndicationDealCode
    {
        get { return this._SyndicationDealCode; }
        set { this._SyndicationDealCode = value; }
    }
    private int _SyndicationDealMovieCode;
    public int SyndicationDealMovieCode
    {
        get { return this._SyndicationDealMovieCode; }
        set { this._SyndicationDealMovieCode = value; }
    }

    private string _RevenueBookedDate;
    public string RevenueBookedDate
    {
        get { return this._RevenueBookedDate; }
        set { this._RevenueBookedDate = value; }
    }

    private string _Remarks;
    public string Remarks
    {
        get { return this._Remarks; }
        set { this._Remarks = value; }
    }
    private int _TitleCode;
    public int TitleCode
    {
        get { return this._TitleCode; }
        set { this._TitleCode = value; }
    }

    private Title _objTitle;
    public Title objTitle
    {
        get
        {
            if (_objTitle == null)
                this._objTitle = new Title();
            return _objTitle;
        }
        set { _objTitle = value; }
    }

    //Dummy properties
    private int _SynDealNo;
    public int SynDealNo
    {
        get { return this._SynDealNo; }
        set { this._SynDealNo = value; }
    }
    private int _syndication_deal_code;
    public int syndication_deal_code
    {
        get { return this._syndication_deal_code; }
        set { this._syndication_deal_code = value; }
    }
    private int _syndication_deal_movie_code;
    public int syndication_deal_movie_code
    {
        get { return this._syndication_deal_movie_code; }
        set { this._syndication_deal_movie_code = value; }
    }
    private int _RevenueAccountCode;
    public int RevenueAccountCode
    {
        get { return this._RevenueAccountCode; }
        set { this._RevenueAccountCode = value; }
    }
    private string _CustomerName;
    public string CustomerName
    {
        get { return this._CustomerName; }
        set { this._CustomerName= value; }
    }
    private int _CustomerCode;
    public int CustomerCode
    {
        get { return this._CustomerCode; }
        set { this._CustomerCode = value; }

    }
    private string _EnglishTitle;
    public string EnglishTitle
    {
        get { return this._EnglishTitle; }
        set { this._EnglishTitle = value; }

    }
    private string _revenue_booked_date;
    public string revenue_booked_date
    {
        get { return this._revenue_booked_date; }
        set { this._revenue_booked_date = value; }

    }
    private string _syndication_deal_date;
    public string syndication_deal_date
    {
        get { return this._syndication_deal_date; }
        set { this._syndication_deal_date = value; }

    }
    private string _remarks;
    public string remarks
    {
        get { return this._remarks; }
        set { this._remarks = value; }

    }
    private string _Country;
    public string Country
    {
        get { return this._Country; }
        set { this._Country= value; }

    }

    private Double _SynRevenueAmt;
    public Double SynRevenueAmt
    {
        get { return this._SynRevenueAmt; }
        set { this._SynRevenueAmt = value; }

    }

    //Dummy Properties


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RevenueAccountedInformationBroker();
    }

    public override void LoadObjects()
    {
        if (this.TitleCode > 0)
        {
            this.objTitle.IntCode = this.TitleCode;
            this.objTitle.Fetch();
        }

    }

    public override void UnloadObjects()
    {

    }

    #endregion

}


