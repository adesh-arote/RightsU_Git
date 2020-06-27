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
public class VendorCountry : Persistent
{
	public  VendorCountry()
	{
        OrderByColumnName = "Vendor_Country_Code";
        OrderByCondition = "ASC";
        tableName = "Vendor_Country";
        pkColName = "Vendor_Country_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _VendorCode;
	public int VendorCode
	{
		get { return this._VendorCode; }
		set { this._VendorCode = value; }
	}

	private int _CountryCode;
	public int CountryCode
	{
		get { return this._CountryCode; }
		set { this._CountryCode = value; }
	}

	private Country _objCountry;
	public Country objCountry
	{
		get { 
			if (this._objCountry == null)
				this._objCountry = new Country();
			return this._objCountry;
		}
		set { this._objCountry = value; }
	}



    private string _Is_Thetrical;
    public string Is_Thetrical
	{
        get { return this._Is_Thetrical; }
        set { this._Is_Thetrical = value; }
	}

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new VendorCountryBroker();
    }

	public override void LoadObjects()
    {
		
		if (this.CountryCode > 0)
		{
			this.objCountry.IntCode = this.CountryCode;
			this.objCountry.Fetch();
		}

	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
