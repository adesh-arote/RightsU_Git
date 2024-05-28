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
public class  VendorDomesticTerritory : Persistent
{
	public  VendorDomesticTerritory()
	{
        OrderByColumnName = "Vendor_Domestic_Territory_Code";
        OrderByCondition = "ASC";
        tableName = "Vendor_Domestic_Territory";
        pkColName = "Vendor_Domestic_Territory_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _VendorCode;
	public int VendorCode
	{
		get { return this._VendorCode; }
		set { this._VendorCode = value; }
	}

	private int _TerritoryCode;
	public int TerritoryCode
	{
		get { return this._TerritoryCode; }
		set { this._TerritoryCode = value; }
	}

	private Territory _objTerritory;
	public Territory objTerritory
	{
		get { 
			if (this._objTerritory == null)
				this._objTerritory = new Territory();
			return this._objTerritory;
		}
		set { this._objTerritory = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new VendorDomesticTerritoryBroker();
    }

	public override void LoadObjects()
    {
		
		if (this.TerritoryCode > 0)
		{
			this.objTerritory.IntCode = this.TerritoryCode;
			this.objTerritory.Fetch();
		}

	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
