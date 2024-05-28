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
/// Summary description for RoyaltyCommissionDetails
/// </summary>
public class RoyaltyCommissionDetailsBroker : DatabaseBroker
{
    public RoyaltyCommissionDetailsBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Royalty_Commission_Details] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        RoyaltyCommissionDetails objRoyaltyCommissionDetails;
        if (obj == null)
        {
            objRoyaltyCommissionDetails = new RoyaltyCommissionDetails();
        }
        else
        {
            objRoyaltyCommissionDetails = (RoyaltyCommissionDetails)obj;
        }

        objRoyaltyCommissionDetails.IntCode = Convert.ToInt32(dRow["royalty_commission_details_code"]);
        #region --populate--
        if (dRow["royalty_commission_code"] != DBNull.Value)
            objRoyaltyCommissionDetails.RoyaltyCommissionCode = Convert.ToInt32(dRow["royalty_commission_code"]);
        objRoyaltyCommissionDetails.CommissionType = Convert.ToString(dRow["commission_type"]);
        if (dRow["commission_type_code"] != DBNull.Value)
            objRoyaltyCommissionDetails.CommissionTypeCode = Convert.ToInt32(dRow["commission_type_code"]);
        objRoyaltyCommissionDetails.AddSubtract = Convert.ToString(dRow["add_subtract"]);
        if (dRow["position"] != DBNull.Value)
        objRoyaltyCommissionDetails.Position = Convert.ToInt32(dRow["position"]);
        #endregion
        return objRoyaltyCommissionDetails;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        RoyaltyCommissionDetails objRoyaltyCommissionDetails = (RoyaltyCommissionDetails)obj;
        return "insert into [Royalty_Commission_Details]([royalty_commission_code], [commission_type], [commission_type_code], [add_subtract],[position]) values(" + objRoyaltyCommissionDetails.RoyaltyCommissionCode + ", '" + objRoyaltyCommissionDetails.CommissionType.Trim().Replace("'", "''") + "', " + objRoyaltyCommissionDetails.CommissionTypeCode + ", '" + objRoyaltyCommissionDetails.AddSubtract.Trim().Replace("'", "''") + "',"+objRoyaltyCommissionDetails.Position+");";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        RoyaltyCommissionDetails objRoyaltyCommissionDetails = (RoyaltyCommissionDetails)obj;
        return "update [Royalty_Commission_Details] set [royalty_commission_code] = '" + objRoyaltyCommissionDetails.RoyaltyCommissionCode + "', [commission_type] = '" + objRoyaltyCommissionDetails.CommissionType.Trim().Replace("'", "''") + "', [commission_type_code] = '" + objRoyaltyCommissionDetails.CommissionTypeCode + "', [add_subtract] = '" + objRoyaltyCommissionDetails.AddSubtract.Trim().Replace("'", "''") + "',[position]="+objRoyaltyCommissionDetails.Position+" where royalty_commission_details_code = '" + objRoyaltyCommissionDetails.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        RoyaltyCommissionDetails objRoyaltyCommissionDetails = (RoyaltyCommissionDetails)obj;

        return " DELETE FROM [Royalty_Commission_Details] WHERE royalty_commission_details_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        RoyaltyCommissionDetails objRoyaltyCommissionDetails = (RoyaltyCommissionDetails)obj;
        return "Update [Royalty_Commission_Details] set Is_Active='" + objRoyaltyCommissionDetails.Is_Active + "',lock_time=null, last_updated_time= getdate() where royalty_commission_details_code = '" + objRoyaltyCommissionDetails.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Royalty_Commission_Details] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Royalty_Commission_Details] WHERE  royalty_commission_details_code = " + obj.IntCode;
    }

    public DataSet getCostType(int intcode)
    {
       // string sql = "select cost_type_code,cost_type_name,'C'costtype  from Cost_Type  where is_active='Y' "
          //  +" union "
           // + "select additional_expense_code,additional_expense_name,'A'costtype  from Additional_Expense where is_active='Y'";
        string sql = " select * from ("
+ "select c.cost_type_code,c.cost_type_name,'C'costtype,rcd.royalty_commission_details_code,rcd.royalty_commission_code,rcd.position from Cost_Type  c "
+ "left join Royalty_Commission_Details rcd on rcd.commission_type_code=c.cost_type_code "
+ "and rcd.commission_type='C' and rcd.royalty_commission_code= "+intcode
+ "where (is_active='Y' or rcd.royalty_commission_details_code>0)"
+ "union "
+ "select a.additional_expense_code,a.additional_expense_name,'A'costtype,rcd.royalty_commission_details_code,rcd.royalty_commission_code,rcd.position from Additional_Expense a "
+ "left join Royalty_Commission_Details rcd on rcd.commission_type_code=a.additional_expense_code "
+ "and rcd.commission_type='A' and rcd.royalty_commission_code="+intcode
+ " where (is_active='Y' or rcd.royalty_commission_details_code>0)"
+ ") as a "
  + "order by isnull(royalty_commission_details_code,'99999'),cost_type_name";

        DataSet ds = ProcessSelect(sql);
        
        return ds;
    }

}
