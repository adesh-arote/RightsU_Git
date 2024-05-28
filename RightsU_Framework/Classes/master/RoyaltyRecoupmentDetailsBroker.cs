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
/// Summary description for RoyaltyRecoupmentDetails
/// </summary>
public class RoyaltyRecoupmentDetailsBroker : DatabaseBroker
{
	public RoyaltyRecoupmentDetailsBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Royalty_Recoupment_Details] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RoyaltyRecoupmentDetails objRoyaltyRecoupmentDetails;
		if (obj == null)
		{
			objRoyaltyRecoupmentDetails = new RoyaltyRecoupmentDetails();
		}
		else
		{
			objRoyaltyRecoupmentDetails = (RoyaltyRecoupmentDetails)obj;
		}

		objRoyaltyRecoupmentDetails.IntCode = Convert.ToInt32(dRow["royalty_recoupment_details_code"]);
		#region --populate--
		if (dRow["royalty_recoupment_code"] != DBNull.Value)
			objRoyaltyRecoupmentDetails.RoyaltyRecoupmentCode = Convert.ToInt32(dRow["royalty_recoupment_code"]);
		objRoyaltyRecoupmentDetails.RecoupmentType = Convert.ToString(dRow["recoupment_type"]);
		if (dRow["recoupment_type_code"] != DBNull.Value)
			objRoyaltyRecoupmentDetails.RecoupmentTypeCode = Convert.ToInt32(dRow["recoupment_type_code"]);
		objRoyaltyRecoupmentDetails.AddSubtract = Convert.ToString(dRow["add_subtract"]);
        if (dRow["position"] != DBNull.Value)
        objRoyaltyRecoupmentDetails.Position = Convert.ToInt32(dRow["position"]);
		#endregion
		return objRoyaltyRecoupmentDetails;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		RoyaltyRecoupmentDetails objRoyaltyRecoupmentDetails = (RoyaltyRecoupmentDetails)obj;
		return "insert into [Royalty_Recoupment_Details]([royalty_recoupment_code], [recoupment_type], [recoupment_type_code],[position]) values(" + objRoyaltyRecoupmentDetails.RoyaltyRecoupmentCode + ", '" + objRoyaltyRecoupmentDetails.RecoupmentType.Trim().Replace("'", "''") + "', " + objRoyaltyRecoupmentDetails.RecoupmentTypeCode + ","+objRoyaltyRecoupmentDetails.Position+");";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		RoyaltyRecoupmentDetails objRoyaltyRecoupmentDetails = (RoyaltyRecoupmentDetails)obj;
		return "update [Royalty_Recoupment_Details] set [royalty_recoupment_code] = " + objRoyaltyRecoupmentDetails.RoyaltyRecoupmentCode + ", [recoupment_type] = '" + objRoyaltyRecoupmentDetails.RecoupmentType.Trim().Replace("'", "''") + "', [recoupment_type_code] = " + objRoyaltyRecoupmentDetails.RecoupmentTypeCode + ",[position]="+objRoyaltyRecoupmentDetails.Position+" where royalty_recoupment_details_code = " + objRoyaltyRecoupmentDetails.IntCode + ";";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		RoyaltyRecoupmentDetails objRoyaltyRecoupmentDetails = (RoyaltyRecoupmentDetails)obj;

		return " DELETE FROM [Royalty_Recoupment_Details] WHERE royalty_recoupment_details_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        RoyaltyRecoupmentDetails objRoyaltyRecoupmentDetails = (RoyaltyRecoupmentDetails)obj;
return "Update [Royalty_Recoupment_Details] set Is_Active='" + objRoyaltyRecoupmentDetails.Is_Active + "',lock_time=null, last_updated_time= getdate() where royalty_recoupment_details_code = '" + objRoyaltyRecoupmentDetails.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [Royalty_Recoupment_Details] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [Royalty_Recoupment_Details] WHERE  royalty_recoupment_details_code = " + obj.IntCode;
    }

    public DataSet getCostType(int intcode)
    {
        // string sql = "select cost_type_code,cost_type_name,'C'costtype  from Cost_Type  where is_active='Y' "
        //  +" union "
        // + "select additional_expense_code,additional_expense_name,'A'costtype  from Additional_Expense where is_active='Y'";
        string sql = " select * from ("
+ "select c.cost_type_code,c.cost_type_name,'C'costtype,rcd.royalty_recoupment_details_code,rcd.royalty_recoupment_code,rcd.position  from Cost_Type  c "
+ "left join Royalty_Recoupment_Details rcd on rcd.recoupment_type_code=c.cost_type_code  "
+ "and rcd.recoupment_type='C' and rcd.royalty_recoupment_code= " + intcode
+ "where (is_active='Y' or rcd.royalty_recoupment_details_code>0)"
+ "union "
+ "select a.additional_expense_code,a.additional_expense_name,'A'costtype,rcd.royalty_recoupment_details_code,rcd.royalty_recoupment_code,rcd.position  from Additional_Expense a "
+ "left join Royalty_Recoupment_Details rcd on rcd.recoupment_type_code=a.additional_expense_code "
+ "and rcd.recoupment_type='A' and rcd.royalty_recoupment_code=" + intcode
+ " where (is_active='Y' or rcd.royalty_recoupment_details_code>0)"
+ ") as a "
  + "order by isnull(royalty_recoupment_details_code,'99999'),cost_type_name";

        DataSet ds = ProcessSelect(sql);

        return ds;
    }
}
