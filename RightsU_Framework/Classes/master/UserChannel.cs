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
public class UserChannel : Persistent
{
    public UserChannel()
    {
        OrderByColumnName = "users_channel_code";
        OrderByCondition = "ASC";
        tableName = "Users_Channel";
        pkColName = "users_channel_code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _UserCode;
    public int UserCode
    {
        get { return this._UserCode; }
        set { this._UserCode = value; }
    }

    private int _ChannelCode;
    public int ChannelCode
    {
        get { return this._ChannelCode; }
        set { this._ChannelCode = value; }
    }

    private char _SDefault;
    public char SDefault
    {
        get { return this._SDefault; }
        set { this._SDefault = value; }
    }
    private Channel _ObjChannel;
    public Channel ObjChannel
    {
        get
        {
            if (_ObjChannel == null) return new Channel();
            return _ObjChannel;
        }
        set
        {
            _ObjChannel = value;
        }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new UserChannelBroker();
    }

    public override void LoadObjects()
    {
        if (this.ChannelCode > 0)
        {
            Channel tmpObjChannel = new Channel();
            tmpObjChannel.IntCode = this.ChannelCode;
            tmpObjChannel.Fetch();
            this.ObjChannel = tmpObjChannel;
        }

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
