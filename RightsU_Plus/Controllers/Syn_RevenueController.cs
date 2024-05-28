using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;
using RightsU_Entities;
using RightsU_BLL;

namespace RightsU_Plus.Controllers
{
    public class Syn_RevenueController : BaseController
    {
        #region "--------------- List Page ---------------"

        public int PageNo
        {
            get
            {
                if (ViewBag.PageNo == null)
                    ViewBag.PageNo = 1;
                return (int)ViewBag.PageNo;
            }
            set { ViewBag.PageNo = value; }
        }

        public string Mode
        {
            get
            {
                if (ViewBag.Mode == null)
                    ViewBag.Mode = String.Empty;
                return (string)ViewBag.Mode;
            }
            set { ViewBag.Mode = value; }
        }

        #region "--------------- Revenue Object ---------------"

        public Syn_Deal_Revenue objSyn_Deal_Revenue
        {
            get
            {
                if (Session["Syn_Deal_Revenue"] == null)
                    Session["Syn_Deal_Revenue"] = new Syn_Deal_Revenue();
                return (Syn_Deal_Revenue)Session["Syn_Deal_Revenue"];
            }
            set { Session["Syn_Deal_Revenue"] = value; }
        }
        public Syn_Deal_Revenue_Service objSyn_Deal_Revenue_Service
        {
            get
            {
                if (Session["Syn_Deal_Revenue_Service"] == null)
                    Session["Syn_Deal_Revenue_Service"] = new Syn_Deal_Revenue_Service(objLoginEntity.ConnectionStringName);
                return (Syn_Deal_Revenue_Service)Session["Syn_Deal_Revenue_Service"];
            }
            set { Session["Syn_Deal_Revenue_Service"] = value; }
        }
        public Syn_Deal_Service objSDS
        {
            get
            {
                if (Session["SDS_Syn_General"] == null)
                    Session["SDS_Syn_General"] = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
                return (Syn_Deal_Service)Session["SDS_Syn_General"];
            }
            set { Session["SDS_Syn_General"] = value; }
        }
        public Syn_Deal objSyn_Deal
        {
            get
            {
                if (Session[RightsU_Session.SESS_SYNDEAL] == null)
                    Session[RightsU_Session.SESS_SYNDEAL] = new Syn_Deal();
                return (Syn_Deal)Session[RightsU_Session.SESS_SYNDEAL];
            }
            set { Session[RightsU_Session.SESS_SYNDEAL] = value; }
        }
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.Syn_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.Syn_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.Syn_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.Syn_DEAL_SCHEMA] = value; }
        }

        #endregion

        public PartialViewResult Index()
        {
            objSyn_Deal = objSDS.GetById(objDeal_Schema.Deal_Code);
            objDeal_Schema.Page_From = GlobalParams.Page_From_Cost;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            ViewBag.Currency = Convert.ToString(objSyn_Deal.Currency.Currency_Name);
            ViewBag.CurrencyExchangeRate = objSyn_Deal.Exchange_Rate;
            ViewBag.TotalFixedDealCost = BindTotalDealCost();
            ViewBag.Approver_Remark = objDeal_Schema.Approver_Remark;

            Mode = objDeal_Schema.Mode;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;

            return PartialView("~/Views/Syn_Deal/_Syn_Revenue.cshtml"); ;
        }

        [HttpPost]
        public PartialViewResult BindGridSynDealRevenue(int? txtPageSize, int? page_No)
        {
            int pageSize;
            if (txtPageSize != null)
            {
                objDeal_Schema.Cost_PageSize = Convert.ToInt32(txtPageSize);
                pageSize = Convert.ToInt32(txtPageSize);
            }
            else
            {
                objDeal_Schema.Cost_PageSize = 50;
                pageSize = 50;
            }
            PageNo = Convert.ToInt32(page_No ?? 0) + 1;
            ICollection<Syn_Deal_Revenue> lst_Syn_Deal_Revenue;

            if (PageNo == 1)
                lst_Syn_Deal_Revenue = objSyn_Deal_Revenue_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Syn_Deal_Revenue_Code).Take(pageSize).ToList();
            else
            {
                lst_Syn_Deal_Revenue = objSyn_Deal_Revenue_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Syn_Deal_Revenue_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (lst_Syn_Deal_Revenue.Count == 0)
                {
                    if (PageNo != 1)
                    {
                        objDeal_Schema.Cost_PageNo = PageNo - 1;
                        PageNo = PageNo - 1;
                    }
                    lst_Syn_Deal_Revenue = objSyn_Deal_Revenue_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Syn_Deal_Revenue_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }

            ViewBag.RecordCount = objSyn_Deal_Revenue_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).Count();
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = txtPageSize;
            Mode = objDeal_Schema.Mode;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            return PartialView("~/Views/Syn_Deal/_List_Revenue.cshtml", lst_Syn_Deal_Revenue.Where(i => i.EntityState != State.Deleted).ToList());
            //return PartialView("_List", lst_Syn_Deal_Revenue.Where(i => i.EntityState != State.Deleted).ToList());
        }

        public JsonResult DeleteRecord(int costCodeId)
        {
            Syn_Deal_Service objSyn = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
            string strMessage = "Y";
            objSyn_Deal = objSyn.GetById(objDeal_Schema.Deal_Code);
            Syn_Deal_Revenue costInstance = objSyn_Deal_Revenue_Service.GetById(costCodeId);
            List<int> lstCostTypeCode = costInstance.Syn_Deal_Revenue_Costtype.Select(r => (int)r.Cost_Type_Code).ToList();
            if (objSyn_Deal.Syn_Deal_Payment_Terms.Where(p => lstCostTypeCode.Contains((int)p.Cost_Type_Code)).Count() > 0)
            {
                strMessage = "N";
            }
            else
            {
                foreach (Syn_Deal_Revenue_Additional_Exp additionalExpInstance in costInstance.Syn_Deal_Revenue_Additional_Exp)
                {
                    additionalExpInstance.EntityState = State.Deleted;
                }
                foreach (Syn_Deal_Revenue_Commission commissionInstance in costInstance.Syn_Deal_Revenue_Commission)
                {
                    commissionInstance.EntityState = State.Deleted;
                }
                foreach (Syn_Deal_Revenue_Costtype costTypeInstance in costInstance.Syn_Deal_Revenue_Costtype)
                {
                    costTypeInstance.EntityState = State.Deleted;
                }
                foreach (Syn_Deal_Revenue_Title titleInstance in costInstance.Syn_Deal_Revenue_Title)
                {
                    titleInstance.EntityState = State.Deleted;
                }
                foreach (Syn_Deal_Revenue_Variable_Cost variableCostInstance in costInstance.Syn_Deal_Revenue_Variable_Cost)
                {
                    variableCostInstance.EntityState = State.Deleted;
                }
                if (costInstance != null)
                {
                    costInstance.EntityState = State.Deleted;
                    Save(costInstance);
                }
            }
            string TotalFixedDealCost = BindTotalDealCost();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strMessage);
            obj.Add("TotalFixedDealCost", TotalFixedDealCost);
            return Json(obj);
        }

        private void Save(Syn_Deal_Revenue costInstance)//Final Save
        {
            dynamic resultSet;
            objSyn_Deal_Revenue_Service.Save(costInstance, out resultSet);
            string strResult = resultSet;

            objSyn_Deal_Revenue_Service = null;
        }

        public ActionResult SaveDeal(string hdnCurrencyExchangeRate, string hdnTabName, string hdnReopenMode = "")
        {
            string msg = "", mode = "", status = "S";

            string txtCurrencyExchangeRate = hdnCurrencyExchangeRate;
            dynamic resultSet;

            if (hdnReopenMode == "RO")
            {
                mode = GlobalParams.DEAL_MODE_EDIT;
                status = "SA";
            }
            else
                mode = objDeal_Schema.Mode;

            if (mode == GlobalParams.DEAL_MODE_REOPEN)
            {
                objDeal_Schema.Deal_Workflow_Flag = objSyn_Deal.Deal_Workflow_Status = Convert.ToString(mode).Trim();
            }

            if (txtCurrencyExchangeRate != "")
            {
                string strExchangeRate = txtCurrencyExchangeRate.Trim() == "." ? "0" : txtCurrencyExchangeRate;
                if (objSyn_Deal_Revenue.Currency_Exchange_Rate != Convert.ToDecimal(strExchangeRate))
                {
                    Syn_Deal objSyn = objSDS.GetById(objSyn_Deal.Syn_Deal_Code);
                    objSyn.Exchange_Rate = Convert.ToDecimal(strExchangeRate);
                    objSyn.EntityState = State.Modified;
                    objSDS.Save(objSyn, out resultSet);
                }
            }

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
                if (hdnTabName == "")
                {
                    Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
                    obj_Dic.Add("Page_No", objDeal_Schema.PageNo.ToString());
                    TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
                    //  return RedirectToAction("Index", "Syn_List");
                    string Mode = objDeal_Schema.Mode;
                    TempData["RedirectSynDeal"] = objSyn_Deal;
                    msg = objMessageKey.DealSavedSuccessfully;
                    if (Mode == GlobalParams.DEAL_MODE_EDIT)
                        msg = objMessageKey.DealUpdatedSuccessfully;
                }
            }
            int pageNo = objDeal_Schema.PageNo;

            string redirectUrl = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetRedirectURL(hdnTabName, pageNo, null, objDeal_Schema.Deal_Type_Code, GlobalParams.ModuleCodeForSynDeal);

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Success_Message", msg);
            obj.Add("Redirect_URL", redirectUrl);
            return Json(obj);
            //    return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, pageNo, objDeal_Schema.Deal_Type_Code, GlobalParams.ModuleCodeForSynDeal);
        }



        public ActionResult Cancel()
        {
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
            ClearSession();
            objDeal_Schema = null;
            Session[RightsU_Session.SESS_SYNDEAL] = null;
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                return RedirectToAction("Index", "Syn_List", new { Page_No = pageNo, ReleaseRecord = "Y" });
            }
        }

        private string BindTotalDealCost()
        {
            ICollection<Syn_Deal_Revenue> lst_Syn_Deal_Revenue = objSyn_Deal_Revenue_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).ToList();
            decimal TotalCost = Convert.ToDecimal((from Syn_Deal_Revenue objDealRevenue in lst_Syn_Deal_Revenue
                                                   select objDealRevenue.Deal_Cost).Sum());
            return GlobalParams.CurrencyFormat((double)TotalCost);
        }

        #endregion

        #region"--------------- Add Revenue---------------"

        private void BindHeaderData()
        {
            Session[RightsU_Session.SESS_SYNDEAL] = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            objSyn_Deal = (Syn_Deal)Session[RightsU_Session.SESS_SYNDEAL];  // Remove Comment Afetr Delete

        }
        IQueryable<Cost_Type> objCost_Type
        {
            get
            {
                if (Session["Cost_Type"] == null)
                    Session["Cost_Type"] = new Cost_Type();
                return (IQueryable<Cost_Type>)Session["Cost_Type"];
            }
            set { Session["Cost_Type"] = value; }
        }
        IQueryable<Additional_Expense> obj_Additional_Expense
        {
            get
            {
                if (Session["Additional_Expense"] == null)
                    Session["Additional_Expense"] = new Additional_Expense();
                return (IQueryable<Additional_Expense>)Session["Additional_Expense"];
            }
            set { Session["Additional_Expense"] = value; }
        }
        public string CostMode
        {
            get
            {
                if (TempData["CostMode"] == null)
                    return "A";
                else
                    return (string)TempData["CostMode"];
            }
            set
            {
                TempData["CostMode"] = value;
            }
        }
        public string ROI
        {
            get
            {
                if (TempData["ROI"] == null)
                    return "N";
                return (string)TempData["ROI"];

            }
            set
            {
                TempData["ROI"] = value;
            }
        }
        public string dealMovieCodes
        {
            get
            {
                if (TempData["dealMovieCodes"] == null)
                    return "";
                else
                    return (string)TempData["dealMovieCodes"];
            }
            set
            {
                TempData["dealMovieCodes"] = value;
            }
        }

        [HttpPost]
        public PartialViewResult PartialAddEditDealCost(int SynDealRevenueCode, string ExchangeRate, string CommandName)
        {
            ClearSession();
            dynamic resultSet;
            if (ExchangeRate != "")
            {
                string strExchangeRate = ExchangeRate.Trim() == "." ? "0" : ExchangeRate;
                if (objSyn_Deal.Exchange_Rate != Convert.ToDecimal(strExchangeRate))
                {
                    Syn_Deal objSyn = objSDS.GetById(objSyn_Deal.Syn_Deal_Code);//188
                    objSyn.Exchange_Rate = Convert.ToDecimal(strExchangeRate);
                    objSyn.EntityState = State.Modified;
                    objSDS.Save(objSyn, out resultSet);
                }
            }
            ViewBag.Currency = Convert.ToString(objSyn_Deal.Currency.Currency_Name);
            ViewBag.CurrencyExchangeRate = objSyn_Deal.Exchange_Rate;
            if (CommandName == "Add")
            {
                objSyn_Deal_Revenue.HeaderLabel = objMessageKey.AddRevenue;
            }
            else if (CommandName == "Edit")
            {
                objSyn_Deal_Revenue = objSyn_Deal_Revenue_Service.GetById(SynDealRevenueCode);
                objSyn_Deal_Revenue.HeaderLabel = objMessageKey.EditRevenue;
                if (objSyn_Deal_Revenue.Currency_Code != objSyn_Deal.Currency_Code)  //Remove if Currenge change not needid in EDIT
                {                                                                    //Remove if Currenge change not needid in EDIT
                    objSyn_Deal_Revenue.Currency_Code = objSyn_Deal.Currency_Code;   //Remove if Currenge change not needid in EDIT
                    objSyn_Deal_Revenue.Currency = null;                             //Remove if Currenge change not needid in EDIT
                }                                                                   //Remove if Currenge change not needid in EDIT
            }
            else if (CommandName == "View")
            {
                objSyn_Deal_Revenue = objSyn_Deal_Revenue_Service.GetById(SynDealRevenueCode);
                string movieName = String.Empty;
                objSyn_Deal_Revenue.HeaderLabel = objMessageKey.ViewRevenue;
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program)
                    movieName = string.Join(", ", objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Select(s => s.Title.Title_Name + " ( " + s.Episode_From + " - " + s.Episode_To + " )").ToArray());
                else
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                        movieName = string.Join(", ", objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Select(s => s.Title.Title_Name + " ( " + s.Episode_From + " )").ToArray());
                    else
                        movieName = string.Join(", ", objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Select(s => s.Title.Title_Name).ToArray());

                //ViewBag.VariableCostList = objSyn_Deal_Revenue.Syn_Deal_Revenue_Variable_Cost.ToList();
                ViewBag.MovieName = movieName;
                if (objSyn_Deal_Revenue.Royalty_Recoupment_Code != null)
                {
                    Royalty_Recoupment_Service objRRS = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
                    ViewBag.Royalty_Recoupment_Name = objRRS.GetById(Convert.ToInt32(objSyn_Deal_Revenue.Royalty_Recoupment_Code)).Royalty_Recoupment_Name;
                }
                else
                    ViewBag.Royalty_Recoupment_Name = objMessageKey.NoRecoupment;
            }
            ViewBag.Mode = objDeal_Schema.Mode;
            Mode = objDeal_Schema.Mode;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            //return PartialView("_Create", objSyn_Deal_Revenue);
            return PartialView("~/Views/Syn_Deal/_Syn_Revenue_Create.cshtml", objSyn_Deal_Revenue);
        }
        public JsonResult BindRoyaltyRecoupment(int Royalty_Recoupment_Code)
        {
            Royalty_Recoupment_Service objRRS = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
            List<SelectListItem> lstRR = new SelectList(objRRS.SearchFor(x => x.Is_Active == "Y"), "Royalty_Recoupment_Code", "Royalty_Recoupment_Name", Royalty_Recoupment_Code).ToList();
            lstRR.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.NoRecoupment });
            //return lstRR;
            var arr = lstRR;
            return Json(arr, JsonRequestBehavior.AllowGet);
        }
        private void PopulateData()
        {
            if (objSyn_Deal != null)
            {
                BindVariableType();
            }
        }
        [HttpPost]
        public PartialViewResult Load_Cost_Type()
        {
            double doublesumCostTypeAmount = (double)(from Syn_Deal_Revenue_Costtype obj in objSyn_Deal_Revenue.Syn_Deal_Revenue_Costtype where obj.EntityState != State.Deleted select obj.Amount).Sum();
            ViewBag.TotalCostType = GlobalParams.CurrencyFormat(doublesumCostTypeAmount);
            SetCost_Type_Service();
            ViewBag.Mode = objDeal_Schema.Mode;
            //return PartialView("_Cost_Type", objSyn_Deal_Revenue);
            return PartialView("~/Views/Syn_Deal/_Cost_Type.cshtml", objSyn_Deal_Revenue);
        }
        public PartialViewResult Load_Additional_Exp()
        {
            double doublesumAdditionalAmount = (double)(from Syn_Deal_Revenue_Additional_Exp obj in objSyn_Deal_Revenue.Syn_Deal_Revenue_Additional_Exp where obj.EntityState != State.Deleted select obj.Amount).Sum();
            ViewBag.TotalAdditionalExpense = GlobalParams.CurrencyFormat(doublesumAdditionalAmount);
            SetAdditional_Expense();
            ViewBag.Mode = objDeal_Schema.Mode;
            //  return PartialView("~/Views/Syn_Deal/_Additional_Exp.cshtml", objSyn_Deal_Revenue);
            return PartialView("~/Views/Syn_Deal/_Additional_Exp.cshtml", objSyn_Deal_Revenue);
        }
        public PartialViewResult Load_Standard_Returns()
        {
            double doublesumCommiAmount = (double)(from Syn_Deal_Revenue_Commission obj in objSyn_Deal_Revenue.Syn_Deal_Revenue_Commission where obj.EntityState != State.Deleted select obj.Amount).Sum();
            ViewBag.TotalStandardReturns = GlobalParams.CurrencyFormat(doublesumCommiAmount);
            ViewBag.Mode = objDeal_Schema.Mode;
            //return PartialView("_Standard_Returns", objSyn_Deal_Revenue);
            return PartialView("~/Views/Syn_Deal/_Standard_Returns.cshtml", objSyn_Deal_Revenue);
        }
        public PartialViewResult Load_Overflow()
        {
            if (objSyn_Deal != null)
                BindVariableType();
            if (objSyn_Deal_Revenue.Variable_Cost_Type == null)
                ViewBag.Variable_Cost_Type = "N";
            else
                ViewBag.Variable_Cost_Type = objSyn_Deal_Revenue.Variable_Cost_Type;
            ViewBag.VariableCostList = objSyn_Deal_Revenue.Syn_Deal_Revenue_Variable_Cost.ToList();
            //BindVariableCost();
            ViewBag.Mode = objDeal_Schema.Mode;
            // return PartialView("_Overflow", objSyn_Deal_Revenue);
            return PartialView("~/Views/Syn_Deal/_Overflow.cshtml", objSyn_Deal_Revenue);
        }
        public void ClearSession()
        {
            objSyn_Deal_Revenue = null;
            Session["Syn_Deal_Revenue_Service"] = null;
            Session["Syn_Deal_Revenue"] = null;
            Session["Cost_Type"] = null;
            Session["Additional_Expense"] = null;
        }

        #region "---------------Bind Dropdowns ---------------"

        public JsonResult BindTitle()
        {
            Syn_Deal_Service objss = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
            objSyn_Deal = objss.GetById(objDeal_Schema.Deal_Code);
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            string dataTxtField;
            string dataValField;
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program)
            {
                dataTxtField = "Title_Name_Program";
                dataValField = "Syn_Deal_Movie_Code";
            }
            else if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                dataTxtField = "Title_Name_Music";
                dataValField = "Syn_Deal_Movie_Code";
            }
            else
            {
                dataTxtField = "Title_Name";
                dataValField = "Title_Code";
            }

            List<Title_List> lstCostAddedTitle = (from Syn_Deal_Revenue objSDR in objSyn_Deal.Syn_Deal_Revenue
                                                  from Syn_Deal_Revenue_Title objSDRT in objSDR.Syn_Deal_Revenue_Title
                                                  select objSDRT).Select(s => new Title_List() { Title_Code = (int)s.Title_Code, Episode_From = (int)s.Episode_From, Episode_To = (int)s.Episode_To }
                                                ).Distinct().ToList();

            List<Title_List> lstPopulate = objDeal_Schema.Title_List.Where(x => lstCostAddedTitle.Where(y => y.Title_Code == x.Title_Code
                && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() == 0).Distinct().ToList();


            lstPopulate.AddRange(objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Select(s => new Title_List() { Title_Code = (int)s.Title_Code, Episode_From = (int)s.Episode_From, Episode_To = (int)s.Episode_To }
            ));

            string selected_Title_Code = ""; // string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(i => i.Title_Code).ToList()));

            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
            else
                selected_Title_Code = string.Join(",", objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Select(t => t.Title_Code.ToString()).Distinct());

            Syn_Deal_Movie_Service objSyn_Deal_Movie_Service = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName);

            MultiSelectList lstTitle = new MultiSelectList(objSyn_Deal_Movie_Service.SearchFor(a => a.Syn_Deal_Code == objDeal_Schema.Deal_Code).ToList()
                .Where(x => lstPopulate.Where(w => x.Episode_From == w.Episode_From && x.Episode_End_To == w.Episode_To && x.Title_Code == w.Title_Code).Count() > 0)
                    .Select(s => new
                    {
                        Syn_Deal_Movie_Code = s.Syn_Deal_Movie_Code,
                        Title_Code = s.Title_Code,
                        Title_Name = s.Title.Title_Name,
                        Title_Name_Music = s.Title.Title_Name + " ( " + (Convert.ToString(s.Episode_From) == "0" ? "Unlimited" : Convert.ToString(s.Episode_From)) + " ) ",
                        Title_Name_Program = s.Title.Title_Name + " ( " + s.Episode_From + " - " + s.Episode_End_To + " ) "
                    }
            ).ToList().OrderBy(o => o.Title_Name), dataValField, dataTxtField, selected_Title_Code.Split(','));

            //return lstTitle;
            var arr = lstTitle;
            return Json(arr, JsonRequestBehavior.AllowGet);
        }

        public void BindTotalLabels()
        {
            double doublesumCostTypeAmount = (double)(from Syn_Deal_Revenue_Costtype obj in objSyn_Deal_Revenue.Syn_Deal_Revenue_Costtype where obj.EntityState != State.Deleted select obj.Amount).Sum();
            ViewBag.TotalCostType = GlobalParams.CurrencyFormat(doublesumCostTypeAmount);

            double doublesumAdditionalAmount = (double)(from Syn_Deal_Revenue_Additional_Exp obj in objSyn_Deal_Revenue.Syn_Deal_Revenue_Additional_Exp where obj.EntityState != State.Deleted select obj.Amount).Sum();
            ViewBag.TotalAdditionalExpense = GlobalParams.CurrencyFormat(doublesumAdditionalAmount);

            double doublesumCommiAmount = (double)(from Syn_Deal_Revenue_Commission obj in objSyn_Deal_Revenue.Syn_Deal_Revenue_Commission where obj.EntityState != State.Deleted select obj.Amount).Sum();
            ViewBag.TotalStandardReturns = GlobalParams.CurrencyFormat(doublesumCommiAmount);
        }

        #endregion

        #region "---------------Set Values ---------------"

        private void SetCost_Type_Service()
        {
            Cost_Type_Service objCTS = new Cost_Type_Service(objLoginEntity.ConnectionStringName);
            objCost_Type = objCTS.SearchFor(i => i.Cost_Type_Code > 0);
        }
        private void SetAdditional_Expense()
        {
            Additional_Expense_Service objAES = new Additional_Expense_Service(objLoginEntity.ConnectionStringName);
            obj_Additional_Expense = objAES.SearchFor(x => x.Additional_Expense_Code > 0);
        }

        #endregion

        #region "---------------Grid Fixed Fees(Cost_CostType) ---------------"

        private List<SelectListItem> BindddlCostType(int Cost_Type_Code)
        {
            string[] Selected_Cost_CostTypeCode = (
                                        from Syn_Deal_Revenue_Costtype objTADCCT in objSyn_Deal_Revenue.Syn_Deal_Revenue_Costtype
                                        where objTADCCT.Cost_Type_Code != Cost_Type_Code && objTADCCT.EntityState != State.Deleted
                                        select objTADCCT.Cost_Type_Code.ToString()
                                        ).Distinct().ToArray();
            List<SelectListItem> lstCostType = new SelectList(from Cost_Type obj in objCost_Type
                                                              where !Selected_Cost_CostTypeCode.Contains(obj.Cost_Type_Code.ToString()) && obj.Is_Active == "Y"
                                                              select obj, "Cost_Type_Code", "Cost_Type_Name", Cost_Type_Code.ToString()).ToList();

            lstCostType.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
            return lstCostType;
        }

        [HttpPost]
        public PartialViewResult AddCancelCostType(string isAdd)
        {
            ViewBag.AcqDealCostTypeCode = 0;
            ViewBag.DdlCostType = BindddlCostType(0);
            if (isAdd == "1")
                ViewBag.IsAddEditMode = "Y";
            else
                ViewBag.IsAddEditMode = "";
            BindTotalLabels();
            //    return PartialView("~/Views/Syn_Deal/_Cost_Type.cshtml", objSyn_Deal_Revenue);
            return PartialView("~/Views/Syn_Deal/_Cost_Type.cshtml", objSyn_Deal_Revenue);

        }

        [HttpPost]
        public PartialViewResult EditCostType(int AcqDealCostTypeCode, int CostTypeCode)
        {
            ViewBag.IsAddEditMode = "Y";
            ViewBag.AcqDealCostTypeCode = CostTypeCode;
            ViewBag.DdlCostType = BindddlCostType(CostTypeCode);
            ViewBag.IsRefPayTerm = false;
            if (objSyn_Deal.Syn_Deal_Payment_Terms.Where(p => CostTypeCode == (int)p.Cost_Type_Code).Count() > 0)
            {
                ViewBag.IsRefPayTerm = true;
            }
            BindTotalLabels();
            return PartialView("~/Views/Syn_Deal/_Cost_Type.cshtml", objSyn_Deal_Revenue);
        }

        [HttpPost]
        public PartialViewResult SaveCostType(int AcqDealCostTypeCode, int CostTypeCode, string BudgetedAmt, int rowIndex)
        {
            if (rowIndex == 0)
            {
                Syn_Deal_Revenue_Costtype objADCCT = new Syn_Deal_Revenue_Costtype();
                objADCCT.Cost_Type_Code = Convert.ToInt32(CostTypeCode);
                objADCCT.Consumed_Amount = Convert.ToDecimal(BudgetedAmt);
                objADCCT.Amount = Convert.ToDecimal(BudgetedAmt);
                SetCost_Type_Service();
                objADCCT.Inserted_On = DBUtil.getServerDate();
                objADCCT.Inserted_By = objLoginUser.Users_Code;
                objADCCT.EntityState = State.Added;
                objSyn_Deal_Revenue.Syn_Deal_Revenue_Costtype.Add(objADCCT);
            }
            else
            {
                rowIndex = rowIndex - 1;
                Syn_Deal_Revenue_Costtype objADCCT = objSyn_Deal_Revenue.Syn_Deal_Revenue_Costtype.Where(c => c.EntityState != State.Deleted).ElementAt(rowIndex);

                objADCCT.Cost_Type_Code = Convert.ToInt32(CostTypeCode);
                objADCCT.Consumed_Amount = Convert.ToDecimal(BudgetedAmt);
                objADCCT.Amount = Convert.ToDecimal(BudgetedAmt);


                if (objADCCT.Syn_Deal_Revenue_Costtype_Code > 0)
                    objADCCT.EntityState = State.Modified;
                else
                    objADCCT.EntityState = State.Added;
            }
            BindTotalLabels();
            ViewBag.IsAddEditMode = "";
            return PartialView("~/Views/Syn_Deal/_Cost_Type.cshtml", objSyn_Deal_Revenue);
        }

        [HttpPost]
        public PartialViewResult DeleteCostType(int AcqDealCostTypeCode, int rowIndex)
        {
            ViewBag.CTMessage = "";
            rowIndex = rowIndex - 1;
            Syn_Deal_Revenue_Costtype objADCCT = objSyn_Deal_Revenue.Syn_Deal_Revenue_Costtype.Where(c => c.EntityState != State.Deleted).ElementAt(rowIndex);
            if (objSyn_Deal.Syn_Deal_Payment_Terms.Where(p => objADCCT.Cost_Type_Code == (int)p.Cost_Type_Code).Count() > 0)
            {
                ViewBag.CTMessage = objMessageKey.ThisFixedFeesisalreadyassignedtoStandardReturnsPaymentTerms;
            }
            else
            {
                if (objADCCT.Syn_Deal_Revenue_Costtype_Code > 0)
                    objADCCT.EntityState = State.Deleted;
                else
                    objSyn_Deal_Revenue.Syn_Deal_Revenue_Costtype.Remove(objADCCT);
            }
            BindTotalLabels();
            return PartialView("~/Views/Syn_Deal/_Cost_Type.cshtml", objSyn_Deal_Revenue);
        }

        #endregion

        #region "---------------Grid Additional Expense---------------"

        private List<SelectListItem> BindddlAdditionalExp(int AdditionalExpCode)
        {
            string[] Selected_Add_Exp_Code = (from Syn_Deal_Revenue_Additional_Exp objADCAE in objSyn_Deal_Revenue.Syn_Deal_Revenue_Additional_Exp
                                              where objADCAE.Additional_Expense_Code != AdditionalExpCode
                                              select objADCAE.Additional_Expense_Code.ToString()).Distinct().ToArray();
            List<SelectListItem> lstAE = new SelectList(from Additional_Expense obj in obj_Additional_Expense
                                                        where !Selected_Add_Exp_Code.Contains(obj.Additional_Expense_Code.ToString())
                                                        select obj, "Additional_Expense_Code", "Additional_Expense_Name", AdditionalExpCode.ToString()).ToList();
            lstAE.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
            return lstAE;
        }

        [HttpPost]
        public PartialViewResult AddCancelAdditionalExpense(string isAdd)
        {
            ViewBag.AcqDealAdditonalExpCode = 0;
            ViewBag.DdlAdditionalExpense = BindddlAdditionalExp(0);

            if (isAdd == "1")
                ViewBag.IsAddEditMode = "Y";
            else
                ViewBag.IsAddEditMode = "";
            BindTotalLabels();
            return PartialView("~/Views/Syn_Deal/_Additional_Exp.cshtml", objSyn_Deal_Revenue);

        }

        [HttpPost]
        public PartialViewResult SaveAdditionalExp(int AcqDealAdditionalExpCode, int AdditionalExpCode, string Amount, int rowIndex)
        {
            if (rowIndex == 0)
            {
                Syn_Deal_Revenue_Additional_Exp objADCAE = new Syn_Deal_Revenue_Additional_Exp();
                objADCAE.Additional_Expense_Code = Convert.ToInt32(AdditionalExpCode);
                objADCAE.Amount = Convert.ToDecimal(Amount.Trim());
                objADCAE.EntityState = State.Added;
                objADCAE.Inserted_On = DBUtil.getServerDate();
                objADCAE.Inserted_By = objLoginUser.Users_Code;

                objSyn_Deal_Revenue.Syn_Deal_Revenue_Additional_Exp.Add(objADCAE);

            }
            else
            {
                rowIndex = rowIndex - 1;

                Syn_Deal_Revenue_Additional_Exp objADCAE = objSyn_Deal_Revenue.Syn_Deal_Revenue_Additional_Exp.Where(a => a.EntityState != State.Deleted).ElementAt(rowIndex);
                objADCAE.Additional_Expense_Code = Convert.ToInt32(AdditionalExpCode);
                objADCAE.Amount = Convert.ToDecimal(Amount.Trim());
                // objADCAE.Min_Max = MinMax;
                if (objADCAE.Syn_Deal_Revenue_Additional_Exp_Code > 0)
                    objADCAE.EntityState = State.Modified;
                else
                    objADCAE.EntityState = State.Added;

            }
            BindTotalLabels();
            ViewBag.IsAddEditMode = "";
            return PartialView("~/Views/Syn_Deal/_Additional_Exp.cshtml", objSyn_Deal_Revenue);
        }

        [HttpPost]
        public PartialViewResult EditAdditionalExpense(int AcqDealAdditionalExpCode, int AdditionalExpCode)
        {
            ViewBag.IsAddEditMode = "Y";
            ViewBag.AcqDealAdditonalExpCode = AdditionalExpCode;
            ViewBag.DdlAdditionalExpense = BindddlAdditionalExp(AdditionalExpCode);

            BindTotalLabels();
            return PartialView("~/Views/Syn_Deal/_Additional_Exp.cshtml", objSyn_Deal_Revenue);
        }

        [HttpPost]
        public PartialViewResult DeleteAdditionalExpense(int rowIndex)
        {
            rowIndex = rowIndex - 1;
            Syn_Deal_Revenue_Additional_Exp objADCAE = objSyn_Deal_Revenue.Syn_Deal_Revenue_Additional_Exp.Where(c => c.EntityState != State.Deleted).ElementAt(rowIndex);

            if (objADCAE.Syn_Deal_Revenue_Additional_Exp_Code > 0)
                objADCAE.EntityState = State.Deleted;
            else
                objSyn_Deal_Revenue.Syn_Deal_Revenue_Additional_Exp.Remove(objADCAE);

            BindTotalLabels();
            return PartialView("~/Views/Syn_Deal/_Additional_Exp.cshtml", objSyn_Deal_Revenue);
        }

        #endregion

        #region "---------------Grid Standard Returns---------------"

        [HttpPost]
        public PartialViewResult EditStandardReturns(int AcqDealStandardReturnsCode, int EntityCodeCode, int CostTypeCode, int VendorCode, string CommissionType)
        {
            ViewBag.IsAddEditMode = "Y";
            ViewBag.CommissionType = CommissionType;
            if (CostTypeCode == 0)
                ViewBag.CostTypeCode = null;
            else
                ViewBag.CostTypeCode = CostTypeCode;
            ViewBag.SynDealRevenueCommissionCode = AcqDealStandardReturnsCode;
            ViewBag.AcqDealEntityCode = EntityCodeCode == 0 ? VendorCode : EntityCodeCode;
            ViewBag.EntityType = EntityCodeCode == 0 ? "L" : "O";
            BindDropDownForSR(EntityCodeCode, CostTypeCode);
            BindRadionForCommissionType();
            BindTotalLabels();
            return PartialView("~/Views/Syn_Deal/_Standard_Returns.cshtml", objSyn_Deal_Revenue);
        }

        private void BindDropDownForSR(int Entity_Code, int Cost_Type_Code)
        {
            List<SelectListItem> lstAE = new List<SelectListItem>();

            Entity objEntity = new Entity();
            objEntity.IntCode = Convert.ToInt32(objLoginUser.Default_Entity_Code);
            objEntity.Fetch();
            lstAE.Add(new SelectListItem() { Value = objEntity.IntCode.ToString() + "~O", Text = objEntity.EntityName });

            Vendor_Service vendorServiceInstance = new Vendor_Service(objLoginEntity.ConnectionStringName);

            if (objSyn_Deal.Vendor_Code.HasValue)
            {
                RightsU_Entities.Vendor vendorInstance = vendorServiceInstance.GetById(objSyn_Deal.Vendor_Code.Value);
                lstAE.Add(new SelectListItem() { Value = vendorInstance.Vendor_Code.ToString() + "~L", Text = vendorInstance.Vendor_Name });
            }
            lstAE.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
            ViewBag.DdlEntity = lstAE;


            /*------------Cost Type-------------------*/
            List<SelectListItem> lstCost_Type = new SelectList(from Syn_Deal_Revenue_Costtype objADCCT in objSyn_Deal_Revenue.Syn_Deal_Revenue_Costtype
                                                               from Cost_Type objCT in objCost_Type
                                                               where objCT.Cost_Type_Code == objADCCT.Cost_Type_Code && objADCCT.EntityState != State.Deleted
                                                               select objCT, "Cost_Type_Code", "Cost_Type_Name", Cost_Type_Code).ToList();
            lstCost_Type.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
            ViewBag.CostTypeSR = lstCost_Type;
        }

        public PartialViewResult SaveStandardReturns(int AcqDealStandardReturnsCode, string EntityCode, int CostTypeCode, string Amount, string Percentage, string CommType, int rowIndex)
        {
            objSyn_Deal_Revenue.StanddardReturnMessage = "";
            if (rowIndex == 0)
            {
                string Vendor_Entity_Code = EntityCode;
                Syn_Deal_Revenue_Commission objADCC = new Syn_Deal_Revenue_Commission();
                string[] ArrVendor_Entity_Code = Vendor_Entity_Code.Split('~');
                objADCC.Cost_Type_Code = CostTypeCode <= 0 ? (int?)null : Convert.ToInt32(CostTypeCode);
                objADCC.Type = ArrVendor_Entity_Code[1];
                if (ArrVendor_Entity_Code[1] == "L")
                    objADCC.Vendor_Code = Convert.ToInt32(ArrVendor_Entity_Code[0]);
                else
                    if (ArrVendor_Entity_Code[1] == "O")
                        objADCC.Entity_Code = Convert.ToInt32(ArrVendor_Entity_Code[0]);

                objADCC.Commission_Type = CommType;
                objADCC.Percentage = Convert.ToDecimal(Percentage.Trim() == "" ? "0" : Percentage.Trim());
                objADCC.Amount = Convert.ToDecimal(Amount.Trim() == "" ? "0" : Amount.Trim());

                int count = 0;
                if (ArrVendor_Entity_Code[1] == "L")
                {
                    count = (from commissionInstance in objSyn_Deal_Revenue.Syn_Deal_Revenue_Commission
                             where commissionInstance.EntityState != State.Deleted &&
                             commissionInstance.Cost_Type_Code == objADCC.Cost_Type_Code &&
                             commissionInstance.Vendor_Code == objADCC.Vendor_Code &&
                             commissionInstance.Type == objADCC.Type &&
                             commissionInstance.Commission_Type == objADCC.Commission_Type
                             select commissionInstance).Count();
                }
                else
                    if (ArrVendor_Entity_Code[1] == "O")
                    {
                        count = (from commissionInstance in objSyn_Deal_Revenue.Syn_Deal_Revenue_Commission
                                 where commissionInstance.EntityState != State.Deleted &&
                                 commissionInstance.Cost_Type_Code == objADCC.Cost_Type_Code &&
                                 commissionInstance.Entity_Code == objADCC.Entity_Code &&
                                 commissionInstance.Type == objADCC.Type &&
                                 commissionInstance.Commission_Type == objADCC.Commission_Type
                                 select commissionInstance).Count();
                    }

                if (count > 0)
                {
                    objSyn_Deal_Revenue.StanddardReturnMessage = objMessageKey.CosttypeforthePartyisalreadyavailable ;
                }
                else
                {
                    objADCC.EntityState = State.Added;
                    objSyn_Deal_Revenue.Syn_Deal_Revenue_Commission.Add(objADCC);
                    BindTotalLabels();
                    ViewBag.IsAddEditMode = "";
                }
            }
            else
            {
                rowIndex = rowIndex - 1;

                string Vendor_Entity_Code = EntityCode;
                string[] ArrVendor_Entity_Code = Vendor_Entity_Code.Split('~');
                Syn_Deal_Revenue_Commission objADCC = objSyn_Deal_Revenue.Syn_Deal_Revenue_Commission.Where(c => c.EntityState != State.Deleted).ElementAt(rowIndex);

                int? Cost_Type_Code = (CostTypeCode <= 0) ? (int?)null : Convert.ToInt32(CostTypeCode);
                string Type = ArrVendor_Entity_Code[1];
                int? Vendor_Code = 0;
                int? Entity_Code = 0;
                if (ArrVendor_Entity_Code[1] == "L")
                    Vendor_Code = Convert.ToInt32(ArrVendor_Entity_Code[0]);
                else
                    if (ArrVendor_Entity_Code[1] == "O")
                        Entity_Code = Convert.ToInt32(ArrVendor_Entity_Code[0]);

                decimal? Percentage_1 = Convert.ToDecimal(Percentage == "" ? "0" : Percentage);
                decimal? Amount_1 = Convert.ToDecimal(GlobalParams.RemoveCommas(Amount == "" ? "0" : Amount));

                List<Syn_Deal_Revenue_Commission> lstCostCommission = objSyn_Deal_Revenue.Syn_Deal_Revenue_Commission.Where(c => c.EntityState != State.Deleted).ToList();
                lstCostCommission.RemoveAt(rowIndex);

                int count = 0;
                if (ArrVendor_Entity_Code[1] == "L")
                {
                    count = (from commissionInstance in lstCostCommission
                             where commissionInstance.EntityState != State.Deleted &&
                                 //commissionInstance.Acq_Deal_Cost_Commission_Code != objADCC.Acq_Deal_Cost_Commission_Code &&
                             commissionInstance.Cost_Type_Code == Cost_Type_Code &&
                             commissionInstance.Vendor_Code == Vendor_Code &&
                             commissionInstance.Type == Type &&
                             commissionInstance.Commission_Type == CommType
                             select commissionInstance).Count();
                }
                else
                    if (ArrVendor_Entity_Code[1] == "O")
                    {
                        count = (from commissionInstance in lstCostCommission//objAcq_Deal_Cost.Acq_Deal_Cost_Commission
                                 where commissionInstance.EntityState != State.Deleted &&
                                     //commissionInstance.Acq_Deal_Cost_Commission_Code != objADCC.Acq_Deal_Cost_Commission_Code &&
                                 commissionInstance.Cost_Type_Code == Cost_Type_Code &&
                                 commissionInstance.Entity_Code == Entity_Code &&
                                 commissionInstance.Type == Type &&
                                 commissionInstance.Commission_Type == CommType
                                 select commissionInstance).Count();
                    }

                if (count > 0)
                {
                    objSyn_Deal_Revenue.StanddardReturnMessage = objMessageKey.CosttypeforthePartyisalreadyavailable;

                }
                else
                {
                    objADCC.Cost_Type_Code = Cost_Type_Code;
                    objADCC.Type = Type;

                    if (ArrVendor_Entity_Code[1] == "L")
                        objADCC.Vendor_Code = Vendor_Code;
                    else
                        if (ArrVendor_Entity_Code[1] == "O")
                            objADCC.Entity_Code = Entity_Code;

                    objADCC.Commission_Type = CommType;
                    objADCC.Percentage = Percentage_1;
                    objADCC.Amount = Amount_1;

                    if (objADCC.Syn_Deal_Revenue_Commission_Code > 0)
                        objADCC.EntityState = State.Modified;

                    ViewBag.IsAddEditMode = "";
                    BindTotalLabels();
                }
            }

            return PartialView("~/Views/Syn_Deal/_Standard_Returns.cshtml", objSyn_Deal_Revenue);
        }

        [HttpPost]
        public PartialViewResult DeleteStandardReturns(int rowIndex)
        {
            rowIndex = rowIndex - 1;

            Syn_Deal_Revenue_Commission objADCC = objSyn_Deal_Revenue.Syn_Deal_Revenue_Commission.Where(c => c.EntityState != State.Deleted).ElementAt(rowIndex);
            if (objADCC.Syn_Deal_Revenue_Commission_Code > 0)
                objADCC.EntityState = State.Deleted;
            else
                objSyn_Deal_Revenue.Syn_Deal_Revenue_Commission.Remove(objADCC);

            BindTotalLabels();
            return PartialView("~/Views/Syn_Deal/_Standard_Returns.cshtml", objSyn_Deal_Revenue);
        }

        [HttpPost]
        public PartialViewResult AddCancelStandardReturns(string isAdd)
        {
            ViewBag.AcqDealEntityCode = 0;
            ViewBag.CostTypeCode = null;
            ViewBag.SynDealRevenueCommissionCode = 0;
            ViewBag.CommissionType = "";
            ViewBag.EntityType = "";
            BindDropDownForSR(0, 0);
            BindRadionForCommissionType();
            if (isAdd == "1")
                ViewBag.IsAddEditMode = "Y";
            else
                ViewBag.IsAddEditMode = "";
            BindTotalLabels();
            return PartialView("~/Views/Syn_Deal/_Standard_Returns.cshtml", objSyn_Deal_Revenue);

        }

        private void BindRadionForCommissionType()
        {
            SelectListItem liCost = new SelectListItem() { Value = "C", Text = objMessageKey.Cost, Selected = true };
            SelectListItem liTR = new SelectListItem() { Value = "R", Text = objMessageKey.TheatricalRevenue, Selected = false };
            SelectListItem liROI = new SelectListItem() { Value = "O", Text = objMessageKey.ROI, Selected = false };
            List<SelectListItem> lstCommType = new List<SelectListItem>();
            lstCommType.Add(liCost);
            lstCommType.Add(liTR);
            lstCommType.Add(liROI);
            ViewBag.Commision_Type = lstCommType;
        }

        public JsonResult BindGridStandardReturns()
        {
            return Json(objSyn_Deal_Revenue);
        }
        #endregion

        #region "---------------Grid Overflow---------------"
        private void BindVariableType()
        {
            SelectListItem liP = new SelectListItem() { Value = "P", Text = objMessageKey.ProfitSharing, Selected = true };
            SelectListItem liR = new SelectListItem() { Value = "R", Text = objMessageKey.RevenueSharing, Selected = false };
            SelectListItem liN = new SelectListItem() { Value = "N", Text = objMessageKey.NA, Selected = false };
            List<SelectListItem> lstVarType = new List<SelectListItem>();
            lstVarType.Add(liP);
            lstVarType.Add(liR);
            lstVarType.Add(liN);
            ViewBag.VariableType = lstVarType;
        }

        private void BindVariableCost()
        {
            List<Syn_Deal_Revenue_Variable_Cost> arrDealMovieCostVariableCost = new List<Syn_Deal_Revenue_Variable_Cost>();

            Entity objEntity = new Entity();
            objEntity.IntCode = Convert.ToInt32(objLoginUser.Default_Entity_Code);
            objEntity.Fetch();
            Syn_Deal_Revenue_Variable_Cost objDealMovieCostVariableCostNew = new Syn_Deal_Revenue_Variable_Cost();
            objDealMovieCostVariableCostNew.Amount = 0;
            objDealMovieCostVariableCostNew.Inserted_By = objLoginUser.Users_Code;
            objDealMovieCostVariableCostNew.Last_Action_By = objLoginUser.Users_Code;
            objDealMovieCostVariableCostNew.Entity_Code = objEntity.IntCode;
            arrDealMovieCostVariableCost.Add(objDealMovieCostVariableCostNew);

            if (objSyn_Deal.Vendor_Code.HasValue)
            {
                Syn_Deal_Revenue_Variable_Cost objDealMovieCostVariableCost = new Syn_Deal_Revenue_Variable_Cost();
                objDealMovieCostVariableCost.Amount = 0;
                objDealMovieCostVariableCost.Percentage = objDealMovieCostVariableCost.Percentage;
                objDealMovieCostVariableCost.Inserted_By = objLoginUser.Users_Code;
                objDealMovieCostVariableCost.Last_Action_By = objLoginUser.Users_Code;
                objDealMovieCostVariableCost.Vendor_Code = objSyn_Deal.Vendor_Code;
                arrDealMovieCostVariableCost.Add(objDealMovieCostVariableCost);
            }

            ViewBag.VariableCostList = arrDealMovieCostVariableCost;
            ViewBag.Mode = objDeal_Schema.Mode;
            if (objSyn_Deal_Revenue.Variable_Cost_Type == null)
                ViewBag.Variable_Cost_Type = "N";
            else
                ViewBag.Variable_Cost_Type = objSyn_Deal_Revenue.Variable_Cost_Type;


        }

        [HttpPost]
        public PartialViewResult ReBindVariableCost(string VarCostType)
        {
            if (VarCostType == "N")
            {
                ViewBag.VariableCostList = new List<Syn_Deal_Revenue_Variable_Cost>();
                foreach (Syn_Deal_Revenue_Variable_Cost variableCostInstance in objSyn_Deal_Revenue.Syn_Deal_Revenue_Variable_Cost)
                {
                    variableCostInstance.EntityState = State.Deleted;
                }
            }
            else
            {
                if (objSyn_Deal_Revenue.Syn_Deal_Revenue_Variable_Cost.Count != 0)
                {
                    foreach (Syn_Deal_Revenue_Variable_Cost variableCostInstance in objSyn_Deal_Revenue.Syn_Deal_Revenue_Variable_Cost)
                    {
                        variableCostInstance.Percentage = 0;
                        variableCostInstance.EntityState = State.Modified;
                    }
                    ViewBag.VariableCostList = objSyn_Deal_Revenue.Syn_Deal_Revenue_Variable_Cost.ToList();
                }
                else
                    BindVariableCost();
            }
            ViewBag.Mode = objDeal_Schema.Mode;
            BindVariableType();
            if (objSyn_Deal_Revenue.Variable_Cost_Type == null)
                ViewBag.Variable_Cost_Type = "N";
            else
                ViewBag.Variable_Cost_Type = objSyn_Deal_Revenue.Variable_Cost_Type;
            return PartialView("~/Views/Syn_Deal/_Overflow.cshtml");
        }

        #endregion

        public JsonResult SaveDealCost(string TitleCodes, string DealCost, int recoupmentCode, string VariableCostType, List<Syn_Deal_Revenue_Variable_Cost> VariableCostRows)
        {
            string strViewBagMsg = "";
            double strDealCost = 0;
            strDealCost = GlobalParams.RemoveCommas(DealCost.Trim() == "" ? "0" : DealCost);
            objSyn_Deal_Revenue.Syn_Deal_Code = objDeal_Schema.Deal_Code;
            objSyn_Deal_Revenue.Currency_Code = objSyn_Deal.Currency_Code;
            objSyn_Deal_Revenue.Currency_Exchange_Rate = Convert.ToDecimal(objSyn_Deal.Exchange_Rate);
            objSyn_Deal_Revenue.Deal_Cost = Convert.ToDecimal(strDealCost);
            objSyn_Deal_Revenue.Deal_Cost_Per_Episode = Convert.ToDecimal(strDealCost);
            objSyn_Deal_Revenue.Cost_Center_Id = null;
            objSyn_Deal_Revenue.Variable_Cost_Type = VariableCostType;
            objSyn_Deal_Revenue.Variable_Cost_Sharing_Type = "L";
            objSyn_Deal_Revenue.Royalty_Recoupment_Code = (recoupmentCode > 0 ? Convert.ToInt32(recoupmentCode) : (int?)null);

            if (objSyn_Deal_Revenue.Syn_Deal_Revenue_Code > 0)
            {
                objSyn_Deal_Revenue.Last_Action_By = objLoginUser.Users_Code;
                objSyn_Deal_Revenue.Last_Updated_Time = DBUtil.getServerDate();
                objSyn_Deal_Revenue.EntityState = State.Modified;
                strViewBagMsg = objMessageKey.Revenueupdatedsuccessfully;
            }
            else
            {
                objSyn_Deal_Revenue.Inserted_On = DBUtil.getServerDate();
                objSyn_Deal_Revenue.Inserted_By = objLoginUser.Users_Code;
                objSyn_Deal_Revenue.EntityState = State.Added;
                strViewBagMsg = objMessageKey.Revenueaddedsuccessfully;
            }
            List<string> arrTitleCode = TitleCodes.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList();
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                List<int> lstTitleCode = objDeal_Schema.Title_List.Where(x => arrTitleCode.Contains(x.Acq_Deal_Movie_Code.ToString())).Select(x => x.Title_Code).ToList();
                foreach (Syn_Deal_Revenue_Title titleInstance in objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Where(t => lstTitleCode.Contains(t.Title_Code.Value)))
                {
                    titleInstance.EntityState = State.Modified;
                }
                foreach (Syn_Deal_Revenue_Title titleInstance in objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Where(t => !lstTitleCode.Contains(t.Title_Code.Value)))
                {
                    titleInstance.EntityState = State.Deleted;
                }
            }
            else
            {
                foreach (Syn_Deal_Revenue_Title titleInstance in objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Where(t => arrTitleCode.Contains(t.Title_Code.Value.ToString())))
                {
                    titleInstance.EntityState = State.Modified;
                }
                foreach (Syn_Deal_Revenue_Title titleInstance in objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Where(t => !arrTitleCode.Contains(t.Title_Code.Value.ToString())))
                {
                    titleInstance.EntityState = State.Deleted;
                }
            }
            foreach (string strTitleCode in arrTitleCode)
            {
                int titleCode = strTitleCode == "" ? 0 : Convert.ToInt32(strTitleCode.Trim());
                if (titleCode > 0)
                {
                    Syn_Deal_Revenue_Title objADCT = new Syn_Deal_Revenue_Title();
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    {
                        Title_List objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == titleCode).FirstOrDefault();
                        if (objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Where(w => w.Title_Code == objTL.Title_Code && w.Episode_From == objTL.Episode_From &&
                            w.Episode_To == objTL.Episode_To).Count() == 0)
                        {
                            objADCT.Title_Code = objTL.Title_Code;
                            objADCT.Episode_From = objTL.Episode_From;
                            objADCT.Episode_To = objTL.Episode_To;
                            objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Add(objADCT);
                        }
                    }
                    else
                    {
                        if (objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Where(t => t.Title_Code == titleCode).Count() == 0)
                        {
                            objADCT.Title_Code = titleCode;
                            objADCT.Episode_From = 1;
                            objADCT.Episode_To = 1;
                            objSyn_Deal_Revenue.Syn_Deal_Revenue_Title.Add(objADCT);
                        }
                    }
                }
            }

            if (VariableCostType == "N")
            {

                Syn_Deal_Revenue_Variable_Cost variableCostInstance;

            }
            else
            {
                foreach (Syn_Deal_Revenue_Variable_Cost objADM_MVC in VariableCostRows)
                {
                    int variableCostCode = Convert.ToInt32(objADM_MVC.Syn_Deal_Revenue_Variable_Cost_Code);
                    Syn_Deal_Revenue_Variable_Cost variableCostInstance;

                    if (variableCostCode > 0)
                    {
                        variableCostInstance = objSyn_Deal_Revenue.Syn_Deal_Revenue_Variable_Cost.Where(v => v.Syn_Deal_Revenue_Variable_Cost_Code == variableCostCode).SingleOrDefault();
                        variableCostInstance.Last_Action_By = objLoginUser.Users_Code;
                        variableCostInstance.Last_Updated_Time = DBUtil.getServerDate();
                        variableCostInstance.EntityState = State.Modified;
                    }
                    else
                    {
                        variableCostInstance = new Syn_Deal_Revenue_Variable_Cost();
                        variableCostInstance.Inserted_By = objLoginUser.Users_Code;
                        variableCostInstance.Inserted_On = DBUtil.getServerDate();
                    }
                    if (objADM_MVC.Entity_Code > 0)
                        variableCostInstance.Entity_Code = Convert.ToInt32(objADM_MVC.Entity_Code);
                    else
                        variableCostInstance.Vendor_Code = Convert.ToInt32(objADM_MVC.Vendor_Code);
                    if (string.IsNullOrEmpty(Convert.ToString(objADM_MVC.Percentage)))
                        variableCostInstance.Percentage = 0;
                    else
                        variableCostInstance.Percentage = Convert.ToDecimal(objADM_MVC.Percentage);
                    variableCostInstance.Amount = 0;
                    objSyn_Deal_Revenue.Syn_Deal_Revenue_Variable_Cost.Add(variableCostInstance);

                }
            }

            foreach (Syn_Deal_Revenue_Costtype costTypeInstance in objSyn_Deal_Revenue.Syn_Deal_Revenue_Costtype.Where(c => c.EntityState != State.Deleted))
            {
                if (costTypeInstance.Syn_Deal_Revenue_Costtype_Code > 0)
                    costTypeInstance.EntityState = State.Modified;
            }
            foreach (Syn_Deal_Revenue_Additional_Exp additionalExpInstance in objSyn_Deal_Revenue.Syn_Deal_Revenue_Additional_Exp.Where(ae => ae.EntityState != State.Deleted))
            {
                if (additionalExpInstance.Syn_Deal_Revenue_Additional_Exp_Code > 0)
                    additionalExpInstance.EntityState = State.Modified;
            }
            foreach (Syn_Deal_Revenue_Commission commissionInstance in objSyn_Deal_Revenue.Syn_Deal_Revenue_Commission.Where(c => c.EntityState != State.Deleted))
            {
                if (commissionInstance.Syn_Deal_Revenue_Commission_Code > 0)
                    commissionInstance.EntityState = State.Modified;
            }
            dynamic resultSet;
            objSyn_Deal_Revenue_Service.Save(objSyn_Deal_Revenue, out resultSet);
            string a = resultSet;

            BindTotalDealCost();
            ClearSession();

            string TotalFixedDealCost = BindTotalDealCost();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strViewBagMsg);
            obj.Add("TotalFixedDealCost", TotalFixedDealCost);
            return Json(obj);
        }

        #endregion

    }
}
