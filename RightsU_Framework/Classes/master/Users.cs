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
public class Users : Persistent {
    public Users()
    {
        OrderByColumnName = "login_name";
        OrderByCondition = "ASC";
        tableName = "users";
		pkColName = "users_code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _LoginName;
    public string loginName
    {
        get { return this._LoginName; }
        set { this._LoginName = value; }
    }

    private string _FirstName;
    public string firstName
    {
        get { return this._FirstName; }
        set { this._FirstName = value; }
    }

    private string _MiddleName;
    public string MiddleName
    {
        get { return this._MiddleName; }
        set { this._MiddleName = value; }
    }

    private string _LastName;
    public string lastName
    {
        get { return this._LastName; }
        set { this._LastName = value; }
    }
    private string _userName;
    public string userName
    {
        //get { return firstName + "   " + MiddleName + "  " + lastName; }
        get
        {
            if (string.IsNullOrEmpty(this._userName))
                return firstName + "   " + MiddleName + "  " + lastName;
            return this._userName;
        }
        set { this._userName = value; }
    }

    private string _Password;
    public string password
    {
        get { return this._Password; }
        set { this._Password = value; }
    }
    private bool _IsSuperadmin;
    public bool IsSuperadmin
    {
        get { return this._IsSuperadmin; }
        set { this._IsSuperadmin = value; }
    }

    private string _EmailId;
    public string emailId
    {
        get { return this._EmailId; }
        set { this._EmailId = value; }
    }

    private string _ContactNo;
    public string ContactNo
    {
        get { return this._ContactNo; }
        set { this._ContactNo = value; }
    }

    private int _SecurityGroupCode;
    public int SecurityGroupCode
    {
        get { return this._SecurityGroupCode; }
        set { this._SecurityGroupCode = value; }
    }

    private string _Isactive;
    public string Isactive
    {
        get { return this._Isactive; }
        set { this._Isactive = value; }
    }

    private string _Issystempassword;
    public string isSystemPassword
    {
        get { return this._Issystempassword; }
        set { this._Issystempassword = value; }
    }

    private int _Passwordfailcount;
    public int passwordFailCount
    {
        get { return this._Passwordfailcount; }
        set { this._Passwordfailcount = value; }
    }

    private int _DefaultChannelCode;
    public int DefaultChannelCode
    {
        get { return this._DefaultChannelCode; }
        set { this._DefaultChannelCode = value; }
    }

    private SecurityGroup _objSecurityGroup;
    public SecurityGroup objSecurityGroup
    {
        get
        {
            if (this._objSecurityGroup == null)
                this._objSecurityGroup = new SecurityGroup();
            return this._objSecurityGroup;
        }
        set { this._objSecurityGroup = value; }
    }



    private ArrayList _arrUserChannel_Del;
    public ArrayList arrUserChannel_Del
    {
        get
        {
            if (this._arrUserChannel_Del == null)
                this._arrUserChannel_Del = new ArrayList();
            return this._arrUserChannel_Del;
        }
        set { this._arrUserChannel_Del = value; }
    }

    private ArrayList _arrUserChannel;
    public ArrayList arrUserChannel
    {
        get
        {
            if (this._arrUserChannel == null)
                this._arrUserChannel = new ArrayList();
            return this._arrUserChannel;
        }
        set { this._arrUserChannel = value; }
    }

    public int moduleCode { get; set; }


    /***************** NEW CODE**********************/
    private ArrayList _arrUserEntity_Del;
    public ArrayList arrUserEntity_Del
    {
        get
        {
            if (this._arrUserEntity_Del == null)
                this._arrUserEntity_Del = new ArrayList();
            return this._arrUserEntity_Del;
        }
        set { this._arrUserEntity_Del = value; }
    }

    private ArrayList _arrUserEntity;
    public ArrayList arrUserEntity
    {
        get
        {
            if (this._arrUserEntity == null)
                this._arrUserEntity = new ArrayList();
            return this._arrUserEntity;
        }
        set { this._arrUserEntity = value; }
    }

    private int _DefaultEntityCode;
    public int DefaultEntityCode
    {
        get { return this._DefaultEntityCode; }
        set { this._DefaultEntityCode = value; }
    }

    private Entity _objEntity;
    public Entity objEntity
    {
        get
        {
            if (this._objEntity == null)
                this._objEntity = new Entity();
            return this._objEntity;
        }
        set { this._objEntity = value; }
    }

    private ArrayList _arrUserBusinessUnit;
    public ArrayList arrUserBusinessUnit
    {
        get
        {
            if (this._arrUserBusinessUnit == null)
                this._arrUserBusinessUnit = new ArrayList();
            return this._arrUserBusinessUnit;
        }
        set { this._arrUserBusinessUnit = value; }
    }
    private ArrayList _arrUserBusinessUnit_Del;
    public ArrayList arrUserBusinessUnit_Del
    {
        get
        {
            if (_arrUserBusinessUnit_Del == null)
            {
                _arrUserBusinessUnit_Del = new ArrayList();
            }
            return _arrUserBusinessUnit_Del;
        }
        set { _arrUserBusinessUnit_Del = value; }
    }

    /***************** NEW CODE**********************/
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new UsersBroker();
    }

