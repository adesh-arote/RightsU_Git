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
public class CostCenter : Persistent
{
    public CostCenter()
    {
        tableName = "cost_center";
        pkColName = "cost_center_id";
        OrderByColumnName = "cost_center_name";
        OrderByCondition = "ASC";
    }

    #region ---------------Attributes And Prperties---------------

    private string _cost_center_code;
    public string Cost_Center_Code
    {
        get { return this._cost_center_code; }
        set { this._cost_center_code = value; }
    }

    private string _cost_center_name;
    public string Cost_Center_Name
    {
        get { return this._cost_center_name; }
        set { this._cost_center_name = value; }
    }
    public string Cost_Code_Name {
        get { return this.Cost_Center_Code+"-"+ this._cost_center_name; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new CostCenterBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
