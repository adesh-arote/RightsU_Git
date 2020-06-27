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
public class  ImportMonthlySalesErrors : Persistent
{
	public  ImportMonthlySalesErrors()
	{
        OrderByColumnName = "import_monthly_sales_code";
		OrderByCondition= "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _ImportMonthlySalesCode;
	public int ImportMonthlySalesCode
	{
		get { return this._ImportMonthlySalesCode; }
		set { this._ImportMonthlySalesCode = value; }
	}

	private int _McTabResultMonthlyCode;
	public int McTabResultMonthlyCode
	{
		get { return this._McTabResultMonthlyCode; }
		set { this._McTabResultMonthlyCode = value; }
	}

	private string _description;
	public string description
	{
		get { return this._description; }
		set { this._description = value; }
	}

    private string _is_Active;
    public string is_Active
    {
        get { return this._is_Active; }
        set { this._is_Active = value; }
    }

    private string _is_MOM_YTD;
    public string is_MOM_YTD
    {
        get { return this._is_MOM_YTD; }
        set { this._is_MOM_YTD = value; }
    }

	private MCTABResultMonthlyCopy _objMCTABResultMonthlyCopy;
    public MCTABResultMonthlyCopy objMCTABResultMonthlyCopy
	{
		get {
            if (this._objMCTABResultMonthlyCopy == null)
                this._objMCTABResultMonthlyCopy = new MCTABResultMonthlyCopy();
            return this._objMCTABResultMonthlyCopy;
		}
        set { this._objMCTABResultMonthlyCopy = value; }
	}

    private MCTABResultYearlyCopy _objMCTABResultYearlyCopy;
    public MCTABResultYearlyCopy objMCTABResultYearlyCopy
    {
        get
        {
            if (this._objMCTABResultYearlyCopy == null)
                this._objMCTABResultYearlyCopy = new MCTABResultYearlyCopy();
            return this._objMCTABResultYearlyCopy;
        }
        set { this._objMCTABResultYearlyCopy = value; }
    }

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ImportMonthlySalesErrorsBroker();
    }

	public override void LoadObjects()
    {

        if (this.McTabResultMonthlyCode > 0 && this.is_MOM_YTD=="M")
		{
			this.objMCTABResultMonthlyCopy.IntCode = this.McTabResultMonthlyCode;
            this.objMCTABResultMonthlyCopy.Fetch();
		}
        else if (this.McTabResultMonthlyCode > 0 && this.is_MOM_YTD == "Y")
        {
            this.objMCTABResultYearlyCopy.IntCode = this.McTabResultMonthlyCode;
            this.objMCTABResultYearlyCopy.Fetch();
        }

	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
