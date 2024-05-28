using System;
using System.Data;
using System.Configuration;
using System.Collections;
using UTOFrameWork.FrameworkClasses;

public class RoyaltyExchangeRate:Persistent
{
    public RoyaltyExchangeRate()
    {
        OrderByColumnName = "deal_royalty_exchange_rate_code";
        OrderByCondition = "ASC";
        tableName = "Deal_Royalty_Exchange_Rate";
        pkColName = "deal_royalty_exchange_rate_code";
    }

    #region ---------------Attributes And Prperties---------------

    private int _DealCode;
    public int DealCode
    {
        get { return this._DealCode; }
        set { this._DealCode = value; }
    }
    private int _FromMonth;
    public int FromMonth
    {
        get { return this._FromMonth; }
        set { this._FromMonth = value; }
    }
    private int _FromYear;
    public int FromYear
    {
        get { return this._FromYear; }
        set { this._FromYear = value; }
    }
    private int _ToMonth;
    public int ToMonth
    {
        get { return this._ToMonth; }
        set { this._ToMonth = value; }
    }
    private int _ToYear;
    public int ToYear
    {
        get { return this._ToYear; }
        set { this._ToYear = value; }
    }
    private Decimal _ExchangeRate;
    public Decimal ExchangeRate
    {
        get { return this._ExchangeRate; }
        set { this._ExchangeRate = value; }
    }
    
    /* Properties for month and year in proper format */
    private string _FromMnthYear;
    public string FromMnthYear
    {
        get { return this._FromMnthYear; }
        set { this._FromMnthYear = value; }
    }
    private string _ToMnthYear;
    public string ToMnthYear
    {
        get { return this._ToMnthYear; }
        set { this._ToMnthYear = value; }
    }
    /* Properties for month and year in proper format */

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RoyaltyExchangeRateBroker();
    }

    public override void LoadObjects()
    {
        
    }

    public override void UnloadObjects()
    {

    }

    #endregion


}

