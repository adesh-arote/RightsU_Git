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
/// Summary description for MovieStarCastBroker
/// </summary>
public class TitleStarCastBroker : DatabaseBroker
{
    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        //TitleStarCast objTitleStarCast = (TitleStarCast)obj;

        //return DBUtil.IsDuplicateSqlTrans(ref obj, "Title_Talent", "talent_code", objTitleStarCast.objTalent.IntCode.ToString(), "title_talent_code", objTitleStarCast.IntCode,
        //"Star cast is already exists for this title", "title_code="+objTitleStarCast.titleCode, true);
        return false;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return "SELECT COUNT(*) FROM Title_Talent WHERE title_talent_code > -1 " + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        return "DELETE FROM Title_Talent WHERE title_talent_code=" + obj.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        TitleStarCast objTitleStarCast = (TitleStarCast)obj;
        string sql = "INSERT INTO Title_Talent (talent_code,title_code,Role_Code) VALUES(" + objTitleStarCast.objTalent.IntCode
                     + "," + objTitleStarCast.titleCode + "," + objTitleStarCast.RoleCode + ")";
        return sql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        //string sql = "SELECT * FROM Title_Talent WHERE title_talent_code > -1 " + strSearchString;

        string sql = " SELECT TT.title_talent_code,TT.title_code,TT.talent_code , TT.Role_Code FROM Title_Talent  TT " +
                    " inner join Talent_Role TR on TT.talent_code = tr.talent_code " + strSearchString; //+ " and TR.role_code =2 ";
        if (objCriteria.IsPagingRequired)
        {
            sql = objCriteria.getPagingSQL(sql);
            return sql;
        }
        return sql + " ORDER BY " + objCriteria.getASCstr();
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "SELECT * FROM Title_Talent WHERE title_talent_code=" + obj.IntCode;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        TitleStarCast objTitleStarCast = (TitleStarCast)obj;
        string sql = "UPDATE Title_Talent SET talent_code=" + objTitleStarCast.IntCode
                   + ",title_code=" + objTitleStarCast.titleCode + " , Role_Code = " + objTitleStarCast.RoleCode + " WHERE title_talent_code=" + obj.IntCode;
        return sql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TitleStarCast objTitleStarCast;
        if (obj == null)
        {
            objTitleStarCast = new TitleStarCast();
        }
        else
        {
            objTitleStarCast = (TitleStarCast)obj;
        }
        objTitleStarCast.IntCode = Convert.ToInt32(dRow["title_talent_code"]);
        objTitleStarCast.objTalent.IntCode = Convert.ToInt32(dRow["talent_code"]);
        objTitleStarCast.titleCode = Convert.ToInt32(dRow["title_code"]);
        objTitleStarCast.RoleCode = Convert.ToInt32(dRow["Role_Code"]);
        objTitleStarCast.status = GlobalParams.LINE_ITEM_EXISTING;
        return objTitleStarCast;
    }
}
