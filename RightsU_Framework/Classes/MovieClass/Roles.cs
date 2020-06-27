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
/// Summary description for Roles
/// </summary>
public class Roles:Persistent 

{
	public Roles()
	{
        OrderByColumnName = "role_code";
        OrderByCondition = "ASC";
    }


    #region-----------Attributes--------------
    private string _roleName;
    private string _roleType;
    private string _isRateCard;
    #endregion

    #region-----------Properties--------------

    public string roleName
    {
        get { return _roleName; }
        set { _roleName = value; }
    }
    public string roleType
    {
        get { return _roleType; }
        set { _roleType = value; }
    }
    public string isRateCard {
        get { return _isRateCard; }
        set { _isRateCard = value; }
    }
    #endregion

    public override DatabaseBroker GetBroker()
    {
        return new RolesBroker();
    }

    public override void UnloadObjects()
    {
        throw new Exception("The method or operation is not implemented.");
    }
}
