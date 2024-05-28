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
/// Summary description for PaymentTermsBroker
/// </summary>
public class PaymentTermsBroker : DatabaseBroker
{
#region ------------ Constructor ------------

    public PaymentTermsBroker()
    {
        //
        // TODO: Add constructor logic here
        //
    }

#endregion

#region ------------ Attributes ------------

#endregion

#region ------------ Properties ------------

#endregion

#region ------------ Event Handler ------------

#endregion

#region ------------ Methods ------------

    public override bool CanDelete(Persistent obj, out string strMessage) {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj) {
        PaymentTerms objPaymentTerms = (PaymentTerms)obj;
        return DBUtil.IsDuplicate(myConnection, "Payment_Terms", "payment_terms", objPaymentTerms.paymentTerms.Trim(), "payment_terms_code", obj.IntCode, "Payment Terms already exists", "");
    }

    public override string GetActivateDeactivateSql(Persistent obj) {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString) {
        return " SELECT Count(*) FROM Payment_Terms WHERE payment_terms_code > 0 " + strSearchString + " ";
        
    }

    public override string GetDeleteSql(Persistent obj) {
        return " DELETE FROM Payment_Terms WHERE payment_terms_code = " + obj.IntCode + " ";
    }

    public override string GetInsertSql(Persistent obj) {
        PaymentTerms objPaymentTerms = (PaymentTerms)obj;
        return " INSERT INTO Payment_Terms(payment_terms, last_action_by, last_update_time) VALUES('" + GlobalUtil.ReplaceSingleQuotes(objPaymentTerms.paymentTerms) + "', '" + objPaymentTerms.InsertedBy + "', getDate()) ";
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString) {
        string strSelect = " SELECT payment_terms_code, payment_terms,last_action_by, lock_time, last_update_time FROM Payment_Terms WHERE payment_terms_code > 0 " + strSearchString + " ";
        
        if (!objCriteria.IsPagingRequired)
            return strSelect + " ORDER BY " + objCriteria.getASCstr();

        return objCriteria.getPagingSQL(strSelect);
    }

    public override string GetSelectSqlOnCode(Persistent obj) {
        return " SELECT payment_terms_code, payment_terms,last_action_by, lock_time, last_update_time FROM Payment_Terms WHERE payment_terms_code = " + obj.IntCode + " ";
    }

    public override string GetUpdateSql(Persistent obj) {
        PaymentTerms objPaymentTerms = (PaymentTerms)obj;
        return " UPDATE Payment_Terms SET payment_terms = '" +GlobalUtil.ReplaceSingleQuotes(objPaymentTerms.paymentTerms) + "', last_action_by = '"+ objPaymentTerms.LastUpdatedBy+"', lock_time = null, last_update_time = getDate() WHERE payment_terms_code = " + obj.IntCode + " ";
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj) {
        PaymentTerms objPaymentTerms;
        if (obj == null) {
            objPaymentTerms = new PaymentTerms();
        }
        else {
            objPaymentTerms = (PaymentTerms)obj;
        }
        objPaymentTerms.IntCode = Convert.ToInt32(dRow["payment_terms_code"]);
        objPaymentTerms.paymentTerms = Convert.ToString(dRow["payment_terms"]);
        if (dRow["last_update_time"] != DBNull.Value)
            objPaymentTerms.LastUpdatedTime = Convert.ToString(dRow["last_update_time"]);
        if (dRow["lock_time"] != DBNull.Value)
            objPaymentTerms.LockTime = Convert.ToString(dRow["lock_time"]);

        return objPaymentTerms;
    }

    public override string getRecordStatus(Persistent obj, out int UserIntcode)
    {
        return DBUtil.GetRecordStatus(myConnection, obj, "Payment_Terms", "payment_terms_code", out UserIntcode);
    }

    public override void refreshRecord(Persistent obj) 
    {
        DBUtil.RefreshOrUnlockRecord(myConnection, obj, "Payment_Terms", "payment_terms_code", true);
    }

    public override void unlockRecord(Persistent obj)
    {
        DBUtil.RefreshOrUnlockRecord(myConnection, obj, "Payment_Terms", "payment_terms_code", false);
    }

    internal bool isExistInModulePaymentTerm(PaymentTerms objPaymentTerms) {
        return DBUtil.HasRecords(myConnection, "Payment_Terms_Module_Right", "payment_terms_code", objPaymentTerms.IntCode.ToString());
    }

#endregion
}
