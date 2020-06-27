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
public class MaterialType : Persistent {
    public MaterialType()
    {
		tableName = "Material_Type";
		pkColName = "Material_Type_Code";
        OrderByColumnName = "Material_Type_Name";
        OrderByCondition = "ASC";
    }

    #region ---------------Attributes And Prperties---------------


    private string _MaterialTypeName;
    public string MaterialTypeName
    {
        get { return this._MaterialTypeName; }
        set { this._MaterialTypeName = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new MaterialTypeBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
