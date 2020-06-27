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
/// Summary description for MapExtendedColumnsDetails
/// </summary>
public class MapExtendedColumnsDetailsBroker : DatabaseBroker
{
	public MapExtendedColumnsDetailsBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Map_Extended_Columns_Details] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MapExtendedColumnsDetails objMapExtendedColumnsDetails;
		if (obj == null)
		{
			objMapExtendedColumnsDetails = new MapExtendedColumnsDetails();
		}
		else
		{
			objMapExtendedColumnsDetails = (MapExtendedColumnsDetails)obj;
		}

		objMapExtendedColumnsDetails.IntCode = Convert.ToInt32(dRow["Map_Extended_Columns_Details_Code"]);
		#region --populate--
		if (dRow["Map_Extended_Columns_Code"] != DBNull.Value)
			objMapExtendedColumnsDetails.MapExtendedColumnsCode = Convert.ToInt32(dRow["Map_Extended_Columns_Code"]);
		if (dRow["Columns_Value_Code"] != DBNull.Value)
			objMapExtendedColumnsDetails.ColumnsValueCode = Convert.ToInt32(dRow["Columns_Value_Code"]);
		#endregion
		return objMapExtendedColumnsDetails;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		MapExtendedColumnsDetails objMapExtendedColumnsDetails = (MapExtendedColumnsDetails)obj;
		string sql= "insert into [Map_Extended_Columns_Details]([Map_Extended_Columns_Code], [Columns_Value_Code])  values "
				+ "('" + objMapExtendedColumnsDetails.MapExtendedColumnsCode + "', '" + objMapExtendedColumnsDetails.ColumnsValueCode + "')";
		return  sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		MapExtendedColumnsDetails objMapExtendedColumnsDetails = (MapExtendedColumnsDetails)obj;
		string sql="update [Map_Extended_Columns_Details] set [Map_Extended_Columns_Code] = '" + objMapExtendedColumnsDetails.MapExtendedColumnsCode + "' "
				+ ", [Columns_Value_Code] = '" + objMapExtendedColumnsDetails.ColumnsValueCode + "' "
				+ " where Map_Extended_Columns_Details_Code = '" + objMapExtendedColumnsDetails.IntCode + "'";
		return  sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		MapExtendedColumnsDetails objMapExtendedColumnsDetails = (MapExtendedColumnsDetails)obj;

		string sql= " DELETE FROM [Map_Extended_Columns_Details] WHERE Map_Extended_Columns_Details_Code = " + obj.IntCode ;
		return  sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        MapExtendedColumnsDetails objMapExtendedColumnsDetails = (MapExtendedColumnsDetails)obj;
		string sql= "Update [Map_Extended_Columns_Details] set lock_time=null, "
					+ " last_updated_time= getdate() where Map_Extended_Columns_Details_Code = '" + objMapExtendedColumnsDetails.IntCode + "'";
		return  sql;
    }

    public override string GetCountSql(string strSearchString)
    {
		string sql= " SELECT Count(*) FROM [Map_Extended_Columns_Details] WHERE 1=1 " + strSearchString;
		return  sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		string sql= " SELECT * FROM [Map_Extended_Columns_Details] WHERE  Map_Extended_Columns_Details_Code = " + obj.IntCode;
		return  sql;
    }  
}
