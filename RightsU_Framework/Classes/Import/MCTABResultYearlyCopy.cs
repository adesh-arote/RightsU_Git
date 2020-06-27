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
public class  MCTABResultYearlyCopy : Persistent
{
	public  MCTABResultYearlyCopy()
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

	private string _TitleId;
	public string TitleId
	{
		get { return this._TitleId; }
		set { this._TitleId = value; }
	}

	private string _TitleName;
	public string TitleName
	{
		get { return this._TitleName; }
		set { this._TitleName = value; }
	}

	private string _ShowbizzFormat;
	public string ShowbizzFormat
	{
		get { return this._ShowbizzFormat; }
		set { this._ShowbizzFormat = value; }
	}

	private string _MasterFormat;
	public string MasterFormat
	{
		get { return this._MasterFormat; }
		set { this._MasterFormat = value; }
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

	private decimal _TotalPurQty;
	public decimal TotalPurQty
	{
		get { return this._TotalPurQty; }
		set { this._TotalPurQty = value; }
	}

	private float _TotalPurRate;
	public float TotalPurRate
	{
		get { return this._TotalPurRate; }
		set { this._TotalPurRate = value; }
	}

	private float _TotalPurCostValue;
	public float TotalPurCostValue
	{
		get { return this._TotalPurCostValue; }
		set { this._TotalPurCostValue = value; }
	}

	private decimal _RPOutQty;
	public decimal RPOutQty
	{
		get { return this._RPOutQty; }
		set { this._RPOutQty = value; }
	}

	private float _RPOutRate;
	public float RPOutRate
	{
		get { return this._RPOutRate; }
		set { this._RPOutRate = value; }
	}

	private float _RPOutValue;
	public float RPOutValue
	{
		get { return this._RPOutValue; }
		set { this._RPOutValue = value; }
	}

	private decimal _RPInQty;
	public decimal RPInQty
	{
		get { return this._RPInQty; }
		set { this._RPInQty = value; }
	}

	private float _RPInRate;
	public float RPInRate
	{
		get { return this._RPInRate; }
		set { this._RPInRate = value; }
	}

	private float _RPInValue;
	public float RPInValue
	{
		get { return this._RPInValue; }
		set { this._RPInValue = value; }
	}

	private decimal _RepackersStkQty;
	public decimal RepackersStkQty
	{
		get { return this._RepackersStkQty; }
		set { this._RepackersStkQty = value; }
	}

	private float _RepackersStkRate;
	public float RepackersStkRate
	{
		get { return this._RepackersStkRate; }
		set { this._RepackersStkRate = value; }
	}

	private float _RepackersStkValue;
	public float RepackersStkValue
	{
		get { return this._RepackersStkValue; }
		set { this._RepackersStkValue = value; }
	}

	private decimal _TotalMaterialQty;
	public decimal TotalMaterialQty
	{
		get { return this._TotalMaterialQty; }
		set { this._TotalMaterialQty = value; }
	}

	private float _TotalMaterialRate;
	public float TotalMaterialRate
	{
		get { return this._TotalMaterialRate; }
		set { this._TotalMaterialRate = value; }
	}

	private float _TotalMaterialValue;
	public float TotalMaterialValue
	{
		get { return this._TotalMaterialValue; }
		set { this._TotalMaterialValue = value; }
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

	private float _PurCreditNoteValue;
	public float PurCreditNoteValue
	{
		get { return this._PurCreditNoteValue; }
		set { this._PurCreditNoteValue = value; }
	}

	private float _PurDebitNoteValue;
	public float PurDebitNoteValue
	{
		get { return this._PurDebitNoteValue; }
		set { this._PurDebitNoteValue = value; }
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

	private decimal _MatConsQty;
	public decimal MatConsQty
	{
		get { return this._MatConsQty; }
		set { this._MatConsQty = value; }
	}

	private float _MatConsRate;
	public float MatConsRate
	{
		get { return this._MatConsRate; }
		set { this._MatConsRate = value; }
	}

	private float _MatConsValue;
	public float MatConsValue
	{
		get { return this._MatConsValue; }
		set { this._MatConsValue = value; }
	}

	private float _ContnwoDistn;
	public float ContnwoDistn
	{
		get { return this._ContnwoDistn; }
		set { this._ContnwoDistn = value; }
	}

	private float _ContnwoDistnPercent;
	public float ContnwoDistnPercent
	{
		get { return this._ContnwoDistnPercent; }
		set { this._ContnwoDistnPercent = value; }
	}

	private float _SAPDirectExpense;
	public float SAPDirectExpense
	{
		get { return this._SAPDirectExpense; }
		set { this._SAPDirectExpense = value; }
	}

	private float _SAPForeignExchange;
	public float SAPForeignExchange
	{
		get { return this._SAPForeignExchange; }
		set { this._SAPForeignExchange = value; }
	}

	private float _SAPMarketingExp;
	public float SAPMarketingExp
	{
		get { return this._SAPMarketingExp; }
		set { this._SAPMarketingExp = value; }
	}

	private float _SAPDownloadCost;
	public float SAPDownloadCost
	{
		get { return this._SAPDownloadCost; }
		set { this._SAPDownloadCost = value; }
	}

	private float _TotalDirectExpense;
	public float TotalDirectExpense
	{
		get { return this._TotalDirectExpense; }
		set { this._TotalDirectExpense = value; }
	}

	private float _DistriExpense;
	public float DistriExpense
	{
		get { return this._DistriExpense; }
		set { this._DistriExpense = value; }
	}

	private float _ContnPostDistn;
	public float ContnPostDistn
	{
		get { return this._ContnPostDistn; }
		set { this._ContnPostDistn = value; }
	}

	private decimal _FreeSampleQty;
	public decimal FreeSampleQty
	{
		get { return this._FreeSampleQty; }
		set { this._FreeSampleQty = value; }
	}

	private decimal _ClStockQty;
	public decimal ClStockQty
	{
		get { return this._ClStockQty; }
		set { this._ClStockQty = value; }
	}

	private decimal _StockinTransit;
	public decimal StockinTransit
	{
		get { return this._StockinTransit; }
		set { this._StockinTransit = value; }
	}

	private decimal _StockwithRep;
	public decimal StockwithRep
	{
		get { return this._StockwithRep; }
		set { this._StockwithRep = value; }
	}

	private decimal _StockInSpindle;
	public decimal StockInSpindle
	{
		get { return this._StockInSpindle; }
		set { this._StockInSpindle = value; }
	}

	private decimal _TotalClosingstkQty;
	public decimal TotalClosingstkQty
	{
		get { return this._TotalClosingstkQty; }
		set { this._TotalClosingstkQty = value; }
	}

	private float _TotalClosingStkRate;
	public float TotalClosingStkRate
	{
		get { return this._TotalClosingStkRate; }
		set { this._TotalClosingStkRate = value; }
	}

	private float _TotalClStockValue;
	public float TotalClStockValue
	{
		get { return this._TotalClStockValue; }
		set { this._TotalClStockValue = value; }
	}

	private float _DevaluedStockRate;
	public float DevaluedStockRate
	{
		get { return this._DevaluedStockRate; }
		set { this._DevaluedStockRate = value; }
	}

	private float _RevisedStkValue;
	public float RevisedStkValue
	{
		get { return this._RevisedStkValue; }
		set { this._RevisedStkValue = value; }
	}

	private float _DevaluationAmount;
	public float DevaluationAmount
	{
		get { return this._DevaluationAmount; }
		set { this._DevaluationAmount = value; }
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
        return new MCTABResultYearlyCopyBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
