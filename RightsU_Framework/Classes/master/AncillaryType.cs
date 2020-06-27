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
public class AncillaryType : Persistent
{
    public AncillaryType()
	{
        OrderByColumnName = "Ancillary_Type_Name";
		OrderByCondition= "ASC";
        tableName = "Ancillary_Type";
        pkColName = "Ancillary_Type_Code";
	}
    #region ---------------Attributes And Prperties---------------


    private string _AncillaryTypeName;

    public string AncillaryTypeName
    {
        get { return _AncillaryTypeName; }
        set { _AncillaryTypeName = value; }
    }
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new AncillaryTypeBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion    
}
