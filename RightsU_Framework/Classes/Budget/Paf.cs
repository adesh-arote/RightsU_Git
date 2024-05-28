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
public class  Paf : Persistent
{
	public  Paf()
	{
		OrderByColumnName = "paf_code";
		OrderByCondition = "ASC";
		tableName = "Paf";
		pkColName = "paf_code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _PafNo;
	public string PafNo
	{
		get { return this._PafNo; }
		set { this._PafNo = value; }
	}

	private string _CreationDate;
    public string CreationDate
	{
		get { return this._CreationDate; }
		set { this._CreationDate = value; }
	}

	private string _TitleName;
	public string TitleName
	{
		get { return this._TitleName; }
		set { this._TitleName = value; }
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

	private ArrayList _arrPafCostType_Del;
	public ArrayList arrPafCostType_Del
	{
		get { 
			if (this._arrPafCostType_Del == null)
				this._arrPafCostType_Del = new ArrayList();
			return this._arrPafCostType_Del;
		}
		set { this._arrPafCostType_Del = value; }
	}

	private ArrayList _arrPafCostType;
	public ArrayList arrPafCostType
	{
		get { 
			if (this._arrPafCostType == null)
				this._arrPafCostType = new ArrayList();
			return this._arrPafCostType;
		}
		set { this._arrPafCostType = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new PafBroker();
    }

	public override void LoadObjects()
    {
		
		this.arrPafCostType = DBUtil.FillArrayList(new PafCostType(), " and paf_code = '" + this.IntCode + "'", false);
		//this.arrDealMoviePAFDetail = DBUtil.FillArrayList(new DealMoviePAFDetail(), " and paf_code = '" + this.IntCode + "'", false);
	}

    public override void UnloadObjects()
    {
        
		if (arrPafCostType_Del != null)
		{
			foreach (PafCostType objPafCostType in this.arrPafCostType_Del)
			{
				objPafCostType.IsTransactionRequired = true;
				objPafCostType.SqlTrans = this.SqlTrans;
				objPafCostType.IsDeleted = true;
				objPafCostType.Save();
			}
		}
		if (arrPafCostType != null)
		{
			foreach (PafCostType objPafCostType in this.arrPafCostType)
			{
				objPafCostType.PafCode = this.IntCode;
				objPafCostType.IsTransactionRequired = true;
				objPafCostType.SqlTrans = this.SqlTrans;
				if (objPafCostType.IntCode > 0)
					objPafCostType.IsDirty = true;
				objPafCostType.Save();
			}
		}
		
    }
    
    #endregion    
}
