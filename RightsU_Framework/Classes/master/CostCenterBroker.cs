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
public class CostCenterBroker : DatabaseBroker
{
    public CostCenterBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [cost_center] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        CostCenter objCostCenter;
        if (obj == null)
        {
            objCostCenter = new CostCenter();
        }
        else
        {
            objCostCenter = (CostCenter)obj;
        }

        objCostCenter.IntCode = Convert.ToInt32(dRow["cost_center_id"]);
        #region --populate--

        if (dRow["cost_center_code"] != DBNull.Value)
            objCostCenter.Cost_Center_Code = Convert.ToString(dRow["cost_center_code"]);
        if (dRow["cost_center_name"] != DBNull.Value)
            objCostCenter.Cost_Center_Name = Convert.ToString(dRow["cost_center_name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objCostCenter.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objCostCenter.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objCostCenter.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objCostCenter.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objCostCenter.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);

        objCostCenter.Is_Active = Convert.ToString(dRow["Is_Active"]);
        #endregion
        return objCostCenter;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        CostCenter objCostCenter = (CostCenter)obj;
        return DBUtil.IsDuplicate(myConnection, "cost_center", "cost_center_code", objCostCenter.Cost_Center_Code, objCostCenter.pkColName, objCostCenter.IntCode, "record already exist", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        CostCenter objCostCenter = (CostCenter)obj;
        return "insert into [cost_center]([cost_center_code],[cost_center_name],[Inserted_On], [Inserted_By], [Lock_Time], [Last_Updated_Time], [Last_Action_By], [Is_Active] ) values('" + objCostCenter.Cost_Center_Code.Trim().Replace("'", "''") + "','" + objCostCenter.Cost_Center_Name.Trim().Replace("'", "''") + "', getDate() , '" + objCostCenter.InsertedBy + "',Null,GetDate(),'" + objCostCenter.InsertedBy + "','Y')";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        CostCenter objCostCenter = (CostCenter)obj;
         string strUpdate= "update [cost_center] set [cost_center_code]='" + objCostCenter.Cost_Center_Code.Trim().Replace("'", "''") + "',[cost_center_name] = '" + objCostCenter.Cost_Center_Name.Trim().Replace("'", "''") + "', [Lock_Time] = null, [Last_Updated_Time] = getDate(), [Last_Action_By] = '" + objCostCenter.LastUpdatedBy + "' where cost_center_id = '" + objCostCenter.IntCode + "';";
         return strUpdate;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        CostCenter objCostCenter = (CostCenter)obj;

        return " DELETE FROM [cost_center] WHERE cost_center_id = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        CostCenter objCostCenter = (CostCenter)obj;
        return "Update [cost_center] set Is_Active='" + objCostCenter.Is_Active + "',lock_time=null, last_updated_time= getdate() where cost_center_id = " + objCostCenter.IntCode;
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [cost_center] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [cost_center] WHERE  cost_center_id = " + obj.IntCode;
    }
}
