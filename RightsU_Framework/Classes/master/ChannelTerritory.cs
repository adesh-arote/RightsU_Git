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


public class ChannelTerritory : Persistent
{
    public ChannelTerritory()
    {
        OrderByColumnName = "Channel_Territory_Code";
        OrderByCondition = "ASC";
        tableName = "Channel_Territory";
        pkColName = "Channel_Territory_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _ChannelCode;
    public int ChannelCode
    {
        get { return this._ChannelCode; }
        set { this._ChannelCode = value; }
    }

    private int _InternationalTerritoryCode;
    public int InternationalTerritoryCode
    {
        get { return this._InternationalTerritoryCode; }
        set { this._InternationalTerritoryCode = value; }
    }

    private Country _objCountry;
    public Country objCountry
    {
        get
        {
            if (this._objCountry == null)
                this._objCountry = new Country();
            return this._objCountry;
        }
        set { this._objCountry = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ChannelTerritoryBroker();
    }

    public override void LoadObjects()
    {
        if (this.InternationalTerritoryCode > 0)
        {
            this.objCountry.IntCode = this.InternationalTerritoryCode;
            this.objCountry.Fetch();
        }
    }

    public override void UnloadObjects()
    { }

    #endregion
}
