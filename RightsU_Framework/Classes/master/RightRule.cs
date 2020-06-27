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
public class  RightRule : Persistent
{
	public  RightRule()
	{
        OrderByColumnName = "right_rule_name";
		OrderByCondition= "ASC";
        tableName = "right_rule";
        pkColName = "right_rule_code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _RightRuleName;
	public string RightRuleName
	{
		get { return this._RightRuleName; }
		set { this._RightRuleName = value; }
	}

	private string _StartTime;
	public string StartTime
	{
		get { return this._StartTime; }
		set { this._StartTime = value; }
	}

	private int _PlayPerDay;
	public int PlayPerDay
	{
		get { return this._PlayPerDay; }
		set { this._PlayPerDay = value; }
	}

	private int _DurationOfDay;
	public int DurationOfDay
	{
		get { return this._DurationOfDay; }
		set { this._DurationOfDay = value; }
	}

	private int _NoOfRepeat;
	public int NoOfRepeat
	{
		get { return this._NoOfRepeat; }
		set { this._NoOfRepeat = value; }
	}

    private string _Short_Key;
    public string Short_Key
    {
        get { return _Short_Key; }
        set { _Short_Key = value; }
    }

    private bool _IS_First_Air;
    public bool IS_First_Air
    {
        get { return this._IS_First_Air; }
        set { this._IS_First_Air = value; }
    }
	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RightRuleBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
