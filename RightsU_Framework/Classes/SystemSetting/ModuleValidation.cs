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
/// Summary description for ModuleValidation
/// </summary>
public class ModuleValidation:Persistent
{
	public ModuleValidation()
	{
        OrderByColumnName = "module_validation_code";
        OrderByCondition = "ASC";
	}
    #region --Members--

    private int _moduleCode;
    private string _tableName;
    private string _primaryColName;
    private string _dateColName;
    
    #endregion


    #region --Properties--

    public int moduleCode
    {
        get { return _moduleCode; }
        set { _moduleCode = value; }
    }
    public string tableName
    {
        get { return _tableName; }
        set { _tableName = value; }
    }
    public string primaryColName
    {
        get { return _primaryColName; }
        set { _primaryColName = value; }
    }
    public string dateColName
    {
        get { return _dateColName; }
        set { _dateColName = value; }
    }    

    #endregion

    #region --Methods--

    public override DatabaseBroker GetBroker()
    {
        return new ModuleValidationBroker();
    }
    public override void UnloadObjects()
    {
       
    }
    public override void LoadObjects()
    {
        
    }
    
    #endregion
}
