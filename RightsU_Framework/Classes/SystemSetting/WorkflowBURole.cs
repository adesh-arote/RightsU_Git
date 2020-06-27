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
public class  WorkflowBURole : Persistent
{
	public  WorkflowBURole()
	{
        OrderByColumnName = "Workflow_BU_Code";
		//OrderByCondition= "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------


    private int _GroupLevel;
	public int GroupLevel
	{
		get { return this._GroupLevel; }
		set { this._GroupLevel = value; }
	}

	private int _WorkflowBUCode;
	public int WorkflowBUCode
	{
		get { return this._WorkflowBUCode; }
		set { this._WorkflowBUCode = value; }
	}

	private int _SecurityGroupCode;
	public int SecurityGroupCode
	{
		get { return this._SecurityGroupCode; }
		set { this._SecurityGroupCode = value; }
	}

    private SecurityGroup _objSecurityGroup;
    public SecurityGroup objSecurityGroup
    {
        get
        {
            if (_objSecurityGroup == null)
            {
                _objSecurityGroup = new SecurityGroup();
            }
            return _objSecurityGroup;
        }
        set { _objSecurityGroup = value; }
    }

    private Users _objPrimaryUser;
    public Users objPrimaryUser
    {
        get
        {
            if (_objPrimaryUser == null)
            {
                _objPrimaryUser = new Users();
            }
            return _objPrimaryUser;
        }
        set { _objPrimaryUser = value; }
    }

    private string _groupName;
    public string groupName
    {
        get { return _groupName; }
        set { _groupName = value; }
    }

    private int _BusinessUnitCode;
    public int BusinessUnitCode
    {
        get { return this._BusinessUnitCode; }
        set { this._BusinessUnitCode = value; }
    }

    private string _recordStatus;
    public string recordStatus
    {
        get { return _recordStatus; }
        set { _recordStatus = value; }
    }
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new WorkflowBURoleBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
