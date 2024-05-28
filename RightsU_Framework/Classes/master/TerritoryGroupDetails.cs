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
public class TerritoryDetails : Persistent
{
    public TerritoryDetails()
    {
        OrderByColumnName = "Territory_Details_code";
        OrderByCondition = "ASC";
        tableName = "Territory_Details";
        pkColName = "Territory_Details_code";
    }

    #region ---------------Attributes And Prperties---------------

    private Country _objCountry;
    public Country objCountry
    {
        get
        {
            if (this._objCountry == null)
                _objCountry = new Country();
            return (Country)_objCountry;
        }
        set { _objCountry = value; }
    }

    private Territory _objTerritory;
    public Territory objTerritory
    {
        get
        {
            if (this._objTerritory == null)
                _objTerritory = new Territory();
            return (Territory)_objTerritory;
        }
        set { _objTerritory = value; }
    }

    private int _CountryCode;
    public int CountryCode
    {
        get { return this._CountryCode; }
        set { this._CountryCode = value; }
    }

    private int _TerritoryCode;
    public int TerritoryCode
    {
        get { return this._TerritoryCode; }
        set { this._TerritoryCode = value; }
    }

    /* Properties  resuired for checking reerences in acquisition and syndication */
    private string _TerritoryReferInAcq;
    public string TerritoryReferInAcq
    {
        get { return this._TerritoryReferInAcq; }
        set { this._TerritoryReferInAcq = value; }
    }

    private string _TerritoryReferInSyn;
    public string TerritoryReferInSyn
    {
        get { return this._TerritoryReferInSyn; }
        set { this._TerritoryReferInSyn = value; }
    }
    /* Properties  resuired for checking reerences in acquisition and syndication */

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new TerritoryDetailsBroker();
    }

    public override void LoadObjects()
    {

        if (this.TerritoryCode > 0)
        {
            objTerritory.IntCode = this.TerritoryCode;
            objTerritory.Fetch();
        }

        if (this.CountryCode > 0)
        {
            objCountry.IntCode = this.CountryCode;
            objCountry.CountryRefExistsInAcqisition = this._TerritoryReferInAcq;
            objCountry.CountryRefExistsInSyndication = this._TerritoryReferInSyn;
            objCountry.Fetch();
        }
    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
