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
public class  AmortRuleDetails : Persistent
{
	public  AmortRuleDetails()
	{
        tableName = "amort_rule_details";
        pkColName = "amort_rule_details_code";
        OrderByColumnName = "amort_rule_details_code";
        OrderByCondition = "ASC";
	}	


    #region ---------------Attributes And Prperties---------------
    
	
	private int _AmortRuleCode;
	public int AmortRuleCode
	{
		get { return this._AmortRuleCode; }
		set { this._AmortRuleCode = value; }
	}

	private int _FromRange;
    public int FromRange
	{
		get { return this._FromRange; }
		set { this._FromRange = value; }
	}

    private int _ToRange;
    public int ToRange
	{
		get { return this._ToRange; }
		set { this._ToRange = value; }
	}

	private decimal _PerCent;
    public decimal PerCent
	{
		get { return this._PerCent; }
		set { this._PerCent = value; }
	}

    private int _Month;
    public int Month
	{
		get { return this._Month; }
		set { this._Month = value; }
	}

    private int _Year;
	public int Year
	{
		get { return this._Year; }
		set { this._Year = value; }
	}

    private string _OrFlag;
    public string OrFlag
	{
		get { return this._OrFlag; }
		set { this._OrFlag = value; }
	}

    private int _endofyear;
    public int EndofYear
    {
        get { return _endofyear; }
        set { _endofyear = value; }
    }


    private int _Actual_year;
    public int Actual_year
    {
        get { return _Actual_year; }
        set { _Actual_year = value; } 
    }

    private int _Actual_month;
    public int Actual_month
    {
        get { return _Actual_month; }
        set { _Actual_month = value; }  
        
    }
    private string _Msg;
    public string Msg
    {
        get {
            if (_Msg == null) _Msg = "";
            return this._Msg; }
        set { this._Msg = value; }
    }


    //private char _IsActive;
    //public char IsActive
    //{
    //    get { return this._IsActive; }
    //    set { this._IsActive = value; }
    //}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new AmortRuleDetailsBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
