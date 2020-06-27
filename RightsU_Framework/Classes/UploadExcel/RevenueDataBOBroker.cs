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
/// Summary description for RevenueDataBO
/// </summary>
public class RevenueDataBOBroker : DatabaseBroker
{
    public RevenueDataBOBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [revenue_data_theatre] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RevenueDataBO objRevenueDataBO;
        if (obj == null)
        {
            objRevenueDataBO = new RevenueDataBO();
        }
        else
        {
            objRevenueDataBO = (RevenueDataBO)obj;
        }

        objRevenueDataBO.IntCode = Convert.ToInt32(dRow["revenue_data_theatre_code"]);
        #region --populate--

        objRevenueDataBO.TitleCodeId = Convert.ToString(dRow["title_code_id"]);
        if (dRow["from_date"] != DBNull.Value)
            objRevenueDataBO.FromDate = Convert.ToString(dRow["from_date"]);
        if (dRow["revenue"] != DBNull.Value)
            objRevenueDataBO.Revenue = Convert.ToDecimal(dRow["revenue"]);
        #endregion
        return objRevenueDataBO;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        RevenueDataBO objRevenueDataBO = (RevenueDataBO)obj;
        return "insert into [revenue_data_theatre]( "
            + " [title_code_id], [from_date], [revenue]) values('"
            + objRevenueDataBO.TitleCodeId.Trim().Replace("'", "''") + "', CONVERT(DATETIME,'" + objRevenueDataBO.FromDate
            + "', 103), '" + objRevenueDataBO.Revenue + "');";
    }
    public override string GetUpdateSql(Persistent obj)
    {
        RevenueDataBO objRevenueDataBO = (RevenueDataBO)obj;
        return "update [revenue_data_theatre] set "
                + "   [title_code_id] = '" + objRevenueDataBO.TitleCodeId.Trim().Replace("'", "''") 
                + "', [from_date] = '" + objRevenueDataBO.FromDate                 
                + "', [revenue] = '" + objRevenueDataBO.Revenue 
                + "' where revenue_data_theatre_code = '" + objRevenueDataBO.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        RevenueDataBO objRevenueDataBO = (RevenueDataBO)obj;

        return " DELETE FROM [revenue_data_theatre] WHERE revenue_data_theatre_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        return "";   
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
