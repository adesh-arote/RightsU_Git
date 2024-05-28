using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;


public class MigrateHouseIDBroker :DatabaseBroker
{

    public MigrateHouseIDBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [revenue_data_home_video] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MigrateHouseID objMigrateHouseID;
        if (obj == null)
        {
            objMigrateHouseID = new MigrateHouseID();
        }
        else
        {
            objMigrateHouseID = (MigrateHouseID)obj;
        }

        objMigrateHouseID.IntCode = Convert.ToInt32(dRow["revenue_data_home_video_code"]);
        #region --populate--
        //if (dRow["distributor_vendor_code"] != DBNull.Value)
        //    objMigrateHouseID.DistributorVendorCode = Convert.ToInt32(dRow["distributor_vendor_code"]);
        //if (dRow["deal_movie_code"] != DBNull.Value)
        //    objMigrateHouseID.DealMovieCode = Convert.ToInt32(dRow["deal_movie_code"]);
        //objMigrateHouseID.TitleCodeId = Convert.ToString(dRow["title_code_id"]);
        //if (dRow["from_date"] != DBNull.Value)
        //    objMigrateHouseID.FromDate = Convert.ToDateTime(dRow["from_date"]);
        //if (dRow["to_date"] != DBNull.Value)
        //    objMigrateHouseID.ToDate = Convert.ToDateTime(dRow["to_date"]);
        //if (dRow["gross_amount"] != DBNull.Value)
        //    objMigrateHouseID.GrossAmount = Convert.ToDecimal(dRow["gross_amount"]);
        //if (dRow["tax"] != DBNull.Value)
        //    objMigrateHouseID.Tax = Convert.ToDecimal(dRow["tax"]);
        //if (dRow["net_amount"] != DBNull.Value)
        //    objMigrateHouseID.NetAmount = Convert.ToDecimal(dRow["net_amount"]);
        //if (dRow["copy"] != DBNull.Value)
        //    objMigrateHouseID.Copy = Convert.ToDecimal(dRow["copy"]);
        //if (dRow["total_revenue"] != DBNull.Value)
        //    objMigrateHouseID.TotalRevenue = Convert.ToDecimal(dRow["total_revenue"]);
        #endregion
        return objMigrateHouseID;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        //MigrateHouseID objMigrateHouseID = (MigrateHouseID)obj;
        //return "insert into [revenue_data_home_video]([distributor_vendor_code], [deal_movie_code], [title_code_id], [from_date], [to_date], [gross_amount], [tax], [net_amount], [copy], [total_revenue]) values('" + objMigrateHouseID.DistributorVendorCode + "', dbo.fn_get_DealMovieCode_From_TitleCode('" + objMigrateHouseID.DealMovieCode + "'), '" + objMigrateHouseID.TitleCodeId.Trim().Replace("'", "''") + "', '" + objMigrateHouseID.FromDate + "', '" + objMigrateHouseID.ToDate + "', '" + objMigrateHouseID.GrossAmount + "', '" + objMigrateHouseID.Tax + "', '" + objMigrateHouseID.NetAmount + "', '" + objMigrateHouseID.Copy + "', '" + objMigrateHouseID.TotalRevenue + "');";
        string searchString = string.Empty;
        return searchString;

    }

    public override string GetUpdateSql(Persistent obj)
    {
        //MigrateHouseID objMigrateHouseID = (MigrateHouseID)obj;
        //return "update [revenue_data_home_video] set [distributor_vendor_code] = '" + objMigrateHouseID.DistributorVendorCode + "', [deal_movie_code] = '" + objMigrateHouseID.DealMovieCode + "', [title_code_id] = '" + objMigrateHouseID.TitleCodeId.Trim().Replace("'", "''") + "', [from_date] = '" + objMigrateHouseID.FromDate + "', [to_date] = '" + objMigrateHouseID.ToDate + "', [gross_amount] = '" + objMigrateHouseID.GrossAmount + "', [tax] = '" + objMigrateHouseID.Tax + "', [net_amount] = '" + objMigrateHouseID.NetAmount + "', [copy] = '" + objMigrateHouseID.Copy + "', [total_revenue] = '" + objMigrateHouseID.TotalRevenue + "' where revenue_data_home_video_code = '" + objMigrateHouseID.IntCode + "';";

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
        MigrateHouseID objMigrateHouseID = (MigrateHouseID)obj;

        return " DELETE FROM [revenue_data_home_video] WHERE revenue_data_home_video_code = " + obj.IntCode;
       
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        MigrateHouseID objMigrateHouseID = (MigrateHouseID)obj;
        return "Update [revenue_data_home_video] set Is_Active='" + objMigrateHouseID.Is_Active + "',lock_time=null, last_updated_time= getdate() where revenue_data_home_video_code = '" + objMigrateHouseID.IntCode + "'";
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

