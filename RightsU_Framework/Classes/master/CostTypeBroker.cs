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
/// Summary description for CostType
/// </summary>
public class CostTypeBroker : DatabaseBroker {
    public CostTypeBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Cost_Type] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        CostType objCostType;
        if (obj == null)
        {
            objCostType = new CostType();
        }
        else
        {
            objCostType = (CostType)obj;
        }

        objCostType.IntCode = Convert.ToInt32(dRow["Cost_Type_Code"]);
        #region --populate--
        objCostType.CostTypeName = Convert.ToString(dRow["Cost_Type_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objCostType.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objCostType.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objCostType.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objCostType.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objCostType.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objCostType.IsActive = Convert.ToChar(dRow["Is_Active"]);
        if (dRow["Is_system_generated"] != DBNull.Value)
            objCostType.IsSystemGenerated = Convert.ToChar(dRow["Is_system_generated"]);    
        #endregion
        return objCostType;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        CostType objCostType = (CostType)obj;
        return DBUtil.IsDuplicate(myConnection, "Cost_Type", "Cost_Type_Name", objCostType.CostTypeName, "Cost_Type_Code", objCostType.IntCode, "Cost Type Name already exists", "");
    }    
 
    public override string GetInsertSql(Persistent obj)
    {
        CostType objCostType = (CostType)obj;
        return "insert into [Cost_Type]([Cost_Type_Name], [Inserted_On], [Inserted_By], [Lock_Time], [Last_Updated_Time], [Last_Action_By], [Is_Active]) values(N'"
                + objCostType.CostTypeName.Trim().Replace("'", "''") + "', getDate(), '" + objCostType.InsertedBy + "', null, getDate(), '" + objCostType.InsertedBy + "', 'Y');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        CostType objCostType = (CostType)obj;
        return "update [Cost_Type] set [Cost_Type_Name] = N'" + objCostType.CostTypeName.Trim().Replace("'", "''") + "', [Lock_Time] = null, [Last_Updated_Time] = getDate(), [Last_Action_By] = '" + objCostType.LastActionBy + "', [Is_Active] = '" + objCostType.IsActive + "' where Cost_Type_Code = '" + objCostType.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        CostType objCostType = (CostType)obj;

        return " DELETE FROM [Cost_Type] WHERE Cost_Type_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        CostType objCostType = (CostType)obj;
        string sql = "Update Cost_Type set Is_Active='" + objCostType.IsActive + "',lock_time=null, last_updated_time= getdate() where Cost_Type_Code = '" + objCostType.IntCode + "'";
        return sql; 
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Cost_Type] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
		CostType objCostType = (CostType)obj;
		return " SELECT * FROM [Cost_Type] WHERE  Cost_Type_Code = " + objCostType.IntCode;
    }
}
