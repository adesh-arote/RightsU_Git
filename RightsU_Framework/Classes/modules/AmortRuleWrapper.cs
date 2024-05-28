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
public class AmortRuleWrapper : Persistent
{
	public AmortRuleWrapper()
    {
        OrderByColumnName = "draft_lfa_code";
        OrderByCondition = "ASC";
        tableName = "Draft_LFA";
        pkColName = "draft_lfa_code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _DealMovieCode;
	public int DealMovieCode
    {
		get { return this._DealMovieCode; }
		set { this._DealMovieCode = value; }
    }

	private int _costTypeCode;
	public int CostTypeCode {
		get { return this._costTypeCode; }
		set { this._costTypeCode = value; }
	}
	private string _costTypeName;
	public string costTypeName {
		get { return this._costTypeName; }
		set { this._costTypeName = value; }
	}

	private int _amortRuleCode;
	public int amortRuleCode {
		get { return this._amortRuleCode; }
		set { this._amortRuleCode = value; }
	}

	private string _amortRuleText;
	public string amortRuleText 
	{
		get { return this._amortRuleText; }
		set { this._amortRuleText = value; }
	}


	private decimal _amount;
	public decimal amount {
		get { return this._amount; }
		set { this._amount = value; }
	}

	private int _deal_movie_content_code;
	public int deal_movie_content_code {
		get { return this._deal_movie_content_code; }
		set { this._deal_movie_content_code = value; }
	}
	private int _ChannelCode;
	public int ChannelCode {
		get { return this._ChannelCode; }
		set { this._ChannelCode = value; }
	}


	private int _deal_movie_contents_amort_code;
	public int deal_movie_contents_amort_code {
		get { return this._deal_movie_contents_amort_code; }
		set { this._deal_movie_contents_amort_code = value; }
	}

    private string _canChangeAmortRule="Y";
    public string canChangeAmortRule
    {
        get { return this._canChangeAmortRule; }
        set { this._canChangeAmortRule = value; }
    }
	
	

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
		return new AmortRuleWrapperBroker();
    }

    public override void LoadObjects()
    {
        
    }

    public override void UnloadObjects()
    {

	}
	#endregion
}