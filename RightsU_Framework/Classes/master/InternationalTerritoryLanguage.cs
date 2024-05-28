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
public class  InternationalTerritoryLanguage : Persistent
{
	public  InternationalTerritoryLanguage()
	{
        OrderByColumnName = "Country_Code";
		OrderByCondition= "ASC";
        tableName = "Country_Language";
        pkColName = "Country_Language_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _InternationalTerritoryCode;
	public int InternationalTerritoryCode
	{
		get { return this._InternationalTerritoryCode; }
		set { this._InternationalTerritoryCode = value; }
	}

	private int _LanguageCode;
	public int LanguageCode
	{
		get { return this._LanguageCode; }
		set { this._LanguageCode = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new InternationalTerritoryLanguageBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
