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
using System.Data.SqlClient;

/// <summary>
/// Summary description for PaymentTerm
/// </summary>
public class PaymentTermBroker : DatabaseBroker {
    public PaymentTermBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Payment_Terms] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        PaymentTerm objPaymentTerm;
        if (obj == null)
        {
            objPaymentTerm = new PaymentTerm();
        }
        else
        {
            objPaymentTerm = (PaymentTerm)obj;
        }

        objPaymentTerm.IntCode = Convert.ToInt32(dRow["payment_terms_code"]);
        #region --populate--
        objPaymentTerm.PaymentTermName = Convert.ToString(dRow["payment_terms"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objPaymentTerm.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objPaymentTerm.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objPaymentTerm.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objPaymentTerm.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objPaymentTerm.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objPaymentTerm.Is_Active = Convert.ToString(dRow["Is_Active"]);
        #endregion
        return objPaymentTerm;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        PaymentTerm objPaymentTerm = (PaymentTerm)obj;
        return GlobalUtil.IsDuplicate(myConnection, "Payment_Terms", "payment_terms", objPaymentTerm.PaymentTermName, "payment_terms_code", objPaymentTerm.IntCode, " Record Already Exits", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        PaymentTerm objPaymentTerm = (PaymentTerm)obj;
        return "insert into [Payment_Terms]([payment_terms], [Inserted_On], [Inserted_By], [Is_Active]) values(N'" + objPaymentTerm.PaymentTermName.Trim().Replace("'", "''") + "', GETDATE(), '" + objPaymentTerm.InsertedBy + "', 'Y');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        PaymentTerm objPaymentTerm = (PaymentTerm)obj;
        string strSql = "update [Payment_Terms] set [payment_terms] = N'" + objPaymentTerm.PaymentTermName.Trim().Replace("'", "''") + "', [Lock_Time] = null, [Last_Updated_Time] = getDate(), [Last_Action_By] = '" + objPaymentTerm.LastActionBy + "' where payment_terms_code = '" + objPaymentTerm.IntCode + "';";
        return (strSql);
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        PaymentTerm objPaymentTerm = (PaymentTerm)obj;

        return " DELETE FROM [Payment_Terms] WHERE payment_terms_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        PaymentTerm objPaymentTerm = (PaymentTerm)obj;
        string strSql = " UPDATE [Payment_Terms] SET [Is_Active]='" + objPaymentTerm.Is_Active + "',[Lock_Time]=null,[Last_Updated_Time] = getDate() WHERE  payment_terms_code = '" + objPaymentTerm.IntCode + "';";
        return (strSql);
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Payment_Terms] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Payment_Terms] WHERE  payment_terms_code = " + obj.IntCode;
    }
}
