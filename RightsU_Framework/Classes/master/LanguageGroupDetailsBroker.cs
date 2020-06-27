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
/// Summary description for LanguageGroupDetails
/// </summary>
public class LanguageGroupDetailsBroker : DatabaseBroker
{
    public LanguageGroupDetailsBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Language_Group_Details] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        LanguageGroupDetails objLanguageGroupDetails;
        if (obj == null)
        {
            objLanguageGroupDetails = new LanguageGroupDetails();
        }
        else
        {
            objLanguageGroupDetails = (LanguageGroupDetails)obj;
        }

        objLanguageGroupDetails.IntCode = Convert.ToInt32(dRow["Language_Group_Details_Code"]);
        #region --populate--
        if (dRow["Language_Group_Code"] != DBNull.Value)
            objLanguageGroupDetails.LanguageGroupCode = Convert.ToInt32(dRow["Language_Group_Code"]);
        if (dRow["Language_Code"] != DBNull.Value)
            objLanguageGroupDetails.LanguageCode = Convert.ToInt32(dRow["Language_Code"]);
        #endregion
        return objLanguageGroupDetails;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        LanguageGroupDetails objLanguageGroupDetails = (LanguageGroupDetails)obj;
        string sql = "insert into [Language_Group_Details]([Language_Group_Code], [Language_Code])  values "
                + "('" + objLanguageGroupDetails.LanguageGroupCode + "', '" + objLanguageGroupDetails.LanguageCode + "')";
        return sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        LanguageGroupDetails objLanguageGroupDetails = (LanguageGroupDetails)obj;
        string sql = "update [Language_Group_Details] set [Language_Group_Code] = '" + objLanguageGroupDetails.LanguageGroupCode + "' "
                + ", [Language_Code] = '" + objLanguageGroupDetails.LanguageCode + "' "
                + " where Language_Group_Details_Code = '" + objLanguageGroupDetails.IntCode + "'";
        return sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        LanguageGroupDetails objLanguageGroupDetails = (LanguageGroupDetails)obj;

        string sql = " DELETE FROM [Language_Group_Details] WHERE Language_Group_Details_Code = " + obj.IntCode;
        return sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        LanguageGroupDetails objLanguageGroupDetails = (LanguageGroupDetails)obj;
        //string sql = "Update [Language_Group_Details] set IsActive='" + objLanguageGroupDetails.IsActive + "',lock_time=null, "
        //            + " last_updated_time= getdate() where Language_Group_Details_Code = '" + objLanguageGroupDetails.IntCode + "'";
        string sql = "Update [Language_Group_Details] set IsActive='" + objLanguageGroupDetails.IsActive + "',lock_time=null, "
                    + " last_updated_time= getdate() where Language_Group_Details_Code = '" + objLanguageGroupDetails.IntCode + "'";
        return sql;
    }

    public override string GetCountSql(string strSearchString)
    {
        string sql = " SELECT Count(*) FROM [Language_Group_Details] WHERE 1=1 " + strSearchString;
        return sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        string sql = " SELECT * FROM [Language_Group_Details] WHERE  Language_Group_Details_Code = " + obj.IntCode;
        return sql;
    }
}
