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
/// Summary description for GradeException
/// </summary>
public class GradeExceptionBroker : DatabaseBroker
{
    public GradeExceptionBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Grade_Exception] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        GradeException objGradeException;
        if (obj == null)
        {
            objGradeException = new GradeException();
        }
        else
        {
            objGradeException = (GradeException)obj;
        }

        objGradeException.IntCode = Convert.ToInt32(dRow["grade_exception_code"]);
        #region --populate--
        if (dRow["deal_code"] != DBNull.Value)
            objGradeException.DealCode = Convert.ToInt32(dRow["deal_code"]);
        if (dRow["external_title_code"] != DBNull.Value)
            objGradeException.ExternalTitleCode = Convert.ToInt32(dRow["external_title_code"]);
        if (dRow["last_grade_code"] != DBNull.Value)
            objGradeException.LastGradeCode = Convert.ToInt32(dRow["last_grade_code"]);
        if (dRow["effective_start_date"] != DBNull.Value)
            objGradeException.EffectiveStartDate = Convert.ToDateTime(dRow["effective_start_date"]).ToString("dd/MM/yyyy");
        if (dRow["effective_end_date"] != DBNull.Value)
            objGradeException.EffectiveEndDate = Convert.ToDateTime(dRow["effective_end_date"]).ToString("dd/MM/yyyy");
        if (dRow["new_grade_code"] != DBNull.Value)
            objGradeException.NewGradeCode = Convert.ToInt32(dRow["new_grade_code"]);
        objGradeException.IsRoyalty = Convert.ToString(dRow["is_royalty"]);

        if (dRow["inserted_on"] != DBNull.Value)
            objGradeException.InsertedOn = Convert.ToString(dRow["inserted_on"]);
        if (dRow["inserted_by"] != DBNull.Value)
            objGradeException.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
        if (dRow["lock_time"] != DBNull.Value)
            objGradeException.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objGradeException.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objGradeException.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
        #endregion
        return objGradeException;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        GradeException objGradeException = (GradeException)obj;

        string strSql = "";
        strSql = " UPDATE Grade_Exception SET "
        + " effective_end_date = dateadd(d,-1, (Select dbo.fn_CreateDate (" + objGradeException.EffYear + "," + objGradeException.EffMonth + ",1)) )	"
        + " WHERE grade_exception_code in "
        + " ( SELECT MAX(grade_exception_code) from Grade_Exception WHERE external_title_code = " + objGradeException.ExternalTitleCode + "  ) ";

        strSql += " insert into [Grade_Exception]([deal_code], [external_title_code], [last_grade_code],  "
        + " [effective_start_date], [new_grade_code], [is_royalty], "
        + " [inserted_on], [inserted_by], [lock_time], [last_updated_time], [last_action_by]) "
        + " values "
        + " ('" + objGradeException.DealCode + "', '" + objGradeException.ExternalTitleCode + "', "
        + " '" + objGradeException.LastGradeCode + "', "
            //+ " ( SELECT new_grade_code from Grade_Exception WHERE external_title_code = " + objGradeException.ExternalTitleCode + " ORDER by grade_exception_code desc )) ,"
        + " (Select dbo.fn_CreateDate (" + objGradeException.EffYear + "," + objGradeException.EffMonth + ",1)) , "
        + " '" + objGradeException.NewGradeCode + "', "
        + " '" + objGradeException.IsRoyalty.Trim().Replace("'", "''") + "', GetDate(), "
        + " '" + objGradeException.InsertedBy + "',  Null, GetDate(), '" + objGradeException.InsertedBy + "'); ";

        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        GradeException objGradeException = (GradeException)obj;
        string strSql = " update [Grade_Exception] set [deal_code] = '" + objGradeException.DealCode + "', "
        + " [external_title_code] = '" + objGradeException.ExternalTitleCode + "', "
        + " [last_grade_code] = '" + objGradeException.LastGradeCode + "', [effective_start_date] = '" + objGradeException.EffectiveStartDate + "',  "
        + " [effective_end_date] = '" + objGradeException.EffectiveEndDate + "', [new_grade_code] = '" + objGradeException.NewGradeCode + "', "
        + " [is_royalty] = '" + objGradeException.IsRoyalty.Trim().Replace("'", "''") + "', [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '" + objGradeException.LastActionBy + "'  "
        + "  where grade_exception_code = '" + objGradeException.IntCode + "';";
        return strSql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        GradeException objGradeException = (GradeException)obj;

        return " DELETE FROM [Grade_Exception] WHERE grade_exception_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        GradeException objGradeException = (GradeException)obj;
        return "Update [Grade_Exception] set Is_Active='" + objGradeException.Is_Active + "',lock_time=null, last_updated_time= getdate() where grade_exception_code = '" + objGradeException.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Grade_Exception] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Grade_Exception] WHERE  grade_exception_code = " + obj.IntCode;
    }
}
