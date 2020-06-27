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
/// Summary description for MapExtendedColumns
/// </summary>
public class MapExtendedColumnsBroker : DatabaseBroker
{
    public MapExtendedColumnsBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Map_Extended_Columns] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MapExtendedColumns objMapExtendedColumns;
        if (obj == null)
        {
            objMapExtendedColumns = new MapExtendedColumns();
        }
        else
        {
            objMapExtendedColumns = (MapExtendedColumns)obj;
        }

        objMapExtendedColumns.IntCode = Convert.ToInt32(dRow["Map_Extended_Columns_Code"]);
        #region --populate--
        if (dRow["Record_Code"] != DBNull.Value)
            objMapExtendedColumns.RecordCode = Convert.ToInt32(dRow["Record_Code"]);
        objMapExtendedColumns.TableName = Convert.ToString(dRow["Table_Name"]);
        if (dRow["Columns_Code"] != DBNull.Value)
            objMapExtendedColumns.ColumnsCode = Convert.ToInt32(dRow["Columns_Code"]);
        if (dRow["Columns_Value_Code"] != DBNull.Value)
            objMapExtendedColumns.ColumnsValueCode = Convert.ToInt32(dRow["Columns_Value_Code"]);
        if (dRow["Column_Value"] != DBNull.Value)
            objMapExtendedColumns.ColumnValue = Convert.ToString(dRow["Column_Value"]);
        if (dRow["Is_Multiple_Select"] != DBNull.Value)
            objMapExtendedColumns.IsMultipleSelect = Convert.ToString(dRow["Is_Multiple_Select"]);
        #endregion
        return objMapExtendedColumns;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        MapExtendedColumns objMapExtendedColumns = (MapExtendedColumns)obj;
        string strCVCode = "";
        if (objMapExtendedColumns.ColumnsValueCode <= 0)
            strCVCode = "null";
        else
            strCVCode = "'" + objMapExtendedColumns.ColumnsValueCode + "'";
        string sql = "insert into [Map_Extended_Columns]([Record_Code], [Table_Name], [Columns_Code] "
                + ", [Columns_Value_Code], [Column_Value], [Is_Multiple_Select] "
                + ")  values "
                + "('" + objMapExtendedColumns.RecordCode + "', '" + objMapExtendedColumns.TableName.Trim().Replace("'", "''") + "', '" + objMapExtendedColumns.ColumnsCode + "' "
                + ", " + strCVCode + ", '" + objMapExtendedColumns.ColumnValue.Trim().Replace("'", "''") + "', '" + objMapExtendedColumns.IsMultipleSelect.Trim().Replace("'", "''") + "' "
                + ")";
        return sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        MapExtendedColumns objMapExtendedColumns = (MapExtendedColumns)obj;
        string strCVCode = "";
        string whrcdnt = "";
        if (objMapExtendedColumns.ColumnsValueCode <= 0)
            whrcdnt = ", [Columns_Value_Code] = NULL ";
        else
            whrcdnt = ", [Columns_Value_Code] = '" + objMapExtendedColumns.ColumnsValueCode + "'";
        string sql = "update [Map_Extended_Columns] set [Record_Code] = '" + objMapExtendedColumns.RecordCode + "' "
                + ", [Table_Name] = '" + objMapExtendedColumns.TableName.Trim().Replace("'", "''") + "' "
                + ", [Columns_Code] = '" + objMapExtendedColumns.ColumnsCode + "' "
                + whrcdnt
                + ", [Column_Value] = '" + objMapExtendedColumns.ColumnValue.Trim().Replace("'", "''") + "' "
                + ", [Is_Multiple_Select] = '" + objMapExtendedColumns.IsMultipleSelect.Trim().Replace("'", "''") + "' "
                + " where Map_Extended_Columns_Code = '" + objMapExtendedColumns.IntCode + "'";
        return sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        MapExtendedColumns objMapExtendedColumns = (MapExtendedColumns)obj;
        if (objMapExtendedColumns.ArrMapExtendedColumnsDetails_del.Count > 0)
            DBUtil.DeleteChild("MapExtendedColumnsDetails", objMapExtendedColumns.ArrMapExtendedColumnsDetails_del, objMapExtendedColumns.IntCode, (SqlTransaction)objMapExtendedColumns.SqlTrans);
        string sql = " DELETE FROM [Map_Extended_Columns] WHERE Map_Extended_Columns_Code = " + obj.IntCode;
        return sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        MapExtendedColumns objMapExtendedColumns = (MapExtendedColumns)obj;
        string sql = "Update [Map_Extended_Columns] set lock_time=null, "
                    + " last_updated_time= getdate() where Map_Extended_Columns_Code = '" + objMapExtendedColumns.IntCode + "'";
        return sql;
    }

    public override string GetCountSql(string strSearchString)
    {
        string sql = " SELECT Count(*) FROM [Map_Extended_Columns] WHERE 1=1 " + strSearchString;
        return sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        string sql = " SELECT * FROM [Map_Extended_Columns] WHERE  Map_Extended_Columns_Code = " + obj.IntCode;
        return sql;
    }
}
