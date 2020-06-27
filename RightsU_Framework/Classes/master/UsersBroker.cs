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
using System.Data.SqlClient;

/// <summary>
/// Summary description for Users
/// </summary>
public class UsersBroker : DatabaseBroker
{
    public UsersBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Users] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Users objUsers;
        if (obj == null)
        {
            objUsers = new Users();
        }
        else
        {
            objUsers = (Users)obj;
        }

        objUsers.IntCode = Convert.ToInt32(dRow["users_code"]);
        #region --populate--
        objUsers.loginName = Convert.ToString(dRow["login_name"]);
        objUsers.firstName = Convert.ToString(dRow["first_name"]);
        objUsers.MiddleName = Convert.ToString(dRow["Middle_Name"]);
        objUsers.lastName = Convert.ToString(dRow["last_name"]);
        objUsers.password = Convert.ToString(dRow["password"]);
        objUsers.emailId = Convert.ToString(dRow["email_id"]);
        objUsers.ContactNo = Convert.ToString(dRow["contact_no"]);
        if (dRow["security_group_code"] != DBNull.Value)
            objUsers.SecurityGroupCode = Convert.ToInt32(dRow["security_group_code"]);
        //objUsers.Is_Active = Convert.ToString(dRow["Is_active"]);
        if (dRow["Is_Active"] != DBNull.Value)
            if (dRow["Is_Active"].ToString() != "")
                objUsers.Is_Active = Convert.ToString(dRow["Is_Active"]);



        objUsers.isSystemPassword = Convert.ToString(dRow["is_system_password"]);
        if (dRow["password_fail_count"] != DBNull.Value)
            objUsers.passwordFailCount = Convert.ToInt32(dRow["password_fail_count"]);
        if (dRow["default_channel_code"] != DBNull.Value)
            objUsers.DefaultChannelCode = Convert.ToInt32(dRow["default_channel_code"]);
        if (dRow["lock_Time"] != DBNull.Value)
            objUsers.LockTime = Convert.ToString(dRow["lock_Time"]);
        if (dRow["last_Updated_Time"] != DBNull.Value)
            objUsers.LastUpdatedTime = Convert.ToString(dRow["last_Updated_Time"]);
        if (dRow["last_Action_By"] != DBNull.Value)
            objUsers.LastActionBy = Convert.ToInt32(dRow["last_Action_By"]);
        if (dRow["Default_Entity_Code"] != DBNull.Value)
            objUsers.DefaultEntityCode = Convert.ToInt32(dRow["Default_Entity_Code"]);
        
        #endregion
        return objUsers;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Users objUsers = (Users)obj;
        if (objUsers.SqlTrans != null)
            return DBUtil.IsDuplicateSqlTrans(ref obj, "Users", "login_name", ((Users)obj).loginName, "users_code", ((Users)obj).IntCode, "User Name Already Exists.", "", true)
                || DBUtil.IsDuplicateSqlTrans(ref obj, "Users", "email_id", ((Users)obj).emailId, "users_code", ((Users)obj).IntCode, "Email Id Already Exists", "", true);
        else
            return DBUtil.IsDuplicate(myConnection, "Users", "login_name", ((Users)obj).loginName, "users_code", ((Users)obj).IntCode, "User name Already Exists.", "", true)
                || DBUtil.IsDuplicate(myConnection, "Users", "email_id", ((Users)obj).emailId, "users_code", ((Users)obj).IntCode, "Email Id Already Exists", "", true);

    }

    public override string GetInsertSql(Persistent obj)
    {
        Users objUser = (Users)obj;

        string strSql = "INSERT INTO Users([login_name], [first_name], [Middle_Name], [last_name],[password], [email_id] "
        + " ,[default_channel_code], [security_group_code],[lock_Time], [last_Updated_Time], [last_Action_By], [Default_Entity_Code],[is_active]) "
        + " VALUES(N'" + objUser.loginName.Trim().Replace("'", "''") + "',N'" + objUser.firstName.Trim().Replace("'", "''") + "', "
        + " N'" + objUser.MiddleName.Trim().Replace("'", "''") + "', N'" + objUser.lastName.Trim().Replace("'", "''") + "', "
        + " '" + ServerUtility.getEncriptedStr(objUser.password.Trim().Replace("'", "''")) + "', "
        + " N'" + objUser.emailId.Trim().Replace("'", "''") + "', '" + objUser.DefaultChannelCode + "', "
        + " '" + objUser.SecurityGroupCode + "',NULL, GetDate(), " + objUser.LastActionBy + ", "
        + " '" + objUser.DefaultEntityCode + "','Y')";
        return strSql;

    }

    public override string GetUpdateSql(Persistent obj)
    {
        Users objUser = (Users)obj;
        string strSql = "UPDATE Users SET login_name = N'" + objUser.loginName.Trim().Replace("'", "''") + "',"
            + " first_name = N'" + objUser.firstName.Trim().Replace("'", "''") + "',"
            + " Middle_Name = N'" + objUser.MiddleName.Trim().Replace("'", "''") + "',"
            + " last_name = N'" + objUser.lastName.Trim().Replace("'", "''") + "',"
            + " email_id = N'" + objUser.emailId.Trim().Replace("'", "''") + "',"
            + " default_channel_code = " + objUser.DefaultChannelCode + ","
            + " security_group_code = " + objUser.SecurityGroupCode + ","
            + " lock_Time = NULL,"
            + " last_Updated_Time = GetDate(), "
            + " last_Action_By = " + objUser.LastActionBy + ", "
            + " [Default_Entity_Code]=" + objUser.DefaultEntityCode + " "
            + " WHERE users_code = " + objUser.IntCode;

        return (strSql);
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Users objUsers = (Users)obj;
        if (objUsers.arrUserChannel.Count > 0)
            DBUtil.DeleteChild("UserChannel", objUsers.arrUserChannel, objUsers.IntCode, (SqlTransaction)objUsers.SqlTrans);

        return " DELETE FROM [Users] WHERE users_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Users objUsers = (Users)obj;
        string strSql = "UPDATE Users SET is_Active= '" + objUsers.Is_Active + "',[Lock_Time]=null,[Last_Updated_Time] = getDate() WHERE users_code=" + objUsers.IntCode;
        return (strSql);
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Users] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        Users objUsers = (Users)obj;
        return " SELECT * FROM [Users] WHERE  users_code = " + obj.IntCode;
    }
   
    internal void setPasswordFailCount(Users objUser)
    {
        string sql;
        sql = "UPDATE Users SET password_fail_count = " + objUser.passwordFailCount + ", last_Updated_Time = GetDate() "
            + "WHERE users_code = " + objUser.IntCode;
        ProcessNonQuery(sql, false);
    }
    
    internal void changeUserPassword(Users objUser)
    {
        string sql;
        sql = "UPDATE Users SET password = '" + ServerUtility.getEncriptedStr(objUser.password.Trim().Replace("'", "''")) + "', "
            + "is_system_password = '" + objUser.isSystemPassword.Trim().Replace("'", "''") + "', "
            + "password_fail_count  = 0, last_Updated_Time = GetDate() "
            + "WHERE users_code = " + objUser.IntCode + " ;";

        sql += "insert into Users_Password_Detail values('" + objUser.IntCode + "', '" + ServerUtility.getEncriptedStr(objUser.password.Trim().Replace("'", "''"))
           + "', GetDate())";

        ProcessNonQuery(sql, false);
    }

   //dada
    internal bool IsLoginNameExist(string loginName, int user_code)
    {
        // throw new NotImplementedException();
        string strSql = "Select count(*) from Users where Login_name= N'" + loginName.Trim().Replace("'", "''") + "' and users_code <>" + user_code;
        //string strSql = "Select count(*) from Users where Login_name= '" + loginName.Trim().Replace("'", "''") + "'";
        int Count = Convert.ToInt32(ProcessScalar(strSql));
        if (Count > 0)
        {
            return true;
        }
        return false;
    }

    internal bool IsEmailExist(string EmailID, int user_code)
    {
        string strSql = "SELECT COUNT(*) FROM Users WHERE email_id=N'" + EmailID.Trim().Replace("'", "''") + "' and users_code <>" + user_code;
        //string strSql = "SELECT COUNT(*) FROM Users WHERE email_id='" + EmailID.Trim().Replace("'", "''") + "' ";
        int count = Convert.ToInt32(ProcessScalar(strSql));
        if (count > 0)
        {
            return true;
        }
        return false;
        //throw new NotImplementedException();
    }
    //
    internal void ReleaseLock(int intCode)
    {
        string sql;
        sql = "UPDATE Users SET password_fail_count = 0, last_Updated_Time = GetDate() "
            + "WHERE users_code = " + intCode;
        ProcessNonQuery(sql, false);
    }
    
    internal int ReleaseLock(Users objUser, string strPassword)
    {
        string sql;
        sql = "SELECT COUNT(*) FROM ("
              + "select TOP 5 users_passwords from Users_Password_Detail WHERE users_code='" + objUser.IntCode + "' ORDER BY password_change_date DESC) "
              + "AS A WHERE users_passwords = '" + ServerUtility.getEncriptedStr(strPassword) + "'";
        return Convert.ToInt32(ProcessScalar(sql));
    }

    public int GetPassLifeTime(int code)
    {
        string sqlStr = "select top 1 DATEDIFF(d, password_change_date, getdate()) last_pwd_date from Users_Password_Detail where users_code = '" + code + "' order by password_change_date desc";
        return Convert.ToInt32(this.ProcessScalar(sqlStr));

    }


    internal DataSet GetUsernameNPassword(int UserCode)
    {
        string strSelect = " select login_name,password from Users where users_code = " + UserCode;
        return DatabaseBroker.ProcessSelectDirectly(strSelect);
    }

    //Code Added by Priti
    public string GetUserNameCommaSeperated(int SecurityGroupCode, int BusinessUnitCode)
    {
        string sqlStr = "";
        sqlStr = " DECLARE @UserName  NVARCHAR(Max) "
                 + " SET @UserName = '' "
                 + " SELECT @UserName = @UserName + First_Name + ' ' + Last_Name + ', '  FROM Users where Users_Code > 0 and Security_Group_Code ='" + SecurityGroupCode + "' and Users_Code in (select Users_Code from Users_Business_Unit where Business_Unit_Code = " + BusinessUnitCode + ") "
                 + " SELECT @UserName as UserName";
        string UserName = DatabaseBroker.ProcessScalarReturnString(sqlStr);
        return UserName;
    }
    //Code Added by Priti
}
