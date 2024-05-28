using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for Title
/// </summary>
public class Currency : Persistent
{
    public Currency()
    {
        tableName = "Currency";
        pkColName = "Currency_Code";
        OrderByColumnName = "Currency_Code";
        OrderByCondition = "ASC";
        Basecurrency = "N";
    }

    #region ---------------Attributes And Prperties---------------


    private string _CurrencyName;
    public string CurrencyName
    {
        get { return this._CurrencyName; }
        set { this._CurrencyName = value; }
    }

    private string _CurrencySign;
    public string CurrencySign
    {
        get { return this._CurrencySign; }
        set { this._CurrencySign = value; }
    }

    private char _IsActive;
    public char IsActive
    {
        get { return this._IsActive; }
        set { this._IsActive = value; }
    }
    private string _basecurrency;
    public string Basecurrency
    {
        get { return _basecurrency; }
        set { _basecurrency = value; }
    }
    private decimal _exchangeRate;
    public decimal ExchangeRate
    {
        get { return _exchangeRate; }
        set { _exchangeRate = value; }
    }

    public string CurrencyNameSign
    {
        get { return this._CurrencyName + "-" + this._CurrencySign; }
    }
    public string IntCodeIsBase
    {
        get { return this.IntCode + "-" + (string.IsNullOrEmpty(this.Basecurrency) ? "N" : this.Basecurrency); }
    }
    private ArrayList _arrCurrencyExchangeRate_Del;
    public ArrayList arrCurrencyExchangeRate_Del
    {
        get
        {
            if (this._arrCurrencyExchangeRate_Del == null)
                this._arrCurrencyExchangeRate_Del = new ArrayList();
            return this._arrCurrencyExchangeRate_Del;
        }
        set { this._arrCurrencyExchangeRate_Del = value; }
    }

    private ArrayList _arrCurrencyExchangeRate;
    public ArrayList arrCurrencyExchangeRate
    {
        get
        {
            if (this._arrCurrencyExchangeRate == null)
                this._arrCurrencyExchangeRate = new ArrayList();
            return this._arrCurrencyExchangeRate;
        }
        set { this._arrCurrencyExchangeRate = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new CurrencyBroker();
    }

    public override void LoadObjects()
    {

        this.arrCurrencyExchangeRate = DBUtil.FillArrayList(new CurrencyExchangeRate(), " and Currency_Code = '" + this.IntCode + "'", true);

    }


    public override void UnloadObjects()
    {

        if (arrCurrencyExchangeRate_Del != null)
        {
            foreach (CurrencyExchangeRate objCurrencyExchangeRate in this.arrCurrencyExchangeRate_Del)
            {
                objCurrencyExchangeRate.IsTransactionRequired = true;
                objCurrencyExchangeRate.SqlTrans = this.SqlTrans;
                objCurrencyExchangeRate.IsDeleted = true;
                objCurrencyExchangeRate.Save();
            }
        }
        if (arrCurrencyExchangeRate != null)
        {
            foreach (CurrencyExchangeRate objCurrencyExchangeRate in this.arrCurrencyExchangeRate)
            {
                objCurrencyExchangeRate.CurrencyCode = this.IntCode;
                objCurrencyExchangeRate.IsTransactionRequired = true;
                objCurrencyExchangeRate.SqlTrans = this.SqlTrans;
                if (objCurrencyExchangeRate.IntCode > 0)
                    objCurrencyExchangeRate.IsDirty = true;
                objCurrencyExchangeRate.Save();
            }
        }

        if (this.IntCode > 0)
        {
            SqlTransaction objsqltransnew = (SqlTransaction)this.SqlTrans;
            string sql = "update Currency_Exchange_Rate set  system_end_date= null where effective_start_date in (select max(effective_start_date) from Currency_Exchange_Rate where currency_code=" + this.IntCode + ")"
                + " and currency_code=" + this.IntCode;
            string str = DatabaseBroker.ProcessScalarUsingTrans(sql, ref objsqltransnew);

        }

    }


    #endregion

    public decimal getCurrentExchageRate(int currencyCode, string dealdate)
    {
        return ((CurrencyBroker)this.GetBroker()).getCurrentExchageRate(currencyCode, dealdate);
    }
    public int checkrefrence(int currencyCode)
    {
        return ((CurrencyBroker)this.GetBroker()).checkrefrence(currencyCode);
    }
     
}
