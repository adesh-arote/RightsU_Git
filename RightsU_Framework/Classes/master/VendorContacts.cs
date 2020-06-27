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
public class VendorContacts : Persistent {
    public VendorContacts()
    {
        OrderByColumnName = "department";
        OrderByCondition = "ASC";
        pkColName = "vendor_contacts_code";
        tableName = "Vendor_Contacts";
    }

    #region ---------------Attributes And Prperties---------------


    private int _VendorCode;
    public int VendorCode
    {
        get { return this._VendorCode; }
        set { this._VendorCode = value; }
    }

    private string _ContactName;
    public string ContactName
    {
        get { return this._ContactName; }
        set { this._ContactName = value; }
    }

    private string _PhoneNo;
    public string PhoneNo
    {
        get { return this._PhoneNo; }
        set { this._PhoneNo = value; }
    }

    private string _Email;
    public string Email
    {
        get { return this._Email; }
        set { this._Email = value; }
    }

    private string _Department;
    public string Department
    {
        get { return this._Department; }
        set { this._Department = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new VendorContactsBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
