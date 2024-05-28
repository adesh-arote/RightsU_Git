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
/// Summary description for FormatPlatforms
/// </summary>
public class FormatPlatformsBroker : DatabaseBroker
{
    public FormatPlatformsBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Format_Platforms] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        FormatPlatforms objFormatPlatforms;
        if (obj == null)
        {
            objFormatPlatforms = new FormatPlatforms();
        }
        else
        {
            objFormatPlatforms = (FormatPlatforms)obj;
        }

        objFormatPlatforms.IntCode = Convert.ToInt32(dRow["format_platforms_code"]);
        #region --populate--
        if (dRow["format_code"] != DBNull.Value)
            objFormatPlatforms.FormatCode = Convert.ToInt32(dRow["format_code"]);
        if (dRow["platform_code"] != DBNull.Value)
            objFormatPlatforms.PlatformCode = Convert.ToInt32(dRow["platform_code"]);
        #endregion
        return objFormatPlatforms;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        FormatPlatforms objFormatPlatforms = (FormatPlatforms)obj;
        string strSql = " insert into [Format_Platforms]([format_code], [platform_code]) "
        + " values('" + objFormatPlatforms.FormatCode + "', '" + objFormatPlatforms.PlatformCode + "');";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        FormatPlatforms objFormatPlatforms = (FormatPlatforms)obj;
        string strSql = " update [Format_Platforms] set [format_code] = '" + objFormatPlatforms.FormatCode + "', "
        + " [platform_code] = '" + objFormatPlatforms.PlatformCode + "' where format_platforms_code = '" + objFormatPlatforms.IntCode + "';";
        return strSql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        FormatPlatforms objFormatPlatforms = (FormatPlatforms)obj;
        string strSql = " DELETE FROM [Format_Platforms] WHERE format_platforms_code = " + obj.IntCode;
        return strSql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        FormatPlatforms objFormatPlatforms = (FormatPlatforms)obj;
        return "Update [Format_Platforms] set Is_Active='" + objFormatPlatforms.Is_Active + "',lock_time=null, last_updated_time= getdate() where format_platforms_code = '" + objFormatPlatforms.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Format_Platforms] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Format_Platforms] WHERE  format_platforms_code = " + obj.IntCode;
    }
}
