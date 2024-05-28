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
/// Summary description for BussinessStamentDetails 
/// </summary>
public class InvoiceOutstandngInfo : Persistent
{
    public InvoiceOutstandngInfo()
    {
        OrderByColumnName = "invoice_outstanding_info_code";
        OrderByCondition = "ASC";
        tableName = "Invoice_Outstandng_Info ";
        pkColName = "invoice_outstanding_info_code";
    }

    #region ---------------Attributes And Prperties---------------

    private int _SyndicationDealCode;
    public int SyndicationDealCode
    {
        get { return this._SyndicationDealCode; }
        set { this._SyndicationDealCode = value; }
    }

    private int _SynDealPaymentTermsCode;
    public int SynDealPaymentTermsCode
    {
        get { return this._SynDealPaymentTermsCode; }
        set { this._SynDealPaymentTermsCode = value; }
    }

    private string _InvoiceNumber;
    public string InvoiceNumber
    {
        get { return this._InvoiceNumber; }
        set { this._InvoiceNumber = value; }
    }

    private double _InvoiceAmount;
    public double InvoiceAmount
    {
        get { return this._InvoiceAmount; }
        set { this._InvoiceAmount = value; }
    }

    private double _PaymentAmount;
    public double PaymentAmount
    {
        get { return this._PaymentAmount; }
        set { this._PaymentAmount = value; }
    }

    private double _PaymentTermsTotalAmount;
    public double PaymentTermsTotalAmount
    {
        get { return this._PaymentTermsTotalAmount; }
        set { this._PaymentTermsTotalAmount = value; }
    }

    private double _OSAmount;
    public double OSAmount
    {
        get { return this._OSAmount; }
        set { this._OSAmount = value; }
    }

    private Title _objTitle;
    public Title objTitle
    {
        get
        {
            if (_objTitle == null)
                this._objTitle = new Title();
            return _objTitle;
        }
        set { _objTitle = value; }
    }

    private PaymentTerm _objPaymentTerm;
    public PaymentTerm objPaymentTerm
    {
        get
        {
            if (_objPaymentTerm == null)
                this._objPaymentTerm = new PaymentTerm();
            return _objPaymentTerm;
        }
        set { _objPaymentTerm = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new InvoiceOutstandngInfoBroker();
    }

    public override void LoadObjects()
    {
        //if (this.TitleCode > 0)
        //{
        //    this.objTitle.IntCode = this.TitleCode;
        //    this.objTitle.Fetch();
        //}

        if (this.SynDealPaymentTermsCode > 0)
        {
            this.objPaymentTerm.IntCode = this.SynDealPaymentTermsCode;
            this.objPaymentTerm.Fetch();
        }

    }

    public override void UnloadObjects()
    {

    }

    public double GetPaymentTermAmount(int SynDealCode, int PaymentTermCode)
    {
        return ((InvoiceOutstandngInfoBroker)this.GetBroker()).GetPaymentTermAmount(SynDealCode, PaymentTermCode);
    }


    #endregion
}

