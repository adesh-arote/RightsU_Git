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
public class  RoyaltyCommissionDetails : Persistent
{
	public  RoyaltyCommissionDetails()
	{
		OrderByColumnName = "commission_type";
		OrderByCondition= "ASC";
        tableName = "Royalty_Commission_Details";
        pkColName = "Royalty_Commission_Details_code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _RoyaltyCommissionCode;
	public int RoyaltyCommissionCode
	{
		get { return this._RoyaltyCommissionCode; }
		set { this._RoyaltyCommissionCode = value; }
	}

	private string _CommissionType;
	public string CommissionType
	{
		get { return this._CommissionType; }
		set { this._CommissionType = value; }
	}

	private int _CommissionTypeCode;
	public int CommissionTypeCode
	{
		get { return this._CommissionTypeCode; }
		set { this._CommissionTypeCode = value; }
	}

    private bool _flag;
    public bool flag
    {
        get { return this._flag; }
        set { this._flag = value; }
    }
    

    
    private string _CostTypeName;
    public string CostTypeName
    {
        get{return this._CostTypeName;}
        set{this._CostTypeName=value;}
    }

	private string _AddSubtract;
	public string AddSubtract
	{
		get { return this._AddSubtract; }
		set { this._AddSubtract = value; }
	}

    private int _Position;
    public int Position
    {
        get { return this._Position; }
        set { this._Position = value; }
    }

	private AdditionalExpense _objAdditionalExpense;
	public AdditionalExpense objAdditionalExpense
	{
		get { 
			if (this._objAdditionalExpense == null)
				this._objAdditionalExpense = new AdditionalExpense();
			return this._objAdditionalExpense;
		}
		set { this._objAdditionalExpense = value; }
	}

	private CostType _objCostType;
	public CostType objCostType
	{
		get { 
			if (this._objCostType == null)
				this._objCostType = new CostType();
			return this._objCostType;
		}
		set { this._objCostType = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RoyaltyCommissionDetailsBroker();
    }

	public override void LoadObjects()
    {
		
		if (this.CommissionTypeCode > 0)
		{
			this.objAdditionalExpense.IntCode = this.CommissionTypeCode;
			this.objAdditionalExpense.Fetch();
		}

		if (this.CommissionTypeCode > 0)
		{
			this.objCostType.IntCode = this.CommissionTypeCode;
			this.objCostType.Fetch();
		}
        
     
	}

    public override void UnloadObjects()
    {
        
    }

    public DataSet getCostType(int intcode)
    {
        DataSet ds = ((RoyaltyCommissionDetailsBroker)GetBroker()).getCostType(intcode);
        return ds;

    }

    #endregion    
}
