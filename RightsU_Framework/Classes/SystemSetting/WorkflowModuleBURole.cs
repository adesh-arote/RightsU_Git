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
public class  WorkflowModuleBURole : Persistent
{
	public  WorkflowModuleBURole()
	{
        OrderByColumnName = "Workflow_Module_BU_Role_Code";
		//OrderByCondition= "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _WorkflowModuleBUCode;
	public int WorkflowModuleBUCode
	{
		get { return this._WorkflowModuleBUCode; }
		set { this._WorkflowModuleBUCode = value; }
	}

	private int _WorkflowBURoleCode;
	public int WorkflowBURoleCode
	{
		get { return this._WorkflowBURoleCode; }
		set { this._WorkflowBURoleCode = value; }
	}

	private string _GroupLevel;
	public string GroupLevel
	{
		get { return this._GroupLevel; }
		set { this._GroupLevel = value; }
	}

	private int _SecurityGroupCode;
	public int SecurityGroupCode
	{
		get { return this._SecurityGroupCode; }
		set { this._SecurityGroupCode = value; }
	}

    private WorkflowBURole _objWorkflowBURole;
    public WorkflowBURole objWorkflowBURole
    {
        get
        {
            if (_objWorkflowBURole == null)
            {
                _objWorkflowBURole = new WorkflowBURole();
            }
            return _objWorkflowBURole;
        }
        set { _objWorkflowBURole = value; }
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
	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new WorkflowModuleBURoleBroker();
    }

	public override void LoadObjects()
    {
        if (SecurityGroupCode > 0)
        {
            objSecurityGroup.IntCode = SecurityGroupCode;
            objSecurityGroup.Fetch();
        }
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
