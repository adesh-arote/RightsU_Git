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
/// Summary description for MaterialReceipt
/// </summary>
public class MaterialReceiptBroker : DatabaseBroker
{
    public MaterialReceiptBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [material_receipt] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MaterialReceipt objMaterialReceipt;
        if (obj == null)
        {
            objMaterialReceipt = new MaterialReceipt();
        }
        else
        {
            objMaterialReceipt = (MaterialReceipt)obj;
        }

        objMaterialReceipt.IntCode = Convert.ToInt32(dRow["material_receipt_code"]);
        #region --populate--
        objMaterialReceipt.MaterialReceiptNo = Convert.ToString(dRow["material_receipt_no"]);
        if (dRow["received_on"] != DBNull.Value)
            objMaterialReceipt.ReceivedOn = Convert.ToDateTime(dRow["received_on"]).ToString("dd/MM/yyyy");
        objMaterialReceipt.Remarks = Convert.ToString(dRow["remarks"]);
        if (dRow["lock_time"] != DBNull.Value)
            objMaterialReceipt.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objMaterialReceipt.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["inserted_on"] != DBNull.Value)
            objMaterialReceipt.InsertedOn = Convert.ToString(dRow["inserted_on"]);
        if (dRow["inserted_by"] != DBNull.Value)
            objMaterialReceipt.InsertedOn = Convert.ToString(dRow["inserted_by"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objMaterialReceipt.InsertedOn = Convert.ToString(dRow["last_action_by"]);
        #endregion
        return objMaterialReceipt;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        MaterialReceipt objMaterialReceipt = (MaterialReceipt)obj;
        string strSql = "insert into [material_receipt]([material_receipt_no], [received_on],[inserted_on],[inserted_by], [remarks]) values('" + objMaterialReceipt.MaterialReceiptNo.Trim().Replace("'", "''") + "', '" + GlobalUtil.GetFormatedDateTime(objMaterialReceipt.ReceivedOn) + "',getdate(), '" + objMaterialReceipt.InsertedBy + "','" + objMaterialReceipt.Remarks.Trim().Replace("'", "''") + "');";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        MaterialReceipt objMaterialReceipt = (MaterialReceipt)obj;
        string strSql = "update [material_receipt] set [material_receipt_no] = '" + objMaterialReceipt.MaterialReceiptNo.Trim().Replace("'", "''") + "', [received_on] = '" + GlobalUtil.GetFormatedDateTime(objMaterialReceipt.ReceivedOn) + "', [remarks] = '" + objMaterialReceipt.Remarks.Trim().Replace("'", "''") + "', [last_updated_time]=getdate(),[last_action_by]='" + objMaterialReceipt.LastActionBy + "' where material_receipt_code = '" + objMaterialReceipt.IntCode + "';";
        return strSql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        MaterialReceipt objMaterialReceipt = (MaterialReceipt)obj;
        if (objMaterialReceipt.arrMaterialReceiptOrder.Count > 0)
            DBUtil.DeleteChild("MaterialReceiptOrder", objMaterialReceipt.arrMaterialReceiptOrder, objMaterialReceipt.IntCode, (SqlTransaction)objMaterialReceipt.SqlTrans);

        return " DELETE FROM [material_receipt] WHERE material_receipt_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [material_receipt] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [material_receipt] WHERE  material_receipt_code = " + obj.IntCode;
    }
}
