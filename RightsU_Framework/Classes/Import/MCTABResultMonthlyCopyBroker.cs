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
/// Summary description for MCTABResultMonthlyCopy
/// </summary>
public class MCTABResultMonthlyCopyBroker : DatabaseBroker
{
	public MCTABResultMonthlyCopyBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [MC_TAB_Result_Monthly_Copy] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MCTABResultMonthlyCopy objMCTABResultMonthlyCopy;
		if (obj == null)
		{
			objMCTABResultMonthlyCopy = new MCTABResultMonthlyCopy();
		}
		else
		{
			objMCTABResultMonthlyCopy = (MCTABResultMonthlyCopy)obj;
		}

		objMCTABResultMonthlyCopy.IntCode = Convert.ToInt32(dRow["mc_tab_result_monthly_copy_code"]);
		#region --populate--
		objMCTABResultMonthlyCopy.MonthYear = Convert.ToString(dRow["Month_Year"]);
		objMCTABResultMonthlyCopy.TitleID = Convert.ToString(dRow["TitleID"]);
		objMCTABResultMonthlyCopy.TitleName = Convert.ToString(dRow["TitleName"]);
		objMCTABResultMonthlyCopy.MasterFormat = Convert.ToString(dRow["MasterFormat"]);
		objMCTABResultMonthlyCopy.ShowbizzFormat = Convert.ToString(dRow["ShowbizzFormat"]);
		if (dRow["MRP"] != DBNull.Value)
			objMCTABResultMonthlyCopy.MRP = Convert.ToDecimal(dRow["MRP"]);
		objMCTABResultMonthlyCopy.ReleaseDate = Convert.ToString(dRow["ReleaseDate"]);
		objMCTABResultMonthlyCopy.RightsExpiry = Convert.ToString(dRow["RightsExpiry"]);
		objMCTABResultMonthlyCopy.Classification = Convert.ToString(dRow["Classification"]);
		objMCTABResultMonthlyCopy.Banner = Convert.ToString(dRow["Banner"]);
		objMCTABResultMonthlyCopy.Dubbed = Convert.ToString(dRow["Dubbed"]);
		objMCTABResultMonthlyCopy.Language = Convert.ToString(dRow["Language"]);
		objMCTABResultMonthlyCopy.Genre = Convert.ToString(dRow["Genre"]);
		objMCTABResultMonthlyCopy.Grade = Convert.ToString(dRow["Grade"]);
		objMCTABResultMonthlyCopy.Zone = Convert.ToString(dRow["Zone"]);
		objMCTABResultMonthlyCopy.FilmType = Convert.ToString(dRow["FilmType"]);
		if (dRow["SAPInternalOrder"] != DBNull.Value)
			objMCTABResultMonthlyCopy.SAPInternalOrder = Convert.ToDecimal(dRow["SAPInternalOrder"]);
		objMCTABResultMonthlyCopy.BoxSetIndicator = Convert.ToString(dRow["Box_Set_Indicator"]);
		if (dRow["Op_Qty"] != DBNull.Value)
			objMCTABResultMonthlyCopy.OpQty = Convert.ToDecimal(dRow["Op_Qty"]);
		if (dRow["Op_Rate"] != DBNull.Value)
			objMCTABResultMonthlyCopy.OpRate = Convert.ToSingle(dRow["Op_Rate"]);
		if (dRow["Op_Value"] != DBNull.Value)
			objMCTABResultMonthlyCopy.OpValue = Convert.ToSingle(dRow["Op_Value"]);
		if (dRow["Op_Amt_Devalued"] != DBNull.Value)
			objMCTABResultMonthlyCopy.OpAmtDevalued = Convert.ToSingle(dRow["Op_Amt_Devalued"]);
		if (dRow["Op_Value_after_Devaluation"] != DBNull.Value)
			objMCTABResultMonthlyCopy.OpValueAfterDevaluation = Convert.ToSingle(dRow["Op_Value_after_Devaluation"]);
		if (dRow["FG_Purchase_Qty"] != DBNull.Value)
			objMCTABResultMonthlyCopy.FGPurchaseQty = Convert.ToDecimal(dRow["FG_Purchase_Qty"]);
		if (dRow["FG_Purchase_Rate"] != DBNull.Value)
			objMCTABResultMonthlyCopy.FGPurchaseRate = Convert.ToSingle(dRow["FG_Purchase_Rate"]);
		if (dRow["FG_Purchase_Value"] != DBNull.Value)
			objMCTABResultMonthlyCopy.FGPurchaseValue = Convert.ToSingle(dRow["FG_Purchase_Value"]);
		if (dRow["RM_Value"] != DBNull.Value)
			objMCTABResultMonthlyCopy.RMValue = Convert.ToSingle(dRow["RM_Value"]);
		if (dRow["StamperCost"] != DBNull.Value)
			objMCTABResultMonthlyCopy.StamperCost = Convert.ToSingle(dRow["StamperCost"]);
		if (dRow["DomSaleQty"] != DBNull.Value)
			objMCTABResultMonthlyCopy.DomSaleQty = Convert.ToDecimal(dRow["DomSaleQty"]);
		if (dRow["DomSaleRate"] != DBNull.Value)
			objMCTABResultMonthlyCopy.DomSaleRate = Convert.ToSingle(dRow["DomSaleRate"]);
		if (dRow["DomSaleValue"] != DBNull.Value)
			objMCTABResultMonthlyCopy.DomSaleValue = Convert.ToSingle(dRow["DomSaleValue"]);
		if (dRow["ExpSaleQty"] != DBNull.Value)
			objMCTABResultMonthlyCopy.ExpSaleQty = Convert.ToDecimal(dRow["ExpSaleQty"]);
		if (dRow["ExpSaleRate"] != DBNull.Value)
			objMCTABResultMonthlyCopy.ExpSaleRate = Convert.ToSingle(dRow["ExpSaleRate"]);
		if (dRow["ExpSaleValue"] != DBNull.Value)
			objMCTABResultMonthlyCopy.ExpSaleValue = Convert.ToSingle(dRow["ExpSaleValue"]);
		if (dRow["SalesReturnQty"] != DBNull.Value)
			objMCTABResultMonthlyCopy.SalesReturnQty = Convert.ToDecimal(dRow["SalesReturnQty"]);
		if (dRow["NetSalesQty"] != DBNull.Value)
			objMCTABResultMonthlyCopy.NetSalesQty = Convert.ToDecimal(dRow["NetSalesQty"]);
		if (dRow["NetSalesRate"] != DBNull.Value)
			objMCTABResultMonthlyCopy.NetSalesRate = Convert.ToSingle(dRow["NetSalesRate"]);
		if (dRow["NetSalesValue"] != DBNull.Value)
			objMCTABResultMonthlyCopy.NetSalesValue = Convert.ToSingle(dRow["NetSalesValue"]);
		if (dRow["FreeSampleValue"] != DBNull.Value)
			objMCTABResultMonthlyCopy.FreeSampleValue = Convert.ToSingle(dRow["FreeSampleValue"]);
		if (dRow["FreeSampleQty"] != DBNull.Value)
			objMCTABResultMonthlyCopy.FreeSampleQty = Convert.ToDecimal(dRow["FreeSampleQty"]);
		if (dRow["DevaluedStockRate"] != DBNull.Value)
			objMCTABResultMonthlyCopy.DevaluedStockRate = Convert.ToSingle(dRow["DevaluedStockRate"]);
		if (dRow["Sale_Return_Value"] != DBNull.Value)
			objMCTABResultMonthlyCopy.SaleReturnValue = Convert.ToSingle(dRow["Sale_Return_Value"]);
		if (dRow["Sale_Credit_Note_Value"] != DBNull.Value)
			objMCTABResultMonthlyCopy.SaleCreditNoteValue = Convert.ToSingle(dRow["Sale_Credit_Note_Value"]);
		if (dRow["Sale_Debit_Note_Value"] != DBNull.Value)
			objMCTABResultMonthlyCopy.SaleDebitNoteValue = Convert.ToSingle(dRow["Sale_Debit_Note_Value"]);
		if (dRow["Cl_Stock_Qty"] != DBNull.Value)
			objMCTABResultMonthlyCopy.ClStockQty = Convert.ToDecimal(dRow["Cl_Stock_Qty"]);
		if (dRow["Stk_In_Spindle"] != DBNull.Value)
			objMCTABResultMonthlyCopy.StkInSpindle = Convert.ToDecimal(dRow["Stk_In_Spindle"]);
		if (dRow["Stk_In_Transit"] != DBNull.Value)
			objMCTABResultMonthlyCopy.StkInTransit = Convert.ToDecimal(dRow["Stk_In_Transit"]);
		if (dRow["RP_Out_Qty"] != DBNull.Value)
			objMCTABResultMonthlyCopy.RPOutQty = Convert.ToDecimal(dRow["RP_Out_Qty"]);
		if (dRow["RP_In_Qty"] != DBNull.Value)
			objMCTABResultMonthlyCopy.RPInQty = Convert.ToDecimal(dRow["RP_In_Qty"]);
		if (dRow["external_title_code"] != DBNull.Value)
			objMCTABResultMonthlyCopy.ExternalTitleCode = Convert.ToInt32(dRow["external_title_code"]);
		objMCTABResultMonthlyCopy.IsError = Convert.ToString(dRow["is_error"]);
		#endregion
		return objMCTABResultMonthlyCopy;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		MCTABResultMonthlyCopy objMCTABResultMonthlyCopy = (MCTABResultMonthlyCopy)obj;
		return "insert into [MC_TAB_Result_Monthly_Copy]([Month_Year], [TitleID], [TitleName], [MasterFormat], [ShowbizzFormat], [MRP], [ReleaseDate], [RightsExpiry], [Classification], [Banner], [Dubbed], [Language], [Genre], [Grade], [Zone], [FilmType], [SAPInternalOrder], [Box_Set_Indicator], [Op_Qty], [Op_Rate], [Op_Value], [Op_Amt_Devalued], [Op_Value_after_Devaluation], [FG_Purchase_Qty], [FG_Purchase_Rate], [FG_Purchase_Value], [RM_Value], [StamperCost], [DomSaleQty], [DomSaleRate], [DomSaleValue], [ExpSaleQty], [ExpSaleRate], [ExpSaleValue], [SalesReturnQty], [NetSalesQty], [NetSalesRate], [NetSalesValue], [FreeSampleValue], [FreeSampleQty], [DevaluedStockRate], [Sale_Return_Value], [Sale_Credit_Note_Value], [Sale_Debit_Note_Value], [Cl_Stock_Qty], [Stk_In_Spindle], [Stk_In_Transit], [RP_Out_Qty], [RP_In_Qty], [external_title_code], [is_error]) values('" + objMCTABResultMonthlyCopy.MonthYear.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.TitleID.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.TitleName.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.MasterFormat.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.ShowbizzFormat.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.MRP + "', '" + objMCTABResultMonthlyCopy.ReleaseDate.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.RightsExpiry.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.Classification.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.Banner.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.Dubbed.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.Language.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.Genre.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.Grade.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.Zone.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.FilmType.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.SAPInternalOrder + "', '" + objMCTABResultMonthlyCopy.BoxSetIndicator.Trim().Replace("'", "''") + "', '" + objMCTABResultMonthlyCopy.OpQty + "', '" + objMCTABResultMonthlyCopy.OpRate + "', '" + objMCTABResultMonthlyCopy.OpValue + "', '" + objMCTABResultMonthlyCopy.OpAmtDevalued + "', '" + objMCTABResultMonthlyCopy.OpValueAfterDevaluation + "', '" + objMCTABResultMonthlyCopy.FGPurchaseQty + "', '" + objMCTABResultMonthlyCopy.FGPurchaseRate + "', '" + objMCTABResultMonthlyCopy.FGPurchaseValue + "', '" + objMCTABResultMonthlyCopy.RMValue + "', '" + objMCTABResultMonthlyCopy.StamperCost + "', '" + objMCTABResultMonthlyCopy.DomSaleQty + "', '" + objMCTABResultMonthlyCopy.DomSaleRate + "', '" + objMCTABResultMonthlyCopy.DomSaleValue + "', '" + objMCTABResultMonthlyCopy.ExpSaleQty + "', '" + objMCTABResultMonthlyCopy.ExpSaleRate + "', '" + objMCTABResultMonthlyCopy.ExpSaleValue + "', '" + objMCTABResultMonthlyCopy.SalesReturnQty + "', '" + objMCTABResultMonthlyCopy.NetSalesQty + "', '" + objMCTABResultMonthlyCopy.NetSalesRate + "', '" + objMCTABResultMonthlyCopy.NetSalesValue + "', '" + objMCTABResultMonthlyCopy.FreeSampleValue + "', '" + objMCTABResultMonthlyCopy.FreeSampleQty + "', '" + objMCTABResultMonthlyCopy.DevaluedStockRate + "', '" + objMCTABResultMonthlyCopy.SaleReturnValue + "', '" + objMCTABResultMonthlyCopy.SaleCreditNoteValue + "', '" + objMCTABResultMonthlyCopy.SaleDebitNoteValue + "', '" + objMCTABResultMonthlyCopy.ClStockQty + "', '" + objMCTABResultMonthlyCopy.StkInSpindle + "', '" + objMCTABResultMonthlyCopy.StkInTransit + "', '" + objMCTABResultMonthlyCopy.RPOutQty + "', '" + objMCTABResultMonthlyCopy.RPInQty + "', '" + objMCTABResultMonthlyCopy.ExternalTitleCode + "', '" + objMCTABResultMonthlyCopy.IsError.Trim().Replace("'", "''") + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		MCTABResultMonthlyCopy objMCTABResultMonthlyCopy = (MCTABResultMonthlyCopy)obj;
		return "update [MC_TAB_Result_Monthly_Copy] set [Month_Year] = '" + objMCTABResultMonthlyCopy.MonthYear.Trim().Replace("'", "''") + "', [TitleID] = '" + objMCTABResultMonthlyCopy.TitleID.Trim().Replace("'", "''") + "', [TitleName] = '" + objMCTABResultMonthlyCopy.TitleName.Trim().Replace("'", "''") + "', [MasterFormat] = '" + objMCTABResultMonthlyCopy.MasterFormat.Trim().Replace("'", "''") + "', [ShowbizzFormat] = '" + objMCTABResultMonthlyCopy.ShowbizzFormat.Trim().Replace("'", "''") + "', [MRP] = '" + objMCTABResultMonthlyCopy.MRP + "', [ReleaseDate] = '" + objMCTABResultMonthlyCopy.ReleaseDate.Trim().Replace("'", "''") + "', [RightsExpiry] = '" + objMCTABResultMonthlyCopy.RightsExpiry.Trim().Replace("'", "''") + "', [Classification] = '" + objMCTABResultMonthlyCopy.Classification.Trim().Replace("'", "''") + "', [Banner] = '" + objMCTABResultMonthlyCopy.Banner.Trim().Replace("'", "''") + "', [Dubbed] = '" + objMCTABResultMonthlyCopy.Dubbed.Trim().Replace("'", "''") + "', [Language] = '" + objMCTABResultMonthlyCopy.Language.Trim().Replace("'", "''") + "', [Genre] = '" + objMCTABResultMonthlyCopy.Genre.Trim().Replace("'", "''") + "', [Grade] = '" + objMCTABResultMonthlyCopy.Grade.Trim().Replace("'", "''") + "', [Zone] = '" + objMCTABResultMonthlyCopy.Zone.Trim().Replace("'", "''") + "', [FilmType] = '" + objMCTABResultMonthlyCopy.FilmType.Trim().Replace("'", "''") + "', [SAPInternalOrder] = '" + objMCTABResultMonthlyCopy.SAPInternalOrder + "', [Box_Set_Indicator] = '" + objMCTABResultMonthlyCopy.BoxSetIndicator.Trim().Replace("'", "''") + "', [Op_Qty] = '" + objMCTABResultMonthlyCopy.OpQty + "', [Op_Rate] = '" + objMCTABResultMonthlyCopy.OpRate + "', [Op_Value] = '" + objMCTABResultMonthlyCopy.OpValue + "', [Op_Amt_Devalued] = '" + objMCTABResultMonthlyCopy.OpAmtDevalued + "', [Op_Value_after_Devaluation] = '" + objMCTABResultMonthlyCopy.OpValueAfterDevaluation + "', [FG_Purchase_Qty] = '" + objMCTABResultMonthlyCopy.FGPurchaseQty + "', [FG_Purchase_Rate] = '" + objMCTABResultMonthlyCopy.FGPurchaseRate + "', [FG_Purchase_Value] = '" + objMCTABResultMonthlyCopy.FGPurchaseValue + "', [RM_Value] = '" + objMCTABResultMonthlyCopy.RMValue + "', [StamperCost] = '" + objMCTABResultMonthlyCopy.StamperCost + "', [DomSaleQty] = '" + objMCTABResultMonthlyCopy.DomSaleQty + "', [DomSaleRate] = '" + objMCTABResultMonthlyCopy.DomSaleRate + "', [DomSaleValue] = '" + objMCTABResultMonthlyCopy.DomSaleValue + "', [ExpSaleQty] = '" + objMCTABResultMonthlyCopy.ExpSaleQty + "', [ExpSaleRate] = '" + objMCTABResultMonthlyCopy.ExpSaleRate + "', [ExpSaleValue] = '" + objMCTABResultMonthlyCopy.ExpSaleValue + "', [SalesReturnQty] = '" + objMCTABResultMonthlyCopy.SalesReturnQty + "', [NetSalesQty] = '" + objMCTABResultMonthlyCopy.NetSalesQty + "', [NetSalesRate] = '" + objMCTABResultMonthlyCopy.NetSalesRate + "', [NetSalesValue] = '" + objMCTABResultMonthlyCopy.NetSalesValue + "', [FreeSampleValue] = '" + objMCTABResultMonthlyCopy.FreeSampleValue + "', [FreeSampleQty] = '" + objMCTABResultMonthlyCopy.FreeSampleQty + "', [DevaluedStockRate] = '" + objMCTABResultMonthlyCopy.DevaluedStockRate + "', [Sale_Return_Value] = '" + objMCTABResultMonthlyCopy.SaleReturnValue + "', [Sale_Credit_Note_Value] = '" + objMCTABResultMonthlyCopy.SaleCreditNoteValue + "', [Sale_Debit_Note_Value] = '" + objMCTABResultMonthlyCopy.SaleDebitNoteValue + "', [Cl_Stock_Qty] = '" + objMCTABResultMonthlyCopy.ClStockQty + "', [Stk_In_Spindle] = '" + objMCTABResultMonthlyCopy.StkInSpindle + "', [Stk_In_Transit] = '" + objMCTABResultMonthlyCopy.StkInTransit + "', [RP_Out_Qty] = '" + objMCTABResultMonthlyCopy.RPOutQty + "', [RP_In_Qty] = '" + objMCTABResultMonthlyCopy.RPInQty + "', [external_title_code] = '" + objMCTABResultMonthlyCopy.ExternalTitleCode + "', [is_error] = '" + objMCTABResultMonthlyCopy.IsError.Trim().Replace("'", "''") + "' where mc_tab_result_monthly_copy_code = '" + objMCTABResultMonthlyCopy.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		MCTABResultMonthlyCopy objMCTABResultMonthlyCopy = (MCTABResultMonthlyCopy)obj;

		return " DELETE FROM [MC_TAB_Result_Monthly_Copy] WHERE mc_tab_result_monthly_copy_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        MCTABResultMonthlyCopy objMCTABResultMonthlyCopy = (MCTABResultMonthlyCopy)obj;
return "Update [MC_TAB_Result_Monthly_Copy] set Is_Active='" + objMCTABResultMonthlyCopy.Is_Active + "',lock_time=null, last_updated_time= getdate() where mc_tab_result_monthly_copy_code = '" + objMCTABResultMonthlyCopy.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [MC_TAB_Result_Monthly_Copy] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [MC_TAB_Result_Monthly_Copy] WHERE  mc_tab_result_monthly_copy_code = " + obj.IntCode;
    }  
}
