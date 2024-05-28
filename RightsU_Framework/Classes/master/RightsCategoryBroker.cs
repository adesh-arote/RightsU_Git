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
/// Summary description for RightsCategory
/// </summary>
public class RightsCategoryBroker : DatabaseBroker
{
    public RightsCategoryBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [rights_category] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RightsCategory objRightsCategory;
        if (obj == null)
        {
            objRightsCategory = new RightsCategory();
        }
        else
        {
            objRightsCategory = (RightsCategory)obj;
        }

        objRightsCategory.IntCode = Convert.ToInt32(dRow["rights_category_code"]);
        #region --populate--
        objRightsCategory.RightsCategoryName = Convert.ToString(dRow["rights_category_name"]);
        if (dRow["parent_category_code"] != DBNull.Value)
            objRightsCategory.ParentCategoryCode = Convert.ToInt32(dRow["parent_category_code"]);
        objRightsCategory.IsSystemGenerated = Convert.ToString(dRow["is_system_generated"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objRightsCategory.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objRightsCategory.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objRightsCategory.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objRightsCategory.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objRightsCategory.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objRightsCategory.Is_Active = Convert.ToString(dRow["Is_Active"]);
        #endregion
        return objRightsCategory;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        RightsCategory objRightsCategory = (RightsCategory)obj;
        if (objRightsCategory.SqlTrans != null)
            return DBUtil.IsDuplicateSqlTrans(ref obj, objRightsCategory.tableName, "rights_category_name", objRightsCategory.RightsCategoryName, "rights_category_Code", objRightsCategory.IntCode, "Rights category name already exist", "", true);
        else
            return DBUtil.IsDuplicate(myConnection, objRightsCategory.tableName, "rights_category_name", objRightsCategory.RightsCategoryName, "rights_category_Code", ((RightsCategory)obj).IntCode, "Rights category name already exist", "", true);
    }

    public override string GetInsertSql(Persistent obj)
    {
        RightsCategory objRightsCategory = (RightsCategory)obj;
        //return "insert into [rights_category]([rights_category_name], [parent_category_code], [is_system_generated], [Inserted_On], [Inserted_By], [Lock_Time], [Last_Updated_Time], [Last_Action_By], [Is_Active]) values('" + objRightsCategory.RightsCategoryName.Trim().Replace("'", "''") + "', '" + objRightsCategory.ParentCategoryCode + "', '" + objRightsCategory.IsSystemGenerated.Trim().Replace("'", "''") + "', GetDate(), '" + objRightsCategory.InsertedBy + "',  Null, GetDate(), '" + objRightsCategory.InsertedBy + "',  '" + objRightsCategory.Is_Active + "');";
        string strSql = "insert into [rights_category]([rights_category_name], [parent_category_code], [is_system_generated], [Inserted_On], "
        + " [Inserted_By], [Lock_Time], [Last_Updated_Time], [Last_Action_By], [Is_Active]) "
        + " values('" + objRightsCategory.RightsCategoryName.Trim().Replace("'", "''") + "', "
        + " '" + objRightsCategory.ParentCategoryCode + "', '" + 'N' + "', "
        + " GetDate(), '" + objRightsCategory.InsertedBy + "',  Null, GetDate(), '" + objRightsCategory.InsertedBy + "',  "
        + " '" + objRightsCategory.Is_Active + "');";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        RightsCategory objRightsCategory = (RightsCategory)obj;
        return "update [rights_category] set [rights_category_name] = '" + objRightsCategory.RightsCategoryName.Trim().Replace("'", "''") + "', [parent_category_code] = '" + objRightsCategory.ParentCategoryCode + "', [is_system_generated] = 'N', [Lock_Time] = Null, [Last_Updated_Time] = GetDate(), [Last_Action_By] = '" + objRightsCategory.LastActionBy + "', [Is_Active] = '" + objRightsCategory.Is_Active + "' where rights_category_code = '" + objRightsCategory.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        RightsCategory objRightsCategory = (RightsCategory)obj;

        return " DELETE FROM [rights_category] WHERE rights_category_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        RightsCategory objRightsCategory = (RightsCategory)obj;
        return "Update [rights_category] set Is_Active='" + objRightsCategory.Is_Active + "',lock_time=null, last_updated_time= getdate() where rights_category_code = '" + objRightsCategory.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [rights_category] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [rights_category] WHERE  rights_category_code = " + obj.IntCode;
    }


    
}
