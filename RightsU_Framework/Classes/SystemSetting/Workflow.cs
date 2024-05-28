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
/// Summary description for Workflow
/// </summary>
public class Workflow : Persistent
{
	public Workflow()
	{
        OrderByColumnName = "workflow_name";
        OrderByCondition = "ASC";
	}

    #region --Members--

    private string _workflowName;
    private string _remarks;    
    private ArrayList _arrWorkflowRole;
    private ArrayList _arrWorkflowBusinessUnit;
    private char _Workflow_Type;
    private int _Business_Unit_Code;

    #endregion


    #region --Properties--

    public string workflowName
    {
        get { return _workflowName; }
        set { _workflowName = value; }
    }
    public string remarks
    {
        get { return _remarks; }
        set { _remarks = value; }
    }

    public char Workflow_Type
    {
        get { return _Workflow_Type; }
        set { _Workflow_Type = value; }
    }

    public int Business_Unit_Code
    {
        get { return _Business_Unit_Code; }
        set { _Business_Unit_Code = value; }
    }
    public ArrayList arrWorkflowRole
    {
        get
        {
            if (_arrWorkflowRole == null)
            {
                _arrWorkflowRole = new ArrayList();
            }
            return _arrWorkflowRole;
        }
        set { _arrWorkflowRole = value; }
    }

    public ArrayList arrWorkflowBusinessUnit
    {
        get
        {
            if (_arrWorkflowBusinessUnit == null)
            {
                _arrWorkflowBusinessUnit = new ArrayList();
            }
            return _arrWorkflowBusinessUnit;
        }
        set { _arrWorkflowBusinessUnit = value; }
    }

    #endregion

    #region --Methods--

    public override DatabaseBroker GetBroker()
    {
        return new WorkflowBroker();
    }
    public override void UnloadObjects()
    {
        foreach (WorkflowRole objWorkflowRole in this.arrWorkflowRole)
        {
            objWorkflowRole.SqlTrans = this.SqlTrans;
            objWorkflowRole.IsTransactionRequired = true;
            objWorkflowRole.workflowCode = this.IntCode;
            switch (objWorkflowRole.recStatus)
            {
                case GlobalParams.LINE_ITEM_DELETED:
                    objWorkflowRole.IsDeleted = true;
                    break;
                case GlobalParams.LINE_ITEM_MODIFIED:
                    objWorkflowRole.IsDirty = true;
                    break;
                case GlobalParams.LINE_ITEM_EXISTING:
                    objWorkflowRole.IsDirty = true;
                    break;
                default:
                    break;
            }            
            objWorkflowRole.Save();
        }
        foreach (WorkflowBU objWorkflowBU in this.arrWorkflowBusinessUnit)
        {
            objWorkflowBU.SqlTrans = this.SqlTrans;
            objWorkflowBU.IsTransactionRequired = true;
            objWorkflowBU.WorkflowCode = this.IntCode;
            objWorkflowBU.IsProxy = false;

            if (objWorkflowBU.IntCode > 0)
                objWorkflowBU.IsDirty = true;

            objWorkflowBU.Save();
        }
    }
    public override void LoadObjects()
    {
        //if (this.Workflow_Type == 'F')
        //{
            WorkflowRole objWorkflowRole = new WorkflowRole();
            this.arrWorkflowRole = FillArrayList(objWorkflowRole, "and workflow_code=" + this.IntCode, true);
        //}
        //else
        //{
        //    WorkflowBU objWorkflowBU = new WorkflowBU();
        //    this.arrWorkflowBusinessUnit = FillArrayList(objWorkflowBU, "and Workflow_Code=" + this.IntCode, true);
        //}
    }
    private ArrayList FillArrayList(Persistent objWorkflowRole, string strSearch, bool isDeepReq)
    {
        if (this.Workflow_Type == 'F')
        {
            objWorkflowRole.OrderByColumnName = "group_level";
        }
        else
            objWorkflowRole.OrderByColumnName = "Business_Unit_Code";
        ArrayList arrFilledObject;
        Criteria ObjCri = new Criteria();
        ObjCri.ClassRef = objWorkflowRole;
        ObjCri.IsSubClassRequired = isDeepReq;
        arrFilledObject = ObjCri.Execute(strSearch);
        return arrFilledObject;
    }

    override public string getRecordStatus()
    {
        return (((WorkflowBroker)this.GetBroker())).getRecordStatus(this);
    }

    override public string getRecordStatus(out int userCode)
    {
        return (((WorkflowBroker)this.GetBroker())).getRecordStatus(this, out userCode);
    }

    override public void unlockRecord()
    {
        (((WorkflowBroker)this.GetBroker())).unlockRecord(this);
    }

    override public void refreshRecord()
    {
        (((WorkflowBroker)this.GetBroker())).refreshRecord(this);
    }
    public bool UsedInAssignWrkFlw(int workFlowCode)
    {
        return (((WorkflowBroker)this.GetBroker())).UsedInAssignWrkFlw(workFlowCode);
    }
    public string GetSecGrpName(int moduleCode,int workFlowCode,int appRightCode)
    {
        return (((WorkflowBroker)this.GetBroker())).GetSecGrpName(moduleCode, workFlowCode, appRightCode);
    }
    #endregion
}
