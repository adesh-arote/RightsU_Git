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

/// <summary>
/// Summary description for TalentBroker
/// </summary>
public class TalentBroker:DatabaseBroker 
{
	public TalentBroker()
	{
		// TODO: Add constructor logic here
	}

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Talent objTalent = (Talent)obj;
        if (objTalent.SqlTrans != null)
            return DBUtil.IsDuplicateSqlTrans(ref obj, "talent", "talent_name", objTalent.talentName, "talent_code", objTalent.IntCode, "Talent Name already exists", "", true);
        else
            return DBUtil.IsDuplicate(myConnection, "talent_name", "talent_name", objTalent.talentName, "talent_code", objTalent.IntCode, "Talent Name already exists", "", true);
    
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
		Talent objTalent = (Talent)obj;
		return "Update [Talent] set Is_Active='" + objTalent.Is_Active + "',lock_time=null, last_updated_time= getdate() where Talent_Code = " + objTalent.IntCode;
    }

    public override string GetCountSql(string strSearchString)
    {
        return "SELECT COUNT(*) FROM Talent WHERE talent_code > -1 " + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        return " DELETE FROM Talent WHERE talent_code = " + obj.IntCode + " ";
    }

    public override string GetInsertSql(Persistent obj)
    {
        Talent  objTalent = (Talent)obj;
        string sql = "INSERT INTO Talent(talent_name,Gender,Inserted_On,Inserted_By,Is_Active) " +
                   "VALUES(N'" + GlobalUtil.ReplaceSingleQuotes(objTalent.talentName) + "','"+objTalent.Gender+"',getdate(),'" + objTalent.InsertedBy + "','Y')";
        return sql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = "SELECT * FROM Talent WHERE talent_code > -1 " + strSearchString;
        if (objCriteria.IsPagingRequired)
        {
            return objCriteria.getPagingSQL(sql); ;
        }
        return sql + " ORDER BY " + objCriteria.getASCstr();     
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "SELECT * FROM Talent WHERE talent_code =" + obj.IntCode;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		Talent objTalent = (Talent)obj;
       string str= "UPDATE Talent SET talent_name=N'" + GlobalUtil.ReplaceSingleQuotes(objTalent.talentName)
			+"',Gender='"+objTalent.Gender
           + "',last_action_by=" + objTalent.LastUpdatedBy
           + ",lock_time=null,last_updated_time=getdate() WHERE talent_code =" + objTalent.IntCode;

	   return str;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Talent objTalent;
        if (obj == null)
            objTalent= new Talent();
        else
        {
            objTalent = (Talent)obj;
        }
        objTalent.IntCode = Convert.ToInt32(dRow["talent_code"]);
        objTalent.talentName  = Convert.ToString(dRow["talent_name"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objTalent.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["lock_time"] != DBNull.Value)
            objTalent.LockTime = Convert.ToString(dRow["lock_time"]);
		objTalent.Is_Active = Convert.ToString(dRow["Is_Active"]);
		objTalent.Gender = Convert.ToChar(dRow["Gender"]);
        return objTalent;

    }

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
        //string strSql;
        //obj = (Talent)obj;
        //strSql = "SELECT lock_time,last_updated_time,ISNUll(datediff(ss,lock_time,getdate()),500) TimeDiff," +
        //         "last_action_by FROM talent WHERE talent_code=" + obj.IntCode;

        //DataSet dsRecord = new DataSet();
        //dsRecord = ProcessSelect(strSql);
        //UserCode = 0;
        //if (dsRecord.Tables.Count > 0 && dsRecord.Tables[0].Rows.Count > 0)
        //{
        //    if (obj.lastUpdatedTime != dsRecord.Tables[0].Rows[0]["last_updated_time"].ToString())
        //    {
        //        UserCode = Convert.ToInt32(dsRecord.Tables[0].Rows[0]["last_action_by"]);
        //        return "C";
        //    }
        //    else if (obj.lastUpdatedTime == dsRecord.Tables[0].Rows[0]["last_updated_time"].ToString())
        //    {
        //        if (Convert.ToInt32(dsRecord.Tables[0].Rows[0]["TimeDiff"]) > 20)
        //        {
        //            ProcessNonQuery("UPDATE talent SET lock_time=getdate(), last_action_by=" + obj.LastUpdatedBy + " WHERE talent_code=" + obj.IntCode, false);
        //            UserCode = obj.LastUpdatedBy;
        //            return "U";
        //        }
        //        else
        //        {
        //            UserCode = Convert.ToInt32(dsRecord.Tables[0].Rows[0]["last_action_by"]);
        //            return "L";
        //        }
        //    }
        //    return null;
        //}
        //else
        //{
        //    return "D";//record has been deleted;
        //}
        //return null;

        return DBUtil.GetRecordStatus(myConnection, obj, "talent", "talent_code", out UserCode);
    }

    override public void unlockRecord(Persistent obj)
    {
        //obj = (Talent)obj;
        //string strSql;
        //strSql = "UPDATE talent SET lock_time=null WHERE talent_code=" + obj.IntCode;
        //ProcessNonQuery(strSql, false);
        DBUtil.RefreshOrUnlockRecord(myConnection, obj, "talent", "talent_code", false);

    }

    override public void refreshRecord(Persistent obj)
    {
        //obj = (Talent)obj;
        //string strSql;
        //strSql = "UPDATE talent SET lock_time=getdate() WHERE talent_code=" + obj.IntCode;
        //ProcessNonQuery(strSql, false);
        DBUtil.RefreshOrUnlockRecord(myConnection, obj, "talent", "talent_code", true);

    }

    public void GetStatus(ref bool _Director,ref bool _StarCast,Int32 _IntCode)
    {
        DataSet ds = new DataSet();
        ds = this.ProcessSelect("select director_code from title where director_code=" + _IntCode + ";"
        + "select talent_code from Title_Talent where talent_code=" + _IntCode);
        if (ds.Tables[0].Rows.Count > 0)
        {
            _Director = true;
        }
        if (ds.Tables[1].Rows.Count > 0)
        {
            _StarCast = true;
        }
    }
}
