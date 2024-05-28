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
/// Summary description for MaterialMedium
/// </summary>
public class PaymentTerms : Persistent
{

    #region ------------ Constructor ------------

    public PaymentTerms()
    {
        OrderByColumnName = "payment_terms";
        OrderByCondition = "ASC";
    }

    #endregion

    #region ------------ Attributes ------------
    
    private string _paymentTerms;
    
    #endregion

    #region ------------ Properties ------------


    public string paymentTerms
    {
        get { return _paymentTerms; }
        set { _paymentTerms = value; }
    }

    #endregion

    #region ------------ Methods ------------

    public override DatabaseBroker GetBroker()
    {
        return new PaymentTermsBroker();
    }

    public override void UnloadObjects()
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string getRecordStatus(out int UserIntcode)
    {
        return this.GetBroker().getRecordStatus(this, out UserIntcode);
    }

    public override void refreshRecord()
    {
        this.GetBroker().refreshRecord(this);
    }

    public override void unlockRecord()
    {
        this.GetBroker().unlockRecord(this);
    }

    public bool isExistInModulePaymentTerm() {
        return ((PaymentTermsBroker)this.GetBroker()).isExistInModulePaymentTerm(this);
    }

    #endregion

}

