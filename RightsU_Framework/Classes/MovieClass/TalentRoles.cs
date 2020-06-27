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
/// Summary description for TalentDetails
/// </summary>
public class TalentRoles:Persistent 
{
    public TalentRoles()
	{
        OrderByColumnName = "role_code";
        OrderByCondition = "ASC";
	}

    //Roles objRoles
    #region-----------Attributes--------------
    private Roles _objRoles;
    private Int32  _talentCode;
    private string _status;
    #endregion


    #region-----------Properties--------------
    public Roles objRoles
    {
        get
        {
            if (_objRoles == null)
                return new Roles();
            else
                return _objRoles;
        }
        set { _objRoles = value; }
    }
    public Int32  talentCode
    {
        get { return _talentCode; }
        set { _talentCode = value; }
    }

    public string status
    {
        get { return _status; }
        set { _status = value; }
    }
    #endregion

    public override DatabaseBroker GetBroker()
    {
        return new TalentRolesBroker();
    }

    public override void refreshRecord()
    {        
        base.refreshRecord();
    }

    public override void LoadObjects()
    {
        if (this.objRoles.IntCode > 0)
            this.objRoles.Fetch();
    }

    public override void UnloadObjects()
    {
        throw new Exception("The method or operation is not implemented.");
    }
}
