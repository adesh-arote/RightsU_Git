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
/// Summary description for Title
/// </summary>
public class Territory : Persistent
{
    public Territory()
    {
        OrderByColumnName = "Territory_name";
        OrderByCondition = "ASC";
        tableName = "Territory";
        pkColName = "Territory_code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _TerritoryName;
    public string TerritoryName
    {
        get { return this._TerritoryName; }
        set { this._TerritoryName = value; }
    }


    //Added by sharad for getting territory names 

    private string _TerritoryNames;
    public string TerritoryNames
    {
        get { return this._TerritoryNames; }
        set { this._TerritoryNames = value; }
    }

    private string _Is_Thetrical;
    public string Is_Thetrical
    {
        get { return this._Is_Thetrical; }
        set { this._Is_Thetrical = value; }
    }

    
    private string _TerritoryCodes;
    public string TerritoryCodes
    {
        get { return this._TerritoryCodes; }
        set { this._TerritoryCodes = value; }
    }


    private ArrayList _arrTerritoryDetails;
    public ArrayList arrTerritoryDetails
    {
        get
        {
            if (this._arrTerritoryDetails == null)
                this._arrTerritoryDetails = new ArrayList();
            return this._arrTerritoryDetails;
        }
        set
        {
            this._arrTerritoryDetails = value;
        }
    }

    private ArrayList _del_arrTerritoryDetails;
    public ArrayList del_arrTerritoryDetails
    {
        get
        {
            if (this._del_arrTerritoryDetails == null)
                this._del_arrTerritoryDetails = new ArrayList();
            return this._del_arrTerritoryDetails;
        }
        set
        {
            this._del_arrTerritoryDetails = value;
        }
    }

    private ArrayList _arrTerritory;
    public ArrayList arrTerritory
    {
        get
        {
            if (this._arrTerritory == null)
                this._arrTerritory = new ArrayList();
            return this._arrTerritory;
        }
        set
        {
            this._arrTerritory = value;
        }
    }

    //Added By sharad for Reference Validation of Territory Group on 29 Dec 2010
    private string _IsReferenceExist;
    public string IsReferenceExist
    {
        get { return this._IsReferenceExist; }
        set { this._IsReferenceExist = value; }
    }
    //Added By sharad for Reference Validation of Territory Group on Dec 2010

    //Added By sharad for Reference Validation of Territory Group on 28 Dec 2010

    private string _ReferencedTerritory;
    public string ReferencedTerritory
    {
        get { return this._ReferencedTerritory; }
        set { this._ReferencedTerritory = value; }
    }

    //Added By sharad for Reference Validation of Territory  on 28 Dec 2010

    /* === Added by sharad on June 06 2011 for displaying reference of territory in acquisition and syndication === */

    private string _TerritoryRefExistsInSyndication;
    public string TerritoryRefExistsInSyndication
    {
        get { return this._TerritoryRefExistsInSyndication; }
        set { this._TerritoryRefExistsInSyndication = value; }
    }

    private string _TerritoryRefExistsInAcqisition;
    public string TerritoryRefExistsInAcqisition
    {
        get { return this._TerritoryRefExistsInAcqisition; }
        set { this._TerritoryRefExistsInAcqisition = value; }
    }

    /* === Added by sharad on June 06 2011 for displaying reference of territory in acquisition and syndication === */

    //Added New Property By Adesh

    private string _IsIntTerrAdd;
    public string IsIntTerrAdd
    {
        get { return this._IsIntTerrAdd; }
        set { this._IsIntTerrAdd = value; }
    }

    private string _IsRef;
    public string IsRef
    {
        get { return this._IsRef; }
        set { this._IsRef = value; }
    }

    //End

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new TerritoryBroker();
    }

    public override void LoadObjects()
    {
        this.arrTerritoryDetails = DBUtil.FillArrayList(new TerritoryDetails(), " and Territory_code = " + this.IntCode, true);
        this.del_arrTerritoryDetails = (ArrayList)this._arrTerritoryDetails.Clone();
        string strSql = " and Country_code  in(select Country_code  from  Territory_details where Territory_code = " + this.IntCode + " )";
        this.arrTerritory = DBUtil.FillArrayList(new Country(), strSql, false);

        string strTerritoryNames = "";
        string strTerritoryCodes = "";
        string strUsedTerritoryCodes = "";

        foreach (TerritoryDetails obj in this.arrTerritoryDetails)
        {
            if (strTerritoryNames != "")
                strTerritoryNames += ", ";
            strTerritoryNames += obj.objCountry.CountryName;

            if (strTerritoryCodes != "")
                strTerritoryCodes += ",";
            strTerritoryCodes += obj.objCountry.IntCode;

            Int32 TerritoryCode = Convert.ToInt32(obj.objCountry.IntCode);

            //string strUsedT = ((TerritoryBroker)(this.GetBroker())).GetUsedTerritory(TerritoryCode);
            //if (strUsedT != "")
            //{
            //if (obj.objCountry.CountryRefExistsInAcqisition == "Y" || obj.objCountry.CountryRefExistsInSyndication == "Y")
            //{
            //    obj.objCountry.IsReferenceTerritoryExist = "Y";
            //}
            //else
            //    obj.objCountry.IsReferenceTerritoryExist = "N";


            if (obj.objCountry.CountryRefExistsInAcqisition == "Y" || obj.objCountry.CountryRefExistsInSyndication == "Y")
            {
                obj.objCountry.IsReferenceTerritoryExist = "Y";
            }
            else
                obj.objCountry.IsReferenceTerritoryExist = "N";

            // strUsedTerritoryCodes += obj.objCountry.IntCode + "~" + obj.objCountry.IsReferenceTerritoryExist + "~" + strUsedT + "#";
            strUsedTerritoryCodes += obj.objCountry.IntCode + "~" + obj.objCountry.IsReferenceTerritoryExist + "#";
            //}

        }

        this.TerritoryNames = strTerritoryNames;
        this.TerritoryCodes = strTerritoryCodes;
        this.ReferencedTerritory = strUsedTerritoryCodes;
    }

    public override void UnloadObjects()
    {

        if (del_arrTerritoryDetails != null)
        {
            foreach (TerritoryDetails objTerritoryDetails in this.del_arrTerritoryDetails)
            {
                objTerritoryDetails.IsTransactionRequired = true;
                objTerritoryDetails.SqlTrans = this.SqlTrans;
                objTerritoryDetails.IsDeleted = true;
                objTerritoryDetails.Save();
            }
        }

        foreach (TerritoryDetails objTerritoryDetails in this.arrTerritoryDetails)
        {
            objTerritoryDetails.TerritoryCode = this.IntCode;
            objTerritoryDetails.IsTransactionRequired = true;
            objTerritoryDetails.SqlTrans = this.SqlTrans;
            objTerritoryDetails.Save();
        }

        SqlTransaction sqlTran = (SqlTransaction)this.SqlTrans;
        if (this.IsIntTerrAdd == "Y")
        {
            int UserId = this.LastActionBy;
            ((TerritoryBroker)(this.GetBroker())).InsertRecordsForDealMassUpdate(this.IntCode, ref sqlTran, UserId);
        }


    }
    #endregion

    public DataSet getAffectedDealList(string strTerritoryCodes)
    {
        return ((TerritoryBroker)(this.GetBroker())).getAffectedDealList(strTerritoryCodes);
    }

    //public static bool IsSameRightContainBothTerritory(string territoryCode, string countryCodes)
    //{
    //    return TerritoryBroker.IsSameRightContainBothTerritory(territoryCode, countryCodes);
    //}
}
