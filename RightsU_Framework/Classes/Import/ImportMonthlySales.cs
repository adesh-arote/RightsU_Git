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
/// Summary description for Title
/// </summary>
public class ImportMonthlySales : Persistent
{
    public ImportMonthlySales()
    {
        OrderByColumnName = "import_monthly_sales_code";
        OrderByCondition = "ASC";
        //tableName = "";
        //pkColName = "";
    }

    #region ---------------Attributes And Prperties---------------


    private string _MonthYear;
    public string MonthYear
    {
        get { return this._MonthYear; }
        set { this._MonthYear = value; }
    }

    private int _RecordsCalculated;
    public int RecordsCalculated
    {
        get { return this._RecordsCalculated; }
        set { this._RecordsCalculated = value; }
    }

    private int _TotalErrors;
    public int TotalErrors
    {
        get { return this._TotalErrors; }
        set { this._TotalErrors = value; }
    }

    private int _ImportedBy;
    public int ImportedBy
    {
        get { return this._ImportedBy; }
        set { this._ImportedBy = value; }
    }

    private string _ImportedOn;
    public string ImportedOn
    {
        get { return this._ImportedOn; }
        set { this._ImportedOn = value; }
    }

    private ArrayList _arrImportMonthlySalesErrors_Del;
    public ArrayList arrImportMonthlySalesErrors_Del
    {
        get
        {
            if (this._arrImportMonthlySalesErrors_Del == null)
                this._arrImportMonthlySalesErrors_Del = new ArrayList();
            return this._arrImportMonthlySalesErrors_Del;
        }
        set { this._arrImportMonthlySalesErrors_Del = value; }
    }

    private ArrayList _arrImportMonthlySalesErrors;
    public ArrayList arrImportMonthlySalesErrors
    {
        get
        {
            if (this._arrImportMonthlySalesErrors == null)
                this._arrImportMonthlySalesErrors = new ArrayList();
            return this._arrImportMonthlySalesErrors;
        }
        set { this._arrImportMonthlySalesErrors = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ImportMonthlySalesBroker();
    }

    public override void LoadObjects()
    {
        this.arrImportMonthlySalesErrors = DBUtil.FillArrayList(new ImportMonthlySalesErrors(), " and import_monthly_sales_code = '" + this.IntCode + "' and is_active not in ('Y')", true);

    }

    public override void UnloadObjects()
    {

        //if (arrImportMonthlySalesErrors_Del != null)
        //{
        //    foreach (ImportMonthlySalesErrors objImportMonthlySalesErrors in this.arrImportMonthlySalesErrors_Del)
        //    {
        //        objImportMonthlySalesErrors.IsTransactionRequired = true;
        //        objImportMonthlySalesErrors.SqlTrans = this.SqlTrans;
        //        objImportMonthlySalesErrors.IsDeleted = true;
        //        objImportMonthlySalesErrors.Save();
        //    }
        //}
        //if (arrImportMonthlySalesErrors != null)
        //{
        //    foreach (ImportMonthlySalesErrors objImportMonthlySalesErrors in this.arrImportMonthlySalesErrors)
        //    {
        //        objImportMonthlySalesErrors.ImportMonthlySalesCode = this.IntCode;
        //        objImportMonthlySalesErrors.IsTransactionRequired = true;
        //        objImportMonthlySalesErrors.SqlTrans = this.SqlTrans;
        //        if (objImportMonthlySalesErrors.IntCode > 0)
        //            objImportMonthlySalesErrors.IsDirty = true;
        //        objImportMonthlySalesErrors.Save();
        //    }
        //}
    }
    public string getMC_TAB_Status()
    {
        return ((ImportMonthlySalesBroker)this.GetBroker()).getMC_TAB_Status();
    }

    public string execute_MonthlySales_Package(int import_monthly_sales_code, string import_tables, int importedBy)
    {
        return ((ImportMonthlySalesBroker)this.GetBroker()).execute_MonthlySales_Package(import_monthly_sales_code, import_tables, importedBy);
    }
    #endregion
}
