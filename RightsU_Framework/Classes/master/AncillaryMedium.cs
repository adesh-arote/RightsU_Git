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

public class AncillaryMedium : Persistent
{
    public AncillaryMedium()
    {
        OrderByColumnName = "Ancillary_Medium_Name";
        OrderByCondition = "ASC";
        tableName = "Ancillary_Medium";
        pkColName = "Ancillary_Medium_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _AncillaryMediumName;
    public string AncillaryMediumName
    {
        get { return this._AncillaryMediumName; }
        set { this._AncillaryMediumName = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new AncillaryMediumBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
