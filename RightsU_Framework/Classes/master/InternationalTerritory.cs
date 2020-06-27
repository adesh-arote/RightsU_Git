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
public class Country : Persistent
{
    public Country()
    {
        OrderByColumnName = "Country_Name";
        OrderByCondition = "ASC";
        tableName = "Country";
        pkColName = "Country_Code";
    }

    #region ---------------Attributes And Prperties---------------

    private string _CountryName;
    public string CountryName
    {
        get { return this._CountryName; }
        set { this._CountryName = value; }
    }

    private string _TerritoryGroupCodes;
    public string TerritoryGroupCodes
    {
        get { return this._TerritoryGroupCodes; }
        set { this._TerritoryGroupCodes = value; }
    }

    private string _TerritoryGroupNames;
    public string TerritoryGroupNames
    {
        get { return this._TerritoryGroupNames; }
        set { this._TerritoryGroupNames = value; }
    }

    private string _Is_Theatrical_Territory;
    public string Is_Theatrical_Territory
    {
        get { return this._Is_Theatrical_Territory; }
        set { this._Is_Theatrical_Territory = value; }
    }

    private string _ReferencedTerritoryGroup;   // Added By sharad for Reference Validation of Territory Group on 28 Dec 2010
    public string ReferencedTerritoryGroup
    {
        get { return this._ReferencedTerritoryGroup; }
        set { this._ReferencedTerritoryGroup = value; }
    }

    private string _IsReferenceTerritoryExist;  // Added By sharad for Reference Validation of Territory on 3 Jan 2011
    public string IsReferenceTerritoryExist
    {
        get { return this._IsReferenceTerritoryExist; }
        set { this._IsReferenceTerritoryExist = value; }
    }

    private string _IsDomesticTerritory;        // Added By sharad For Reference Validation Of Territory In Sydication on 7 Jan 2011
    public string IsDomesticTerritory
    {
        get { return this._IsDomesticTerritory; }
        set { this._IsDomesticTerritory = value; }
    }

    private string _ReferencedTerritoryInSyndication;
    public string ReferencedTerritoryInSyndication
    {
        get { return this._ReferencedTerritoryInSyndication; }
        set { this._ReferencedTerritoryInSyndication = value; }
    }

    public string _DomisticTerritoryReferenceCount;
    public string DomisticTerritoryReferenceCount
    {
        get { return this._DomisticTerritoryReferenceCount; }
        set { this._DomisticTerritoryReferenceCount = value; }
    }

    public string _DomisticTerritoryReferenceCountAdd;

    private string _CountryRefExistsInSyndication;  // Added by sharad on June 06 2011 for displaying reference of territory in ACQ and SYN
    public string CountryRefExistsInSyndication
    {
        get { return this._CountryRefExistsInSyndication; }
        set { this._CountryRefExistsInSyndication = value; }
    }

    private string _CountryRefExistsInAcqisition;   // Added by sharad on June 06 2011 for displaying reference of territory in ACQ and SYN
    public string CountryRefExistsInAcqisition
    {
        get { return this._CountryRefExistsInAcqisition; }
        set { this._CountryRefExistsInAcqisition = value; }
    }

    private string _IsIntTerrAdd;                   //Added New Property By Adesh
    public string IsIntTerrAdd
    {
        get { return this._IsIntTerrAdd; }
        set { this._IsIntTerrAdd = value; }
    }

    private string _TerritoryGroupsCode;            //Added New Property By Adesh
    public string TerritoryGroupsCode
    {
        get { return this._TerritoryGroupsCode; }
        set { this._TerritoryGroupsCode = value; }
    }

    private int _ParentCountryCode;
    public int ParentCountryCode
    {
        get { return _ParentCountryCode; }
        set { _ParentCountryCode = value; }
    }

    private string _Language;
    public string Language
    {
        get { return _Language; }
        set { _Language = value; }
    }

