using System;
using System.Data;
using System.Configuration;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for PafCostTypeMapping
/// </summary>
public class PafCostTypeMappingBroker : DatabaseBroker
{
	public PafCostTypeMappingBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Paf_Cost_Type_Mapping] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        PafCostTypeMapping objPafCostTypeMapping;
		if (obj == null)
		{
			objPafCostTypeMapping = new PafCostTypeMapping();
		}
		else
		{
			objPafCostTypeMapping = (PafCostTypeMapping)obj;
		}

		objPafCostTypeMapping.IntCode = Convert.ToInt32(dRow["paf_ctm_code"]);
		#region --populate--
		objPafCostTypeMapping.PafCostType = Convert.ToString(dRow["paf_cost_type"]);
		if (dRow["ams_cost_type_code"] != DBNull.Value)
			objPafCostTypeMapping.AmsCostTypeCode = Convert.ToInt32(dRow["ams_cost_type_code"]);
		#endregion
		return objPafCostTypeMapping;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		PafCostTypeMapping objPafCostTypeMapping = (PafCostTypeMapping)obj;
		return "insert into [Paf_Cost_Type_Mapping]([paf_cost_type], [ams_cost_type_code]) values('" + objPafCostTypeMapping.PafCostType.Trim().Replace("'", "''") + "', '" + objPafCostTypeMapping.AmsCostTypeCode + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		PafCostTypeMapping objPafCostTypeMapping = (PafCostTypeMapping)obj;
		return "update [Paf_Cost_Type_Mapping] set [paf_cost_type] = '" + objPafCostTypeMapping.PafCostType.Trim().Replace("'", "''") + "', [ams_cost_type_code] = '" + objPafCostTypeMapping.AmsCostTypeCode + "' where paf_ctm_code = '" + objPafCostTypeMapping.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		PafCostTypeMapping objPafCostTypeMapping = (PafCostTypeMapping)obj;

		return " DELETE FROM [Paf_Cost_Type_Mapping] WHERE paf_ctm_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        PafCostTypeMapping objPafCostTypeMapping = (PafCostTypeMapping)obj;
return "Update [Paf_Cost_Type_Mapping] set Is_Active='" + objPafCostTypeMapping.Is_Active + "',lock_time=null, last_updated_time= getdate() where paf_ctm_code = '" + objPafCostTypeMapping.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [Paf_Cost_Type_Mapping] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [Paf_Cost_Type_Mapping] WHERE  paf_ctm_code = " + obj.IntCode;
    }  
}
