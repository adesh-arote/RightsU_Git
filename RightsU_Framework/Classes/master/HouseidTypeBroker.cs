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
/// Summary description for HouseidType
/// </summary>
public class HouseidTypeBroker : DatabaseBroker
{
    public HouseidTypeBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [HouseID_Type] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        HouseidType objHouseidType;
        if (obj == null)
        {
            objHouseidType = new HouseidType();
        }
        else
        {
            objHouseidType = (HouseidType)obj;
        }

        objHouseidType.IntCode = Convert.ToInt32(dRow["HouseID_Type_Code"]);
        #region --populate--
        objHouseidType.HouseidType_Name = Convert.ToString(dRow["HouseID_Type_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objHouseidType.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objHouseidType.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objHouseidType.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objHouseidType.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objHouseidType.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objHouseidType.Is_Active = Convert.ToString(dRow["Is_Active"]);
        #endregion
        return objHouseidType;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        HouseidType objHouseidType = (HouseidType)obj;
        string strSql = "insert into [HouseID_Type]([HouseID_Type_Name], [Inserted_On], [Inserted_By], [Is_Active]) "
        + " values('" + objHouseidType.HouseidType_Name.Trim().Replace("'", "''") + "', getDate() , '" + objHouseidType.InsertedBy + "', 'Y');";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        HouseidType objHouseidType = (HouseidType)obj;
        string strSql = "update [HouseID_Type] set [HouseID_Type_Name] = '" + objHouseidType.HouseidType_Name.Trim().Replace("'", "''") + "' "
        + " [Lock_Time] = null, [Last_Updated_Time] = getDate() , [Last_Action_By] = '" + objHouseidType.LastActionBy + "' "
        + " where HouseID_Type_Code = '" + objHouseidType.IntCode + "';";
        return strSql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        HouseidType objHouseidType = (HouseidType)obj;

        return " DELETE FROM [HouseID_Type] WHERE HouseID_Type_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        HouseidType objHouseidType = (HouseidType)obj;
        return "Update [HouseID_Type] set Is_Active='" + objHouseidType.Is_Active + "',lock_time=null, last_updated_time= getdate() where HouseID_Type_Code = '" + objHouseidType.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [HouseID_Type] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [HouseID_Type] WHERE  HouseID_Type_Code = " + obj.IntCode;
    }
}
