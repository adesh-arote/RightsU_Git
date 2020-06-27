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
public class  MapExtendedColumnsDetails : Persistent
{
	public  MapExtendedColumnsDetails()
	{
        OrderByColumnName = "Map_Extended_Columns_Code";
        OrderByCondition = "ASC";
        tableName = "Map_Extended_Columns_Details";
        pkColName = "Map_Extended_Columns_Details_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _MapExtendedColumnsCode;
	public int MapExtendedColumnsCode
	{
		get { return this._MapExtendedColumnsCode; }
		set { this._MapExtendedColumnsCode = value; }
	}

	private int _ColumnsValueCode;
	public int ColumnsValueCode
	{
		get { return this._ColumnsValueCode; }
		set { this._ColumnsValueCode = value; }
	}
    
	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new MapExtendedColumnsDetailsBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
