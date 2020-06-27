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
/// Summary description for Penalty
/// </summary>
public class PenaltyBroker : DatabaseBroker
{
    public PenaltyBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Penalty] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Penalty objPenalty;
        if (obj == null)
        {
            objPenalty = new Penalty();
        }
        else
        {
            objPenalty = (Penalty)obj;
        }

        objPenalty.IntCode = Convert.ToInt32(dRow["Penalty_Code"]);
        #region --populate--
        objPenalty.PenaltyName = Convert.ToString(dRow["Penalty_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objPenalty.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objPenalty.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objPenalty.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objPenalty.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objPenalty.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objPenalty.Is_Active = Convert.ToString(dRow["Is_Active"]) == "" ? "Y" : dRow["Is_Active"].ToString();
        #endregion
        return objPenalty;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Penalty objPenalty = (Penalty)obj;
        bool result1 = GlobalUtil.IsDuplicate(myConnection, "Penalty", "Penalty_Name", objPenalty.PenaltyName,
                                              "Penalty_Code", objPenalty.IntCode, "Penalty Name already exists", "");
        if (result1)
            return true;
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        Penalty objPenalty = (Penalty)obj;
        return "insert into [Penalty]([Penalty_Name], [Inserted_On], "
            + " [Inserted_By], [Lock_Time], [Last_Updated_Time], [Last_Action_By], [Is_Active]) "
            + " values('" + objPenalty.PenaltyName.Trim().Replace("'", "''") + "', "
            + " getDate() ,"
            + " '" + objPenalty.InsertedBy + "', "
            + " " + (Convert.ToDateTime(objPenalty.LockTime) == DateTime.MinValue ? "null" : "'" + objPenalty.LockTime + "'") + " , "
            + " getDate() ,"
            + " '" + objPenalty.LastActionBy + "', 'Y');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Penalty objPenalty = (Penalty)obj;
        return "update [Penalty] set [Penalty_Name] = '" + objPenalty.PenaltyName.Trim().Replace("'", "''") + "',"
            + " [Lock_Time] = null, "
            + " [Last_Updated_Time] = getDate(), "
            + " [Last_Action_By] = '" + objPenalty.LastActionBy + "', "
            + " [Is_Active] = '" + objPenalty.Is_Active + "' "
            + " where Penalty_Code = '" + objPenalty.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Penalty objPenalty = (Penalty)obj;
        string sql = " update [Penalty] set is_Active='" + objPenalty.Is_Active + "' where Penalty_Code=" + objPenalty.IntCode;
        return sql;
        //return " DELETE FROM [Penalty] WHERE Penalty_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Penalty objPenalty = (Penalty)obj;
        string sql = " update [Penalty] set is_Active='" + objPenalty.Is_Active + "',lock_time=null, last_updated_time= getdate() where Penalty_Code=" + objPenalty.IntCode;
        return sql;
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Penalty] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Penalty] WHERE  Penalty_Code = " + obj.IntCode;
    }
}
