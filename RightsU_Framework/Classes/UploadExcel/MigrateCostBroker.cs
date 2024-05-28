using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;


public class MigrateCostBroker : DatabaseBroker
{
    public MigrateCostBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [revenue_data_home_video] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MigrateCost objMigrateCost;
        if (obj == null)
        {
            objMigrateCost = new MigrateCost();
        }
        else
        {
            objMigrateCost = (MigrateCost)obj;
        }

        objMigrateCost.IntCode = Convert.ToInt32(dRow["revenue_data_home_video_code"]);
        #region --populate--
        //if (dRow["distributor_vendor_code"] != DBNull.Value)
        //    objMigrateCost.DistributorVendorCode = Convert.ToInt32(dRow["distributor_vendor_code"]);
        //if (dRow["deal_movie_code"] != DBNull.Value)
        //    objMigrateCost.DealMovieCode = Convert.ToInt32(dRow["deal_movie_code"]);
        //objMigrateCost.TitleCodeId = Convert.ToString(dRow["title_code_id"]);
        //if (dRow["from_date"] != DBNull.Value)
        //    objMigrateCost.FromDate = Convert.ToDateTime(dRow["from_date"]);
        //if (dRow["to_date"] != DBNull.Value)
        //    objMigrateCost.ToDate = Convert.ToDateTime(dRow["to_date"]);
        //if (dRow["gross_amount"] != DBNull.Value)
        //    objMigrateCost.GrossAmount = Convert.ToDecimal(dRow["gross_amount"]);
        //if (dRow["tax"] != DBNull.Value)
        //    objMigrateCost.Tax = Convert.ToDecimal(dRow["tax"]);
        //if (dRow["net_amount"] != DBNull.Value)
        //    objMigrateCost.NetAmount = Convert.ToDecimal(dRow["net_amount"]);
        //if (dRow["copy"] != DBNull.Value)
        //    objMigrateCost.Copy = Convert.ToDecimal(dRow["copy"]);
        //if (dRow["total_revenue"] != DBNull.Value)
        //    objMigrateCost.TotalRevenue = Convert.ToDecimal(dRow["total_revenue"]);
        #endregion
        return objMigrateCost;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        //MigrateCost objMigrateCost = (MigrateCost)obj;
        //return "insert into [revenue_data_home_video]([distributor_vendor_code], [deal_movie_code], [title_code_id], [from_date], [to_date], [gross_amount], [tax], [net_amount], [copy], [total_revenue]) values('" + objMigrateCost.DistributorVendorCode + "', dbo.fn_get_DealMovieCode_From_TitleCode('" + objMigrateCost.DealMovieCode + "'), '" + objMigrateCost.TitleCodeId.Trim().Replace("'", "''") + "', '" + objMigrateCost.FromDate + "', '" + objMigrateCost.ToDate + "', '" + objMigrateCost.GrossAmount + "', '" + objMigrateCost.Tax + "', '" + objMigrateCost.NetAmount + "', '" + objMigrateCost.Copy + "', '" + objMigrateCost.TotalRevenue + "');";
        string searchString = string.Empty;
        return searchString;

    }

    public override string GetUpdateSql(Persistent obj)
    {
        //MigrateCost objMigrateCost = (MigrateCost)obj;
        //return "update [revenue_data_home_video] set [distributor_vendor_code] = '" + objMigrateCost.DistributorVendorCode + "', [deal_movie_code] = '" + objMigrateCost.DealMovieCode + "', [title_code_id] = '" + objMigrateCost.TitleCodeId.Trim().Replace("'", "''") + "', [from_date] = '" + objMigrateCost.FromDate + "', [to_date] = '" + objMigrateCost.ToDate + "', [gross_amount] = '" + objMigrateCost.GrossAmount + "', [tax] = '" + objMigrateCost.Tax + "', [net_amount] = '" + objMigrateCost.NetAmount + "', [copy] = '" + objMigrateCost.Copy + "', [total_revenue] = '" + objMigrateCost.TotalRevenue + "' where revenue_data_home_video_code = '" + objMigrateCost.IntCode + "';";

        string searchString = string.Empty;
        return searchString;

    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        MigrateCost objMigrateCost = (MigrateCost)obj;

        return " DELETE FROM [revenue_data_home_video] WHERE revenue_data_home_video_code = " + obj.IntCode;
       
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        MigrateCost objMigrateCost = (MigrateCost)obj;
        return "Update [revenue_data_home_video] set Is_Active='" + objMigrateCost.Is_Active + "',lock_time=null, last_updated_time= getdate() where revenue_data_home_video_code = '" + objMigrateCost.IntCode + "'";
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

