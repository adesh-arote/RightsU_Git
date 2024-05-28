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
/// Summary description for MCTABResultYearlyCopy
/// </summary>
public class MCTABResultYearlyCopyBroker : DatabaseBroker
{
	public MCTABResultYearlyCopyBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [MC_TAB_Result_Yearly_Copy] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        MCTABResultYearlyCopy objMCTABResultYearlyCopy;
		if (obj == null)
		{
			objMCTABResultYearlyCopy = new MCTABResultYearlyCopy();
		}
		else
		{
			objMCTABResultYearlyCopy = (MCTABResultYearlyCopy)obj;
		}

		objMCTABResultYearlyCopy.IntCode = Convert.ToInt32(dRow["mc_tab_result_yearly_copy_code"]);
		#region --populate--
		objMCTABResultYearlyCopy.MonthYear = Convert.ToString(dRow["Month_Year"]);
		objMCTABResultYearlyCopy.TitleId = Convert.ToString(dRow["TitleId"]);
		objMCTABResultYearlyCopy.TitleName = Convert.ToString(dRow["TitleName"]);
		objMCTABResultYearlyCopy.ShowbizzFormat = Convert.ToString(dRow["ShowbizzFormat"]);
		objMCTABResultYearlyCopy.MasterFormat = Convert.ToString(dRow["MasterFormat"]);
		if (dRow["MRP"] != DBNull.Value)
			objMCTABResultYearlyCopy.MRP = Convert.ToDecimal(dRow["MRP"]);
		objMCTABResultYearlyCopy.ReleaseDate = Convert.ToString(dRow["ReleaseDate"]);
		objMCTABResultYearlyCopy.RightsExpiry = Convert.ToString(dRow["RightsExpiry"]);
		objMCTABResultYearlyCopy.Classification = Convert.ToString(dRow["Classification"]);
		objMCTABResultYearlyCopy.Banner = Convert.ToString(dRow["Banner"]);
		objMCTABResultYearlyCopy.Dubbed = Convert.ToString(dRow["Dubbed"]);
		objMCTABResultYearlyCopy.Language = Convert.ToString(dRow["Language"]);
		objMCTABResultYearlyCopy.Genre = Convert.ToString(dRow["Genre"]);
		objMCTABResultYearlyCopy.Grade = Convert.ToString(dRow["Grade"]);
		objMCTABResultYearlyCopy.Zone = Convert.ToString(dRow["Zone"]);
		objMCTABResultYearlyCopy.FilmType = Convert.ToString(dRow["FilmType"]);
		if (dRow["SAPInternalOrder"] != DBNull.Value)
			objMCTABResultYearlyCopy.SAPInternalOrder = Convert.ToDecimal(dRow["SAPInternalOrder"]);
		objMCTABResultYearlyCopy.BoxSetIndicator = Convert.ToString(dRow["Box_Set_Indicator"]);
		if (dRow["Op_Qty"] != DBNull.Value)
			objMCTABResultYearlyCopy.OpQty = Convert.ToDecimal(dRow["Op_Qty"]);
		if (dRow["Op_Rate"] != DBNull.Value)
			objMCTABResultYearlyCopy.OpRate = Convert.ToSingle(dRow["Op_Rate"]);
		if (dRow["Op_Value"] != DBNull.Value)
			objMCTABResultYearlyCopy.OpValue = Convert.ToSingle(dRow["Op_Value"]);
		if (dRow["Op_Amt_Devalued"] != DBNull.Value)
			objMCTABResultYearlyCopy.OpAmtDevalued = Convert.ToSingle(dRow["Op_Amt_Devalued"]);
		if (dRow["Op_Value_After_Devaluation"] != DBNull.Value)
			objMCTABResultYearlyCopy.OpValueAfterDevaluation = Convert.ToSingle(dRow["Op_Value_After_Devaluation"]);
		if (dRow["FG_Purchase_Qty"] != DBNull.Value)
			objMCTABResultYearlyCopy.FGPurchaseQty = Convert.ToDecimal(dRow["FG_Purchase_Qty"]);
		if (dRow["FG_Purchase_Rate"] != DBNull.Value)
			objMCTABResultYearlyCopy.FGPurchaseRate = Convert.ToSingle(dRow["FG_Purchase_Rate"]);
		if (dRow["FG_Purchase_Value"] != DBNull.Value)
			objMCTABResultYearlyCopy.FGPurchaseValue = Convert.ToSingle(dRow["FG_Purchase_Value"]);
		if (dRow["RM_Value"] != DBNull.Value)
			objMCTABResultYearlyCopy.RMValue = Convert.ToSingle(dRow["RM_Value"]);
		if (dRow["Total_Pur_Qty"] != DBNull.Value)
			objMCTABResultYearlyCopy.TotalPurQty = Convert.ToDecimal(dRow["Total_Pur_Qty"]);
		if (dRow["Total_Pur_Rate"] != DBNull.Value)
			objMCTABResultYearlyCopy.TotalPurRate = Convert.ToSingle(dRow["Total_Pur_Rate"]);
		if (dRow["Total_Pur_Cost_Value"] != DBNull.Value)
			objMCTABResultYearlyCopy.TotalPurCostValue = Convert.ToSingle(dRow["Total_Pur_Cost_Value"]);
		if (dRow["RP_Out_Qty"] != DBNull.Value)
			objMCTABResultYearlyCopy.RPOutQty = Convert.ToDecimal(dRow["RP_Out_Qty"]);
		if (dRow["RP_Out_Rate"] != DBNull.Value)
			objMCTABResultYearlyCopy.RPOutRate = Convert.ToSingle(dRow["RP_Out_Rate"]);
		if (dRow["RP_Out_Value"] != DBNull.Value)
			objMCTABResultYearlyCopy.RPOutValue = Convert.ToSingle(dRow["RP_Out_Value"]);
		if (dRow["RP_In_Qty"] != DBNull.Value)
			objMCTABResultYearlyCopy.RPInQty = Convert.ToDecimal(dRow["RP_In_Qty"]);
		if (dRow["RP_In_Rate"] != DBNull.Value)
			objMCTABResultYearlyCopy.RPInRate = Convert.ToSingle(dRow["RP_In_Rate"]);
		if (dRow["RP_In_Value"] != DBNull.Value)
			objMCTABResultYearlyCopy.RPInValue = Convert.ToSingle(dRow["RP_In_Value"]);
		if (dRow["RepackersStkQty"] != DBNull.Value)
			objMCTABResultYearlyCopy.RepackersStkQty = Convert.ToDecimal(dRow["RepackersStkQty"]);
		if (dRow["RepackersStkRate"] != DBNull.Value)
			objMCTABResultYearlyCopy.RepackersStkRate = Convert.ToSingle(dRow["RepackersStkRate"]);
		if (dRow["RepackersStkValue"] != DBNull.Value)
			objMCTABResultYearlyCopy.RepackersStkValue = Convert.ToSingle(dRow["RepackersStkValue"]);
		if (dRow["TotalMaterialQty"] != DBNull.Value)
			objMCTABResultYearlyCopy.TotalMaterialQty = Convert.ToDecimal(dRow["TotalMaterialQty"]);
		if (dRow["TotalMaterialRate"] != DBNull.Value)
			objMCTABResultYearlyCopy.TotalMaterialRate = Convert.ToSingle(dRow["TotalMaterialRate"]);
		if (dRow["TotalMaterialValue"] != DBNull.Value)
			objMCTABResultYearlyCopy.TotalMaterialValue = Convert.ToSingle(dRow["TotalMaterialValue"]);
		if (dRow["StamperCost"] != DBNull.Value)
			objMCTABResultYearlyCopy.StamperCost = Convert.ToSingle(dRow["StamperCost"]);
		if (dRow["DomSaleQty"] != DBNull.Value)
			objMCTABResultYearlyCopy.DomSaleQty = Convert.ToDecimal(dRow["DomSaleQty"]);
		if (dRow["DomSaleRate"] != DBNull.Value)
			objMCTABResultYearlyCopy.DomSaleRate = Convert.ToSingle(dRow["DomSaleRate"]);
		if (dRow["DomSaleValue"] != DBNull.Value)
			objMCTABResultYearlyCopy.DomSaleValue = Convert.ToSingle(dRow["DomSaleValue"]);
		if (dRow["ExpSaleQty"] != DBNull.Value)
			objMCTABResultYearlyCopy.ExpSaleQty = Convert.ToDecimal(dRow["ExpSaleQty"]);
		if (dRow["ExpSaleRate"] != DBNull.Value)
			objMCTABResultYearlyCopy.ExpSaleRate = Convert.ToSingle(dRow["ExpSaleRate"]);
		if (dRow["ExpSaleValue"] != DBNull.Value)
			objMCTABResultYearlyCopy.ExpSaleValue = Convert.ToSingle(dRow["ExpSaleValue"]);
		if (dRow["SalesReturnQty"] != DBNull.Value)
			objMCTABResultYearlyCopy.SalesReturnQty = Convert.ToDecimal(dRow["SalesReturnQty"]);
		if (dRow["Sale_Return_Value"] != DBNull.Value)
			objMCTABResultYearlyCopy.SaleReturnValue = Convert.ToSingle(dRow["Sale_Return_Value"]);
		if (dRow["Sale_Credit_Note_Value"] != DBNull.Value)
			objMCTABResultYearlyCopy.SaleCreditNoteValue = Convert.ToSingle(dRow["Sale_Credit_Note_Value"]);
		if (dRow["Sale_Debit_Note_Value"] != DBNull.Value)
			objMCTABResultYearlyCopy.SaleDebitNoteValue = Convert.ToSingle(dRow["Sale_Debit_Note_Value"]);
		if (dRow["Pur_Credit_Note_Value"] != DBNull.Value)
			objMCTABResultYearlyCopy.PurCreditNoteValue = Convert.ToSingle(dRow["Pur_Credit_Note_Value"]);
		if (dRow["Pur_Debit_Note_Value"] != DBNull.Value)
			objMCTABResultYearlyCopy.PurDebitNoteValue = Convert.ToSingle(dRow["Pur_Debit_Note_Value"]);
		if (dRow["NetSalesQty"] != DBNull.Value)
			objMCTABResultYearlyCopy.NetSalesQty = Convert.ToDecimal(dRow["NetSalesQty"]);
		if (dRow["NetSalesRate"] != DBNull.Value)
			objMCTABResultYearlyCopy.NetSalesRate = Convert.ToSingle(dRow["NetSalesRate"]);
		if (dRow["NetSalesValue"] != DBNull.Value)
			objMCTABResultYearlyCopy.NetSalesValue = Convert.ToSingle(dRow["NetSalesValue"]);
		if (dRow["MatConsQty"] != DBNull.Value)
			objMCTABResultYearlyCopy.MatConsQty = Convert.ToDecimal(dRow["MatConsQty"]);
		if (dRow["MatConsRate"] != DBNull.Value)
			objMCTABResultYearlyCopy.MatConsRate = Convert.ToSingle(dRow["MatConsRate"]);
		if (dRow["MatConsValue"] != DBNull.Value)
			objMCTABResultYearlyCopy.MatConsValue = Convert.ToSingle(dRow["MatConsValue"]);
		if (dRow["ContnwoDistn"] != DBNull.Value)
			objMCTABResultYearlyCopy.ContnwoDistn = Convert.ToSingle(dRow["ContnwoDistn"]);
		if (dRow["ContnwoDistnPercent"] != DBNull.Value)
			objMCTABResultYearlyCopy.ContnwoDistnPercent = Convert.ToSingle(dRow["ContnwoDistnPercent"]);
		if (dRow["SAPDirectExpense"] != DBNull.Value)
			objMCTABResultYearlyCopy.SAPDirectExpense = Convert.ToSingle(dRow["SAPDirectExpense"]);
		if (dRow["SAPForeignExchange"] != DBNull.Value)
			objMCTABResultYearlyCopy.SAPForeignExchange = Convert.ToSingle(dRow["SAPForeignExchange"]);
		if (dRow["SAPMarketingExp"] != DBNull.Value)
			objMCTABResultYearlyCopy.SAPMarketingExp = Convert.ToSingle(dRow["SAPMarketingExp"]);
		if (dRow["SAPDownloadCost"] != DBNull.Value)
			objMCTABResultYearlyCopy.SAPDownloadCost = Convert.ToSingle(dRow["SAPDownloadCost"]);
		if (dRow["TotalDirectExpense"] != DBNull.Value)
			objMCTABResultYearlyCopy.TotalDirectExpense = Convert.ToSingle(dRow["TotalDirectExpense"]);
		if (dRow["DistriExpense"] != DBNull.Value)
			objMCTABResultYearlyCopy.DistriExpense = Convert.ToSingle(dRow["DistriExpense"]);
		if (dRow["ContnPostDistn"] != DBNull.Value)
			objMCTABResultYearlyCopy.ContnPostDistn = Convert.ToSingle(dRow["ContnPostDistn"]);
		if (dRow["FreeSampleQty"] != DBNull.Value)
			objMCTABResultYearlyCopy.FreeSampleQty = Convert.ToDecimal(dRow["FreeSampleQty"]);
		if (dRow["ClStockQty"] != DBNull.Value)
			objMCTABResultYearlyCopy.ClStockQty = Convert.ToDecimal(dRow["ClStockQty"]);
		if (dRow["StockinTransit"] != DBNull.Value)
			objMCTABResultYearlyCopy.StockinTransit = Convert.ToDecimal(dRow["StockinTransit"]);
		if (dRow["StockwithRep"] != DBNull.Value)
			objMCTABResultYearlyCopy.StockwithRep = Convert.ToDecimal(dRow["StockwithRep"]);
		if (dRow["StockInSpindle"] != DBNull.Value)
			objMCTABResultYearlyCopy.StockInSpindle = Convert.ToDecimal(dRow["StockInSpindle"]);
		if (dRow["TotalClosingstkQty"] != DBNull.Value)
			objMCTABResultYearlyCopy.TotalClosingstkQty = Convert.ToDecimal(dRow["TotalClosingstkQty"]);
		if (dRow["TotalClosingStkRate"] != DBNull.Value)
			objMCTABResultYearlyCopy.TotalClosingStkRate = Convert.ToSingle(dRow["TotalClosingStkRate"]);
		if (dRow["TotalClStockValue"] != DBNull.Value)
			objMCTABResultYearlyCopy.TotalClStockValue = Convert.ToSingle(dRow["TotalClStockValue"]);
		if (dRow["DevaluedStockRate"] != DBNull.Value)
			objMCTABResultYearlyCopy.DevaluedStockRate = Convert.ToSingle(dRow["DevaluedStockRate"]);
		if (dRow["RevisedStkValue"] != DBNull.Value)
			objMCTABResultYearlyCopy.RevisedStkValue = Convert.ToSingle(dRow["RevisedStkValue"]);
		if (dRow["DevaluationAmount"] != DBNull.Value)
			objMCTABResultYearlyCopy.DevaluationAmount = Convert.ToSingle(dRow["DevaluationAmount"]);
		if (dRow["external_title_code"] != DBNull.Value)
			objMCTABResultYearlyCopy.ExternalTitleCode = Convert.ToInt32(dRow["external_title_code"]);
		objMCTABResultYearlyCopy.IsError = Convert.ToString(dRow["is_error"]);
		#endregion
		return objMCTABResultYearlyCopy;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		MCTABResultYearlyCopy objMCTABResultYearlyCopy = (MCTABResultYearlyCopy)obj;
		return "insert into [MC_TAB_Result_Yearly_Copy]([Month_Year], [TitleId], [TitleName], [ShowbizzFormat], [MasterFormat], [MRP], [ReleaseDate], [RightsExpiry], [Classification], [Banner], [Dubbed], [Language], [Genre], [Grade], [Zone], [FilmType], [SAPInternalOrder], [Box_Set_Indicator], [Op_Qty], [Op_Rate], [Op_Value], [Op_Amt_Devalued], [Op_Value_After_Devaluation], [FG_Purchase_Qty], [FG_Purchase_Rate], [FG_Purchase_Value], [RM_Value], [Total_Pur_Qty], [Total_Pur_Rate], [Total_Pur_Cost_Value], [RP_Out_Qty], [RP_Out_Rate], [RP_Out_Value], [RP_In_Qty], [RP_In_Rate], [RP_In_Value], [RepackersStkQty], [RepackersStkRate], [RepackersStkValue], [TotalMaterialQty], [TotalMaterialRate], [TotalMaterialValue], [StamperCost], [DomSaleQty], [DomSaleRate], [DomSaleValue], [ExpSaleQty], [ExpSaleRate], [ExpSaleValue], [SalesReturnQty], [Sale_Return_Value], [Sale_Credit_Note_Value], [Sale_Debit_Note_Value], [Pur_Credit_Note_Value], [Pur_Debit_Note_Value], [NetSalesQty], [NetSalesRate], [NetSalesValue], [MatConsQty], [MatConsRate], [MatConsValue], [ContnwoDistn], [ContnwoDistnPercent], [SAPDirectExpense], [SAPForeignExchange], [SAPMarketingExp], [SAPDownloadCost], [TotalDirectExpense], [DistriExpense], [ContnPostDistn], [FreeSampleQty], [ClStockQty], [StockinTransit], [StockwithRep], [StockInSpindle], [TotalClosingstkQty], [TotalClosingStkRate], [TotalClStockValue], [DevaluedStockRate], [RevisedStkValue], [DevaluationAmount], [external_title_code], [is_error]) values('" + objMCTABResultYearlyCopy.MonthYear.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.TitleId.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.TitleName.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.ShowbizzFormat.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.MasterFormat.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.MRP + "', '" + objMCTABResultYearlyCopy.ReleaseDate.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.RightsExpiry.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.Classification.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.Banner.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.Dubbed.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.Language.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.Genre.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.Grade.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.Zone.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.FilmType.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.SAPInternalOrder + "', '" + objMCTABResultYearlyCopy.BoxSetIndicator.Trim().Replace("'", "''") + "', '" + objMCTABResultYearlyCopy.OpQty + "', '" + objMCTABResultYearlyCopy.OpRate + "', '" + objMCTABResultYearlyCopy.OpValue + "', '" + objMCTABResultYearlyCopy.OpAmtDevalued + "', '" + objMCTABResultYearlyCopy.OpValueAfterDevaluation + "', '" + objMCTABResultYearlyCopy.FGPurchaseQty + "', '" + objMCTABResultYearlyCopy.FGPurchaseRate + "', '" + objMCTABResultYearlyCopy.FGPurchaseValue + "', '" + objMCTABResultYearlyCopy.RMValue + "', '" + objMCTABResultYearlyCopy.TotalPurQty + "', '" + objMCTABResultYearlyCopy.TotalPurRate + "', '" + objMCTABResultYearlyCopy.TotalPurCostValue + "', '" + objMCTABResultYearlyCopy.RPOutQty + "', '" + objMCTABResultYearlyCopy.RPOutRate + "', '" + objMCTABResultYearlyCopy.RPOutValue + "', '" + objMCTABResultYearlyCopy.RPInQty + "', '" + objMCTABResultYearlyCopy.RPInRate + "', '" + objMCTABResultYearlyCopy.RPInValue + "', '" + objMCTABResultYearlyCopy.RepackersStkQty + "', '" + objMCTABResultYearlyCopy.RepackersStkRate + "', '" + objMCTABResultYearlyCopy.RepackersStkValue + "', '" + objMCTABResultYearlyCopy.TotalMaterialQty + "', '" + objMCTABResultYearlyCopy.TotalMaterialRate + "', '" + objMCTABResultYearlyCopy.TotalMaterialValue + "', '" + objMCTABResultYearlyCopy.StamperCost + "', '" + objMCTABResultYearlyCopy.DomSaleQty + "', '" + objMCTABResultYearlyCopy.DomSaleRate + "', '" + objMCTABResultYearlyCopy.DomSaleValue + "', '" + objMCTABResultYearlyCopy.ExpSaleQty + "', '" + objMCTABResultYearlyCopy.ExpSaleRate + "', '" + objMCTABResultYearlyCopy.ExpSaleValue + "', '" + objMCTABResultYearlyCopy.SalesReturnQty + "', '" + objMCTABResultYearlyCopy.SaleReturnValue + "', '" + objMCTABResultYearlyCopy.SaleCreditNoteValue + "', '" + objMCTABResultYearlyCopy.SaleDebitNoteValue + "', '" + objMCTABResultYearlyCopy.PurCreditNoteValue + "', '" + objMCTABResultYearlyCopy.PurDebitNoteValue + "', '" + objMCTABResultYearlyCopy.NetSalesQty + "', '" + objMCTABResultYearlyCopy.NetSalesRate + "', '" + objMCTABResultYearlyCopy.NetSalesValue + "', '" + objMCTABResultYearlyCopy.MatConsQty + "', '" + objMCTABResultYearlyCopy.MatConsRate + "', '" + objMCTABResultYearlyCopy.MatConsValue + "', '" + objMCTABResultYearlyCopy.ContnwoDistn + "', '" + objMCTABResultYearlyCopy.ContnwoDistnPercent + "', '" + objMCTABResultYearlyCopy.SAPDirectExpense + "', '" + objMCTABResultYearlyCopy.SAPForeignExchange + "', '" + objMCTABResultYearlyCopy.SAPMarketingExp + "', '" + objMCTABResultYearlyCopy.SAPDownloadCost + "', '" + objMCTABResultYearlyCopy.TotalDirectExpense + "', '" + objMCTABResultYearlyCopy.DistriExpense + "', '" + objMCTABResultYearlyCopy.ContnPostDistn + "', '" + objMCTABResultYearlyCopy.FreeSampleQty + "', '" + objMCTABResultYearlyCopy.ClStockQty + "', '" + objMCTABResultYearlyCopy.StockinTransit + "', '" + objMCTABResultYearlyCopy.StockwithRep + "', '" + objMCTABResultYearlyCopy.StockInSpindle + "', '" + objMCTABResultYearlyCopy.TotalClosingstkQty + "', '" + objMCTABResultYearlyCopy.TotalClosingStkRate + "', '" + objMCTABResultYearlyCopy.TotalClStockValue + "', '" + objMCTABResultYearlyCopy.DevaluedStockRate + "', '" + objMCTABResultYearlyCopy.RevisedStkValue + "', '" + objMCTABResultYearlyCopy.DevaluationAmount + "', '" + objMCTABResultYearlyCopy.ExternalTitleCode + "', '" + objMCTABResultYearlyCopy.IsError.Trim().Replace("'", "''") + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		MCTABResultYearlyCopy objMCTABResultYearlyCopy = (MCTABResultYearlyCopy)obj;
		return "update [MC_TAB_Result_Yearly_Copy] set [Month_Year] = '" + objMCTABResultYearlyCopy.MonthYear.Trim().Replace("'", "''") + "', [TitleId] = '" + objMCTABResultYearlyCopy.TitleId.Trim().Replace("'", "''") + "', [TitleName] = '" + objMCTABResultYearlyCopy.TitleName.Trim().Replace("'", "''") + "', [ShowbizzFormat] = '" + objMCTABResultYearlyCopy.ShowbizzFormat.Trim().Replace("'", "''") + "', [MasterFormat] = '" + objMCTABResultYearlyCopy.MasterFormat.Trim().Replace("'", "''") + "', [MRP] = '" + objMCTABResultYearlyCopy.MRP + "', [ReleaseDate] = '" + objMCTABResultYearlyCopy.ReleaseDate.Trim().Replace("'", "''") + "', [RightsExpiry] = '" + objMCTABResultYearlyCopy.RightsExpiry.Trim().Replace("'", "''") + "', [Classification] = '" + objMCTABResultYearlyCopy.Classification.Trim().Replace("'", "''") + "', [Banner] = '" + objMCTABResultYearlyCopy.Banner.Trim().Replace("'", "''") + "', [Dubbed] = '" + objMCTABResultYearlyCopy.Dubbed.Trim().Replace("'", "''") + "', [Language] = '" + objMCTABResultYearlyCopy.Language.Trim().Replace("'", "''") + "', [Genre] = '" + objMCTABResultYearlyCopy.Genre.Trim().Replace("'", "''") + "', [Grade] = '" + objMCTABResultYearlyCopy.Grade.Trim().Replace("'", "''") + "', [Zone] = '" + objMCTABResultYearlyCopy.Zone.Trim().Replace("'", "''") + "', [FilmType] = '" + objMCTABResultYearlyCopy.FilmType.Trim().Replace("'", "''") + "', [SAPInternalOrder] = '" + objMCTABResultYearlyCopy.SAPInternalOrder + "', [Box_Set_Indicator] = '" + objMCTABResultYearlyCopy.BoxSetIndicator.Trim().Replace("'", "''") + "', [Op_Qty] = '" + objMCTABResultYearlyCopy.OpQty + "', [Op_Rate] = '" + objMCTABResultYearlyCopy.OpRate + "', [Op_Value] = '" + objMCTABResultYearlyCopy.OpValue + "', [Op_Amt_Devalued] = '" + objMCTABResultYearlyCopy.OpAmtDevalued + "', [Op_Value_After_Devaluation] = '" + objMCTABResultYearlyCopy.OpValueAfterDevaluation + "', [FG_Purchase_Qty] = '" + objMCTABResultYearlyCopy.FGPurchaseQty + "', [FG_Purchase_Rate] = '" + objMCTABResultYearlyCopy.FGPurchaseRate + "', [FG_Purchase_Value] = '" + objMCTABResultYearlyCopy.FGPurchaseValue + "', [RM_Value] = '" + objMCTABResultYearlyCopy.RMValue + "', [Total_Pur_Qty] = '" + objMCTABResultYearlyCopy.TotalPurQty + "', [Total_Pur_Rate] = '" + objMCTABResultYearlyCopy.TotalPurRate + "', [Total_Pur_Cost_Value] = '" + objMCTABResultYearlyCopy.TotalPurCostValue + "', [RP_Out_Qty] = '" + objMCTABResultYearlyCopy.RPOutQty + "', [RP_Out_Rate] = '" + objMCTABResultYearlyCopy.RPOutRate + "', [RP_Out_Value] = '" + objMCTABResultYearlyCopy.RPOutValue + "', [RP_In_Qty] = '" + objMCTABResultYearlyCopy.RPInQty + "', [RP_In_Rate] = '" + objMCTABResultYearlyCopy.RPInRate + "', [RP_In_Value] = '" + objMCTABResultYearlyCopy.RPInValue + "', [RepackersStkQty] = '" + objMCTABResultYearlyCopy.RepackersStkQty + "', [RepackersStkRate] = '" + objMCTABResultYearlyCopy.RepackersStkRate + "', [RepackersStkValue] = '" + objMCTABResultYearlyCopy.RepackersStkValue + "', [TotalMaterialQty] = '" + objMCTABResultYearlyCopy.TotalMaterialQty + "', [TotalMaterialRate] = '" + objMCTABResultYearlyCopy.TotalMaterialRate + "', [TotalMaterialValue] = '" + objMCTABResultYearlyCopy.TotalMaterialValue + "', [StamperCost] = '" + objMCTABResultYearlyCopy.StamperCost + "', [DomSaleQty] = '" + objMCTABResultYearlyCopy.DomSaleQty + "', [DomSaleRate] = '" + objMCTABResultYearlyCopy.DomSaleRate + "', [DomSaleValue] = '" + objMCTABResultYearlyCopy.DomSaleValue + "', [ExpSaleQty] = '" + objMCTABResultYearlyCopy.ExpSaleQty + "', [ExpSaleRate] = '" + objMCTABResultYearlyCopy.ExpSaleRate + "', [ExpSaleValue] = '" + objMCTABResultYearlyCopy.ExpSaleValue + "', [SalesReturnQty] = '" + objMCTABResultYearlyCopy.SalesReturnQty + "', [Sale_Return_Value] = '" + objMCTABResultYearlyCopy.SaleReturnValue + "', [Sale_Credit_Note_Value] = '" + objMCTABResultYearlyCopy.SaleCreditNoteValue + "', [Sale_Debit_Note_Value] = '" + objMCTABResultYearlyCopy.SaleDebitNoteValue + "', [Pur_Credit_Note_Value] = '" + objMCTABResultYearlyCopy.PurCreditNoteValue + "', [Pur_Debit_Note_Value] = '" + objMCTABResultYearlyCopy.PurDebitNoteValue + "', [NetSalesQty] = '" + objMCTABResultYearlyCopy.NetSalesQty + "', [NetSalesRate] = '" + objMCTABResultYearlyCopy.NetSalesRate + "', [NetSalesValue] = '" + objMCTABResultYearlyCopy.NetSalesValue + "', [MatConsQty] = '" + objMCTABResultYearlyCopy.MatConsQty + "', [MatConsRate] = '" + objMCTABResultYearlyCopy.MatConsRate + "', [MatConsValue] = '" + objMCTABResultYearlyCopy.MatConsValue + "', [ContnwoDistn] = '" + objMCTABResultYearlyCopy.ContnwoDistn + "', [ContnwoDistnPercent] = '" + objMCTABResultYearlyCopy.ContnwoDistnPercent + "', [SAPDirectExpense] = '" + objMCTABResultYearlyCopy.SAPDirectExpense + "', [SAPForeignExchange] = '" + objMCTABResultYearlyCopy.SAPForeignExchange + "', [SAPMarketingExp] = '" + objMCTABResultYearlyCopy.SAPMarketingExp + "', [SAPDownloadCost] = '" + objMCTABResultYearlyCopy.SAPDownloadCost + "', [TotalDirectExpense] = '" + objMCTABResultYearlyCopy.TotalDirectExpense + "', [DistriExpense] = '" + objMCTABResultYearlyCopy.DistriExpense + "', [ContnPostDistn] = '" + objMCTABResultYearlyCopy.ContnPostDistn + "', [FreeSampleQty] = '" + objMCTABResultYearlyCopy.FreeSampleQty + "', [ClStockQty] = '" + objMCTABResultYearlyCopy.ClStockQty + "', [StockinTransit] = '" + objMCTABResultYearlyCopy.StockinTransit + "', [StockwithRep] = '" + objMCTABResultYearlyCopy.StockwithRep + "', [StockInSpindle] = '" + objMCTABResultYearlyCopy.StockInSpindle + "', [TotalClosingstkQty] = '" + objMCTABResultYearlyCopy.TotalClosingstkQty + "', [TotalClosingStkRate] = '" + objMCTABResultYearlyCopy.TotalClosingStkRate + "', [TotalClStockValue] = '" + objMCTABResultYearlyCopy.TotalClStockValue + "', [DevaluedStockRate] = '" + objMCTABResultYearlyCopy.DevaluedStockRate + "', [RevisedStkValue] = '" + objMCTABResultYearlyCopy.RevisedStkValue + "', [DevaluationAmount] = '" + objMCTABResultYearlyCopy.DevaluationAmount + "', [external_title_code] = '" + objMCTABResultYearlyCopy.ExternalTitleCode + "', [is_error] = '" + objMCTABResultYearlyCopy.IsError.Trim().Replace("'", "''") + "' where mc_tab_result_yearly_copy_code = '" + objMCTABResultYearlyCopy.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		MCTABResultYearlyCopy objMCTABResultYearlyCopy = (MCTABResultYearlyCopy)obj;

		return " DELETE FROM [MC_TAB_Result_Yearly_Copy] WHERE mc_tab_result_yearly_copy_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        MCTABResultYearlyCopy objMCTABResultYearlyCopy = (MCTABResultYearlyCopy)obj;
return "Update [MC_TAB_Result_Yearly_Copy] set Is_Active='" + objMCTABResultYearlyCopy.Is_Active + "',lock_time=null, last_updated_time= getdate() where mc_tab_result_yearly_copy_code = '" + objMCTABResultYearlyCopy.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [MC_TAB_Result_Yearly_Copy] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [MC_TAB_Result_Yearly_Copy] WHERE  mc_tab_result_yearly_copy_code = " + obj.IntCode;
    }  
}
