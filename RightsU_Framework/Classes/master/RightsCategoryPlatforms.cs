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
public class RightsCategoryPlatforms : Persistent
{
    public RightsCategoryPlatforms()
    {
        OrderByColumnName = "rights_category_platforms_code";
        OrderByCondition = "ASC";
        tableName = "rights_category_platforms";
        pkColName = "rights_category_platforms_code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _RightsCategoryCode;
    public int RightsCategoryCode
    {
        get { return this._RightsCategoryCode; }
        set { this._RightsCategoryCode = value; }
    }

    private int _PlatformsCode;
    public int PlatformsCode
    {
        get { return this._PlatformsCode; }
        set { this._PlatformsCode = value; }
    }

    private Platform _objPlatform;
    public Platform objPlatform
    {
        get
        {
            if (_objPlatform == null)
                this._objPlatform = new Platform();
            return _objPlatform;
        }
        set { _objPlatform = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RightsCategoryPlatformsBroker();
    }

    public override void LoadObjects()
    {
        if (this.PlatformsCode > 0)
        {
            objPlatform.IntCode = this.PlatformsCode;
            objPlatform.Fetch();
        }
    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
