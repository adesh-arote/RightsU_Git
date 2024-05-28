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

public class ExtendedColumnsValueBroker : DatabaseBroker
{
    public ExtendedColumnsValueBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Extended_Columns_Value] where 1=1 " + strSearchString;
        
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        
        return objCriteria.getPagingSQL(sqlStr);
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ExtendedColumnsValue objExtendedColumnsValue;

        if (obj == null)
            objExtendedColumnsValue = new ExtendedColumnsValue();
        else
            objExtendedColumnsValue = (ExtendedColumnsValue)obj;

        objExtendedColumnsValue.IntCode = Convert.ToInt32(dRow["Columns_Value_Code"]);
        #region --populate--
        if (dRow["Columns_Code"] != DBNull.Value)
            objExtendedColumnsValue.ColumnsCode = Convert.ToInt32(dRow["Columns_Code"]);
        objExtendedColumnsValue.ColumnsValue = Convert.ToString(dRow["Columns_Value"]);
        #endregion
        return objExtendedColumnsValue;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        ExtendedColumnsValue objExtendedColumnsValue = (ExtendedColumnsValue)obj;
        string sql = "insert into [Extended_Columns_Value]([Columns_Code], [Columns_Value])  values "
                + "('" + objExtendedColumnsValue.ColumnsCode + "', '" + objExtendedColumnsValue.ColumnsValue.Trim().Replace("'", "''") + "')";
        return sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        ExtendedColumnsValue objExtendedColumnsValue = (ExtendedColumnsValue)obj;
        string sql = "update [Extended_Columns_Value] set [Columns_Code] = '" + objExtendedColumnsValue.ColumnsCode + "' "
                + ", [Columns_Value] = '" + objExtendedColumnsValue.ColumnsValue.Trim().Replace("'", "''") + "' "
                + " where Columns_Value_Code = '" + objExtendedColumnsValue.IntCode + "'";
        return sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        ExtendedColumnsValue objExtendedColumnsValue = (ExtendedColumnsValue)obj;

        string sql = " DELETE FROM [Extended_Columns_Value] WHERE Columns_Value_Code = " + obj.IntCode;
        return sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        ExtendedColumnsValue objExtendedColumnsValue = (ExtendedColumnsValue)obj;
        string sql = "Update [Extended_Columns_Value] set lock_time=null, "
                    + " last_updated_time= getdate() where Columns_Value_Code = '" + objExtendedColumnsValue.IntCode + "'";
        return sql;
    }

    public override string GetCountSql(string strSearchString)
    {
        string sql = " SELECT Count(*) FROM [Extended_Columns_Value] WHERE 1=1 " + strSearchString;
        return sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        string sql = " SELECT * FROM [Extended_Columns_Value] WHERE  Columns_Value_Code = " + obj.IntCode;
        return sql;
    }
}
