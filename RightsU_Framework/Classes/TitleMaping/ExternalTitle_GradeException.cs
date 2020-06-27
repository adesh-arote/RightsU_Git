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
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for ExternalTitle_GradeException
/// </summary>


public class ExternalTitle_GradeException : Persistent
{
    public ExternalTitle_GradeException()
    {
        OrderByColumnName = "external_title_code";
        OrderByCondition = "ASC";
        tableName = "External_Title";
        pkColName = "external_title_code";
    }

    #region ---------------Attributes And Prperties---------------

    public int ExternalTitleCode
    {
        get { return this.IntCode; }
        set { this.IntCode = value; }
    }

    private string _TitleName;
    public string TitleName
    {
        get { return this._TitleName; }
        set { this._TitleName = value; }
    }

    //private string _CompleteTitleName;
    //public string CompleteTitleName
    //{
    //    get { return this._CompleteTitleName; }
    //    set { this._CompleteTitleName = value; }

    //}

    private string _MasterFormat;
    public string MasterFormat
    {
        get { return this._MasterFormat; }
        set { this._MasterFormat = value; }
    }

    private string _ReleaseDate;
    public string ReleaseDate
    {
        get { return this._ReleaseDate; }
        set { this._ReleaseDate = value; }
    }

    private string _RightsExpiry;
    public string RightsExpiry
    {
        get { return this._RightsExpiry; }
        set { this._RightsExpiry = value; }
    }

    private string _TitleType;
    public string TitleType
    {
        get { return this._TitleType; }
        set { this._TitleType = value; }
    }

    private string _BoxSingle;
    public string BoxSingle
    {
        get { return this._BoxSingle; }
        set { this._BoxSingle = value; }
    }

    private string _SAPInternalOrder;
    public string SAPInternalOrder
    {
        get { return this._SAPInternalOrder; }
        set { this._SAPInternalOrder = value; }
    }

    private int _DealMovieCode;
    public int DealMovieCode
    {
        get { return this._DealMovieCode; }
        set { this._DealMovieCode = value; }
    }

    public string PromotionTitleName
    {
        get
        {
            if (this.IntCode > 0)
            {
                string str = this.TitleName + "-" + this.MasterFormat + "-" + (this.TitleType == "O" ? "Original" : "Dubbed");
                return str;
            }
            return "";
        }
    }

    private string _LastExceptionGrade;
    public string LastExceptionGrade
    {
        get { return this._LastExceptionGrade; }
        set { this._LastExceptionGrade = value; }
    }

    private int _ExceptionGrade_LastGradeCode;  //Value from Grade Exception Table
    public int ExceptionGrade_LastGradeCode
    {
        get { return this._ExceptionGrade_LastGradeCode; }
        set { this._ExceptionGrade_LastGradeCode = value; }
    }

    private string _ExceptionGrade_EffStartDate;        //Value from Grade Exception Table
    public string ExceptionGrade_EffStartDate
    {
        get { return this._ExceptionGrade_EffStartDate; }
        set { this._ExceptionGrade_EffStartDate = value; }
    }

    private string _DealRightStartDate;
    public string DealRightStartDate
    {
        get { return this._DealRightStartDate; }
        set { this._DealRightStartDate = value; }
    }

    private string _DealRightEndDate;
    public string DealRightEndDate
    {
        get { return this._DealRightEndDate; }
        set { this._DealRightEndDate = value; }
    }

    private string _IsRoyaltyCal;
    public string IsRoyaltyCal
    {
        get { return this._IsRoyaltyCal; }
        set { this._IsRoyaltyCal = value; }
    }
        
    //Dummy Properties
    private string _Grade;
    public string Grade
    {
        get { return this._Grade; }
        set { this._Grade = value; }
    }

    private string _EffectiveStartDate;
    public string EffectiveStartDate
    {
        get { return this._EffectiveStartDate; }
        set { this._EffectiveStartDate = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ExternalTitle_GradeExceptionBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion

}
