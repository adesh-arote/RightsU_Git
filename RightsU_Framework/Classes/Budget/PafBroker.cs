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
using System.Data.SqlClient;

/// <summary>
/// Summary description for Paf
/// </summary>
public class PafBroker : DatabaseBroker
{
	public PafBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Paf] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Paf objPaf;
		if (obj == null)
		{
			objPaf = new Paf();
		}
		else
		{
			objPaf = (Paf)obj;
		}

		objPaf.IntCode = Convert.ToInt32(dRow["paf_code"]);
		#region --populate--
		objPaf.PafNo = Convert.ToString(dRow["paf_no"]);
		if (dRow["creation_date"] != DBNull.Value)
			objPaf.CreationDate = Convert.ToDateTime(dRow["creation_date"]).ToString("dd/MM/yyyy");
		objPaf.TitleName = Convert.ToString(dRow["title_name"]);
		if (dRow["amount"] != DBNull.Value)
			objPaf.amount = Convert.ToDecimal(dRow["amount"]);
		if (dRow["utilized"] != DBNull.Value)
			objPaf.utilized = Convert.ToDecimal(dRow["utilized"]);
		if (dRow["balance"] != DBNull.Value)
			objPaf.balance = Convert.ToDecimal(dRow["balance"]);
		#endregion
		return objPaf;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		Paf objPaf = (Paf)obj;
		return "insert into [Paf]([paf_no], [creation_date], [title_name], [amount], [utilized], [balance]) values('" + objPaf.PafNo.Trim().Replace("'", "''") + "', '" + objPaf.CreationDate + "', '" + objPaf.TitleName.Trim().Replace("'", "''") + "', '" + objPaf.amount + "', '" + objPaf.utilized + "', '" + objPaf.balance + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		Paf objPaf = (Paf)obj;
		return "update [Paf] set [paf_no] = '" + objPaf.PafNo.Trim().Replace("'", "''") + "', [creation_date] = '" + objPaf.CreationDate + "', [title_name] = '" + objPaf.TitleName.Trim().Replace("'", "''") + "', [amount] = '" + objPaf.amount + "', [utilized] = '" + objPaf.utilized + "', [balance] = '" + objPaf.balance + "' where paf_code = '" + objPaf.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		Paf objPaf = (Paf)obj;
		if (objPaf.arrPafCostType.Count > 0)
			DBUtil.DeleteChild("PafCostType", objPaf.arrPafCostType, objPaf.IntCode, (SqlTransaction)objPaf.SqlTrans);
		//if (objPaf.arrDealMoviePAFDetail.Count > 0)
		//    DBUtil.DeleteChild("DealPAFDetail", objPaf.arrDealMoviePAFDetail, objPaf.IntCode, (SqlTransaction)objPaf.SqlTrans);

		return " DELETE FROM [Paf] WHERE paf_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Paf objPaf = (Paf)obj;
return "Update [Paf] set Is_Active='" + objPaf.Is_Active + "',lock_time=null, last_updated_time= getdate() where paf_code = '" + objPaf.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [Paf] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [Paf] WHERE  paf_code = " + obj.IntCode;
    }  
}
