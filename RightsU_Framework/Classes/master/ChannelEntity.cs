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
public class  ChannelEntity : Persistent
{
	public  ChannelEntity()
	{
        OrderByColumnName = "channel_entity_code";
        OrderByCondition = "ASC";
        tableName = "channel_entity";
        pkColName = "channel_entity_code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _ChannelCode;
	public int ChannelCode
	{
		get { return this._ChannelCode; }
		set { this._ChannelCode = value; }
	}

	private int _EntityCode;
	public int EntityCode
	{
		get { return this._EntityCode; }
		set { this._EntityCode = value; }
	}

	//private DateTime _EffectiveStartDate;
	//public DateTime EffectiveStartDate
	//{
	//    get { return this._EffectiveStartDate; }
	//    set { this._EffectiveStartDate = value; }
	//}

	private string _EffectiveStartDate;
	public string EffectiveStartDate 
	{
		get { return this._EffectiveStartDate; }
		set { this._EffectiveStartDate = value; }
	}

	private string _SystemEndDate;
	public string SystemEndDate
	{
		get { return this._SystemEndDate; }
		set { this._SystemEndDate = value; }
	}

	private Entity _objEntity;
	public Entity objEntity
	{
		get { 
			if (this._objEntity == null)
				this._objEntity = new Entity();
			return this._objEntity;
		}
		set { this._objEntity = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ChannelEntityBroker();
    }

	public override void LoadObjects()
    {
		
		if (this.EntityCode > 0)
		{
			this.objEntity.IntCode = this.EntityCode;
			this.objEntity.Fetch();
		}

	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
