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
public class CommissionType : Persistent {
    public CommissionType()
    {

		tableName = "Commission_Type";
		pkColName = "commission_type_Code";
		OrderByColumnName = "commission_type_Name";
        OrderByCondition = "ASC";
    }

    #region ---------------Attributes And Prperties---------------


    private string _CommissionTypeName;
    public string CommissionTypeName
    {
        get { return this._CommissionTypeName; }
        set { this._CommissionTypeName = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new CommissionTypeBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
