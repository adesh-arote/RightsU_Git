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
public class  WorkflowModuleBU : Persistent
{
	public  WorkflowModuleBU()
	{
        OrderByColumnName = "Workflow_Module_BU_Code";
		//OrderByCondition= "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _WorkflowModuleCode;
	public int WorkflowModuleCode
	{
		get { return this._WorkflowModuleCode; }
		set { this._WorkflowModuleCode = value; }
	}

	private int _WorkflowBUCode;
	public int WorkflowBUCode
	{
		get { return this._WorkflowBUCode; }
		set { this._WorkflowBUCode = value; }
	}

	private int _BusinessUnitCode;
	public int BusinessUnitCode
	{
		get { return this._BusinessUnitCode; }
		set { this._BusinessUnitCode = value; }
	}

    private string _BusinessUnitName;
    public string BusinessUnitName
    {
        get { return this._BusinessUnitName; }
        set { this._BusinessUnitName = value; }
    }

    private WorkflowBU _objWorkflowBU;
    public WorkflowBU objWorkflowBU
    {
        get
        {
            if (_objWorkflowBU == null)
            {
                _objWorkflowBU = new WorkflowBU();
            }
            return _objWorkflowBU;
        }
        set { _objWorkflowBU = value; }
    }

    private ArrayList _arrWorkflowModuleBURole;
    public ArrayList arrWorkflowModuleBURole
    {
        get
        {
            if (_arrWorkflowModuleBURole == null)
            {
                _arrWorkflowModuleBURole = new ArrayList();
            }
            return _arrWorkflowModuleBURole;
        }
        set { _arrWorkflowModuleBURole = value; }
    }

    private ArrayList _arrWorkflowModuleBURole_Del;
    public ArrayList arrWorkflowModuleBURole_Del
    {
        get
        {
            if (_arrWorkflowModuleBURole_Del == null)
            {
                _arrWorkflowModuleBURole_Del = new ArrayList();
            }
            return _arrWorkflowModuleBURole_Del;
        }
        set { _arrWorkflowModuleBURole_Del = value; }
    }
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new WorkflowModuleBUBroker();
    }

	public override void LoadObjects()
    {
        if (this.IntCode > 0)
        {
            WorkflowModuleBURole objWorkflowModuleBURole = new WorkflowModuleBURole();
            this.arrWorkflowModuleBURole = FillArrayList(objWorkflowModuleBURole, " and Workflow_Module_BU_Code=" + this.IntCode, true);
        }
	}

    public override void UnloadObjects()
    {
        foreach (WorkflowModuleBURole objWorkflowModuleBURole in this.arrWorkflowModuleBURole)
        {
            objWorkflowModuleBURole.SqlTrans = this.SqlTrans;
            objWorkflowModuleBURole.IsTransactionRequired = true;
            objWorkflowModuleBURole.WorkflowModuleBUCode = this.IntCode;
            objWorkflowModuleBURole.Save();
        }

        foreach (WorkflowModuleBURole objWorkflowModuleBURole_Del in this.arrWorkflowModuleBURole_Del)
        {
            objWorkflowModuleBURole_Del.IsTransactionRequired = true;
            objWorkflowModuleBURole_Del.SqlTrans = this.SqlTrans;
            objWorkflowModuleBURole_Del.IsDeleted = true;
            objWorkflowModuleBURole_Del.Save();
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
    #endregion    
}
