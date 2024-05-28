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
/// Summary description for AmortRule
/// </summary>
public class AmortRuleBroker : DatabaseBroker
{
	public AmortRuleBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [amort_rule] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        AmortRule objAmortRule;
		if (obj == null)
		{
			objAmortRule = new AmortRule();
		}
		else
		{
			objAmortRule = (AmortRule)obj;
		}

		objAmortRule.IntCode = Convert.ToInt32(dRow["amort_rule_code"]);
		#region --populate--
		objAmortRule.RuleType = Convert.ToString(dRow["rule_type"]);
		objAmortRule.RuleNo = Convert.ToString(dRow["rule_no"]);
		objAmortRule.RuleDesc = Convert.ToString(dRow["rule_desc"]);
        objAmortRule.DistributionType = Convert.ToString(dRow["distribution_type"]);
        if (dRow["period_for"] != DBNull.Value)   
        objAmortRule.PeriodFor = Convert.ToString(dRow["period_for"]);
        if (dRow["year_type"] != DBNull.Value)   
        objAmortRule.YearType = Convert.ToString(dRow["year_type"]);
        if(dRow["nos"]!=DBNull.Value)   
        objAmortRule.Nos = Convert.ToInt32(dRow["nos"]);
		if (dRow["Inserted_On"] != DBNull.Value)
            objAmortRule.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
		if (dRow["Inserted_By"] != DBNull.Value)
			objAmortRule.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
		if (dRow["Lock_Time"] != DBNull.Value)
            objAmortRule.LockTime = Convert.ToString(dRow["Lock_Time"]);
		if (dRow["Last_Updated_Time"] != DBNull.Value)
            objAmortRule.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
		if (dRow["Last_Action_By"] != DBNull.Value)
			objAmortRule.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objAmortRule.IsActive = Convert.ToString(dRow["Is_Active"]);
		#endregion
		return objAmortRule;
    }


    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		AmortRule objAmortRule = (AmortRule)obj;
       
	  	string sql= "insert into [amort_rule]([rule_type], [rule_no], [rule_desc], [distribution_type], [period_for], [year_type], [nos], [Inserted_On], [Inserted_By],[Last_Updated_Time], [Last_Action_By], [Is_Active])" 
        + " values('" + objAmortRule.RuleType + "', '" + objAmortRule.RuleNo.Trim().Replace("'", "''") + "', '" + objAmortRule.RuleDesc.Trim().Replace("'", "''") + "', '" + objAmortRule.DistributionType + "', '" + objAmortRule.PeriodFor + "', '" + objAmortRule.YearType + "', '" + objAmortRule.Nos + "', GetDate(), '" + objAmortRule.InsertedBy + "', GetDate(), '" + objAmortRule.LastActionBy + "', 'Y');";
        return sql; 
    } 

    public override string GetUpdateSql(Persistent obj)
    {
		AmortRule objAmortRule = (AmortRule)obj;
      	string sql= "update [amort_rule] set [rule_type] = '" + objAmortRule.RuleType + "', [rule_no] = '" + objAmortRule.RuleNo.Trim().Replace("'", "''") + "', [rule_desc] = '" + objAmortRule.RuleDesc.Trim().Replace("'", "''") + "', [distribution_type] = '" + objAmortRule.DistributionType + "', [period_for] = '" + objAmortRule.PeriodFor + "', [year_type] = '" + objAmortRule.YearType + "', [nos] = '" + objAmortRule.Nos + "', [Lock_Time] = Null, [Last_Updated_Time] = GetDate(), [Last_Action_By] = '" + objAmortRule.LastActionBy + "', [Is_Active] = '" + objAmortRule.IsActive + "' where amort_rule_code = '" + objAmortRule.IntCode + "';";
        return sql; 
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		AmortRule objAmortRule = (AmortRule)obj;
        if (objAmortRule.arrAmortRuleDetails.Count > 0)
            DBUtil.DeleteChild("amortruledetails", objAmortRule.arrAmortRuleDetails, objAmortRule.IntCode, (SqlTransaction)objAmortRule.SqlTrans);

		return " DELETE FROM [amort_rule] WHERE amort_rule_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        AmortRule objAmortRule = (AmortRule)obj;
        string sql = " update amort_rule set is_Active='" + objAmortRule.IsActive + "' where amort_rule_code=" + objAmortRule.IntCode;
        return sql;        
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [amort_rule] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [amort_rule] WHERE  amort_rule_code = " + obj.IntCode;
    }

    internal bool IsRuleNoExist(string ruleNo, int ruleCode)
    {
        string strSql = "Select count(*) from Amort_Rule where rule_no= '" + ruleNo.Trim().Replace("'", "''") + "' and amort_rule_code not in('" + ruleCode + "')";
        int Count = Convert.ToInt32(ProcessScalar(strSql));
        if (Count > 0)
        {
            return true;
        }
        return false;
    }

    internal bool IsDupEqlDisAmgRights(int ruleCode)
    {
        
        string strSql = "Select * from Amort_Rule where distribution_type='E' and period_for='A' and amort_rule_code not in('" + ruleCode + "')";
        int Count = Convert.ToInt32(ProcessScalar(strSql));
        if (Count > 0)
        {
            return true;
        }
        return false;
    }

    internal bool IsAmortRuleExist(int ruleCode, int noOfMonth)
    {
        string strSql = "Select * from Amort_Rule where distribution_type='E' and period_for='" + GlobalParams.AmortRulePeriodDefineManually + "' and nos = " + noOfMonth + " and amort_rule_code not in('" + ruleCode + "')";
        int Count = Convert.ToInt32(ProcessScalar(strSql));
        if (Count > 0)
        {
            return true;
        }
        return false;
    }  

    internal bool IsAmortRunRuleExist(string Ruletype, int noOfMonth,int code)
    {

        string strSql = "Select count(*) from Amort_Rule where distribution_type='" + Ruletype + "' and rule_type='R' and nos = " + noOfMonth + " and amort_rule_code not in('" + code + "')";
        int Count = Convert.ToInt32(DatabaseBroker.ProcessScalarDirectly(strSql));
        if (Count > 0)
        {
            return false;
        }
        return true;        
    }

    public int checkrefrence(int Amortrulecode)
    {
        string sql;       
        int count;
        sql = "select count(*)from deal_movie_contents_amort where amort_rule_code=" + Amortrulecode;
        count = ProcessScalarDirectly(sql); 
        if (count > 0)
        {
            return 1;
        }
        return count;

    }


    internal bool IsAmortRuleExistForMulipleChild(int ruleCode, string gridData)
    {
        string[] arrValue = gridData.Split(Convert.ToChar("-"));
        string strSql = "Select amort_rule_code from Amort_Rule where distribution_type='D' and period_for='" + GlobalParams.AmortRulePeriodDefineManually + "' and nos = " + Convert.ToInt32(arrValue[0]) + " and amort_rule_code not in('" + ruleCode + "')";
        DataSet ds = ProcessSelectDirectly(strSql);
        bool res = false;
        if (ds.Tables[0].Rows.Count > 0)
        {
            AmortRule objAmortRule = new AmortRule();
            for (int i = 0; (i < ds.Tables[0].Rows.Count) && (res == false); i++)
            {
                objAmortRule.IntCode = Convert.ToInt32(ds.Tables[0].Rows[i][0]);
                objAmortRule.FetchDeep();
                if (((arrValue.Length - 1) / 3) == objAmortRule.arrAmortRuleDetails.Count)
                {
                    for (int j = 0; j < objAmortRule.arrAmortRuleDetails.Count; j++)
                    {
                        AmortRuleDetails objARM = (AmortRuleDetails)objAmortRule.arrAmortRuleDetails[j];
                        if ((objARM.FromRange == Convert.ToInt32(arrValue[(j * 3) + 1])) && (objARM.ToRange == Convert.ToInt32(arrValue[(j * 3) + 2])) && (objARM.PerCent == Convert.ToDecimal(arrValue[(j * 3) + 3])))
                        {
                            res = true;
                        }
                        else
                        {
                            res = false;
                            break;
                        }
                    }
                }
            }
        }
        return res;
    }

}
