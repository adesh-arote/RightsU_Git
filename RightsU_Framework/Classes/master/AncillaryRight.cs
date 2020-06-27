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
public class  AncillaryRight : Persistent
{
	public  AncillaryRight()
	{
        OrderByColumnName = "Ancillary_Right_Name";
		OrderByCondition= "ASC";
        tableName = "Ancillary_Right";
        pkColName = "Ancillary_Right_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _AncillaryRightName;
	public string AncillaryRightName
	{
		get { return this._AncillaryRightName; }
		set { this._AncillaryRightName = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new AncillaryRightBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
