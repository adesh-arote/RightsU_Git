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
/// Summary description for Language
/// </summary>
public class LanguageBroker : DatabaseBroker {
    public LanguageBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Language] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    
    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Language objLanguage;
        if (obj == null)
        {
            objLanguage = new Language();
        }
        else
        {
            objLanguage = (Language)obj;
        }

        objLanguage.IntCode = Convert.ToInt32(dRow["Language_Code"]);
        #region --populate--
        objLanguage.LanguageName = Convert.ToString(dRow["Language_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objLanguage.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objLanguage.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objLanguage.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objLanguage.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objLanguage.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objLanguage.IsActive = Convert.ToString(dRow["Is_Active"]);
        if (objLanguage != null && objLanguage.IntCode > 0)
            objLanguage.IsRef = CheckRef(objLanguage.IntCode);
        #endregion
        return objLanguage;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Language objLanguage = (Language)obj;
        return DBUtil.IsDuplicate(myConnection, "Language", "Language_Name", objLanguage.LanguageName, "Language_Code", objLanguage.IntCode , "Language Name already exists", "");
    }    
    

    public override string GetInsertSql(Persistent obj)
    {
        Language objLanguage = (Language)obj;
        return "insert into [Language]([Language_Name], [Inserted_On], [Inserted_By], [Lock_Time], [Last_Updated_Time], [Last_Action_By], [Is_Active]) values(N'" + objLanguage.LanguageName.Trim().Replace("'", "''") + "', '" + objLanguage.InsertedOn + "', '" + objLanguage.InsertedBy + "', null, '" + objLanguage.LastUpdatedTime + "', '" + objLanguage.LastActionBy + "', 'Y');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Language objLanguage = (Language)obj;
        return "update [Language] set [Language_Name] = N'" + objLanguage.LanguageName.Trim().Replace("'", "''") + "', [Lock_Time] = null, [Last_Updated_Time] = getDate(), [Last_Action_By] = '" + objLanguage.LastActionBy + "', [Is_Active] = '" + objLanguage.IsActive + "' where Language_Code = '" + objLanguage.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Language objLanguage = (Language)obj;

        return " DELETE FROM [Language] WHERE Language_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Language objLanguage = (Language)obj;
        string sql = "Update Language set Is_Active='" + objLanguage.IsActive + "',lock_time=null, last_updated_time= getdate() where Language_Code = '" + objLanguage.IntCode + "'";
        return sql; 
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Language] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Language] WHERE  Language_Code = " + obj.IntCode;
    }

    private string CheckRef(int Lang_Code)
    {
        string sql = "SELECT dbo.UFN_Check_Ref_Language(" + Lang_Code + ",'L') AS Is_Ref";
        sql = DatabaseBroker.ProcessScalarReturnString(sql);
        return sql;
    }
}
