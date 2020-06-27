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
public class RoyaltyCommission : Persistent
{
    public RoyaltyCommission()
    {
        OrderByColumnName = "royalty_commission_name";
        OrderByCondition = "ASC";
        tableName = "Royalty_Commission";
        pkColName = "Royalty_Commission_code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _RoyaltyCommissionName;
    public string RoyaltyCommissionName
    {
        get { return this._RoyaltyCommissionName; }
        set { this._RoyaltyCommissionName = value; }
    }


    private ArrayList _arrRoyaltyCommissionDetails_Del;
    public ArrayList arrRoyaltyCommissionDetails_Del
    {
        get
        {
            if (this._arrRoyaltyCommissionDetails_Del == null)
                this._arrRoyaltyCommissionDetails_Del = new ArrayList();
            return this._arrRoyaltyCommissionDetails_Del;
        }
        set { this._arrRoyaltyCommissionDetails_Del = value; }
    }

    private ArrayList _arrRoyaltyCommissionDetails;
    public ArrayList arrRoyaltyCommissionDetails
    {
        get
        {
            if (this._arrRoyaltyCommissionDetails == null)
                this._arrRoyaltyCommissionDetails = new ArrayList();
            return this._arrRoyaltyCommissionDetails;
        }
        set { this._arrRoyaltyCommissionDetails = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RoyaltyCommissionBroker();
    }

    public override void LoadObjects()
    {

        this.arrRoyaltyCommissionDetails = DBUtil.FillArrayList(new RoyaltyCommissionDetails(), " and royalty_commission_code = '" + this.IntCode + "'", false);
        this.arrRoyaltyCommissionDetails_Del = DBUtil.FillArrayList(new RoyaltyCommissionDetails(), " and royalty_commission_code = '" + this.IntCode + "'", false);

    }

    public override void UnloadObjects()
    {

        if (arrRoyaltyCommissionDetails_Del != null)
        {
            foreach (RoyaltyCommissionDetails objRoyaltyCommissionDetails in this.arrRoyaltyCommissionDetails_Del)
            {
                objRoyaltyCommissionDetails.IsTransactionRequired = true;
                objRoyaltyCommissionDetails.SqlTrans = this.SqlTrans;
                objRoyaltyCommissionDetails.IsDeleted = true;
                objRoyaltyCommissionDetails.Save();
            }
        }
        if (arrRoyaltyCommissionDetails != null)
        {
            foreach (RoyaltyCommissionDetails objRoyaltyCommissionDetails in this.arrRoyaltyCommissionDetails)
            {
                objRoyaltyCommissionDetails.RoyaltyCommissionCode = this.IntCode;
                //objRoyaltyCommissionDetails.IsLastIdRequired = true;
                objRoyaltyCommissionDetails.IsTransactionRequired = true;
                objRoyaltyCommissionDetails.SqlTrans = this.SqlTrans;
                //if (objRoyaltyCommissionDetails.IntCode > 0)
                // objRoyaltyCommissionDetails.IsDirty = true;
                objRoyaltyCommissionDetails.Save();
            }
        }
    }

    #endregion
}
