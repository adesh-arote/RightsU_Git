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
public class BussinessStatementDetailsBroker : DatabaseBroker
{
    public BussinessStatementDetailsBroker()
    {
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Buisness_Statement_Info] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        BussinessStamentDetails objBussinessStamentDetails;
        if (obj == null)
        {
            objBussinessStamentDetails = new BussinessStamentDetails();
        }
        else
        {
            objBussinessStamentDetails = (BussinessStamentDetails)obj;
        }

        objBussinessStamentDetails.IntCode = Convert.ToInt32(dRow["buisness_statement_info_code"]);
        #region --populate--
        if (dRow["syndication_deal_code"] != DBNull.Value)
            objBussinessStamentDetails.SyndicationDealCode = Convert.ToInt32(dRow["syndication_deal_code"]);
        if (dRow["syndication_deal_movie_code"] != DBNull.Value)
            objBussinessStamentDetails.SyndicationDealMovieCode = Convert.ToInt32(dRow["syndication_deal_movie_code"]);
        if (dRow["title_code"] != DBNull.Value)
            objBussinessStamentDetails.TitleCode = Convert.ToInt32(dRow["title_code"]);
        if (dRow["statement_received_date"] != DBNull.Value)
            objBussinessStamentDetails.StmtReceivedDate = Convert.ToDateTime(dRow["statement_received_date"]).ToString("dd/MM/yyyy");
        objBussinessStamentDetails.Remarks = Convert.ToString(dRow["remarks"]);
        if (dRow["lock_time"] != DBNull.Value)
            objBussinessStamentDetails.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objBussinessStamentDetails.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objBussinessStamentDetails.LastUpdatedBy = Convert.ToInt32(dRow["last_action_by"]);

        #endregion
        return objBussinessStamentDetails;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }
    
    public override string GetInsertSql(Persistent obj)
    {
        BussinessStamentDetails objBussinessStamentDetails = (BussinessStamentDetails)obj;
        string strSql = " insert into [Buisness_Statement_Info]([syndication_deal_code],[syndication_deal_movie_code],[statement_received_date],[remarks],[title_code]," +
                        " [lock_time],[last_updated_time], [last_action_by]) values(" + objBussinessStamentDetails.SyndicationDealCode + "," + objBussinessStamentDetails.SyndicationDealMovieCode + "," +
                        " convert(datetime,'" + objBussinessStamentDetails.StmtReceivedDate + "',103),'" + objBussinessStamentDetails.Remarks.Trim().Replace("'", "''") + "','" + objBussinessStamentDetails.TitleCode + "'," +
                        " null,getdate(),'" + objBussinessStamentDetails.LastUpdatedBy + "')";
        return (strSql);
    }

    public override string GetUpdateSql(Persistent obj)
    {
        BussinessStamentDetails objBussinessStamentDetails = (BussinessStamentDetails)obj;
        return " update [Buisness_Statement_Info] set [syndication_deal_code] = '" + objBussinessStamentDetails.SyndicationDealCode + "',[syndication_deal_movie_code]='" + objBussinessStamentDetails.SyndicationDealMovieCode + "'," +
               " [statement_received_date]=convert(datetime,'" + objBussinessStamentDetails.StmtReceivedDate + "',103),[remarks]='" + objBussinessStamentDetails.Remarks.Trim().Replace("'", "''") + "',[title_code]='" + objBussinessStamentDetails.TitleCode + "'," +
               " [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '" + objBussinessStamentDetails.LastUpdatedBy + "'" +
               " where buisness_statement_info_code = '" + objBussinessStamentDetails.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        BussinessStamentDetails objBussinessStatementDetails = (BussinessStamentDetails)obj;

        return " DELETE FROM [Buisness_Statement_Info] WHERE buisness_statement_info_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        BussinessStamentDetails objBussinessStatementDetails = (BussinessStamentDetails)obj;
        string strSql = "UPDATE [Buisness_Statement_Info] SET Is_Active='" + objBussinessStatementDetails.Is_Active + "',[Lock_Time]=null,[Last_Updated_Time] = getDate() WHERE buisness_statement_info_code =" + objBussinessStatementDetails.IntCode;
        return (strSql);
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Buisness_Statement_Info] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Buisness_Statement_Info] WHERE buisness_statement_info_code = " + obj.IntCode;
    }
}

