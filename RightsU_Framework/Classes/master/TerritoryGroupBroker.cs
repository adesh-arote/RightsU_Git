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
public class TerritoryBroker : DatabaseBroker
{
    public TerritoryBroker() { }

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

        objTerritory.IntCode = Convert.ToInt32(dRow["Territory_code"]);
        #region --populate--
        objTerritory.TerritoryName = Convert.ToString(dRow["Territory_name"]);
        //objTerritory. = Convert.ToString(dRow["Is_Thetrical"]);

        objTerritory.TerritoryRefExistsInAcqisition = Convert.ToString(dRow["is_ref_acq"]);
        objTerritory.TerritoryRefExistsInSyndication = Convert.ToString(dRow["is_ref_syn"]);

        if (dRow["inserted_on"] != DBNull.Value)
            objTerritory.InsertedOn = Convert.ToString(dRow["inserted_on"]);
        if (dRow["inserted_by"] != DBNull.Value)
            objTerritory.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
        if (dRow["lock_time"] != DBNull.Value)
            objTerritory.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objTerritory.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objTerritory.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
        if (dRow["Is_Active"] != DBNull.Value)
            objTerritory.Is_Active = Convert.ToString(dRow["is_active"]);
        else
            objTerritory.Is_Active = "Y";

        if (dRow["Is_Thetrical"] != DBNull.Value)
            objTerritory.Is_Thetrical = Convert.ToString(dRow["Is_Thetrical"]);
        else
            objTerritory.Is_Thetrical = "N";
        if (objTerritory != null && objTerritory.IntCode > 0)
            objTerritory.IsRef = CheckRef(objTerritory.IntCode);
        #endregion
        return objTerritory;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Territory objTerritory = (Territory)obj;
        if (objTerritory.SqlTrans != null)
            return DBUtil.IsDuplicateSqlTrans(ref obj, objTerritory.tableName, "Territory_name", objTerritory.TerritoryName, objTerritory.pkColName, objTerritory.IntCode, "Record Already Exists.", "", true) ||
                DBUtil.IsDuplicateSqlTrans(ref obj, "Country", "Country_Name ", objTerritory.TerritoryName, "Country_Code", 0, " and Country name can not be the same.", "", true);
        else
            return DBUtil.IsDuplicate(myConnection, objTerritory.tableName, "Territory_name", objTerritory.TerritoryName, objTerritory.pkColName, objTerritory.IntCode, "Record Already Exists.", "") ||
                DBUtil.IsDuplicate(myConnection, "Country", "Country_Name", objTerritory.TerritoryName, "Country_Code", 0, " and Country name can not be the same.", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        Territory objTerritory = (Territory)obj;
        string strsql = "insert into [Territory]([Territory_name], [inserted_on], [inserted_by], [lock_time], [last_updated_time], [last_action_by], [is_active],[Is_Thetrical]) values(N'" + objTerritory.TerritoryName.Trim().Replace("'", "''") + "', GetDate(), '" + objTerritory.InsertedBy + "',  Null, GetDate(), '" + objTerritory.InsertedBy + "', 'Y','" + objTerritory.Is_Thetrical + "' );";
        return strsql;

    }

    public override string GetUpdateSql(Persistent obj)
    {
        Territory objTerritory = (Territory)obj;
        string strsql = "update [Territory] set [Territory_name] = N'" + objTerritory.TerritoryName.Trim().Replace("'", "''") + "', [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '" + objTerritory.LastActionBy + "', [is_active] = '" + objTerritory.Is_Active  + "', [Is_Thetrical] = '" + objTerritory.Is_Thetrical+ "'" + " where Territory_code = '" + objTerritory.IntCode + "';";
        
        
        return strsql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Territory objTerritory = (Territory)obj;

        return " DELETE FROM [Territory] WHERE Territory_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Territory objTerritory = (Territory)obj;
        return "Update [Territory] set Is_Active='" + objTerritory.Is_Active + "',lock_time=null, last_updated_time= getdate() where Territory_code = '" + objTerritory.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Territory] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Territory] WHERE  Territory_code = " + obj.IntCode;
    }

    internal DataSet getAffectedDealList(string strCodes)
    {
        DataSet dset = new DataSet();

        strCodes = strCodes == "" ? "0" : strCodes;
        string strSelect = "";

        strSelect = " select d.deal_no , d.deal_desc from deal d " +
                    " inner join deal_movie dm on d.deal_code = dm.deal_code " +
                    " inner join deal_movie_rights dmr on dm.deal_movie_code = dmr.deal_movie_code " +
                    " inner join Deal_Movie_Rights_Territory dmrt on dmr.deal_movie_rights_code = dmrt.deal_movie_rights_code " +
                    " where dmr.territoy_type  = 'G' and dmrt.Territory_code In (" + strCodes + ")  " +
                    " and ISNULL(dm.is_closed,'N') = 'N' " +
                    " and ISNULL(d.is_active,'N') = 'Y' ";

        dset = (DataSet)ProcessSelectDirectly(strSelect);
        return dset;
    }

    public string GetUsedTerritory(Int32 TerritoryUsed)
    {
        DataSet dset = new DataSet();
        string strUT = "";

        //string strSelect = " select top 1 d.deal_no from Deal d " +
        //                  " inner join Deal_Movie dm on d.deal_code = dm.deal_code " +
        //                  " inner join Deal_Movie_Rights dmr on dm.deal_movie_code = dmr.deal_movie_code " +
        //                  " inner join Deal_Movie_Rights_Territory dmrt on dmr.deal_movie_rights_code = dmrt.deal_movie_rights_code " +
        //                  " where dmrt.territory_type = 'I' and dmrt.territory_code =" + TerritoryUsed + " " +
        //                  " and ISNULL(dm.is_closed,'N') = 'N' " +
        //                  " and ISNULL(d.is_active,'N') = 'Y' "+
        //                  " order by d.deal_no desc ";

        //no refrance cheked.It was causeing runtime error it was commented b

        string strSelect = " select ''";

        dset = DatabaseBroker.ProcessSelectDirectly(strSelect);

        if (Convert.ToInt32(dset.Tables[0].Rows.Count) > 0)
            strUT = Convert.ToString(dset.Tables[0].Rows[0].ItemArray[0]);

        return strUT;

    }

    internal void InsertRecordsForDealMassUpdate(int TerritoryCode, ref System.Data.SqlClient.SqlTransaction sqlTran,int UserId)
    {
        string sql = "Exec USP_Generate_Mass_Territory_Update '" + TerritoryCode + "',"+UserId;
        this.ProcessNonQuery(sql, false, ref sqlTran);
    }

    private string CheckRef(int T_Group_Code)
    {
        string sql = "SELECT dbo.UFN_Check_Ref_Territory_Country(" + T_Group_Code + ",'G') AS Is_Ref";
        sql = DatabaseBroker.ProcessScalarReturnString(sql);
        return sql;
    }

}
