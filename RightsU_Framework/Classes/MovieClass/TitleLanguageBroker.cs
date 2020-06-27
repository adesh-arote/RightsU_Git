using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for TitleLanguageBroker
/// </summary>
public class TitleLanguageBroker123 : DatabaseBroker
{
    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        //TitleLanguage121 objMovLanguage = (TitleLanguage121)obj;
        //return DBUtil.IsDuplicateSqlTrans(ref obj, "Movie_Language", "language_code", objMovLanguage.objLanguage.IntCode.ToString(), "movie_language_code", objMovLanguage.IntCode,
        //"Original Language is already exists for this movie", "title_code=" + objMovLanguage.titleCode, true);

        return false;

    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return "SELECT COUNT(*) FROM Movie_Language WHERE movie_language_code > -1 " + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        return "DELETE FROM Movie_Language WHERE movie_language_code=" + obj.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        TitleLanguage121 objMovLanguage = (TitleLanguage121)obj;
        string sql = "INSERT INTO Movie_Language (movie_code,language_code) " +
                     "VALUES(" + objMovLanguage.titleCode + ","+ objMovLanguage.objLanguage.IntCode +")";
        return sql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = "SELECT * FROM Movie_Language WHERE movie_language_code > -1 " + strSearchString;
        if (objCriteria.IsPagingRequired){
            sql = objCriteria.getPagingSQL(sql);
            return sql;
        }
        return sql + " ORDER BY " + objCriteria.getASCstr();
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "SELECT * FROM Movie_Language WHERE movie_language_code=" + obj.IntCode;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        TitleLanguage121 objMovLanguage = (TitleLanguage121)obj;
        string sql = "UPDATE Movie_Language SET movie_code=" + objMovLanguage.titleCode
                    + ",language_code=" + objMovLanguage.objLanguage.IntCode;
        return sql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TitleLanguage121 objMovLanguage;
        if (obj == null){
            objMovLanguage = new TitleLanguage121();
        }
        else{
            objMovLanguage = (TitleLanguage121)obj;
        }
        objMovLanguage.IntCode = Convert.ToInt32(dRow["movie_language_code"]);
        objMovLanguage.titleCode = Convert.ToInt32(dRow["movie_code"]);
        objMovLanguage.objLanguage.IntCode = Convert.ToInt32(dRow["language_code"]);
        objMovLanguage.status = GlobalParams.LINE_ITEM_EXISTING;
        return objMovLanguage;
    }
}
