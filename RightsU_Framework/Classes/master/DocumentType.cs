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
public class  DocumentType : Persistent
{
	public  DocumentType()
	{
        OrderByColumnName = "Document_Type_Name";
        OrderByCondition = "ASC";
        tableName = "document_type";
        pkColName = "Document_Type_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _DocumentTypeName;
	public string DocumentTypeName
	{
		get { return this._DocumentTypeName; }
		set { this._DocumentTypeName = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new DocumentTypeBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
