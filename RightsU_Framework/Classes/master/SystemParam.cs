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
public class  SystemParam : Persistent
{
	public  SystemParam()
	{
		OrderByColumnName = "id";
		OrderByCondition= "ASC";
        tableName = "[system_parameter_new]"; 
		pkColName = "id";
	}	 

    #region ---------------Attributes And Prperties---------------
    
	
	private string _ParameterName;
	public string ParameterName
	{
		get { return this._ParameterName; }
		set { this._ParameterName = value; }
	}

	private string _ParameterValue;
	public string ParameterValue
	{
		get { return this._ParameterValue; }
		set { this._ParameterValue = value; }
	}

   private string _Type;
   public string Type
   {
      get { return this._Type; }
      set { this._Type = value; }
   }

   private int _ChannelCode;
   public int ChannelCode
   {
      get { return this._ChannelCode; }
      set { this._ChannelCode = value; }
   }

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new SystemParamBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
