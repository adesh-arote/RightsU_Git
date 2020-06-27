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
/// Summary description for Title
/// </summary>
public class Territory_DoNotUse : Persistent
{
    public Territory_DoNotUse()
    {
        OrderByColumnName = "Territory_Name";
        OrderByCondition = "ASC";
        tableName = "Territory";
        pkColName = "Territory_Code";
    }

    #region ---------------Attributes And Prperties---------------

    private string _TerritoryName;
    public string TerritoryName
    {
        get
        {
            return this._TerritoryName;

        }
        set { this._TerritoryName = value; }
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

    private ArrayList _arrChild;
    public ArrayList arrChild
    {
        get
        {
            return _arrChild;
        }
        set
        {
            _arrChild = value;
        }
    }

    private ArrayList _arrTerritoryGroupDetails;
    public ArrayList arrTerritoryGroupDetails
    {
        get
        {
            if (this._arrTerritoryGroupDetails == null)
                this._arrTerritoryGroupDetails = new ArrayList();
            return this._arrTerritoryGroupDetails;
        }
        set { this._arrTerritoryGroupDetails = value; }
    }

    private ArrayList _del_arrTerritoryGroupDetails;
    public ArrayList del_arrTerritoryGroupDetails
    {
        get
        {
            if (this._del_arrTerritoryGroupDetails == null)
                this._del_arrTerritoryGroupDetails = new ArrayList();
            return this._del_arrTerritoryGroupDetails;
        }
        set { this._del_arrTerritoryGroupDetails = value; }
    }

    //Added By sharad for Reference Validation of Territory Group on 29 Dec 2010
    private string _IsReferenceExist;
    public string IsReferenceExist
    {
        get { return this._IsReferenceExist; }
        set { this._IsReferenceExist = value; }
    }
    //Added By sharad for Reference Validation of Territory Group on Dec 2010

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new Territory_DoNotUse_Broker();
    }

    public override void LoadObjects()
    {
        this.arrTerritoryGroupDetails = DBUtil.FillArrayList(new TerritoryDetails(), " and country_code = '" + this.IntCode + "'", true);
        this.del_arrTerritoryGroupDetails = (ArrayList)this.arrTerritoryGroupDetails.Clone();

        string strTerritoryGroupNames = "";
        string strTerritoryGroupCodes = "";


        foreach (TerritoryDetails obj in this.arrTerritoryGroupDetails)
        {
            if (strTerritoryGroupNames != "")
                strTerritoryGroupNames += ",";
            strTerritoryGroupNames += obj.objTerritory.TerritoryName;

            if (strTerritoryGroupCodes != "")
                strTerritoryGroupCodes += ",";
            strTerritoryGroupCodes += obj.objTerritory.IntCode;

        }
        this.TerritoryGroupNames = strTerritoryGroupNames;
        this.TerritoryGroupCodes = strTerritoryGroupCodes;

    }

    public override void UnloadObjects()
    {

        if (del_arrTerritoryGroupDetails != null)
        {
            foreach (TerritoryDetails objTerritoryGroupDetails in this.del_arrTerritoryGroupDetails)
            {
                objTerritoryGroupDetails.IsTransactionRequired = true;
                objTerritoryGroupDetails.SqlTrans = this.SqlTrans;
                objTerritoryGroupDetails.IsDeleted = true;
                objTerritoryGroupDetails.Save();
            }
        }

        foreach (TerritoryDetails objTerritoryGroupDetails in this.arrTerritoryGroupDetails)
        {
            objTerritoryGroupDetails.CountryCode = this.IntCode;
            objTerritoryGroupDetails.IsTransactionRequired = true;
            objTerritoryGroupDetails.SqlTrans = this.SqlTrans;
            if (objTerritoryGroupDetails.IntCode > 0)
                objTerritoryGroupDetails.IsDirty = true;
            else
                objTerritoryGroupDetails.IsDirty = false;

            objTerritoryGroupDetails.Save();
        }

        //For adding records in Deal Movie Rights Territory 
        int TerritoryCode = this.IntCode;
        string strTerritoryGroupCodes = TerritoryGroupCodes;
        string strSql = " Exec UpdateRerodsInDealMovieRightsTerritory(" + TerritoryCode + "," + strTerritoryGroupCodes + ")";

    }
    public int GetCategoryCode()
    {
        return ((Territory_DoNotUse_Broker)(this.GetBroker())).getCategoryCode(this);
    }

    #endregion 

    public DataSet getAffectedDealList(string strTerritoryGroupCodes)
    {
        return ((TerritoryBroker)(this.GetBroker())).getAffectedDealList(strTerritoryGroupCodes);
    }
}