    public override void LoadObjects()
    {

        if (this.SecurityGroupCode > 0)
        {
            this.objSecurityGroup.IntCode = this.SecurityGroupCode;
            this.objSecurityGroup.Fetch();
        }

        //    this.arrUserChannel = DBUtil.FillArrayList(new UserChannel(), " and user_code = '" + this.IntCode + "'", false);
        this.arrUserChannel_Del = DBUtil.FillArrayList(new UserChannel(), " and users_code = '" + this.IntCode + "'", false);

        this.arrUserEntity = DBUtil.FillArrayList(new UserEntity(), " and users_code='" + this.IntCode + "'", false);
        this.arrUserEntity_Del = DBUtil.FillArrayList(new UserEntity(), " and users_code='" + this.IntCode + "'", false);

        if (this.DefaultEntityCode > 0)
        {
            this.objEntity.IntCode = this.DefaultEntityCode;
            this.objEntity.Fetch();
        }
        //Code for Business Unit
        this.arrUserBusinessUnit_Del = DBUtil.FillArrayList(new UsersBusinessUnit(), " and Users_Code = '" + this.IntCode + "'", false);
        this.arrUserBusinessUnit = DBUtil.FillArrayList(new UsersBusinessUnit(), " and Users_Code = '" + this.IntCode + "'", false);
    }

    public override void UnloadObjects()
    {

        if (arrUserChannel_Del != null)
        {
            foreach (UserChannel objUserChannel in this.arrUserChannel_Del)
            {
                objUserChannel.IsTransactionRequired = true;
                objUserChannel.SqlTrans = this.SqlTrans;
                objUserChannel.IsDeleted = true;
                objUserChannel.Save();
            }
        }
        if (arrUserChannel != null)
        {
            foreach (UserChannel objUserChannel in this.arrUserChannel)
            {
                objUserChannel.UserCode = this.IntCode;
                objUserChannel.IsTransactionRequired = true;
                objUserChannel.SqlTrans = this.SqlTrans;
                if (objUserChannel.IntCode > 0)
                    objUserChannel.IsDirty = true;
                objUserChannel.Save();
            }
        }

        /*************************NEW CODE USER ENTITY*************************/
        if (arrUserEntity_Del != null)
        {
            foreach (UserEntity objUserEntity in this.arrUserEntity_Del)
            {
                objUserEntity.IsTransactionRequired = true;
                objUserEntity.SqlTrans = this.SqlTrans;
                objUserEntity.IsDeleted = true;
                objUserEntity.Save();
            }
        }
        if (arrUserEntity != null)
        {
            foreach (UserEntity objUserEntity in this.arrUserEntity)
            {
                objUserEntity.UserCode = this.IntCode;
                objUserEntity.IsTransactionRequired = true;
                objUserEntity.SqlTrans = this.SqlTrans;
                if (objUserEntity.IntCode > 0)
                    objUserEntity.IsDirty = true;
                objUserEntity.Save();
            }
        }
        /*************************NEW CODE USER ENTITY*************************/
        //New code for Business Unit
        if (arrUserBusinessUnit_Del != null)
        {
            foreach (UsersBusinessUnit objUsersBusinessUnit in this.arrUserBusinessUnit_Del)
            {
                objUsersBusinessUnit.IsTransactionRequired = true;
                objUsersBusinessUnit.SqlTrans = this.SqlTrans;
                objUsersBusinessUnit.IsDeleted = true;
                objUsersBusinessUnit.Save();
            }
        }
        foreach (UsersBusinessUnit objUsersBusinessUnit in this.arrUserBusinessUnit)
        {
            if (this.IsTransactionRequired)
            {
                objUsersBusinessUnit.IsTransactionRequired = true;
                objUsersBusinessUnit.SqlTrans = this.SqlTrans;
            }
            objUsersBusinessUnit.UsersCode = this.IntCode;
            objUsersBusinessUnit.IsProxy = true;
            objUsersBusinessUnit.IsDirty = false;
            objUsersBusinessUnit.Save();
        }
        //New code for Business Unit ENds
    }
    public void setPasswordFailCount()
    {
        ((UsersBroker)(this.GetBroker())).setPasswordFailCount(this);
    }
    public void changeUserPassword()
    {
        ((UsersBroker)(this.GetBroker())).changeUserPassword(this);
    }

