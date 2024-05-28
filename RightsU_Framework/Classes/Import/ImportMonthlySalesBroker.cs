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
/// Summary description for ImportMonthlySales
/// </summary>
public class ImportMonthlySalesBroker : DatabaseBroker
{
    public ImportMonthlySalesBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Import_Monthly_Sales] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ImportMonthlySales objImportMonthlySales;
        if (obj == null)
        {
            objImportMonthlySales = new ImportMonthlySales();
        }
        else
        {
            objImportMonthlySales = (ImportMonthlySales)obj;
        }

        objImportMonthlySales.IntCode = Convert.ToInt32(dRow["import_monthly_sales_code"]);
        #region --populate--
        if (dRow["MonthYear"] != DBNull.Value)
            objImportMonthlySales.MonthYear = Convert.ToDateTime(dRow["MonthYear"]).ToString("dd/MM/yyyy");
        if (dRow["records_calculated"] != DBNull.Value)
            objImportMonthlySales.RecordsCalculated = Convert.ToInt32(dRow["records_calculated"]);
        if (dRow["total_errors"] != DBNull.Value)
            objImportMonthlySales.TotalErrors = Convert.ToInt32(dRow["total_errors"]);
        if (dRow["imported_by"] != DBNull.Value)
            objImportMonthlySales.ImportedBy = Convert.ToInt32(dRow["imported_by"]);
        if (dRow["imported_on"] != DBNull.Value)
            objImportMonthlySales.ImportedOn = Convert.ToDateTime(dRow["imported_on"]).ToString("dd/MM/yyyy");
        objImportMonthlySales.Is_Active = Convert.ToString(dRow["is_active"]);
        #endregion
        return objImportMonthlySales;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        ImportMonthlySales objImportMonthlySales = (ImportMonthlySales)obj;
        return "insert into [Import_Monthly_Sales]([MonthYear], [records_calculated], [total_errors], [imported_by], [imported_on], [is_active]) values('" + objImportMonthlySales.MonthYear + "', '" + objImportMonthlySales.RecordsCalculated + "', '" + objImportMonthlySales.TotalErrors + "', '" + objImportMonthlySales.ImportedBy + "', getDate(),  '" + objImportMonthlySales.Is_Active + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        ImportMonthlySales objImportMonthlySales = (ImportMonthlySales)obj;
        return "update [Import_Monthly_Sales] set [MonthYear] = '" + objImportMonthlySales.MonthYear + "', [records_calculated] = '" + objImportMonthlySales.RecordsCalculated + "', [total_errors] = '" + objImportMonthlySales.TotalErrors + "', [imported_by] = '" + objImportMonthlySales.ImportedBy + "', [imported_on] = '" + objImportMonthlySales.ImportedOn + "', [is_active] = '" + objImportMonthlySales.Is_Active + "' where import_monthly_sales_code = '" + objImportMonthlySales.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        ImportMonthlySales objImportMonthlySales = (ImportMonthlySales)obj;
        if (objImportMonthlySales.arrImportMonthlySalesErrors.Count > 0)
            DBUtil.DeleteChild("ImportMonthlySalesErrors", objImportMonthlySales.arrImportMonthlySalesErrors, objImportMonthlySales.IntCode, (SqlTransaction)objImportMonthlySales.SqlTrans);

        return " DELETE FROM [Import_Monthly_Sales] WHERE import_monthly_sales_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        ImportMonthlySales objImportMonthlySales = (ImportMonthlySales)obj;
        return "Update [Import_Monthly_Sales] set Is_Active='" + objImportMonthlySales.Is_Active + "',lock_time=null, last_updated_time= getdate() where import_monthly_sales_code = '" + objImportMonthlySales.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Import_Monthly_Sales] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Import_Monthly_Sales] WHERE  import_monthly_sales_code = " + obj.IntCode;
    }

    public string getMC_TAB_Status()
    {
        return ProcessScalarReturnString("select dbo.[fn_get_MC_TAB_Status]()");
    }
    public string execute_MonthlySales_Package(int import_monthly_sales_code, string import_tables, int importedBy)
    {
        return ProcessScalarReturnString("exec execute_MonthlySales_Package " + import_monthly_sales_code + "," + import_tables + "," + importedBy);
    }
}
