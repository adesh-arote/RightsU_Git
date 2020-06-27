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
/// Summary description for MaterialMedium
/// </summary>
public class MaterialMediumBroker : DatabaseBroker
{
    public MaterialMediumBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Material_Medium] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MaterialMedium objMaterialMedium;
        if (obj == null)
        {
            objMaterialMedium = new MaterialMedium();
        }
        else
        {
            objMaterialMedium = (MaterialMedium)obj;
        }

        objMaterialMedium.IntCode = Convert.ToInt32(dRow["Material_Medium_Code"]);
        #region --populate--
        objMaterialMedium.MaterialMediumName = Convert.ToString(dRow["Material_Medium_Name"]);
        if (dRow["Type"] != DBNull.Value)
            objMaterialMedium.Type = Convert.ToString(dRow["Type"]);
        if (dRow["Duration"] != DBNull.Value)
            objMaterialMedium.Duration = Convert.ToInt32(dRow["Duration"]);
        objMaterialMedium.IsQcRequired = Convert.ToString(dRow["Is_Qc_Required"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objMaterialMedium.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objMaterialMedium.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objMaterialMedium.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objMaterialMedium.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objMaterialMedium.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objMaterialMedium.Is_Active = Convert.ToString(dRow["Is_Active"]);
        #endregion
        return objMaterialMedium;
    }


    public override bool CheckDuplicate(Persistent obj)
    {
		MaterialMedium objMaterialMedium = (MaterialMedium)obj;
		return DBUtil.IsDuplicate(myConnection, objMaterialMedium.tableName, "Material_Medium_Name", objMaterialMedium.MaterialMediumName,objMaterialMedium.pkColName,objMaterialMedium.IntCode, "Record already exist", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        MaterialMedium objMaterialMedium = (MaterialMedium)obj;
		string str="insert into [Material_Medium]([Material_Medium_Name], [Type], [Duration], [Is_Qc_Required], [Inserted_On], [Inserted_By], [Is_Active]) values(N'" + objMaterialMedium.MaterialMediumName.Trim().Replace("'", "''") + "', " + objMaterialMedium.Type + ", " + objMaterialMedium.Duration + ", '" + objMaterialMedium.IsQcRequired + "', getDate(),'" + objMaterialMedium.InsertedBy + "','Y');";
		return str;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        MaterialMedium objMaterialMedium = (MaterialMedium)obj;
		string str="update [Material_Medium] set [Material_Medium_Name] = N'" + objMaterialMedium.MaterialMediumName.Trim().Replace("'", "''") + "', [Type] = " + objMaterialMedium.Type + ", [Duration] = '" + objMaterialMedium.Duration + "', [Is_Qc_Required] = '" + objMaterialMedium.IsQcRequired + "', [Lock_Time] = null, [Last_Updated_Time] = getDate(), [Last_Action_By] = '" + objMaterialMedium.LastActionBy + "' where Material_Medium_Code = '" + objMaterialMedium.IntCode + "';";
		return str;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        MaterialMedium objMaterialMedium = (MaterialMedium)obj;

        return " DELETE FROM [Material_Medium] WHERE Material_Medium_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
		MaterialMedium objMaterialMedium = (MaterialMedium)obj;
		return "Update [Material_Medium] set Is_Active='" + objMaterialMedium.Is_Active + "',lock_time=null, last_updated_time= getdate() where Material_Medium_Code = '" + objMaterialMedium.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Material_Medium] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Material_Medium] WHERE  Material_Medium_Code = " + obj.IntCode;
    }
}
