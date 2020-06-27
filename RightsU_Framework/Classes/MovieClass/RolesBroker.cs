using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for RolesBroker
/// </summary>
public class RolesBroker:DatabaseBroker 
{
	public RolesBroker()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetDeleteSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetInsertSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = "SELECT * FROM Role WHERE Role_code > -1 " + strSearchString;
        if (objCriteria.IsPagingRequired)
        {
            return objCriteria.getPagingSQL(sql); ;
        }
        return sql + " ORDER BY " + objCriteria.getASCstr();        
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "SELECT * FROM Role WHERE Role_code =" + obj.IntCode;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Roles objRoles;
        if (obj == null)
        {
            objRoles =  new Roles();
        }
        else
        {
            objRoles = (Roles)obj;
        }
        objRoles.IntCode = Convert.ToInt32(dRow["Role_Code"]);
        objRoles.roleType = Convert.ToString(dRow["Role_Type"]);
        objRoles.roleName = Convert.ToString(dRow["Role_name"]);
        objRoles.isRateCard = Convert.ToString(dRow["is_rate_card"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objRoles.InsertedBy = Convert.ToInt32(dRow["last_action_by"]);        
        if (dRow["lock_time"] != DBNull.Value)
            objRoles.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objRoles.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        return objRoles;
    }

    //added for database locking system

    /// <summary>
    /// To get the status of perticular record whether is used by any user or not.
    /// </summary>
    /// <param name="objPO">record object in which we get info of perticular record when that record is bind on page
    ///     for ex. when datagrid is bind
    /// </param>
    /// <returns>'C': In this case record is changed by another user by just seeing last updated time(latest)
    ///     and object's last updated time
    /// U: when any user lock the record and go away then after 20 sec its unlock for this user and set locktime
    /// L: When above all condition failed then it returns that this record is locked from some other user
    /// </returns>
    override public string getRecordStatus(Persistent obj, out int UserCode)
    {
        string strSql;
        obj = (Roles)obj;
        strSql = "SELECT lock_time,last_updated_time,ISNUll(datediff(ss,lock_time,getdate()),500) TimeDiff," +
                 "last_action_by FROM Role WHERE Role_code=" + obj.IntCode;

        DataSet dsRecord = new DataSet();
        dsRecord = ProcessSelect(strSql);
        UserCode = 0;
        if (dsRecord.Tables.Count > 0 && dsRecord.Tables[0].Rows.Count > 0)
        {
            if (obj.LastUpdatedTime != dsRecord.Tables[0].Rows[0]["last_updated_time"].ToString())
            {
                UserCode = Convert.ToInt32(dsRecord.Tables[0].Rows[0]["last_action_by"]);
                return "C";
            }
            else if (obj.LastUpdatedTime == dsRecord.Tables[0].Rows[0]["last_updated_time"].ToString())
            {
                if (Convert.ToInt32(dsRecord.Tables[0].Rows[0]["TimeDiff"]) > 20)
                {
                    ProcessNonQuery("UPDATE Material_Type SET lock_time=getdate(), last_action_by=" + obj.LastUpdatedBy + " WHERE Role_code=" + obj.IntCode, false);
                    UserCode = obj.LastUpdatedBy;
                    return "U";
                }
                else
                {
                    UserCode = Convert.ToInt32(dsRecord.Tables[0].Rows[0]["last_action_by"]);
                    return "L";
                }
            }
            return null;
        }
        else
        {
            return "D";//record has been deleted;
        }
        return null;
    }

    override public void unlockRecord(Persistent obj)
    {
        obj = (MaterialType)obj;
        string strSql;
        strSql = "UPDATE Role SET lock_time=null WHERE Role_code=" + obj.IntCode;
        ProcessNonQuery(strSql, false);

    }

    override public void refreshRecord(Persistent obj)
    {
        obj = (MaterialType)obj;
        string strSql;
        strSql = "UPDATE Role SET lock_time=getdate() WHERE Role_code=" + obj.IntCode;
        ProcessNonQuery(strSql, false);

    }


}
