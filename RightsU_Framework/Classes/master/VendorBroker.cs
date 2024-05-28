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
using System.Data.SqlClient;

/// <summary>
/// Summary description for Vendor
/// </summary>
public class VendorBroker : DatabaseBroker
{
    public VendorBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Vendor] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Vendor objVendor;
        if (obj == null)
        {
            objVendor = new Vendor();
        }
        else
        {
            objVendor = (Vendor)obj;
        }

        objVendor.IntCode = Convert.ToInt32(dRow["Vendor_Code"]);
        #region --populate--
        objVendor.VendorName = Convert.ToString(dRow["Vendor_Name"]);
        objVendor.Address = Convert.ToString(dRow["Address"]);
        objVendor.PhoneNo = Convert.ToString(dRow["Phone_No"]);
        objVendor.FaxNo = Convert.ToString(dRow["Fax_No"]);
        objVendor.STNo = Convert.ToString(dRow["ST_No"]);
        objVendor.VATNo = Convert.ToString(dRow["VAT_No"]);
        objVendor.TINNo = Convert.ToString(dRow["TIN_No"]);
        objVendor.PANNo = Convert.ToString(dRow["PAN_No"]);
        objVendor.CSTNo = Convert.ToString(dRow["CST_No"]);
        //objVendor.Type = Convert.ToChar(dRow["Type"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objVendor.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objVendor.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objVendor.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objVendor.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objVendor.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objVendor.Is_Active = Convert.ToString(dRow["Is_Active"]);

        if (objVendor.IntCode > 0)
            objVendor.VendorRoles = getVendorRoles(objVendor.IntCode);
        #endregion
        return objVendor;
    }

    private string getVendorRoles(int VendorCode)
    {
        string StrvendorRole = "";
        string strSql = "";
        strSql = "select dbo.[UFN_Get_Vendor_Roles](" + VendorCode + ") ";
        DataSet ds = new DataSet();
        ds = ProcessSelect(strSql);
        if (ds.Tables[0].Rows.Count > 0)
            StrvendorRole = ds.Tables[0].Rows[0][0].ToString();
        return StrvendorRole;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Vendor objVendor = (Vendor)obj;
        if (objVendor.SqlTrans != null)
            return DBUtil.IsDuplicateSqlTrans(ref obj, "Vendor", "Vendor_name", ((Vendor)obj).VendorName, "Vendor_code", ((Vendor)obj).IntCode, "Company name already exists.", "", true);
        else
            return DBUtil.IsDuplicate(myConnection, "Vendor", "Vendor_name", ((Vendor)obj).VendorName, "Vendor_code", ((Vendor)obj).IntCode, "Company name already exists.", "", true);

    }

    public override string GetInsertSql(Persistent obj)
    {
        Vendor objVendor = (Vendor)obj;
        return "insert into [Vendor]([Vendor_Name], [Address], [Phone_No], [Fax_No], [ST_No], [VAT_No], "
            + " [TIN_No], [PAN_No],[CST_No],[Inserted_On], [Inserted_By],  [Last_Updated_Time], [Last_Action_By],"
            + " [Is_Active]) values(N'" + objVendor.VendorName.Trim().Replace("'", "''") + "', "
            + " N'" + objVendor.Address.Trim().Replace("'", "''") + "', "
            + " '" + objVendor.PhoneNo.Trim().Replace("'", "''") + "', "
            + " '" + objVendor.FaxNo.Trim().Replace("'", "''") + "', "
            + " '" + objVendor.STNo.Trim().Replace("'", "''") + "',"
            + " '" + objVendor.VATNo.Trim().Replace("'", "''") + "',"
            + " '" + objVendor.TINNo.Trim().Replace("'", "''") + "',"
            + " '" + objVendor.PANNo.Trim().Replace("'", "''") + "', "
            + " '" + objVendor.CSTNo.Trim().Replace("'", "''") + "', "
            + " getdate(), "
            + " '" + objVendor.InsertedBy + "', "
            //+ " '" + objVendor.LockTime + "', "
            + " getdate(),"
            + " '" + objVendor.LastActionBy + "', "
            + " 'Y');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Vendor objVendor = (Vendor)obj;
        return "update [Vendor] set [Vendor_Name] = N'" + objVendor.VendorName.Trim().Replace("'", "''")
               + "', [Address] = N'" + objVendor.Address.Trim().Replace("'", "''")
               + "', [Phone_No] = '" + objVendor.PhoneNo.Trim().Replace("'", "''")
               + "', [Fax_No] = '" + objVendor.FaxNo.Trim().Replace("'", "''")
               + "', [ST_No] = '" + objVendor.STNo.Trim().Replace("'", "''")
               + "', [VAT_No] = '" + objVendor.VATNo.Trim().Replace("'", "''")
               + "', [TIN_No] = '" + objVendor.TINNo.Trim().Replace("'", "''")
               + "', [PAN_No] = '" + objVendor.PANNo.Trim().Replace("'", "''")
               + "', [CST_No] = '" + objVendor.CSTNo.Trim().Replace("'", "''")
               + "', [Lock_Time] = null, [Last_Updated_Time] = getDate(), [Last_Action_By] = '" + objVendor.LastActionBy
               + "', [Is_Active] = '" + objVendor.Is_Active
               + "' where Vendor_Code = '" + objVendor.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        Vendor objVendor = (Vendor)obj;
        strMessage = "";

        bool isRefTitle = DBUtil.HasRecords(myConnection, "title", "producer_code", objVendor.IntCode.ToString());
        if (isRefTitle)
        {
            strMessage = "Cannot Deactivate : Company references exist";
            return false;
        }
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Vendor objVendor = (Vendor)obj;
        //string sql = " update [Vendor] set is_Active='" + objVendor.Is_Active + "' where Vendor_Code=" + objVendor.IntCode;
        ////return sql;
        if (objVendor.ArrRole.Count > 0)
            DBUtil.DeleteChild("vendor_role", objVendor.ArrRole, objVendor.IntCode, (SqlTransaction)objVendor.SqlTrans);

        return "";

        //return " DELETE FROM [Vendor] WHERE Vendor_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Vendor objVendor = (Vendor)obj;
        return "Update [Vendor] set Is_Active='" + objVendor.Is_Active + "',lock_time=null, last_updated_time= getdate() where Vendor_Code = " + objVendor.IntCode;
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Vendor] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Vendor] WHERE  Vendor_Code = " + obj.IntCode;
    }

    internal bool IsVendorExist(string VendorName, int Code)
    {
        string strSql = "Select count(*) from vendor where vendor_name= N'" + VendorName.Trim().Replace("'", "''") + "' and Vendor_Code not in('" + Code + "')";
        int Count = Convert.ToInt32(ProcessScalar(strSql));
        if (Count > 0)
        {
            return true;
        }
        return false;
    }
    internal bool CheckRef(int Code)
    {
        string sql = "";
        //sql = "select count(*) from title where producer_code=" + Code;
        //int Count = Convert.ToInt32(ProcessScalar(sql));
        //if (Count > 0)
        //{
        //    return true;
        //}
        return false;

    }


}
