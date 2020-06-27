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
using System.Data.SqlClient;
/// <summary>
/// Summary description for MovieBroker
/// </summary>
public class TitleBroker : DatabaseBroker
{

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        string addOnSql = "Reference_Flag IS NULL AND Deal_Type_Code = " + ((Title)obj).dealTypeCode;
        Title objTitle = (Title)obj;
        if (objTitle.SqlTrans != null)
            return DBUtil.IsDuplicateSqlTrans(ref obj, "Title", "Title_Name", ((Title)obj).TitleName, "title_code", ((Title)obj).IntCode, "Title already exists.", addOnSql, true);
        else
            return DBUtil.IsDuplicate(myConnection, "Title", "Title_Name", ((Title)obj).TitleName, "title_code", ((Title)obj).IntCode, "Title already exists.", addOnSql, true);
        //return false;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Title objTitle = (Title)obj;
        string strSql = "UPDATE [Title] SET [is_active]='" + objTitle.Is_Active + "',[Lock_Time]=null,[last_updated_time]=getdate() WHERE Title_code=" + objTitle.IntCode;
        return strSql;

    }

    public override string GetCountSql(string strSearchString)
    {
        return "SELECT COUNT(*) FROM Title WHERE Title_code > -1 " + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        return "DELETE FROM Title WHERE Title_code=" + obj.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        Title objTitle = (Title)obj;
        string tmpOrgTitle = "null";
        string tempTitleCodeId = "null";
        string tempsynopsis = "null";
        string tempOriginalLanguageCode = "null";
        string tempTitleLanguageCode = "null";
        string tmpProdYear = "null";
        string tmpMovRlsYr = "null";
        string tempGradeCode = "null";
        if (objTitle.originalTitle != null && objTitle.originalTitle.Trim() != "")
            tmpOrgTitle = "'" + GlobalUtil.ReplaceSingleQuotes(objTitle.originalTitle).Trim() + "'";
        if (objTitle.TitleCodeId != null && objTitle.TitleCodeId.Trim() != "")
            tempTitleCodeId = "'" + GlobalUtil.ReplaceSingleQuotes(objTitle.TitleCodeId) + "'";
        if (objTitle.synopsis != null && objTitle.synopsis.Trim() != "")
            tempsynopsis = "'" + GlobalUtil.ReplaceSingleQuotes(objTitle.synopsis) + "'";

        if (objTitle.objOriginalLanguage.IntCode > 0)
            tempOriginalLanguageCode = Convert.ToString(objTitle.objOriginalLanguage.IntCode);

        if (objTitle.TitleLanguageCode > 0)
            tempTitleLanguageCode = Convert.ToString(objTitle.TitleLanguageCode);

        if (objTitle.synopsis != null && objTitle.synopsis.Trim() != "")
            tempsynopsis = "'" + GlobalUtil.ReplaceSingleQuotes(objTitle.synopsis) + "'";

        if (objTitle.yearOfProduction > 0)
            tmpProdYear = objTitle.yearOfProduction.ToString().Trim();

        if (objTitle.GradeCode > 0)
            tempGradeCode = objTitle.GradeCode.ToString();
        string sql = " Insert INTO Title(Original_Title,Title_Name,Title_Code_Id,Synopsis,"
                    + " Original_Language_Code,Title_Language_Code,Year_Of_Production,Duration_In_Min,Deal_Type_Code,"
                    + " Grade_Code,Is_Active,Inserted_By,Inserted_On,Last_UpDated_Time,Last_Action_By)"
                    + " Values(" + tmpOrgTitle + ", '" + GlobalUtil.ReplaceSingleQuotes(objTitle.TitleName) + "'," + tempTitleCodeId + "," + tempsynopsis + ","
                    + " " + tempOriginalLanguageCode + "," + tempTitleLanguageCode + "," + tmpProdYear + "," + objTitle.Duration + "," + objTitle.dealTypeCode + ","
                    + " " + tempGradeCode + ",'" + objTitle.Is_Active + "'," + objTitle.InsertedBy + ",getdate(),getdate()," + objTitle.InsertedBy + ")";
        return sql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [title] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "SELECT * FROM [title] where title_code =  " + obj.IntCode;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Title objTitle = (Title)obj;
        string tmpOrgTitle = "null";
        string tempTitleCodeId = "null";
        string tempsynopsis = "null";
        string tempOriginalLanguageCode = "null";
        string tempTitleLanguageCode = "null";
        string tmpProdYear = "null";
        string tempGradeCode = "null";
        if (objTitle.originalTitle != null && objTitle.originalTitle.Trim() != "")
            tmpOrgTitle = "'" + GlobalUtil.ReplaceSingleQuotes(objTitle.originalTitle).Trim() + "'";
        if (objTitle.TitleCodeId != null && objTitle.TitleCodeId.Trim() != "")
            tempTitleCodeId = "'" + GlobalUtil.ReplaceSingleQuotes(objTitle.TitleCodeId) + "'";
        if (objTitle.synopsis != null && objTitle.synopsis.Trim() != "")
            tempsynopsis = "'" + GlobalUtil.ReplaceSingleQuotes(objTitle.synopsis) + "'";

        if (objTitle.objOriginalLanguage.IntCode > 0)
            tempOriginalLanguageCode = Convert.ToString(objTitle.objOriginalLanguage.IntCode);

        if (objTitle.TitleLanguageCode > 0)
            tempTitleLanguageCode = Convert.ToString(objTitle.TitleLanguageCode);

        if (objTitle.synopsis != null && objTitle.synopsis.Trim() != "")
            tempsynopsis = "'" + GlobalUtil.ReplaceSingleQuotes(objTitle.synopsis) + "'";

        if (objTitle.yearOfProduction > 0)
            tmpProdYear = objTitle.yearOfProduction.ToString().Trim();

        if (objTitle.GradeCode > 0)
            tempGradeCode = objTitle.GradeCode.ToString();

        string sql = "UPDATE Title SET original_title=" + tmpOrgTitle
                   + ",Title_Name='" + GlobalUtil.ReplaceSingleQuotes(objTitle.TitleName)
                   + "',synopsis='" + GlobalUtil.ReplaceSingleQuotes(objTitle.synopsis)
                   + "',Year_Of_Production=" + tmpProdYear
                   + ",Duration_In_Min=" + objTitle.Duration
                   + ",Deal_Type_Code= " + objTitle.dealTypeCode
                   + ",original_language_code= " + tempOriginalLanguageCode //objTitle.objOriginalLanguage.IntCode
                   + ",last_action_by=" + objTitle.LastUpdatedBy
                   + ",lock_time=null,last_updated_time=getdate(),title_code_id=" + tempTitleCodeId
                   + ",Grade_Code = " + tempGradeCode
                   + ",Title_Language_Code = " + objTitle.TitleLanguageCode
                   + " WHERE title_code=" + obj.IntCode;
        return sql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Title objTitle;
        if (obj == null)
        {
            objTitle = new Title();
        }
        else
        {
            objTitle = (Title)obj;
        }
        objTitle.IntCode = Convert.ToInt32(dRow["title_code"]);
        objTitle.originalTitle = Convert.ToString(dRow["original_title"]);
        objTitle.TitleName = Convert.ToString(dRow["Title_Name"]);
        objTitle.synopsis = Convert.ToString(dRow["synopsis"]);

        if (dRow["original_language_code"] != DBNull.Value)
            objTitle.objOriginalLanguage.IntCode = Convert.ToInt32(dRow["original_language_code"]);
        if (dRow["year_of_production"] != DBNull.Value)
        {
            objTitle.yearOfProduction = Convert.ToInt32(dRow["year_of_production"]);
        }
        if (dRow["Duration_In_Min"] != DBNull.Value)
        {
            objTitle.Duration = Convert.ToInt32(dRow["Duration_In_Min"]);
        }
        if (dRow["last_action_by"] != DBNull.Value)
            objTitle.InsertedBy = Convert.ToInt32(dRow["last_action_by"]);
        if (dRow["Deal_Type_Code"] != DBNull.Value)
            objTitle.dealTypeCode = Convert.ToInt32(dRow["Deal_Type_Code"]);

        objTitle.objDealType.IntCode = objTitle.dealTypeCode;
        if (dRow["lock_time"] != DBNull.Value)
        {
            objTitle.LockTime = Convert.ToString(dRow["lock_time"]);
        }
        if (dRow["last_updated_time"] != DBNull.Value)
        {
            objTitle.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        }
        if (dRow["title_code_id"] != DBNull.Value)
        {
            objTitle.TitleCodeId = Convert.ToString(dRow["title_code_id"]);
        }
        if (dRow["original_language_code"] != DBNull.Value)
        {
            objTitle.objOriginalLanguage.IntCode = Convert.ToInt32(dRow["original_language_code"]);
        }
        //if (dRow["released_on"] != DBNull.Value)
        //{
        //    objTitle.ReleasedOn = Convert.ToDateTime(dRow["released_on"]).ToString("dd/MM/yyyy");
        //}
        if (dRow["is_active"] != DBNull.Value)
            objTitle.Is_Active = Convert.ToString(dRow["is_active"]);

        objTitle.isShowReleaseBtn = isShowReleaseBtn(objTitle.IntCode);     //Added by Dada for Title Release

        if (dRow["Grade_Code"] != DBNull.Value)
            objTitle.GradeCode = Convert.ToInt32(dRow["Grade_Code"]);

        if (dRow["Title_Language_Code"] != DBNull.Value)
            objTitle.TitleLanguageCode = Convert.ToInt32(dRow["Title_Language_Code"]);

        objTitle.TitleStarCast = getTitleStarCast(objTitle.IntCode);
        objTitle.TitleDealMovieExsits = IsMovieExistInDealMovie(objTitle.IntCode);

        return objTitle;

    }

    public override string getRecordStatus(Persistent objPersist, out int UserIntcode)
    {
        return DBUtil.GetRecordStatus(myConnection, objPersist, "Title", "Title_code", out UserIntcode);
    }

    public override void refreshRecord(Persistent objPersist)
    {
        DBUtil.RefreshOrUnlockRecord(myConnection, objPersist, "Title", "Title_code", true);
    }

    public override void unlockRecord(Persistent objPersist)
    {
        DBUtil.RefreshOrUnlockRecord(myConnection, objPersist, "Title", "Title_code", false);
    }

    internal Boolean IsHoldback(int movieCode)
    {
        string strSql = "";
        //"select count(*) from Deal_Movie as DM Inner Join Deal_Movie_Rights as DMR on " +
        //                 "DM.deal_movie_code = DMR.deal_movie_code INNER JOIN deal_movie_rights_holdback dmrh " +
        //                 "ON DMR.deal_movie_rights_code=dmrh.deal_movie_rights_code " +
        //                 "INNER JOIN Deal_Memo DMEM ON DM.deal_memo_code = DMEM.deal_memo_code " +
        //                 "where DMR.is_holdback_applicable = 'Y' " +
        //                 "AND dmrh.holdback_flag='" + GlobalParams.holdBackFlag_Release + "' " +
        //                 "and DM.movie_code=" + movieCode + " " +
        //                 "AND DMEM.status = '" + GlobalParams.WorkFlowStatus_Approved + "' " +
        //                 "AND DMEM.is_active = '" + GlobalParams.deal_active + "' ";
        int resCount = (int)this.ProcessScalar(strSql);
        if (resCount > 0)
            return true;
        else
            return false;
    }

    internal Boolean IsAwardRlsExist(int movieCode)
    {
        string strSql = "select count(*) from Movie_Award where movie_code=" + movieCode;
        int resCount = (int)this.ProcessScalar(strSql);
        if (resCount > 0)
        {
            return true;
        }
        else
        {
            strSql = "select count(*) from Movie_Releases where movie_code=" + movieCode;
            resCount = (int)this.ProcessScalar(strSql);
            if (resCount > 0)
                return true;
            else
            {
                strSql = "select count(*) from Deal_Movie where movie_code=" + movieCode;
                resCount = (int)this.ProcessScalar(strSql);
                if (resCount > 0)
                    return true;
                else
                    return false;
            }
        }
    }

    internal bool IsTitleExist(string movieName, int movieCode)
    {
        string strSql = "Select count(*) from Title where Title_Name= '" + movieName.Trim().Replace("'", "''") + "' and title_code not in('" + movieCode + "')";
        int Count = Convert.ToInt32(ProcessScalar(strSql));
        if (Count > 0)
        {
            return true;
        }
        return false;
    }

    internal bool IsMovieExistInDealMovie(int movieCode)
    {
        string strSql = "Select count(Acq_Deal_Movie_Code) from Acq_Deal_Movie where title_code=" + movieCode;
        int Count = Convert.ToInt32(ProcessScalar(strSql));
        if (Count > 0)
        {
            return true;
        }
        return false;
    }

    internal void updateAndUnLockMovie(Title objTitle)
    {
        string strSql;
        strSql = "UPDATE title SET lock_time = null, last_action_by = " + objTitle.LastUpdatedBy + ", last_updated_time = getdate() WHERE title_code =" + objTitle.IntCode;
        if (objTitle.SqlTrans != null)
        {
            SqlTransaction sqlTrans = (SqlTransaction)objTitle.SqlTrans;
            ProcessNonQuery(strSql, false, ref sqlTrans);
        }
        else
        {
            ProcessNonQuery(strSql, false);
        }
    }

    //Added 
    internal string UpdateRelesedDate(Title title, string ReleaseDate)
    {
        try
        {
            Title objTitle = new Title();
            string strSql;
            strSql = "exec [usp_For_title_ReleasedOn] '" + title.IntCode + "','" + ReleaseDate + "','" + title.released_by + "' ";
            if (title.SqlTrans != null)
            {
                SqlTransaction sqlTrans = (SqlTransaction)title.SqlTrans;
                ProcessNonQuery(strSql, false, ref sqlTrans);
            }
            else
            {

                ProcessNonQuery(strSql, false);
            }

        }
        catch (Exception ex)
        {
            //throw ex;
            return "error";
        }
        return "ReleasedU";

    }

    internal DateTime GetDealSigndedDate(int titlecode)
    {
        //throw new NotImplementedException();
        Title objTitle = new Title();
        string strSql = "SELECT deal_signed_date FROM Acq_Deal d inner join Acq_Deal_Movie dm on d.deal_code=dm.deal_code where ISNULL(d.is_active,'N') = 'Y' and dm.title_code=" + titlecode;
        DateTime date = (DateTime)ProcessScalar(strSql);
        //string a = Convert.ToString(date);
        return date;
    }

    internal string Holdback(int titlecode)
    {
        //throw new NotImplementedException();
        string holdBack = "N";
        string strSql = "select is_holdback from deal_movie_rights dmr inner join Acq_Deal_Movie dm on dmr.deal_movie_code=dm.deal_movie_code where dm.title_code=" + titlecode;
        try
        {
            holdBack = (string)ProcessScalar(strSql);
        }
        catch (InvalidCastException Ex)
        {
        }
        catch (Exception Ex)
        {
            throw Ex;
        }

        return holdBack;
    }

    internal int getDealMovieCode(int titlecode)
    {
        string strSql = "SELECT deal_movie_code FROM Acq_Deal_Movie WHERE title_code=" + titlecode;
        int DealMovieCode = (int)ProcessScalar(strSql);
        return DealMovieCode;
    }
    internal bool checkMovieRefExist(int titlecode)
    {
        string strSql = "SELECT count(Acq_Deal_Movie_Code) FROM Acq_Deal_Movie WHERE  is_closed='N' and title_code=" + titlecode;
        int DealMovieCode = (int)ProcessScalar(strSql);
        if (DealMovieCode > 0)
            return true;
        else
            return false;
    }

    internal string ExecStoredProcedure(int DealMovieCode)
    {
        string strSql = "EXEC ForReleasedOn " + DealMovieCode;
        ProcessNonQueryDirectly(strSql);
        return "Update";
    }

    //Added

    internal string getSynopsis(int titlecode)
    {
        string Synopsis = "";
        string strSql = "select synopsis from title where title_code=" + titlecode;
        Synopsis = (string)ProcessScalar(strSql);
        return Synopsis;
    }

    internal string isShowReleaseBtn(int titlecode)     //Added by Dada for Title Release
    {

        string strShowReleaseBtn = "Y";
        string strSql = "SELECT dbo.ShouldShowReleaseButton (" + titlecode + ")";
        //  strShowReleaseBtn = (string)ProcessScalar(strSql);
        return strShowReleaseBtn;
    }

    private string getTitleStarCast(int TitleCode)
    {
        string starCast = string.Empty;
        string strSql = " select dbo.fn_GetStarCastForTitle_Viacom (" + TitleCode + ") ";
        starCast = ProcessScalarReturnString(strSql);
        starCast = starCast.Trim().Trim(',');
        return starCast;
    }


    internal bool SetEnableOnRef(int titleCode)
    {
        string strSelectCount = " select COUNT(Acq_Deal_Movie_Code) from Acq_Deal_Movie where title_code = " + titleCode;
        return DatabaseBroker.ProcessScalarDirectly(strSelectCount) > 0 ? false : true;
    }

    internal bool CanChangeOriginalLanguage(int titleCode)
    {
        //string strSelectCount = " select COUNT(*) from Syndication_Deal_Movie where title_code = " + titleCode;
        //return DatabaseBroker.ProcessScalarDirectly(strSelectCount) > 0 ? false : true;
        return true;
    }
}
