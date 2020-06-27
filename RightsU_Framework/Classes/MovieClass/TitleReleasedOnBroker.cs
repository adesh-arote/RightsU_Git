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
using System.Data.SqlClient;

/// <summary>
/// Summary description for TitleReleasedOn
/// </summary>
public class TitleReleasedOnBroker : DatabaseBroker
{
    public TitleReleasedOnBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Title_Released_On] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TitleReleasedOn objTitleReleasedOn;
        if (obj == null)
        {
            objTitleReleasedOn = new TitleReleasedOn();
        }
        else
        {
            objTitleReleasedOn = (TitleReleasedOn)obj;
        }

        objTitleReleasedOn.IntCode = Convert.ToInt32(dRow["title_released_on_code"]);
        #region --populate--
        if (dRow["title_code"] != DBNull.Value)
            objTitleReleasedOn.TitleCode = Convert.ToInt32(dRow["title_code"]);
        if (dRow["platform_code"] != DBNull.Value)
            objTitleReleasedOn.PlatformCode = Convert.ToInt32(dRow["platform_code"]);
        if (dRow["released_on_date"] != DBNull.Value)
            objTitleReleasedOn.ReleasedOnDate = Convert.ToDateTime(dRow["released_on_date"]).ToString("dd/MM/yyyy");
        if (dRow["release_type"] != DBNull.Value)
            objTitleReleasedOn.ReleaseType = Convert.ToString(dRow["release_type"]);
        if (dRow["territory_code"] != DBNull.Value)
            objTitleReleasedOn.TerritoryCode = Convert.ToInt32(dRow["territory_code"]);
        if (dRow["country_code"] != DBNull.Value)
            objTitleReleasedOn.CountryCode = Convert.ToInt32(dRow["country_code"]);
        if (dRow["group_code"] != DBNull.Value)
            objTitleReleasedOn.GroupCode = Convert.ToInt32(dRow["group_code"]);

        objTitleReleasedOn.IsShowEditDeleteBtn = recordCount(objTitleReleasedOn.TitleCode);
        objTitleReleasedOn.IsNewlyAdded = YesNo.N.ToString();
        #endregion
        return objTitleReleasedOn;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        TitleReleasedOn objTitleReleasedOn = (TitleReleasedOn)obj;
        string strSql = " insert into [Title_Released_On]([title_code], [platform_code], [released_on_date],[release_type],[territory_code], "
        + " [country_code], [group_code]) values "
        + " ('" + objTitleReleasedOn.TitleCode + "', '" + objTitleReleasedOn.PlatformCode + "', "
        + " '" + GlobalUtil.GetFormatedDateTime(objTitleReleasedOn.ReleasedOnDate) + "', "
        + " '" + objTitleReleasedOn.ReleaseType + "', " + objTitleReleasedOn.TerritoryCode + ", "
        + " " + objTitleReleasedOn.CountryCode + ", " + objTitleReleasedOn.GroupCode + " )";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        TitleReleasedOn objTitleReleasedOn = (TitleReleasedOn)obj;
        return "update [Title_Released_On] set [title_code] = '" + objTitleReleasedOn.TitleCode + "', [platform_code] = '" + objTitleReleasedOn.PlatformCode + "', [released_on_date] = '" + GlobalUtil.GetFormatedDateTime(objTitleReleasedOn.ReleasedOnDate) + "' where title_released_on_code = '" + objTitleReleasedOn.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        TitleReleasedOn objTitleReleasedOn = (TitleReleasedOn)obj;

        return " DELETE FROM [Title_Released_On] WHERE title_released_on_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        TitleReleasedOn objTitleReleasedOn = (TitleReleasedOn)obj;
        return "Update [Title_Released_On] set Is_Active='" + objTitleReleasedOn.Is_Active + "',lock_time=null, last_updated_time= getdate() where title_released_on_code = '" + objTitleReleasedOn.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Title_Released_On] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Title_Released_On] WHERE  title_released_on_code = " + obj.IntCode;
    }

    internal void TitleRelease(int TitleCode, string ReleasedOnDate, int PlatformCode, string ReleaseType, int TerritoryGrpCode, int CountryCode, ref SqlTransaction objSqlTrans)
    {
        try
        {
            string strSql;
            //OLD QUERY
            //strSql = "EXEC [usp_TitleReleasedOn ] " + TitleCode + ",'" + GlobalUtil.GetFormatedDateTime(ReleasedOnDate) + "'," + PlatformCode + " ";

            strSql = " EXEC [usp_TitleReleasedOn_NEW] " + TitleCode + ",'" + GlobalUtil.GetFormatedDateTime(ReleasedOnDate) + "'," + PlatformCode + ", "
            + " '" + ReleaseType + "'," + TerritoryGrpCode + "," + CountryCode + " ";
            int tempInt = 0;
            tempInt = ProcessNonQuery(strSql, false, ref objSqlTrans);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    internal string recordCount(int TitleCode)
    {
        int count = 0;
        string IsDelEdit = "N";
        string strSql = "SELECT COUNT(*) FROM Title_Released_On WHERE title_code=" + TitleCode;
        count = ProcessScalarDirectly(strSql);

        if (count > 0)
            IsDelEdit = "N";
        else
            IsDelEdit = "Y";
        return IsDelEdit;
    }
}
