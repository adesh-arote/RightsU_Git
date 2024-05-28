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
/// Summary description for InvoiceOutstandngInfo 
/// </summary>
public class InvoiceOutstandngInfoBroker : DatabaseBroker
{
    public InvoiceOutstandngInfoBroker()
    {
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Invoice_Outstandng_Info] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        InvoiceOutstandngInfo objInvoiceOutstandngInfo;
        if (obj == null)
        {
            objInvoiceOutstandngInfo = new InvoiceOutstandngInfo();
        }
        else
        {
            objInvoiceOutstandngInfo = (InvoiceOutstandngInfo)obj;
        }

        objInvoiceOutstandngInfo.IntCode = Convert.ToInt32(dRow["invoice_outstanding_info_code"]);
        #region --populate--
        if (dRow["syndication_deal_code"] != DBNull.Value)
            objInvoiceOutstandngInfo.SyndicationDealCode = Convert.ToInt32(dRow["syndication_deal_code"]);
        if (dRow["syn_deal_payment_terms_code"] != DBNull.Value)
            objInvoiceOutstandngInfo.SynDealPaymentTermsCode = Convert.ToInt32(dRow["syn_deal_payment_terms_code"]);
        if (dRow["invoice_number"] != DBNull.Value)
            objInvoiceOutstandngInfo.InvoiceNumber = Convert.ToString(dRow["invoice_number"]);
        if (dRow["invoice_amount"] != DBNull.Value)
            objInvoiceOutstandngInfo.InvoiceAmount = Convert.ToDouble(dRow["invoice_amount"]);
        objInvoiceOutstandngInfo.PaymentAmount = Convert.ToDouble(dRow["payment_amount"]);
        if (dRow["lock_time"] != DBNull.Value)
            objInvoiceOutstandngInfo.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objInvoiceOutstandngInfo.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objInvoiceOutstandngInfo.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
        objInvoiceOutstandngInfo.OSAmount = (objInvoiceOutstandngInfo.InvoiceAmount - objInvoiceOutstandngInfo.PaymentAmount);
        objInvoiceOutstandngInfo.PaymentTermsTotalAmount = GetPaymentTermAmount(objInvoiceOutstandngInfo.SyndicationDealCode, objInvoiceOutstandngInfo.SynDealPaymentTermsCode);

        #endregion
        return objInvoiceOutstandngInfo;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        InvoiceOutstandngInfo objInvoiceOutstandngInfo = (InvoiceOutstandngInfo)obj;
        //return DBUtil.IsDuplicate(myConnection, objInvoiceOutstandngInfo.tableName, "Invoice_Number", objInvoiceOutstandngInfo.InvoiceNumber, objInvoiceOutstandngInfo.pkColName, objInvoiceOutstandngInfo.IntCode, "InvoiceNumber", "");
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        InvoiceOutstandngInfo objInvoiceOutstandngInfo = (InvoiceOutstandngInfo)obj;
        string strSql = " insert into [Invoice_Outstandng_Info]([syndication_deal_code],[syn_deal_payment_terms_code],[invoice_number],"
        + " [invoice_amount], [payment_amount], [lock_time],[last_updated_time], [last_action_by]) "
        + " values(" + objInvoiceOutstandngInfo.SyndicationDealCode + ", " + objInvoiceOutstandngInfo.SynDealPaymentTermsCode + "," +
        " '" + objInvoiceOutstandngInfo.InvoiceNumber + "', " + objInvoiceOutstandngInfo.InvoiceAmount + ", "
        + " '" + objInvoiceOutstandngInfo.PaymentAmount + "',"
        + " null,getdate()," + objInvoiceOutstandngInfo.LastActionBy + ")";
        return (strSql);
    }

    public override string GetUpdateSql(Persistent obj)
    {
        InvoiceOutstandngInfo objInvoiceOutstandngInfo = (InvoiceOutstandngInfo)obj;
        return " update [Invoice_Outstandng_Info] set [syndication_deal_code] = '" + objInvoiceOutstandngInfo.SyndicationDealCode + "', "
        + " [syn_deal_payment_terms_code]=" + objInvoiceOutstandngInfo.SynDealPaymentTermsCode + ", "
        + " [invoice_number] = '" + objInvoiceOutstandngInfo.InvoiceNumber + "', "
        + " [invoice_amount] = " + objInvoiceOutstandngInfo.InvoiceAmount + ", "
        + " [payment_amount] = " + objInvoiceOutstandngInfo.PaymentAmount + ", "
        + " [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = " + objInvoiceOutstandngInfo.LastActionBy + " "
        + " where invoice_outstanding_info_code = '" + objInvoiceOutstandngInfo.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        InvoiceOutstandngInfo objBussinessStatementDetails = (InvoiceOutstandngInfo)obj;

        return " DELETE FROM [Invoice_Outstandng_Info] WHERE invoice_outstanding_info_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        InvoiceOutstandngInfo objBussinessStatementDetails = (InvoiceOutstandngInfo)obj;
        string strSql = "UPDATE [Invoice_Outstandng_Info] SET Is_Active='" + objBussinessStatementDetails.Is_Active + "',[Lock_Time]=null,[Last_Updated_Time] = getDate() WHERE invoice_outstanding_info_code =" + objBussinessStatementDetails.IntCode;
        return (strSql);
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Invoice_Outstandng_Info] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Invoice_Outstandng_Info] WHERE invoice_outstanding_info_code = " + obj.IntCode;
    }


    internal double GetPaymentTermAmount(int SynDealCode, int PaymentTermCode)
    {
        double PaymentTermAmount = 0;
        string strSql = " SELECT dbo.[fn_GetPaymentTermAmount_OS_Info]( " + SynDealCode + " ," + PaymentTermCode + ") ";
        DataSet dsData = new DataSet();
        dsData = ProcessSelect(strSql);

        if (dsData.Tables[0].Rows.Count > 0)
        {
            if (dsData.Tables[0].Rows[0][0] != DBNull.Value)
                PaymentTermAmount = Convert.ToDouble(dsData.Tables[0].Rows[0][0]);
        }


        return PaymentTermAmount;
    }
}




