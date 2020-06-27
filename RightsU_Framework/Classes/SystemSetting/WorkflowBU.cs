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
public class  WorkflowBU : Persistent
{
	public  WorkflowBU()
	{
		//OrderByColumnName = "";
		//OrderByCondition= "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _WorkflowCode;
	public int WorkflowCode
	{
		get { return this._WorkflowCode; }
		set { this._WorkflowCode = value; }
	}

	private int _BusinessUnitCode;
	public int BusinessUnitCode
	{
		get { return this._BusinessUnitCode; }
		set { this._BusinessUnitCode = value; }
	}

    private ArrayList _arrWorkflowBusinessUnitRole;
    public ArrayList arrWorkflowBusinessUnitRole
    {
        get
        {
            if (this._arrWorkflowBusinessUnitRole == null)
                this._arrWorkflowBusinessUnitRole = new ArrayList();
            return this._arrWorkflowBusinessUnitRole;
        }
        set { this._arrWorkflowBusinessUnitRole = value; }
    }
    private ArrayList _arrWorkflowBusinessUnitRole_Del;
    public ArrayList arrWorkflowBusinessUnitRole_Del
    {
        get
        {
            if (_arrWorkflowBusinessUnitRole_Del == null)
            {
                _arrWorkflowBusinessUnitRole_Del = new ArrayList();
            }
            return _arrWorkflowBusinessUnitRole_Del;
        }
        set { _arrWorkflowBusinessUnitRole_Del = value; }
    }
	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new WorkflowBUBroker();
    }

	public override void LoadObjects()
    {
        this.arrWorkflowBusinessUnitRole = DBUtil.FillArrayList(new WorkflowBURole(), " and Workflow_BU_Code = '" + this.IntCode + "'", false);
	}

    public override void UnloadObjects()
    {
        if (this.arrWorkflowBusinessUnitRole != null)
        {
            foreach (WorkflowBURole objWorkflowBURole in this.arrWorkflowBusinessUnitRole)
            {
                objWorkflowBURole.WorkflowBUCode = this.IntCode;
                objWorkflowBURole.IsTransactionRequired = true;
                objWorkflowBURole.SqlTrans = this.SqlTrans;

                //objPlacementDealChannel.IsProxy = false;

                if (objWorkflowBURole.IntCode > 0)
                    objWorkflowBURole.IsDirty = true;

                objWorkflowBURole.Save();
            }

            if (arrWorkflowBusinessUnitRole_Del != null)
            {
                foreach (WorkflowBURole objWorkflowBURole in this.arrWorkflowBusinessUnitRole_Del)
                {
                    objWorkflowBURole.IsTransactionRequired = true;
                    objWorkflowBURole.SqlTrans = this.SqlTrans;
                    objWorkflowBURole.IsDeleted = true;
                    objWorkflowBURole.Save();
                }
            }
        }
    }
    
    #endregion    
}