    //dada
    public Boolean IsLoginNameExist(string loginName, int user_code)
    {
        return (((UsersBroker)this.GetBroker())).IsLoginNameExist(loginName, user_code);
    }

    public bool IsEmailExist(string EmailID, int user_code)
    {
        return (((UsersBroker)this.GetBroker())).IsEmailExist(EmailID, user_code);
        //throw new NotImplementedException();
    }
    //dada

    public int CheckLast5Pwds(string strPassword)
    {
        return ((UsersBroker)(this.GetBroker())).ReleaseLock(this, strPassword);
    }

    public int GetPassLifeTime(int code)
    {
        return ((UsersBroker)(this.GetBroker())).GetPassLifeTime(code);
    }

    public void ReleaseLock(int intCode)
    {
        ((UsersBroker)(this.GetBroker())).ReleaseLock(intCode);
    }

    #endregion

    public DataSet GetUsernameNPassword(int UserCode)
    {
        return ((UsersBroker)this.GetBroker()).GetUsernameNPassword(UserCode);
    }

    public string generatePwd()
    {
        string pwd = getEncrptedPass(this.firstName, this.lastName).Trim();
        //pwd_Encrpted = ServerUtility.getEncriptedStr(pwd);
        return pwd;
    }

    public static string getEncrptedPass(string FirstName, string LastName)
    {
        long currentTime = Convert.ToInt64(GetDateComparisionNumber(DateTime.Now.ToString("s")));
        string date = currentTime.ToString().Substring(8, 4);

        if (Convert.ToInt32(date) % 2 == 0)
        {
            date = ((date[0]) + date);
            date += date[2];
        }
        else
        {
            date = ((date[1]) + date);
            date += date[3];
        }

        if (FirstName.Length < 2)
            FirstName = FirstName + '#';
        if (LastName.Length < 2)
            LastName = LastName + '#';
        string str = FirstName.Substring(0, 2).Trim() + date + LastName.Substring(0, 2).Trim();

        return str;
    }
    public static string GetDateComparisionNumber(string strDate)
    {
        string actualStr = strDate.Trim().Replace("T", "~").Replace(":", "~").Replace("-", "~");
        string[] arrDt = actualStr.Split('~');
        string tmpTimeInSec = arrDt[0].Trim() + arrDt[1].Trim() + arrDt[2].Trim() + Convert.ToString(Convert.ToInt64(Convert.ToInt64(arrDt[3].Trim()) * 60 * 60) + Convert.ToInt64(Convert.ToInt64(arrDt[4].Trim()) * 60) + Convert.ToInt64(arrDt[5].Trim()));
        return tmpTimeInSec;
    }
    //Code Added by Priti
    public string GetUserNameCommaSeperated(int SecurityGroupCode, int BusinessUnitCode)
    {
        return ((UsersBroker)this.GetBroker()).GetUserNameCommaSeperated(SecurityGroupCode, BusinessUnitCode);
    }
    //Code Added by Priti
}
