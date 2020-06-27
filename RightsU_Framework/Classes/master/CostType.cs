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
public class CostType : Persistent {
    public CostType()
    {
        OrderByColumnName = "Cost_Type_Name";
        OrderByCondition = "ASC";
        tableName = "Cost_Type";
        pkColName = "Cost_Type_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _CostTypeName;
    public string CostTypeName
    {
        get { return this._CostTypeName; }
        set { this._CostTypeName = value; }
    }

    private char _IsActive;
    public char IsActive
    {
        get { return this._IsActive; }
        set { this._IsActive = value; }
    }
    private char _Issystemgenerated;
    public char IsSystemGenerated
    {
        get { return _Issystemgenerated; }
        set{_Issystemgenerated=value; }  
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new CostTypeBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
