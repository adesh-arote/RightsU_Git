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
using System.Collections;

/// <summary>
/// Summary description for Title
/// </summary>
public class SecurityGroupRel : Persistent {
    public SecurityGroupRel()
    {
        OrderByColumnName = "security_rel_code";
        OrderByCondition = "ASC";
    }

    #region ------------- Properties--------------


    private int _securityrelcode;
    public int securityrelcode
    {
        get { return _securityrelcode; }
        set { _securityrelcode = value; }
    }

    private int _securitygroupcode;
    public int securitygroupcode
    {
        get { return _securitygroupcode; }
        set { _securitygroupcode = value; }
    }

    private int _systemmodulerightscode;
    public int systemmodulerightscode
    {
        get { return _systemmodulerightscode; }
        set { _systemmodulerightscode = value; }
    }
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new SecurityGroupRelBroker();
    }

    public override void UnloadObjects()
    {
        throw new Exception("The method or operation is not implemented.");
    }
    #endregion
}
