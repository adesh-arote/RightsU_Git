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
public class  RevenueDataBO : Persistent
{
	public  RevenueDataBO()
	{
		//OrderByColumnName = "";
		//OrderByCondition= "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	
	private string _TitleCodeId;
	public string TitleCodeId
	{
		get { return this._TitleCodeId; }
		set { this._TitleCodeId = value; }
	}

    private String _FromDate;
	public String FromDate
	{
		get { return this._FromDate; }
		set { this._FromDate = value; }
	}
	
	private decimal _Revenue;
	public decimal Revenue
	{
		get { return this._Revenue; }
		set { this._Revenue = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RevenueDataBOBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
