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
/// Summary description for RevenueDataTheatre
/// </summary>
public class RevenueDataTheatreBroker : DatabaseBroker
{
    public RevenueDataTheatreBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [revenue_data_theatre] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RevenueDataTheatre objRevenueDataTheatre;
        if (obj == null)
        {
            objRevenueDataTheatre = new RevenueDataTheatre();
        }
        else
        {
            objRevenueDataTheatre = (RevenueDataTheatre)obj;
        }

        objRevenueDataTheatre.IntCode = Convert.ToInt32(dRow["revenue_data_theatre_code"]);
        #region --populate--
        if (dRow["distributor_vendor_code"] != DBNull.Value)
            objRevenueDataTheatre.DistributorVendorCode = Convert.ToInt32(dRow["distributor_vendor_code"]);
        objRevenueDataTheatre.TheatreName = Convert.ToString(dRow["theatre_name"]);
        if (dRow["city_name"] != DBNull.Value)
            objRevenueDataTheatre.CityName = Convert.ToString(dRow["city_name"]);
        if (dRow["deal_movie_code"] != DBNull.Value)
            objRevenueDataTheatre.DealMovieCode = Convert.ToInt32(dRow["deal_movie_code"]);
        objRevenueDataTheatre.TitleCodeId = Convert.ToString(dRow["title_code_id"]);
        if (dRow["from_date"] != DBNull.Value)
            objRevenueDataTheatre.FromDate = Convert.ToDateTime(dRow["from_date"]);
        if (dRow["to_date"] != DBNull.Value)
            objRevenueDataTheatre.ToDate = Convert.ToDateTime(dRow["to_date"]);
        if (dRow["days"] != DBNull.Value)
            objRevenueDataTheatre.Days = Convert.ToDecimal(dRow["days"]);
        if (dRow["show_per_day"] != DBNull.Value)
            objRevenueDataTheatre.ShowPerDay = Convert.ToDecimal(dRow["show_per_day"]);
        if (dRow["no_of_seat"] != DBNull.Value)
            objRevenueDataTheatre.NoOfSeat = Convert.ToDecimal(dRow["no_of_seat"]);
        if (dRow["ticket_rate"] != DBNull.Value)
            objRevenueDataTheatre.TicketRate = Convert.ToDecimal(dRow["ticket_rate"]);
        if (dRow["st"] != DBNull.Value)
            objRevenueDataTheatre.St = Convert.ToDecimal(dRow["st"]);
        if (dRow["ent_tax"] != DBNull.Value)
            objRevenueDataTheatre.EntTax = Convert.ToDecimal(dRow["ent_tax"]);
        if (dRow["net_amount"] != DBNull.Value)
            objRevenueDataTheatre.NetAmount = Convert.ToDecimal(dRow["net_amount"]);
        if (dRow["revenue"] != DBNull.Value)
            objRevenueDataTheatre.Revenue = Convert.ToDecimal(dRow["revenue"]);
        #endregion
        return objRevenueDataTheatre;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        RevenueDataTheatre objRevenueDataTheatre = (RevenueDataTheatre)obj;
        return "insert into [revenue_data_theatre]([distributor_vendor_code], [theatre_name], [city_name], [deal_movie_code], [title_code_id], [from_date], [to_date], [days], [show_per_day], [no_of_seat], [ticket_rate], [st], [ent_tax], [net_amount], [revenue]) values('" + objRevenueDataTheatre.DistributorVendorCode + "', '" + objRevenueDataTheatre.TheatreName.Trim().Replace("'", "''") + "', '" + objRevenueDataTheatre.CityName + "',dbo.fn_get_DealMovieCode_From_TitleCode('" + objRevenueDataTheatre.DealMovieCode + "'), '" + objRevenueDataTheatre.TitleCodeId.Trim().Replace("'", "''") + "', '" + objRevenueDataTheatre.FromDate + "', '" + objRevenueDataTheatre.ToDate + "', '" + objRevenueDataTheatre.Days + "', '" + objRevenueDataTheatre.ShowPerDay + "', '" + objRevenueDataTheatre.NoOfSeat + "', '" + objRevenueDataTheatre.TicketRate + "', '" + objRevenueDataTheatre.St + "', '" + objRevenueDataTheatre.EntTax + "', '" + objRevenueDataTheatre.NetAmount + "', '" + objRevenueDataTheatre.Revenue + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        RevenueDataTheatre objRevenueDataTheatre = (RevenueDataTheatre)obj;
        return "update [revenue_data_theatre] set [distributor_vendor_code] = '" + objRevenueDataTheatre.DistributorVendorCode + "', [theatre_name] = '" + objRevenueDataTheatre.TheatreName.Trim().Replace("'", "''") + "', [city_name] = '" + objRevenueDataTheatre.CityName + "', [deal_movie_code] = '" + objRevenueDataTheatre.DealMovieCode + "', [title_code_id] = '" + objRevenueDataTheatre.TitleCodeId.Trim().Replace("'", "''") + "', [from_date] = '" + objRevenueDataTheatre.FromDate + "', [to_date] = '" + objRevenueDataTheatre.ToDate + "', [days] = '" + objRevenueDataTheatre.Days + "', [show_per_day] = '" + objRevenueDataTheatre.ShowPerDay + "', [no_of_seat] = '" + objRevenueDataTheatre.NoOfSeat + "', [ticket_rate] = '" + objRevenueDataTheatre.TicketRate + "', [st] = '" + objRevenueDataTheatre.St + "', [ent_tax] = '" + objRevenueDataTheatre.EntTax + "', [net_amount] = '" + objRevenueDataTheatre.NetAmount + "', [revenue] = '" + objRevenueDataTheatre.Revenue + "' where revenue_data_theatre_code = '" + objRevenueDataTheatre.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        RevenueDataTheatre objRevenueDataTheatre = (RevenueDataTheatre)obj;

        return " DELETE FROM [revenue_data_theatre] WHERE revenue_data_theatre_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        RevenueDataTheatre objRevenueDataTheatre = (RevenueDataTheatre)obj;
        return "Update [revenue_data_theatre] set Is_Active='" + objRevenueDataTheatre.Is_Active + "',lock_time=null, last_updated_time= getdate() where revenue_data_theatre_code = '" + objRevenueDataTheatre.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [revenue_data_theatre] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [revenue_data_theatre] WHERE  revenue_data_theatre_code = " + obj.IntCode;
    }
}
