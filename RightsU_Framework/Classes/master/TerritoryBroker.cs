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
/// Summary description for Territory
/// </summary>
public class Territory_DoNotUse_Broker : DatabaseBroker
{
    public Territory_DoNotUse_Broker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Territory] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Territory objTerritory;
        if (obj == null)
        {
            objTerritory = new Territory();
        }
        else
        {
            objTerritory = (Territory)obj;
        }

        objTerritory.IntCode = Convert.ToInt32(dRow["Territory_Code"]);
        #region --populate--
        objTerritory.TerritoryName = Convert.ToString(dRow["Territory_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objTerritory.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objTerritory.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objTerritory.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objTerritory.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objTerritory.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objTerritory.Is_Active = Convert.ToString(dRow["Is_Active"]);
        #endregion
        return objTerritory;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Territory objTerritory = (Territory)obj;
        if (objTerritory.SqlTrans != null)
            return DBUtil.IsDuplicateSqlTrans(ref obj, objTerritory.tableName, "Territory_Name", objTerritory.TerritoryName, objTerritory.pkColName, objTerritory.IntCode, "Record already exist", "", true);
        else
            return DBUtil.IsDuplicate(myConnection, objTerritory.tableName, "Territory_Name", objTerritory.TerritoryName, objTerritory.pkColName, objTerritory.IntCode, "Record already exist", "");

    }

    public override string GetInsertSql(Persistent obj)
    {
        Territory objTerritory = (Territory)obj;
        string strSql = "insert into [Territory]([Territory_Name], [Inserted_On], [Inserted_By], [Is_Active],[Domestic_territory_code]) values('" + objTerritory.TerritoryName.Trim().Replace("'", "''") + "', getDate(), '" + objTerritory.InsertedBy + "','Y',(select top 1 Country_code from Country where is_Domestic_territory='Y'));";
        return strSql;

    }

    public override string GetUpdateSql(Persistent obj)
    {
        Territory objTerritory = (Territory)obj;
        //return "update [Territory] set [Territory_Name] = '" + objTerritory.TerritoryName.Trim().Replace("'", "''") + "', [Parent_Territory_Code] = '" + objTerritory.ParentTerritoryCode + "', [Lock_Time] = null, [Last_Updated_Time] = getDate(), [Last_Action_By] = '" + objTerritory.LastActionBy + "', [Is_Active] = '" + objTerritory.Is_Active + "' where Territory_Code = '" + objTerritory.IntCode + "';";
        string strSql = "update [Territory] set [Territory_Name] = '" + objTerritory.TerritoryName.Trim().Replace("'", "''") + "', "
        + " [Lock_Time] = null, [Last_Updated_Time] = getDate(), [Last_Action_By] = '" + objTerritory.LastActionBy + "', [Is_Active] = '" + objTerritory.Is_Active + "' "
        + " where Territory_Code = '" + objTerritory.IntCode + "';";
        return strSql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Territory objTerritory = (Territory)obj;

        return " DELETE FROM [Territory] WHERE Territory_Code = " + objTerritory.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Territory objTerritory = (Territory)obj;
        return "Update [Territory] set Is_Active='" + objTerritory.Is_Active + "',lock_time=null, last_updated_time= getdate() where Territory_Code = " + objTerritory.IntCode;

    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Territory] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Territory] WHERE  Territory_Code = " + obj.IntCode;
    }
    public int getCategoryCode(Persistent obj)
    {
        Territory objTerritory = (Territory)obj;
        string str = "Select territory_code from territory where territory_Name like '" + objTerritory.TerritoryName + "'";
        int intCategory_Code = (int)this.ProcessScalar(str);
        return intCategory_Code;
    }

    internal DataSet getAffectedDealList(string strCodes)
    {
        DataSet dset = new DataSet();

        strCodes = strCodes == "" ? "0" : strCodes;
        string strSelect = "";

        //strSelect = " select d.deal_no , d.deal_desc from deal d " +
        //            " inner join deal_movie dm on d.deal_code = dm.deal_code " +
        //            " inner join deal_movie_rights dmr on dm.deal_movie_code = dmr.deal_movie_code " +
        //            " inner join Deal_Movie_Rights_Territory dmrt on dmr.deal_movie_rights_code = dmrt.deal_movie_rights_code " +
        //            " where dmr.territoy_type  = 'G' and dmrt.Territory_code In (" + strCodes + ")  ";

        strSelect = " select distinct	t.english_title , d.deal_no from deal d " +
                    " inner join deal_movie dm on d.deal_code = dm.deal_code " +
                    " inner join deal_movie_rights dmr on dm.deal_movie_code = dmr.deal_movie_code " +
                    " inner join Deal_Movie_Rights_Territory dmrt on dmr.deal_movie_rights_code = dmrt.deal_movie_rights_code " +
                    " inner join Title t on dm.title_code = t.title_code " +
                    " where dmr.territoy_type  = 'G' and dmrt.Territory_code In (" + strCodes + ") and ISNULL(d.is_active,'N') = 'Y'";

        dset = (DataSet)ProcessSelectDirectly(strSelect);
        return dset;
    }

    public static bool IsSameRightContainBothTerritory(string territoryCode, string countryCodes)
    {
        string sql = "EXEC USP_IS_SAME_RIGHTS_CONTAIN_BOTH_TERRIOTORY '" + territoryCode + "', '" + countryCodes + "'";
        DataSet ds = ProcessSelectDirectly(sql);

        if (ds.Tables[0].Rows.Count > 0)
            return true;

        return false;
    }
}
