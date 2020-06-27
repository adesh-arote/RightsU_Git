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
/// Summary description for securitygrouprel
/// </summary>
public class SecurityGroupRelBroker : DatabaseBroker {
    public SecurityGroupRelBroker()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    #region ---------------Methods---------------

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlselect = "";
        if (!objCriteria.IsPagingRequired)
            sqlselect = "SELECT * FROM security_group_rel where security_rel_code > 0 " + strSearchString + " ORDER BY " + objCriteria.ClassRef.OrderByColumnName;
        else
        {
            int p1 = objCriteria.GetPagingP1();
            int p2 = objCriteria.GetPagingP2();
            sqlselect = "select * from ( Select Top " + p1 + " * From (SELECT TOP " + p2 + " * FROM security_group_rel  where security_rel_code > -1 " + strSearchString + "  Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition
            + ") As a1 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByReverseCondition
            + " ) as a3 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition;
        }
        return sqlselect;

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        SecurityGroupRel Objsecuritygrouprel;
        if (obj == null)
        {
            Objsecuritygrouprel = new SecurityGroupRel();
        }
        else
        {
            Objsecuritygrouprel = (SecurityGroupRel)obj;
        }
        Objsecuritygrouprel.IntCode = Convert.ToInt32(dRow["security_rel_code"]);
        if (System.DBNull.Value != dRow["security_group_code"])
            Objsecuritygrouprel.securitygroupcode = Convert.ToInt32(dRow["security_group_code"]);
        if (System.DBNull.Value != dRow["system_module_rights_code"])
            Objsecuritygrouprel.systemmodulerightscode = Convert.ToInt32(dRow["system_module_rights_code"]);
        return Objsecuritygrouprel;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        SecurityGroupRel objsecuritygrouprel = (SecurityGroupRel)obj;
        string sql = "Insert into security_group_rel(security_group_code ,system_module_rights_code )values('" + objsecuritygrouprel.securitygroupcode + "','" + objsecuritygrouprel.systemmodulerightscode + "')";
        return sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        SecurityGroupRel objsecuritygrouprel = (SecurityGroupRel)obj;
        string sql = "UPDATE security_group_rel set security_group_code = '" + objsecuritygrouprel.securitygroupcode + "',system_module_rights_code = '" + objsecuritygrouprel.systemmodulerightscode + "' WHERE 1=1 and security_rel_code = '" + objsecuritygrouprel.IntCode + "'";
        return sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        string sql = " delete security_group_rel where security_rel_code=" + obj.IntCode;
        return sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        string sql = " select count(*) from security_group_rel where 1=1 " + strSearchString;
        return sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        string sql = "select * from security_group_rel where security_rel_code =" + obj.IntCode;
        return sql;
    }
    #endregion
}
