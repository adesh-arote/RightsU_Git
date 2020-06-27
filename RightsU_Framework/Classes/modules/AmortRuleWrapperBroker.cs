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
/// Summary description for DrafLfa
/// </summary>
public class AmortRuleWrapperBroker : DatabaseBroker
{
    public AmortRuleWrapperBroker () { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        #region ----------------- Old Query -----------------
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
        //string sqlStr = "  select a.deal_movie_code, cost_type_name,a.cost_type_code,a.amount,ar.amort_rule_code,ar.rule_no,a.deal_movie_content_code," +
        // " dmcca.deal_movie_contents_amort_code from ( " +
        // " SELECT dmc.deal_movie_code,c.cost_type_name,c.cost_type_code,ct.amount," +
        // " max(dmc.deal_movie_content_code ) deal_movie_content_code  FROM deal_movie_cost_costtype ct  " +
        // " INNER JOIN Deal_Movie_Contents dmc on dmc.deal_movie_code = ct.deal_movie_code  " +
        // " INNER JOIN deal_movie dm on dm.deal_movie_code = dmc.deal_movie_code  " +
        // " INNER JOIN Cost_Type c on c.cost_type_code = ct.cost_type_code  " +
        // " WHERE 1=1   " + strSearchString +
        // " group by dmc.deal_movie_code,c.cost_type_name,c.cost_type_code,ct.amount )a" +
        // " LEFT OUTER join Deal_movie_content_channel dmcc on dmcc.deal_movie_content_code=a.deal_movie_content_code  " +
        // " AND dmcc.Cost_type_code = a.cost_type_code  " +
        // " LEFT OUTER JOIN Deal_Movie_Contents_Amort dmcca on dmcca.Deal_movie_content_channel_code=dmcc.Deal_movie_content_channel_code  " +
        // " left outer join Amort_Rule AR on AR.amort_rule_code=dmcca.amort_rule_code  " +
        // " where dmcca.system_end_date is null  order by 2  ";

        #endregion

        #region ----------------- New Query -----------------
        /*Changed by Dada 20Dec2012*/

        string sqlStr = " select a.deal_movie_code, cost_type_name, a.cost_type_code, a.amount, ar.amort_rule_code, ar.rule_no, "
        + " a.deal_movie_content_code, dmcca.deal_movie_contents_amort_code "
        + " from (  "
        + " SELECT a.deal_movie_code,a.cost_type_name,a.cost_type_code,a.amount , a.Maxdeal_movie_content_code as deal_movie_content_code "
        + " FROM 	( "
        + " SELECT dmc.deal_movie_code, c.cost_type_name, c.cost_type_code, ct.amount, "
        + " MAX(dmcctype.deal_movie_content_code) OVER (PARTITION BY dmc.deal_movie_code,c.cost_type_name,c.cost_type_code,ct.amount ) AS Maxdeal_movie_content_code "
        + " FROM deal_movie_cost_costtype ct   "
        + " INNER JOIN Deal_Movie_Contents dmc on dmc.deal_movie_code = ct.deal_movie_code   "
        + " INNER JOIN deal_movie dm on dm.deal_movie_code = dmc.deal_movie_code   "
        + " INNER JOIN Cost_Type c on c.cost_type_code = ct.cost_type_code   "
        + " INNER JOIN Deal_Movie_Contents_CostType dmcctype on dmcctype.Deal_Movie_Content_Code = dmc.deal_movie_content_code "
        + " AND dmcctype.CostTypeCode=C.cost_type_code "
        + " WHERE 1=1    AND dmcctype.Amount > 0 "
        + strSearchString
        + "	) as a "
        + " group by a.deal_movie_code,a.cost_type_name,a.cost_type_code,a.amount , a.Maxdeal_movie_content_code "
        + " )a LEFT OUTER join Deal_movie_content_channel dmcc on dmcc.deal_movie_content_code=a.deal_movie_content_code   "
        + " AND dmcc.Cost_type_code = a.cost_type_code   "
        + " LEFT OUTER JOIN Deal_Movie_Contents_Amort dmcca on dmcca.Deal_movie_content_channel_code=dmcc.Deal_movie_content_channel_code   "
        + " left outer join Amort_Rule AR on AR.amort_rule_code=dmcca.amort_rule_code   "
        + " where dmcca.system_end_date is null  order by 2  ";

        #endregion

        return sqlStr;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
		AmortRuleWrapper objAmortRuleWrapper = (AmortRuleWrapper)obj;
        if (obj == null)
        {
            objAmortRuleWrapper = new  AmortRuleWrapper();
        }
        else
        {
            objAmortRuleWrapper = ( AmortRuleWrapper)obj;
        }
        
        #region --populate--
		if (dRow["deal_movie_code"] != DBNull.Value)
			objAmortRuleWrapper.DealMovieCode = Convert.ToInt32(dRow["deal_movie_code"]);
		if (dRow["cost_type_name"] != DBNull.Value)
			objAmortRuleWrapper.costTypeName = Convert.ToString(dRow["cost_type_name"]);
		if (dRow["cost_type_code"] != DBNull.Value)
			objAmortRuleWrapper.CostTypeCode = Convert.ToInt32(dRow["cost_type_code"]);
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

        if (ValidForChangeRule(objAmortRuleWrapper.DealMovieCode, objAmortRuleWrapper.CostTypeCode)=="")
            objAmortRuleWrapper.canChangeAmortRule = "Y";
        else
            objAmortRuleWrapper.canChangeAmortRule = "N";
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
        AmortRuleWrapper objAmortRuleWrapper = (AmortRuleWrapper)obj;
		string strSql = "exec usp_insert_AmortWrapper @deal_movie_code='" + objAmortRuleWrapper.DealMovieCode + "',@CostTypeCode='" + objAmortRuleWrapper.CostTypeCode + "' ,@AmortCode ='" + objAmortRuleWrapper.amortRuleCode + "'  ";
		
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		AmortRuleWrapper objAmortRuleWrapper = (AmortRuleWrapper)obj;
		string strSql = "exec usp_update_AmortWrapper 	@deal_movie_code ='" + objAmortRuleWrapper.DealMovieCode + "',	@Cost_type_code='" + objAmortRuleWrapper.CostTypeCode + "' ,@AMORT_RULE_CODE='" + objAmortRuleWrapper.amortRuleCode + "' ";
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
        return " SELECT Count(*) FROM [Draft_LFA] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Draft_LFA] WHERE  draft_lfa_code = " + obj.IntCode;//feach with deal code

    }


    public string ValidForChangeRule(int DealMovieCode, int Cost_Type_code)
    {
        //string SqlStr = "select top 1 amort_amount from Deal_movie_content_channel where Deal_movie_content_code='" + deal_movie_content_Code + "' and Cost_type_code='" + Cost_Type_code + "' and amort_amount>0";
        string SqlStr = "select top 1 dmcc.amort_amount from Deal_movie_content_channel dmcc inner join Deal_Movie_Contents dmc on dmc.deal_movie_content_code=dmcc.Deal_movie_content_code "+
             " where dmc.deal_movie_code='" + DealMovieCode + "'   and dmcc.Cost_type_code='" + Cost_Type_code + "' and dmcc.amort_amount>0";
        return  ProcessScalarReturnString(SqlStr);

    }

}
