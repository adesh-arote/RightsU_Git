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
public class  MaterialReceiptOrder : Persistent
{
	public  MaterialReceiptOrder()
	{
        OrderByColumnName = "material_receipt_code";
		OrderByCondition= "ASC";
        tableName = "material_receipt_order";
        pkColName = "material_receipt_order";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _MaterialReceiptCode;
	public int MaterialReceiptCode
	{
		get { return this._MaterialReceiptCode; }
		set { this._MaterialReceiptCode = value; }
	}

	private int _MaterialOrderDetailCode;
	public int MaterialOrderDetailCode
	{
		get { return this._MaterialOrderDetailCode; }
		set { this._MaterialOrderDetailCode = value; }
	}

	private int _ReceivedQantity;
	public int ReceivedQantity
	{
		get { return this._ReceivedQantity; }
		set { this._ReceivedQantity = value; }
	}

	private MaterialOrderDetails _objMaterialOrderDetails;
	public MaterialOrderDetails objMaterialOrderDetails
	{
		get { 
			if (this._objMaterialOrderDetails == null)
				this._objMaterialOrderDetails = new MaterialOrderDetails();
			return this._objMaterialOrderDetails;
		}
		set { this._objMaterialOrderDetails = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new MaterialReceiptOrderBroker();
    }

	public override void LoadObjects()
    {
		
		if (this.MaterialOrderDetailCode > 0)
		{
			this.objMaterialOrderDetails.IntCode = this.MaterialOrderDetailCode;
			this.objMaterialOrderDetails.Fetch();
		}

	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
