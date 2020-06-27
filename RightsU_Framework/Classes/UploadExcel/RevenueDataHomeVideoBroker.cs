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
/// Summary description for RevenueDataHomeVideo
/// </summary>
public class RevenueDataHomeVideoBroker : DatabaseBroker
{
    public RevenueDataHomeVideoBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [revenue_data_home_video] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RevenueDataHomeVideo objRevenueDataHomeVideo;
        if (obj == null)
        {
            objRevenueDataHomeVideo = new RevenueDataHomeVideo();
        }
        else
        {
            objRevenueDataHomeVideo = (RevenueDataHomeVideo)obj;
        }

        objRevenueDataHomeVideo.IntCode = Convert.ToInt32(dRow["revenue_data_home_video_code"]);
        #region --populate--
        if (dRow["distributor_vendor_code"] != DBNull.Value)
            objRevenueDataHomeVideo.DistributorVendorCode = Convert.ToInt32(dRow["distributor_vendor_code"]);
        if (dRow["deal_movie_code"] != DBNull.Value)
            objRevenueDataHomeVideo.DealMovieCode = Convert.ToInt32(dRow["deal_movie_code"]);
        objRevenueDataHomeVideo.TitleCodeId = Convert.ToString(dRow["title_code_id"]);
        if (dRow["from_date"] != DBNull.Value)
            objRevenueDataHomeVideo.FromDate = Convert.ToDateTime(dRow["from_date"]);
        if (dRow["to_date"] != DBNull.Value)
            objRevenueDataHomeVideo.ToDate = Convert.ToDateTime(dRow["to_date"]);
        if (dRow["gross_amount"] != DBNull.Value)
            objRevenueDataHomeVideo.GrossAmount = Convert.ToDecimal(dRow["gross_amount"]);
        if (dRow["tax"] != DBNull.Value)
            objRevenueDataHomeVideo.Tax = Convert.ToDecimal(dRow["tax"]);
        if (dRow["net_amount"] != DBNull.Value)
            objRevenueDataHomeVideo.NetAmount = Convert.ToDecimal(dRow["net_amount"]);
        if (dRow["copy"] != DBNull.Value)
            objRevenueDataHomeVideo.Copy = Convert.ToDecimal(dRow["copy"]);
        if (dRow["total_revenue"] != DBNull.Value)
            objRevenueDataHomeVideo.TotalRevenue = Convert.ToDecimal(dRow["total_revenue"]);
        #endregion
        return objRevenueDataHomeVideo;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        RevenueDataHomeVideo objRevenueDataHomeVideo = (RevenueDataHomeVideo)obj;
        return "insert into [revenue_data_home_video]([distributor_vendor_code], [deal_movie_code], [title_code_id], [from_date], [to_date], [gross_amount], [tax], [net_amount], [copy], [total_revenue]) values('" + objRevenueDataHomeVideo.DistributorVendorCode + "', dbo.fn_get_DealMovieCode_From_TitleCode('" + objRevenueDataHomeVideo.DealMovieCode + "'), '" + objRevenueDataHomeVideo.TitleCodeId.Trim().Replace("'", "''") + "', '" + objRevenueDataHomeVideo.FromDate + "', '" + objRevenueDataHomeVideo.ToDate + "', '" + objRevenueDataHomeVideo.GrossAmount + "', '" + objRevenueDataHomeVideo.Tax + "', '" + objRevenueDataHomeVideo.NetAmount + "', '" + objRevenueDataHomeVideo.Copy + "', '" + objRevenueDataHomeVideo.TotalRevenue + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        RevenueDataHomeVideo objRevenueDataHomeVideo = (RevenueDataHomeVideo)obj;
        return "update [revenue_data_home_video] set [distributor_vendor_code] = '" + objRevenueDataHomeVideo.DistributorVendorCode + "', [deal_movie_code] = '" + objRevenueDataHomeVideo.DealMovieCode + "', [title_code_id] = '" + objRevenueDataHomeVideo.TitleCodeId.Trim().Replace("'", "''") + "', [from_date] = '" + objRevenueDataHomeVideo.FromDate + "', [to_date] = '" + objRevenueDataHomeVideo.ToDate + "', [gross_amount] = '" + objRevenueDataHomeVideo.GrossAmount + "', [tax] = '" + objRevenueDataHomeVideo.Tax + "', [net_amount] = '" + objRevenueDataHomeVideo.NetAmount + "', [copy] = '" + objRevenueDataHomeVideo.Copy + "', [total_revenue] = '" + objRevenueDataHomeVideo.TotalRevenue + "' where revenue_data_home_video_code = '" + objRevenueDataHomeVideo.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        RevenueDataHomeVideo objRevenueDataHomeVideo = (RevenueDataHomeVideo)obj;

        return " DELETE FROM [revenue_data_home_video] WHERE revenue_data_home_video_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        RevenueDataHomeVideo objRevenueDataHomeVideo = (RevenueDataHomeVideo)obj;
        return "Update [revenue_data_home_video] set Is_Active='" + objRevenueDataHomeVideo.Is_Active + "',lock_time=null, last_updated_time= getdate() where revenue_data_home_video_code = '" + objRevenueDataHomeVideo.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [revenue_data_home_video] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [revenue_data_home_video] WHERE  revenue_data_home_video_code = " + obj.IntCode;
    }
}
