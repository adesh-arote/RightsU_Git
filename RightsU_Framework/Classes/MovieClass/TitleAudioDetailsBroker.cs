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
/// Summary description for TitleAudioDetails
/// </summary>
public class TitleAudioDetailsBroker : DatabaseBroker
{
    public TitleAudioDetailsBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [title_audio_details] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TitleAudioDetails objTitleAudioDetails;
        if (obj == null)
        {
            objTitleAudioDetails = new TitleAudioDetails();
        }
        else
        {
            objTitleAudioDetails = (TitleAudioDetails)obj;
        }

        objTitleAudioDetails.IntCode = Convert.ToInt32(dRow["title_audio_details_code"]);
        #region --populate--
        if (dRow["title_code"] != DBNull.Value)
            objTitleAudioDetails.TitleCode = Convert.ToInt32(dRow["title_code"]);
        objTitleAudioDetails.SongName = Convert.ToString(dRow["song_name"]);
        objTitleAudioDetails.MovieName = Convert.ToString(dRow["movie_name"]);
        if (dRow["duration"] != DBNull.Value)
            objTitleAudioDetails.Duration = Convert.ToInt32(dRow["duration"]);
        if (dRow["language_code"] != DBNull.Value)
            objTitleAudioDetails.LanguageCode = Convert.ToInt32(dRow["language_code"]);
        if (dRow["geners_code"] != DBNull.Value)
            objTitleAudioDetails.GenersCode = Convert.ToInt32(dRow["geners_code"]);
        #endregion
        return objTitleAudioDetails;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        TitleAudioDetails objTitleAudioDetails = (TitleAudioDetails)obj;
        return "insert into [title_audio_details]([title_code], [song_name], [movie_name], [duration], [language_code], [geners_code]) values('" + objTitleAudioDetails.TitleCode + "', '" + objTitleAudioDetails.SongName.Trim().Replace("'", "''") + "', '" + objTitleAudioDetails.MovieName.Trim().Replace("'", "''") + "', '" + objTitleAudioDetails.Duration + "', '" + objTitleAudioDetails.LanguageCode + "', '" + objTitleAudioDetails.GenersCode + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        TitleAudioDetails objTitleAudioDetails = (TitleAudioDetails)obj;
        return "update [title_audio_details] set [title_code] = '" + objTitleAudioDetails.TitleCode + "', [song_name] = '" + objTitleAudioDetails.SongName.Trim().Replace("'", "''") + "', [movie_name] = '" + objTitleAudioDetails.MovieName.Trim().Replace("'", "''") + "', [duration] = '" + objTitleAudioDetails.Duration + "', [language_code] = '" + objTitleAudioDetails.LanguageCode + "', [geners_code] = '" + objTitleAudioDetails.GenersCode + "' where title_audio_details_code = '" + objTitleAudioDetails.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        TitleAudioDetails objTitleAudioDetails = (TitleAudioDetails)obj;
        if (objTitleAudioDetails.arrTitleAudioDetailsSingers.Count > 0)
            DBUtil.DeleteChild("TitleAudioDetailsSingers", objTitleAudioDetails.arrTitleAudioDetailsSingers, objTitleAudioDetails.IntCode, (SqlTransaction)objTitleAudioDetails.SqlTrans);

        return " DELETE FROM [title_audio_details] WHERE title_audio_details_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        TitleAudioDetails objTitleAudioDetails = (TitleAudioDetails)obj;
        return "Update [title_audio_details] set Is_Active='" + objTitleAudioDetails.Is_Active + "',lock_time=null, last_updated_time= getdate() where title_audio_details_code = '" + objTitleAudioDetails.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [title_audio_details] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [title_audio_details] WHERE  title_audio_details_code = " + obj.IntCode;
    }
}
