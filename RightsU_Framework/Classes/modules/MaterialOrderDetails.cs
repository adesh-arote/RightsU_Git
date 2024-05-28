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
public class  MaterialOrderDetails : Persistent
{
	public  MaterialOrderDetails()
	{
        OrderByColumnName = "material_order_detail_code";
        OrderByCondition = "desc";
        tableName = "material_order_detail";
        pkColName = "material_order_detail_code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _MaterialOrderCode;
	public int MaterialOrderCode
	{
		get { return this._MaterialOrderCode; }
		set { this._MaterialOrderCode = value; }
	}

	private int _DealCode;
	public int DealCode
	{
		get { return this._DealCode; }
		set { this._DealCode = value; }
	}

	private int _DealMovieCode;
	public int DealMovieCode
	{
		get { return this._DealMovieCode; }
		set { this._DealMovieCode = value; }
	}

	private int _MaterialMediumCode;
	public int MaterialMediumCode
	{
		get { return this._MaterialMediumCode; }
		set { this._MaterialMediumCode = value; }
	}

	private int _OrderQuantity;
	public int OrderQuantity
	{
		get { return this._OrderQuantity; }
		set { this._OrderQuantity = value; }
	}

	private int _CurrencyCode;
	public int CurrencyCode
	{
		get { return this._CurrencyCode; }
		set { this._CurrencyCode = value; }
	}

	private decimal _Rate;
	public decimal Rate
	{
		get { return this._Rate; }
		set { this._Rate = value; }
	}

	private decimal _Amount;
	public decimal Amount
	{
		get { return this._Amount; }
		set { this._Amount = value; }
	}

	private string _Remarks;
	public string Remarks
	{
		get { return this._Remarks; }
		set { this._Remarks = value; }
	}

	private int _ReceivedQuantity;
	public int ReceivedQuantity
	{
		get { return this._ReceivedQuantity; }
		set { this._ReceivedQuantity = value; }
	}

    //private Deal _objDeal;
    //public Deal objDeal
    //{
    //    get { 
    //        if (this._objDeal == null)
    //            this._objDeal = new Deal();
    //        return this._objDeal;
    //    }
    //    set { this._objDeal = value; }
    //}

    //private DealMovie _objDealMovie;
    //public DealMovie objDealMovie
    //{
    //    get { 
    //        if (this._objDealMovie == null)
    //            this._objDealMovie = new DealMovie();
    //        return this._objDealMovie;
    //    }
    //    set { this._objDealMovie = value; }
    //}

	private MaterialMedium _objMaterialMedium;
	public MaterialMedium objMaterialMedium
	{
		get { 
			if (this._objMaterialMedium == null)
				this._objMaterialMedium = new MaterialMedium();
			return this._objMaterialMedium;
		}
		set { this._objMaterialMedium = value; }
	}

	private Currency _objCurrency;
	public Currency objCurrency
	{
		get { 
			if (this._objCurrency == null)
				this._objCurrency = new Currency();
			return this._objCurrency;
		}
		set { this._objCurrency = value; }
	}

	private ArrayList _arrMaterialReceipt_Del;
	public ArrayList arrMaterialReceipt_Del
	{
		get { 
			if (this._arrMaterialReceipt_Del == null)
				this._arrMaterialReceipt_Del = new ArrayList();
			return this._arrMaterialReceipt_Del;
		}
		set { this._arrMaterialReceipt_Del = value; }
	}

	private ArrayList _arrMaterialReceipt;
	public ArrayList arrMaterialReceipt
	{
		get { 
			if (this._arrMaterialReceipt == null)
				this._arrMaterialReceipt = new ArrayList();
			return this._arrMaterialReceipt;
		}
		set { this._arrMaterialReceipt = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new MaterialOrderDetailsBroker();
    }

	public override void LoadObjects()
    {
		
        //if (this.DealCode > 0)
        //{
        //    this.objDeal.IntCode = this.DealCode;
        //    this.objDeal.Fetch();
        //}

        //if (this.DealMovieCode > 0)
        //{
        //    this.objDealMovie.IntCode = this.DealMovieCode;
        //    this.objDealMovie.Fetch();
        //}

		if (this.MaterialMediumCode > 0)
		{
			this.objMaterialMedium.IntCode = this.MaterialMediumCode;
			this.objMaterialMedium.Fetch();
		}

		if (this.CurrencyCode > 0)
		{
			this.objCurrency.IntCode = this.CurrencyCode;
			this.objCurrency.Fetch();
		}

        //dada
		//this.arrMaterialReceipt = DBUtil.FillArrayList(new MaterialReceipt(), " and material_order_detail_code = '" + this.IntCode + "'", false);

	}

    public override void UnloadObjects()
    {
        
        //if (arrMaterialReceipt_Del != null)
        //{
        //    foreach (MaterialReceipt objMaterialReceipt in this.arrMaterialReceipt_Del)
        //    {
        //        objMaterialReceipt.IsTransactionRequired = true;
        //        objMaterialReceipt.SqlTrans = this.SqlTrans;
        //        objMaterialReceipt.IsDeleted = true;
        //        objMaterialReceipt.Save();
        //    }
        //}
        //if (arrMaterialReceipt != null)
        //{
        //    foreach (MaterialReceipt objMaterialReceipt in this.arrMaterialReceipt)
        //    {
        //        objMaterialReceipt.MaterialOrderDetailCode = this.IntCode;
        //        objMaterialReceipt.IsTransactionRequired = true;
        //        objMaterialReceipt.SqlTrans = this.SqlTrans;
        //        if (objMaterialReceipt.IntCode > 0)
        //            objMaterialReceipt.IsDirty = true;
        //        objMaterialReceipt.Save();
        //    }
        //}
    }
    
    #endregion    
}
