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
/// Summary description for TerritoryDetails
/// </summary>
public class TerritoryDetailsBroker : DatabaseBroker
{
    public TerritoryDetailsBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Territory_Details] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TerritoryDetails objTerritoryDetails;
        if (obj == null)
        {
            objTerritoryDetails = new TerritoryDetails();
        }
        else
        {
            objTerritoryDetails = (TerritoryDetails)obj;
        }

        objTerritoryDetails.IntCode = Convert.ToInt32(dRow["Territory_Details_code"]);
        #region --populate--
        if (dRow["Country_code"] != DBNull.Value)
            objTerritoryDetails.CountryCode = Convert.ToInt32(dRow["Country_code"]);
        if (dRow["Territory_code"] != DBNull.Value)
            objTerritoryDetails.TerritoryCode = Convert.ToInt32(dRow["Territory_code"]);

        objTerritoryDetails.TerritoryReferInAcq = Convert.ToString(dRow["is_ref_acq"]);
        objTerritoryDetails.TerritoryReferInSyn = Convert.ToString(dRow["is_ref_syn"]);

        #endregion
        return objTerritoryDetails;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        TerritoryDetails objTerritoryDetails = (TerritoryDetails)obj;
        return "insert into [Territory_Details]([Country_code], [Territory_code]) values('" + objTerritoryDetails.CountryCode + "', '" + objTerritoryDetails.TerritoryCode + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        TerritoryDetails objTerritoryDetails = (TerritoryDetails)obj;
        return "update [Territory_Details] set [Country_code] = '" + objTerritoryDetails.CountryCode + "', [Territory_code] = '" + objTerritoryDetails.TerritoryCode + "' where Territory_Details_code = '" + objTerritoryDetails.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        TerritoryDetails objTerritoryDetails = (TerritoryDetails)obj;

        return " DELETE FROM [Territory_Details] WHERE Territory_Details_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        TerritoryDetails objTerritoryDetails = (TerritoryDetails)obj;
        return "Update [Territory_Details] set Is_Active='" + objTerritoryDetails.Is_Active + "',lock_time=null, last_updated_time= getdate() where Territory_Details_code = '" + objTerritoryDetails.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Territory_Details] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Territory_Details] WHERE  Territory_Details_code = " + obj.IntCode;
    }
}
