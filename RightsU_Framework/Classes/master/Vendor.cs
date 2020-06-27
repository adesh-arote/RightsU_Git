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
public class Vendor : Persistent
{
    public Vendor()
    {
        tableName = "Vendor";
        pkColName = "Vendor_Code";
        OrderByColumnName = "Vendor_Name";
        OrderByCondition = "ASC";
    }
    public Vendor(int code)
        : base(code)
    {
        tableName = "Vendor";
        pkColName = "Vendor_Code";
        OrderByColumnName = "Vendor_Name";
        OrderByCondition = "ASC";
    }
    #region ---------------Attributes And Prperties---------------

    private string _VendorRoles;
    public string VendorRoles
    {
        get { return this._VendorRoles; }
        set { this._VendorRoles = value; }
    }

    private string _VendorName;
    public string VendorName
    {
        get { return this._VendorName; }
        set { this._VendorName = value; }
    }

    private string _Address;
    public string Address
    {
        get { return this._Address; }
        set { this._Address = value; }
    }

    private string _PhoneNo;
    public string PhoneNo
    {
        get { return this._PhoneNo; }
        set { this._PhoneNo = value; }
    }

    private string _FaxNo;
    public string FaxNo
    {
        get { return this._FaxNo; }
        set { this._FaxNo = value; }
    }

    private string _STNo;
    public string STNo
    {
        get { return this._STNo; }
        set { this._STNo = value; }
    }

    private string _VATNo;
    public string VATNo
    {
        get { return this._VATNo; }
        set { this._VATNo = value; }
    }

    private string _TINNo;
    public string TINNo
    {
        get { return this._TINNo; }
        set { this._TINNo = value; }
    }

    private string _PANNo;
    public string PANNo
    {
        get { return this._PANNo; }
        set { this._PANNo = value; }
    }


    private string _CSTNo;
    public string CSTNo
    {
        get { return this._CSTNo; }
        set { this._CSTNo = value; }
    }


    private char _Type;
    public char Type
    {
        get { return this._Type; }
        set { this._Type = value; }
    }
    private ArrayList _arrVenderContacts_Del;
    public ArrayList arrVenderContacts_Del
    {
        get
        {
            if (this._arrVenderContacts_Del == null)
                this._arrVenderContacts_Del = new ArrayList();
            return this._arrVenderContacts_Del;
        }
        set { this._arrVenderContacts_Del = value; }
    }

    private ArrayList _arrVenderContacts;
    public ArrayList arrVenderContacts
    {
        get
        {
            if (this._arrVenderContacts == null)
                this._arrVenderContacts = new ArrayList();
            return this._arrVenderContacts;
        }
        set { this._arrVenderContacts = value; }
    }
    private ArrayList _arrRole;
    public ArrayList ArrRole
    {
        get
        {
            if (_arrRole == null)
                _arrRole = new ArrayList();
            return _arrRole;
        }
        set { _arrRole = value; }

    }

    private ArrayList _arrRole_Del;
    public ArrayList ArrRole_Del
    {
        get
        {
            if (_arrRole_Del == null)
                _arrRole_Del = new ArrayList();
            return _arrRole_Del;
        }
        set { _arrRole_Del = value; }

    }

    private ArrayList _arrInterNationalTerritory;
    public ArrayList arrInterNationalTerritory
    {
        get
        {
            if (this._arrInterNationalTerritory == null)
                this._arrInterNationalTerritory = new ArrayList();
            return this._arrInterNationalTerritory;
        }
        set { this._arrInterNationalTerritory = value; }
    }

    private ArrayList _arrInterNationalTerritory_Del;
    public ArrayList arrInterNationalTerritory_Del
    {
        get
        {
            if (this._arrInterNationalTerritory_Del == null)
                this._arrInterNationalTerritory_Del = new ArrayList();
            return this._arrInterNationalTerritory_Del;
        }
        set { this._arrInterNationalTerritory_Del = value; }
    }

    private ArrayList _arrDomesticTerritory;
    public ArrayList arrDomesticTerritory
    {
        get
        {
            if (this._arrDomesticTerritory == null)
                this._arrDomesticTerritory = new ArrayList();
            return this._arrDomesticTerritory;
        }
        set { this._arrDomesticTerritory = value; }
    }

    private ArrayList _arrDomesticTerritory_Del;
    public ArrayList arrDomesticTerritory_Del
    {
        get
        {
            if (this._arrDomesticTerritory_Del == null)
                this._arrDomesticTerritory_Del = new ArrayList();
            return this._arrDomesticTerritory_Del;
        }
        set { this._arrDomesticTerritory_Del = value; }
    }

    /*** === Added by sharad for displaying Country in export to excel === ***/

    private string _VendorCountry;
    public string VendorCountry
    {
        get { return this._VendorCountry; }
        set { this._VendorCountry = value; }
    }

