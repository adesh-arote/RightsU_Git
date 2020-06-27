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
/// Summary description for ClosingDealMovieEpisode
/// </summary>
public class ClosingDealMovieEpisodeBroker : DatabaseBroker
{
    public ClosingDealMovieEpisodeBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT isnull(first_name,'')+' '+isnull(Middle_Name,'')+' '+isnull(last_name,'')DisplayClosed_by ,closing_deal_movie_episode.*,datename(month,month_closed)+' '+ cast(datepart(year,month_closed) as varchar(10))Displaymonth FROM [closing_deal_movie_episode] left outer join users on closing_deal_movie_episode.closed_by=users.users_code where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ClosingDealMovieEpisode objClosingDealMovieEpisode;
        if (obj == null)
        {
            objClosingDealMovieEpisode = new ClosingDealMovieEpisode();
        }
        else
        {
            objClosingDealMovieEpisode = (ClosingDealMovieEpisode)obj;
        }

        objClosingDealMovieEpisode.IntCode = Convert.ToInt32(dRow["closing_deal_movie_episode_code"]);
        #region --populate--
        if (dRow["deal_movie_contents_code"] != DBNull.Value)
            objClosingDealMovieEpisode.DealMovieContentsCode = Convert.ToInt32(dRow["deal_movie_contents_code"]);
        if (dRow["month_closed"] != DBNull.Value)
            objClosingDealMovieEpisode.MonthClosed = Convert.ToDateTime(dRow["month_closed"]);
        if (dRow["closed_amount"] != DBNull.Value)
            objClosingDealMovieEpisode.ClosedAmount = Convert.ToDecimal(dRow["closed_amount"]);
        if (dRow["balance_amount"] != DBNull.Value)
            objClosingDealMovieEpisode.BalanceAmount = Convert.ToDecimal(dRow["balance_amount"]);
        if (dRow["additional_amount"] != DBNull.Value)
            objClosingDealMovieEpisode.AdditionalAmount = Convert.ToDecimal(dRow["additional_amount"]);
        if (dRow["balance_to_amort_additional_amount"] != DBNull.Value)
            objClosingDealMovieEpisode.BalanceToAmortAdditionalAmount = Convert.ToDecimal(dRow["balance_to_amort_additional_amount"]);
        if (dRow["closed_by"] != DBNull.Value)
            objClosingDealMovieEpisode.ClosedBy = Convert.ToInt32(dRow["closed_by"]);
        if (dRow["closed_on"] != DBNull.Value)
            objClosingDealMovieEpisode.ClosedOn = Convert.ToDateTime(dRow["closed_on"]);
        if (dRow["closed_runs"] != DBNull.Value)
            objClosingDealMovieEpisode.ClosedRuns = Convert.ToInt32(dRow["closed_runs"]);
        if (dRow["DisplayClosed_by"] != DBNull.Value)
            objClosingDealMovieEpisode.DisplayClosed_by = Convert.ToString(dRow["DisplayClosed_by"]);

        if (dRow["Displaymonth"] != DBNull.Value)
            objClosingDealMovieEpisode.Displaymonth = Convert.ToString(dRow["Displaymonth"]);

        
        #endregion
        return objClosingDealMovieEpisode;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        ClosingDealMovieEpisode objClosingDealMovieEpisode = (ClosingDealMovieEpisode)obj;
        return "insert into [closing_deal_movie_episode]([deal_movie_contents_code], [month_closed], [closed_amount], [balance_amount], [additional_amount], [balance_to_amort_additional_amount], [closed_by], [closed_on], [closed_runs]) values('" + objClosingDealMovieEpisode.DealMovieContentsCode + "', '" + objClosingDealMovieEpisode.MonthClosed + "', '" + objClosingDealMovieEpisode.ClosedAmount + "', '" + objClosingDealMovieEpisode.BalanceAmount + "', '" + objClosingDealMovieEpisode.AdditionalAmount + "', '" + objClosingDealMovieEpisode.BalanceToAmortAdditionalAmount + "', '" + objClosingDealMovieEpisode.ClosedBy + "', '" + objClosingDealMovieEpisode.ClosedOn + "', '" + objClosingDealMovieEpisode.ClosedRuns + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        ClosingDealMovieEpisode objClosingDealMovieEpisode = (ClosingDealMovieEpisode)obj;
        return "update [closing_deal_movie_episode] set [deal_movie_contents_code] = '" + objClosingDealMovieEpisode.DealMovieContentsCode + "', [month_closed] = '" + objClosingDealMovieEpisode.MonthClosed + "', [closed_amount] = '" + objClosingDealMovieEpisode.ClosedAmount + "', [balance_amount] = '" + objClosingDealMovieEpisode.BalanceAmount + "', [additional_amount] = '" + objClosingDealMovieEpisode.AdditionalAmount + "', [balance_to_amort_additional_amount] = '" + objClosingDealMovieEpisode.BalanceToAmortAdditionalAmount + "', [closed_by] = '" + objClosingDealMovieEpisode.ClosedBy + "', [closed_on] = '" + objClosingDealMovieEpisode.ClosedOn + "', [closed_runs] = '" + objClosingDealMovieEpisode.ClosedRuns + "' where closing_deal_movie_episode_code = '" + objClosingDealMovieEpisode.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        ClosingDealMovieEpisode objClosingDealMovieEpisode = (ClosingDealMovieEpisode)obj;

        return " DELETE FROM [closing_deal_movie_episode] WHERE closing_deal_movie_episode_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [closing_deal_movie_episode] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [closing_deal_movie_episode] WHERE  closing_deal_movie_episode_code = " + obj.IntCode;
    }

    internal DataSet GetNextClosingDate()
    {
      return   ProcessSelectDirectly("select LEFT(DATENAME(M,dbo.FN_GET_AMORT_NEXT_CLOSING_DATE(0)),3)+'-'+CAST(DATENAME(YYYY,dbo.FN_GET_AMORT_NEXT_CLOSING_DATE(0)) AS VARCHAR(10))");
    }
    internal DataSet GetNextClosingDateTime()
    {
        return ProcessSelectDirectly(" declare @Allow as varchar(10)='N' select @Allow= 'Y' where dbo.FN_GET_LAST_DATE_OF_MONTH(dbo.FN_GET_AMORT_NEXT_CLOSING_DATE(0))< getdate() select @Allow  ");
    }

	internal string getMovieRightsPeriod(int DealMovieCode) 
	{
		string strSelect = "Select dbo.[fn_RightsPeriod_Per_Movie](" + DealMovieCode + ")";
		return DatabaseBroker.ProcessScalarReturnString(strSelect);
	}

	internal string getAmortNote(int DealMovieCode) 
	{
		string strExec = " Exec USP_GetAmortNote " + DealMovieCode;
		return DatabaseBroker.ProcessScalarReturnString(strExec);
	}
}
