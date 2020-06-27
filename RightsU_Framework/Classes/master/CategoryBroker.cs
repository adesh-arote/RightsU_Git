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
/// Summary description for Category
/// </summary>
public class CategoryBroker : DatabaseBroker
{
    public CategoryBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Category] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Category objCategory;
        if (obj == null)
        {
            objCategory = new Category();
        }
        else
        {
            objCategory = (Category)obj;
        }

        objCategory.IntCode = Convert.ToInt32(dRow["Category_Code"]);
        #region --populate--
        objCategory.CategoryName = Convert.ToString(dRow["Category_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objCategory.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objCategory.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objCategory.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objCategory.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objCategory.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        if (dRow["is_system_generated"] != DBNull.Value)
            objCategory.IsSystemGenerated = Convert.ToString(dRow["is_system_generated"]);
        else
            objCategory.IsSystemGenerated = "";
        objCategory.IsActive = Convert.ToChar(dRow["Is_Active"]);
        #endregion
        return objCategory;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        //Category objCategory = (Category)obj;
        //string strSql = "SELECT COUNT(*) FROM Category WHERE Category_Name='" + objCategory.CategoryName + "' and Category_Code <> " + objCategory.IntCode;
        //DataSet ds = ProcessSelect(strSql);
        //if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        //{
        //    int count = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
        //    if (count > 0)
        //        throw new DuplicateRecordException("Category Name Already Exits");
        //}
        //return false;

        Category objCategory = (Category)obj;
        return DBUtil.IsDuplicate(myConnection, "Category", "Category_Name", objCategory.CategoryName, "Category_Code", objCategory.IntCode, "Record already exists", "");

    }

    public override string GetInsertSql(Persistent obj)
    {
        Category objCategory = (Category)obj;
        string strSql = "insert into [Category]([Category_Name], [Inserted_On], [Inserted_By],[Is_Active],[is_system_generated]) values(N'" + objCategory.CategoryName.Trim().Replace("'", "''") + "', GETDATE() , '" + objCategory.InsertedBy + "','Y','N');";
        return (strSql);
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Category objCategory = (Category)obj;
        string strSql = "update [Category] set [Category_Name] = N'" + objCategory.CategoryName.Trim().Replace("'", "''") + "',[Lock_Time] = null, [Last_Updated_Time] = GETDATE(), [Last_Action_By] =  '" + objCategory.LastActionBy + "', [Is_Active] = '" + objCategory.IsActive + "' where Category_Code = '" + objCategory.IntCode + "';";
        return (strSql);
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Category objCategory = (Category)obj;

        return " DELETE FROM [Category] WHERE Category_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Category objCategory = (Category)obj;
        string strSql = "UPDATE [Category] SET Is_Active='" + objCategory.IsActive + "',[Lock_Time]=null,[Last_Updated_Time] = getDate() WHERE Category_Code=" + objCategory.IntCode;
        return (strSql);
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Category] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Category] WHERE  Category_Code = " + obj.IntCode;
    }
}
