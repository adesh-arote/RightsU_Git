using System;
using System.Data;
using System.Configuration;
using System.Web.Security;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for SystemRight
/// </summary>
public class SystemRight : Persistent {
    public SystemRight()
    {
        OrderByColumnName = "right_code";
        OrderByCondition = "ASC";
    }

    #region "----------------------- MEMBER VARIABLES ----------------"
    private string _rightName;
    #endregion

    #region "------------------------ PROPERTIES -----------------------"
    public string rightName
    {
        get
        {
            return _rightName;
        }
        set
        {
            _rightName = value;
        }
    }
    #endregion

    #region "-------------------------- METHODS ------------------"
    public override DatabaseBroker GetBroker()
    {
        return new SystemRightBroker();
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