    private string _IsRef;
    public string IsRef
    {
        get { return this._IsRef; }
        set { this._IsRef = value; }
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
        set { this._arrTerritoryDetails = value; }
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
        set { this._del_arrTerritoryDetails = value; }
    }

    private ArrayList _arrTerritoryGroups;
    public ArrayList arrTerritoryGroups
    {
        get
        {
            if (this._arrTerritoryGroups == null)
                this._arrTerritoryGroups = new ArrayList();
            return this._arrTerritoryGroups;
        }
        set
        {
            this._arrTerritoryGroups = value;
        }
    }

    private ArrayList _arrInternationalTerritoryLanguage_Del;
    public ArrayList arrInternationalTerritoryLanguage_Del
    {
        get
        {
            if (this._arrInternationalTerritoryLanguage_Del == null)
                this._arrInternationalTerritoryLanguage_Del = new ArrayList();
            return this._arrInternationalTerritoryLanguage_Del;
        }
        set { this._arrInternationalTerritoryLanguage_Del = value; }
    }

    private ArrayList _arrInternationalTerritoryLanguage;
    public ArrayList arrInternationalTerritoryLanguage
    {
        get
        {
            if (this._arrInternationalTerritoryLanguage == null)
                this._arrInternationalTerritoryLanguage = new ArrayList();
            return this._arrInternationalTerritoryLanguage;
        }
        set { this._arrInternationalTerritoryLanguage = value; }
    }

