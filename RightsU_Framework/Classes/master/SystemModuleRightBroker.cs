using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for BankBroker
/// </summary>
public class SystemModuleRightBroker : DatabaseBroker {
    string strSql = "";
    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        Criteria objCrt = (Criteria)objCriteria;
        SystemModuleRight objSysRight = (SystemModuleRight)objCrt.ClassRef;
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

            strSql = "select top " + intP1 + " * from (select top " + intP2 + " * from System_Module_Right where module_right_code > 0 " + strSearchString + " order by  " + objSysRight.OrderByColumnName + " " + objSysRight.OrderByReverseCondition + " ) as a1 order by " + objSysRight.OrderByColumnName + "  " + objSysRight.OrderByCondition;

        }
        else
        {
            strSql = "select * from System_Module_Right where module_right_code > 0 " + strSearchString;

        }
        return strSql;

    }
    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = null;
        return true;
    }
    public override bool CheckDuplicate(Persistent obj)
    {
        return new Boolean();
    }
    public override string GetActivateDeactivateSql(Persistent obj)
    {
        return null;
    }
    public override string GetCountSql(string strSearchString)
    {
        return "select count(*) from System_Module_Right where module_right_code > 0 " + strSearchString + "";
    }
    public override string GetDeleteSql(Persistent obj)
    {
        SystemModuleRight objSystemModuleRight = (SystemModuleRight)obj;
        return "Delete from System_Module_Right where module_right_code='" + objSystemModuleRight.IntCode + "'";
    }
    public override string GetInsertSql(Persistent obj)
    {
        SystemModuleRight objSystemModuleRight = (SystemModuleRight)obj;
        return "Insert into System_Module_Right(module_code, right_code) values ('"
    + objSystemModuleRight.moduleCode + "', '" + objSystemModuleRight.rightCode + "')";


    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        SystemModuleRight objSystemModuleRight = (SystemModuleRight)obj;
        strSql = "select count(*) from System_Module_Right where module_right_code='" + objSystemModuleRight.IntCode + "'";
        return strSql;
    }
    public override string GetUpdateSql(Persistent obj)
    {
        SystemModuleRight objSystemModuleRight = (SystemModuleRight)obj;

        return "Update System_Module_Right set module_code='" + objSystemModuleRight.moduleCode + "'"
        + ", right_code='" + objSystemModuleRight.rightCode + "'"
        + " where module_right_code ='" + objSystemModuleRight.IntCode + "'";
    }
    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        SystemModuleRight objSystemModuleRight;
        if (obj == null)
        {
            objSystemModuleRight = new SystemModuleRight();
        }
        else
        {
            objSystemModuleRight = (SystemModuleRight)obj;
        }
        objSystemModuleRight.IntCode = Convert.ToInt32(dRow["module_right_code"]);
        objSystemModuleRight.moduleCode = Convert.ToInt32(dRow["module_code"]);
        objSystemModuleRight.rightCode = Convert.ToInt32(dRow["right_code"]);

        objSystemModuleRight.objSysModule = new SystemModule();
        objSystemModuleRight.objSysModule.IntCode = Convert.ToInt32(dRow["module_code"].ToString().Trim());
        objSystemModuleRight.objSysModule.Fetch();

        objSystemModuleRight.objSysRight = new SystemRight();
        objSystemModuleRight.objSysRight.IntCode = Convert.ToInt32(dRow["right_code"].ToString().Trim());
        objSystemModuleRight.objSysRight.Fetch();

        return objSystemModuleRight;
    }
}
