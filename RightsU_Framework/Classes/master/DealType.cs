using System;
using System.Data;
using System.Configuration;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for Title
/// </summary>
public class DealType : Persistent
{
    public DealType()
    {
        OrderByColumnName = "deal_type_code";
        OrderByCondition = "ASC";
        tableName = "";
        pkColName = "";
    }
    public DealType(string dealTypename, int Code)
    {
        this.IntCode = Code;
        this.DealTypeName = dealTypename;
    }

    #region ---------------Attributes And Prperties---------------

    private int _DealTypeCode;
    public int DealTypeCode
    {
        get { return this._DealTypeCode; }
        set { this._DealTypeCode = value; }
    }

    private string _DealTypeName;
    public string DealTypeName
    {
        get { return this._DealTypeName; }
        set { this._DealTypeName = value; }
    }

    private string _IsDefault;
    public string IsDefault
    {
        get { return this._IsDefault; }
        set { this._IsDefault = value; }
    }

    public string IntCodeIsGridReq_IsMasterDeal
    {
        get { return this.IntCode + "~" + IsGridRequired + "~" + IsMasterDeal; }
    }

    private string _IsGridRequired;
    public string IsGridRequired
    {
        get { return this._IsGridRequired; }
        set { this._IsGridRequired = value; }
    }

    private string _IsActive;
    public string IsActive
    {
        get { return this._IsActive; }
        set { this._IsActive = value; }
    }

    private string _IsMasterDeal = "N";
    public string IsMasterDeal
    {
        get { return this._IsMasterDeal; }
        set { this._IsMasterDeal = value; }
    }

    private string _Deal_Or_Title;
    public string Deal_Or_Title
    {
        get {            
            return _Deal_Or_Title; 
        }
        set { _Deal_Or_Title = value; }
    }
    private int _ParentCode;

    public int ParentCode
    {
        get { return _ParentCode; }
        set { _ParentCode = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new DealTypeBroker();
    }

    public override void LoadObjects()
    {
        
    }

    public override void UnloadObjects()
    {
         
    }

    #endregion
}
