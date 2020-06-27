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
/// Summary description for commission_type
/// </summary>
public class CommissionTypeBroker : DatabaseBroker {
    public CommissionTypeBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Commission_Type] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        CommissionType objCommissionType;
        if (obj == null)
        {
            objCommissionType = new CommissionType();
        }
        else
        {
            objCommissionType = (CommissionType)obj;
        }

        objCommissionType.IntCode = Convert.ToInt32(dRow["commission_type_Code"]);
        #region --populate--
        objCommissionType.CommissionTypeName = Convert.ToString(dRow["commission_type_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objCommissionType.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objCommissionType.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objCommissionType.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objCommissionType.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objCommissionType.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objCommissionType.Is_Active = Convert.ToString(dRow["Is_Active"]);
        #endregion
        return objCommissionType;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		CommissionType objCommissionType = (CommissionType)obj;
        return DBUtil.IsDuplicate(myConnection, objCommissionType.tableName, "commission_type_Name", objCommissionType.CommissionTypeName, objCommissionType.pkColName, objCommissionType.IntCode, "Commission Type Name already exist", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        CommissionType objCommissionType = (CommissionType)obj;
        return "insert into [commission_type]([commission_type_Name], [Inserted_On], [Inserted_By], [Is_Active]) values('" + objCommissionType.CommissionTypeName.Trim().Replace("'", "''") + "', getDate() , '" + objCommissionType.InsertedBy + "', 'Y');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        CommissionType objCommissionType = (CommissionType)obj;
        return "update [commission_type] set [commission_type_Name] = '" + objCommissionType.CommissionTypeName.Trim().Replace("'", "''") + "',  [Lock_Time] = null, [Last_Updated_Time] = getDate() , [Last_Action_By] = '" + objCommissionType.LastActionBy + "' where commission_type_Code = '" + objCommissionType.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        CommissionType objCommissionType = (CommissionType)obj;
        return "DELETE FROM [commission_type] WHERE commission_type_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
		CommissionType objCommissionType = (CommissionType)obj;
		return "Update [commission_type] set Is_Active='"+objCommissionType.Is_Active +"',lock_time=null, last_updated_time= getdate() where commission_type_Code = '" + objCommissionType.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [commission_type] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [commission_type] WHERE  commission_type_Code = " + obj.IntCode;
    }
}
