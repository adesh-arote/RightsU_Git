using System;
using System.Data;
using System.Configuration;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Web.UI.HtmlControls;
using System.Collections;
using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for ExtendedColumns
/// </summary>
public class ExtendedColumnsBroker : DatabaseBroker
{
	public ExtendedColumnsBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Extended_Columns] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ExtendedColumns objExtendedColumns;
		if (obj == null)
		{
			objExtendedColumns = new ExtendedColumns();
		}
		else
		{
			objExtendedColumns = (ExtendedColumns)obj;
		}

		objExtendedColumns.IntCode = Convert.ToInt32(dRow["Columns_Code"]);
		#region --populate--
		objExtendedColumns.ColumnsName = Convert.ToString(dRow["Columns_Name"]);
		objExtendedColumns.ControlType = Convert.ToString(dRow["Control_Type"]);
		objExtendedColumns.IsRef = Convert.ToString(dRow["Is_Ref"]);
		objExtendedColumns.IsDefinedValues = Convert.ToString(dRow["Is_Defined_Values"]);
		objExtendedColumns.IsMultipleSelect = Convert.ToString(dRow["Is_Multiple_Select"]);
		objExtendedColumns.RefTable = Convert.ToString(dRow["Ref_Table"]);
		objExtendedColumns.RefDisplayField = Convert.ToString(dRow["Ref_Display_Field"]);
		objExtendedColumns.RefValueField = Convert.ToString(dRow["Ref_Value_Field"]);
		objExtendedColumns.AdditionalCondition = Convert.ToString(dRow["Additional_Condition"]);
		#endregion
		return objExtendedColumns;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		ExtendedColumns objExtendedColumns = (ExtendedColumns)obj;
		string sql= "insert into [Extended_Columns]([Columns_Name], [Control_Type], [Is_Ref] "
				+ ", [Is_Defined_Values], [Is_Multiple_Select], [Ref_Table] "
				+ ", [Ref_Display_Field], [Ref_Value_Field], [Additional_Condition] "
				+ ")  values "
				+ "('" + objExtendedColumns.ColumnsName.Trim().Replace("'", "''") + "', '" + objExtendedColumns.ControlType.Trim().Replace("'", "''") + "', '" + objExtendedColumns.IsRef.Trim().Replace("'", "''") + "' "
				+ ", '" + objExtendedColumns.IsDefinedValues.Trim().Replace("'", "''") + "', '" + objExtendedColumns.IsMultipleSelect.Trim().Replace("'", "''") + "', '" + objExtendedColumns.RefTable.Trim().Replace("'", "''") + "' "
				+ ", '" + objExtendedColumns.RefDisplayField.Trim().Replace("'", "''") + "', '" + objExtendedColumns.RefValueField.Trim().Replace("'", "''") + "', '" + objExtendedColumns.AdditionalCondition.Trim().Replace("'", "''") + "' "
				+ ")";
		return  sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		ExtendedColumns objExtendedColumns = (ExtendedColumns)obj;
		string sql="update [Extended_Columns] set [Columns_Name] = '" + objExtendedColumns.ColumnsName.Trim().Replace("'", "''") + "' "
				+ ", [Control_Type] = '" + objExtendedColumns.ControlType.Trim().Replace("'", "''") + "' "
				+ ", [Is_Ref] = '" + objExtendedColumns.IsRef.Trim().Replace("'", "''") + "' "
				+ ", [Is_Defined_Values] = '" + objExtendedColumns.IsDefinedValues.Trim().Replace("'", "''") + "' "
				+ ", [Is_Multiple_Select] = '" + objExtendedColumns.IsMultipleSelect.Trim().Replace("'", "''") + "' "
				+ ", [Ref_Table] = '" + objExtendedColumns.RefTable.Trim().Replace("'", "''") + "' "
				+ ", [Ref_Display_Field] = '" + objExtendedColumns.RefDisplayField.Trim().Replace("'", "''") + "' "
				+ ", [Ref_Value_Field] = '" + objExtendedColumns.RefValueField.Trim().Replace("'", "''") + "' "
				+ ", [Additional_Condition] = '" + objExtendedColumns.AdditionalCondition.Trim().Replace("'", "''") + "' "
				+ " where Columns_Code = '" + objExtendedColumns.IntCode + "'";
		return  sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		ExtendedColumns objExtendedColumns = (ExtendedColumns)obj;

		string sql= " DELETE FROM [Extended_Columns] WHERE Columns_Code = " + obj.IntCode ;
		return  sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        ExtendedColumns objExtendedColumns = (ExtendedColumns)obj;
		string sql= "Update [Extended_Columns] set lock_time=null, "
					+ " last_updated_time= getdate() where Columns_Code = '" + objExtendedColumns.IntCode + "'";
		return  sql;
    }

    public override string GetCountSql(string strSearchString)
    {
		string sql= " SELECT Count(*) FROM [Extended_Columns] WHERE 1=1 " + strSearchString;
		return  sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		string sql= " SELECT * FROM [Extended_Columns] WHERE  Columns_Code = " + obj.IntCode;
		return  sql;
    }  
}
