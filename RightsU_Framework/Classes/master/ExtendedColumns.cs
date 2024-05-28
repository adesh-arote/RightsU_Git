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
public class  ExtendedColumns : Persistent
{
	public  ExtendedColumns()
	{
        OrderByColumnName = "Columns_Name";
        OrderByCondition = "ASC";
        tableName = "Extended_Columns";
        pkColName = "Columns_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _ColumnsName;
	public string ColumnsName
	{
		get { return this._ColumnsName; }
		set { this._ColumnsName = value; }
	}

	private string _ControlType;
	public string ControlType
	{
		get { return this._ControlType; }
		set { this._ControlType = value; }
	}

	private string _IsRef;
	public string IsRef
	{
		get { return this._IsRef; }
		set { this._IsRef = value; }
	}

	private string _IsDefinedValues;
	public string IsDefinedValues
	{
		get { return this._IsDefinedValues; }
		set { this._IsDefinedValues = value; }
	}

	private string _IsMultipleSelect;
	public string IsMultipleSelect
	{
		get { return this._IsMultipleSelect; }
		set { this._IsMultipleSelect = value; }
	}

	private string _RefTable;
	public string RefTable
	{
		get { return this._RefTable; }
		set { this._RefTable = value; }
	}

	private string _RefDisplayField;
	public string RefDisplayField
	{
		get { return this._RefDisplayField; }
		set { this._RefDisplayField = value; }
	}

	private string _RefValueField;
	public string RefValueField
	{
		get { return this._RefValueField; }
		set { this._RefValueField = value; }
	}

	private string _AdditionalCondition;
	public string AdditionalCondition
	{
		get { return this._AdditionalCondition; }
		set { this._AdditionalCondition = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ExtendedColumnsBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
