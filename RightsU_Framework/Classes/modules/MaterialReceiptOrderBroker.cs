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
/// Summary description for MaterialReceiptOrder
/// </summary>
public class MaterialReceiptOrderBroker : DatabaseBroker
{
	public MaterialReceiptOrderBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [material_receipt_order] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MaterialReceiptOrder objMaterialReceiptOrder;
		if (obj == null)
		{
			objMaterialReceiptOrder = new MaterialReceiptOrder();
		}
		else
		{
			objMaterialReceiptOrder = (MaterialReceiptOrder)obj;
		}

		objMaterialReceiptOrder.IntCode = Convert.ToInt32(dRow["material_receipt_order"]);
		#region --populate--
		if (dRow["material_receipt_code"] != DBNull.Value)
			objMaterialReceiptOrder.MaterialReceiptCode = Convert.ToInt32(dRow["material_receipt_code"]);
		if (dRow["material_order_detail_code"] != DBNull.Value)
			objMaterialReceiptOrder.MaterialOrderDetailCode = Convert.ToInt32(dRow["material_order_detail_code"]);
		if (dRow["received_qantity"] != DBNull.Value)
			objMaterialReceiptOrder.ReceivedQantity = Convert.ToInt32(dRow["received_qantity"]);
		#endregion
                
		return objMaterialReceiptOrder;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		MaterialReceiptOrder objMaterialReceiptOrder = (MaterialReceiptOrder)obj;
		return "insert into [material_receipt_order]([material_receipt_code], [material_order_detail_code], [received_qantity]) values('" + objMaterialReceiptOrder.MaterialReceiptCode + "', '" + objMaterialReceiptOrder.MaterialOrderDetailCode + "', '" + objMaterialReceiptOrder.ReceivedQantity + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		MaterialReceiptOrder objMaterialReceiptOrder = (MaterialReceiptOrder)obj;
		return "update [material_receipt_order] set [material_receipt_code] = '" + objMaterialReceiptOrder.MaterialReceiptCode + "', [material_order_detail_code] = '" + objMaterialReceiptOrder.MaterialOrderDetailCode + "', [received_qantity] = '" + objMaterialReceiptOrder.ReceivedQantity + "' where material_receipt_order = '" + objMaterialReceiptOrder.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		MaterialReceiptOrder objMaterialReceiptOrder = (MaterialReceiptOrder)obj;

		return " DELETE FROM [material_receipt_order] WHERE material_receipt_order = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [material_receipt_order] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [material_receipt_order] WHERE  material_receipt_order = " + obj.IntCode;
    }  
}
