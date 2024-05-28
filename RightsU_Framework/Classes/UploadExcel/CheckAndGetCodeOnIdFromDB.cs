using System;
using System.Data.SqlClient;
using UTOFrameWork.FrameworkClasses;
using System.Data;
/// <summary>
/// Summary description for CheckAndGetCodeOnIdFromDB.
/// </summary>
public class CheckAndGetCodeOnIdFromDB : DatabaseBroker
{
    public CheckAndGetCodeOnIdFromDB()
    {
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        return "";
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        return  null;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return false;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return true;
    }
    public override bool Equals(object obj)
    {
        return base.Equals(obj);
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        return "";
    }

    public override string GetCountSql(string strSearchString)
    {
        return "";
    }
    public override string GetDeleteSql(Persistent obj)
    {
        return "";
    }

    public override int GetHashCode()
    {
        return base.GetHashCode();
    }
    public override string GetInsertSql(Persistent obj)
    {
        return "";
    }
    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "";
    }
    public override string GetUpdateSql(Persistent obj)
    {
        return "";
    }

    #region Method Code
    /// <summary>
    /// It creates ==> select [dbTableCodeColumnNameToBeSelected] from [dbTableName] where [dbTableIDColumnNameForSearch]='[dbTableIDColumnNameValue]' [searchStringForSql]
    /// </summary>
    /// <param name="dbTableCodeColumnNameToBeSelected">Input variable: Table Column Name To Be Selected</param>
    /// <param name="dbTableName">Input variable: Table Name</param>
    /// <param name="dbTableIDColumnNameForSearch">Input variable: Table Column Name For Where Condition</param>
    /// <param name="dbTableIDColumnNameValue">Input variable: Table Column Name Value For Where Condition</param>
    /// <param name="searchStringForSql">Input variable: Search Criteria String</param>
    /// <returns>"dbTableCodeColumnNameToBeSelected" if the select statement produces value, else returns "-1"</returns>
    public static int getCodeForIDInputFromDataBaseTable(string dbTableCodeColumnNameToBeSelected, string dbTableName, string dbTableIDColumnNameForSearch, string dbTableIDColumnNameValue, string searchStringForSql)
    {
        string sql = "";
        sql = "select " + dbTableCodeColumnNameToBeSelected.Trim() + "  from  " + dbTableName.Trim() + " where " + dbTableIDColumnNameForSearch.Trim() + "='" + dbTableIDColumnNameValue.Trim().Replace("'", "''") + "' " + searchStringForSql;
        int codeToBeReturned = ProcessScalarDirectly(sql);
        if (codeToBeReturned < 1)
        {
            codeToBeReturned = -1;
        }
        return codeToBeReturned;
    }
    /// <summary>
    /// Method directly returns count as per select criteria.
    /// </summary>
    /// <param name="sqlStr">input "select count(1) ....." statement</param>
    /// <returns>record count</returns>
    public static int getCountForSelect(string sqlStr)
    {
        return (ProcessScalarDirectly(sqlStr));
    }
    #endregion
}
