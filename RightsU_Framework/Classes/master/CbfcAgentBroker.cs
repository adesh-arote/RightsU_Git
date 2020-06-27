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
/// Summary description for CbfcAgent
/// </summary>
public class CbfcAgentBroker : DatabaseBroker {
    public CbfcAgentBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Cbfc_Agent] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        CbfcAgent objCbfcAgent;
        if (obj == null)
        {
            objCbfcAgent = new CbfcAgent();
        }
        else
        {
            objCbfcAgent = (CbfcAgent)obj;
        }

        objCbfcAgent.IntCode = Convert.ToInt32(dRow["Cbfc_Agent_Code"]);
        #region --populate--
        objCbfcAgent.CbfcAgentname = Convert.ToString(dRow["Cbfc_Agent_name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objCbfcAgent.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objCbfcAgent.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objCbfcAgent.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objCbfcAgent.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objCbfcAgent.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objCbfcAgent.Is_Active = Convert.ToString(dRow["Is_Active"]);
        #endregion
        return objCbfcAgent;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        CbfcAgent objCbfcAgent = (CbfcAgent)obj;
        return DBUtil.IsDuplicate(myConnection, "Cbfc_Agent", "Cbfc_Agent_name", objCbfcAgent.CbfcAgentname, "Cbfc_Agent_Code", objCbfcAgent.IntCode, "Record already exists", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        CbfcAgent objCbfcAgent = (CbfcAgent)obj;
        string strSql= "insert into [Cbfc_Agent]([Cbfc_Agent_name], [Inserted_On], [Inserted_By], [Is_Active]) values('" + objCbfcAgent.CbfcAgentname.Trim().Replace("'", "''") + "', GetDate(), '" + objCbfcAgent.InsertedBy + "','Y');";
        return (strSql);
    }

    public override string GetUpdateSql(Persistent obj)
    {
        CbfcAgent objCbfcAgent = (CbfcAgent)obj;
        return "update [Cbfc_Agent] set [Cbfc_Agent_name] = '" + objCbfcAgent.CbfcAgentname.Trim().Replace("'", "''") + "', [Lock_Time] = null, [Last_Updated_Time] = getDate(), [Last_Action_By] = '" + objCbfcAgent.LastActionBy + "', [Is_Active] = '" + objCbfcAgent.Is_Active + "' where Cbfc_Agent_Code = '" + objCbfcAgent.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        CbfcAgent objCbfcAgent = (CbfcAgent)obj;

        return " DELETE FROM [Cbfc_Agent] WHERE Cbfc_Agent_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        CbfcAgent objCbfcAgent = (CbfcAgent)obj;
        string strSql = "UPDATE [Cbfc_Agent] SET Is_Active='" + objCbfcAgent.Is_Active + "',[Lock_Time]=null,[Last_Updated_Time] = getDate() WHERE Cbfc_Agent_Code=" + objCbfcAgent.IntCode;
        return (strSql);
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Cbfc_Agent] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Cbfc_Agent] WHERE  Cbfc_Agent_Code = " + obj.IntCode;
    }
}
