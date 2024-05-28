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
/// Summary description for VendorDomesticTerritory
/// </summary>
public class VendorDomesticTerritoryBroker : DatabaseBroker
{
	public VendorDomesticTerritoryBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Vendor_Domestic_Territory] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        VendorDomesticTerritory objVendorDomesticTerritory;
		if (obj == null)
		{
			objVendorDomesticTerritory = new VendorDomesticTerritory();
		}
		else
		{
			objVendorDomesticTerritory = (VendorDomesticTerritory)obj;
		}

		objVendorDomesticTerritory.IntCode = Convert.ToInt32(dRow["Vendor_Domestic_Territory_Code"]);
		#region --populate--
		if (dRow["Vendor_Code"] != DBNull.Value)
			objVendorDomesticTerritory.VendorCode = Convert.ToInt32(dRow["Vendor_Code"]);
		if (dRow["Territory_Code"] != DBNull.Value)
			objVendorDomesticTerritory.TerritoryCode = Convert.ToInt32(dRow["Territory_Code"]);
		#endregion
		return objVendorDomesticTerritory;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		VendorDomesticTerritory objVendorDomesticTerritory = (VendorDomesticTerritory)obj;
		return "insert into [Vendor_Domestic_Territory]([Vendor_Code], [Territory_Code]) values('" + objVendorDomesticTerritory.VendorCode + "', '" + objVendorDomesticTerritory.TerritoryCode + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		VendorDomesticTerritory objVendorDomesticTerritory = (VendorDomesticTerritory)obj;
		return "update [Vendor_Domestic_Territory] set [Vendor_Code] = '" + objVendorDomesticTerritory.VendorCode + "', [Territory_Code] = '" + objVendorDomesticTerritory.TerritoryCode + "' where Vendor_Domestic_Territory_Code = '" + objVendorDomesticTerritory.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		VendorDomesticTerritory objVendorDomesticTerritory = (VendorDomesticTerritory)obj;

		return " DELETE FROM [Vendor_Domestic_Territory] WHERE Vendor_Domestic_Territory_Code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        VendorDomesticTerritory objVendorDomesticTerritory = (VendorDomesticTerritory)obj;
return "Update [Vendor_Domestic_Territory] set Is_Active='" + objVendorDomesticTerritory.Is_Active + "',lock_time=null, last_updated_time= getdate() where Vendor_Domestic_Territory_Code = '" + objVendorDomesticTerritory.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [Vendor_Domestic_Territory] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [Vendor_Domestic_Territory] WHERE  Vendor_Domestic_Territory_Code = " + obj.IntCode;
    }  
}
