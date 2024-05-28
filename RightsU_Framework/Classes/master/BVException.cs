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
public class  BVException : Persistent
{
	public  BVException()
	{
        OrderByColumnName = "bv_exception_code";
        OrderByCondition = "ASC";
        tableName = "BVException";
        pkColName = "bv_exception_code";
	}	

    #region ---------------Attributes And Prperties---------------
    private string _BvExceptionCode;
    public string BvExceptionCode
    {
        get { return this._BvExceptionCode; }
        set { this._BvExceptionCode = value; }
    }
	
	private string _BvExceptionType;
	public string BvExceptionType
	{
		get { return this._BvExceptionType; }
		set { this._BvExceptionType = value; }
	}

    public string ChannelList
    {
        get
        {
            string retStr = "";
            if (this._arrBvexceptionChannel != null)
            {
                foreach (BvexceptionChannel rbf in arrBvexceptionChannel)
                {
                    rbf.objChannel.IntCode = rbf.ChannelCode;
                    rbf.objChannel.Fetch();
                    retStr = retStr + rbf.objChannel.ChannelName + ",";
                }
            }
            if (retStr != "")
            {
                return retStr.Substring(0, retStr.Length - 1);
            }
            else
                return "";
        }
    }

    public string UsersList
    {
        get
        {
            string retStr = "";
            if (this._arrBvexceptionUsers != null)
            {
                foreach (BvexceptionUsers rbf in arrBvexceptionUsers)
                {
                    rbf.objUsers.IntCode = rbf.UsersCode;
                    rbf.objUsers.Fetch();
                    retStr = retStr + rbf.objUsers.userName + ",";
                }
            }
            if (retStr != "")
            {
                return retStr.Substring(0, retStr.Length - 1);
            }
            else
                return "";
        }
    }

    public string ChannelCodeList
    {
        get
        {
            string retStr = "";
            if (this._arrBvexceptionChannel != null)
            {
                foreach (BvexceptionChannel rbf in arrBvexceptionChannel)
                {
                    retStr = retStr + rbf.ChannelCode + "~";
                }
            }
            if (retStr != "")
            {
                return retStr.Substring(0, retStr.Length - 1);
            }
            else
                return "";
        }
    }

    public string UsersCodeList
    {
        get
        {
            string retStr = "";
            if (this._arrBvexceptionUsers != null)
            {
                foreach (BvexceptionUsers rbf in arrBvexceptionUsers)
                {
                    rbf.objUsers.IntCode = rbf.UsersCode;
                    rbf.objUsers.Fetch();
                    retStr = retStr + rbf.objUsers.IntCode + "~";
                }
            }
            if (retStr != "")
            {
                return retStr.Substring(0, retStr.Length - 1);
            }
            else
                return "";
            //return retStr;
        }
    }


	private ArrayList _arrBvexceptionChannel_Del;
	public ArrayList arrBvexceptionChannel_Del
	{
		get { 
			if (this._arrBvexceptionChannel_Del == null)
				this._arrBvexceptionChannel_Del = new ArrayList();
			return this._arrBvexceptionChannel_Del;
		}
		set { this._arrBvexceptionChannel_Del = value; }
	}

	private ArrayList _arrBvexceptionChannel;
	public ArrayList arrBvexceptionChannel
	{
		get { 
			if (this._arrBvexceptionChannel == null)
				this._arrBvexceptionChannel = new ArrayList();
			return this._arrBvexceptionChannel;
		}
		set { this._arrBvexceptionChannel = value; }
	}

	private ArrayList _arrBvexceptionUsers_Del;
	public ArrayList arrBvexceptionUsers_Del
	{
		get { 
			if (this._arrBvexceptionUsers_Del == null)
				this._arrBvexceptionUsers_Del = new ArrayList();
			return this._arrBvexceptionUsers_Del;
		}
		set { this._arrBvexceptionUsers_Del = value; }
	}

	private ArrayList _arrBvexceptionUsers;
	public ArrayList arrBvexceptionUsers
	{
		get { 
			if (this._arrBvexceptionUsers == null)
				this._arrBvexceptionUsers = new ArrayList();
			return this._arrBvexceptionUsers;
		}
		set { this._arrBvexceptionUsers = value; }
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
        return new BVExceptionBroker();
    }

	public override void LoadObjects()
    {
        this.arrBvexceptionChannel = DBUtil.FillArrayList(new BvexceptionChannel(), " and bv_exception_code = '" + this.IntCode + "'", true);
        this.arrBvexceptionUsers = DBUtil.FillArrayList(new BvexceptionUsers(), " and bv_exception_code = '" + this.IntCode + "'", true);
        this.arrBvexceptionChannel_Del = DBUtil.FillArrayList(new BvexceptionChannel(), " and bv_exception_code = '" + this.IntCode + "'", true);
        this.arrBvexceptionUsers_Del = DBUtil.FillArrayList(new BvexceptionUsers(), " and bv_exception_code = '" + this.IntCode + "'", true);
	}

    public override void UnloadObjects()
    {
        if (arrBvexceptionChannel_Del != null)
        {
            foreach (BvexceptionChannel objBvexceptionChannel in this.arrBvexceptionChannel_Del)
            {
                objBvexceptionChannel.IsTransactionRequired = true;
                objBvexceptionChannel.SqlTrans = this.SqlTrans;
                objBvexceptionChannel.IsDeleted = true;
                objBvexceptionChannel.Save();
            }
        }
        if (arrBvexceptionChannel != null)
        {
            foreach (BvexceptionChannel objBvexceptionChannel in this.arrBvexceptionChannel)
            {
                objBvexceptionChannel.BvExceptionCode= this.IntCode;
                objBvexceptionChannel.IsTransactionRequired = true;
                objBvexceptionChannel.SqlTrans = this.SqlTrans;
                if (objBvexceptionChannel.IntCode > 0)
                    objBvexceptionChannel.IsDirty = true;
                objBvexceptionChannel.Save();
            }
        }
        if (arrBvexceptionUsers_Del != null)
        {
            foreach (BvexceptionUsers objBvexceptionUsers in this.arrBvexceptionUsers_Del)
            {
                objBvexceptionUsers.IsTransactionRequired = true;
                objBvexceptionUsers.SqlTrans = this.SqlTrans;
                objBvexceptionUsers.IsDeleted = true;
                objBvexceptionUsers.Save();
            }
        }
        if (arrBvexceptionUsers != null)
        {
            foreach (BvexceptionUsers objBvexceptionUsers in this.arrBvexceptionUsers)
            {
                objBvexceptionUsers.BvExceptionCode = this.IntCode;
                objBvexceptionUsers.IsTransactionRequired = true;
                objBvexceptionUsers.SqlTrans = this.SqlTrans;
                if (objBvexceptionUsers.IntCode > 0)
                    objBvexceptionUsers.IsDirty = true;
                objBvexceptionUsers.Save();
            }
        }
    }

    public DataSet getChannelNames(string ChannelName)
    {
        return ((BVExceptionBroker)this.GetBroker()).getChannelNames(ChannelName);
    }

    #endregion    
}
