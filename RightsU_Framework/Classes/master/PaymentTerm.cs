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
public class PaymentTerm : Persistent {
    public PaymentTerm()
    {
        OrderByColumnName = "payment_terms";
        OrderByCondition = "ASC";
        tableName = "Payment_Terms";
        pkColName = "payment_terms_code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _PaymentTermName;
    public string PaymentTermName
    {
        get { return this._PaymentTermName; }
        set { this._PaymentTermName = value; }
    }

    


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new PaymentTermBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
