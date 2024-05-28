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
public class  ExtendedColumnsValue : Persistent
{
	public  ExtendedColumnsValue()
	{
        OrderByColumnName = "Columns_Value";
        OrderByCondition = "ASC";
        tableName = "Extended_Columns_Value";
        pkColName = "Columns_Value_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _ColumnsCode;
	public int ColumnsCode
	{
		get { return this._ColumnsCode; }
		set { this._ColumnsCode = value; }
	}

	private string _ColumnsValue;
	public string ColumnsValue
	{
		get { return this._ColumnsValue; }
		set { this._ColumnsValue = value; }
	}
    private string _TalentName = "";
    public string TalentName
    {
        get { return _TalentName; }
        set { _TalentName = value; }
    }
    private string _All_Talent_Code="";
    public string All_Talent_Code
    {
        get { return _All_Talent_Code; }
        set { _All_Talent_Code = value; }
    }
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ExtendedColumnsValueBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
