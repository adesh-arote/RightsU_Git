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
/// Summary description for BussinessStamentDetails 
/// </summary>
public class BussinessStamentDetails : Persistent
{
    public BussinessStamentDetails()
    {
        OrderByColumnName = "statement_received_date";
        OrderByCondition = "ASC";
        tableName = "Buisness_Statement_Info ";
        pkColName = "buisness_statement_info_code";
    }

    #region ---------------Attributes And Prperties---------------

    private int _SyndicationDealCode;
    public int SyndicationDealCode
    {
        get { return this._SyndicationDealCode; }
        set { this._SyndicationDealCode = value; }
    }
    private int _SyndicationDealMovieCode;
    public int SyndicationDealMovieCode
    {
        get { return this._SyndicationDealMovieCode; }
        set { this._SyndicationDealMovieCode = value; }
    }

    private string _StmtReceivedDate;
    public string StmtReceivedDate
    {
        get { return this._StmtReceivedDate; }
        set { this._StmtReceivedDate = value; }
    }

    private string _Remarks;
    public string Remarks
    {
        get { return this._Remarks; }
        set { this._Remarks = value; }
    }
    private int _TitleCode;
    public int TitleCode
    {
        get { return this._TitleCode; }
        set { this._TitleCode = value; }
    }

    private Title _objTitle;
    public Title objTitle
    {
        get
        {
            if (_objTitle == null)
                this._objTitle = new Title();
            return _objTitle;
        }
        set { _objTitle = value;}
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new BussinessStatementDetailsBroker();
    }

    public override void LoadObjects()
    {
        if (this.TitleCode > 0)
        {
            this.objTitle.IntCode = this.TitleCode;
            this.objTitle.Fetch();
        }

    }

    public override void UnloadObjects()
    {

    }

    #endregion

    

}