    /*** === Added by sharad for displaying Country in export to excel === ***/

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new VendorBroker();
    }

    public override void LoadObjects()
    {
        this.arrVenderContacts = DBUtil.FillArrayList(new VendorContacts(), " and Vendor_Code = '" + this.IntCode + "'", false);
        this.ArrRole = DBUtil.FillArrayList(new VendorRole(), " and Vendor_Code = '" + this.IntCode + "'", false);

        this.ArrRole_Del = DBUtil.FillArrayList(new VendorRole(), " and Vendor_Code = '" + this.IntCode + "'", false);

        this.arrDomesticTerritory = DBUtil.FillArrayList(new VendorCountry(), " And Country_Code In (Select Country_Code From Country Where IsNull(Is_Theatrical_Territory, 'N') = 'N') and Vendor_Code='" + this.IntCode + "' ", false);
        this.arrDomesticTerritory_Del = DBUtil.FillArrayList(new VendorCountry(), " And Country_Code In (Select Country_Code From Country Where IsNull(Is_Theatrical_Territory, 'N') = 'N') and Vendor_Code='" + this.IntCode + "' ", false);
        this.arrInterNationalTerritory = DBUtil.FillArrayList(new VendorCountry(), " And Country_Code In (Select Country_Code From Country Where IsNull(Is_Theatrical_Territory, 'N') = 'Y') and Vendor_Code='" + this.IntCode + "' ", true);
        this.arrInterNationalTerritory_Del = DBUtil.FillArrayList(new VendorCountry(), " And Country_Code In (Select Country_Code From Country Where IsNull(Is_Theatrical_Territory, 'N') = 'Y') and Vendor_Code='" + this.IntCode + "' ", false);

        VendorCountry = getCountry(this.arrInterNationalTerritory);
    }

    private string getCountry(ArrayList arrCountry)
    {
        string vendorCountry = "";
        foreach (VendorCountry objTmpcountry in arrCountry)
        {
            if (vendorCountry != "")
            {
                vendorCountry += ",";
            }
            vendorCountry += objTmpcountry.objCountry.CountryName;
        }

        string strSelectedCountry = vendorCountry.Trim(",".ToCharArray()).Replace(",", ",");
        return strSelectedCountry;
    }

    public override void UnloadObjects()
    {

        if (arrVenderContacts_Del != null)
        {
            foreach (VendorContacts objVenderContacts in this.arrVenderContacts_Del)
            {
                objVenderContacts.IsTransactionRequired = true;
                objVenderContacts.SqlTrans = this.SqlTrans;
                objVenderContacts.IsDeleted = true;
                objVenderContacts.Save();
            }
        }
        if (arrVenderContacts != null)
        {
            foreach (VendorContacts objVenderContacts in this.arrVenderContacts)
            {
                objVenderContacts.VendorCode = this.IntCode;
                objVenderContacts.IsTransactionRequired = true;
                objVenderContacts.SqlTrans = this.SqlTrans;
                if (objVenderContacts.IntCode > 0)
                    objVenderContacts.IsDirty = true;
                objVenderContacts.Save();
            }
        }

        if (ArrRole_Del != null)
        {
            foreach (VendorRole objVendorRole in this.ArrRole_Del)
            {
                objVendorRole.IsTransactionRequired = true;
                objVendorRole.SqlTrans = this.SqlTrans;
                objVendorRole.IsDeleted = true;
                objVendorRole.Save();
            }
        }

        foreach (VendorRole objVendorRole in this.ArrRole)
        {
            objVendorRole.SqlTrans = this.SqlTrans;
            objVendorRole.IsTransactionRequired = true;
            objVendorRole.VendorCode = this.IntCode;
            objVendorRole.Save();
        }



        /*InterNational Territory*/
        if (arrInterNationalTerritory_Del != null)
        {
            foreach (VendorCountry objVendorInternationalTerritory in this.arrInterNationalTerritory_Del)
            {
                objVendorInternationalTerritory.IsTransactionRequired = true;
                objVendorInternationalTerritory.SqlTrans = this.SqlTrans;
                objVendorInternationalTerritory.IsDeleted = true;
                objVendorInternationalTerritory.Save();
            }
        }

        if (arrInterNationalTerritory != null)
        {
            foreach (VendorCountry objVendorInternationalTerritory in this.arrInterNationalTerritory)
            {
                objVendorInternationalTerritory.VendorCode = this.IntCode;
                objVendorInternationalTerritory.IsTransactionRequired = true;
                objVendorInternationalTerritory.SqlTrans = this.SqlTrans;
                if (objVendorInternationalTerritory.IntCode > 0)
                    objVendorInternationalTerritory.IsDirty = true;
                objVendorInternationalTerritory.Save();
            }
        }
        /*InterNational Territory*/

        /*Domestic Territory*/

        if (arrDomesticTerritory_Del != null)
        {
            foreach (VendorCountry objVendorDomesticTerritory in this.arrDomesticTerritory_Del)
            {
                objVendorDomesticTerritory.IsTransactionRequired = true;
                objVendorDomesticTerritory.SqlTrans = this.SqlTrans;
                objVendorDomesticTerritory.IsDeleted = true;
                objVendorDomesticTerritory.Save();
            }
        }

        if (arrDomesticTerritory != null)
        {
            foreach (VendorCountry objVendorDomesticTerritory in this.arrDomesticTerritory)
            {
                objVendorDomesticTerritory.VendorCode = this.IntCode;
                objVendorDomesticTerritory.IsTransactionRequired = true;
                objVendorDomesticTerritory.SqlTrans = this.SqlTrans;
                if (objVendorDomesticTerritory.IntCode > 0)
                    objVendorDomesticTerritory.IsDirty = true;
                objVendorDomesticTerritory.Save();
            }
        }

        /*Domestic Territory*/


    }

    public Boolean IsVendorExist(string VendorName, int Code)
    {
        return (((VendorBroker)this.GetBroker())).IsVendorExist(VendorName, Code);
    }

    #endregion

    public bool CheckRef(int Code)
    {
        return (((VendorBroker)this.GetBroker())).CheckRef(Code);
    }
}
