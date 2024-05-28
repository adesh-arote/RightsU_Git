using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for WorkflowRole
/// </summary>
public class WorkflowRole:Persistent
{
	public WorkflowRole()
	{
        OrderByColumnName = "workflow_role_code";
        OrderByCondition = "ASC";
	}

    #region --Members--

    private int _groupLevel;
    private int _workflowCode;
    private SecurityGroup _objSecurityGroup;
    private Users _objPrimaryUser;
    private string _groupName;
    private string _userName;
    private string _recStatus;
    private int _reminderDays;
    private int _Business_Unit_Code;  


    #endregion

    #region --Properties--

    public int Business_Unit_Code
    {
        get { return _Business_Unit_Code; }
        set { _Business_Unit_Code = value; }
    }
    public int groupLevel
    {
        get { return _groupLevel; }
        set { _groupLevel = value; }
    }
    public int workflowCode
    {
        get { return _workflowCode; }
        set { _workflowCode = value; }
    }
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
    public string groupName
    {
        get { return _groupName; }
        set { _groupName = value; }
    }
    public string userName
    {
        get { return _userName; }
        set { _userName = value; }
    }
    public string recStatus
    {
        get { return _recStatus; }
        set { _recStatus = value; }
    }
    public int reminderDays
    {
        get { return _reminderDays; }
        set { _reminderDays = value; }
    }    
    #endregion

    #region --Methods--

    public override DatabaseBroker GetBroker()
    {
        return new WorkflowRoleBroker();
    }
    public override void UnloadObjects()
    {
        if (this.workflowCode > 0)
        {
            Workflow objWorkflow = new Workflow();
            objWorkflow.IntCode = this.workflowCode;
            objWorkflow.Fetch();
            Business_Unit_Code = objWorkflow.Business_Unit_Code;
        }

    }
    public override void LoadObjects()
    {
        
    }
    public DataSet getWorkFlow_NextGroupCode(int wfcode, int currentLevel)
    {
        return ((WorkflowRoleBroker)this.GetBroker()).getWorkFlow_NextGroupCode(wfcode, currentLevel);
    }
    #endregion

}
