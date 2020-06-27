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
/// Summary description for RightsCategoryPlatforms
/// </summary>
public class RightsCategoryPlatformsBroker : DatabaseBroker
{
	public RightsCategoryPlatformsBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [rights_category_platforms] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RightsCategoryPlatforms objRightsCategoryPlatforms;
		if (obj == null)
		{
			objRightsCategoryPlatforms = new RightsCategoryPlatforms();
		}
		else
		{
			objRightsCategoryPlatforms = (RightsCategoryPlatforms)obj;
		}

		objRightsCategoryPlatforms.IntCode = Convert.ToInt32(dRow["rights_category_platforms_code"]);
		#region --populate--
		if (dRow["rights_category_code"] != DBNull.Value)
			objRightsCategoryPlatforms.RightsCategoryCode = Convert.ToInt32(dRow["rights_category_code"]);
		if (dRow["platforms_code"] != DBNull.Value)
			objRightsCategoryPlatforms.PlatformsCode = Convert.ToInt32(dRow["platforms_code"]);
		#endregion
		return objRightsCategoryPlatforms;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		RightsCategoryPlatforms objRightsCategoryPlatforms = (RightsCategoryPlatforms)obj;
		return "insert into [rights_category_platforms]([rights_category_code], [platforms_code]) values('" + objRightsCategoryPlatforms.RightsCategoryCode + "', '" + objRightsCategoryPlatforms.PlatformsCode + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		RightsCategoryPlatforms objRightsCategoryPlatforms = (RightsCategoryPlatforms)obj;
		return "update [rights_category_platforms] set [rights_category_code] = '" + objRightsCategoryPlatforms.RightsCategoryCode + "', [platforms_code] = '" + objRightsCategoryPlatforms.PlatformsCode + "' where rights_category_platforms_code = '" + objRightsCategoryPlatforms.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		RightsCategoryPlatforms objRightsCategoryPlatforms = (RightsCategoryPlatforms)obj;

		return " DELETE FROM [rights_category_platforms] WHERE rights_category_platforms_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        RightsCategoryPlatforms objRightsCategoryPlatforms = (RightsCategoryPlatforms)obj;
return "Update [rights_category_platforms] set Is_Active='" + objRightsCategoryPlatforms.Is_Active + "',lock_time=null, last_updated_time= getdate() where rights_category_platforms_code = '" + objRightsCategoryPlatforms.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [rights_category_platforms] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [rights_category_platforms] WHERE  rights_category_platforms_code = " + obj.IntCode;
    }  
}
