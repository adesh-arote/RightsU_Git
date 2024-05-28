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
public class RoyaltyRecoupment : Persistent
{
    public RoyaltyRecoupment()
    {
        OrderByColumnName = "Royalty_Recoupment_Name";
        OrderByCondition = "ASC";
        tableName = "Royalty_Recoupment";
        pkColName = "Royalty_Recoupment_code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _RoyaltyRecoupmentName;
    public string RoyaltyRecoupmentName
    {
        get { return this._RoyaltyRecoupmentName; }
        set { this._RoyaltyRecoupmentName = value; }
    }

    private ArrayList _arrRoyaltyRecoupmentDetails_Del;
    public ArrayList arrRoyaltyRecoupmentDetails_Del
    {
        get
        {
            if (this._arrRoyaltyRecoupmentDetails_Del == null)
                this._arrRoyaltyRecoupmentDetails_Del = new ArrayList();
            return this._arrRoyaltyRecoupmentDetails_Del;
        }
        set { this._arrRoyaltyRecoupmentDetails_Del = value; }
    }

    private ArrayList _arrRoyaltyRecoupmentDetails;
    public ArrayList arrRoyaltyRecoupmentDetails
    {
        get
        {
            if (this._arrRoyaltyRecoupmentDetails == null)
                this._arrRoyaltyRecoupmentDetails = new ArrayList();
            return this._arrRoyaltyRecoupmentDetails;
        }
        set { this._arrRoyaltyRecoupmentDetails = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RoyaltyRecoupmentBroker();
    }

    public override void LoadObjects()
    {

        this.arrRoyaltyRecoupmentDetails = DBUtil.FillArrayList(new RoyaltyRecoupmentDetails(), " and royalty_recoupment_code = '" + this.IntCode + "'", false);

    }

    public override void UnloadObjects()
    {

        if (arrRoyaltyRecoupmentDetails_Del != null)
        {
            foreach (RoyaltyRecoupmentDetails objRoyaltyRecoupmentDetails in this.arrRoyaltyRecoupmentDetails_Del)
            {
                objRoyaltyRecoupmentDetails.IsTransactionRequired = true;
                objRoyaltyRecoupmentDetails.SqlTrans = this.SqlTrans;
                objRoyaltyRecoupmentDetails.IsDeleted = true;
                objRoyaltyRecoupmentDetails.Save();
            }
        }
        if (arrRoyaltyRecoupmentDetails != null)
        {
            foreach (RoyaltyRecoupmentDetails objRoyaltyRecoupmentDetails in this.arrRoyaltyRecoupmentDetails)
            {
                objRoyaltyRecoupmentDetails.RoyaltyRecoupmentCode = this.IntCode;
                objRoyaltyRecoupmentDetails.IsTransactionRequired = true;
                objRoyaltyRecoupmentDetails.SqlTrans = this.SqlTrans;
                if (objRoyaltyRecoupmentDetails.IntCode > 0)
                    objRoyaltyRecoupmentDetails.IsDirty = true;
                objRoyaltyRecoupmentDetails.Save();
            }
        }
    }

    #endregion
}
