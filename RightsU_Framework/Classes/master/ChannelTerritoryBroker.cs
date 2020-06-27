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


public class ChannelTerritoryBroker : DatabaseBroker
{
    public ChannelTerritoryBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Channel_Territory] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ChannelTerritory objChannelTerritory;

        if (obj == null)
            objChannelTerritory = new ChannelTerritory();
        else
            objChannelTerritory = (ChannelTerritory)obj;

        objChannelTerritory.IntCode = Convert.ToInt32(dRow["Channel_Territory_Code"]);
        #region --populate--
        if (dRow["Channel_Code"] != DBNull.Value)
            objChannelTerritory.ChannelCode = Convert.ToInt32(dRow["Channel_Code"]);
        if (dRow["Country_Code"] != DBNull.Value)
            objChannelTerritory.InternationalTerritoryCode = Convert.ToInt32(dRow["Country_Code"]);
        #endregion
        return objChannelTerritory;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        ChannelTerritory objChannelTerritory = (ChannelTerritory)obj;
        return "insert into [Channel_Territory]([Channel_Code], [Country_Code]) values('"
            + objChannelTerritory.ChannelCode + "', '" + objChannelTerritory.InternationalTerritoryCode + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        ChannelTerritory objChannelTerritory = (ChannelTerritory)obj;
        return "update [Channel_Territory] set "
            + "[Channel_Code] = '" + objChannelTerritory.ChannelCode
            + "', [Country_Code] = '" + objChannelTerritory.InternationalTerritoryCode
            + "' where Channel_Territory_Code = '" + objChannelTerritory.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        ChannelTerritory objChannelTerritory = (ChannelTerritory)obj;
        return " DELETE FROM [Channel_Territory] WHERE Channel_Territory_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Channel_Territory] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Channel_Territory] WHERE Channel_Territory_Code = " + obj.IntCode;
    }
}
