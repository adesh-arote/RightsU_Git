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
/// Summary description for Format
/// </summary>
public class FormatBroker : DatabaseBroker
{
    public FormatBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Format] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Format objFormat;
        if (obj == null)
        {
            objFormat = new Format();
        }
        else
        {
            objFormat = (Format)obj;
        }

        objFormat.IntCode = Convert.ToInt32(dRow["Format_Code"]);
        #region --populate--
        objFormat.FormatName = Convert.ToString(dRow["Format_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objFormat.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objFormat.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objFormat.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objFormat.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objFormat.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objFormat.Is_Active = Convert.ToString(dRow["Is_Active"]);

        objFormat.IsRefExists = getIsRefExists(objFormat.FormatName).Trim();
        #endregion
        return objFormat;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Format objFormat = (Format)obj;
        return DBUtil.IsDuplicateSqlTrans(ref obj, objFormat.tableName, "Format_Name", objFormat.FormatName, objFormat.pkColName, objFormat.IntCode, "Record already exist", "", true);
    }

    public override string GetInsertSql(Persistent obj)
    {
        Format objFormat = (Format)obj;
        return "insert into [Format]([Format_Name], [Inserted_On], [Inserted_By], [Is_Active]) values('" + objFormat.FormatName.Trim().Replace("'", "''") + "', getDate() , '" + objFormat.InsertedBy + "', 'Y');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Format objFormat = (Format)obj;
        return "update [Format] set [Format_Name] = '" + objFormat.FormatName.Trim().Replace("'", "''") + "',  [Lock_Time] = null, [Last_Updated_Time] = getDate() , [Last_Action_By] = '" + objFormat.LastActionBy + "' where Format_Code = '" + objFormat.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Format objFormat = (Format)obj;
        return "DELETE FROM [Format] WHERE Format_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Format objFormat = (Format)obj;
        return "Update [Format] set Is_Active='" + objFormat.Is_Active + "',lock_time=null, last_updated_time= getdate() where Format_Code = '" + objFormat.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Format] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Format] WHERE  Format_Code = " + obj.IntCode;
    }

    //Get Platform_codes which ref exists in deal.
    internal string GetPlatform_RefExists(int FormatCode)
    {
        string PltformCodes = string.Empty;
        string strSql = " SELECT dbo.[fn_GetPlatform_RefExists] (" + FormatCode + ") AS PlatformCodes ";
        PltformCodes = ProcessScalarReturnString(strSql);

        return PltformCodes;

    }

    //Check is reference exists in Monthly_Sales_Royalty
    private string getIsRefExists(string FormatName)
    {
        string IsRef = YesNo.N.ToString();
        string strSql = " SELECT COUNT(*) FROM External_Title WHERE MasterFormat = '" + FormatName + "' ";
        int IsRefCnt = ProcessScalarDirectly(strSql);

        if (IsRefCnt > 0)
        {
            IsRef = YesNo.Y.ToString();
        }

        return IsRef;
    }
}
