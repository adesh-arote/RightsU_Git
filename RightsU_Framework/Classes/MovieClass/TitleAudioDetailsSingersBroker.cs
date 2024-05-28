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
/// Summary description for TitleAudioDetailsSingers
/// </summary>
public class TitleAudioDetailsSingersBroker : DatabaseBroker
{
	public TitleAudioDetailsSingersBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [title_audio_details_singers] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TitleAudioDetailsSingers objTitleAudioDetailsSingers;
		if (obj == null)
		{
			objTitleAudioDetailsSingers = new TitleAudioDetailsSingers();
		}
		else
		{
			objTitleAudioDetailsSingers = (TitleAudioDetailsSingers)obj;
		}

		objTitleAudioDetailsSingers.IntCode = Convert.ToInt32(dRow["title_audio_details_singers_code"]);
		#region --populate--
		if (dRow["title_code"] != DBNull.Value)
			objTitleAudioDetailsSingers.TitleCode = Convert.ToInt32(dRow["title_code"]);
		if (dRow["title_audio_details_code"] != DBNull.Value)
			objTitleAudioDetailsSingers.TitleAudioDetailsCode = Convert.ToInt32(dRow["title_audio_details_code"]);
		if (dRow["talent_code"] != DBNull.Value)
			objTitleAudioDetailsSingers.TalentCode = Convert.ToInt32(dRow["talent_code"]);
		#endregion
		return objTitleAudioDetailsSingers;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		TitleAudioDetailsSingers objTitleAudioDetailsSingers = (TitleAudioDetailsSingers)obj;
		return "insert into [title_audio_details_singers]([title_code], [title_audio_details_code], [talent_code]) values('" + objTitleAudioDetailsSingers.TitleCode + "', '" + objTitleAudioDetailsSingers.TitleAudioDetailsCode + "', '" + objTitleAudioDetailsSingers.TalentCode + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		TitleAudioDetailsSingers objTitleAudioDetailsSingers = (TitleAudioDetailsSingers)obj;
		return "update [title_audio_details_singers] set [title_code] = '" + objTitleAudioDetailsSingers.TitleCode + "', [title_audio_details_code] = '" + objTitleAudioDetailsSingers.TitleAudioDetailsCode + "', [talent_code] = '" + objTitleAudioDetailsSingers.TalentCode + "' where title_audio_details_singers_code = '" + objTitleAudioDetailsSingers.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		TitleAudioDetailsSingers objTitleAudioDetailsSingers = (TitleAudioDetailsSingers)obj;

		return " DELETE FROM [title_audio_details_singers] WHERE title_audio_details_singers_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        TitleAudioDetailsSingers objTitleAudioDetailsSingers = (TitleAudioDetailsSingers)obj;
return "Update [title_audio_details_singers] set Is_Active='" + objTitleAudioDetailsSingers.Is_Active + "',lock_time=null, last_updated_time= getdate() where title_audio_details_singers_code = '" + objTitleAudioDetailsSingers.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [title_audio_details_singers] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [title_audio_details_singers] WHERE  title_audio_details_singers_code = " + obj.IntCode;
    }  
}