    //private int _LanguageCode;    // Added by sharad for adding langauge
    //public int LanguageCode
    //{
    //    get { return this._LanguageCode; }
    //    set { this._LanguageCode = value; }
    //}
    //private Language _objLanguage;    // Added by sharad for adding langauge
    //public Language objLanguage
    //{
    //    get
    //    {
    //        if (this._objLanguage == null)
    //            this._objLanguage = new Language();
    //        return this._objLanguage;
    //    }
    //    set { this._objLanguage = value; }
    //}

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new CountryBroker();
    }

    public override void LoadObjects()
    {
        this.arrTerritoryDetails = DBUtil.FillArrayList(new TerritoryDetails(), " and country_code = '" + this.IntCode + "'", true);
        this.del_arrTerritoryDetails = (ArrayList)this.arrTerritoryDetails.Clone();

        string strSql = " and territory_code in ( select territory_code from territory_details where Country_code = " + this.IntCode + ")";
        this.arrTerritoryGroups = DBUtil.FillArrayList(new Territory(), strSql, false);

        string strTerritoryGroupNames = "";
        string strTerritoryGroupCodes = "";
        string strUsedTerritoryGroupCodes = "";

        foreach (TerritoryDetails obj in this.arrTerritoryDetails)
        {
            if (strTerritoryGroupNames != "")
                strTerritoryGroupNames += ", ";

            if (strTerritoryGroupCodes != "")
                strTerritoryGroupCodes += ",";

            strTerritoryGroupNames += obj.objTerritory.TerritoryName;
            strTerritoryGroupCodes += obj.objTerritory.IntCode;

            Int32 TerritoryGroupCode = Convert.ToInt32(obj.objTerritory.IntCode);

            //string strUsedTG = ((CountryBroker)(this.GetBroker())).GetUsedTerritoryGroup(TerritoryGroupCode);
            //if (strUsedTG != ""){

            obj.objTerritory.TerritoryRefExistsInAcqisition = obj.TerritoryReferInAcq;
            obj.objTerritory.TerritoryRefExistsInSyndication = obj.TerritoryReferInSyn;

            if (obj.objTerritory.TerritoryRefExistsInAcqisition == "Y" || obj.objTerritory.TerritoryRefExistsInSyndication == "Y")
                obj.objTerritory.IsReferenceExist = "Y";
            else
                obj.objTerritory.IsReferenceExist = "N";

            //strUsedTerritoryGroupCodes += obj.objTerritory.IntCode + "~" + obj.objTerritory.IsReferenceExist + "~" + strUsedTG + "#";
            strUsedTerritoryGroupCodes += obj.objTerritory.IntCode + "~" + obj.objTerritory.IsReferenceExist + "#";
            //}
        }

        this.TerritoryGroupNames = strTerritoryGroupNames;
        this.TerritoryGroupCodes = strTerritoryGroupCodes;
        this.ReferencedTerritoryGroup = strUsedTerritoryGroupCodes;
        this.arrInternationalTerritoryLanguage = DBUtil.FillArrayList(new InternationalTerritoryLanguage(), " and Country_Code = '" + this.IntCode + "'", false);
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
            objTerritoryDetails.CountryCode = this.IntCode;
            objTerritoryDetails.IsTransactionRequired = true;
            objTerritoryDetails.SqlTrans = this.SqlTrans;
            if (objTerritoryDetails.IntCode > 0)
                objTerritoryDetails.IsDirty = true;
            else
                objTerritoryDetails.IsDirty = false;
            objTerritoryDetails.Save();
        }

        SqlTransaction sqlTran = (SqlTransaction)this.SqlTrans;

        if (this.IsIntTerrAdd == "Y")
            ((CountryBroker)(this.GetBroker())).InsertRecordsForDealMassUpdate(this.TerritoryGroupsCode, ref sqlTran, this.LastActionBy);

        //For adding records in Deal Movie Rights Territory 
        int TerritoryCode = this.IntCode;
        string strTerritoryGroupCodes = TerritoryGroupCodes;
        string strSql = " Exec UpdateRerodsInDealMovieRightsTerritory(" + TerritoryCode + "," + strTerritoryGroupCodes + ")";

        if (arrInternationalTerritoryLanguage_Del != null)
        {
            foreach (InternationalTerritoryLanguage objInternationalTerritoryLanguage in this.arrInternationalTerritoryLanguage_Del)
            {
                objInternationalTerritoryLanguage.IsTransactionRequired = true;
                objInternationalTerritoryLanguage.SqlTrans = this.SqlTrans;
                objInternationalTerritoryLanguage.IsDeleted = true;
                objInternationalTerritoryLanguage.Save();
            }
        }

        if (arrInternationalTerritoryLanguage != null)
        {
            foreach (InternationalTerritoryLanguage objInternationalTerritoryLanguage in this.arrInternationalTerritoryLanguage)
            {
                objInternationalTerritoryLanguage.InternationalTerritoryCode = this.IntCode;
                objInternationalTerritoryLanguage.IsTransactionRequired = true;
                objInternationalTerritoryLanguage.SqlTrans = this.SqlTrans;

                if (objInternationalTerritoryLanguage.IntCode > 0)
                    objInternationalTerritoryLanguage.IsDirty = true;

                objInternationalTerritoryLanguage.Save();
            }
        }
    }

    public int GetCategoryCode()
    {
        return ((CountryBroker)(this.GetBroker())).getCategoryCode(this);
    }

    public DataSet getAffectedDealList(string strTerritoryGroupCodes)
    {
        return ((CountryBroker)(this.GetBroker())).getAffectedDealList(strTerritoryGroupCodes);
    }

    //public string getReferenceTerritoriesInSyndication()
    //{
    //    return ((CountryBroker)(this.GetBroker())).GetIsDomisticTerritoryReferenceStatusCountAdd();
    //}

    /* added by prashant	*/
    public string GetUsedTerritoryInSyndication(int territoryCode)
    {
        return ((CountryBroker)(this.GetBroker())).GetUsedTerritoryInSyndication(territoryCode);
    }

    public string GetIsDomisticTerritoryReferenceStatusCountEdit(int territoryCode)
    {
        return ((CountryBroker)(this.GetBroker())).GetIsDomisticTerritoryReferenceStatusCountEdit(territoryCode);
    }

    public string isBaseTerritoryAvailable(string strTerritoryCodeNotIn)
    {
        return ((CountryBroker)(this.GetBroker())).isBaseTerritoryAvailable(strTerritoryCodeNotIn);
    }

    #endregion
}
