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
/// Summary description for ModuleValidationBroker
/// </summary>
public class ModuleValidationBroker:DatabaseBroker
{
	public ModuleValidationBroker()
	{
		//
		// TODO: Add constructor logic here
		//
	}

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
        return "select count(*) from Module_Validation where module_validation_code > 0" + strSearchString;
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
        string sql = "select * from Module_Validation WHERE module_validation_code > -1 " + strSearchString;
        if (objCriteria.IsPagingRequired)
        {
            sql = objCriteria.getPagingSQL(sql);
            return sql;
        }
        return sql + " ORDER BY " + objCriteria.getASCstr();
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        ModuleValidation objModValidation = (ModuleValidation)obj;
        string strSql = "Select * from dbo.Module_Validation where module_validation_code = " + objModValidation.IntCode;
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ModuleValidation objModValidation;
        if (obj == null)
        {
            objModValidation = new ModuleValidation();
        }
        else
        {
            objModValidation = (ModuleValidation)obj;
        }

        objModValidation.IntCode = Convert.ToInt32(dRow["module_validation_code"]);

        objModValidation.moduleCode = Convert.ToInt32(dRow["module_code"]);
        objModValidation.tableName = Convert.ToString(dRow["table_name"]);
        objModValidation.primaryColName = Convert.ToString(dRow["primary_column_name"]);
        objModValidation.dateColName = Convert.ToString(dRow["date_column_name"]);
        
        return objModValidation;
    }
}
