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

public class AncillaryPlatformMedium : Persistent
{
    public AncillaryPlatformMedium()
    {
        OrderByColumnName = "Ancillary_Platform_Medium_Code";
        OrderByCondition = "ASC";
        tableName = "Ancillary_Platform_Medium";
        pkColName = "Ancillary_Platform_Medium_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _AncillaryPlatformCode;
    public int AncillaryPlatformCode
    {
        get { return this._AncillaryPlatformCode; }
        set { this._AncillaryPlatformCode = value; }
    }

    private int _AncillaryMediumCode;
    public int AncillaryMediumCode
    {
        get { return this._AncillaryMediumCode; }
        set { this._AncillaryMediumCode = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new AncillaryPlatformMediumBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
