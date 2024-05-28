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
public class  BvexceptionChannel : Persistent
{
	public  BvexceptionChannel()
	{
        OrderByColumnName = "bv_exception_channel_code";
        OrderByCondition = "ASC";
        tableName = "BVException_Channel";
        pkColName = "bv_exception_channel_code";
	}	

    #region ---------------Attributes And Prperties---------------


    private int _BvExceptionChannelCode;
    public int BvExceptionChannelCode
	{
        get { return this._BvExceptionChannelCode; }
        set { this._BvExceptionChannelCode = value; }
	}

	private int _BvExceptionCode;
	public int BvExceptionCode
	{
		get { return this._BvExceptionCode; }
		set { this._BvExceptionCode = value; }
	}

	private int _ChannelCode;
	public int ChannelCode
	{
		get { return this._ChannelCode; }
		set { this._ChannelCode = value; }
	}

    private Channel _objChannel;
    public Channel objChannel
    {
        get
        {
            if (this._objChannel == null)
                this._objChannel = new Channel();
            return this._objChannel;
        }
        set { this._objChannel = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new BvexceptionChannelBroker();
    }

	public override void LoadObjects()
    {
        if (this.ChannelCode > 0)
        {
            objChannel.IntCode = this.ChannelCode;
            objChannel.Fetch();
        }	
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
