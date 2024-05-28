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
/// Summary description for Title
/// </summary>
public class MaterialReceipt : Persistent
{
    public MaterialReceipt()
    {
        OrderByColumnName = "material_receipt_no";
        OrderByCondition= "ASC";
        tableName = "material_receipt";
        pkColName = "material_receipt_code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _MaterialReceiptNo;
    public string MaterialReceiptNo
    {
        get { return this._MaterialReceiptNo; }
        set { this._MaterialReceiptNo = value; }
    }

    private string _ReceivedOn;
    public string ReceivedOn
    {
        get { return this._ReceivedOn; }
        set { this._ReceivedOn = value; }
    }

    private string _Remarks;
    public string Remarks
    {
        get { return this._Remarks; }
        set { this._Remarks = value; }
    }

    //private string _lockTime;
    //public string lockTime
    //{
    //    get { return this._lockTime; }
    //    set { this._lockTime = value; }
    //}

    //private string _lastUpdatedTime;
    //public string lastUpdatedTime
    //{
    //    get { return this._lastUpdatedTime; }
    //    set { this._lastUpdatedTime = value; }
    //}

    
    private string _IsActive;
    public string IsActive
    {
        get { return this._IsActive; }
        set { this._IsActive = value; }
    }

    private ArrayList _arrMaterialReceiptOrder_Del;
    public ArrayList arrMaterialReceiptOrder_Del
    {
        get
        {
            if (this._arrMaterialReceiptOrder_Del == null)
                this._arrMaterialReceiptOrder_Del = new ArrayList();
            return this._arrMaterialReceiptOrder_Del;
        }
        set { this._arrMaterialReceiptOrder_Del = value; }
    }

    private ArrayList _arrMaterialReceiptOrder;
    public ArrayList arrMaterialReceiptOrder
    {
        get
        {
            if (this._arrMaterialReceiptOrder == null)
                this._arrMaterialReceiptOrder = new ArrayList();
            return this._arrMaterialReceiptOrder;
        }
        set { this._arrMaterialReceiptOrder = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new MaterialReceiptBroker();
    }

    public override void LoadObjects()
    {


        this.arrMaterialReceiptOrder = DBUtil.FillArrayList(new MaterialReceiptOrder(), " and material_receipt_code = '" + this.IntCode + "'", false);

    }

    public override void UnloadObjects()
    {

        if (arrMaterialReceiptOrder_Del != null)
        {
            foreach (MaterialReceiptOrder objMaterialReceiptOrder in this.arrMaterialReceiptOrder_Del)
            {
                objMaterialReceiptOrder.IsTransactionRequired = true;
                objMaterialReceiptOrder.SqlTrans = this.SqlTrans;
                objMaterialReceiptOrder.IsDeleted = true;
                objMaterialReceiptOrder.Save();
            }
        }
        if (arrMaterialReceiptOrder != null)
        {
            foreach (MaterialReceiptOrder objMaterialReceiptOrder in this.arrMaterialReceiptOrder)
            {
                objMaterialReceiptOrder.MaterialReceiptCode = this.IntCode;
                objMaterialReceiptOrder.IsTransactionRequired = true;
                objMaterialReceiptOrder.SqlTrans = this.SqlTrans;
                if (objMaterialReceiptOrder.IntCode > 0)
                    objMaterialReceiptOrder.IsDirty = true;
                objMaterialReceiptOrder.Save();

                MaterialOrderDetails objMaterialOrderDetails = new MaterialOrderDetails();
                objMaterialOrderDetails.IntCode = objMaterialReceiptOrder.MaterialOrderDetailCode;
                objMaterialOrderDetails.IsTransactionRequired = true;
                objMaterialOrderDetails.SqlTrans = this.SqlTrans;
                objMaterialOrderDetails.Fetch();
                objMaterialOrderDetails.ReceivedQuantity = objMaterialReceiptOrder.ReceivedQantity;
                objMaterialOrderDetails.IsDirty = true;
                objMaterialOrderDetails.Save();

            }
        }
    }

    #endregion
}
