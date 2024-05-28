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
using System.Text;
/// <summary>
/// Summary description for DrafLfa
/// </summary>
public class AmortRuleWrapperFromatShowBroker : DatabaseBroker
{
    public AmortRuleWrapperFromatShowBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        //string sqlStr = " SELECT distinct dm.deal_movie_code,c.cost_type_name, ct.cost_type_code,ct.Amount,dmcca.amort_rule_code, AR.rule_no 
        //                " ,MIN(dmc.deal_movie_content_code)over(partition by dm.deal_movie_code,c.cost_type_name, ct.cost_type_code,ct.Amount,dmcca.amort_rule_code, AR.rule_no)deal_movie_content_code  " +
        //                ",isnull(MIN(dmcca.deal_movie_contents_amort_code)over(partition by dm.deal_movie_code,c.cost_type_name, ct.cost_type_code,ct.Amount,dmcca.amort_rule_code, AR.rule_no),0) deal_movie_contents_amort_code " +
        //                " FROM deal_movie_cost_costtype ct "+
        //                " INNER JOIN Deal_Movie_Contents dmc on dmc.deal_movie_code = ct.deal_movie_code "+
        //                " INNER JOIN deal_movie dm on dm.deal_movie_code = dmc.deal_movie_code "+
        //                " INNER JOIN Cost_Type c on c.cost_type_code = ct.cost_type_code "+
        //                " LEFT OUTER join Deal_movie_content_channel dmcc on dmcc.deal_movie_content_code=dmc.deal_movie_content_code " +
        //                " AND dmcc.Cost_type_code = ct.cost_type_code "+
        //                " LEFT OUTER JOIN Deal_Movie_Contents_Amort dmcca on dmcca.Deal_movie_content_channel_code=dmcc.Deal_movie_content_channel_code "+
        //                " left outer join Amort_Rule AR on AR.amort_rule_code=dmcca.amort_rule_code "+
        //                " WHERE 1=1  and dmcca.system_end_date is null  " + strSearchString; 

        /*Changed by tushar 20Aug2012*/
        StringBuilder sqlStr =new StringBuilder();

        sqlStr.Append("  select dm.deal_movie_code,p.paf_code,p.paf_no ,Dmc.deal_movie_content_code,a.amort_rule_code,ar.rule_no ");
            sqlStr.Append(" ,deal_movie_contents_amort_code,p.amount from Deal_Movie dm ");
            sqlStr.Append("  inner join Deal_Movie_PAF_Detail paf on dm.deal_movie_code=paf.deal_movie_code ");
            sqlStr.Append("  inner join PAF p on p.paf_code=paf.paf_code ");
            sqlStr.Append("  left outer join Deal_Movie_Contents dmc on dmc.deal_movie_code=dm.deal_movie_code ");
            sqlStr.Append("  left outer join Deal_movie_content_channel dmcc on dmcc.Deal_movie_content_code=dmc.deal_movie_content_code and p.paf_code=dmcc.paf_code ");
            sqlStr.Append("  left outer join Deal_Movie_Contents_Amort a on a.Deal_movie_content_channel_code=dmcc.Deal_movie_content_channel_code ");
            sqlStr.Append("  left outer join Amort_Rule ar on ar.amort_rule_code=a.amort_rule_code ");
            sqlStr.Append("  where   a.system_end_date is null and 1=1 " + strSearchString);
            


        return Convert.ToString(sqlStr);
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        AmortRuleWrapperFormatShow objAmortRuleWrapper = (AmortRuleWrapperFormatShow)obj;
        if (obj == null)
        {
            objAmortRuleWrapper = new AmortRuleWrapperFormatShow();
        }
        else
        {
            objAmortRuleWrapper = (AmortRuleWrapperFormatShow)obj;
        }

        #region --populate--
        if (dRow["deal_movie_code"] != DBNull.Value)
            objAmortRuleWrapper.DealMovieCode = Convert.ToInt32(dRow["deal_movie_code"]);
        if (dRow["paf_no"] != DBNull.Value)
            objAmortRuleWrapper.PAFName = Convert.ToString(dRow["paf_no"]);
        if (dRow["paf_code"] != DBNull.Value)
            objAmortRuleWrapper.PAFCode = Convert.ToInt32(dRow["paf_code"]);
        if (dRow["Amount"] != DBNull.Value)
            objAmortRuleWrapper.amount = Convert.ToDecimal(dRow["Amount"]);
        if (dRow["amort_rule_code"] != DBNull.Value)
            objAmortRuleWrapper.amortRuleCode = Convert.ToInt32(dRow["amort_rule_code"]);
        if (dRow["deal_movie_content_code"] != DBNull.Value)
            objAmortRuleWrapper.deal_movie_content_code = Convert.ToInt32(dRow["deal_movie_content_code"]);
        if (dRow["deal_movie_contents_amort_code"] != DBNull.Value)
            objAmortRuleWrapper.deal_movie_contents_amort_code = Convert.ToInt32(dRow["deal_movie_contents_amort_code"]);
        if (dRow["rule_no"] != DBNull.Value)
            objAmortRuleWrapper.amortRuleText = Convert.ToString(dRow["rule_no"]);
        /*Added by tushar 20/08/2012 to validate change rule*/

        
        /*Added by tushar 20/08/2012 to validate change rule*/
        //select top 1 amort_amount from Deal_movie_content_channel where Deal_movie_content_code=2 and Cost_type_code=0 and amort_amount>0


        #endregion
        return objAmortRuleWrapper;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        AmortRuleWrapperFormatShow objAmortRuleWrapper = (AmortRuleWrapperFormatShow)obj;
        string strSql = "exec usp_insert_AmortWrapper_format_show @deal_movie_code='" + objAmortRuleWrapper.DealMovieCode + "', @paf_code='" + objAmortRuleWrapper.PAFCode + "' ,@AmortCode ='" + objAmortRuleWrapper.amortRuleCode + "'  ";

        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        AmortRuleWrapperFormatShow objAmortRuleWrapper = (AmortRuleWrapperFormatShow)obj;
        string strSql = "exec usp_update_AmortWrapper_format_show 	@deal_movie_code ='" + objAmortRuleWrapper.DealMovieCode + "',	@paf_code='" + objAmortRuleWrapper.PAFCode + "' ,@AMORT_RULE_CODE='" + objAmortRuleWrapper.amortRuleCode + "' ";
        return strSql;
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
        return " " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " " + obj.IntCode;//feach with deal code

    }


    public string ValidForChangeRule(int DealMovieCode, int Cost_Type_code)
    {
        //string SqlStr = "select top 1 amort_amount from Deal_movie_content_channel where Deal_movie_content_code='" + deal_movie_content_Code + "' and Cost_type_code='" + Cost_Type_code + "' and amort_amount>0";
        string SqlStr = "";
        return ProcessScalarReturnString(SqlStr);

    }

}
