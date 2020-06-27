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
public class MaterialOrder : Persistent
{
    public MaterialOrder()
    {
        OrderByColumnName = "material_order_code";
        OrderByCondition = "desc";
        tableName = "material_order";
        pkColName = "material_order_code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _MaterialOrderNo;
    public string MaterialOrderNo
    {
        get { return this._MaterialOrderNo; }
        set { this._MaterialOrderNo = value; }
    }

    private string _MaterialOrderDate;
    public string MaterialOrderDate
    {
        get { return this._MaterialOrderDate; }
        set { this._MaterialOrderDate = value; }
    }

    private int _VendorCode;
    public int VendorCode
    {
        get { return this._VendorCode; }
        set { this._VendorCode = value; }
    }

    private string _Remarks;
    public string Remarks
    {
        get { return this._Remarks; }
        set { this._Remarks = value; }
    }
    //private char _IsActive;
    //public char IsActive
    //{
    //    get { return this._IsActive; }
    //    set { this._IsActive = value; }
    //}
    
    private Vendor _objVendor;
    public Vendor objVendor
    {
        get
        {
            if (this._objVendor == null)
                this._objVendor = new Vendor();
            return this._objVendor;
        }
        set { this._objVendor = value; }
    }

    //private Deal _objDeal;
    //public Deal objDeal
    //{
    //    get
    //    {
    //        if (this._objDeal == null)
    //            this._objDeal = new Deal();
    //        return this._objDeal;
    //    }
    //    set { this._objDeal = value; }
    //}

    private ArrayList _arrMaterialOrderDetails_Del;
    public ArrayList arrMaterialOrderDetails_Del
    {
        get
        {
            if (this._arrMaterialOrderDetails_Del == null)
                this._arrMaterialOrderDetails_Del = new ArrayList();
            return this._arrMaterialOrderDetails_Del;
        }
        set { this._arrMaterialOrderDetails_Del = value; }
    }

    private ArrayList _arrMaterialOrderDetails;
    public ArrayList arrMaterialOrderDetails
    {
        get
        {
            if (this._arrMaterialOrderDetails == null)
                this._arrMaterialOrderDetails = new ArrayList();
            return this._arrMaterialOrderDetails;
        }
        set { this._arrMaterialOrderDetails = value; }
    }



    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new MaterialOrderBroker();
    }

    public override void LoadObjects()
    {

        if (this.VendorCode > 0)
        {
            this.objVendor.IntCode = this.VendorCode;
            this.objVendor.Fetch();
        }

        

        this.arrMaterialOrderDetails = DBUtil.FillArrayList(new MaterialOrderDetails(), " and material_order_code = '" + this.IntCode + "'", true);

        //this.arrMaterialOrderDetails = DBUtil.FillArrayList(new MaterialOrderDetails(), " and material_order_code = '" + this.IntCode + "'", false);

    }

    public override void UnloadObjects()
    {

        if (arrMaterialOrderDetails_Del != null)
        {
            foreach (MaterialOrderDetails objMaterialOrderDetails in this.arrMaterialOrderDetails_Del)
            {
                objMaterialOrderDetails.IsTransactionRequired = true;
                objMaterialOrderDetails.SqlTrans = this.SqlTrans;
                objMaterialOrderDetails.IsDeleted = true;
                objMaterialOrderDetails.Save();
            }
        }
        if (arrMaterialOrderDetails != null)
        {
            foreach (MaterialOrderDetails objMaterialOrderDetails in this.arrMaterialOrderDetails)
            {
                objMaterialOrderDetails.MaterialOrderCode = this.IntCode;
                objMaterialOrderDetails.IsTransactionRequired = true;
                objMaterialOrderDetails.SqlTrans = this.SqlTrans;
                if (objMaterialOrderDetails.IntCode > 0)
                    objMaterialOrderDetails.IsDirty = true;
                objMaterialOrderDetails.Save();
            }
        }

    }

    #endregion
}
