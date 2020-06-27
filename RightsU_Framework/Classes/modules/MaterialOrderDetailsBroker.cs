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
/// Summary description for MaterialOrderDetails
/// </summary>
public class MaterialOrderDetailsBroker : DatabaseBroker
{
    public MaterialOrderDetailsBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [material_order_details] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MaterialOrderDetails objMaterialOrderDetails;
        if (obj == null)
        {
            objMaterialOrderDetails = new MaterialOrderDetails();
        }
        else
        {
            objMaterialOrderDetails = (MaterialOrderDetails)obj;
        }

        objMaterialOrderDetails.IntCode = Convert.ToInt32(dRow["material_order_detail_code"]);
        #region --populate--
        if (dRow["material_order_code"] != DBNull.Value)
            objMaterialOrderDetails.MaterialOrderCode = Convert.ToInt32(dRow["material_order_code"]);
        if (dRow["deal_code"] != DBNull.Value)
            objMaterialOrderDetails.DealCode = Convert.ToInt32(dRow["deal_code"]);
        if (dRow["deal_movie_code"] != DBNull.Value)
            objMaterialOrderDetails.DealMovieCode = Convert.ToInt32(dRow["deal_movie_code"]);
        if (dRow["material_medium_code"] != DBNull.Value)
            objMaterialOrderDetails.MaterialMediumCode = Convert.ToInt32(dRow["material_medium_code"]);
        if (dRow["order_quantity"] != DBNull.Value)
            objMaterialOrderDetails.OrderQuantity = Convert.ToInt32(dRow["order_quantity"]);
        if (dRow["currency_code"] != DBNull.Value)
            objMaterialOrderDetails.CurrencyCode = Convert.ToInt32(dRow["currency_code"]);
        if (dRow["rate"] != DBNull.Value)
            objMaterialOrderDetails.Rate = Convert.ToDecimal(dRow["rate"]);
        if (dRow["amount"] != DBNull.Value)
            objMaterialOrderDetails.Amount = Convert.ToDecimal(dRow["amount"]);
        //objMaterialOrderDetails.Remarks = Convert.ToString(dRow["remarks"]);
        if (dRow["received_quantity"] != DBNull.Value)
            objMaterialOrderDetails.ReceivedQuantity = Convert.ToInt32(dRow["received_quantity"]);
        #endregion

       return objMaterialOrderDetails;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        MaterialOrderDetails objMaterialOrderDetails = (MaterialOrderDetails)obj;
        string strSql = "insert into [material_order_details]([material_order_code], [deal_code], [deal_movie_code], [material_medium_code], [order_quantity], [currency_code], [rate], [amount] ) values('" + objMaterialOrderDetails.MaterialOrderCode + "', '" + objMaterialOrderDetails.DealCode + "', '" + objMaterialOrderDetails.DealMovieCode + "', '" + objMaterialOrderDetails.MaterialMediumCode + "', '" + objMaterialOrderDetails.OrderQuantity + "', Null, '" + objMaterialOrderDetails.Rate + "', '" + objMaterialOrderDetails.Amount + "');";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        MaterialOrderDetails objMaterialOrderDetails = (MaterialOrderDetails)obj;
        string strSql = "update [material_order_details] set [material_order_code] = '" + objMaterialOrderDetails.MaterialOrderCode + "', [deal_code] = '" + objMaterialOrderDetails.DealCode + "', [deal_movie_code] = '" + objMaterialOrderDetails.DealMovieCode + "', [material_medium_code] = '" + objMaterialOrderDetails.MaterialMediumCode + "', [order_quantity] = '" + objMaterialOrderDetails.OrderQuantity + "', [currency_code] = Null, [rate] = '" + objMaterialOrderDetails.Rate + "', [amount] = '" + objMaterialOrderDetails.Amount + "',[received_quantity]='" + objMaterialOrderDetails.ReceivedQuantity + "' where material_order_detail_code = '" + objMaterialOrderDetails.IntCode + "';";
        return strSql;
        //, [received_quantity] = '" + objMaterialOrderDetails.ReceivedQuantity + "' 
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        MaterialOrderDetails objMaterialOrderDetails = (MaterialOrderDetails)obj;
        if (objMaterialOrderDetails.arrMaterialReceipt.Count > 0)
            DBUtil.DeleteChild("materialreceipt", objMaterialOrderDetails.arrMaterialReceipt, objMaterialOrderDetails.IntCode, (SqlTransaction)objMaterialOrderDetails.SqlTrans);

        return " DELETE FROM [material_order_details] WHERE material_order_detail_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [material_order_details] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [material_order_details] WHERE  material_order_detail_code = " + obj.IntCode;
    }
}
