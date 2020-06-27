using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for SystemRightBroker
/// </summary>
public class SystemRightBroker : DatabaseBroker {
    string strSql = "";
    public SystemRightBroker()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        Criteria objCrt = (Criteria)objCriteria;
        SystemRight objSysRight = (SystemRight)objCrt.ClassRef;
        int intP1, intP2;
        if (objCrt.IsPagingRequired)
        {
            intP1 = objCrt.RecordPerPage;
            if (objCrt.PageNo == 1)
            {
                intP2 = objCrt.RecordCount;
            }
            else
            {
                intP2 = Math.Abs((objCrt.RecordCount - (objCrt.RecordPerPage * (objCrt.PageNo - 1))));
            }
            strSql = "select top " + intP1 + " * from (select top " + intP2 + " * from System_Right where right_code > 0 " + strSearchString + " order by " + objSysRight.OrderByColumnName + " " + objSysRight.OrderByCondition + ")";
        }
        else
        {
            strSql = "select * from System_Right where right_code > 0 " + strSearchString;
        }
        return strSql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        SystemRight objSysRight;
        if (obj != null)
        {
            objSysRight = (SystemRight)obj;
        }
        else
        {
            objSysRight = new SystemRight();
        }

        objSysRight.rightName = Convert.ToString(dRow["right_name"]);
        objSysRight.IntCode = Convert.ToInt32(dRow["right_code"]);

        return objSysRight;
    }

    public override Boolean CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        SystemRight objSysRight = (SystemRight)obj;
        strSql = "insert into System_Right(right_name) values ('" + objSysRight.rightName + "')";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        SystemRight objSysRight = (SystemRight)obj;
        strSql = "update System_Right set right_name='" + objSysRight.rightName + "' where right_code='" + objSysRight.IntCode + "'";
        return strSql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = null;
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        SystemRight objSysRight = (SystemRight)obj;
        strSql = "delete from System_Right where right_code='" + objSysRight.IntCode + "'";
        return strSql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        return null;
    }

    public override string GetCountSql(string strSearchString)
    {
        strSql = "select count(*) from System_Right where right_code > 0" + strSearchString;
        return strSql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        SystemRight objSysRight = (SystemRight)obj;
        strSql = "select * from System_Right where right_code='" + objSysRight.IntCode + "'";
        return strSql;
    }
}
