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
public class  VendorRole : Persistent
{
	public  VendorRole()
	{
        OrderByColumnName = "Vendor_Code";
		OrderByCondition= "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _VendorCode;
	public int VendorCode
	{
		get { return this._VendorCode; }
		set { this._VendorCode = value; }
	}

	private int _RoleCode;
	public int RoleCode
	{
		get { return this._RoleCode; }
		set { this._RoleCode = value; }
	}

	private char _IsActive;
	public char IsActive
	{
		get { return this._IsActive; }
		set { this._IsActive = value; }
	}

	private Roles _objRole;
	public Roles objRole
	{
		get { 
			if (this._objRole == null)
				this._objRole = new Roles();
			return this._objRole;
		}
		set { this._objRole = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new VendorRoleBroker();
    }

	public override void LoadObjects()
    {
		
		if (this.RoleCode > 0)
		{
			this.objRole.IntCode = this.RoleCode;
			this.objRole.Fetch();
		}

	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
