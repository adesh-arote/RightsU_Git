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
/// Summary description for Country
/// </summary>
public class CountryBroker : DatabaseBroker
{
    public CountryBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Country] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr += " ORDER BY " + objCriteria.getASCstr();

        return objCriteria.getPagingSQL(sqlStr);
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Country objCountry;

        if (obj == null)
            objCountry = new Country();
        else
            objCountry = (Country)obj;

        objCountry.IntCode = Convert.ToInt32(dRow["Country_Code"]);
        #region --populate--
        objCountry.CountryName = Convert.ToString(dRow["Country_Name"]);
        objCountry.IsDomesticTerritory = Convert.ToString(dRow["is_Domestic_territory"]);

        ////Commented by prashant 
        //string strDealno = GetUsedTerritoryInSyndication(objCountry.IntCode);

        //if (strDealno != "")
        //    objCountry.ReferencedTerritoryInSyndication = "Y";
        //else
        //    objCountry.ReferencedTerritoryInSyndication = "N";

        //string strcountEdit = Convert.ToString(GetIsDomisticTerritoryReferenceStatusCountEdit(objCountry.IntCode));
        //if (strcountEdit != "")
        //    objCountry.DomisticTerritoryReferenceCount = strcountEdit;
        //else
        //    objCountry.DomisticTerritoryReferenceCount = "0";

        ///* Reference Exists In Syndication deal or not  */
        ///

        //objCountry.CountryRefExistsInAcqisition = GetReferenceCountOfCountryInTerritoryGroupDetails(objCountry.IntCode);
        // objCountry.CountryRefExistsInSyndication = Convert.ToString(dRow["is_ref_syn"]);

        if (dRow["Inserted_On"] != DBNull.Value)
            objCountry.InsertedOn = Convert.ToString(dRow["Inserted_On"]);

        if (dRow["Inserted_By"] != DBNull.Value)
            objCountry.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);

        if (dRow["Lock_Time"] != DBNull.Value)
            objCountry.LockTime = Convert.ToString(dRow["Lock_Time"]);

        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objCountry.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);

        if (dRow["Last_Action_By"] != DBNull.Value)
            objCountry.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);

        if (dRow["Is_Theatrical_Territory"] != DBNull.Value)
            objCountry.Is_Theatrical_Territory = Convert.ToString(dRow["Is_Theatrical_Territory"]);

        if (dRow["Parent_Country_Code"] != DBNull.Value)
            objCountry.ParentCountryCode = Convert.ToInt32(dRow["Parent_Country_Code"]);

        if (objCountry != null && objCountry.IntCode > 0)
            objCountry.IsRef = CheckRef(objCountry.IntCode);

        objCountry.Is_Active = Convert.ToString(dRow["Is_Active"]);
        objCountry.Language = GetLanguageName(objCountry.IntCode);

        #endregion
        return objCountry;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Country objCountry = (Country)obj;

        if (objCountry.SqlTrans != null)
            return DBUtil.IsDuplicateSqlTrans(ref obj, objCountry.tableName, "Country_Name ", objCountry.CountryName, objCountry.pkColName, objCountry.IntCode, "Record already exist", "", true) ||
                DBUtil.IsDuplicateSqlTrans(ref obj, "Territory", "Territory_name", objCountry.CountryName, "Territory_code", 0, " and Territory name can not be same.", "", true);
        else
            return DBUtil.IsDuplicate(myConnection, objCountry.tableName, "Country_Name ", objCountry.CountryName, objCountry.pkColName, objCountry.IntCode, "Record already exist", "") ||
                DBUtil.IsDuplicate(myConnection, "Territory", "Territory_name", objCountry.CountryName, "Territory_code", 0, " and Territory name can not be same.", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        Country objCountry = (Country)obj;
        return "insert into [Country]("
            + "[Country_Name],[is_Domestic_territory],[Inserted_On], [Inserted_By],[Lock_Time],[Last_Updated_Time], [Last_Action_By], "
            + "[Is_Active],[Is_Theatrical_Territory],[Parent_Country_Code]) "
            + "values(N'"
                + objCountry.CountryName.Trim().Replace("'", "''") + "','"
                + objCountry.IsDomesticTerritory + "' ,GetDate(), '"
                + objCountry.InsertedBy + "', null, GetDate(), '"
                + objCountry.InsertedBy + "',  'Y','"
                + objCountry.Is_Theatrical_Territory + "','"
                + objCountry.ParentCountryCode
            + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Country objCountry = (Country)obj;
        return "update [Country] set "
            + "[Country_Name] = N'" + objCountry.CountryName.Trim().Replace("'", "''") + "',"
            + "[is_Domestic_territory]='" + objCountry.IsDomesticTerritory + "', "
            + "[Is_Theatrical_Territory]='" + objCountry.Is_Theatrical_Territory + "', "
            + "[Parent_Country_Code]='" + objCountry.ParentCountryCode + "', "
            + "[Lock_Time] = Null, "
            + "[Last_Updated_Time] = GetDate(), "
            + "[Last_Action_By] = '" + objCountry.LastActionBy + "', "
            + "[Is_Active] = '" + objCountry.Is_Active
            + "' where Country_Code = '" + objCountry.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Country objCountry = (Country)obj;
        return " DELETE FROM [Country] WHERE Country_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Country objCountry = (Country)obj;
        return "Update [Country] set Is_Active='" + objCountry.Is_Active
            + "',lock_time=null, last_updated_time= getdate() where Country_Code = '" + objCountry.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Country] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Country] WHERE  Country_Code = " + obj.IntCode;
    }

    public int getCategoryCode(Persistent obj)
    {
        Country objTerritory = (Country)obj;
        string str = "Select Country_code from Country where Country_Name like '" + objTerritory.CountryName + "'";
        int intCategory_Code = (int)this.ProcessScalar(str);
        return intCategory_Code;
    }

    internal DataSet getAffectedDealList(string strCodes)
    {
        DataSet dset = new DataSet();

        strCodes = strCodes == "" ? "0" : strCodes;
        string strSelect = "";

        strSelect = " select distinct	t.english_title , d.deal_no from deal d " +
                    " inner join deal_movie dm on d.deal_code = dm.deal_code " +
                    " inner join deal_movie_rights dmr on dm.deal_movie_code = dmr.deal_movie_code " +
                    " inner join Deal_Movie_Rights_Territory dmrt on dmr.deal_movie_rights_code = dmrt.deal_movie_rights_code " +
                    " inner join Title t on dm.title_code = t.title_code " +
                    " where dmr.territoy_type  = 'G' and dmrt.Territory_code In (" + strCodes + ") and ISNULL(d.is_active,'N') = 'Y'";

        dset = (DataSet)ProcessSelectDirectly(strSelect);
        return dset;
    }

    /* prashant chenged region */

    public string GetUsedTerritoryInSyndication(Int32 TerritoryInSyndication)
    {
        DataSet dset = new DataSet();
        string strUTInSyndication = "";
        string strSelect = " select top 1 syndication_no from syndication_deal sd " +
                           " inner join syndication_deal_movie sdm on sd.syndication_deal_code=sdm.syndication_deal_code " +
                           " inner join syn_deal_movie_rights sdmr on sdm.syndication_deal_movie_code=sdmr.syndication_deal_movie_code " +
                           " inner join Syn_Deal_Movie_Rights_Territory sdmrt on sdmr.syn_deal_movie_rights_code=sdmrt.Syn_Deal_movie_rights_code  " +
                           " where sdmrt.territory_type='I' " +
                           " and sdmrt.is_domestic_territory = 'Y' " +
                           " and sdmrt.is_Country ='Y' " +
                           " and sdmrt.territory_code= " + TerritoryInSyndication + " " +
                           " and ISNULL(sd.Is_Active,'N') = 'Y'";

        dset = DatabaseBroker.ProcessSelectDirectly(strSelect);

        if (Convert.ToInt32(dset.Tables[0].Rows.Count) > 0)
            strUTInSyndication = Convert.ToString(dset.Tables[0].Rows[0].ItemArray[0]);

        return strUTInSyndication;
    }

    public string GetIsDomisticTerritoryReferenceStatusCountEdit(int territorycode)
    {
        DataSet dset = new DataSet();
        string strCount = "";
        string strSelect = " select COUNT(*) syn_deal_code from syn_deal sd " +
                           " inner join syn_deal_rights sdmr on sd.syn_deal_code=sd.syn_deal_code " +
                           " inner join Syn_Deal_Rights_Territory sdmrt on sdmr.Syn_Deal_Rights_Code=sdmrt.Syn_Deal_Rights_Code " +
                           " where sdmrt.territory_type='I'  " +
                           " and sdmrt.Country_Code in (" + territorycode + ")" +
                           " and ISNULL(sd.Is_Active,'N') = 'Y'";

        dset = DatabaseBroker.ProcessSelectDirectly(strSelect);

        if (Convert.ToInt32(dset.Tables[0].Rows.Count) > 0)
            strCount = Convert.ToString(dset.Tables[0].Rows[0].ItemArray[0]);

        return strCount;
    }

    internal string isBaseTerritoryAvailable(string strTerritoryCodeNotIn)
    {
        string strSelect = " select COUNT(*) from Country " +
                           " where isnull(is_Domestic_territory,'N') = 'Y'" +
                           " and Country_code not in(" + strTerritoryCodeNotIn + ")";

        string isBaseTerritoryAvailable = "N";
        DataSet dset = new DataSet();
        dset = DatabaseBroker.ProcessSelectDirectly(strSelect);

        if (Convert.ToInt32(dset.Tables[0].Rows[0][0]) > 0)
            isBaseTerritoryAvailable = "Y";

        return isBaseTerritoryAvailable;
    }

    /* prashant chenged region end */

    public string GetUsedTerritoryGroup(Int32 TerritoryGroupUsed)
    {
        DataSet dset = new DataSet();
        string strUTG = "";
        string strSelect = " select top 1 d.deal_no from Deal d " +
                          " inner join Deal_Movie dm on d.deal_code = dm.deal_code " +
                          " inner join Deal_Movie_Rights dmr on dm.deal_movie_code = dmr.deal_movie_code " +
                          " inner join Deal_Movie_Rights_Territory dmrt on dmr.deal_movie_rights_code = dmrt.deal_movie_rights_code " +
                          " where dmrt.territory_type = 'G' and dmrt.Territory_code =" + TerritoryGroupUsed + " " +
                          " and ISNULL(dm.is_closed,'N') = 'N' " +
                          " and ISNULL(d.is_active,'N') = 'Y' " +
                          " order by d.deal_no desc ";

        dset = DatabaseBroker.ProcessSelectDirectly(strSelect);

        if (Convert.ToInt32(dset.Tables[0].Rows.Count) > 0)
            strUTG = Convert.ToString(dset.Tables[0].Rows[0].ItemArray[0]);

        return strUTG;
    }

    public string GetReferenceCountOfCountryInTerritoryGroupDetails(int countryCode) // Added By sharad for Checking reference of country
    {
        int referenceCount = 0;
        string status = string.Empty;
        string strSql = "select COUNT(*) from Territory_details  where 1=1 and is_ref_acq='Y' and Country_code=" + countryCode;
        referenceCount = DatabaseBroker.ProcessScalarDirectly(strSql);

        if (referenceCount > 0)
            status = "Y";
        else
            status = "N";

        return status;
    }

    private string GetLanguageName(int International_Territory_Code)
    {
        string sql = " select language_name from Country IT  "
                    + " Inner join Country_Language ITL  On ITL.Country_Code=IT.Country_code AND ITL.Country_code=" + International_Territory_Code + " "
                    + " Inner Join [Language] L on L.language_code=ITL.Language_Code";
        DataSet ds = DatabaseBroker.ProcessSelectDirectly(sql);
        string LangName = "";

        if (ds.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                LangName = ds.Tables[0].Rows[i][0].ToString() + ", " + LangName;
            }
        }
        LangName = LangName.Trim();
        return LangName.Trim(',');
    }

    internal void InsertRecordsForDealMassUpdate(string TerritoryGroups, ref System.Data.SqlClient.SqlTransaction sqlTran, int UserId)
    {
        string sql = "Exec USP_Generate_Mass_Territory_Update '" + TerritoryGroups + "'," + UserId;
        this.ProcessNonQuery(sql, false, ref sqlTran);
    }

    private string CheckRef(int T_Group_Code)
    {
        string sql = "SELECT dbo.UFN_Check_Ref_Territory_Country(" + T_Group_Code + ",'I') AS Is_Ref";
        sql = DatabaseBroker.ProcessScalarReturnString(sql);
        return sql;
    }

}
