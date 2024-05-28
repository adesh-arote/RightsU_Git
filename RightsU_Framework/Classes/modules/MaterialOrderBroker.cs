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
/// Summary description for MaterialOrder
/// </summary>
public class MaterialOrderBroker : DatabaseBroker
{
    public MaterialOrderBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [material_order] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MaterialOrder objMaterialOrder;
        if (obj == null)
        {
            objMaterialOrder = new MaterialOrder();
        }
        else
        {
            objMaterialOrder = (MaterialOrder)obj;
        }

        objMaterialOrder.IntCode = Convert.ToInt32(dRow["material_order_code"]);
        #region --populate--
        objMaterialOrder.MaterialOrderNo = Convert.ToString(dRow["material_order_no"]);
        if (dRow["material_order_date"] != DBNull.Value)
            objMaterialOrder.MaterialOrderDate = Convert.ToDateTime(dRow["material_order_date"]).ToString("dd/MM/yyyy");
        if (dRow["vendor_code"] != DBNull.Value)
            objMaterialOrder.VendorCode = Convert.ToInt32(dRow["vendor_code"]);
        if (dRow["inserted_on"] != DBNull.Value)
            objMaterialOrder.InsertedOn = Convert.ToString(dRow["inserted_on"]);
        if (dRow["inserted_by"] != DBNull.Value)
            objMaterialOrder.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
        if (dRow["lock_time"] != DBNull.Value)
            objMaterialOrder.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objMaterialOrder.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objMaterialOrder.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
        if (dRow["remarks"] != DBNull.Value)
            objMaterialOrder.Remarks = Convert.ToString(dRow["remarks"]);
        
        objMaterialOrder.Is_Active = Convert.ToString(dRow["is_active"]);
        #endregion

        if (objMaterialOrder.VendorCode > 0)
        {
            Vendor TempVendor = new Vendor();
            TempVendor.IntCode = objMaterialOrder.VendorCode;
            TempVendor.Fetch();
            objMaterialOrder.objVendor = TempVendor;
        }

        return objMaterialOrder;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        MaterialOrder objMaterialOrder = (MaterialOrder)obj;
        //string strSql= "insert into [material_order]([material_order_no], [material_order_date], [vendor_code], [inserted_on], [inserted_by], [lock_time], [last_updated_time], [last_action_by], [is_active]) values('" + objMaterialOrder.MaterialOrderNo.Trim().Replace("'", "''") + "', '" + objMaterialOrder.MaterialOrderDate + "', '" + objMaterialOrder.VendorCode + "', GetDate(), '" + objMaterialOrder.InsertedBy + "',  Null, Null,Null, '" + objMaterialOrder.Is_Active + "');";
        string strSql = "insert into [material_order]([material_order_no], [material_order_date], [vendor_code], [inserted_on], [inserted_by], [lock_time], [last_updated_time], [last_action_by], [is_active], [remarks]) values('" + objMaterialOrder.MaterialOrderNo.Trim().Replace("'", "''") + "', '" + GlobalUtil.GetFormatedDateTime(objMaterialOrder.MaterialOrderDate) + "', '" + objMaterialOrder.VendorCode + "', GetDate(), '" + objMaterialOrder.InsertedBy + "',  Null, Null,Null, '" + objMaterialOrder.Is_Active + "','" + objMaterialOrder.Remarks + "');";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        MaterialOrder objMaterialOrder = (MaterialOrder)obj;
        return "update [material_order] set [material_order_no] = '" + objMaterialOrder.MaterialOrderNo.Trim().Replace("'", "''") + "', [material_order_date] = '" + GlobalUtil.GetFormatedDateTime(objMaterialOrder.MaterialOrderDate) + "', [vendor_code] = '" + objMaterialOrder.VendorCode + "', [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '" + objMaterialOrder.LastActionBy + "', [is_active] = '" + objMaterialOrder.Is_Active + "',[remarks]='" + objMaterialOrder.Remarks + "' where material_order_code = '" + objMaterialOrder.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        MaterialOrder objMaterialOrder = (MaterialOrder)obj;

        if (objMaterialOrder.arrMaterialOrderDetails.Count > 0)
            DBUtil.DeleteChild("MaterialOrderDetails", objMaterialOrder.arrMaterialOrderDetails, objMaterialOrder.IntCode, (SqlTransaction)objMaterialOrder.SqlTrans);

        return " DELETE FROM [material_order] WHERE material_order_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [material_order] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [material_order] WHERE  material_order_code = " + obj.IntCode;
    }
}
