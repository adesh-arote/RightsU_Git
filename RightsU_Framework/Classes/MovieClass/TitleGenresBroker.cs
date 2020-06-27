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
/// Summary description for titleGenreBroker
/// </summary>
public class TitleGenresBroker : DatabaseBroker
{
    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        //TitleGenres objTitleGnrDtl = (TitleGenres)obj;
        //return DBUtil.IsDuplicateSqlTrans(ref obj, "title_geners", "genres_code", objTitleGnrDtl.objMovGenre.IntCode.ToString(),
        //       "title_geners_code", objTitleGnrDtl.IntCode, "Genre is already exists for this title", "title_code=" + objTitleGnrDtl.titleCode, true);

        return false;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return "SELECT COUNT(*) FROM title_geners WHERE title_geners_code > -1 " + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        return "DELETE FROM title_geners WHERE title_geners_code=" + obj.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        TitleGenres objTitleGnrDtl = (TitleGenres)obj;
        string sql = "INSERT INTO title_geners (title_code,genres_code) VALUES(" + objTitleGnrDtl.titleCode
                   + "," + objTitleGnrDtl.objMovGenre.IntCode + ")";
        return sql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = "SELECT * FROM title_geners WHERE title_geners_code > -1 " + strSearchString;
        if (objCriteria.IsPagingRequired)
        {
            sql = objCriteria.getPagingSQL(sql);
            return sql;
        }
        return sql + " ORDER BY " + objCriteria.getASCstr();
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "SELECT * FROM title_geners WHERE title_geners_code=" + obj.IntCode;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        TitleGenres objTitleGnrDtl = (TitleGenres)obj;
        string sql = "UPDATE title_geners SET title_code=" + objTitleGnrDtl.titleCode
            + ",genres_code=" + objTitleGnrDtl.objMovGenre.IntCode + " WHERE title_geners_code=" + obj.IntCode;
        return sql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TitleGenres objTitleGnrDtl;
        if (obj == null)
        {
            objTitleGnrDtl = new TitleGenres();
        }
        else
        {
            objTitleGnrDtl = (TitleGenres)obj;
        }
        objTitleGnrDtl.IntCode = Convert.ToInt32(dRow["title_geners_code"]);
        objTitleGnrDtl.titleCode = Convert.ToInt32(dRow["title_code"]);
        objTitleGnrDtl.objMovGenre.IntCode = Convert.ToInt32(dRow["genres_code"]);
        objTitleGnrDtl.status = GlobalParams.LINE_ITEM_EXISTING;
        return objTitleGnrDtl;
    }
}
