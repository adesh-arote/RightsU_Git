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
public class GradeException : Persistent
{
    public GradeException()
    {
        OrderByColumnName = "grade_exception_code";
        OrderByCondition = "ASC";
        tableName = "Grade_Exception";
        pkColName = "grade_exception_code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _DealCode;
    public int DealCode
    {
        get { return this._DealCode; }
        set { this._DealCode = value; }
    }

    private int _ExternalTitleCode;
    public int ExternalTitleCode
    {
        get { return this._ExternalTitleCode; }
        set { this._ExternalTitleCode = value; }
    }

    private int _LastGradeCode;
    public int LastGradeCode
    {
        get { return this._LastGradeCode; }
        set { this._LastGradeCode = value; }
    }

    private int _EffMonth;
    public int EffMonth
    {
        get { return this._EffMonth; }
        set { this._EffMonth = value; }
    }

    private int _EffYear;
    public int EffYear
    {
        get { return this._EffYear; }
        set { this._EffYear = value; }
    }

    private string _EffectiveStartDate;
    public string EffectiveStartDate
    {
        get { return this._EffectiveStartDate; }
        set { this._EffectiveStartDate = value; }
    }

    private string _EffectiveEndDate;
    public string EffectiveEndDate
    {
        get { return this._EffectiveEndDate; }
        set { this._EffectiveEndDate = value; }
    }

    private int _NewGradeCode;
    public int NewGradeCode
    {
        get { return this._NewGradeCode; }
        set { this._NewGradeCode = value; }
    }

    private string _IsRoyalty;
    public string IsRoyalty
    {
        get { return this._IsRoyalty; }
        set { this._IsRoyalty = value; }
    }

    private GradeMaster _objGradeMaster;
    public GradeMaster objGradeMaster
    {
        get
        {
            if (this._objGradeMaster == null)
                this._objGradeMaster = new GradeMaster();
            return this._objGradeMaster;
        }
        set { this._objGradeMaster = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new GradeExceptionBroker();
    }

    public override void LoadObjects()
    {
        if (this.NewGradeCode > 0)
        {
            this.objGradeMaster.IntCode = this.NewGradeCode;
            this.objGradeMaster.Fetch();
        }

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
