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
/// Summary description for LanguageGroup
/// </summary>
public class LanguageGroupBroker : DatabaseBroker
{
    public LanguageGroupBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Language_Group] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        LanguageGroup objLanguageGroup;
        if (obj == null)
        {
            objLanguageGroup = new LanguageGroup();
        }
        else
        {
            objLanguageGroup = (LanguageGroup)obj;
        }

        objLanguageGroup.IntCode = Convert.ToInt32(dRow["Language_Group_Code"]);
        #region --populate--
        objLanguageGroup.LanguageGroupName = Convert.ToString(dRow["Language_Group_Name"]);
        if (dRow["inserted_on"] != DBNull.Value)
            //objLanguageGroup.InsertedOn = Convert.ToDateTime(dRow["inserted_on"]);
            objLanguageGroup.InsertedOn = Convert.ToString(dRow["inserted_on"]);
        if (dRow["inserted_by"] != DBNull.Value)
            objLanguageGroup.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
        if (dRow["lock_time"] != DBNull.Value)
            objLanguageGroup.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objLanguageGroup.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objLanguageGroup.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
        objLanguageGroup.IsActive = Convert.ToString(dRow["is_active"]);
        objLanguageGroup.Language = GetLanguageName(objLanguageGroup.IntCode);
        if (objLanguageGroup != null && objLanguageGroup.IntCode > 0)
            objLanguageGroup.IsRef = CheckRef(objLanguageGroup.IntCode);
        #endregion
        return objLanguageGroup;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        LanguageGroup objLanguageGroup = (LanguageGroup)obj;
        string sql = "insert into [Language_Group]([Language_Group_Name], [inserted_on], [inserted_by] "
                + ", [lock_time], [last_updated_time], [last_action_by] "
                + ", [is_active])  values "
                + "(N'" + objLanguageGroup.LanguageGroupName.Trim().Replace("'", "''") + "', GetDate(), '" + objLanguageGroup.InsertedBy + "' "
                + ",  Null, GetDate(), '" + objLanguageGroup.InsertedBy + "' "
                + ",  '" + objLanguageGroup.IsActive + "')";
        return sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        LanguageGroup objLanguageGroup = (LanguageGroup)obj;
        string sql = "update [Language_Group] set [Language_Group_Name] = N'" + objLanguageGroup.LanguageGroupName.Trim().Replace("'", "''") + "' "
                + " "
                + " "
                + ", [lock_time] = Null "
                + ", [last_updated_time] = GetDate() "
                + ", [last_action_by] = '" + objLanguageGroup.LastActionBy + "' "
                + ", [is_active] = '" + objLanguageGroup.IsActive + "' "
                + " where Language_Group_Code = '" + objLanguageGroup.IntCode + "'";
        return sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        LanguageGroup objLanguageGroup = (LanguageGroup)obj;
        //if (objLanguageGroup.arrLanguageGroupDetails.Count > 0)
        //    DBUtil.DeleteChild("LanguageGroupDetails", objLanguageGroup.arrLanguageGroupDetails, objLanguageGroup.IntCode, (SqlTransaction)objLanguageGroup.SqlTrans);

        string sql = " DELETE FROM [Language_Group] WHERE Language_Group_Code = " + obj.IntCode;
        return sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        LanguageGroup objLanguageGroup = (LanguageGroup)obj;
        string sql = "Update [Language_Group] set is_active='" + objLanguageGroup.IsActive + "',lock_time=null, "
                    + " last_updated_time= getdate() where Language_Group_Code = '" + objLanguageGroup.IntCode + "'";
        return sql;
    }

    public override string GetCountSql(string strSearchString)
    {
        string sql = " SELECT Count(*) FROM [Language_Group] WHERE 1=1 " + strSearchString;
        return sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        string sql = " SELECT * FROM [Language_Group] WHERE  Language_Group_Code = " + obj.IntCode;
        return sql;
    }
    private string GetLanguageName(int langGroupCode)
    {
        //string sql = "select language_name from Language Where language_code In("
        //    + " select Language_Code from Language_Group_Details Where Language_Group_Code IN("
        //    + " select Language_Group_Code from Language_Group Where Language_Group_Code = " + languageGroupCode + "))";
        string sql = " select language_name from Language_Group LG "
                    + " Inner join Language_Group_Details LGD On LGD.Language_Group_Code=LG.Language_Group_Code AND LG.Language_Group_Code=" + langGroupCode + " "
                    + " Inner Join Language L on L.language_code=LGD.Language_Code";
        DataSet ds = DatabaseBroker.ProcessSelectDirectly(sql);
        string LangName = "";
        if (ds.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                LangName = ds.Tables[0].Rows[i][0].ToString() + ", " + LangName;
            }
            
        }
        return LangName.Trim(',');
    }

    private string CheckRef(int Lang_Group_Code)
    {
        string sql = "SELECT dbo.UFN_Check_Ref_Language(" + Lang_Group_Code + ",'G') AS Is_Ref";
        sql = DatabaseBroker.ProcessScalarReturnString(sql);
        return sql;
    }
}
