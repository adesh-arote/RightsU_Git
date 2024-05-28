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
/// Summary description for VwMovieRightsStatusAvailableReport1
/// </summary>
public class MovieRightsStatusAvailableReportBroker : DatabaseBroker
{
	public MovieRightsStatusAvailableReportBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [vw_movie_rights_status_available_report] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
		MovieRightsStatusAvailableReport objMovieRightsStatusAvailableReport;
		if (obj == null)
		{
			objMovieRightsStatusAvailableReport = new MovieRightsStatusAvailableReport();
		}
		else
		{
			objMovieRightsStatusAvailableReport = (MovieRightsStatusAvailableReport)obj;
		}

		objMovieRightsStatusAvailableReport.IntCode = Convert.ToInt32(dRow["deal_no"]);
		#region --populate--
		objMovieRightsStatusAvailableReport.OriginalTitle = Convert.ToString(dRow["original_title"]);
		objMovieRightsStatusAvailableReport.RightPeriodFor = Convert.ToString(dRow["right_period_for"]);
		objMovieRightsStatusAvailableReport.DealRights = Convert.ToString(dRow["deal_rights"]);
		if (dRow["deal_right_start_date"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.DealRightStartDate = Convert.ToDateTime(dRow["deal_right_start_date"]);
		if (dRow["deal_right_end_date"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.DealRightEndDate = Convert.ToDateTime(dRow["deal_right_end_date"]);
		objMovieRightsStatusAvailableReport.PlatformName = Convert.ToString(dRow["platform_name"]);
		objMovieRightsStatusAvailableReport.LanguageName = Convert.ToString(dRow["language_name"]);
		if (dRow["title_code"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.TitleCode = Convert.ToInt32(dRow["title_code"]);
		if (dRow["platform_code"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.PlatformCode = Convert.ToInt32(dRow["platform_code"]);
		if (dRow["Country_code"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.InternationalTerritoryCode = Convert.ToInt32(dRow["Country_code"]);
		if (dRow["language_code"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.LanguageCode = Convert.ToInt32(dRow["language_code"]);
		if (dRow["deal_movie_rights_code"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.DealMovieRightsCode = Convert.ToInt32(dRow["deal_movie_rights_code"]);
		objMovieRightsStatusAvailableReport.IsSubLicense = Convert.ToString(dRow["is_sub_license"]);
		objMovieRightsStatusAvailableReport.DomesticTeritoryName = Convert.ToString(dRow["domestic_teritory_name"]);
		objMovieRightsStatusAvailableReport.InternationalTerritoryName = Convert.ToString(dRow["Country_name"]);
		if (dRow["deal_signed_date"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.DealSignedDate = Convert.ToDateTime(dRow["deal_signed_date"]);
		if (dRow["territory_code"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.TerritoryCode = Convert.ToInt32(dRow["territory_code"]);
		objMovieRightsStatusAvailableReport.IsExclusive = Convert.ToString(dRow["is_exclusive"]);
		if (dRow["dealtype_code"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.DealtypeCode = Convert.ToInt32(dRow["dealtype_code"]);
		if (dRow["entity_code"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.EntityCode = Convert.ToInt32(dRow["entity_code"]);
		if (dRow["Minsale_right_start_date"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.MinsaleRightStartDate = Convert.ToInt32(dRow["Minsale_right_start_date"]);
		if (dRow["Maxsale_right_end_date"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.MaxsaleRightEndDate = Convert.ToInt32(dRow["Maxsale_right_end_date"]);
		if (dRow["Movie_Material_Medium_Name"] != DBNull.Value)
			objMovieRightsStatusAvailableReport.MovieMaterialMediumName = Convert.ToInt32(dRow["Movie_Material_Medium_Name"]);
		#endregion
		return objMovieRightsStatusAvailableReport;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		//MovieRightsStatusAvailableReport objMovieRightsStatusAvailableReport = (MovieRightsStatusAvailableReport)obj;
		//return "insert into [vw_movie_rights_status_available_report_1]([original_title], [right_period_for], [deal_rights], [deal_right_start_date], [deal_right_end_date], [platform_name], [language_name], [title_code], [platform_code], [Country_code], [language_code], [deal_movie_rights_code], [is_sub_license], [domestic_teritory_name], [Country_name], [deal_signed_date], [territory_code], [is_exclusive], [dealtype_code], [entity_code], [Minsale_right_start_date], [Maxsale_right_end_date], [Movie_Material_Medium_Name]) values('" + objVwMovieRightsStatusAvailableReport1.OriginalTitle.Trim().Replace("'", "''") + "', '" + objVwMovieRightsStatusAvailableReport1.RightPeriodFor.Trim().Replace("'", "''") + "', '" + objVwMovieRightsStatusAvailableReport1.DealRights.Trim().Replace("'", "''") + "', '" + objVwMovieRightsStatusAvailableReport1.DealRightStartDate + "', '" + objVwMovieRightsStatusAvailableReport1.DealRightEndDate + "', '" + objVwMovieRightsStatusAvailableReport1.PlatformName.Trim().Replace("'", "''") + "', '" + objVwMovieRightsStatusAvailableReport1.LanguageName.Trim().Replace("'", "''") + "', '" + objVwMovieRightsStatusAvailableReport1.TitleCode + "', '" + objVwMovieRightsStatusAvailableReport1.PlatformCode + "', '" + objVwMovieRightsStatusAvailableReport1.InternationalTerritoryCode + "', '" + objVwMovieRightsStatusAvailableReport1.LanguageCode + "', '" + objVwMovieRightsStatusAvailableReport1.DealMovieRightsCode + "', '" + objVwMovieRightsStatusAvailableReport1.IsSubLicense.Trim().Replace("'", "''") + "', '" + objVwMovieRightsStatusAvailableReport1.DomesticTeritoryName.Trim().Replace("'", "''") + "', '" + objVwMovieRightsStatusAvailableReport1.InternationalTerritoryName.Trim().Replace("'", "''") + "', '" + objVwMovieRightsStatusAvailableReport1.DealSignedDate + "', '" + objVwMovieRightsStatusAvailableReport1.TerritoryCode + "', '" + objVwMovieRightsStatusAvailableReport1.IsExclusive.Trim().Replace("'", "''") + "', '" + objVwMovieRightsStatusAvailableReport1.DealtypeCode + "', '" + objVwMovieRightsStatusAvailableReport1.EntityCode + "', '" + objVwMovieRightsStatusAvailableReport1.MinsaleRightStartDate + "', '" + objVwMovieRightsStatusAvailableReport1.MaxsaleRightEndDate + "', '" + objVwMovieRightsStatusAvailableReport1.MovieMaterialMediumName + "');";
		return "";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		//VwMovieRightsStatusAvailableReport1 objVwMovieRightsStatusAvailableReport1 = (VwMovieRightsStatusAvailableReport1)obj;
		//return "update [vw_movie_rights_status_available_report_1] set [original_title] = '" + objVwMovieRightsStatusAvailableReport1.OriginalTitle.Trim().Replace("'", "''") + "', [right_period_for] = '" + objVwMovieRightsStatusAvailableReport1.RightPeriodFor.Trim().Replace("'", "''") + "', [deal_rights] = '" + objVwMovieRightsStatusAvailableReport1.DealRights.Trim().Replace("'", "''") + "', [deal_right_start_date] = '" + objVwMovieRightsStatusAvailableReport1.DealRightStartDate + "', [deal_right_end_date] = '" + objVwMovieRightsStatusAvailableReport1.DealRightEndDate + "', [platform_name] = '" + objVwMovieRightsStatusAvailableReport1.PlatformName.Trim().Replace("'", "''") + "', [language_name] = '" + objVwMovieRightsStatusAvailableReport1.LanguageName.Trim().Replace("'", "''") + "', [title_code] = '" + objVwMovieRightsStatusAvailableReport1.TitleCode + "', [platform_code] = '" + objVwMovieRightsStatusAvailableReport1.PlatformCode + "', [Country_code] = '" + objVwMovieRightsStatusAvailableReport1.InternationalTerritoryCode + "', [language_code] = '" + objVwMovieRightsStatusAvailableReport1.LanguageCode + "', [deal_movie_rights_code] = '" + objVwMovieRightsStatusAvailableReport1.DealMovieRightsCode + "', [is_sub_license] = '" + objVwMovieRightsStatusAvailableReport1.IsSubLicense.Trim().Replace("'", "''") + "', [domestic_teritory_name] = '" + objVwMovieRightsStatusAvailableReport1.DomesticTeritoryName.Trim().Replace("'", "''") + "', [Country_name] = '" + objVwMovieRightsStatusAvailableReport1.InternationalTerritoryName.Trim().Replace("'", "''") + "', [deal_signed_date] = '" + objVwMovieRightsStatusAvailableReport1.DealSignedDate + "', [territory_code] = '" + objVwMovieRightsStatusAvailableReport1.TerritoryCode + "', [is_exclusive] = '" + objVwMovieRightsStatusAvailableReport1.IsExclusive.Trim().Replace("'", "''") + "', [dealtype_code] = '" + objVwMovieRightsStatusAvailableReport1.DealtypeCode + "', [entity_code] = '" + objVwMovieRightsStatusAvailableReport1.EntityCode + "', [Minsale_right_start_date] = '" + objVwMovieRightsStatusAvailableReport1.MinsaleRightStartDate + "', [Maxsale_right_end_date] = '" + objVwMovieRightsStatusAvailableReport1.MaxsaleRightEndDate + "', [Movie_Material_Medium_Name] = '" + objVwMovieRightsStatusAvailableReport1.MovieMaterialMediumName + "' where deal_no = '" + objVwMovieRightsStatusAvailableReport1.IntCode + "';";
		return "";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		//VwMovieRightsStatusAvailableReport1 objVwMovieRightsStatusAvailableReport1 = (VwMovieRightsStatusAvailableReport1)obj;
		//return " DELETE FROM [vw_movie_rights_status_available_report_1] WHERE deal_no = " + obj.IntCode ;

		return "";
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
		//VwMovieRightsStatusAvailableReport1 objVwMovieRightsStatusAvailableReport1 = (VwMovieRightsStatusAvailableReport1)obj;
		//return "Update [vw_movie_rights_status_available_report_1] set Is_Active='" + objVwMovieRightsStatusAvailableReport1.Is_Active + "',lock_time=null, last_updated_time= getdate() where deal_no = '" + objVwMovieRightsStatusAvailableReport1.IntCode + "'";
		return "";
    }

    public override string GetCountSql(string strSearchString)
    {
        int charIndex = strSearchString.IndexOf("where");
        string SelectedCol = strSearchString.Substring(0, charIndex); 
        string StrSearch = strSearchString.Substring(charIndex, strSearchString.Length - charIndex);
        StrSearch = StrSearch.Replace("where", " and ");
        SelectedCol = SelectedCol.Replace("set dateformat dmy", " ");
       

        return " select count(*) from ( " + SelectedCol + " WHERE 1=1 " + StrSearch+") as a";
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [vw_movie_rights_status_available_report] WHERE  deal_no = " + obj.IntCode;
    }

    internal DataSet GetDataSetToBindGrid(Criteria objCriteria, string Sql)
    {
        string sqlStr = Sql;
        string sqlStr1 = "";
        if (!objCriteria.IsPagingRequired)
            sqlStr = sqlStr + " ORDER BY " + objCriteria.getASCstr();

        sqlStr1=objCriteria.getPagingSQL(sqlStr);

        return this.ProcessSelect(sqlStr1);

    }

     
}
