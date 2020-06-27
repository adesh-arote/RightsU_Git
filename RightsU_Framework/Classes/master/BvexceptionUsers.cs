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
public class  BvexceptionUsers : Persistent
{
	public  BvexceptionUsers()
	{
        OrderByColumnName = "bv_exception_users_code";
        OrderByCondition = "ASC";
        tableName = "BVException_Users";
        pkColName = "bv_exception_users_code";
	}	

    #region ---------------Attributes And Prperties---------------
    private int _BvExceptionUserCode;
    public int BvExceptionUserCode
    {
        get { return this._BvExceptionUserCode; }
        set { this._BvExceptionUserCode = value; }
    }
	
	private int _BvExceptionCode;
	public int BvExceptionCode
	{
		get { return this._BvExceptionCode; }
		set { this._BvExceptionCode = value; }
	}

	private int _UsersCode;
	public int UsersCode
	{
		get { return this._UsersCode; }
		set { this._UsersCode = value; }
	}

    private Users _objUsers;
    public Users objUsers
    {
        get
        {
            if (this._objUsers == null)
                this._objUsers = new Users();
            return this._objUsers;
        }
        set { this._objUsers = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new BvexceptionUsersBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        if (this.UsersCode > 0)
        {
            objUsers.IntCode = this.UsersCode;
            objUsers.Fetch();
        }	
    }
    
    #endregion    
}
