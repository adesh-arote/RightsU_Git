using System;
using System.Data;
using System.Data.SqlClient;
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
/// Summary description for WorkflowModule
/// </summary>
public class WorkflowModule:Persistent
{
	public WorkflowModule()
	{
        OrderByColumnName = "workflow_module_code";
        OrderByCondition = "ASC";
	}

    #region --Members--

    private Workflow _objWorkflow;
    private SystemModule _objSysModule;
    private int _moduleCode;
    private int _idealProcessDays;
    private string _effStartDate;
    private string _sysEndDate;
    private char _isWrkFlwActive;
    private ArrayList _arrWrkflwModRole;
    private ArrayList _arrWrkflwModBU;
    private int _workflowCode;
    private ArrayList _arrWrkflwModBU_Del;
    private int _Business_Unit_Code;

    #endregion


    #region --Properties--

    public Workflow objWorkflow
    {
        get
        {
            if (_objWorkflow == null)
            {
                _objWorkflow = new Workflow();
            }
            return _objWorkflow;
        }
        set { _objWorkflow = value; }
    }
    public SystemModule objSysModule
    {
        get
        {
            if (_objSysModule == null)
            {
                _objSysModule = new SystemModule();
            }
            return _objSysModule;
        }
        set { _objSysModule = value; }
    }
    public int moduleCode
    {
        get { return _moduleCode; }
        set { _moduleCode = value; }
    }
    public int idealProcessDays
    {
        get { return _idealProcessDays; }
        set { _idealProcessDays = value; }
    }
    public string effStartDate
    {
        get { return _effStartDate; }
        set { _effStartDate = value; }
    }
    public string sysEndDate
    {
        get { return _sysEndDate; }
        set { _sysEndDate = value; }
    }
    public char isWrkFlwActive
    {
        get { return _isWrkFlwActive; }
        set { _isWrkFlwActive = value; }
    }
    public ArrayList arrWrkflwModRole
    {
        get
        {
            if (_arrWrkflwModRole == null)
            {
                _arrWrkflwModRole = new ArrayList();
            }
            return _arrWrkflwModRole;
        }
        set { _arrWrkflwModRole = value; }
    }

    public ArrayList arrWrkflwModBU
    {
        get
        {
            if (_arrWrkflwModBU == null)
            {
                _arrWrkflwModBU = new ArrayList();
            }
            return _arrWrkflwModBU;
        }
        set { _arrWrkflwModBU = value; }
    }

    public ArrayList arrWrkflwModBU_Del
    {
        get
        {
            if (_arrWrkflwModBU_Del == null)
            {
                _arrWrkflwModBU_Del = new ArrayList();
            }
            return _arrWrkflwModBU_Del;
        }
        set { _arrWrkflwModBU_Del = value; }
    }

    public int Workflow_Code
    {
        get { return _workflowCode; }
        set { _workflowCode = value; }
    }
    public int Business_Unit_Code
    {
        get { return _Business_Unit_Code; }
        set { _Business_Unit_Code = value; }
    }

    #endregion

    #region --Methods--

    public override DatabaseBroker GetBroker()
    {
        return new WorkflowModuleBroker();
    }
    public override void UnloadObjects()
    {

        foreach (WorkFlowModuleRole objWrkflwModRole in this.arrWrkflwModRole)
        {
            objWrkflwModRole.SqlTrans = this.SqlTrans;
            objWrkflwModRole.IsTransactionRequired = true;
            objWrkflwModRole.workflowModuleCode = this.IntCode;
            objWrkflwModRole.Save();
        }

        foreach (WorkflowModuleBU objWorkflowModuleBU in this.arrWrkflwModBU)
        {
            objWorkflowModuleBU.SqlTrans = this.SqlTrans;
            objWorkflowModuleBU.IsTransactionRequired = true;
            objWorkflowModuleBU.WorkflowModuleCode = this.IntCode;
            objWorkflowModuleBU.IsProxy = false;
            objWorkflowModuleBU.Save();
        }
        foreach (WorkflowModuleBU objWorkflowModuleBU_del in this.arrWrkflwModBU_Del)
        {
            objWorkflowModuleBU_del.IsTransactionRequired = true;
            objWorkflowModuleBU_del.SqlTrans = this.SqlTrans;
            objWorkflowModuleBU_del.IsDeleted = true;
            objWorkflowModuleBU_del.Save();
        }
    }
    public override void LoadObjects()
    {
        if (objWorkflow.IntCode > 0)
            objWorkflow.Fetch();
        if (objSysModule.IntCode > 0)
            objSysModule.Fetch();
        if (objWorkflow.Workflow_Type == 'F')
        {
            WorkFlowModuleRole objWFModuleRole = new WorkFlowModuleRole();
            this.arrWrkflwModRole = FillArrayList(objWFModuleRole, " and workflow_module_code=" + this.IntCode, true);
        }
        else
        {
            WorkflowModuleBU objWorkflowModuleBU = new WorkflowModuleBU();
            this.arrWrkflwModBU = FillArrayList(objWorkflowModuleBU, " and workflow_module_code=" + this.IntCode, true);
        }
    }
    private ArrayList FillArrayList(Persistent objWorkflowRole, string strSearch, bool isDeepReq)
    {
        ArrayList arrFilledObject;
        Criteria ObjCri = new Criteria();
        ObjCri.ClassRef = objWorkflowRole;
        ObjCri.IsSubClassRequired = isDeepReq;
        arrFilledObject = ObjCri.Execute(strSearch);
        return arrFilledObject;
    }

    override public string getRecordStatus()
    {
        return (((WorkflowModuleBroker)this.GetBroker())).getRecordStatus(this);
    }

    override public string getRecordStatus(out int userCode)
    {
        return (((WorkflowModuleBroker)this.GetBroker())).getRecordStatus(this, out userCode);
    }

    override public void unlockRecord()
    {
        (((WorkflowModuleBroker)this.GetBroker())).unlockRecord(this);
    }

    override public void refreshRecord()
    {
        (((WorkflowModuleBroker)this.GetBroker())).refreshRecord(this);
    }
    public void DeleteChildHistory(int wrkFlwModCode,ref SqlTransaction objTrans, string workflowType)
    {
        (((WorkflowModuleBroker)this.GetBroker())).DeleteChildHistory(wrkFlwModCode, ref objTrans, workflowType);
    }

    public bool IsWorkFlowAssignForModule(int moduleCode) { 
        return ((WorkflowModuleBroker)this.GetBroker()).IsWorkFlowAssignForModule(moduleCode);
    }

    public bool IsWorkFlowAssignForModuleGroup(int moduleCode, int groupCode) {
        return ((WorkflowModuleBroker)this.GetBroker()).IsWorkFlowAssignForModuleGroup(moduleCode, groupCode);
    }

    public int getEffeciveWorkFlowCode(int moduleCode,string checkDate){
        return ((WorkflowModuleBroker)this.GetBroker()).getEffeciveWorkFlowCode(moduleCode, checkDate);  
    }

    public string getWorkflowType(int Workflow_Code)
    {
        return ((WorkflowModuleBroker)this.GetBroker()).getWorkflowType(Workflow_Code); 
    }
    #endregion
}
