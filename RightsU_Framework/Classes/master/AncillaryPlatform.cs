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


public class AncillaryPlatform : Persistent
{
    public AncillaryPlatform()
    {
        OrderByColumnName = "Platform_Name";
        OrderByCondition = "ASC";
        tableName = "Ancillary_Platform";
        pkColName = "Ancillary_Platform_code";

    }
    #region ---------------Attributes And Prperties---------------


    private string _PlatformName;
    public string PlatformName
    {
        get { return _PlatformName; }
        set { _PlatformName = value; }
    }

    private int _PlatformCode;
    public int PlatformCode
    {
        get { return _PlatformCode; }
        set { _PlatformCode = value; }
    }

    private int _AncillaryTypeCode;
    public int AncillaryTypeCode
    {
        get { return _AncillaryTypeCode; }
        set { _AncillaryTypeCode = value; }
    }
    private AncillaryType _objAncillaryType;

    public AncillaryType ObjAncillaryType
    {
        get
        {
            if (_objAncillaryType == null)
                _objAncillaryType = new AncillaryType();
            return _objAncillaryType;
        }
        set { _objAncillaryType = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new AncillaryPlatformBroker();
    }

    public override void LoadObjects()
    {
        if (this.AncillaryTypeCode > 0)
        {
            ObjAncillaryType.IntCode = this.AncillaryTypeCode;
            ObjAncillaryType.IsProxy = false;
            ObjAncillaryType.FetchDeep();
        }
    }

    public override void UnloadObjects()
    {

    }

    #endregion

}