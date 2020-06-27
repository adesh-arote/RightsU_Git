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
/// Summary description for VendorCountry
/// </summary>
public class VendorCountryBroker : DatabaseBroker
{
    public VendorCountryBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Vendor_Country] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        VendorCountry objVendorCountry;
        if (obj == null)
        {
            objVendorCountry = new VendorCountry();
        }
        else
        {
            objVendorCountry = (VendorCountry)obj;
        }

        objVendorCountry.IntCode = Convert.ToInt32(dRow["Vendor_Country_Code"]);
        #region --populate--
        if (dRow["Vendor_Code"] != DBNull.Value)
            objVendorCountry.VendorCode = Convert.ToInt32(dRow["Vendor_Code"]);
        if (dRow["Country_Code"] != DBNull.Value)
            objVendorCountry.CountryCode = Convert.ToInt32(dRow["Country_Code"]);
        #endregion
        return objVendorCountry;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        VendorCountry objVendorCountry = (VendorCountry)obj;
        return "insert into [Vendor_Country]([Vendor_Code], [Country_Code],[Is_Theatrical]) values('" + objVendorCountry.VendorCode + "', '" + objVendorCountry.CountryCode + "','"+objVendorCountry.Is_Thetrical+"');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        VendorCountry objVendorCountry = (VendorCountry)obj;
        return "update [Vendor_Country] set [Vendor_Code] = '" + objVendorCountry.VendorCode + "', [Country_Code] = '" + objVendorCountry.CountryCode + "', [Is_Theatrical]='" + objVendorCountry.Is_Thetrical + "' where Vendor_Country_Code = '" + objVendorCountry.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        VendorCountry objVendorCountry = (VendorCountry)obj;

        return " DELETE FROM [Vendor_Country] WHERE Vendor_Country_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        VendorCountry objVendorCountry = (VendorCountry)obj;
        return "Update [Vendor_Country] set Is_Active='" + objVendorCountry.Is_Active + "',lock_time=null, last_updated_time= getdate() where Vendor_Country_Code = '" + objVendorCountry.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Vendor_Country] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Vendor_Country] WHERE  Vendor_Country_Code = " + obj.IntCode;
    }
}
