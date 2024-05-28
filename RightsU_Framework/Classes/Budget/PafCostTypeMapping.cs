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
public class  PafCostTypeMapping : Persistent
{
	public  PafCostTypeMapping()
	{
		//OrderByColumnName = "";
		//OrderByCondition= "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _PafCostType;
	public string PafCostType
	{
		get { return this._PafCostType; }
		set { this._PafCostType = value; }
	}

	private int _AmsCostTypeCode;
	public int AmsCostTypeCode
	{
		get { return this._AmsCostTypeCode; }
		set { this._AmsCostTypeCode = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new PafCostTypeMappingBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
