using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for ModuleWorkFlowDetail
/// </summary>
public class ModuleWorkFlowDetail:Persistent {
    #region-----------Constructor-------------
    public ModuleWorkFlowDetail()
	{
        OrderByColumnName = "module_workflow_detail_code";
        OrderByCondition = "ASC";
    }
    #endregion

    #region-----------Attributes--------------
    private SystemModule _objModule;
   	private int _recordCode;
   	private SecurityGroup _objSecurityGroup;
   	private Users _objPrimaryUser;
    private int _roleLevel;
    private string _isDone;
    private SecurityGroup _objNextLevelGroup;
    private string _entryDate;	
    #endregion

    #region-----------Properties--------------

    public SystemModule objModule
    {
        get {
            if (_objModule == null) {
                _objModule = new SystemModule();
            }
            return _objModule; }
        set { _objModule = value; }
    }
	public int recordCode
	{
		get { return _recordCode;}
		set { _recordCode = value;}
	}
	public SecurityGroup objSecurityGroup
	{
		get { 
            if(_objSecurityGroup==null){
                _objSecurityGroup=new SecurityGroup();
            }
            return _objSecurityGroup;}
		set { _objSecurityGroup = value;}
	}
	public Users objPrimaryUser
	{
		get { 
            if(_objPrimaryUser==null){
                _objPrimaryUser=new Users();
            }
            return _objPrimaryUser;}
		set { _objPrimaryUser = value;}
	}
	public int roleLevel
	{
		get { return _roleLevel;}
		set { _roleLevel = value;}
	}
    public string isDone
	{
		get { return _isDone;}
		set { _isDone = value;}
	}
    public SecurityGroup objNextLevelGroup
    {
        get {
            if (_objNextLevelGroup == null) {
                _objNextLevelGroup = new SecurityGroup();
            }
            return _objNextLevelGroup; }
        set { _objNextLevelGroup = value; }
    }
    public string entryDate
    {
        get { return _entryDate; }
        set { _entryDate = value; }
    }
    #endregion

    #region-----------Methods-----------------
    public override DatabaseBroker GetBroker()
    {
        return new ModuleWorkFlowDetailBroker();
    }

    public override void UnloadObjects()
    {
        throw new Exception("The method or operation is not implemented.");
    }
    public bool IsModuleWorkFlowLevelDone(int moduleCode, int recordCode, int level) {
        return ((ModuleWorkFlowDetailBroker)this.GetBroker()).IsModuleWorkFlowLevelDone(moduleCode, recordCode, level);
    }
    public DataSet getdsNextApprover(int moduleCode, int recordCode, string strSearch)
    {
        return ((ModuleWorkFlowDetailBroker)this.GetBroker()).getdsNextApprover(moduleCode, recordCode, strSearch);
    }
    //public bool getProcessApproverAction(Persistent obj, DataSet dsWFDtl, string isLvlDone, int userCode, string usrStatus, string strRemarks)
    //{
    //    return ((ModuleWorkFlowDetailBroker)this.GetBroker()).getProcessApproverAction(obj, dsWFDtl, isLvlDone, userCode, usrStatus, strRemarks);
    //}
    public void UpdateWorkflowDetailOnRejection(int moduleCode, int recordCode, SqlTransaction sqlTrans)
    {
        ((ModuleWorkFlowDetailBroker)this.GetBroker()).UpdateWorkflowDetailOnRejection(moduleCode, recordCode, sqlTrans);
    }
    public int getDeleteWorkFlowModuleDetails(int moduleCode, int recordCode, SqlTransaction sqlTrans)
    {
        return ((ModuleWorkFlowDetailBroker)this.GetBroker()).getDeleteWorkFlowModuleDetails(moduleCode, recordCode, sqlTrans);
    }
    #endregion

}
