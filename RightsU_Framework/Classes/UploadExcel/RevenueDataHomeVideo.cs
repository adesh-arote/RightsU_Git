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
public class  RevenueDataHomeVideo : Persistent
{
	public  RevenueDataHomeVideo()
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

	private decimal _GrossAmount;
	public decimal GrossAmount
	{
		get { return this._GrossAmount; }
		set { this._GrossAmount = value; }
	}

	private decimal _Tax;
	public decimal Tax
	{
		get { return this._Tax; }
		set { this._Tax = value; }
	}

	private decimal _NetAmount;
	public decimal NetAmount
	{
		get { return this._NetAmount; }
		set { this._NetAmount = value; }
	}

	private decimal _Copy;
	public decimal Copy
	{
		get { return this._Copy; }
		set { this._Copy = value; }
	}

	private decimal _TotalRevenue;
	public decimal TotalRevenue
	{
		get { return this._TotalRevenue; }
		set { this._TotalRevenue = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RevenueDataHomeVideoBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
