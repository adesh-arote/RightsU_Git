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
/// Summary description for CurrencyExchangeRate
/// </summary>
public class CurrencyExchangeRateBroker : DatabaseBroker {
    public CurrencyExchangeRateBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Currency_Exchange_Rate] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        CurrencyExchangeRate objCurrencyExchangeRate;
        if (obj == null)
        {
            objCurrencyExchangeRate = new CurrencyExchangeRate();
        }
        else
        {
            objCurrencyExchangeRate = (CurrencyExchangeRate)obj;
        }


        objCurrencyExchangeRate.IntCode = Convert.ToInt32(dRow["Currency_Exchange_Rate_code"]);
        #region --populate--
        if (dRow["Currency_Code"] != DBNull.Value)
            objCurrencyExchangeRate.CurrencyCode = Convert.ToInt32(dRow["Currency_Code"]);
        if (dRow["Effective_Start_Date"] != DBNull.Value)
            objCurrencyExchangeRate.EffectiveStartDate =  Convert.ToDateTime(dRow["Effective_Start_Date"]).ToString("dd/MM/yyyy"); 
        if (dRow["System_End_Date"] != DBNull.Value)
            objCurrencyExchangeRate.SystemEndDate = Convert.ToDateTime(dRow["System_End_Date"]).ToString("dd/MM/yyyy");
        if (dRow["Exchange_Rate"] != DBNull.Value)
            objCurrencyExchangeRate.ExchangeRate = Convert.ToDecimal(dRow["Exchange_Rate"]);
        #endregion
        return objCurrencyExchangeRate;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        CurrencyExchangeRate objCurrencyExchangeRate = (CurrencyExchangeRate)obj;
        string sql = "insert into [Currency_Exchange_Rate]([Currency_Code], [Effective_Start_Date], [System_End_Date], [Exchange_Rate]) values('" + objCurrencyExchangeRate.CurrencyCode + "', '" + GlobalUtil.GetFormatedDateTimeNew(objCurrencyExchangeRate.EffectiveStartDate).ToString("dd-MMM-yyyy") + "', null, '" + objCurrencyExchangeRate.ExchangeRate + "');";
        sql = "update [Currency_Exchange_Rate] set [System_End_Date]=dateadd(d,-1,'" + GlobalUtil.GetFormatedDateTimeNew(objCurrencyExchangeRate.EffectiveStartDate).ToString("dd-MMM-yyyy") + "') where Currency_Exchange_Rate_code in(select max(Currency_Exchange_Rate_code) from [Currency_Exchange_Rate] where currency_code='" + objCurrencyExchangeRate.CurrencyCode + " ')" + sql;
        return sql; 
    }

    public override string GetUpdateSql(Persistent obj)
    {
        CurrencyExchangeRate objCurrencyExchangeRate = (CurrencyExchangeRate)obj;
        string sql = "update [Currency_Exchange_Rate] set [Currency_Code] = '" + objCurrencyExchangeRate.CurrencyCode + "', [Effective_Start_Date] = '" + GlobalUtil.GetFormatedDateTimeNew(objCurrencyExchangeRate.EffectiveStartDate).ToString("dd-MMM-yyyy") + "',[Exchange_Rate] = '" + objCurrencyExchangeRate.ExchangeRate + "' where Currency_Exchange_Rate_code = '" + objCurrencyExchangeRate.IntCode + "';";

        sql += "update Currency_Exchange_Rate set system_end_date=dateadd(d,-1,'" + GlobalUtil.GetFormatedDateTimeNew(objCurrencyExchangeRate.EffectiveStartDate).ToString("dd-MMM-yyyy") + "')"
             + " where system_end_date=(select max(isnull(system_end_date,dateadd(d,-1,'" + GlobalUtil.GetFormatedDateTimeNew(objCurrencyExchangeRate.EffectiveStartDate).ToString("dd-MMM-yyyy") + "'))) from Currency_Exchange_Rate where 1=1 "
             + " and currency_exchange_rate_code!='" + objCurrencyExchangeRate.IntCode + "' and effective_start_date < '" + GlobalUtil.GetFormatedDateTimeNew(objCurrencyExchangeRate.EffectiveStartDate).ToString("dd-MMM-yyyy") + "'  and [Currency_Code] = '" + objCurrencyExchangeRate.CurrencyCode + "')and [Currency_Code] = '" + objCurrencyExchangeRate.CurrencyCode + "'";   
        return sql; 
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        CurrencyExchangeRate objCurrencyExchangeRate = (CurrencyExchangeRate)obj;

        return " DELETE FROM [Currency_Exchange_Rate] WHERE Currency_Exchange_Rate_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Currency_Exchange_Rate] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Currency_Exchange_Rate] WHERE Currency_Exchange_Rate_code = " + obj.IntCode;
    }

    public DataSet DefaultCurrency(string DefaultCurrencyText)
    {
        string StrDefaultCurrency="SELECT parameter_value FROM system_parameter_new WHERE parameter_name = '"+ DefaultCurrencyText +"'";
        int DefaultCurrency = ProcessScalarDirectly(StrDefaultCurrency);
        DataSet dsExchangeRate = DatabaseBroker.ProcessSelectDirectly("select CER.exchange_rate,(C.currency_name+'-'+C.currency_sign) AS CurrencyNameSign from Currency C inner join Currency_Exchange_Rate CER on C.currency_code = CER.currency_code where C.currency_code=" + DefaultCurrency + " ");
        return dsExchangeRate;
    }
    public int DefaultCategory(string DefaultCategoryText) 
    {
        string StrDefaultCategory = "SELECT parameter_value FROM system_parameter_new WHERE parameter_name = '" + DefaultCategoryText + "'";
        int DefaultCategory = ProcessScalarDirectly(StrDefaultCategory);
        return DefaultCategory;
    }

}
