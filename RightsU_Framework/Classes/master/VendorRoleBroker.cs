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
/// Summary description for VendorRole
/// </summary>
public class VendorRoleBroker : DatabaseBroker
{
    public VendorRoleBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [vendor_role] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        VendorRole objVendorRole;
        if (obj == null)
        {
            objVendorRole = new VendorRole();
        }
        else
        {
            objVendorRole = (VendorRole)obj;
        }

        objVendorRole.IntCode = Convert.ToInt32(dRow["vendor_role_code"]);
        #region --populate--
        if (dRow["Vendor_Code"] != DBNull.Value)
            objVendorRole.VendorCode = Convert.ToInt32(dRow["Vendor_Code"]);
        if (dRow["role_code"] != DBNull.Value)
            objVendorRole.RoleCode = Convert.ToInt32(dRow["role_code"]);
        objVendorRole.IsActive = Convert.ToChar(dRow["is_active"]);
        #endregion
        return objVendorRole;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        VendorRole objVendorRole = (VendorRole)obj;
        return "insert into [vendor_role]([Vendor_Code], [role_code], "
            + " [is_active]) values('" + objVendorRole.VendorCode + "', "
            + " '" + objVendorRole.RoleCode + "', "
            + " 'Y');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        VendorRole objVendorRole = (VendorRole)obj;
        return "update [vendor_role] set [Vendor_Code] = '" + objVendorRole.VendorCode + "', [role_code] = '" + objVendorRole.RoleCode + "', [is_active] = '" + objVendorRole.IsActive + "' where vendor_role_code = '" + objVendorRole.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        VendorRole objVendorRole = (VendorRole)obj;
        //return " DELETE FROM [vendor_role] ";
        return " DELETE FROM [vendor_role] WHERE vendor_role_code = " + objVendorRole.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [vendor_role] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [vendor_role] WHERE  vendor_role_code = " + obj.IntCode;
    }
}
