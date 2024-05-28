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
/// Summary description for ExternalTitle
/// </summary>
public class ExternalTitleBroker : DatabaseBroker
{
    public ExternalTitleBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [External_Title] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ExternalTitle objExternalTitle;
        if (obj == null)
        {
            objExternalTitle = new ExternalTitle();
        }
        else
        {
            objExternalTitle = (ExternalTitle)obj;
        }

        objExternalTitle.IntCode = Convert.ToInt32(dRow["external_title_code"]);
        #region --populate--
        objExternalTitle.TitleName = Convert.ToString(dRow["TitleName"]);
        objExternalTitle.MasterFormat = Convert.ToString(dRow["MasterFormat"]);
        if (dRow["ReleaseDate"] != DBNull.Value)
            objExternalTitle.ReleaseDate = Convert.ToDateTime(dRow["ReleaseDate"]);
        if (dRow["RightsExpiry"] != DBNull.Value)
            objExternalTitle.RightsExpiry = Convert.ToDateTime(dRow["RightsExpiry"]);
        objExternalTitle.TitleType = Convert.ToString(dRow["Title_Type"]);
        objExternalTitle.BoxSingle = Convert.ToString(dRow["Box_Single"]);
        objExternalTitle.SAPInternalOrder = Convert.ToString(dRow["SAPInternalOrder"]);
        objExternalTitle.CompleteTitleName = CompleteTitleName(objExternalTitle.IntCode);

        if (dRow["deal_movie_code"] != DBNull.Value)
            objExternalTitle.DealMovieCode = Convert.ToInt32(dRow["deal_movie_code"]);
        if (objExternalTitle.DealMovieCode > 0)
        {
            objExternalTitle.DealTitleName = getDealTitleName(objExternalTitle.DealMovieCode);
            objExternalTitle.DealNo = getDealNo(objExternalTitle.DealMovieCode);
        }
        objExternalTitle.TitlePromotionCode = Convert.ToInt32(getMaxTitlePromotionCode(objExternalTitle.IntCode));
        objExternalTitle.EffectiveStDt = getEffStDt(objExternalTitle.IntCode);

        #endregion
        return objExternalTitle;
    }
    private string getDealTitleName(int dealMovieCode)
    {
        return ProcessScalarReturnString("select t.english_title from Deal_Movie dm inner join Title t on t.title_code=dm.title_code where deal_movie_code='" + dealMovieCode + "'");
    }
    private string getEffStDt(int extTitleCode)
    {
        return ProcessScalarReturnString("select CONVERT(varchar,Max(tm.effective_start_date),103) from External_Title et inner join  Title_Mapping tm on et.external_title_code=tm.external_title_code where et.external_title_code='" + extTitleCode + "'");
    }
    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        ExternalTitle objExternalTitle = (ExternalTitle)obj;
        return "insert into [External_Title]([TitleName], [MasterFormat], [ReleaseDate], [RightsExpiry], [Title_Type], [Box_Single], [SAPInternalOrder], [deal_movie_code]) values('" + objExternalTitle.TitleName.Trim().Replace("'", "''") + "', '" + objExternalTitle.MasterFormat.Trim().Replace("'", "''") + "', '" + objExternalTitle.ReleaseDate + "', '" + objExternalTitle.RightsExpiry + "', '" + objExternalTitle.TitleType.Trim().Replace("'", "''") + "', '" + objExternalTitle.BoxSingle.Trim().Replace("'", "''") + "', '" + objExternalTitle.SAPInternalOrder.Trim().Replace("'", "''") + "', '" + objExternalTitle.DealMovieCode + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        ExternalTitle objExternalTitle = (ExternalTitle)obj;
        return "update [External_Title] set [TitleName] = '" + objExternalTitle.TitleName.Trim().Replace("'", "''") + "', [MasterFormat] = '" + objExternalTitle.MasterFormat.Trim().Replace("'", "''") + "', [ReleaseDate] = '" + objExternalTitle.ReleaseDate + "', [RightsExpiry] = '" + objExternalTitle.RightsExpiry + "', [Title_Type] = '" + objExternalTitle.TitleType.Trim().Replace("'", "''") + "', [Box_Single] = '" + objExternalTitle.BoxSingle.Trim().Replace("'", "''") + "', [SAPInternalOrder] = '" + objExternalTitle.SAPInternalOrder.Trim().Replace("'", "''") + "', [deal_movie_code] = '" + objExternalTitle.DealMovieCode + "' where external_title_code = '" + objExternalTitle.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        ExternalTitle objExternalTitle = (ExternalTitle)obj;

        return " DELETE FROM [External_Title] WHERE external_title_code = " + obj.IntCode;
    }
    public override string GetActivateDeactivateSql(Persistent obj)
    {
        ExternalTitle objExternalTitle = (ExternalTitle)obj;
        return "Update [External_Title] set Is_Active='" + objExternalTitle.Is_Active + "',lock_time=null, last_updated_time= getdate() where external_title_code = '" + objExternalTitle.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [External_Title] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [External_Title] WHERE  external_title_code = " + obj.IntCode;
    }

    private string CompleteTitleName(int code)
    {
        DataSet ds = new DataSet();

        string strSelect = "(select TitleName +''+  (case Title_Type when 'O' then ' - Original - ' when 'D' then ' - Dubbed - ' end) +''+ MasterFormat as 'Title_Type' from External_Title where external_title_code =" + code + ")";
        ds = DatabaseBroker.ProcessSelectDirectly(strSelect);
        string strCount = "0";

        if (ds.Tables[0].Rows.Count > 0)
            strCount = ds.Tables[0].Rows[0][0].ToString();
        return strCount;
    }

    public void BindDDLForDealTitleName(DropDownList ddl)
    {
        DataSet ds = new DataSet();
        string strstring = "(select dm.deal_movie_code,t.english_title +' ['+ d.deal_no+']' 'title_name' ,d.deal_signed_date from Deal d inner join Deal_Movie dm on dm.deal_code= d.deal_code inner join Title t on t.title_code=dm.title_code and  d.is_active='Y' and d.is_archive='N' and d.deal_workflow_status='A' and d.status='O')order by title_name asc";
        ds = DatabaseBroker.ProcessSelectDirectly(strstring);
        if (ds.Tables[0].Rows.Count > 0)
        {
            ddl.DataSource = ds;
            ddl.DataValueField = ds.Tables[0].Columns[0].ColumnName.ToString();
            ddl.DataTextField = ds.Tables[0].Columns[1].ColumnName.ToString();
            ddl.DataBind();
        }
        ddl.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Please Select DealTitle --", "0"));
    }
    public string getMaxTitlePromotionCode(int ExtTitleCode)
    {
        return ProcessScalarReturnString("select isnull(MAX(title_promotion_code),0) from Title_Promotion where external_title_code='" + ExtTitleCode + "' and effective_end_date is null");
    }

    private string getDealNo(int code)
    {
        DataSet ds = new DataSet();
        string str = "select deal_no from deal where deal_code in(select deal_code from deal_movie where deal_movie_code ='" + code + "')";

        ds = DatabaseBroker.ProcessSelectDirectly(str);
        string strCount = "0";

        if (ds.Tables[0].Rows.Count > 0)
            strCount = ds.Tables[0].Rows[0][0].ToString();
        return " [" + strCount + "]";

    }
}
