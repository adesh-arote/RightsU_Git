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
/// Summary description for VendorContacts`
/// </summary>
public class VendorContactsBroker : DatabaseBroker
{
    public VendorContactsBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Vendor_Contacts] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        VendorContacts objVendorContacts;
        if (obj == null)
        {
            objVendorContacts = new VendorContacts();
        }
        else
        {
            objVendorContacts = (VendorContacts)obj;
        }

        objVendorContacts.IntCode = Convert.ToInt32(dRow["Vendor_Contacts_Code"]);
        #region --populate--
        if (dRow["Vendor_Code"] != DBNull.Value)
            objVendorContacts.VendorCode = Convert.ToInt32(dRow["Vendor_Code"]);
        objVendorContacts.ContactName = Convert.ToString(dRow["Contact_Name"]);
        objVendorContacts.PhoneNo = Convert.ToString(dRow["Phone_No"]);
        objVendorContacts.Email = Convert.ToString(dRow["Email"]);
        objVendorContacts.Department = Convert.ToString(dRow["Department"]);
        #endregion
        return objVendorContacts;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        VendorContacts objVendorContacts = (VendorContacts)obj;
        return "insert into [Vendor_Contacts]([Vendor_Code], [Contact_Name], [Phone_No], [Email], [Department]) values('" + objVendorContacts.VendorCode + "', N'" + objVendorContacts.ContactName.Trim().Replace("'", "''") + "', '" + objVendorContacts.PhoneNo.Trim().Replace("'", "''") + "', N'" + objVendorContacts.Email.Trim().Replace("'", "''") + "', N'" + objVendorContacts.Department.Trim().Replace("'", "''") + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        VendorContacts objVendorContacts = (VendorContacts)obj;
        return "update [Vendor_Contacts] set [Vendor_Code] = '" + objVendorContacts.VendorCode + "', [Contact_Name] = N'" + objVendorContacts.ContactName.Trim().Replace("'", "''") + "', [Phone_No] = '" + objVendorContacts.PhoneNo.Trim().Replace("'", "''") + "', [Email] = N'" + objVendorContacts.Email.Trim().Replace("'", "''") + "', [Department] = N'" + objVendorContacts.Department.Trim().Replace("'", "''") + "' where Vendor_Contacts_Code = '" + objVendorContacts.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        VendorContacts objVendorContacts = (VendorContacts)obj;

        return " DELETE FROM [Vendor_Contacts] WHERE Vendor_Contacts_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Vendor_Contacts] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Vendor_Contacts] WHERE  Vendor_Contacts_Code = " + obj.IntCode;
    }

}
