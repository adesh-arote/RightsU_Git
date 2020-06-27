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
/// Summary description for Currency
/// </summary>
public class CurrencyBroker : DatabaseBroker
{
    public CurrencyBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Currency] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Currency objCurrency;
        if (obj == null)
        {
            objCurrency = new Currency();
        }
        else
        {
            objCurrency = (Currency)obj;
        }

        objCurrency.IntCode = Convert.ToInt32(dRow["Currency_Code"]);
        #region --populate--
        objCurrency.CurrencyName = Convert.ToString(dRow["Currency_Name"]);
        objCurrency.CurrencySign = Convert.ToString(dRow["Currency_Sign"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objCurrency.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objCurrency.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objCurrency.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objCurrency.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objCurrency.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objCurrency.IsActive = Convert.ToChar(dRow["Is_Active"]);
        if (dRow["is_base_currency"] != DBNull.Value)
            objCurrency.Basecurrency = Convert.ToString(dRow["is_base_currency"]);
        #endregion
        return objCurrency;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Currency objCurrency = (Currency)obj;
        return DBUtil.IsDuplicateSqlTrans(ref obj, "Currency", "Currency_Name", objCurrency.CurrencyName, "Currency_Code", objCurrency.IntCode, "Currency Name already exists", "", true);


    }


    public override string GetInsertSql(Persistent obj)
    {
        Currency objCurrency = (Currency)obj;
        string sql = "insert into [Currency]([Currency_Name], [Currency_Sign], [Inserted_On], "
            + " [Inserted_By], [Last_Updated_Time], [Last_Action_By], [Is_Active],is_base_currency) "
            + " values(N'" + objCurrency.CurrencyName.Trim().Replace("'", "''") + "', "
            + " N'" + objCurrency.CurrencySign.Trim().Replace("'", "''") + "', "
            + " getdate(), "
            + " '" + objCurrency.InsertedBy + "', "
            + " getdate(), "
            + " '" + objCurrency.LastActionBy + "', 'Y','" + objCurrency.Basecurrency + "');";
        return sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Currency objCurrency = (Currency)obj;
        string sql = "update [Currency] set [Currency_Name] = N'" + objCurrency.CurrencyName.Trim().Replace("'", "''") + "', [Currency_Sign] = N'" + objCurrency.CurrencySign.Trim().Replace("'", "''") + "', [Lock_Time] = null, [Last_Updated_Time] = getDate() , [Last_Action_By] = '" + objCurrency.LastActionBy + "',is_base_currency='" + objCurrency.Basecurrency + "' where Currency_Code = '" + objCurrency.IntCode + "';";
        return sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Currency objCurrency = (Currency)obj;
        if (objCurrency.arrCurrencyExchangeRate.Count > 0)
            DBUtil.DeleteChild("CurrencyExchangeRate", objCurrency.arrCurrencyExchangeRate, objCurrency.IntCode, (SqlTransaction)objCurrency.SqlTrans);

        return " DELETE FROM [Currency] WHERE Currency_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Currency objCurrency = (Currency)obj;
        string sql = " update Currency set is_Active='" + objCurrency.IsActive + "' where Currency_Code=" + objCurrency.IntCode;
        return sql;
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Currency] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Currency] WHERE  Currency_Code = " + obj.IntCode;
    }

    internal Decimal getCurrentExchageRate(int currencyCode, string dealdate)
    {
        if (currencyCode > 0)
        {
            
            string sqlExec = " select Exchange_Rate from currency_exchange_rate where currency_code=" + currencyCode + " and convert(datetime,'" + dealdate + "',103) between Effective_Start_Date and isnull(System_End_Date,getdate())  ";
            //return Convert.ToDecimal(((DataSet)ProcessSelectDirectly(sqlExec)).Tables[0].Rows[0][0]);
            decimal Exchange_rate = Convert.ToDecimal(ProcessScalar(sqlExec));
            return  Exchange_rate;
        }
        else
        {
            return 0;
        }
    }

    public int checkrefrence(int currencycode)
    {
        string sql;
        int count;
		sql = "select count(*) from deal where currency_code=" + currencycode + " and ISNULL(is_active,'N') = 'Y' ";
        count = ProcessScalarDirectly(sql);
        if (count > 0)
        {
            return 1;
        }
        return count;

    }

}
