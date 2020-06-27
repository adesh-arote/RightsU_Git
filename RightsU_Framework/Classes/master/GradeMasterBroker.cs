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
/// Summary description for GradeMaster
/// </summary>
public class GradeMasterBroker : DatabaseBroker
{
    public GradeMasterBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Grade_Master] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        GradeMaster objGradeMaster;
        if (obj == null)
        {
            objGradeMaster = new GradeMaster();
        }
        else
        {
            objGradeMaster = (GradeMaster)obj;
        }

        objGradeMaster.IntCode = Convert.ToInt32(dRow["Grade_Code"]);
        #region --populate--
        objGradeMaster.GradeName = Convert.ToString(dRow["Grade_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objGradeMaster.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objGradeMaster.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objGradeMaster.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objGradeMaster.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objGradeMaster.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objGradeMaster.Is_Active = Convert.ToString(dRow["Is_Active"]);

        objGradeMaster.IsRefExists = getIsRefExists(objGradeMaster.GradeName).Trim();
        #endregion
        return objGradeMaster;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        GradeMaster objGradeMaster = (GradeMaster)obj;
        return DBUtil.IsDuplicate(myConnection, objGradeMaster.tableName, "Grade_Name", objGradeMaster.GradeName, objGradeMaster.pkColName, objGradeMaster.IntCode, "Record Already Exist", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        GradeMaster objGradeMaster = (GradeMaster)obj;
        return "insert into [Grade_Master]([Grade_Name], [Inserted_On], [Inserted_By], [Lock_Time], [Last_Updated_Time], [Last_Action_By], [Is_Active]) values(N'" + objGradeMaster.GradeName.Trim().Replace("'", "''") + "', GetDate(), '" + objGradeMaster.InsertedBy + "',  Null, GetDate(), '" + objGradeMaster.InsertedBy + "',  '" + objGradeMaster.Is_Active + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        GradeMaster objGradeMaster = (GradeMaster)obj;
        return "update [Grade_Master] set [Grade_Name] = N'" + objGradeMaster.GradeName.Trim().Replace("'", "''") + "', [Lock_Time] = Null, [Last_Updated_Time] = GetDate(), [Last_Action_By] = '" + objGradeMaster.LastActionBy + "', [Is_Active] = '" + objGradeMaster.Is_Active + "' where Grade_Code = '" + objGradeMaster.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        GradeMaster objGradeMaster = (GradeMaster)obj;

        return " DELETE FROM [Grade_Master] WHERE Grade_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        GradeMaster objGradeMaster = (GradeMaster)obj;
        return "Update [Grade_Master] set Is_Active='" + objGradeMaster.Is_Active + "',lock_time=null, last_updated_time= getdate() where Grade_Code = '" + objGradeMaster.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Grade_Master] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Grade_Master] WHERE  Grade_Code = " + obj.IntCode;
    }

    //Check is reference exists in Monthly_Sales_Royalty
    private string getIsRefExists(string GradeName)
    {
        string IsRef = YesNo.N.ToString();
        string strSql = " SELECT COUNT(*) FROM Monthly_Sales_Royalty WHERE isnull(Grade,'All') = '" + GradeName + "' ";
        int IsRefCnt = ProcessScalarDirectly(strSql);

        if (IsRefCnt > 0)
        {
            IsRef = YesNo.Y.ToString();
        }

        return IsRef;
    }
}
