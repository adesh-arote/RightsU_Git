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
/// Summary description for AdditionalExpense
/// </summary>
public class AdditionalExpenseBroker : DatabaseBroker
{
    public AdditionalExpenseBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Additional_Expense] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        AdditionalExpense objAdditionalExpense;
        if (obj == null)
        {
            objAdditionalExpense = new AdditionalExpense();
        }
        else
        {
            objAdditionalExpense = (AdditionalExpense)obj;
        }

        objAdditionalExpense.IntCode = Convert.ToInt32(dRow["Additional_Expense_Code"]);
        #region --populate--
        objAdditionalExpense.AdditionalExpenseName = Convert.ToString(dRow["Additional_Expense_Name"]);
        objAdditionalExpense.SapGlGroupCode = Convert.ToString(dRow["SAP_GL_Group_Code"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objAdditionalExpense.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objAdditionalExpense.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objAdditionalExpense.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objAdditionalExpense.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objAdditionalExpense.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objAdditionalExpense.Is_Active = Convert.ToString(dRow["Is_Active"]);
        #endregion
        return objAdditionalExpense;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        AdditionalExpense objAdditionalExpense = (AdditionalExpense)obj;
        return DBUtil.IsDuplicate(myConnection, objAdditionalExpense.tableName, "Additional_Expense_Name ", objAdditionalExpense.AdditionalExpenseName, objAdditionalExpense.pkColName, objAdditionalExpense.IntCode, "Record already exist", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        AdditionalExpense objAdditionalExpense = (AdditionalExpense)obj;
        return "insert into [Additional_Expense]([Additional_Expense_Name],[SAP_GL_Group_Code],[Inserted_On], [Inserted_By], [Lock_Time], [Last_Updated_Time], [Last_Action_By], [Is_Active]) values(N'" + objAdditionalExpense.AdditionalExpenseName.Trim().Replace("'", "''") + "',N'" + objAdditionalExpense.SapGlGroupCode.Trim().Replace("'", "''") + "' ,GetDate(), '" + objAdditionalExpense.InsertedBy + "',  Null, GetDate(), '" + objAdditionalExpense.InsertedBy + "',  '" + objAdditionalExpense.Is_Active + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        AdditionalExpense objAdditionalExpense = (AdditionalExpense)obj;
        return "update [Additional_Expense] set [Additional_Expense_Name] = N'" + objAdditionalExpense.AdditionalExpenseName.Trim().Replace("'", "''") + "',[SAP_GL_Group_Code]=N'" + objAdditionalExpense.SapGlGroupCode.Trim().Replace("'", "''") + "' ,[Lock_Time] = Null, [Last_Updated_Time] = GetDate(), [Last_Action_By] = '" + objAdditionalExpense.LastActionBy + "', [Is_Active] = '" + objAdditionalExpense.Is_Active + "' where Additional_Expense_Code = '" + objAdditionalExpense.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        AdditionalExpense objAdditionalExpense = (AdditionalExpense)obj;

        return " DELETE FROM [Additional_Expense] WHERE Additional_Expense_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        AdditionalExpense objAdditionalExpense = (AdditionalExpense)obj;
        return "Update [Additional_Expense] set Is_Active='" + objAdditionalExpense.Is_Active + "',lock_time=null, last_updated_time= getdate() where Additional_Expense_Code = '" + objAdditionalExpense.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Additional_Expense] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Additional_Expense] WHERE  Additional_Expense_Code = " + obj.IntCode;
    }
}
