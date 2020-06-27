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
/// Summary description for ModuleStatusHistoryBroker
/// </summary>
public class ModuleStatusHistoryBroker:DatabaseBroker
{
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
        return "SELECT COUNT(*) FROM Module_Status_History WHERE module_status_code > -1 " + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        return "DELETE FROM Module_Status_History WHERE module_status_code=" + obj.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        ModuleStatusHistory objModStatusHist = (ModuleStatusHistory)obj;
        string sql = "INSERT INTO Module_Status_History(module_code,record_code,status,status_changed_by,status_changed_on,remarks) " +
                     "VALUES(" + objModStatusHist.objModule.IntCode + "," + objModStatusHist.recordCode
                     + ",'"+ GlobalUtil.ReplaceSingleQuotes(objModStatusHist.status)
                     + "'," + objModStatusHist.objStatusChangedBy.IntCode
                     + ",getdate(),'"+ GlobalUtil.ReplaceSingleQuotes(objModStatusHist.remarks) +"')";
        return sql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = "SELECT * FROM Module_Status_History WHERE module_status_code > -1 " + strSearchString;
        if (objCriteria.IsPagingRequired){
            sql = objCriteria.getPagingSQL(sql);
            return sql;
        }
        return sql + " ORDER BY " + objCriteria.getASCstr();
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "SELECT * FROM Module_Status_History WHERE module_status_code=" + obj.IntCode;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        ModuleStatusHistory objModStatusHist = (ModuleStatusHistory)obj;
        string sql = "UPDATE Module_Status_History SET module_code="+ objModStatusHist.objModule.IntCode
            + ",record_code="+ objModStatusHist.recordCode
            + ",status='"+ GlobalUtil.ReplaceSingleQuotes(objModStatusHist.status)
            + "',status_changed_by="+ objModStatusHist.objStatusChangedBy.IntCode
            + ",status_changed_on=getdate(),remarks='"+ GlobalUtil.ReplaceSingleQuotes(objModStatusHist.remarks)
            +"' WHERE module_status_code=" + obj.IntCode;
        return sql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ModuleStatusHistory objModStatusHist;
        if (obj == null){
            objModStatusHist = new ModuleStatusHistory();
        }
        else{
            objModStatusHist = (ModuleStatusHistory)obj;
        }
        objModStatusHist.IntCode = Convert.ToInt32(dRow["module_status_code"]);
        objModStatusHist.objModule.IntCode = Convert.ToInt32(dRow["module_code"]);
        objModStatusHist.recordCode = Convert.ToInt32(dRow["record_code"]);
        objModStatusHist.status = Convert.ToString(dRow["status"]);
        objModStatusHist.objStatusChangedBy.IntCode = Convert.ToInt32(dRow["status_changed_by"]);
        if (dRow["status_changed_on"] != DBNull.Value)
        {
            //objModStatusHist.statusChangedOn = Convert.ToString(dRow["status_changed_on"]);
            DateTime tmpChangedOn = Convert.ToDateTime(dRow["status_changed_on"]);
            objModStatusHist.statusChangedOn = tmpChangedOn.ToString("dd/MM/yyyy");
        }
        if (dRow["remarks"] != DBNull.Value) {
            objModStatusHist.remarks = Convert.ToString(dRow["remarks"]);
        }
        return objModStatusHist;
    }
}
