using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for Title
/// </summary>
public class  UsersBusinessUnit : Persistent
{
	public  UsersBusinessUnit()
	{
        OrderByColumnName = "Users_Business_Unit_Code";
        OrderByCondition = "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _UsersCode;
	public int UsersCode
	{
		get { return this._UsersCode; }
		set { this._UsersCode = value; }
	}

	private int _BusinessUnitCode;
	public int BusinessUnitCode
	{
		get { return this._BusinessUnitCode; }
		set { this._BusinessUnitCode = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new UsersBusinessUnitBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
