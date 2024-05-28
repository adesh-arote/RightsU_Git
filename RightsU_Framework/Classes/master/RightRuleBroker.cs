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
/// Summary description for RightRule
/// </summary>
public class RightRuleBroker : DatabaseBroker
{
    public RightRuleBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [right_rule] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RightRule objRightRule;
        if (obj == null)
        {
            objRightRule = new RightRule();
        }
        else
        {
            objRightRule = (RightRule)obj;
        }

        objRightRule.IntCode = Convert.ToInt32(dRow["right_rule_code"]);
        #region --populate--
        objRightRule.RightRuleName = Convert.ToString(dRow["right_rule_name"]);
        if (dRow["start_time"] != DBNull.Value)
            objRightRule.StartTime = Convert.ToString(dRow["start_time"]);
        if (dRow["play_per_day"] != DBNull.Value)
            objRightRule.PlayPerDay = Convert.ToInt32(dRow["play_per_day"]);
        if (dRow["duration_of_day"] != DBNull.Value)
            objRightRule.DurationOfDay = Convert.ToInt32(dRow["duration_of_day"]);
        if (dRow["no_of_repeat"] != DBNull.Value)
            objRightRule.NoOfRepeat = Convert.ToInt32(dRow["no_of_repeat"]);
        if (dRow["inserted_on"] != DBNull.Value)
            objRightRule.InsertedOn = Convert.ToString(dRow["inserted_on"]);
        if (dRow["inserted_by"] != DBNull.Value)
            objRightRule.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
        if (dRow["lock_time"] != DBNull.Value)
            objRightRule.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objRightRule.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objRightRule.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
        if (dRow["Short_Key"] != DBNull.Value)
            objRightRule.Short_Key = Convert.ToString(dRow["Short_Key"]);
        if (dRow["IS_First_Air"] != DBNull.Value)
            objRightRule.IS_First_Air = Convert.ToBoolean(dRow["IS_First_Air"]);
        objRightRule.Is_Active = Convert.ToString(dRow["is_active"]);
        #endregion
        return objRightRule;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        RightRule objRightRule = (RightRule)obj;
        return DBUtil.IsDuplicate(myConnection, objRightRule.tableName, "right_rule_name", objRightRule.RightRuleName, objRightRule.pkColName, objRightRule.IntCode, "Right Rule Record Already Exists", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        RightRule objRightRule = (RightRule)obj;
        return "insert into [right_rule]([right_rule_name], [start_time], [play_per_day], [duration_of_day], [no_of_repeat], [inserted_on], [inserted_by], [lock_time], [last_updated_time], [last_action_by], [is_active],[IS_First_Air],[Short_Key]) values(N'" + objRightRule.RightRuleName.Trim().Replace("'", "''") + "', '" + objRightRule.StartTime + "', '" + objRightRule.PlayPerDay + "', '" + objRightRule.DurationOfDay + "', '" + objRightRule.NoOfRepeat + "', GetDate(), '" + objRightRule.InsertedBy + "',  Null, GetDate(), '" + objRightRule.InsertedBy + "', '" + objRightRule.Is_Active + "','"+objRightRule.IS_First_Air+"',N'"+objRightRule.Short_Key+"');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        RightRule objRightRule = (RightRule)obj;
        return "update [right_rule] set [right_rule_name] = N'" + objRightRule.RightRuleName.Trim().Replace("'", "''") + "', [start_time] = '" + objRightRule.StartTime + "', [play_per_day] = '" + objRightRule.PlayPerDay + "', [duration_of_day] = '" + objRightRule.DurationOfDay + "', [no_of_repeat] = '" + objRightRule.NoOfRepeat + "', [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '" + objRightRule.LastActionBy + "', [is_active] = '" + objRightRule.Is_Active + "', [IS_First_Air] = '" + objRightRule.IS_First_Air + "', [Short_Key] = N'" + objRightRule.Short_Key + "' where right_rule_code = '" + objRightRule.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        RightRule objRightRule = (RightRule)obj;

        return " DELETE FROM [right_rule] WHERE right_rule_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        RightRule objRightRule = (RightRule)obj;
        string strSql = "UPDATE [right_rule] SET Is_Active='" + objRightRule.Is_Active + "',[Lock_Time]=null,[Last_Updated_Time] = getDate() WHERE right_rule_code=" + objRightRule.IntCode;
        return strSql;
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [right_rule] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [right_rule] WHERE  right_rule_code = " + obj.IntCode;
    }
}
