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
public class AmortRule : Persistent
{
    public AmortRule()
    {
        tableName = "amort_rule";
        pkColName = "amort_rule_code";
        OrderByColumnName = "amort_rule_code";
        OrderByCondition = "ASC";

    }
    public AmortRule(string OrderBy):this()
    {
        OrderByColumnName = OrderBy ;
        OrderByCondition = "ASC";

    }
    #region ---------------Attributes And Prperties---------------



    private string _RuleType;
    public string RuleType
    {
        get { return this._RuleType; }
        set { this._RuleType = value; }
    }

    private string _RuleNo;
    public string RuleNo
    {
        get { return this._RuleNo; }
        set { this._RuleNo = value; }
    }

    private string _RuleDesc;
    public string RuleDesc
    {
        get { return this._RuleDesc; }
        set { this._RuleDesc = value; }
    }

    private string _DistributionType;
    public string DistributionType
    {
        get { return this._DistributionType; }
        set { this._DistributionType = value; }
    }

    private string _PeriodFor;
    public string PeriodFor
    {
        get { return this._PeriodFor; }
        set { this._PeriodFor = value; }
    }

    //private char _YearType;
    //public char YearType
    //{
    //    get { return this._YearType; }
    //    set { this._YearType = value; }
    //}

    private string _YearType;
    public string YearType
    {
        get { return this._YearType; }
        set { this._YearType = value; }
    }

    private int _Nos;
    public int Nos
    {
        get { return this._Nos; }
        set { this._Nos = value; }
    }

    private string _IsActive;
    public string IsActive
    {
        get { return this._IsActive; }
        set { this._IsActive = value; }
    }

    private ArrayList _arrAmortRuleDetails_Del;
    public ArrayList arrAmortRuleDetails_Del
    {
        get
        {
            if (this._arrAmortRuleDetails_Del == null)
                this._arrAmortRuleDetails_Del = new ArrayList();
            return this._arrAmortRuleDetails_Del;
        }
        set { this._arrAmortRuleDetails_Del = value; }
    }

    private ArrayList _arrAmortRuleDetails;
    public ArrayList arrAmortRuleDetails
    {
        get
        {
            if (this._arrAmortRuleDetails == null)
                this._arrAmortRuleDetails = new ArrayList();
            return this._arrAmortRuleDetails;
        }
        set { this._arrAmortRuleDetails = value; }
    }

    /* === Added by sharad === */
    // Dummy Properties
    private int _FromRange;
    public int FromRange
    {
        get
        {
            if (this._FromRange == 0)
            {
                return GlobalParams.nosValInRuleTypePremium;
            }
            else
            {
                return this._FromRange;
            }
        }
        set { this._FromRange = value; }
    }

    private int _ToRange;
    public int ToRange
    {
        get
        { 
          return this._ToRange;            
        }
        set { this._ToRange = value; }
    }

    private decimal _PerCent;
    public decimal PerCent
    {
        get { return this._PerCent; }
        set { this._PerCent = value; }
    }

    private int _Year;
    public int Year
    {
        get { return this._Year; }
        set { this._Year = value; }
    }

    private int _OrFlag;
    public int OrFlag
    {
        get { return this._OrFlag; }
        set { this._OrFlag = value; }
    }


    /* === Added by sharad === */

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new AmortRuleBroker();
    }

    public override void LoadObjects()
    {

        this.arrAmortRuleDetails = DBUtil.FillArrayList(new AmortRuleDetails(), " and amort_rule_code = '" + this.IntCode + "'", false);

    }

    public override void UnloadObjects()
    {

        if (arrAmortRuleDetails_Del != null)
        {
            foreach (AmortRuleDetails objAmortRuleDetails in this.arrAmortRuleDetails_Del)
            {
                objAmortRuleDetails.IsTransactionRequired = true;
                objAmortRuleDetails.SqlTrans = this.SqlTrans;
                objAmortRuleDetails.IsDeleted = true;
                objAmortRuleDetails.Save();
            }
        }
        if (arrAmortRuleDetails != null)
        {
            foreach (AmortRuleDetails objAmortRuleDetails in this.arrAmortRuleDetails)
            {
                objAmortRuleDetails.AmortRuleCode = this.IntCode;
                objAmortRuleDetails.IntCode = 0;
                objAmortRuleDetails.IsTransactionRequired = true;
                objAmortRuleDetails.SqlTrans = this.SqlTrans;
                if (objAmortRuleDetails.IntCode > 0)
                    objAmortRuleDetails.IsDirty = true;
                objAmortRuleDetails.Save();
            }
        }
    }

    public bool IsRuleNoExist(string ruleNo, int ruleCode)
    {
        return (((AmortRuleBroker)this.GetBroker())).IsRuleNoExist(ruleNo, ruleCode);
    }
    public bool IsAmortRuleExist(int ruleCode, int noOfMonth)
    {
        return (((AmortRuleBroker)this.GetBroker())).IsAmortRuleExist(ruleCode, noOfMonth);
    }
    //------------------------------Run-------------------------
    public bool IsAmortRunRuleExist(string ruletype, int noOfMonth, int code)
    {
        return (((AmortRuleBroker)this.GetBroker())).IsAmortRunRuleExist(ruletype, noOfMonth, code);
    }
    //---------------------------------------------------------------------
    public bool IsAmortRuleExistForMulipleChild(int ruleCode, string gridData)
    {
        return (((AmortRuleBroker)this.GetBroker())).IsAmortRuleExistForMulipleChild(ruleCode, gridData);
    }
    public bool IsDupEqlDisAmgRights(int ruleCode)
    {
        return (((AmortRuleBroker)this.GetBroker())).IsDupEqlDisAmgRights(ruleCode);
    }
    public int checkrefrence(int ruleCode)
    {
        return ((AmortRuleBroker)this.GetBroker()).checkrefrence(ruleCode);
    }

    #endregion
}
