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
/// Summary description for InternationalTerritoryLanguage
/// </summary>
public class InternationalTerritoryLanguageBroker : DatabaseBroker
{
	public InternationalTerritoryLanguageBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Country_Language] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        InternationalTerritoryLanguage objInternationalTerritoryLanguage;
		if (obj == null)
		{
			objInternationalTerritoryLanguage = new InternationalTerritoryLanguage();
		}
		else
		{
			objInternationalTerritoryLanguage = (InternationalTerritoryLanguage)obj;
		}

        objInternationalTerritoryLanguage.IntCode = Convert.ToInt32(dRow["Country_Language_Code"]);
		#region --populate--
        if (dRow["Country_Code"] != DBNull.Value)
            objInternationalTerritoryLanguage.InternationalTerritoryCode = Convert.ToInt32(dRow["Country_Code"]);
		if (dRow["Language_Code"] != DBNull.Value)
			objInternationalTerritoryLanguage.LanguageCode = Convert.ToInt32(dRow["Language_Code"]);
        
		#endregion
		return objInternationalTerritoryLanguage;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		InternationalTerritoryLanguage objInternationalTerritoryLanguage = (InternationalTerritoryLanguage)obj;
		string sql= "insert into [Country_Language]([Country_Code], [Language_Code])  values "
				+ "('" + objInternationalTerritoryLanguage.InternationalTerritoryCode + "', '" + objInternationalTerritoryLanguage.LanguageCode + "')";
		return  sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		InternationalTerritoryLanguage objInternationalTerritoryLanguage = (InternationalTerritoryLanguage)obj;
		string sql="update [Country_Language] set [Country_Code] = '" + objInternationalTerritoryLanguage.InternationalTerritoryCode + "' "
				+ ", [Language_Code] = '" + objInternationalTerritoryLanguage.LanguageCode + "' "
				+ " where Country_Language_Code = '" + objInternationalTerritoryLanguage.IntCode + "'";
		return  sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		InternationalTerritoryLanguage objInternationalTerritoryLanguage = (InternationalTerritoryLanguage)obj;

		string sql= " DELETE FROM [Country_Language] WHERE Country_Language_Code = " + obj.IntCode ;
		return  sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        InternationalTerritoryLanguage objInternationalTerritoryLanguage = (InternationalTerritoryLanguage)obj;
		string sql= "Update [Country_Language] set IsActive='" + objInternationalTerritoryLanguage.Is_Active + "',lock_time=null, "
					+ " last_updated_time= getdate() where Country_Language_Code = '" + objInternationalTerritoryLanguage.IntCode + "'";
		return  sql;
    }

    public override string GetCountSql(string strSearchString)
    {
		string sql= " SELECT Count(*) FROM [Country_Language] WHERE 1=1 " + strSearchString;
		return  sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		string sql= " SELECT * FROM [Country_Language] WHERE  Country_Language_Code = " + obj.IntCode;
		return  sql;
    }
   
}
