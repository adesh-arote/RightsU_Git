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
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for ExternalTitle_GradeExceptionBroker
/// </summary>
public class ExternalTitle_GradeExceptionBroker : DatabaseBroker
{
    public ExternalTitle_GradeExceptionBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [External_Title] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ExternalTitle_GradeException objExternalTitle_GradeException;
        if (obj == null)
        {
            objExternalTitle_GradeException = new ExternalTitle_GradeException();
        }
        else
        {
            objExternalTitle_GradeException = (ExternalTitle_GradeException)obj;
        }

        objExternalTitle_GradeException.IntCode = Convert.ToInt32(dRow["external_title_code"]);
        #region --populate--
        objExternalTitle_GradeException.TitleName = Convert.ToString(dRow["TitleName"]);
        objExternalTitle_GradeException.MasterFormat = Convert.ToString(dRow["MasterFormat"]);
        if (dRow["ReleaseDate"] != DBNull.Value)
            objExternalTitle_GradeException.ReleaseDate = Convert.ToDateTime(dRow["ReleaseDate"]).ToString("dd/MM/yyyy");
        if (dRow["RightsExpiry"] != DBNull.Value)
            objExternalTitle_GradeException.RightsExpiry = Convert.ToDateTime(dRow["RightsExpiry"]).ToString("dd/MM/yyyy");
        objExternalTitle_GradeException.TitleType = Convert.ToString(dRow["Title_Type"]);
        objExternalTitle_GradeException.BoxSingle = Convert.ToString(dRow["Box_Single"]);
        objExternalTitle_GradeException.SAPInternalOrder = Convert.ToString(dRow["SAPInternalOrder"]);

        if (dRow["deal_movie_code"] != DBNull.Value)
            objExternalTitle_GradeException.DealMovieCode = Convert.ToInt32(dRow["deal_movie_code"]);

        objExternalTitle_GradeException.LastExceptionGrade = GetLastExceptionGrade(objExternalTitle_GradeException.IntCode);
        objExternalTitle_GradeException.ExceptionGrade_LastGradeCode = Get_ExceptionGrade_LastGradeCode(objExternalTitle_GradeException.IntCode);
        objExternalTitle_GradeException.ExceptionGrade_EffStartDate = Get_ExceptionGrade_EffStartDate(objExternalTitle_GradeException.IntCode);

        string RightPeriod = Get_RightPeriod(objExternalTitle_GradeException.DealMovieCode);
        if (!string.IsNullOrEmpty(RightPeriod))
        {
            string[] arr = RightPeriod.Split(new char[] { '~' }, StringSplitOptions.RemoveEmptyEntries);
            objExternalTitle_GradeException.DealRightStartDate = arr[0];
            objExternalTitle_GradeException.DealRightEndDate = arr[1];
        }

        objExternalTitle_GradeException.IsRoyaltyCal = GetIsRoyalty(objExternalTitle_GradeException.IntCode);
        
        #endregion

        return objExternalTitle_GradeException;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetUpdateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }
    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [External_Title] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [External_Title] WHERE  external_title_code = " + obj.IntCode;
    }

    public string GetLastExceptionGrade(int ExternalTitleCode)
    {
        string LastExceptionGrade = string.Empty;
        string strSql = " select grade_name from Grade_Master where grade_code in  "
        + " ( SELECT TOP 1 new_grade_code from Grade_Exception 	WHERE external_title_code = " + ExternalTitleCode + " ORDER by grade_exception_code desc ) ";
        LastExceptionGrade = ProcessScalarReturnString(strSql);

        return LastExceptionGrade;
    }

    //To get Max Grade Code For particular External Title
    public int Get_ExceptionGrade_LastGradeCode(int ExternalTitleCode)
    {
        int ExceptionGrade_LastGradeCode = 0;
        string strSql = " SELECT TOP 1 new_grade_code from Grade_Exception "
        + " WHERE external_title_code = " + ExternalTitleCode + " ORDER by grade_exception_code desc  ";
        ExceptionGrade_LastGradeCode = ProcessScalarDirectly(strSql);

        return ExceptionGrade_LastGradeCode;
    }

    //To get Max Eff. Start Date Code For particular External Title
    public string Get_ExceptionGrade_EffStartDate(int ExternalTitleCode)
    {
        string EffStartDate = string.Empty;
        string strSql = " SELECT MAX(effective_start_date) FROM Grade_Exception WHERE external_title_code = " + ExternalTitleCode + " ";
        DataSet ds = new DataSet();
        ds = ProcessSelect(strSql);
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0][0] != DBNull.Value)
                EffStartDate = Convert.ToDateTime(ds.Tables[0].Rows[0][0]).ToString("dd/MM/yyyy");
        }
        return EffStartDate;
    }

    //To get Deal Max Right Start Date And Right End Date
    public string Get_RightPeriod(int DealMovieCode)
    {
        string RightStartDate = string.Empty;
        string RightEndDate = string.Empty;
        string RightPeriod = string.Empty;
        string strSql = " SELECT MIN(right_start_date) as right_start_date, MAX(right_end_date) as right_end_date FROM Deal_Movie_Rights WHERE deal_movie_code = " + DealMovieCode + " ";
        DataSet ds = new DataSet();
        ds = ProcessSelect(strSql);
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0]["right_start_date"] != DBNull.Value)
            {
                RightStartDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["right_start_date"]).ToString("dd/MM/yyyy");
            }
            if (ds.Tables[0].Rows[0]["right_end_date"] != DBNull.Value)
            {
                RightEndDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["right_end_date"]).ToString("dd/MM/yyyy");
            }
            if (!string.IsNullOrEmpty(RightStartDate) && !string.IsNullOrEmpty(RightEndDate))
            {
                RightPeriod = RightStartDate + "~" + RightEndDate;
            }
        }
        return RightPeriod;
    }

    //Get IsRoyalty Calculated
    public string GetIsRoyalty(int ExternalTitleCode)
    {
        string IsRoyalty = "N";
        string strSql = " SELECT TOP 1 Is_Royalty from Grade_Exception "
        + " WHERE external_title_code = " + ExternalTitleCode + " ORDER by grade_exception_code desc  ";
        IsRoyalty = ProcessScalarReturnString(strSql);

        return IsRoyalty;
    }
}








