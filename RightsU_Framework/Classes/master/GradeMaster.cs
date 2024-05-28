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
public class GradeMaster : Persistent
{
    public GradeMaster()
    {
        OrderByColumnName = "Grade_Name";
        OrderByCondition = "ASC";
        tableName = "Grade_Master";
        pkColName = "Grade_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _GradeName;
    public string GradeName
    {
        get { return this._GradeName; }
        set { this._GradeName = value; }
    }

    private string _IsRefExists;
    public string IsRefExists
    {
        get { return this._IsRefExists; }
        set { this._IsRefExists = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new GradeMasterBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
