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
public class  MCTABResultMonthlyCopy : Persistent
{
	public  MCTABResultMonthlyCopy()
	{
		//OrderByColumnName = "";
		//OrderByCondition= "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _MonthYear;
	public string MonthYear
	{
		get { return this._MonthYear; }
		set { this._MonthYear = value; }
	}

	private string _TitleID;
	public string TitleID
	{
		get { return this._TitleID; }
		set { this._TitleID = value; }
	}

	private string _TitleName;
	public string TitleName
	{
		get { return this._TitleName; }
		set { this._TitleName = value; }
	}

	private string _MasterFormat;
	public string MasterFormat
	{
		get { return this._MasterFormat; }
		set { this._MasterFormat = value; }
	}

	private string _ShowbizzFormat;
	public string ShowbizzFormat
	{
		get { return this._ShowbizzFormat; }
		set { this._ShowbizzFormat = value; }
	}

	private decimal _MRP;
	public decimal MRP
	{
		get { return this._MRP; }
		set { this._MRP = value; }
	}

	private string _ReleaseDate;
	public string ReleaseDate
	{
		get { return this._ReleaseDate; }
		set { this._ReleaseDate = value; }
	}

	private string _RightsExpiry;
	public string RightsExpiry
	{
		get { return this._RightsExpiry; }
		set { this._RightsExpiry = value; }
	}

	private string _Classification;
	public string Classification
	{
		get { return this._Classification; }
		set { this._Classification = value; }
	}

	private string _Banner;
	public string Banner
	{
		get { return this._Banner; }
		set { this._Banner = value; }
	}

	private string _Dubbed;
	public string Dubbed
	{
		get { return this._Dubbed; }
		set { this._Dubbed = value; }
	}

	private string _Language;
	public string Language
	{
		get { return this._Language; }
		set { this._Language = value; }
	}

	private string _Genre;
	public string Genre
	{
		get { return this._Genre; }
		set { this._Genre = value; }
	}

	private string _Grade;
	public string Grade
	{
		get { return this._Grade; }
		set { this._Grade = value; }
	}

	private string _Zone;
	public string Zone
	{
		get { return this._Zone; }
		set { this._Zone = value; }
	}

	private string _FilmType;
	public string FilmType
	{
		get { return this._FilmType; }
		set { this._FilmType = value; }
	}

	private decimal _SAPInternalOrder;
	public decimal SAPInternalOrder
	{
		get { return this._SAPInternalOrder; }
		set { this._SAPInternalOrder = value; }
	}

	private string _BoxSetIndicator;
	public string BoxSetIndicator
	{
		get { return this._BoxSetIndicator; }
		set { this._BoxSetIndicator = value; }
	}

	private decimal _OpQty;
	public decimal OpQty
	{
		get { return this._OpQty; }
		set { this._OpQty = value; }
	}

	private float _OpRate;
	public float OpRate
	{
		get { return this._OpRate; }
		set { this._OpRate = value; }
	}

	private float _OpValue;
	public float OpValue
	{
		get { return this._OpValue; }
		set { this._OpValue = value; }
	}

	private float _OpAmtDevalued;
	public float OpAmtDevalued
	{
		get { return this._OpAmtDevalued; }
		set { this._OpAmtDevalued = value; }
	}

	private float _OpValueAfterDevaluation;
	public float OpValueAfterDevaluation
	{
		get { return this._OpValueAfterDevaluation; }
		set { this._OpValueAfterDevaluation = value; }
	}

	private decimal _FGPurchaseQty;
	public decimal FGPurchaseQty
	{
		get { return this._FGPurchaseQty; }
		set { this._FGPurchaseQty = value; }
	}

	private float _FGPurchaseRate;
	public float FGPurchaseRate
	{
		get { return this._FGPurchaseRate; }
		set { this._FGPurchaseRate = value; }
	}

	private float _FGPurchaseValue;
	public float FGPurchaseValue
	{
		get { return this._FGPurchaseValue; }
		set { this._FGPurchaseValue = value; }
	}

	private float _RMValue;
	public float RMValue
	{
		get { return this._RMValue; }
		set { this._RMValue = value; }
	}

	private float _StamperCost;
	public float StamperCost
	{
		get { return this._StamperCost; }
		set { this._StamperCost = value; }
	}

	private decimal _DomSaleQty;
	public decimal DomSaleQty
	{
		get { return this._DomSaleQty; }
		set { this._DomSaleQty = value; }
	}

	private float _DomSaleRate;
	public float DomSaleRate
	{
		get { return this._DomSaleRate; }
		set { this._DomSaleRate = value; }
	}

	private float _DomSaleValue;
	public float DomSaleValue
	{
		get { return this._DomSaleValue; }
		set { this._DomSaleValue = value; }
	}

	private decimal _ExpSaleQty;
	public decimal ExpSaleQty
	{
		get { return this._ExpSaleQty; }
		set { this._ExpSaleQty = value; }
	}

	private float _ExpSaleRate;
	public float ExpSaleRate
	{
		get { return this._ExpSaleRate; }
		set { this._ExpSaleRate = value; }
	}

	private float _ExpSaleValue;
	public float ExpSaleValue
	{
		get { return this._ExpSaleValue; }
		set { this._ExpSaleValue = value; }
	}

	private decimal _SalesReturnQty;
	public decimal SalesReturnQty
	{
		get { return this._SalesReturnQty; }
		set { this._SalesReturnQty = value; }
	}

	private decimal _NetSalesQty;
	public decimal NetSalesQty
	{
		get { return this._NetSalesQty; }
		set { this._NetSalesQty = value; }
	}

	private float _NetSalesRate;
	public float NetSalesRate
	{
		get { return this._NetSalesRate; }
		set { this._NetSalesRate = value; }
	}

	private float _NetSalesValue;
	public float NetSalesValue
	{
		get { return this._NetSalesValue; }
		set { this._NetSalesValue = value; }
	}

	private float _FreeSampleValue;
	public float FreeSampleValue
	{
		get { return this._FreeSampleValue; }
		set { this._FreeSampleValue = value; }
	}

	private decimal _FreeSampleQty;
	public decimal FreeSampleQty
	{
		get { return this._FreeSampleQty; }
		set { this._FreeSampleQty = value; }
	}

	private float _DevaluedStockRate;
	public float DevaluedStockRate
	{
		get { return this._DevaluedStockRate; }
		set { this._DevaluedStockRate = value; }
	}

	private float _SaleReturnValue;
	public float SaleReturnValue
	{
		get { return this._SaleReturnValue; }
		set { this._SaleReturnValue = value; }
	}

	private float _SaleCreditNoteValue;
	public float SaleCreditNoteValue
	{
		get { return this._SaleCreditNoteValue; }
		set { this._SaleCreditNoteValue = value; }
	}

	private float _SaleDebitNoteValue;
	public float SaleDebitNoteValue
	{
		get { return this._SaleDebitNoteValue; }
		set { this._SaleDebitNoteValue = value; }
	}

	private decimal _ClStockQty;
	public decimal ClStockQty
	{
		get { return this._ClStockQty; }
		set { this._ClStockQty = value; }
	}

	private decimal _StkInSpindle;
	public decimal StkInSpindle
	{
		get { return this._StkInSpindle; }
		set { this._StkInSpindle = value; }
	}

	private decimal _StkInTransit;
	public decimal StkInTransit
	{
		get { return this._StkInTransit; }
		set { this._StkInTransit = value; }
	}

	private decimal _RPOutQty;
	public decimal RPOutQty
	{
		get { return this._RPOutQty; }
		set { this._RPOutQty = value; }
	}

	private decimal _RPInQty;
	public decimal RPInQty
	{
		get { return this._RPInQty; }
		set { this._RPInQty = value; }
	}

	private int _ExternalTitleCode;
	public int ExternalTitleCode
	{
		get { return this._ExternalTitleCode; }
		set { this._ExternalTitleCode = value; }
	}

	private string _IsError;
	public string IsError
	{
		get { return this._IsError; }
		set { this._IsError = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new MCTABResultMonthlyCopyBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
