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
public class MaterialMedium : Persistent {
    public MaterialMedium()
    {
		tableName = "Material_Medium";
		pkColName = "Material_Medium_Code";
        OrderByColumnName = "Material_Medium_Name";
        OrderByCondition = "ASC";
    }

    #region ---------------Attributes And Prperties---------------


    private string _MaterialMediumName;
    public string MaterialMediumName
    {
        get { return this._MaterialMediumName; }
        set { this._MaterialMediumName = value; }
    }

    private string _Type;
    public string Type
    {
        get { return this._Type; }
        set { this._Type = value; }
    }

    private int _Duration;
    public int Duration
    {
        get { return this._Duration; }
        set { this._Duration = value; }
    }

    private string _IsQcRequired;
    public string IsQcRequired
    {
        get { return this._IsQcRequired; }
        set { this._IsQcRequired = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new MaterialMediumBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
