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
/// Summary description for TalentDetailsBroker
/// </summary>
public class TalentRolesBroker:DatabaseBroker 
{
    public TalentRolesBroker()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    //public override bool CanDelete(Persistent obj, out string strMessage)
    //{
    //    throw new Exception("The method or operation is not implemented.");
    //}

    //public override bool CheckDuplicate(Persistent obj)
    //{
    //    throw new Exception("The method or operation is not implemented.");
    //}

    //public override string GetActivateDeactivateSql(Persistent obj)
    //{
    //    throw new Exception("The method or operation is not implemented.");
    //}

    //public override string GetCountSql(string strSearchString)
    //{
    //    throw new Exception("The method or operation is not implemented.");
    //}

    //public override string GetDeleteSql(Persistent obj)
    //{
    //    throw new Exception("The method or operation is not implemented.");
    //}

    //public override string GetInsertSql(Persistent obj)
    //{
    //    throw new Exception("The method or operation is not implemented.");
    //}

    //public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    //{
    //    throw new Exception("The method or operation is not implemented.");
    //}

    //public override string GetSelectSqlOnCode(Persistent obj)
    //{
    //    throw new Exception("The method or operation is not implemented.");
    //}

    //public override string GetUpdateSql(Persistent obj)
    //{
    //    throw new Exception("The method or operation is not implemented.");
    //}

    //public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    //{
    //    throw new Exception("The method or operation is not implemented.");
    //}


    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;        
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return "SELECT COUNT(*) FROM Talent_role WHERE talent_role_code > -1 " + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        TalentRoles objTalentRoles = (TalentRoles)obj;
        return "Delete from talent_role where talent_role_code=" + obj.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        TalentRoles objTalentRoles = (TalentRoles)obj;
        string sql = "INSERT INTO Talent_Role(talent_code,role_code) " +
                   "VALUES(" + objTalentRoles.talentCode + "," + objTalentRoles.objRoles.IntCode + ")";
        return sql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = "SELECT * FROM Talent_Role WHERE talent_code > -1 " + strSearchString;
        if (objCriteria.IsPagingRequired)
        {
            return objCriteria.getPagingSQL(sql); ;
        }
        return sql + " ORDER BY " + objCriteria.getASCstr();
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "SELECT * FROM Talent_Role WHERE talent_role_code =" + obj.IntCode;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        TalentRoles objTalentRoles = (TalentRoles)obj;
        return "UPDATE Talent_Role SET talent_code=" + objTalentRoles.talentCode
            + ", role_code=" + objTalentRoles.objRoles.IntCode + " WHERE talent_role_code =" + objTalentRoles.IntCode;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TalentRoles objTalentRoles;
        if (obj == null)
           objTalentRoles = new TalentRoles();
        else
        {
            objTalentRoles = (TalentRoles)obj;
        }
        objTalentRoles.IntCode = Convert.ToInt32(dRow["talent_role_code"]);
        objTalentRoles.talentCode = Convert.ToInt32(dRow["talent_code"]);
        Roles objRoles = new Roles();
        objRoles.IntCode = Convert.ToInt32(dRow["role_code"]);
        objTalentRoles.objRoles = objRoles;
        objTalentRoles.status = "MOD";
        return objTalentRoles;

    }
}
