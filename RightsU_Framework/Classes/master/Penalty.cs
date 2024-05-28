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
public class Penalty : Persistent {
    public Penalty()
    {
        tableName = "Penalty";
        pkColName = "Penalty_Code";
        OrderByColumnName = "Penalty_Name";
        OrderByCondition = "ASC";
    }

    #region ---------------Attributes And Prperties---------------


    private string _PenaltyName;
    public string PenaltyName
    {
        get { return this._PenaltyName; }
        set { this._PenaltyName = value; }
    }

    //private string _IsActive;
    //public string IsActive
    //{
    //    get { return this._IsActive; }
    //    set { this._IsActive = value; }
    //}


    #endregion

    #region ---------------Methods--------------

    public override DatabaseBroker GetBroker()
    {
        return new PenaltyBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
