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
public class  RoyaltyRecoupmentDetails : Persistent
{
	public  RoyaltyRecoupmentDetails()
	{
		OrderByColumnName = "recoupment_type";
		OrderByCondition= "ASC";
        tableName = "Royalty_Recoupment_Details";
        pkColName = "Royalty_Recoupment_Details_code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _RoyaltyRecoupmentCode;
	public int RoyaltyRecoupmentCode
	{
		get { return this._RoyaltyRecoupmentCode; }
		set { this._RoyaltyRecoupmentCode = value; }
	}

	private string _RecoupmentType;
	public string RecoupmentType
	{
		get { return this._RecoupmentType; }
		set { this._RecoupmentType = value; }
	}

	private int _RecoupmentTypeCode;
	public int RecoupmentTypeCode
	{
		get { return this._RecoupmentTypeCode; }
		set { this._RecoupmentTypeCode = value; }
	}

    private int _Position;
    public int Position
    {
        get { return this._Position; }
        set { this._Position = value; }

    }

	private string _AddSubtract;
	public string AddSubtract
	{
		get { return this._AddSubtract; }
		set { this._AddSubtract = value; }
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

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RoyaltyRecoupmentDetailsBroker();
    }

	public override void LoadObjects()
    {
		
		if (this.RecoupmentTypeCode > 0)
		{
			this.objAdditionalExpense.IntCode = this.RecoupmentTypeCode;
			this.objAdditionalExpense.Fetch();
		}

	}

    public override void UnloadObjects()
    {
        
    }
    public DataSet getCostType(int intcode)
    {
        DataSet ds = ((RoyaltyRecoupmentDetailsBroker)GetBroker()).getCostType(intcode);
        return ds;

    }
    
    #endregion    
}
