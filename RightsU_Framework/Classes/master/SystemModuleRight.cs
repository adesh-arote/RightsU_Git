using System;
using System.Data;
using System.Configuration;
using System.Web.Security;
using UTOFrameWork.FrameworkClasses;
/// <summary>
/// </summary>
public class SystemModuleRight : Persistent {
    public SystemModuleRight()
    {
        OrderByColumnName = "module_right_code";
        OrderByCondition = "ASC";//"DESC";
    }
    #region --Members--

    private int _moduleCode;
    private int _rightCode;

    private SystemModule _objSysModule;
    private SystemRight _objSysRight;
    #endregion

    #region --Properties--

    public int moduleCode
    {
        get
        {
            return _moduleCode;
        }

        set
        {
            _moduleCode = value;
        }
    }

    public int rightCode
    {
        get
        {
            return _rightCode;
        }

        set
        {
            _rightCode = value;
        }
    }

    public SystemModule objSysModule
    {
        get
        {
            return _objSysModule;
        }

        set
        {
            _objSysModule = value;
        }
    }

    public SystemRight objSysRight
    {
        get
        {
            return _objSysRight;
        }

        set
        {
            _objSysRight = value;
        }
    }
    #endregion

    #region --Methods--

    public override void LoadObjects()
    {
        this.objSysModule.Fetch();
        this.objSysRight.Fetch();
    }
    public override void UnloadObjects()
    {
        throw new Exception("UnLoadObjects Not Coded");
    }
    public override DatabaseBroker GetBroker()
    {
        return new SystemModuleRightBroker();
    }
    #endregion
}
