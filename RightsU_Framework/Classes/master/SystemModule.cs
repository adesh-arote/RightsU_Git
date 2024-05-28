using System;
using System.Data;
using System.Configuration;
using System.Web.Security;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for SystemModule
/// </summary>
public class SystemModule : Persistent {
    public SystemModule()
    {
        //
        // TODO: Add constructor logic here
        //
        OrderByColumnName = "module_position";
        OrderByCondition = "ASC";
    }

    #region "----------------------- MEMBER VARIABLES ----------------"

    private string _moduleName;
    private string _modulePosition;
    private string _isSubModule;

    #endregion

    #region "------------------------ PROPERTIES -----------------------"
    public string moduleName
    {
        get { return _moduleName; }
        set { _moduleName = value; }
    }

    public string modulePosition
    {
        get { return _modulePosition; }
        set { _modulePosition = value; }
    }

    public string isSubModule
    {
        get { return _isSubModule; }
        set { _isSubModule = value; }
    }

    #endregion

    #region "-------------------------- METHODS ------------------"
    public override DatabaseBroker GetBroker()
    {
        return new SystemModuleBroker();
    }

    public override void LoadObjects()
    {
        base.LoadObjects();
    }

    public override void UnloadObjects()
    {

    }
    #endregion
}
