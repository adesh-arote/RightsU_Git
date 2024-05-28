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
/// Summary description for AmortRuleDetails
/// </summary>
public class AmortRuleDetailsBroker : DatabaseBroker
{
	public AmortRuleDetailsBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [amort_rule_details] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        AmortRuleDetails objAmortRuleDetails;
		if (obj == null)
		{
			objAmortRuleDetails = new AmortRuleDetails();
		}
		else
		{
			objAmortRuleDetails = (AmortRuleDetails)obj;
		}

        objAmortRuleDetails.IntCode = Convert.ToInt32(dRow["amort_rule_details_code"]);
		#region --populate--
		if (dRow["amort_rule_code"] != DBNull.Value)
			objAmortRuleDetails.AmortRuleCode = Convert.ToInt32(dRow["amort_rule_code"]);
        objAmortRuleDetails.FromRange = Convert.ToInt32(dRow["from_range"]);
        objAmortRuleDetails.ToRange = Convert.ToInt32(dRow["to_range"]);
        if (dRow["per_cent"] != DBNull.Value)   
        objAmortRuleDetails.PerCent = Convert.ToDecimal(dRow["per_cent"]);
        if (dRow["month"] != DBNull.Value)   
        objAmortRuleDetails.Month = Convert.ToInt32(dRow["month"]);
        if (dRow["year"] != DBNull.Value)   
        objAmortRuleDetails.Year = Convert.ToInt32(dRow["year"]);
        if (dRow["or_flag"] != DBNull.Value)   
        objAmortRuleDetails.OrFlag = Convert.ToString(dRow["or_flag"]);
        if (dRow["end_of_year"] != DBNull.Value)
            objAmortRuleDetails.EndofYear = Convert.ToInt32(dRow["end_of_year"]);
        if (dRow["Actual_year"] != DBNull.Value)
            objAmortRuleDetails.Actual_year = Convert.ToInt32(dRow["Actual_year"]);
        if (dRow["Actual_month"] != DBNull.Value)
            objAmortRuleDetails.Actual_month = Convert.ToInt32(dRow["Actual_month"]);     
        //if (dRow["Inserted_On"] != DBNull.Value)
        //    objAmortRuleDetails.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        //if (dRow["Inserted_By"] != DBNull.Value)
        //    objAmortRuleDetails.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        //if (dRow["Lock_Time"] != DBNull.Value)
        //    objAmortRuleDetails.LockTime = Convert.ToString(dRow["Lock_Time"]);
        //if (dRow["Last_Updated_Time"] != DBNull.Value)
        //    objAmortRuleDetails.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        //if (dRow["Last_Action_By"] != DBNull.Value)
        //    objAmortRuleDetails.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        //objAmortRuleDetails.IsActive = Convert.ToChar(dRow["Is_Active"]);
		#endregion
		return objAmortRuleDetails;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }


    public override string GetInsertSql(Persistent obj)
    {
		AmortRuleDetails objAmortRuleDetails = (AmortRuleDetails)obj;
        string sql = "insert into [amort_rule_details]([amort_rule_code], [from_range], [to_range], [per_cent], [month], [year], [or_flag],end_of_year,Actual_year,Actual_month) "
                    + " values('" + objAmortRuleDetails.AmortRuleCode + "', '" + objAmortRuleDetails.FromRange + "', '" + objAmortRuleDetails.ToRange + "', '" + objAmortRuleDetails.PerCent + "', '" + objAmortRuleDetails.Month + "', '" + objAmortRuleDetails.Year + "', '" + objAmortRuleDetails.OrFlag + "','" + objAmortRuleDetails.EndofYear + "','" + objAmortRuleDetails.Actual_year + "','" + objAmortRuleDetails.Actual_month + "');";
        return sql; 
    }

    public override string GetUpdateSql(Persistent obj)
    {
		AmortRuleDetails objAmortRuleDetails = (AmortRuleDetails)obj;
        return "update [amort_rule_details] set [amort_rule_code] = '" + objAmortRuleDetails.AmortRuleCode + "', [from_range] = '" + objAmortRuleDetails.FromRange + "', [to_range] = '" + objAmortRuleDetails.ToRange + "', [per_cent] = '" + objAmortRuleDetails.PerCent + "', [month] = '" + objAmortRuleDetails.Month + "', [year] = '" + objAmortRuleDetails.Year + "', [or_flag] = '" + objAmortRuleDetails.OrFlag + "',end_of_year='" + objAmortRuleDetails.EndofYear + "',Actual_year='" + objAmortRuleDetails.Actual_year + "',Actual_month='" + objAmortRuleDetails.Actual_month + "' where amort_rule_details_code = '" + objAmortRuleDetails.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		AmortRuleDetails objAmortRuleDetails = (AmortRuleDetails)obj;

        return " DELETE FROM [amort_rule_details] WHERE amort_rule_details_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [amort_rule_details] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [amort_rule_details] WHERE  amort_rule_details_code = " + obj.IntCode;
    }  
}
