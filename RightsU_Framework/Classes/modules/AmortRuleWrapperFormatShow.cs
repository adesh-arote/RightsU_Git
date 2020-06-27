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
public class AmortRuleWrapperFormatShow: Persistent
{
    public AmortRuleWrapperFormatShow()
    {
        OrderByColumnName = "draft_lfa_code";
        OrderByCondition = "ASC";
        tableName = "Draft_LFA";
        pkColName = "draft_lfa_code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _DealMovieCode;
    public int DealMovieCode
    {
        get { return this._DealMovieCode; }
        set { this._DealMovieCode = value; }
    }

    private int _PAFCode;
    public int PAFCode
    {
        get { return this._PAFCode; }
        set { this._PAFCode = value; }
    }
    private string _PAFName;
    public string PAFName
    {
        get { return this._PAFName; }
        set { this._PAFName = value; }
    }

    private int _amortRuleCode;
    public int amortRuleCode
    {
        get { return this._amortRuleCode; }
        set { this._amortRuleCode = value; }
    }

    private string _amortRuleText;
    public string amortRuleText
    {
        get { return this._amortRuleText; }
        set { this._amortRuleText = value; }
    }


    private decimal _amount;
    public decimal amount
    {
        get { return this._amount; }
        set { this._amount = value; }
    }

    private int _deal_movie_content_code;
    public int deal_movie_content_code
    {
        get { return this._deal_movie_content_code; }
        set { this._deal_movie_content_code = value; }
    }
  


    private int _deal_movie_contents_amort_code;
    public int deal_movie_contents_amort_code
    {
        get { return this._deal_movie_contents_amort_code; }
        set { this._deal_movie_contents_amort_code = value; }
    }

    private string _canChangeAmortRule = "Y";
    public string canChangeAmortRule
    {
        get { return this._canChangeAmortRule; }
        set { this._canChangeAmortRule = value; }
    }



    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new AmortRuleWrapperFromatShowBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }
    #endregion
}