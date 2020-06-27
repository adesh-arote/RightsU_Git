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
public class  RevenueDataTheatre : Persistent
{
	public  RevenueDataTheatre()
	{
		//OrderByColumnName = "";
		//OrderByCondition= "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _DistributorVendorCode;
	public int DistributorVendorCode
	{
		get { return this._DistributorVendorCode; }
		set { this._DistributorVendorCode = value; }
	}

	private string _TheatreName;
	public string TheatreName
	{
		get { return this._TheatreName; }
		set { this._TheatreName = value; }
	}

    private string _CityName;
    public string CityName
	{
        get { return this._CityName; }
        set { this._CityName = value; }
	}

	private int _DealMovieCode;
	public int DealMovieCode
	{
		get { return this._DealMovieCode; }
		set { this._DealMovieCode = value; }
	}

	private string _TitleCodeId;
	public string TitleCodeId
	{
		get { return this._TitleCodeId; }
		set { this._TitleCodeId = value; }
	}

	private DateTime _FromDate;
	public DateTime FromDate
	{
		get { return this._FromDate; }
		set { this._FromDate = value; }
	}

	private DateTime _ToDate;
	public DateTime ToDate
	{
		get { return this._ToDate; }
		set { this._ToDate = value; }
	}

	private decimal _Days;
	public decimal Days
	{
		get { return this._Days; }
		set { this._Days = value; }
	}

	private decimal _ShowPerDay;
	public decimal ShowPerDay
	{
		get { return this._ShowPerDay; }
		set { this._ShowPerDay = value; }
	}

	private decimal _NoOfSeat;
	public decimal NoOfSeat
	{
		get { return this._NoOfSeat; }
		set { this._NoOfSeat = value; }
	}

	private decimal _TicketRate;
	public decimal TicketRate
	{
		get { return this._TicketRate; }
		set { this._TicketRate = value; }
	}

	private decimal _St;
	public decimal St
	{
		get { return this._St; }
		set { this._St = value; }
	}

	private decimal _EntTax;
	public decimal EntTax
	{
		get { return this._EntTax; }
		set { this._EntTax = value; }
	}

	private decimal _NetAmount;
	public decimal NetAmount
	{
		get { return this._NetAmount; }
		set { this._NetAmount = value; }
	}

	private decimal _Revenue;
	public decimal Revenue
	{
		get { return this._Revenue; }
		set { this._Revenue = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RevenueDataTheatreBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
