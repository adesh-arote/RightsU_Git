using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for Title
/// </summary>
public class  BusinessUnit : Persistent
{
	public  BusinessUnit()
	{
        OrderByColumnName = "Business_Unit_Code";
		OrderByCondition= "ASC"; 
        //tableName = "";
        //pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _BusinessUnitName;
	public string BusinessUnitName
	{
		get { return this._BusinessUnitName; }
		set { this._BusinessUnitName = value; }
	}
    private string _IsActive;
    public string IsActive
	{
        get { return this._IsActive; }
        set { this._IsActive = value; }
	}

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new BusinessUnitBroker();
    }

	public override void LoadObjects()
    {
        
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
