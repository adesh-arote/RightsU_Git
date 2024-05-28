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
public class HouseidType : Persistent
{
    public HouseidType()
    {
        OrderByColumnName = "HouseID_Type_Code";
        OrderByCondition = "ASC";
        tableName = "HouseId_Type";
        pkColName = "HouseID_Type_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _HouseidType_Name;
    public string HouseidType_Name
    {
        get { return this._HouseidType_Name; }
        set { this._HouseidType_Name = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new HouseidTypeBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
