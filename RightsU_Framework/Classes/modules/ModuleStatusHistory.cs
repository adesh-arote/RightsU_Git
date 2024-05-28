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
/// Summary description for ModuleStatusHistory
/// </summary>
public class ModuleStatusHistory:Persistent {
    #region-----------Constructor-------------
    public ModuleStatusHistory()
	{
        OrderByColumnName = "module_status_code";
        OrderByCondition = "ASC";
    }
    #endregion

    #region-----------Attributes--------------
    private SystemModule _objModule;
    private int _recordCode;
    private string _status;
    private Users _objStatusChangedBy;
    private string _statusChangedOn;
    private string _remarks;
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
        get { return _recordCode; }
        set { _recordCode = value; }
    }
    public string status
    {
        get { return _status; }
        set { _status = value; }
    }
    public Users objStatusChangedBy
    {
        get { 
            if(_objStatusChangedBy==null){
                _objStatusChangedBy = new Users();
            }
            return _objStatusChangedBy; }
        set { _objStatusChangedBy = value; }
    }
    public string statusChangedOn
    {
        get { return _statusChangedOn; }
        set { _statusChangedOn = value; }
    }
    public string remarks
    {
        get { return _remarks; }
        set { _remarks = value; }
    }
	
    #endregion

    #region-----------Methods-----------------
    public override DatabaseBroker GetBroker()
    {
        return new ModuleStatusHistoryBroker();
    }
    public override void LoadObjects()
    {
        if (objStatusChangedBy.IntCode > 0) {
            objStatusChangedBy.FetchDeep();
        }
    }
    public override void UnloadObjects()
    {
        throw new Exception("The method or operation is not implemented.");
    }
    #endregion
}
