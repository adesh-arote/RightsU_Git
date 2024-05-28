using System;
using System.Data;

using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for ModulePaymentTermBroker
/// </summary>
public class ModulePaymentTermBroker : DatabaseBroker {

#region ------------ Constructor ------------

    public ModulePaymentTermBroker() {
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
        return DBUtil.IsDuplicate(myConnection, "Payment_Terms_Module_Right", "payment_terms_code", ((ModulePaymentTerm)obj).objPaymentTerms.IntCode.ToString(), "payment_terms_module_right_code", obj.IntCode, "Module Payment Term" + " " + "already exists", " module_right_code = " + ((ModulePaymentTerm)obj).objSystemModuleRight.IntCode + " ");
    }

    public override string GetActivateDeactivateSql(Persistent obj) {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString) {
        return " SELECT Count(*) FROM Payment_Terms_Module_Right WHERE payment_terms_module_right_code > 0 " + strSearchString + " ";
    }

    public override string GetDeleteSql(Persistent obj) {
        return " DELETE FROM Payment_Terms_Module_Right WHERE payment_terms_module_right_code = " + obj.IntCode + " ";
    }

    public override string GetInsertSql(Persistent obj) {
        ModulePaymentTerm objModulePayTerm = (ModulePaymentTerm)obj;
        return " INSERT INTO Payment_Terms_Module_Right(payment_terms_code, module_right_code, last_action_by, last_update_time) VALUES('" + objModulePayTerm.objPaymentTerms.IntCode + "', " + objModulePayTerm.objSystemModuleRight.IntCode + ", " + obj.InsertedBy + ", getDate()) ";
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString) {
        string strSelect = " SELECT payment_terms_module_right_code, payment_terms_code, module_right_code, last_action_by, lock_time, last_update_time FROM Payment_Terms_Module_Right WHERE payment_terms_module_right_code > 0 " + strSearchString + " ";
        if (!objCriteria.IsPagingRequired)
            return strSelect + " ORDER BY " + objCriteria.getASCstr();

        return objCriteria.getPagingSQL(strSelect);
    }

    public override string GetSelectSqlOnCode(Persistent obj) {
        return " SELECT payment_terms_module_right_code, payment_terms_code, module_right_code, last_action_by, lock_time, last_update_time FROM Payment_Terms_Module_Right WHERE payment_terms_module_right_code = " + obj.IntCode + " ";
    }

    public override string GetUpdateSql(Persistent obj) {
        ModulePaymentTerm objModulePayTerm = (ModulePaymentTerm)obj;
        return " UPDATE Payment_Terms_Module_Right SET payment_terms_code = " + objModulePayTerm.objPaymentTerms.IntCode + ", module_right_code = " + objModulePayTerm.objSystemModuleRight.IntCode + ", last_action_by = " + obj.LastUpdatedBy + ", lock_time = null, last_update_time = getDate() WHERE payment_terms_module_right_code = " + obj.IntCode + " ";
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj) {
        ModulePaymentTerm objModulePayTerm;
        if (obj == null) {
            objModulePayTerm = new ModulePaymentTerm();
        }
        else {
            objModulePayTerm = (ModulePaymentTerm)obj;
        }
        objModulePayTerm.IntCode = Convert.ToInt32(dRow["payment_terms_module_right_code"]);
        objModulePayTerm.objPaymentTerms.IntCode = Convert.ToInt32(dRow["payment_terms_code"]);
        objModulePayTerm.objSystemModuleRight.IntCode = Convert.ToInt32(dRow["module_right_code"]);
        if (dRow["last_update_time"] != DBNull.Value)
            objModulePayTerm.LastUpdatedTime = Convert.ToString(dRow["last_update_time"]);
        if (dRow["lock_time"] != DBNull.Value)
            objModulePayTerm.LockTime = Convert.ToString(dRow["lock_time"]);

        objModulePayTerm.isReference = isReference(objModulePayTerm.objPaymentTerms.IntCode);

        return objModulePayTerm;
    }

    public override string getRecordStatus(Persistent obj, out int UserIntcode) {
        return DBUtil.GetRecordStatus(myConnection, obj, "Payment_Terms_Module_Right", "payment_terms_module_right_code", out UserIntcode);
    }

    public override void refreshRecord(Persistent obj) {
        DBUtil.RefreshOrUnlockRecord(myConnection, obj, "Payment_Terms_Module_Right", "payment_terms_module_right_code", true);
    }

    public override void unlockRecord(Persistent obj) {
        DBUtil.RefreshOrUnlockRecord(myConnection, obj, "Payment_Terms_Module_Right", "payment_terms_module_right_code", false);
    }

    private bool isReference(int payTermCode) {
        return DBUtil.HasRecords(myConnection, "deal_movie_cost_payment_terms", "payment_terms_code", payTermCode.ToString());
    }

#endregion
}
