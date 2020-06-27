using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for SystemModuleBroker
/// </summary>
public class SystemModuleBroker : DatabaseBroker {
    string strSql = "";
    public SystemModuleBroker()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        Criteria objCrt = (Criteria)objCriteria;
        SystemModule objSysModule = (SystemModule)objCrt.ClassRef;
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
                intP2 = Math.Abs((objCrt.RecordCount - (objCrt.RecordCount * (objCrt.PageNo - 1))));
            }
            strSql = "select top " + intP1 + " * from (select top " + intP2 + " * from System_Module where module_code > 0 " + strSearchString + " order by " + objSysModule.OrderByColumnName + " " + objSysModule.OrderByReverseCondition + " ) as a1 order by " + objSysModule.OrderByColumnName + " " + objSysModule.OrderByCondition;
        }
        else
        {
            if (strSearchString == "")
            {
                strSearchString = " order by " + objSysModule.OrderByColumnName;
            }
            strSql = "select * from System_Module where module_code > 0 " + strSearchString;// +" order by " + objSysModule.OrderByColumnName + " " + objSysModule.OrderByCondition;
        }
        return strSql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        SystemModule objSysModule;
        if (obj != null)
        {
            objSysModule = (SystemModule)obj;
        }
        else
        {
            objSysModule = new SystemModule();
        }
        objSysModule.IntCode = Convert.ToInt32(dRow["module_code"]);
        objSysModule.moduleName = Convert.ToString(dRow["module_name"]);
        objSysModule.modulePosition = Convert.ToString(dRow["module_position"]);
        objSysModule.isSubModule = Convert.ToString(dRow["is_sub_module"]);

        return objSysModule;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        SystemModule objSysModule = (SystemModule)obj;
        strSql = "insert into System_Module(module_name,module_position) values('" + objSysModule.moduleName + "','" + objSysModule.modulePosition + "')";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        SystemModule objSysModule = (SystemModule)obj;
        strSql = "update System_Module set module_name='" + objSysModule.moduleName + "',module_position='" + objSysModule.modulePosition + "' where module_code='" + objSysModule.IntCode + "'";
        return strSql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = null;
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        SystemModule objSysModule = (SystemModule)obj;
        strSql = "delete from System_Module where module_code='" + objSysModule.IntCode + "'";
        return strSql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        return null;
    }

    public override string GetCountSql(string strSearchString)
    {
        strSql = "select count(*) from System_Module where module_code >0 " + strSearchString + "'";
        return strSql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        SystemModule objSysModule = (SystemModule)obj;
        strSql = "select * from System_Module where module_code='" + objSysModule.IntCode + "'";
        return strSql;
    }
}
