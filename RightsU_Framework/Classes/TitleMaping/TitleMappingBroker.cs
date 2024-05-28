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
/// Summary description for TitleMapping
/// </summary>
public class TitleMappingBroker : DatabaseBroker
{
    public TitleMappingBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Title_Mapping] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TitleMapping objTitleMapping;
        if (obj == null)
        {
            objTitleMapping = new TitleMapping();
        }
        else
        {
            objTitleMapping = (TitleMapping)obj;
        }

        objTitleMapping.IntCode = Convert.ToInt32(dRow["title_mapping_code"]);
        #region --populate--
        if (dRow["external_title_code"] != DBNull.Value)
            objTitleMapping.ExternalTitleCode = Convert.ToInt32(dRow["external_title_code"]);
        if (dRow["deal_moive_code"] != DBNull.Value)
            objTitleMapping.DealMoiveCode = Convert.ToInt32(dRow["deal_moive_code"]);
        if (dRow["effective_start_date"] != DBNull.Value)
            objTitleMapping.EffectiveStartDate = Convert.ToDateTime(dRow["effective_start_date"]);
        objTitleMapping.EffectiveStartDateForMovement = Convert.ToDateTime(getMaxEffectiveStartDate(objTitleMapping.ExternalTitleCode));
        if (dRow["effective_end_date"] != DBNull.Value)
            objTitleMapping.EffectiveEndDate = Convert.ToDateTime(dRow["effective_end_date"]);
        if (dRow["inserted_on"] != DBNull.Value)
            objTitleMapping.InsertedOn = Convert.ToString(dRow["inserted_on"]);
        if (dRow["inserted_by"] != DBNull.Value)
            objTitleMapping.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
        if (dRow["lock_time"] != DBNull.Value)
            objTitleMapping.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objTitleMapping.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objTitleMapping.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
        objTitleMapping.DealTitleName = getDealTitleName(objTitleMapping.DealMoiveCode);
        objTitleMapping.MaxDateFromRoyalty = Convert.ToDateTime((getMaxMonthYearfromRoyalty(objTitleMapping.ExternalTitleCode)==String.Empty?objTitleMapping.EffectiveStartDateForMovement.ToString():(getMaxMonthYearfromRoyalty(objTitleMapping.ExternalTitleCode))));
        #endregion
        return objTitleMapping;
    }

    private string getDealTitleName(int dealMovieCode)
    {
        return ProcessScalarReturnString("select t.english_title from Deal_Movie dm inner join Title t on t.title_code=dm.title_code where deal_movie_code='" + dealMovieCode + "'");
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        TitleMapping objTitleMapping = (TitleMapping)obj;

        string EffectiveEndDate = objTitleMapping.EffectiveEndDate == DateTime.MinValue ? "Null" : "'" + objTitleMapping.EffectiveEndDate + "'";

        return "insert into [Title_Mapping]([external_title_code], [deal_moive_code], [effective_start_date], [effective_end_date], [inserted_on], [inserted_by], [lock_time], [last_updated_time], [last_action_by]) values('" + objTitleMapping.ExternalTitleCode + "', '" + objTitleMapping.DealMoiveCode + "', '" + objTitleMapping.EffectiveStartDate + "', " + EffectiveEndDate + ", GetDate(), '" + objTitleMapping.InsertedBy + "',  Null, GetDate(), '" + objTitleMapping.InsertedBy + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        TitleMapping objTitleMapping = (TitleMapping)obj;
        return "update [Title_Mapping] set [external_title_code] = '" + objTitleMapping.ExternalTitleCode + "', [deal_moive_code] = '" + objTitleMapping.DealMoiveCode + "', [effective_start_date] = '" + objTitleMapping.EffectiveStartDate + "', [effective_end_date] = '" + objTitleMapping.EffectiveEndDate + "', [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '" + objTitleMapping.LastActionBy + "' where title_mapping_code = '" + objTitleMapping.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        TitleMapping objTitleMapping = (TitleMapping)obj;

        return " DELETE FROM [Title_Mapping] WHERE title_mapping_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        TitleMapping objTitleMapping = (TitleMapping)obj;
        return "Update [Title_Mapping] set Is_Active='" + objTitleMapping.Is_Active + "',lock_time=null, last_updated_time= getdate() where title_mapping_code = '" + objTitleMapping.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Title_Mapping] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Title_Mapping] WHERE  title_mapping_code = " + obj.IntCode;
    }
    public void insertMovieDealCode(int DealMovieCode, int ExternalTitleCode, SqlTransaction sqlTrans)
    {
        SqlTransaction trans = (SqlTransaction)sqlTrans;
        string str = "update [External_Title] set [deal_movie_code] = '" + DealMovieCode + "' where external_title_code = '" + ExternalTitleCode + "'";
        ProcessNonQuery(str, false, ref trans);
    }
    public DateTime DateofDealsign(int DealMovieCode)
    {
        DataSet ds = new DataSet();
        string strstring = "(select dm.deal_movie_code,t.english_title +' ['+ d.deal_no+']' 'title_name' , d.deal_signed_date from Deal d inner join Deal_Movie dm on dm.deal_code= d.deal_code inner join Title t on t.title_code=dm.title_code where dm.deal_movie_code = '" + DealMovieCode + "')";
        ds = DatabaseBroker.ProcessSelectDirectly(strstring);
        string dealDate = "";
        if (ds.Tables[0].Rows.Count > 0)

            dealDate = (ds.Tables[0].Rows[0][2]).ToString();
        return Convert.ToDateTime(dealDate);
    }

    public string getMaxEffectiveStartDate(int externalTitleCode)
    {
        return ProcessScalarReturnString("select MAX(effective_start_date) from Title_Mapping where external_title_code =" + externalTitleCode);
    }

    public void insertEffectiveEndDate(DateTime EffectiveEndDate, int ExternalTitleCode)
    {
        string str = "update[Title_Mapping] set [effective_end_date] = '" + EffectiveEndDate + "' where effective_end_date is Null  and external_title_code = '" + ExternalTitleCode + "'";
        ProcessNonQuery(str, false);
    }

    public string getMaxMonthYearfromRoyalty(int ExternalTitleCode)
    {
        return ProcessScalarReturnString("select MAX(Month_Year) from Monthly_Sales_Royalty where external_title_code=" + ExternalTitleCode + "");
    }
}
