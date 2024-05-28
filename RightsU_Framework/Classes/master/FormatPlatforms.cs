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
public class  FormatPlatforms : Persistent
{
	public  FormatPlatforms()
	{
        OrderByColumnName = "Format_Platforms_Code";
		OrderByCondition= "ASC";
        tableName = "Format_Platforms";
        pkColName = "Format_Platforms_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _FormatCode;
	public int FormatCode
	{
		get { return this._FormatCode; }
		set { this._FormatCode = value; }
	}

	private int _PlatformCode;
	public int PlatformCode
	{
		get { return this._PlatformCode; }
		set { this._PlatformCode = value; }
	}

	private Format _objFormat;
	public Format objFormat
	{
		get { 
			if (this._objFormat == null)
				this._objFormat = new Format();
			return this._objFormat;
		}
		set { this._objFormat = value; }
	}

	private Platform _objPlatform;
	public Platform objPlatform
	{
		get { 
			if (this._objPlatform == null)
				this._objPlatform = new Platform();
			return this._objPlatform;
		}
		set { this._objPlatform = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new FormatPlatformsBroker();
    }

	public override void LoadObjects()
    {
		
		if (this.FormatCode > 0)
		{
			this.objFormat.IntCode = this.FormatCode;
			this.objFormat.Fetch();
		}

		if (this.PlatformCode > 0)
		{
			this.objPlatform.IntCode = this.PlatformCode;
			this.objPlatform.Fetch();
		}

	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
