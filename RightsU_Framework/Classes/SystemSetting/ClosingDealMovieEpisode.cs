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
public class  ClosingDealMovieEpisode : Persistent
{
	public  ClosingDealMovieEpisode()
	{
        OrderByColumnName = "closing_deal_movie_episode_code";
		 OrderByCondition= "desc";
         tableName = "closing_deal_movie_episode";
         pkColName = "closing_deal_movie_episode_code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _DealMovieContentsCode;
	public int DealMovieContentsCode
	{
		get { return this._DealMovieContentsCode; }
		set { this._DealMovieContentsCode = value; }
	}

	private DateTime _MonthClosed;
	public DateTime MonthClosed
	{
		get { return this._MonthClosed; }
		set { this._MonthClosed = value; }
	}

	private decimal _ClosedAmount;
	public decimal ClosedAmount
	{
		get { return this._ClosedAmount; }
		set { this._ClosedAmount = value; }
	}

	private decimal _BalanceAmount;
	public decimal BalanceAmount
	{
		get { return this._BalanceAmount; }
		set { this._BalanceAmount = value; }
	}

	private decimal _AdditionalAmount;
	public decimal AdditionalAmount
	{
		get { return this._AdditionalAmount; }
		set { this._AdditionalAmount = value; }
	}

	private decimal _BalanceToAmortAdditionalAmount;
	public decimal BalanceToAmortAdditionalAmount
	{
		get { return this._BalanceToAmortAdditionalAmount; }
		set { this._BalanceToAmortAdditionalAmount = value; }
	}

	private int _ClosedBy;
	public int ClosedBy
	{
		get { return this._ClosedBy; }
		set { this._ClosedBy = value; }
	}

	private DateTime _ClosedOn;
	public DateTime ClosedOn
	{
		get { return this._ClosedOn; }
		set { this._ClosedOn = value; }
	}

	private int _ClosedRuns;
	public int ClosedRuns
	{
		get { return this._ClosedRuns; }
		set { this._ClosedRuns = value; }
	}
    public int Isactive { get; set; }

    public string DisplayClosedOn
    {
        get {
            return ClosedOn.ToString("dd/MM/yyyy") ;
        }
    }
    private string _displayClosed_by = "";
    public string DisplayClosed_by
    {
        get {
            return _displayClosed_by;
        }
        set
        {
            _displayClosed_by = value;
        }
    }
 
    private string _displaymonth = "";
    public string Displaymonth
    {
        get
        {
            return _displaymonth;
        }
        set
        {
            _displaymonth = value;
        }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ClosingDealMovieEpisodeBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    

    public DataSet GetNextClosingDate()
    {
        return ((ClosingDealMovieEpisodeBroker )this.GetBroker()).GetNextClosingDate();
    }
    public DataSet GetNextClosingDateTime()
    {
        return ((ClosingDealMovieEpisodeBroker)this.GetBroker()).GetNextClosingDateTime();
    }
   

	public string getMovieRightsPeriod(int DealMovieCode) 
	{
		return ((ClosingDealMovieEpisodeBroker)this.GetBroker()).getMovieRightsPeriod(DealMovieCode);
	}

	public string getAmortNote(int DealMovieCode) 
	{
		return ((ClosingDealMovieEpisodeBroker)this.GetBroker()).getAmortNote(DealMovieCode);
	}
}
