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
public class Category : Persistent
{
    public Category()
    {
        OrderByColumnName = "Category_Name";
        OrderByCondition = "ASC";
        pkColName = "Category_Code";
        tableName = "Category";
    }

    #region ---------------Attributes And Prperties---------------


    private string _CategoryName;
    public string CategoryName
    {
        get { return this._CategoryName; }
        set { this._CategoryName = value; }
    }

    private char _IsActive;
    public char IsActive
    {
        get { return this._IsActive; }
        set { this._IsActive = value; }
    }

    private string _Issystemgenerated;
    public string IsSystemGenerated
    {
        get { return _Issystemgenerated; }
        set { _Issystemgenerated = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new CategoryBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
