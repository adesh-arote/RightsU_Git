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
/// Summary description for MaterialType
/// </summary>
public class MaterialTypeBroker : DatabaseBroker {
    public MaterialTypeBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Material_Type] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MaterialType objMaterialType;
        if (obj == null)
        {
            objMaterialType = new MaterialType();
        }
        else
        {
            objMaterialType = (MaterialType)obj;
        }

        objMaterialType.IntCode = Convert.ToInt32(dRow["Material_Type_Code"]);
        #region --populate--
        if (dRow["Material_Type_Name"] != DBNull.Value)
            objMaterialType.MaterialTypeName = Convert.ToString(dRow["Material_Type_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objMaterialType.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objMaterialType.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objMaterialType.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objMaterialType.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objMaterialType.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objMaterialType.Is_Active = Convert.ToString(dRow["Is_Active"]);
        #endregion
        return objMaterialType;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		MaterialType objMaterialType = (MaterialType)obj;
		return DBUtil.IsDuplicate(myConnection, "Material_Type", "Material_Type_Name", objMaterialType.MaterialTypeName, objMaterialType.pkColName, objMaterialType.IntCode, "Record already exist","");
    }

    public override string GetInsertSql(Persistent obj)
    {
        MaterialType objMaterialType = (MaterialType)obj;
		return "insert into [Material_Type]([Material_Type_Name], [Inserted_On], [Inserted_By],[Is_Active]) values(N'" + objMaterialType.MaterialTypeName + "', getDate() , '" + objMaterialType.InsertedBy + "','Y')";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        MaterialType objMaterialType = (MaterialType)obj;
        return "update [Material_Type] set [Material_Type_Name] = N'" + objMaterialType.MaterialTypeName + "', [Lock_Time] = null, [Last_Updated_Time] = getDate(), [Last_Action_By] = '" + objMaterialType.LastActionBy + "' where Material_Type_Code = '" + objMaterialType.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        MaterialType objMaterialType = (MaterialType)obj;

        return " DELETE FROM [Material_Type] WHERE Material_Type_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
		MaterialType objMaterialType = (MaterialType)obj;
		return "Update [Material_Type] set Is_Active='" + objMaterialType.Is_Active +"',lock_time=null, last_updated_time= getdate() where Material_Type_Code = " + objMaterialType.IntCode;
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Material_Type] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Material_Type] WHERE  Material_Type_Code = " + obj.IntCode;
    }
}
