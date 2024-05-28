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
/// Summary description for MovieTerritoryBroker
/// </summary>
public class TitleTerritoryBroker : DatabaseBroker
{
    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        //TitleTerritory objTitleTerritory = (TitleTerritory)obj; 
        //return DBUtil.IsDuplicateSqlTrans(ref obj, "title_country", "territory_code", objTitleTerritory.objTerritory.IntCode.ToString(), "Title_Country_Code", objTitleTerritory.IntCode,
        //"Territory is already exists for this movie", "title_code=" + objTitleTerritory.titleCode, true);

        return false;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return "SELECT COUNT(*) FROM Title_Country WHERE Title_Country_Code > -1 " + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        return "DELETE FROM Title_Country WHERE Title_Country_Code=" + obj.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        TitleTerritory objTitleTerritory = (TitleTerritory)obj;
        string sql = "INSERT INTO Title_Country (title_code,Country_Code) VALUES(" + objTitleTerritory.titleCode 
            + ","+ objTitleTerritory.objTerritory.IntCode +")";
        return sql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = "SELECT * FROM Title_Country WHERE Title_Country_Code > -1 " + strSearchString;
        if (objCriteria.IsPagingRequired){
            sql = objCriteria.getPagingSQL(sql);
            return sql;
        }
        return sql + " ORDER BY " + objCriteria.getASCstr();
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "SELECT * FROM Title_Country WHERE Title_Country_Code=" + obj.IntCode;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        TitleTerritory objTitleTerritory = (TitleTerritory)obj;
        string sql = "UPDATE Title_Country SET title_code=" + objTitleTerritory.titleCode
                   + ",Country_Code=" + objTitleTerritory.objTerritory.IntCode
                   + " WHERE Title_Country_Code=" + obj.IntCode;
        return sql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TitleTerritory objTitleTerritory;
        if (obj == null){
            objTitleTerritory = new TitleTerritory();
        }
        else{
            objTitleTerritory = (TitleTerritory)obj;
        }
        objTitleTerritory.IntCode = Convert.ToInt32(dRow["Title_Country_Code"]);
        objTitleTerritory.titleCode = Convert.ToInt32(dRow["title_code"]);
        objTitleTerritory.objTerritory.IntCode = Convert.ToInt32(dRow["Country_Code"]);
        objTitleTerritory.status = GlobalParams.LINE_ITEM_EXISTING;
        return objTitleTerritory;
    }
}
