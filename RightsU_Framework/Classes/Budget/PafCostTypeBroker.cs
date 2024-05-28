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
/// Summary description for PafCostType
/// </summary>
public class PafCostTypeBroker : DatabaseBroker
{
	public PafCostTypeBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Paf_Cost_Type] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        PafCostType objPafCostType;
		if (obj == null)
		{
			objPafCostType = new PafCostType();
		}
		else
		{
			objPafCostType = (PafCostType)obj;
		}

		objPafCostType.IntCode = Convert.ToInt32(dRow["paf_cost_type_code"]);
		#region --populate--
		if (dRow["paf_code"] != DBNull.Value)
			objPafCostType.PafCode = Convert.ToInt32(dRow["paf_code"]);
		if (dRow["paf_ctm_code"] != DBNull.Value)
			objPafCostType.PafCtmCode = Convert.ToInt32(dRow["paf_ctm_code"]);
		if (dRow["ams_cost_type_code"] != DBNull.Value)
			objPafCostType.AmsCostTypeCode = Convert.ToInt32(dRow["ams_cost_type_code"]);
		if (dRow["amount"] != DBNull.Value)
			objPafCostType.amount = Convert.ToDecimal(dRow["amount"]);
		if (dRow["utilized"] != DBNull.Value)
			objPafCostType.utilized = Convert.ToDecimal(dRow["utilized"]);
		if (dRow["balance"] != DBNull.Value)
			objPafCostType.balance = Convert.ToDecimal(dRow["balance"]);
		objPafCostType.EntryType = Convert.ToString(dRow["entry_type"]);
		#endregion
		return objPafCostType;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		PafCostType objPafCostType = (PafCostType)obj;
		return "insert into [Paf_Cost_Type]([paf_code], [paf_ctm_code], [ams_cost_type_code], [amount], [utilized], [balance], [entry_type]) values('" + objPafCostType.PafCode + "', '" + objPafCostType.PafCtmCode + "', '" + objPafCostType.AmsCostTypeCode + "', '" + objPafCostType.amount + "', '" + objPafCostType.utilized + "', '" + objPafCostType.balance + "', '" + objPafCostType.EntryType.Trim().Replace("'", "''") + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		PafCostType objPafCostType = (PafCostType)obj;
		return "update [Paf_Cost_Type] set [paf_code] = '" + objPafCostType.PafCode + "', [paf_ctm_code] = '" + objPafCostType.PafCtmCode + "', [ams_cost_type_code] = '" + objPafCostType.AmsCostTypeCode + "', [amount] = '" + objPafCostType.amount + "', [utilized] = '" + objPafCostType.utilized + "', [balance] = '" + objPafCostType.balance + "', [entry_type] = '" + objPafCostType.EntryType.Trim().Replace("'", "''") + "' where paf_cost_type_code = '" + objPafCostType.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		PafCostType objPafCostType = (PafCostType)obj;

		return " DELETE FROM [Paf_Cost_Type] WHERE paf_cost_type_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        PafCostType objPafCostType = (PafCostType)obj;
return "Update [Paf_Cost_Type] set Is_Active='" + objPafCostType.Is_Active + "',lock_time=null, last_updated_time= getdate() where paf_cost_type_code = '" + objPafCostType.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [Paf_Cost_Type] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [Paf_Cost_Type] WHERE  paf_cost_type_code = " + obj.IntCode;
    }  
}
