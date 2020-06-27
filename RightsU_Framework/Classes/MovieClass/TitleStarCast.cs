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
/// Summary description for MovieStarCast
/// </summary>
public class TitleStarCast:Persistent {
    #region-----------Constructor-------------
    public TitleStarCast()
	{
        OrderByColumnName = "talent_code";
        OrderByCondition = "ASC";
    }
    #endregion

    #region-----------Attributes--------------
    private Talent _objTalent;
    private int _titleCode; 
    private string _status;
    #endregion

    #region-----------Properties--------------
    public Talent objTalent
    {
        get
        {
            if (_objTalent == null)
            {
                _objTalent = new Talent();
            }
            return _objTalent;
        }
        set { _objTalent = value; }
    }
    public int titleCode
    {
        get { return _titleCode; }
        set { _titleCode = value; }
    }
    public string status
    {
        get { return _status; }
        set { _status = value; }
    }
    private int _RoleCode;

    public int RoleCode
    {
        get { return _RoleCode; }
        set { _RoleCode = value; }
    }
    #endregion

    #region-----------Methods-----------------
    public override DatabaseBroker GetBroker()
    {
        return new TitleStarCastBroker();
    }
    public override void LoadObjects()
    {
        if (_objTalent.IntCode > 0) {
            _objTalent.Fetch();
        }
    }
    public override void UnloadObjects()
    {
        throw new Exception("The method or operation is not implemented.");
    }
    #endregion
}
