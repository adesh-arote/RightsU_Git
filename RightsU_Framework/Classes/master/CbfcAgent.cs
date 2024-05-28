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
public class CbfcAgent : Persistent {
    public CbfcAgent()
    {
        OrderByColumnName = "Cbfc_Agent_name";
        OrderByCondition = "ASC";
        tableName = "Cbfc_Agent";
        pkColName = "Cbfc_Agent_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _CbfcAgentname;
    public string CbfcAgentname
    {
        get { return this._CbfcAgentname; }
        set { this._CbfcAgentname = value; }
    }

    


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new CbfcAgentBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
