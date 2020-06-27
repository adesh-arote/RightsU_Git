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

/// <summary>
/// Summary description for Title
/// </summary>
public class CurrencyExchangeRate : Persistent {
    public CurrencyExchangeRate()
    {
        OrderByColumnName = "Currency_Exchange_Rate_code";
        OrderByCondition = "ASC";
    }

    #region ---------------Attributes And Prperties---------------


    private int _CurrencyCode;
    public int CurrencyCode
    {
        get { return this._CurrencyCode; }
        set { this._CurrencyCode = value; }
    }

    private string _EffectiveStartDate;
    public string EffectiveStartDate
    {
        get { return this._EffectiveStartDate; }
        set { this._EffectiveStartDate = value; }
    }

    private string  _SystemEndDate;
    public string  SystemEndDate
    {
        get { return this._SystemEndDate; }
        set { this._SystemEndDate = value; }
    }

    private decimal _ExchangeRate;
    public decimal ExchangeRate
    {
        get { return this._ExchangeRate; }
        set { this._ExchangeRate = value; }
    }

    private string _DefaultCurrencyCode;
    public string  DefaultCurrencyCode
    {
        get { return this.DefaultCurrencyCode ; }
        set { this._DefaultCurrencyCode= GlobalParams.DefaultCurrencyText; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new CurrencyExchangeRateBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
