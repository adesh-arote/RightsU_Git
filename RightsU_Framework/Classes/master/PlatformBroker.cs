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
/// Summary description for Platform
/// </summary>
public class PlatformBroker : DatabaseBroker
{
    public PlatformBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Platform] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Platform objPlatform;
        if (obj == null)
        {
            objPlatform = new Platform();
        }
        else
        {
            objPlatform = (Platform)obj;
        }

        objPlatform.IntCode = Convert.ToInt32(dRow["Platform_Code"]);
        #region --populate--
        objPlatform.PlatformName = Convert.ToString(dRow["Platform_Name"]);

        if (dRow["is_no_of_run"] != DBNull.Value)
            objPlatform.IsNoOfRun = Convert.ToChar(dRow["is_no_of_run"]);
        else
            objPlatform.IsNoOfRun = 'N';

        if (dRow["applicable_for_holdback"] != DBNull.Value)
            objPlatform.IsApplicableForHoldBack = Convert.ToChar(dRow["applicable_for_holdback"]);
        else
            objPlatform.IsApplicableForHoldBack = 'N';

        if (dRow["Inserted_On"] != DBNull.Value)
            objPlatform.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objPlatform.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objPlatform.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objPlatform.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objPlatform.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        if (dRow["Is_Active"] != DBNull.Value)
            if (dRow["Is_Active"].ToString() != "")
                objPlatform.Is_Active = Convert.ToString(dRow["Is_Active"]);
            else
                objPlatform.Is_Active = "Y";

        if (dRow["parent_platform_code"] != DBNull.Value)
            objPlatform.ParentPlatformCode = Convert.ToInt32(dRow["parent_platform_code"]);

        if (dRow["Is_Last_Level"] != DBNull.Value)
            objPlatform.IsLastLevel = Convert.ToString(dRow["Is_Last_Level"]);

        if (dRow["base_platform_code"] != DBNull.Value)
            objPlatform.base_platform_code = Convert.ToInt32(dRow["base_platform_code"]);

        if (dRow["module_Position"] != DBNull.Value)
            objPlatform.modulePosition = Convert.ToString(dRow["module_Position"]);

        if (dRow["Platform_Hiearachy"] != DBNull.Value)
            objPlatform.PlatformNameHierarchy = Convert.ToString(dRow["Platform_Hiearachy"]);

        // objPlatform.PlatformNameHierarchy = GetPlatformHirearchy(objPlatform.IntCode);
        #endregion
        return objPlatform;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Platform objPlatform = (Platform)obj;
        if (obj.IsDirty == true)
            return DBUtil.IsDuplicate(myConnection, objPlatform.tableName, "Platform_Name", objPlatform.PlatformName, objPlatform.pkColName, objPlatform.IntCode, "Record already exist", "");
        else
            return DBUtil.IsDuplicateSqlTrans(ref obj, objPlatform.tableName, "Platform_Name", objPlatform.PlatformName, objPlatform.pkColName, objPlatform.IntCode, "Record already exist", "", true);

    }

    public override string GetInsertSql(Persistent obj)
    {
        Platform objPlatform = (Platform)obj;
        string str = "insert into [Platform]([Platform_Name],[is_no_of_run],[applicable_for_holdback], [Inserted_On], [Inserted_By],[Is_Active][Platform_Hiearachy])" +
             "values('" + objPlatform.PlatformName.Trim().Replace("'", "''") + "','" + objPlatform.IsNoOfRun + "','" + objPlatform.IsApplicableForHoldBack + "',GetDate(), '" + objPlatform.InsertedBy + "','Y','" + objPlatform.PlatformNameHierarchy + "');";
        return str;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Platform objPlatform = (Platform)obj;
        return "update [Platform] set [Platform_Name] = '" + objPlatform.PlatformName.Trim().Replace("'", "''") + "',[is_no_of_run]='" + objPlatform.IsNoOfRun + "',[applicable_for_holdback]='" + objPlatform.IsApplicableForHoldBack + "', [Lock_Time] = Null, [Last_Updated_Time] = GetDate(), [Last_Action_By] = '" + objPlatform.LastActionBy + "',[Platform_Hiearachy] = '" + objPlatform.PlatformNameHierarchy + "' where Platform_Code = '" + objPlatform.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Platform objPlatform = (Platform)obj;
        return " DELETE FROM [Platform] WHERE Platform_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Platform objPlatform = (Platform)obj;
        return "Update [Platform] set Is_Active='" + objPlatform.Is_Active + "',lock_time=null, last_updated_time= getdate() where Platform_Code = '" + objPlatform.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Platform] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Platform] WHERE  Platform_Code = " + obj.IntCode;
    }

    public int insertPlatformRightsCategory(int platformCode, SqlTransaction sqlTran)
    {
        return ProcessNonQuery("exec usp_Insert_Platform_RightsCategory " + platformCode, false, sqlTran);
    }

    public string GetPlatformHirearchy(int ChildPlatformCode)
    {
        string result;
        string strSelect;
        strSelect = " select dbo.GetPlatformHierarchy (" + ChildPlatformCode + ")";
        result = DatabaseBroker.ProcessScalarReturnString(strSelect);
        return result;
    }

    public static string GetPlatformCodeHierarchy(string platformCode)
    {
        string strQuery = "select dbo.GetPlatformCodeHierarchy('" + platformCode + "')";
        return ProcessScalarReturnString(strQuery);
    }
}
