using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Data.SqlClient;
using UTOFrameWork.FrameworkClasses;

public class RoyaltyExchangeRateBroker : DatabaseBroker
{
    public RoyaltyExchangeRateBroker()
    {
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Deal_Royalty_Exchange_Rate] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RoyaltyExchangeRate objRoyaltyExchangeRate;
        if (obj == null)
        {
            objRoyaltyExchangeRate = new RoyaltyExchangeRate();
        }
        else
        {
            objRoyaltyExchangeRate = (RoyaltyExchangeRate)obj;
        }

        objRoyaltyExchangeRate.IntCode = Convert.ToInt32(dRow["deal_royalty_exchange_rate_code"]);
        #region --populate--
        if (dRow["deal_code"] != DBNull.Value)
            objRoyaltyExchangeRate.DealCode = Convert.ToInt32(dRow["deal_code"]);
        if (dRow["from_month"] != DBNull.Value)
            objRoyaltyExchangeRate.FromMonth = Convert.ToInt32(dRow["from_month"]);
        if (dRow["from_year"] != DBNull.Value)
            objRoyaltyExchangeRate.FromYear = Convert.ToInt32(dRow["from_year"]);
        if (dRow["to_month"] != DBNull.Value)
            objRoyaltyExchangeRate.ToMonth = Convert.ToInt32(dRow["to_month"]);
        if (dRow["to_year"] != DBNull.Value)
            objRoyaltyExchangeRate.ToYear = Convert.ToInt32(dRow["to_year"]);
        if (dRow["exchange_rate"] != DBNull.Value)
            objRoyaltyExchangeRate.ExchangeRate = Convert.ToDecimal(dRow["exchange_rate"]);
        if (dRow["inserted_on"] != DBNull.Value)
            objRoyaltyExchangeRate.InsertedOn = Convert.ToString(dRow["inserted_on"]);
        if (dRow["inserted_by"] != DBNull.Value)
            objRoyaltyExchangeRate.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
        if (dRow["lock_time"] != DBNull.Value)
            objRoyaltyExchangeRate.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objRoyaltyExchangeRate.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objRoyaltyExchangeRate.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);

        objRoyaltyExchangeRate.FromMnthYear = GetFromMonthYear(objRoyaltyExchangeRate.FromMonth, objRoyaltyExchangeRate.FromYear);
        objRoyaltyExchangeRate.ToMnthYear = GetToMonthYear(objRoyaltyExchangeRate.ToMonth, objRoyaltyExchangeRate.ToYear);

        #endregion
        return objRoyaltyExchangeRate;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        RoyaltyExchangeRate objRoyaltyExchangeRate = (RoyaltyExchangeRate)obj;

        string strSqlInsert = " INSERT INTO [Deal_Royalty_Exchange_Rate]([deal_code],[from_month],[from_year],[to_month],[to_year],[exchange_rate],[inserted_on]," +
                            " [inserted_by],[lock_time],[last_updated_time],[last_action_by]) VALUES ('" + objRoyaltyExchangeRate.DealCode + "','" + objRoyaltyExchangeRate.FromMonth + "'," +
                            " '" + objRoyaltyExchangeRate.FromYear + "','" + objRoyaltyExchangeRate.ToMonth + "','" + objRoyaltyExchangeRate.ToYear + "','" + objRoyaltyExchangeRate.ExchangeRate + "'," +
                            "  getDate(), '" + objRoyaltyExchangeRate.InsertedBy + "', null, getDate(), '" + objRoyaltyExchangeRate.InsertedBy + "')";


        return (strSqlInsert);
    }

    public override string GetUpdateSql(Persistent obj)
    {
        RoyaltyExchangeRate objRoyaltyExchangeRate = (RoyaltyExchangeRate)obj;

        string strSqlUpdate = " UPDATE [Deal_Royalty_Exchange_Rate] SET [deal_code] ='" + objRoyaltyExchangeRate.DealCode + "' ,[from_month] ='" + objRoyaltyExchangeRate.FromMonth + "' ,[from_year] ='" + objRoyaltyExchangeRate.FromYear + "' ,[to_month] ='" + objRoyaltyExchangeRate.ToMonth + "'," +
                             " [to_year] ='" + objRoyaltyExchangeRate.ToYear + "' , [exchange_rate] ='" + objRoyaltyExchangeRate.ExchangeRate + "',[lock_time] =null ,[last_updated_time] =getDate(),[last_action_by] = '" + objRoyaltyExchangeRate.LastActionBy + "' " +
                             " where deal_royalty_exchange_rate_code = '" + objRoyaltyExchangeRate.IntCode + "';";
        return strSqlUpdate;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        RoyaltyExchangeRate objBussinessStatementDetails = (RoyaltyExchangeRate)obj;

        return " DELETE FROM [Deal_Royalty_Exchange_Rate] WHERE deal_royalty_exchange_rate_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        RoyaltyExchangeRate objBussinessStatementDetails = (RoyaltyExchangeRate)obj;
        string strSql = "UPDATE [Deal_Royalty_Exchange_Rate] SET Is_Active='" + objBussinessStatementDetails.Is_Active + "',[Lock_Time]=null,[Last_Updated_Time] = getDate() WHERE deal_royalty_exchange_rate_code =" + objBussinessStatementDetails.IntCode;
        return (strSql);
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Deal_Royalty_Exchange_Rate] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Deal_Royalty_Exchange_Rate] WHERE deal_royalty_exchange_rate_code = " + obj.IntCode;
    }

    internal string GetFromMonthYear(int fromMnth, int fromYear)
    {
        string fromMonthYear=string.Empty;
        switch (fromMnth)
        {
            case 1: fromMonthYear = "Jan - " + fromYear;
                break;
            case 2: fromMonthYear = "Feb - " + fromYear;
                break;
            case 3: fromMonthYear = "Mar - " + fromYear;
                break;
            case 4: fromMonthYear = "Apr - " + fromYear;
                break;
            case 5: fromMonthYear = "May - " + fromYear;
                break;
            case 6: fromMonthYear = "Jun - " + fromYear;
                break;
            case 7: fromMonthYear = "Jul - " + fromYear;
                break;
            case 8: fromMonthYear = "Aug - " + fromYear;
                break;
            case 9: fromMonthYear = "Sep - " + fromYear;
                break;
            case 10: fromMonthYear = "Oct - " + fromYear;
                break;
            case 11: fromMonthYear = "Nov - " + fromYear;
                break;
            case 12: fromMonthYear = "Dec - " + fromYear;
                break;
        }
        return fromMonthYear;
    }

    internal string GetToMonthYear(int toMnth, int toYear)
    {
        string toMonthYear = string.Empty;
        switch (toMnth)
        {
            case 1: toMonthYear = "Jan - " + toYear;
                break;
            case 2: toMonthYear = "Feb - " + toYear;
                break;
            case 3: toMonthYear = "Mar - " + toYear;
                break;
            case 4: toMonthYear = "Apr - " + toYear;
                break;
            case 5: toMonthYear = "May - " + toYear;
                break;
            case 6: toMonthYear = "Jun - " + toYear;
                break;
            case 7: toMonthYear = "Jul - " + toYear;
                break;
            case 8: toMonthYear = "Aug - " + toYear;
                break;
            case 9: toMonthYear = "Sep - " + toYear;
                break;
            case 10: toMonthYear = "Oct - " + toYear;
                break;
            case 11: toMonthYear = "Nov - " + toYear;
                break;
            case 12: toMonthYear = "Dec - " + toYear;
                break;
        }
        return toMonthYear;
    }

    

}

