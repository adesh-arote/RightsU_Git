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
public class  AdditionalExpense : Persistent
{
	public  AdditionalExpense()
	{
        OrderByColumnName = "Additional_Expense_Name";
        OrderByCondition = "ASC";
        tableName = "additional_expense";
        pkColName = "Additional_Expense_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _AdditionalExpenseName;
	public string AdditionalExpenseName
	{
		get { return this._AdditionalExpenseName; }
		set { this._AdditionalExpenseName = value; }
	}

    private string _SapGlGroupCode;
    public string SapGlGroupCode
    {
        get { return this._SapGlGroupCode; }
        set { this._SapGlGroupCode = value; }
    }
	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new AdditionalExpenseBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}