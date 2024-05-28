using System;

using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for MaterialMedium
/// </summary>
public class ModulePaymentTerm : Persistent {

#region ------------ Constructor ------------

    public ModulePaymentTerm() {
        OrderByColumnName = "payment_terms_code, module_right_code";
        OrderByCondition = "ASC";
    }

#endregion

#region ------------ Attributes ------------

    private PaymentTerms _objPaymentTerms;

    private SystemModuleRight _objSystemModuleRight;

    private bool _isReference;

#endregion

#region ------------ Properties ------------


    public PaymentTerms objPaymentTerms {
        get {
            if (_objPaymentTerms == null) {
                _objPaymentTerms = new PaymentTerms();
            }
            return _objPaymentTerms;
        }
        set { _objPaymentTerms = value; }
    }

    public SystemModuleRight objSystemModuleRight {
        get {
            if (_objSystemModuleRight == null) {
                _objSystemModuleRight = new SystemModuleRight();
            }
            return _objSystemModuleRight; }
        set { _objSystemModuleRight = value; }
    }

    public int paymentTermsCode {
        get { return objPaymentTerms.IntCode; }
    }

    public string paymentTerms {
        get { return objPaymentTerms.paymentTerms; }
    }

    public bool isReference {
        get { return _isReference; }
        set { _isReference = value; }
    }
#endregion

#region ------------ Methods ------------

    public override DatabaseBroker GetBroker() {
        return new ModulePaymentTermBroker();
    }

    public override void LoadObjects() {
        if (objPaymentTerms.IntCode > 0) {
            objPaymentTerms.Fetch();
        }
        if (objSystemModuleRight.IntCode > 0) {
            objSystemModuleRight.Fetch();
        }
    }

    public override void UnloadObjects() {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string getRecordStatus(out int UserIntcode) {
        return this.GetBroker().getRecordStatus(this, out UserIntcode);
    }

    public override void refreshRecord() {
        this.GetBroker().refreshRecord(this);
    }

    public override void unlockRecord() {
        this.GetBroker().unlockRecord(this);
    }

#endregion
}