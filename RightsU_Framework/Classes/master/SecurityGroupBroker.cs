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
/// Summary description for securitygroup
/// </summary>
public class SecurityGroupBroker : DatabaseBroker
{
    public SecurityGroupBroker()
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
            sqlselect = "SELECT * FROM security_group where security_group_code > 0 " + strSearchString + " ORDER BY " + objCriteria.ClassRef.OrderByColumnName;
        else
        {
            int p1 = objCriteria.GetPagingP1();
            int p2 = objCriteria.GetPagingP2();
            sqlselect = "select * from ( Select Top " + p1 + " * From (SELECT TOP " + p2 + " * FROM security_group  where security_group_code > -1 " + strSearchString + "  Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition
            + ") As a1 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByReverseCondition
            + " ) as a3 Order By " + objCriteria.ClassRef.OrderByColumnName + " " + objCriteria.ClassRef.OrderByCondition;
        }
        return sqlselect;

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        SecurityGroup Objsecuritygroup;
        if (obj == null)
        {
            Objsecuritygroup = new SecurityGroup();
        }
        else
        {
            Objsecuritygroup = (SecurityGroup)obj;
        }
        Objsecuritygroup.IntCode = Convert.ToInt32(dRow["security_group_code"]);
        Objsecuritygroup.securitygroupname = Convert.ToString(dRow["security_group_name"]);
        Objsecuritygroup.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        Objsecuritygroup.Is_Active = Convert.ToString(dRow["Is_Active"]);
        return Objsecuritygroup;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        SecurityGroup objSecurityGroup=(SecurityGroup)obj;
        if (objSecurityGroup.SqlTrans != null)
            return DBUtil.IsDuplicateSqlTrans(ref obj,"Security_Group","Security_Group_name", ((SecurityGroup)obj).securitygroupname,"Security_Group_code",((SecurityGroup)obj).IntCode,"Security group name already exists","",true);
        else
            return DBUtil.IsDuplicate(myConnection, "Security_Group", "Security_Group_name", ((SecurityGroup)obj).securitygroupname, "Security_Group_code", ((SecurityGroup)obj).IntCode, "Security group name already exists", "", true);
            
        
    }

    public override string GetInsertSql(Persistent obj)
    {
        SecurityGroup objsecuritygroup = (SecurityGroup)obj;
        string sql = "Insert into security_group(security_group_name,Inserted_On,Inserted_By,Is_Active )values(N'" + objsecuritygroup.securitygroupname.Replace("'", "''").Trim() + "', GETDATE(),'" + objsecuritygroup.InsertedBy + "','Y')";
        return sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        SecurityGroup objsecuritygroup = (SecurityGroup)obj;
        string sql = "UPDATE security_group set security_group_name = N'" + objsecuritygroup.securitygroupname.Replace("'", "''").Trim() + "', Last_Updated_Time=GETDATE(),Last_Action_By='"+ objsecuritygroup.LastActionBy +"' WHERE 1=1 and security_group_code = '" + objsecuritygroup.IntCode + "'";
        return sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        string sql = " delete security_group where security_group_code=" + obj.IntCode;
        return sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        SecurityGroup objSecurityGroup = (SecurityGroup)obj;
        string strSql = " UPDATE security_group SET Is_Active='" + objSecurityGroup.Is_Active + "',Lock_Time=null,Last_Updated_Time=GETDATE() WHERE Security_Group_code=" + objSecurityGroup.IntCode;
        return strSql;
    }

    public override string GetCountSql(string strSearchString)
    {
        string sql = " select count(*) from security_group where 1=1 " + strSearchString;
        return sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        string sql = "select * from security_group where security_group_code =" + obj.IntCode;
        return sql;
    }
    #endregion

    internal string getSecurityGroupRelCodes(int sec_code)
    {
        string sql = "";
        sql = "declare @sec_rel_code varchar(5000); set @sec_rel_code = ''";
        sql += "select @sec_rel_code = @sec_rel_code + '!' + cast(system_module_rights_code as varchar(10)) + '#' from security_group_rel where security_group_code = '" + sec_code + "'; select @sec_rel_code";

        string result = Convert.ToString(ProcessScalar(sql));
        return result;
    }
    public ArrayList getArrUserRightCodes(int groupCode, int moduleCode, string strSearch)
    {
        string sql = "select right_code from System_Module_Right smr inner join security_group_rel sgr on smr.module_right_code = sgr.system_module_rights_code "
                     + " where sgr.security_group_code = '" + groupCode + "' and smr.module_code='" + moduleCode + "' " + strSearch;
        ArrayList arrUserRight = new ArrayList();
        DataSet ds = ProcessSelect(sql);
        foreach (DataRow drow in ds.Tables[0].Rows)
        {
            arrUserRight.Add(Convert.ToInt32(drow["right_code"]));
        }
        return arrUserRight;
    }

    internal string getArrUserRightCodesString(int groupCode, int moduleCode, string strSearch)
    {
        string sql = "select right_code from System_Module_Right smr inner join security_group_rel sgr on smr.module_right_code = sgr.system_module_rights_code "
                     + " where sgr.security_group_code = '" + groupCode + "' and smr.module_code='" + moduleCode + "' " + strSearch;
        DataSet ds = ProcessSelect(sql);
        string srtReturn = "";
        foreach (DataRow drow in ds.Tables[0].Rows)
        {
            srtReturn += Convert.ToString(drow["right_code"]) + "~";
        }
        if (srtReturn != null)
            srtReturn = srtReturn.Trim("~".ToCharArray());
        else
            srtReturn = "";
        return srtReturn;
    }
}
