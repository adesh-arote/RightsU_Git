using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for WrkFlwModuleRole
/// </summary>
public class WorkFlowModuleRole:Persistent
{
    public WorkFlowModuleRole()
	{
        OrderByColumnName = "workflow_module_role_code";
        OrderByCondition = "ASC";
	}
    #region --Members--
    
    private int _workflowModuleCode;
    private WorkflowRole _objWorkflowRole;
    private int _groupLevel;
    private SecurityGroup _objSecurityGroup;
    private int _reminderDays;    

    #endregion


    #region --Properties--

    public int workflowModuleCode
    {
        get { return _workflowModuleCode; }
        set { _workflowModuleCode = value; }
    }
    public WorkflowRole objWorkflowRole
    {
        get
        {
            if (_objWorkflowRole == null)
            {
                _objWorkflowRole = new WorkflowRole();
            }
            return _objWorkflowRole;
        }
        set { _objWorkflowRole = value; }
    }
    public int groupLevel
    {
        get { return _groupLevel; }
        set { _groupLevel = value; }
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
    public int reminderDays
    {
        get { return _reminderDays; }
        set { _reminderDays = value; }
    }    

    #endregion

    #region --Methods--

    public override DatabaseBroker GetBroker()
    {
        return new WorkFlowModuleRoleBroker();
    }
    public override void UnloadObjects()
    {
        
    }
    public override void LoadObjects()
    {
        if (objWorkflowRole.IntCode > 0)
            objWorkflowRole.Fetch();
    }    
    
    #endregion

}
