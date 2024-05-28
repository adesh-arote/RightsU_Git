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
/// Summary description for BussinessStatementDetails
/// </summary>
public class RevenueAccountedInformationBroker : DatabaseBroker
{
    public RevenueAccountedInformationBroker()
    {
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Revenue_Accounted_Info] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RevenueAccountedInformation objRevenueAccountedInformation;
        if (obj == null)
        {
            objRevenueAccountedInformation = new RevenueAccountedInformation();
        }
        else
        {
            objRevenueAccountedInformation = (RevenueAccountedInformation)obj;
        }

        objRevenueAccountedInformation.IntCode = Convert.ToInt32(dRow["revenue_accounted_info_code"]);
        #region --populate--
        if (dRow["syndication_deal_code"] != DBNull.Value)
            objRevenueAccountedInformation.SyndicationDealCode = Convert.ToInt32(dRow["syndication_deal_code"]);
        if (dRow["syndication_deal_movie_code"] != DBNull.Value)
            objRevenueAccountedInformation.SyndicationDealMovieCode = Convert.ToInt32(dRow["syndication_deal_movie_code"]);
        if (dRow["title_code"] != DBNull.Value)
            objRevenueAccountedInformation.TitleCode = Convert.ToInt32(dRow["title_code"]);
        if (dRow["revenue_booked_date"] != DBNull.Value)
            objRevenueAccountedInformation.RevenueBookedDate = Convert.ToDateTime(dRow["revenue_booked_date"]).ToString("dd/MM/yyyy");
        else
            objRevenueAccountedInformation.RevenueBookedDate = "";

        objRevenueAccountedInformation.Remarks = Convert.ToString(dRow["remarks"]);
        if (dRow["lock_time"] != DBNull.Value)
            objRevenueAccountedInformation.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objRevenueAccountedInformation.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objRevenueAccountedInformation.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);

        #endregion
        return objRevenueAccountedInformation;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        RevenueAccountedInformation objRevenueAccountedInformation = (RevenueAccountedInformation)obj;
        string date = objRevenueAccountedInformation.RevenueBookedDate == "0" ? "NULL" : "convert(datetime,'" + objRevenueAccountedInformation.RevenueBookedDate + "',103)";

        string strSql = " insert into [Revenue_Accounted_Info]([syndication_deal_code],[syndication_deal_movie_code],[revenue_booked_date],[remarks],[title_code]," +
                        " [lock_time],[last_updated_time], [last_action_by]) values(" + objRevenueAccountedInformation.SyndicationDealCode + "," + objRevenueAccountedInformation.SyndicationDealMovieCode + "," +
                        " " + date + ",'" + objRevenueAccountedInformation.Remarks.Trim().Replace("'", "''") + "','" + objRevenueAccountedInformation.TitleCode + "'," +
                        " null,getdate(),'" + objRevenueAccountedInformation.LastActionBy + "')";
        return (strSql);
    }

    public override string GetUpdateSql(Persistent obj)
    {
        RevenueAccountedInformation objRevenueAccountedInformation = (RevenueAccountedInformation)obj;
        string date = objRevenueAccountedInformation.RevenueBookedDate == "0" ? "NULL" : "convert(datetime,'" + objRevenueAccountedInformation.RevenueBookedDate + "',103)";

        string strUpdate = " update [Revenue_Accounted_Info] set [revenue_booked_date]= " + date + "," +
              " [remarks]='" + objRevenueAccountedInformation.Remarks.Trim().Replace("'", "''") + "'," +
              " [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '" + objRevenueAccountedInformation.LastActionBy + "'" +
              " where revenue_accounted_info_code = '" + objRevenueAccountedInformation.IntCode + "';";
        return strUpdate;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        RevenueAccountedInformation objBussinessStatementDetails = (RevenueAccountedInformation)obj;

        return " DELETE FROM [Revenue_Accounted_Info] WHERE revenue_accounted_info_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        RevenueAccountedInformation objBussinessStatementDetails = (RevenueAccountedInformation)obj;
        string strSql = "UPDATE [Revenue_Accounted_Info] SET Is_Active='" + objBussinessStatementDetails.Is_Active + "',[Lock_Time]=null,[Last_Updated_Time] = getDate() WHERE revenue_accounted_info_code =" + objBussinessStatementDetails.IntCode;
        return (strSql);
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Revenue_Accounted_Info] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Revenue_Accounted_Info] WHERE revenue_accounted_info_code = " + obj.IntCode;
    }

}

