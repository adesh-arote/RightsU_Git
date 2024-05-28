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
/// Summary description for DealType
/// </summary>
public class DealTypeBroker : DatabaseBroker
{
	public DealTypeBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [deal_type] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        DealType objDealType;
		if (obj == null)
		{
			objDealType = new DealType();
		}
		else
		{
			objDealType = (DealType)obj;
		}

        objDealType.DealTypeCode = Convert.ToInt32(dRow["deal_type_code"]);
		objDealType.IntCode = Convert.ToInt32(dRow["deal_type_code"]);        
        
		#region --populate--
		objDealType.DealTypeName = Convert.ToString(dRow["deal_type_name"]);
		objDealType.IsDefault = Convert.ToString(dRow["is_default"]);
        objDealType.IsGridRequired = Convert.ToString(dRow["is_grid_required"]);
		if (dRow["Inserted_On"] != DBNull.Value)
            objDealType.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
		if (dRow["Inserted_By"] != DBNull.Value)
			objDealType.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
		if (dRow["Lock_Time"] != DBNull.Value)
            objDealType.LockTime = Convert.ToString(dRow["Lock_Time"]);
		if (dRow["Last_Updated_Time"] != DBNull.Value)
            objDealType.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
		if (dRow["Last_Action_By"] != DBNull.Value)
			objDealType.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objDealType.IsActive = Convert.ToString(dRow["Is_Active"]);
        if (dRow["is_master_deal"] != DBNull.Value)
            objDealType.IsMasterDeal = Convert.ToString(dRow["is_master_deal"]);

        if (dRow["Deal_Or_Title"] != DBNull.Value)
            objDealType.Deal_Or_Title = Convert.ToString(dRow["Deal_Or_Title"]);
        if (dRow["Parent_Code"] != DBNull.Value)
            objDealType.ParentCode = Convert.ToInt32(dRow["Parent_Code"]);
		#endregion
		return objDealType;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		DealType objDealType = (DealType)obj;
		return "insert into [deal_type]([deal_type_name], [is_default], [is_grid_required], [Inserted_On], [Inserted_By], [Lock_Time], [Last_Updated_Time], [Last_Action_By], [Is_Active]) values('" + objDealType.DealTypeName.Trim().Replace("'", "''") + "', '" + objDealType.IsDefault + "', '" + objDealType.IsGridRequired + "', GetDate(), '" + objDealType.InsertedBy + "',  Null, GetDate(), '" + objDealType.InsertedBy + "', '" + objDealType.IsActive + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		DealType objDealType = (DealType)obj;
		return "update [deal_type] set [deal_type_name] = '" + objDealType.DealTypeName.Trim().Replace("'", "''") + "', [is_default] = '" + objDealType.IsDefault + "', [is_grid_required] = '" + objDealType.IsGridRequired + "', [Lock_Time] = Null, [Last_Updated_Time] = GetDate(), [Last_Action_By] = '" + objDealType.LastActionBy + "', [Is_Active] = '" + objDealType.IsActive + "' where deal_type_code = '" + objDealType.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		DealType objDealType = (DealType)obj;

		return " DELETE FROM [deal_type] WHERE deal_type_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [deal_type] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [deal_type] WHERE  deal_type_code = " + obj.IntCode;
    }  
}
