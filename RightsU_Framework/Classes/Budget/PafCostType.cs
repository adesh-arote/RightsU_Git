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
public class  PafCostType : Persistent
{
	public  PafCostType()
	{
		OrderByColumnName = "paf_cost_type_code";
		OrderByCondition = "ASC";
		tableName = "Paf_Cost_Type";
		pkColName = "paf_cost_type_code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _PafCode;
	public int PafCode
	{
		get { return this._PafCode; }
		set { this._PafCode = value; }
	}

	private int _PafCtmCode;
	public int PafCtmCode
	{
		get { return this._PafCtmCode; }
		set { this._PafCtmCode = value; }
	}

	private int _AmsCostTypeCode;
	public int AmsCostTypeCode
	{
		get { return this._AmsCostTypeCode; }
		set { this._AmsCostTypeCode = value; }
	}

	private decimal _amount;
	public decimal amount
	{
		get { return this._amount; }
		set { this._amount = value; }
	}

	private decimal _utilized;
	public decimal utilized
	{
		get { return this._utilized; }
		set { this._utilized = value; }
	}

	private decimal _balance;
	public decimal balance
	{
		get { return this._balance; }
		set { this._balance = value; }
	}

	private string _EntryType;
	public string EntryType
	{
		get { return this._EntryType; }
		set { this._EntryType = value; }
	}

	private Paf _objPaf;
	public Paf objPaf
	{
		get { 
			if (this._objPaf == null)
				this._objPaf = new Paf();
			return this._objPaf;
		}
		set { this._objPaf = value; }
	}

	private PafCostTypeMapping _objPafCostTypeMapping;
	public PafCostTypeMapping objPafCostTypeMapping
	{
		get { 
			if (this._objPafCostTypeMapping == null)
				this._objPafCostTypeMapping = new PafCostTypeMapping();
			return this._objPafCostTypeMapping;
		}
		set { this._objPafCostTypeMapping = value; }
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
        return new PafCostTypeBroker();
    }

	public override void LoadObjects()
    {
		
		if (this.PafCode > 0)
		{
			this.objPaf.IntCode = this.PafCode;
			this.objPaf.Fetch();
		}

		if (this.PafCtmCode > 0)
		{
			this.objPafCostTypeMapping.IntCode = this.PafCtmCode;
			this.objPafCostTypeMapping.Fetch();
		}

		if (this.AmsCostTypeCode > 0)
		{
			this.objCostType.IntCode = this.AmsCostTypeCode;
			this.objCostType.Fetch();
		}

	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
