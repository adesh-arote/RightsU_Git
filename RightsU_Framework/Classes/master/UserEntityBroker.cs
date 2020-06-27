using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UTOFrameWork.FrameworkClasses;
using System.Collections;
using System.Data;

//namespace R_RightsFramework.Classes.master
//{
//    class UserEntityBroker
//    {
//    }
//}

public class UserEntityBroker : DatabaseBroker
{
    public UserEntityBroker()
    {

    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Users_Entity] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);
    }

    public override Persistent PopulateObject(System.Data.DataRow dRow, Persistent obj)
    {
        UserEntity objUserEntity;
        if (obj == null)
        {
            objUserEntity = new UserEntity();
        }
        else
        {
            objUserEntity = (UserEntity)obj;
        }

        objUserEntity.IntCode = Convert.ToInt32(dRow["Users_Entity_Code"]);
        #region --populate--
        if (dRow["Users_Code"] != DBNull.Value)
            objUserEntity.UserCode = Convert.ToInt32(dRow["Users_Code"]);
        if (dRow["Entity_Code"] != DBNull.Value)
            objUserEntity.EntityCode = Convert.ToInt32(dRow["Entity_Code"]);
        objUserEntity.ISDefault = Convert.ToChar(dRow["Is_default"]);

        objUserEntity.EntityName = GetEntityName(objUserEntity.UserCode, objUserEntity.EntityCode);
        #endregion
        return objUserEntity;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        UserEntity objUserEntity = (UserEntity)obj;
        string strSql = "insert into [Users_Entity]([users_code], [Entity_Code], [Is_default]) values "
        + " ('" + objUserEntity.UserCode + "', '" + objUserEntity.EntityCode + "', '" + objUserEntity.ISDefault + "');";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        UserEntity objUserEntity = (UserEntity)obj;

        string strSql = "update [Users_Entity] set [users_code] = '" + objUserEntity.UserCode + "' "
        + " , [Entity_Code] = '" + objUserEntity.EntityCode + "' "
        + " , [Is_default] = '" + objUserEntity.ISDefault + "'  "
        + " where users_Entity_code = '" + objUserEntity.IntCode + "';";
        return strSql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        UserEntity objUserEntity = (UserEntity)obj;

        return " DELETE FROM [Users_Entity] WHERE users_Entity_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Users_Entity] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Users_Entity] WHERE  users_Entity_code = " + obj.IntCode;
    }

    internal string GetEntityName(int userCode, int EntityCode)
    {
        string strSql = "select Entity_Name from entity  where  Entity_Code='" + EntityCode + "' and is_active='Y'";
        DataSet ds = new DataSet();
        ds = ProcessSelect(strSql);
        string str = "";
        if (ds.Tables[0].Rows.Count > 0)
            str = ds.Tables[0].Rows[0][0].ToString();
        return str;
    }
}