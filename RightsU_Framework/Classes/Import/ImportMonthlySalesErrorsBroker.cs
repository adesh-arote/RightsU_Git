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
/// Summary description for ImportMonthlySalesErrors
/// </summary>
public class ImportMonthlySalesErrorsBroker : DatabaseBroker
{
    public ImportMonthlySalesErrorsBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Import_Monthly_Sales_Errors] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ImportMonthlySalesErrors objImportMonthlySalesErrors;
        if (obj == null)
        {
            objImportMonthlySalesErrors = new ImportMonthlySalesErrors();
        }
        else
        {
            objImportMonthlySalesErrors = (ImportMonthlySalesErrors)obj;
        }

        objImportMonthlySalesErrors.IntCode = Convert.ToInt32(dRow["import_monthly_sales_errors_code"]);
        #region --populate--
        if (dRow["import_monthly_sales_code"] != DBNull.Value)
            objImportMonthlySalesErrors.ImportMonthlySalesCode = Convert.ToInt32(dRow["import_monthly_sales_code"]);
        if (dRow["mc_tab_result_monthly_code"] != DBNull.Value)
            objImportMonthlySalesErrors.McTabResultMonthlyCode = Convert.ToInt32(dRow["mc_tab_result_monthly_code"]);
        objImportMonthlySalesErrors.description = Convert.ToString(dRow["description"]);
        objImportMonthlySalesErrors.Is_Active = Convert.ToString(dRow["is_active"]);
        if (dRow["is_MOM_YTD"] != DBNull.Value)
            objImportMonthlySalesErrors.is_MOM_YTD = Convert.ToString(dRow["is_MOM_YTD"]);
        #endregion
        return objImportMonthlySalesErrors;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        ImportMonthlySalesErrors objImportMonthlySalesErrors = (ImportMonthlySalesErrors)obj;
        return "insert into [Import_Monthly_Sales_Errors]([import_monthly_sales_code], [mc_tab_result_monthly_code], [description], [is_active]) values('" + objImportMonthlySalesErrors.ImportMonthlySalesCode + "', '" + objImportMonthlySalesErrors.McTabResultMonthlyCode + "', '" + objImportMonthlySalesErrors.description.Trim().Replace("'", "''") + "',  '" + objImportMonthlySalesErrors.Is_Active + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        ImportMonthlySalesErrors objImportMonthlySalesErrors = (ImportMonthlySalesErrors)obj;
        return "update [Import_Monthly_Sales_Errors] set [import_monthly_sales_code] = '" + objImportMonthlySalesErrors.ImportMonthlySalesCode + "', [mc_tab_result_monthly_code] = '" + objImportMonthlySalesErrors.McTabResultMonthlyCode + "', [description] = '" + objImportMonthlySalesErrors.description.Trim().Replace("'", "''") + "', [is_active] = '" + objImportMonthlySalesErrors.Is_Active + "' where import_monthly_sales_errors_code = '" + objImportMonthlySalesErrors.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        ImportMonthlySalesErrors objImportMonthlySalesErrors = (ImportMonthlySalesErrors)obj;

        return " DELETE FROM [Import_Monthly_Sales_Errors] WHERE import_monthly_sales_errors_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        ImportMonthlySalesErrors objImportMonthlySalesErrors = (ImportMonthlySalesErrors)obj;
        return "Update [Import_Monthly_Sales_Errors] set Is_Active='" + objImportMonthlySalesErrors.Is_Active + "',lock_time=null, last_updated_time= getdate() where import_monthly_sales_errors_code = '" + objImportMonthlySalesErrors.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Import_Monthly_Sales_Errors] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Import_Monthly_Sales_Errors] WHERE  import_monthly_sales_errors_code = " + obj.IntCode;
    }
}
