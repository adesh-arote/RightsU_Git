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
    public class Acq_CostController : BaseController
    {
        #region --- Attributes & Properties ---


        private List<RightsU_Entities.Acq_Deal_Cost_Costtype_Episode> lstAcq_Deal_Cost_Costtype_Episode
        {
            get
            {
                if (Session["lstAcq_Deal_Cost_Costtype_Episode"] == null)
                    Session["lstAcq_Deal_Cost_Costtype_Episode"] = new List<RightsU_Entities.Acq_Deal_Cost_Costtype_Episode>();
                return (List<RightsU_Entities.Acq_Deal_Cost_Costtype_Episode>)Session["lstAcq_Deal_Cost_Costtype_Episode"];
            }
            set { Session["lstAcq_Deal_Cost_Costtype_Episode"] = value; }
        }

        private List<RightsU_Entities.Acq_Deal_Cost_Costtype_Episode> lstAcq_Deal_Cost_Costtype_Episode_Searched
        {
            get
            {
                if (Session["lstAcq_Deal_Cost_Costtype_Episode_Searched"] == null)
                    Session["lstAcq_Deal_Cost_Costtype_Episode_Searched"] = new List<RightsU_Entities.Acq_Deal_Cost_Costtype_Episode>();
                return (List<RightsU_Entities.Acq_Deal_Cost_Costtype_Episode>)Session["lstAcq_Deal_Cost_Costtype_Episode_Searched"];
            }
            set { Session["lstAcq_Deal_Cost_Costtype_Episode_Searched"] = value; }
        }


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

        public Acq_Deal_Cost objAcq_Deal_Cost
        {
            get
            {
                if (Session["Acq_Deal_Cost"] == null)
                    Session["Acq_Deal_Cost"] = new Acq_Deal_Cost();
                return (Acq_Deal_Cost)Session["Acq_Deal_Cost"];
            }
            set { Session["Acq_Deal_Cost"] = value; }
        }

        public Acq_Deal_Cost_Service objAcq_Deal_Cost_Service
        {
            get
            {
                if (Session["Acq_Deal_Cost_Service"] == null)
                    Session["Acq_Deal_Cost_Service"] = new Acq_Deal_Cost_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Cost_Service)Session["Acq_Deal_Cost_Service"];
            }
            set { Session["Acq_Deal_Cost_Service"] = value; }
        }

        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[UtoSession.ACQ_DEAL_SCHEMA] == null)
                    Session[UtoSession.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[UtoSession.ACQ_DEAL_SCHEMA];
            }
            set { Session[UtoSession.ACQ_DEAL_SCHEMA] = value; }
        }

        public Acq_Deal_Service objADS
        {
            get
            {
                if (Session["ADS_Acq_General"] == null)
                    Session["ADS_Acq_General"] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Service)Session["ADS_Acq_General"];
            }
            set { Session["ADS_Acq_General"] = value; }
        }

        public Acq_Deal objAcq_Deal
        {
            get
            {
                if (Session[UtoSession.SESS_DEAL] == null)
                    Session[UtoSession.SESS_DEAL] = new Acq_Deal();
                return (Acq_Deal)Session[UtoSession.SESS_DEAL];
            }
            set { Session[UtoSession.SESS_DEAL] = value; }
        }

        #endregion

        #region --- Page Load / List Page --
        public PartialViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            objAcq_Deal = objADS.GetById(objDeal_Schema.Deal_Code);
            objDeal_Schema.Page_From = GlobalParams.Page_From_Cost;

            //System_Parameter_New_Service objSystem_Parameter_New_Service = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            //System_Parameter_New objSystem_Parameter_New = new System_Parameter_New();
            //objSystem_Parameter_New = objSystem_Parameter_New_Service.SearchFor(x => x.Parameter_Name == "Direct_Cost_Grid").FirstOrDefault();
            //if (objSystem_Parameter_New != null)
            //{
            //    if (objSystem_Parameter_New.Parameter_Value == "Y")
            //    {
            //        return RedirectToAction("Index", "Acq_Cost_New");
            //    }
            //}

            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            ViewBag.Currency = Convert.ToString(objAcq_Deal.Currency.Currency_Name);
            ViewBag.CurrencyExchangeRate = objAcq_Deal.Exchange_Rate;
            ViewBag.TotalFixedDealCost = BindTotalDealCost();
            ViewBag.Approver_Remark = objDeal_Schema.Approver_Remark;
            Mode = objDeal_Schema.Mode;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;

            return PartialView("~/Views/Acq_Deal/_Acq_Cost_List.cshtml");
        }
        [HttpPost]
        public PartialViewResult BindGridAcqDealCost(int txtPageSize, int page_No)
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
            PageNo = page_No + 1;
            ICollection<Acq_Deal_Cost> pagedList = objAcq_Deal_Cost_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Cost_Code).ToList();
            ICollection<Acq_Deal_Cost> list;
            
            if (PageNo == 1)
                list = pagedList.Take(pageSize).ToList();
            else
            {
                
                list = pagedList.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (list.Count == 0)
                {
                    if (PageNo != 1)
                    {
                        objDeal_Schema.Cost_PageNo = PageNo - 1;
                        PageNo = PageNo - 1;
                    }
                    list = pagedList.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }

            ViewBag.RecordCount = objAcq_Deal_Cost_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Count();
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = txtPageSize;
            Mode = objDeal_Schema.Mode;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;

            return PartialView("~/Views/Acq_Deal/_List_Cost.cshtml", list.Where(i => i.EntityState != State.Deleted).ToList());
        }
        private string BindTotalDealCost()
        {
            ICollection<Acq_Deal_Cost> lst_Acq_Deal_Cost = objAcq_Deal_Cost_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).ToList();
            decimal TotalCost = Convert.ToDecimal((from Acq_Deal_Cost objDealCost in lst_Acq_Deal_Cost
                                                   select objDealCost.Deal_Cost).Sum());
            return GlobalParams.CurrencyFormat((double)TotalCost);
        }
        public JsonResult DeleteRecord(int costCodeId)
        {
            Acq_Deal_Service objADS = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
            string strMessage = "Y";
            objAcq_Deal = objADS.GetById(objDeal_Schema.Deal_Code);
            Acq_Deal_Cost costInstance = objAcq_Deal_Cost_Service.GetById(costCodeId);
            List<int> lstCostTypeCode = costInstance.Acq_Deal_Cost_Costtype.Select(r => (int)r.Cost_Type_Code).ToList();
            if (objAcq_Deal.Acq_Deal_Payment_Terms.Where(p => lstCostTypeCode.Contains((int)p.Cost_Type_Code)).Count() > 0)
            {
                strMessage = "N";
            }
            else
            {
                foreach (Acq_Deal_Cost_Additional_Exp additionalExpInstance in costInstance.Acq_Deal_Cost_Additional_Exp)
                {
                    additionalExpInstance.EntityState = State.Deleted;
                }
                foreach (Acq_Deal_Cost_Commission commissionInstance in costInstance.Acq_Deal_Cost_Commission)
                {
                    commissionInstance.EntityState = State.Deleted;
                }
                foreach (Acq_Deal_Cost_Costtype costTypeInstance in costInstance.Acq_Deal_Cost_Costtype)
                {
                    foreach (Acq_Deal_Cost_Costtype_Episode costTypeInstance_ESP in costTypeInstance.Acq_Deal_Cost_Costtype_Episode)
                    {
                        costTypeInstance_ESP.EntityState = State.Deleted;
                    }
                    costTypeInstance.EntityState = State.Deleted;
                }
                foreach (Acq_Deal_Cost_Title titleInstance in costInstance.Acq_Deal_Cost_Title)
                {
                    titleInstance.EntityState = State.Deleted;
                }
                foreach (Acq_Deal_Cost_Variable_Cost variableCostInstance in costInstance.Acq_Deal_Cost_Variable_Cost)
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
        private void Save(Acq_Deal_Cost costInstance)//Final Save
        {
            dynamic resultSet;
            objAcq_Deal_Cost_Service.Save(costInstance, out resultSet);
            string strResult = resultSet;

            objAcq_Deal_Cost_Service = null;
        }
        public JsonResult SaveDeal(string hdnCurrencyExchangeRate, string hdnTabName, string hdnReopenMode = "")
        {
            string msg = "", mode = "", status = "S";
            if (hdnReopenMode == "RO")
            {
                mode = GlobalParams.DEAL_MODE_EDIT;
                status = "SA";
            }
            else
                mode = objDeal_Schema.Mode;

            if (mode == GlobalParams.DEAL_MODE_REOPEN)
            {
                objDeal_Schema.Deal_Workflow_Flag = objAcq_Deal.Deal_Workflow_Status = Convert.ToString(mode).Trim();
            }
            string txtCurrencyExchangeRate = hdnCurrencyExchangeRate;
            dynamic resultSet;
            if (txtCurrencyExchangeRate != "")
            {
                string strExchangeRate = txtCurrencyExchangeRate.Trim() == "." ? "0" : txtCurrencyExchangeRate;
                if (objAcq_Deal.Exchange_Rate != Convert.ToDecimal(strExchangeRate))
                {
                    //objAcq_Deal.Exchange_Rate = Convert.ToDecimal(strExchangeRate);
                    //objAcq_Deal.EntityState = State.Modified;

                    Acq_Deal objAcq = objADS.GetById(objAcq_Deal.Acq_Deal_Code);
                    objAcq.Exchange_Rate = Convert.ToDecimal(strExchangeRate);
                    objAcq.EntityState = State.Modified;
                    objADS.Save(objAcq, out resultSet);
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
                    // return RedirectToAction("Index", "Acq_List");

                    string Mode = objDeal_Schema.Mode;
                    TempData["RedirectAcqDeal"] = objAcq_Deal;
                    msg = objMessageKey.DealSavedSuccessfully;
                    if (Mode == GlobalParams.DEAL_MODE_EDIT)
                        msg = objMessageKey.DealUpdatedSuccessfully;

                }
                //ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "RL", "ReleaseRecordLock();", true);
            }

            //Session[UtoSession.SESS_DEAL] = null;
            //objDeal_Schema = null;
            int pageNo = objDeal_Schema.PageNo;

            string redirectUrl = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetRedirectURL(hdnTabName, pageNo, null, objDeal_Schema.Deal_Type_Code);

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Success_Message", msg);
            obj.Add("Redirect_URL", redirectUrl);
            return Json(obj);

            //   return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, pageNo, objDeal_Schema.Deal_Type_Code);
        }
        public ActionResult Cancel()
        {
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
            ClearSession();
            objDeal_Schema = null;
            Session[UtoSession.SESS_DEAL] = null;
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                return RedirectToAction("Index", "Acq_List", new { Page_No = pageNo, ReleaseRecord = "Y" });
            }
        }
        #endregion

        #region --- Add / Edit Cost ---

        public void BindHeaderData()
        {
            Session[UtoSession.SESS_DEAL] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            objAcq_Deal = (Acq_Deal)Session[UtoSession.SESS_DEAL];
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
        public PartialViewResult PartialAddEditDealCost(int AcqDealCostCode, string ExchangeRate, string CommandName, int DTC, int PageSize)
        {
            ClearSession();
            objAcq_Deal_Cost = objAcq_Deal_Cost_Service.GetById(AcqDealCostCode);
            dynamic resultSet;
            if (ExchangeRate != "")
            {
                string strExchangeRate = ExchangeRate.Trim() == "." ? "0" : ExchangeRate;
                if (objAcq_Deal.Exchange_Rate != Convert.ToDecimal(strExchangeRate))
                {
                    Acq_Deal objAcq = objADS.GetById(objAcq_Deal.Acq_Deal_Code);
                    objAcq.Exchange_Rate = Convert.ToDecimal(strExchangeRate);
                    objAcq.EntityState = State.Modified;
                    objADS.Save(objAcq, out resultSet);
                }
            }
            if (CommandName == "Add")
                objAcq_Deal_Cost.HeaderLabel = "Add Cost";
            else if (CommandName == "Edit")
                objAcq_Deal_Cost.HeaderLabel = "Edit Cost";
            else if (CommandName == "View")
            {
                string movieName = String.Empty;
                objAcq_Deal_Cost.HeaderLabel = "View Cost";
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program)
                    movieName = string.Join(", ", objAcq_Deal_Cost.Acq_Deal_Cost_Title.Select(s => s.Title.Title_Name + " ( " + s.Episode_From + " - " + s.Episode_To + " )").ToArray());
                else
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                        movieName = string.Join(", ", objAcq_Deal_Cost.Acq_Deal_Cost_Title.Select(s => s.Title.Title_Name + " ( " + s.Episode_From + " )").ToArray());
                    else
                        movieName = string.Join(", ", objAcq_Deal_Cost.Acq_Deal_Cost_Title.Select(s => s.Title.Title_Name).ToArray());
                ViewBag.VariableCostList = objAcq_Deal_Cost.Acq_Deal_Cost_Variable_Cost.ToList();
                ViewBag.MovieName = movieName;
                if (objAcq_Deal_Cost.Royalty_Recoupment_Code != null)
                {
                    Royalty_Recoupment_Service objRRS = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
                    ViewBag.Royalty_Recoupment_Name = objRRS.GetById(Convert.ToInt32(objAcq_Deal_Cost.Royalty_Recoupment_Code)).Royalty_Recoupment_Name;
                }
                else
                    ViewBag.Royalty_Recoupment_Name = "No Recoupment";
            }
            ViewBag.PageSize = PageSize;
            ViewBag.DealTypeCode = DTC;
            ViewBag.Currency = Convert.ToString(objAcq_Deal.Currency.Currency_Name);
            ViewBag.CurrencyExchangeRate = objAcq_Deal.Exchange_Rate;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            Mode = objDeal_Schema.Mode;
            ViewBag.Mode = objDeal_Schema.Mode;
            return PartialView("~/Views/Acq_Deal/_Acq_Cost.cshtml", objAcq_Deal_Cost);
        }
        [HttpPost]
        public PartialViewResult Load_Cost_Type(int Deal_Type_Code = 0)
        {
            double doublesumCostTypeAmount = (double)(from Acq_Deal_Cost_Costtype obj in objAcq_Deal_Cost.Acq_Deal_Cost_Costtype where obj.EntityState != State.Deleted select obj.Amount).Sum();
            ViewBag.TotalCostType = GlobalParams.CurrencyFormat(doublesumCostTypeAmount);
            SetCost_Type_Service();
            ViewBag.Mode = objDeal_Schema.Mode;
            ViewBag.DTC = Deal_Type_Code;
            return PartialView("~/Views/Acq_Deal/_Cost_Type.cshtml", objAcq_Deal_Cost);
        }
        public PartialViewResult Load_Additional_Exp()
        {
            double doublesumAdditionalAmount = (double)(from Acq_Deal_Cost_Additional_Exp obj in objAcq_Deal_Cost.Acq_Deal_Cost_Additional_Exp where obj.EntityState != State.Deleted select obj.Amount).Sum();
            ViewBag.TotalAdditionalExpense = GlobalParams.CurrencyFormat(doublesumAdditionalAmount);
            SetAdditional_Expense();
            ViewBag.Mode = objDeal_Schema.Mode;
            return PartialView("~/Views/Acq_Deal/_Additional_Exp.cshtml", objAcq_Deal_Cost);
        }
        public PartialViewResult Load_Standard_Returns()
        {
            double doublesumCommiAmount = (double)(from Acq_Deal_Cost_Commission obj in objAcq_Deal_Cost.Acq_Deal_Cost_Commission where obj.EntityState != State.Deleted select obj.Amount).Sum();
            ViewBag.TotalStandardReturns = GlobalParams.CurrencyFormat(doublesumCommiAmount);
            ViewBag.Mode = objDeal_Schema.Mode;
            return PartialView("~/Views/Acq_Deal/_Standard_Returns.cshtml", objAcq_Deal_Cost);
        }
        public PartialViewResult Load_Overflow()
        {
            if (objAcq_Deal != null)
                BindVariableType();
            if (objAcq_Deal_Cost.Variable_Cost_Type == null)
                ViewBag.Variable_Cost_Type = "N";
            else
                ViewBag.Variable_Cost_Type = objAcq_Deal_Cost.Variable_Cost_Type;
            ViewBag.VariableCostList = objAcq_Deal_Cost.Acq_Deal_Cost_Variable_Cost.ToList();
            //BindVariableCost();
            ViewBag.Mode = objDeal_Schema.Mode;
            return PartialView("~/Views/Acq_Deal/_Overflow.cshtml", objAcq_Deal_Cost);
        }

        public void ClearSession()
        {
            objAcq_Deal_Cost = null;
            Session["Acq_Deal_Cost_Service"] = null;
            Session["Acq_Deal_Cost"] = null;
            Session["Cost_Type"] = null;
            Session["Additional_Expense"] = null;
        }

        #region "---------------Bind Dropdowns ---------------"

        public JsonResult BindTitle()
        {
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            string dataTxtField;
            string dataValField;
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program)
            {
                dataTxtField = "Title_Name_Program";
                dataValField = "Acq_Deal_Movie_Code";
            }
            else if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                dataTxtField = "Title_Name_Music";
                dataValField = "Acq_Deal_Movie_Code";
            }
            else if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Movie)
            {
                dataTxtField = "Title_Name_Movie";
                dataValField = "Acq_Deal_Movie_Code";
            }
            else
            {
                dataTxtField = "Title_Name";
                dataValField = "Title_Code";
            }

            List<Title_List> lstCostAddedTitle = (from Acq_Deal_Cost objADC in objAcq_Deal.Acq_Deal_Cost
                                                  from Acq_Deal_Cost_Title objADCT in objADC.Acq_Deal_Cost_Title
                                                  select objADCT).Select(s => new Title_List() { Title_Code = (int)s.Title_Code, Episode_From = (int)s.Episode_From, Episode_To = (int)s.Episode_To }
                                                ).Distinct().ToList();

            List<Title_List> lstPopulate = objDeal_Schema.Title_List.Where(x => lstCostAddedTitle.Where(y => y.Title_Code == x.Title_Code
                && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() == 0).Distinct().ToList();


            lstPopulate.AddRange(objAcq_Deal_Cost.Acq_Deal_Cost_Title.Select(s => new Title_List() { Title_Code = (int)s.Title_Code, Episode_From = (int)s.Episode_From, Episode_To = (int)s.Episode_To }
            ));

            string selected_Title_Code = "";

            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Movie)
                selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
            else
                selected_Title_Code = string.Join(",", objAcq_Deal_Cost.Acq_Deal_Cost_Title.Select(t => t.Title_Code.ToString()).Distinct());

            Acq_Deal_Movie_Service objAcq_Deal_Movie_Service = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName);

            MultiSelectList lstTitle = new MultiSelectList(objAcq_Deal_Movie_Service.SearchFor(a => a.Acq_Deal_Code == objDeal_Schema.Deal_Code).ToList().Where(x => lstPopulate.
                Where(w => x.Episode_Starts_From == w.Episode_From && x.Episode_End_To == w.Episode_To && x.Title_Code == w.Title_Code).Count() > 0).
                    Select(s => new
                    {
                        Acq_Deal_Movie_Code = s.Acq_Deal_Movie_Code,
                        Title_Code = s.Title_Code,
                        Title_Name = s.Title.Title_Name,
                        Title_Name_Movie = s.Title.Title_Name,
                        Title_Name_Music = s.Title.Title_Name + " ( " + (Convert.ToString(s.Episode_Starts_From) == "0" ? "Unlimited" : Convert.ToString(s.Episode_Starts_From)) + " ) ",
                        Title_Name_Program = s.Title.Title_Name + " ( " + s.Episode_Starts_From + " - " + s.Episode_End_To + " ) "
                    }
            ).ToList().OrderBy(o => o.Title_Name), dataValField, dataTxtField, selected_Title_Code.Split(','));
            //return lstTitle;
            var arr = lstTitle;
            return Json(arr, JsonRequestBehavior.AllowGet);
        }

        public JsonResult BindRoyaltyRecoupment(int Royalty_Recoupment_Code)
        {
            Royalty_Recoupment_Service objRRS = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
            List<SelectListItem> lstRR = new SelectList(objRRS.SearchFor(x => x.Is_Active == "Y"), "Royalty_Recoupment_Code", "Royalty_Recoupment_Name", Royalty_Recoupment_Code).ToList();
            lstRR.Insert(0, new SelectListItem() { Value = "0", Text = "No Recoupment" });
            //return lstRR;
            var arr = lstRR;
            return Json(arr, JsonRequestBehavior.AllowGet);
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

        public void BindTotalLabels()
        {
            double doublesumCostTypeAmount = (double)(from Acq_Deal_Cost_Costtype obj in objAcq_Deal_Cost.Acq_Deal_Cost_Costtype where obj.EntityState != State.Deleted select obj.Amount).Sum();
            ViewBag.TotalCostType = GlobalParams.CurrencyFormat(doublesumCostTypeAmount);
        }

        #region "---------------Grid Cost Head(Cost_CostType) ---------------"

        private List<SelectListItem> BindddlCostType(int Cost_Type_Code)
        {

            //List<SelectListItem> lstCostType = new SelectList(objCost_Type_Service.SearchFor(x => x.Is_Active == "Y"), "Cost_Type_Code", "Cost_Type_Name", Cost_Type_Code.ToString()).ToList();
            string[] Selected_Cost_CostTypeCode = (
                                        from Acq_Deal_Cost_Costtype objTADCCT in objAcq_Deal_Cost.Acq_Deal_Cost_Costtype
                                        where objTADCCT.Cost_Type_Code != Cost_Type_Code && objTADCCT.EntityState != State.Deleted
                                        select objTADCCT.Cost_Type_Code.ToString()
                                        ).Distinct().ToArray();
            List<SelectListItem> lstCostType = new SelectList(from Cost_Type obj in objCost_Type
                                                              where !Selected_Cost_CostTypeCode.Contains(obj.Cost_Type_Code.ToString()) && obj.Is_Active == "Y"
                                                              select obj, "Cost_Type_Code", "Cost_Type_Name", Cost_Type_Code.ToString()).ToList();

            lstCostType.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect});
            return lstCostType;
        }

        [HttpPost]
        public PartialViewResult AddCancelCostType(string isAdd, int dealtc)
        {
            ViewBag.AcqDealCostTypeCode = 0;
            ViewBag.DdlCostType = BindddlCostType(0);
            if (isAdd == "1")
                ViewBag.IsAddEditMode = "Y";
            else
                ViewBag.IsAddEditMode = "";
            BindTotalLabels();
            ViewBag.DTC = dealtc;
            return PartialView("~/Views/Acq_Deal/_Cost_Type.cshtml", objAcq_Deal_Cost);

        }

        [HttpPost]
        public PartialViewResult EditCostType(int AcqDealCostTypeCode, int CostTypeCode, int dealtc)
        {
            ViewBag.DTC = dealtc;
            ViewBag.IsAddEditMode = "Y";
            ViewBag.AcqDealCostTypeCode = CostTypeCode;
            ViewBag.DdlCostType = BindddlCostType(CostTypeCode);
            ViewBag.IsRefPayTerm = false;
            if (objAcq_Deal.Acq_Deal_Payment_Terms.Where(p => CostTypeCode == (int)p.Cost_Type_Code).Count() > 0)
            {
                ViewBag.IsRefPayTerm = true;
            }
            BindTotalLabels();
            return PartialView("~/Views/Acq_Deal/_Cost_Type.cshtml", objAcq_Deal_Cost);
        }

        [HttpPost]
        public PartialViewResult SaveCostType(int AcqDealCostTypeCode, int CostTypeCode, string BudgetedAmt, int rowIndex, int dealtc, string key, int Deal_Movie_Code = 0)
        {
            if (rowIndex == 0)
            {

                var a = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Movie_Code == Deal_Movie_Code).FirstOrDefault();
                Acq_Deal_Cost_Costtype_Episode objAcq_Deal_Cost_Costtype_Episode = new Acq_Deal_Cost_Costtype_Episode();
                objAcq_Deal_Cost_Costtype_Episode.Episode_From = a.Episode_Starts_From;
                objAcq_Deal_Cost_Costtype_Episode.Episode_To = a.Episode_End_To;
                objAcq_Deal_Cost_Costtype_Episode.Amount_Type = "P";
                objAcq_Deal_Cost_Costtype_Episode.Amount = Convert.ToDecimal(BudgetedAmt);
                objAcq_Deal_Cost_Costtype_Episode.Percentage = 100;
                var Episode_Count = objAcq_Deal_Cost_Costtype_Episode.Episode_To - objAcq_Deal_Cost_Costtype_Episode.Episode_From;
                Episode_Count = Episode_Count + 1;
                objAcq_Deal_Cost_Costtype_Episode.Per_Eps_Amount = objAcq_Deal_Cost_Costtype_Episode.Amount / Episode_Count;
                objAcq_Deal_Cost_Costtype_Episode.EntityState = State.Added;


                Acq_Deal_Cost_Costtype objADCCT = new Acq_Deal_Cost_Costtype();
                objADCCT.Cost_Type_Code = Convert.ToInt32(CostTypeCode);
                objADCCT.Consumed_Amount = Convert.ToDecimal(BudgetedAmt);
                objADCCT.Amount = Convert.ToDecimal(BudgetedAmt);
                SetCost_Type_Service();
                objADCCT.Inserted_On = DBUtil.getServerDate();
                objADCCT.Inserted_By = objLoginUser.Users_Code;
                objADCCT.EntityState = State.Added;
                objADCCT.Acq_Deal_Cost_Costtype_Episode.Add(objAcq_Deal_Cost_Costtype_Episode);
                objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Add(objADCCT);

                //hdnCostNAmt.Value = string.Empty;
                //foreach (Acq_Deal_Cost_Costtype obj in objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(c => c.EntityState != State.Deleted))
                //{
                //    if (hdnCostNAmt.Value == string.Empty)
                //        hdnCostNAmt.Value = obj.Cost_Type_Code.ToString() + "~" + obj.Amount.ToString();
                //    else
                //        hdnCostNAmt.Value = hdnCostNAmt.Value + "#" + obj.Cost_Type_Code.ToString() + "~" + obj.Amount.ToString();

                //}

            }
            else
            {
                rowIndex = rowIndex - 1;
                Acq_Deal_Cost_Costtype objADCCT = objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(c => c.EntityState != State.Deleted).ElementAt(rowIndex);
                //objADCCT.Cost_Type.Cost_Type_Name = (from Cost_Type objCT in objCost_Type
                //                                     where objCT.Cost_Type_Code == CostTypeCode
                //                                     select objCT.Cost_Type_Name).FirstOrDefault();
                objADCCT.Cost_Type_Code = Convert.ToInt32(CostTypeCode);
                objADCCT.Consumed_Amount = Convert.ToDecimal(BudgetedAmt);
                objADCCT.Amount = Convert.ToDecimal(BudgetedAmt);


                if (objADCCT.Acq_Deal_Cost_Costtype_Code > 0)
                    objADCCT.EntityState = State.Modified;
                else
                    objADCCT.EntityState = State.Added;
                //hdnCostNAmt.Value = string.Empty;
                //foreach (Acq_Deal_Cost_Costtype obj in objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(c => c.EntityState != State.Deleted))
                //{
                //    if (hdnCostNAmt.Value == string.Empty)
                //        hdnCostNAmt.Value = obj.Cost_Type_Code.ToString() + "~" + obj.Amount.ToString();
                //    else
                //        hdnCostNAmt.Value = hdnCostNAmt.Value + "#" + obj.Cost_Type_Code.ToString() + "~" + obj.Amount.ToString();

                //}

            }
            BindTotalLabels();
            ViewBag.IsAddEditMode = "";
            ViewBag.DTC = dealtc;
            return PartialView("~/Views/Acq_Deal/_Cost_Type.cshtml", objAcq_Deal_Cost);
        }

        [HttpPost]
        public PartialViewResult DeleteCostType(int AcqDealCostTypeCode, int rowIndex, int dealtc)
        {
            ViewBag.CTMessage = "";
            rowIndex = rowIndex - 1;
            Acq_Deal_Cost_Costtype objADCCT = objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(c => c.EntityState != State.Deleted).ElementAt(rowIndex);
            if (objAcq_Deal.Acq_Deal_Payment_Terms.Where(p => objADCCT.Cost_Type_Code == (int)p.Cost_Type_Code).Count() > 0)
            {
                ViewBag.CTMessage = objMessageKey.ThisCostheadisalreadyassignedtoPaymentTerm;
            }
            else
            {
                if (objADCCT.Acq_Deal_Cost_Costtype_Code > 0)
                    objADCCT.EntityState = State.Deleted;
                else
                    objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Remove(objADCCT);
            }
            ViewBag.DTC = dealtc;
            BindTotalLabels();
            return PartialView("~/Views/Acq_Deal/_Cost_Type.cshtml", objAcq_Deal_Cost);
        }

        #endregion

        #region------------------Episode Cost------------------
        public PartialViewResult AddEditEpisodeCost(int AcqDealCostTypeCode, int rowIndex, int CostTypeCode, int TitleCode, double Amount = 0)
        {
            Acq_Deal_Movie lst_Acq_Deal_Movie = new Acq_Deal_Movie();
            if (objDeal_Schema.Deal_Type_Condition.ToString() == "Sub_Deal_Talent")
                lst_Acq_Deal_Movie = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == TitleCode && x.Acq_Deal_Code == objAcq_Deal.Acq_Deal_Code).FirstOrDefault();
            else
                lst_Acq_Deal_Movie = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Movie_Code == TitleCode).FirstOrDefault();
            ViewBag.Mode = objDeal_Schema.Mode;
            ViewBag.AcqDealCostTypeCode = AcqDealCostTypeCode;
            ViewBag.rowIndex = rowIndex;
            ViewBag.Amount = Amount;
            ViewBag.Episode_Starts_From = lst_Acq_Deal_Movie.Episode_Starts_From;
            ViewBag.Titel_Name = lst_Acq_Deal_Movie.Title.Title_Name;
            ViewBag.Episode_End_To = lst_Acq_Deal_Movie.Episode_End_To;
            if (AcqDealCostTypeCode != 0)
            {
                lstAcq_Deal_Cost_Costtype_Episode_Searched = lstAcq_Deal_Cost_Costtype_Episode =
                objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(x => x.Acq_Deal_Cost_Costtype_Code == AcqDealCostTypeCode).FirstOrDefault().Acq_Deal_Cost_Costtype_Episode.Where(x => x.EntityState != State.Deleted).ToList();
            }
            else
            {
                lstAcq_Deal_Cost_Costtype_Episode_Searched = lstAcq_Deal_Cost_Costtype_Episode = objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.ElementAt(rowIndex - 1).Acq_Deal_Cost_Costtype_Episode.Where(x => x.EntityState != State.Deleted).ToList();
            }
            return PartialView("~/Views/Acq_Deal/_Episode_Cost.cshtml");
        }

        public PartialViewResult BindEpisodeCostView()
        {
            List<RightsU_Entities.Acq_Deal_Cost_Costtype_Episode> lst = new List<RightsU_Entities.Acq_Deal_Cost_Costtype_Episode>();
            int RecordCount = 0;
            RecordCount = lstAcq_Deal_Cost_Costtype_Episode_Searched.Count;
            if (RecordCount > 0)
            {
                lst = lstAcq_Deal_Cost_Costtype_Episode_Searched;
            }
            ViewBag.Sum = lst.Sum(t => t.Amount ?? 0);
            ViewBag.Mode = objDeal_Schema.Mode;
            return PartialView("~/Views/Acq_Deal/_AddEdit_Episode_Cost.cshtml", lst);
        }

        public JsonResult AddEditEpisodeCost_List(string dummyGuid, string commandName, int esp_end, int esp_start, decimal cost_type_Amount = 0)
        {
            string status = "S", message = "Record {ACTION} successfully";
            TempData["esp_end"] = esp_end;
            TempData["esp_start"] = esp_start;
            if (commandName == "ADD")
            {
                TempData["Action"] = "AddEpisodeCost";
                TempData["TotalSum_remain"] = cost_type_Amount - lstAcq_Deal_Cost_Costtype_Episode_Searched.Sum(x => x.Amount);
                TempData["TotalPercent_remain"] = 100 - lstAcq_Deal_Cost_Costtype_Episode_Searched.Sum(x => x.Percentage);
            }
            else if (commandName == "EDIT")
            {
                Acq_Deal_Cost_Costtype_Episode objAcq_Deal_Cost_Costtype_Episode = lstAcq_Deal_Cost_Costtype_Episode_Searched.Where(x => x.Dummy_Guid == dummyGuid).FirstOrDefault();
                TempData["Action"] = "EditEpisodeCost";
                TempData["idEpisodeCost"] = objAcq_Deal_Cost_Costtype_Episode.Dummy_Guid;
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult SaveUpdateEpisodeCost(FormCollection objFormCollection)
        {
            string status = "S", message = "Record {ACTION} successfully", warning = "";
            int AcqDealCostTypeCode = Convert.ToInt32(objFormCollection["AcqDealCostTypeCode"]);
            int rowIndex = Convert.ToInt32(objFormCollection["rowIndex"]);
            if (objFormCollection["Key"].ToString().Trim() == "ADD")
            {
                Acq_Deal_Cost_Costtype_Episode objAcq_Deal_Cost_Costtype_Episode = new Acq_Deal_Cost_Costtype_Episode();
                objAcq_Deal_Cost_Costtype_Episode.Episode_From = Convert.ToInt32(objFormCollection["Episode_From"]);
                objAcq_Deal_Cost_Costtype_Episode.Episode_To = Convert.ToInt32(objFormCollection["Episode_To"]);
                objAcq_Deal_Cost_Costtype_Episode.Amount_Type = objFormCollection["RadioButtonChecked"].ToString().Trim();
                objAcq_Deal_Cost_Costtype_Episode.Amount = Convert.ToDecimal(objFormCollection["Amount"]);
                objAcq_Deal_Cost_Costtype_Episode.Percentage = Convert.ToDecimal(objFormCollection["Percentage"]);
                objAcq_Deal_Cost_Costtype_Episode.Remarks = objFormCollection["Remarks"].ToString().Trim();
                var Episode_Count = objAcq_Deal_Cost_Costtype_Episode.Episode_To - objAcq_Deal_Cost_Costtype_Episode.Episode_From;
                Episode_Count = Episode_Count + 1;
                objAcq_Deal_Cost_Costtype_Episode.Per_Eps_Amount = objAcq_Deal_Cost_Costtype_Episode.Amount / Episode_Count;
                objAcq_Deal_Cost_Costtype_Episode.EntityState = State.Added;

                if (lstAcq_Deal_Cost_Costtype_Episode_Searched.Count > 0)
                {
                    foreach (var item in lstAcq_Deal_Cost_Costtype_Episode_Searched)
                    {
                        if (objAcq_Deal_Cost_Costtype_Episode.Episode_From >= item.Episode_From && objAcq_Deal_Cost_Costtype_Episode.Episode_From <= item.Episode_To)
                        { warning = "Overlapping"; }

                        if (objAcq_Deal_Cost_Costtype_Episode.Episode_To >= item.Episode_From && objAcq_Deal_Cost_Costtype_Episode.Episode_To <= item.Episode_To)
                        { warning = "Overlapping"; }
                    }
                }

                if (AcqDealCostTypeCode != 0)
                {
                    objAcq_Deal_Cost_Costtype_Episode.Acq_Deal_Cost_Costtype_Code = AcqDealCostTypeCode;
                    objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(x => x.Acq_Deal_Cost_Costtype_Code == AcqDealCostTypeCode).FirstOrDefault().Acq_Deal_Cost_Costtype_Episode.Add(objAcq_Deal_Cost_Costtype_Episode);
                }
                else
                    objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.ElementAt(rowIndex - 1).Acq_Deal_Cost_Costtype_Episode.Add(objAcq_Deal_Cost_Costtype_Episode);

                if (AcqDealCostTypeCode != 0)
                {
                    lstAcq_Deal_Cost_Costtype_Episode_Searched = lstAcq_Deal_Cost_Costtype_Episode =
                    objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(x => x.Acq_Deal_Cost_Costtype_Code == AcqDealCostTypeCode).FirstOrDefault().Acq_Deal_Cost_Costtype_Episode.Where(x => x.EntityState != State.Deleted).ToList();
                }
                else
                {
                    lstAcq_Deal_Cost_Costtype_Episode_Searched = lstAcq_Deal_Cost_Costtype_Episode = objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.ElementAt(rowIndex - 1).Acq_Deal_Cost_Costtype_Episode.Where(x => x.EntityState != State.Deleted).ToList();
                }
            }
            else if (objFormCollection["Key"].ToString().Trim() == "EDIT")
            {
                Acq_Deal_Cost_Costtype_Episode objAcq_Deal_Cost_Costtype_Episode = new Acq_Deal_Cost_Costtype_Episode();
                if (AcqDealCostTypeCode != 0)
                {
                    objAcq_Deal_Cost_Costtype_Episode = objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(x => x.Acq_Deal_Cost_Costtype_Code == AcqDealCostTypeCode).FirstOrDefault().Acq_Deal_Cost_Costtype_Episode.Where(x => x.Dummy_Guid == objFormCollection["dummy_Guid"].ToString().Trim()).FirstOrDefault();
                    objAcq_Deal_Cost_Costtype_Episode.EntityState = State.Modified;
                }
                // lstAcq_Deal_Cost_Costtype_Episode_Searched.Remove(lstAcq_Deal_Cost_Costtype_Episode_Searched.Where(x => x.Dummy_Guid == objFormCollection["dummy_Guid"].ToString().Trim()).FirstOrDefault());
                objAcq_Deal_Cost_Costtype_Episode.Episode_From = Convert.ToInt32(objFormCollection["Episode_From_Edit"]);
                objAcq_Deal_Cost_Costtype_Episode.Episode_To = Convert.ToInt32(objFormCollection["Episode_To_Edit"]);
                objAcq_Deal_Cost_Costtype_Episode.Amount_Type = objFormCollection["RadioButtonChecked_Edit"].ToString().Trim();
                objAcq_Deal_Cost_Costtype_Episode.Amount = Convert.ToDecimal(objFormCollection["Amount_Edit"]);
                objAcq_Deal_Cost_Costtype_Episode.Percentage = Convert.ToDecimal(objFormCollection["Percentage_Edit"]);
                objAcq_Deal_Cost_Costtype_Episode.Remarks = objFormCollection["Remarks_Edit"].ToString().Trim();
                var Episode_Count = objAcq_Deal_Cost_Costtype_Episode.Episode_To - objAcq_Deal_Cost_Costtype_Episode.Episode_From;
                Episode_Count = Episode_Count + 1;
                objAcq_Deal_Cost_Costtype_Episode.Per_Eps_Amount = objAcq_Deal_Cost_Costtype_Episode.Amount / Episode_Count;
                if (AcqDealCostTypeCode == 0)
                {
                    objAcq_Deal_Cost_Costtype_Episode.EntityState = State.Added;
                    objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.ElementAt(rowIndex - 1).Acq_Deal_Cost_Costtype_Episode.Remove(lstAcq_Deal_Cost_Costtype_Episode_Searched.Where(x => x.Dummy_Guid == objFormCollection["dummy_Guid"].ToString().Trim()).FirstOrDefault());
                    objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.ElementAt(rowIndex - 1).Acq_Deal_Cost_Costtype_Episode.Add(objAcq_Deal_Cost_Costtype_Episode);
                }
                lstAcq_Deal_Cost_Costtype_Episode_Searched.Clear();
                if (AcqDealCostTypeCode != 0)
                {
                    lstAcq_Deal_Cost_Costtype_Episode_Searched = lstAcq_Deal_Cost_Costtype_Episode =
                    objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(x => x.Acq_Deal_Cost_Costtype_Code == AcqDealCostTypeCode).FirstOrDefault().Acq_Deal_Cost_Costtype_Episode.Where(x => x.EntityState != State.Deleted).ToList();
                }
                else
                {
                    lstAcq_Deal_Cost_Costtype_Episode_Searched = lstAcq_Deal_Cost_Costtype_Episode = objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.ElementAt(rowIndex - 1).Acq_Deal_Cost_Costtype_Episode.Where(x => x.EntityState != State.Deleted).ToList();
                }
                var tempList = lstAcq_Deal_Cost_Costtype_Episode_Searched.Where(x => x.Dummy_Guid != objAcq_Deal_Cost_Costtype_Episode.Dummy_Guid).ToList();
                if (tempList.Count > 0)
                {
                    foreach (var item in tempList)
                    {
                        if (objAcq_Deal_Cost_Costtype_Episode.Episode_From >= item.Episode_From && objAcq_Deal_Cost_Costtype_Episode.Episode_From <= item.Episode_To)
                        { warning = "Overlapping"; }

                        if (objAcq_Deal_Cost_Costtype_Episode.Episode_To >= item.Episode_From && objAcq_Deal_Cost_Costtype_Episode.Episode_To <= item.Episode_To)
                        { warning = "Overlapping"; }
                    }
                }

            }
            var obj = new
            {
                Status = status,
                Message = message,
                Warning = warning
            };
            return Json(obj);
        }

        public JsonResult DeleteEpisodeCost_List(FormCollection objFormCollection)
        {
            string status = "S", message = "Record {ACTION} successfully";
            int AcqDealCostTypeCode = Convert.ToInt32(objFormCollection["AcqDealCostTypeCode"]);
            int rowIndex = Convert.ToInt32(objFormCollection["rowIndex"]);
            Acq_Deal_Cost_Costtype_Episode objAcq_Deal_Cost_Costtype_Episode = new Acq_Deal_Cost_Costtype_Episode();
            if (AcqDealCostTypeCode != 0)
            {
                objAcq_Deal_Cost_Costtype_Episode = objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(x => x.Acq_Deal_Cost_Costtype_Code == AcqDealCostTypeCode).FirstOrDefault().Acq_Deal_Cost_Costtype_Episode.Where(x => x.Dummy_Guid == objFormCollection["dummy_Guid"].ToString().Trim()).FirstOrDefault();
                objAcq_Deal_Cost_Costtype_Episode.EntityState = State.Deleted;
            }
            else
            {
                objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.ElementAt(rowIndex - 1).Acq_Deal_Cost_Costtype_Episode.Remove(
                    objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.ElementAt(rowIndex - 1).Acq_Deal_Cost_Costtype_Episode.Where(x => x.Dummy_Guid == objFormCollection["dummy_Guid"].ToString().Trim()).FirstOrDefault());

            }
            lstAcq_Deal_Cost_Costtype_Episode_Searched.Clear();
            if (AcqDealCostTypeCode != 0)
            {
                lstAcq_Deal_Cost_Costtype_Episode_Searched = lstAcq_Deal_Cost_Costtype_Episode =
                objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(x => x.Acq_Deal_Cost_Costtype_Code == AcqDealCostTypeCode).FirstOrDefault().Acq_Deal_Cost_Costtype_Episode.Where(x => x.EntityState != State.Deleted).ToList();
            }
            else
                lstAcq_Deal_Cost_Costtype_Episode_Searched = lstAcq_Deal_Cost_Costtype_Episode = objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.ElementAt(rowIndex - 1).Acq_Deal_Cost_Costtype_Episode.ToList();

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        #endregion

        #region "---------------Grid Additional Expense---------------"

        private List<SelectListItem> BindddlAdditionalExp(int AdditionalExpCode)
        {
            string[] Selected_Add_Exp_Code = (from Acq_Deal_Cost_Additional_Exp objADCAE in objAcq_Deal_Cost.Acq_Deal_Cost_Additional_Exp
                                              where objADCAE.Additional_Expense_Code != AdditionalExpCode
                                              select objADCAE.Additional_Expense_Code.ToString()).Distinct().ToArray();
            List<SelectListItem> lstAE = new SelectList(from Additional_Expense obj in obj_Additional_Expense
                                                        where !Selected_Add_Exp_Code.Contains(obj.Additional_Expense_Code.ToString())
                                                        select obj, "Additional_Expense_Code", "Additional_Expense_Name", AdditionalExpCode.ToString()).ToList();
            lstAE.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
            return lstAE;
        }

        private void BindAllRadionButtonList()
        {
            //Create the select list item you want to add
            SelectListItem liMin = new SelectListItem() { Value = "MIN", Text = objMessageKey.Minimum, Selected = true };
            SelectListItem liMax = new SelectListItem() { Value = "MAX", Text = objMessageKey.Maximum, Selected = false };
            SelectListItem liFix = new SelectListItem() { Value = "Fix", Text = objMessageKey.Fixed, Selected = false };
            List<SelectListItem> lstMinMax = new List<SelectListItem>();
            lstMinMax.Add(liMin);
            lstMinMax.Add(liMax);
            lstMinMax.Add(liFix);
            ViewBag.Min_Max_Radio = lstMinMax;
        }

        [HttpPost]
        public PartialViewResult AddCancelAdditionalExpense(string isAdd)
        {
            ViewBag.AcqDealAdditonalExpCode = 0;
            ViewBag.DdlAdditionalExpense = BindddlAdditionalExp(0);
            BindAllRadionButtonList();
            if (isAdd == "1")
                ViewBag.IsAddEditMode = "Y";
            else
                ViewBag.IsAddEditMode = "";
            BindTotalLabels();
            return PartialView("~/Views/Acq_Deal/_Additional_Exp.cshtml", objAcq_Deal_Cost);

        }

        [HttpPost]
        public PartialViewResult SaveAdditionalExp(int AcqDealAdditionalExpCode, int AdditionalExpCode, string Amount, string MinMax, int rowIndex)
        {
            if (rowIndex == 0)
            {
                Acq_Deal_Cost_Additional_Exp objADCAE = new Acq_Deal_Cost_Additional_Exp();
                objADCAE.Additional_Expense_Code = Convert.ToInt32(AdditionalExpCode);
                objADCAE.Amount = Convert.ToDecimal(Amount.Trim());
                objADCAE.EntityState = State.Added;
                objADCAE.Inserted_On = DBUtil.getServerDate();
                objADCAE.Inserted_By = objLoginUser.Users_Code;
                objADCAE.Min_Max = MinMax;
                objAcq_Deal_Cost.Acq_Deal_Cost_Additional_Exp.Add(objADCAE);

            }
            else
            {
                rowIndex = rowIndex - 1;

                Acq_Deal_Cost_Additional_Exp objADCAE = objAcq_Deal_Cost.Acq_Deal_Cost_Additional_Exp.Where(a => a.EntityState != State.Deleted).ElementAt(rowIndex);
                objADCAE.Additional_Expense_Code = Convert.ToInt32(AdditionalExpCode);
                objADCAE.Amount = Convert.ToDecimal(Amount.Trim());
                objADCAE.Min_Max = MinMax;
                if (objADCAE.Acq_Deal_Cost_Additional_Exp_Code > 0)
                    objADCAE.EntityState = State.Modified;
                else
                    objADCAE.EntityState = State.Added;

            }
            BindTotalLabels();
            ViewBag.IsAddEditMode = "";
            return PartialView("~/Views/Acq_Deal/_Additional_Exp.cshtml", objAcq_Deal_Cost);
        }

        [HttpPost]
        public PartialViewResult EditAdditionalExpense(int AcqDealAdditionalExpCode, int AdditionalExpCode)
        {
            ViewBag.IsAddEditMode = "Y";
            ViewBag.AcqDealAdditonalExpCode = AdditionalExpCode;
            ViewBag.DdlAdditionalExpense = BindddlAdditionalExp(AdditionalExpCode);
            BindAllRadionButtonList();
            BindTotalLabels();
            return PartialView("~/Views/Acq_Deal/_Additional_Exp.cshtml", objAcq_Deal_Cost);
        }

        [HttpPost]
        public PartialViewResult DeleteAdditionalExpense(int rowIndex)
        {
            rowIndex = rowIndex - 1;
            Acq_Deal_Cost_Additional_Exp objADCAE = objAcq_Deal_Cost.Acq_Deal_Cost_Additional_Exp.Where(c => c.EntityState != State.Deleted).ElementAt(rowIndex);

            if (objADCAE.Acq_Deal_Cost_Additional_Exp_Code > 0)
                objADCAE.EntityState = State.Deleted;
            else
                objAcq_Deal_Cost.Acq_Deal_Cost_Additional_Exp.Remove(objADCAE);

            BindTotalLabels();
            return PartialView("~/Views/Acq_Deal/_Additional_Exp.cshtml", objAcq_Deal_Cost);
        }

        #endregion

        #region "---------------Grid Standard Returns---------------"

        [HttpPost]
        public PartialViewResult EditStandardReturns(int AcqDealStandardReturnsCode, int EntityCodeCode, int CostTypeCode, int VendorCode)
        {
            ViewBag.IsAddEditMode = "Y";
            ViewBag.AcqDealEntityCode = EntityCodeCode == 0 ? VendorCode : EntityCodeCode;
            ViewBag.EntityType = EntityCodeCode == 0 ? "L" : "O";
            BindDropDownForSR(EntityCodeCode, CostTypeCode);
            BindRadionForCommissionType();
            BindTotalLabels();
            return PartialView("~/Views/Acq_Deal/_Standard_Returns.cshtml", objAcq_Deal_Cost);
        }

        private void BindDropDownForSR(int Entity_Code, int Cost_Type_Code)
        {
            List<SelectListItem> lstAE = new List<SelectListItem>();

            Entity objEntity = new Entity();
            objEntity.IntCode = Convert.ToInt32(objLoginUser.Default_Entity_Code);
            objEntity.Fetch();
            lstAE.Add(new SelectListItem() { Value = objEntity.IntCode.ToString() + "~O", Text = objEntity.EntityName });

            Vendor_Service vendorServiceInstance = new Vendor_Service(objLoginEntity.ConnectionStringName);
            foreach (Acq_Deal_Licensor licensorInstance in objAcq_Deal.Acq_Deal_Licensor)
            {
                RightsU_Entities.Vendor vendorInstance = vendorServiceInstance.GetById(licensorInstance.Vendor_Code.Value);
                lstAE.Add(new SelectListItem() { Value = vendorInstance.Vendor_Code.ToString() + "~L", Text = vendorInstance.Vendor_Name });
            }
            lstAE.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });

            ViewBag.DdlEntity = lstAE;


            /*------------Cost Type-------------------*/
            List<SelectListItem> lstCost_Type = new SelectList(from Acq_Deal_Cost_Costtype objADCCT in objAcq_Deal_Cost.Acq_Deal_Cost_Costtype
                                                               from Cost_Type objCT in objCost_Type
                                                               where objCT.Cost_Type_Code == objADCCT.Cost_Type_Code && objADCCT.EntityState != State.Deleted
                                                               select objCT, "Cost_Type_Code", "Cost_Type_Name", Cost_Type_Code).ToList();
            lstCost_Type.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
            ViewBag.CostTypeSR = lstCost_Type;
        }

        public PartialViewResult SaveStandardReturns(int AcqDealStandardReturnsCode, string EntityCode, int CostTypeCode, string Amount, string Percentage, string CommType, int rowIndex)
        {
            objAcq_Deal_Cost.StanddardReturnMessage = "";
            if (rowIndex == 0)
            {
                string Vendor_Entity_Code = EntityCode;
                Acq_Deal_Cost_Commission objADCC = new Acq_Deal_Cost_Commission();
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
                    count = (from commissionInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Commission
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
                        count = (from commissionInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Commission
                                 where commissionInstance.EntityState != State.Deleted &&
                                 commissionInstance.Cost_Type_Code == objADCC.Cost_Type_Code &&
                                 commissionInstance.Entity_Code == objADCC.Entity_Code &&
                                 commissionInstance.Type == objADCC.Type &&
                                 commissionInstance.Commission_Type == objADCC.Commission_Type
                                 select commissionInstance).Count();
                    }

                if (count > 0)
                {
                    objAcq_Deal_Cost.StanddardReturnMessage = objMessageKey.CosttypeforthePartyisalreadyavailable;
                }
                else
                {
                    objADCC.EntityState = State.Added;
                    objAcq_Deal_Cost.Acq_Deal_Cost_Commission.Add(objADCC);
                    BindTotalLabels();
                    ViewBag.IsAddEditMode = "";
                }
            }
            else
            {
                rowIndex = rowIndex - 1;

                string Vendor_Entity_Code = EntityCode;
                string[] ArrVendor_Entity_Code = Vendor_Entity_Code.Split('~');
                Acq_Deal_Cost_Commission objADCC = objAcq_Deal_Cost.Acq_Deal_Cost_Commission.Where(c => c.EntityState != State.Deleted).ElementAt(rowIndex);

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

                List<Acq_Deal_Cost_Commission> lstCostCommission = objAcq_Deal_Cost.Acq_Deal_Cost_Commission.Where(c => c.EntityState != State.Deleted).ToList();
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
                    objAcq_Deal_Cost.StanddardReturnMessage = objMessageKey.CosttypeforthePartyisalreadyavailable;

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

                    if (objADCC.Acq_Deal_Cost_Commission_Code > 0)
                        objADCC.EntityState = State.Modified;

                    ViewBag.IsAddEditMode = "";
                    BindTotalLabels();
                }
            }

            return PartialView("~/Views/Acq_Deal/_Standard_Returns.cshtml", objAcq_Deal_Cost);
        }

        [HttpPost]
        public PartialViewResult DeleteStandardReturns(int rowIndex)
        {
            rowIndex = rowIndex - 1;

            Acq_Deal_Cost_Commission objADCC = objAcq_Deal_Cost.Acq_Deal_Cost_Commission.Where(c => c.EntityState != State.Deleted).ElementAt(rowIndex);
            if (objADCC.Acq_Deal_Cost_Commission_Code > 0)
                objADCC.EntityState = State.Deleted;
            else
                objAcq_Deal_Cost.Acq_Deal_Cost_Commission.Remove(objADCC);

            BindTotalLabels();
            return PartialView("~/Views/Acq_Deal/_Standard_Returns.cshtml", objAcq_Deal_Cost);
        }

        [HttpPost]
        public PartialViewResult AddCancelStandardReturns(string isAdd)
        {
            ViewBag.AcqDealEntityCode = 0;
            ViewBag.EntityType = "";
            BindDropDownForSR(0, 0);
            BindRadionForCommissionType();
            if (isAdd == "1")
                ViewBag.IsAddEditMode = "Y";
            else
                ViewBag.IsAddEditMode = "";
            BindTotalLabels();
            return PartialView("~/Views/Acq_Deal/_Standard_Returns.cshtml", objAcq_Deal_Cost);

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
            return Json(objAcq_Deal_Cost);
        }
        #endregion

        #region "---------------Grid Overflow---------------"

        private void BindVariableCost()
        {
            List<Acq_Deal_Cost_Variable_Cost> arrDealMovieCostVariableCost = new List<Acq_Deal_Cost_Variable_Cost>();

            Entity objEntity = new Entity();
            objEntity.IntCode = Convert.ToInt32(objLoginUser.Default_Entity_Code);
            objEntity.Fetch();
            Acq_Deal_Cost_Variable_Cost objDealMovieCostVariableCostNew = new Acq_Deal_Cost_Variable_Cost();
            objDealMovieCostVariableCostNew.Amount = 0;
            objDealMovieCostVariableCostNew.Inserted_By = objLoginUser.Users_Code;
            objDealMovieCostVariableCostNew.Last_Action_By = objLoginUser.Users_Code;
            objDealMovieCostVariableCostNew.Entity_Code = objEntity.IntCode;
            arrDealMovieCostVariableCost.Add(objDealMovieCostVariableCostNew);

            for (int i = 0; i < objAcq_Deal.Acq_Deal_Licensor.Count; i++)
            {
                Acq_Deal_Licensor objVen = (Acq_Deal_Licensor)objAcq_Deal.Acq_Deal_Licensor.ElementAt(i);
                Acq_Deal_Cost_Variable_Cost objDealMovieCostVariableCost = new Acq_Deal_Cost_Variable_Cost();
                objDealMovieCostVariableCost.Amount = 0;
                objDealMovieCostVariableCost.Percentage = objDealMovieCostVariableCost.Percentage;
                objDealMovieCostVariableCost.Inserted_By = objLoginUser.Users_Code;
                objDealMovieCostVariableCost.Last_Action_By = objLoginUser.Users_Code;
                objDealMovieCostVariableCost.Vendor_Code = objVen.Vendor_Code;
                arrDealMovieCostVariableCost.Add(objDealMovieCostVariableCost);
            }
            ViewBag.VariableCostList = arrDealMovieCostVariableCost;
            ViewBag.Mode = objDeal_Schema.Mode;
            if (objAcq_Deal_Cost.Variable_Cost_Type == null)
                ViewBag.Variable_Cost_Type = "N";
            else
                ViewBag.Variable_Cost_Type = objAcq_Deal_Cost.Variable_Cost_Type;
        }

        [HttpPost]
        public PartialViewResult ReBindVariableCost(string VarCostType)
        {
            if (VarCostType == "N")
            {
                ViewBag.VariableCostList = new List<Acq_Deal_Cost_Variable_Cost>();
                foreach (Acq_Deal_Cost_Variable_Cost variableCostInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Variable_Cost)
                {
                    variableCostInstance.EntityState = State.Deleted;
                }
            }
            else
            {
                if (objAcq_Deal_Cost.Acq_Deal_Cost_Variable_Cost.Count != 0)
                {
                    foreach (Acq_Deal_Cost_Variable_Cost variableCostInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Variable_Cost)
                    {
                        variableCostInstance.Percentage = 0;
                        variableCostInstance.EntityState = State.Modified;
                    }
                    ViewBag.VariableCostList = objAcq_Deal_Cost.Acq_Deal_Cost_Variable_Cost.ToList();
                }
                else
                    BindVariableCost();
            }
            ViewBag.Mode = objDeal_Schema.Mode;
            BindVariableType();
            if (objAcq_Deal_Cost.Variable_Cost_Type == null)
                ViewBag.Variable_Cost_Type = "N";
            else
                ViewBag.Variable_Cost_Type = objAcq_Deal_Cost.Variable_Cost_Type;
            return PartialView("~/Views/Acq_Deal/_Overflow.cshtml");
        }

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

        #endregion

        public JsonResult SaveDealCost(string TitleCodes, string DealCost, int recoupmentCode, string VariableCostType, List<Acq_Deal_Cost_Variable_Cost> VariableCostRows)
        {
            List<Cost_Type> ct = new List<Cost_Type>();
            string strViewBagErrorMsg = "";
            string strViewBagMsg = "";
            if (objDeal_Schema.Deal_Type_Condition != GlobalParams.Deal_Movie)
            {
                if (objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Count > 0)
                {
                    foreach (var item in objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(x => x.EntityState != State.Deleted).ToList())
                    {
                        decimal costtype_Amount = Convert.ToDecimal(item.Amount);
                        decimal costtype_Esp_Amount = Convert.ToDecimal(item.Acq_Deal_Cost_Costtype_Episode.Where(x => x.EntityState != State.Deleted).Sum(x => x.Amount));
                        if (costtype_Esp_Amount > 0)
                        {
                            if (costtype_Amount != costtype_Esp_Amount)
                            {
                                ct = new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Cost_Type_Code == item.Cost_Type_Code).ToList();
                                strViewBagErrorMsg = ct.ElementAt(0).Cost_Type_Name.ToString();
                            }
                        }
                    }
                }
            }

            if (strViewBagErrorMsg == "")
            {
                #region
                double strDealCost = 0;
                strDealCost = GlobalParams.RemoveCommas(DealCost.Trim() == "" ? "0" : DealCost);
                objAcq_Deal_Cost.Acq_Deal_Code = objDeal_Schema.Deal_Code;
                objAcq_Deal_Cost.Currency_Code = objAcq_Deal.Currency_Code;
                objAcq_Deal_Cost.Currency_Exchange_Rate = Convert.ToDecimal(objAcq_Deal.Exchange_Rate);
                objAcq_Deal_Cost.Deal_Cost = Convert.ToDecimal(strDealCost);
                objAcq_Deal_Cost.Deal_Cost_Per_Episode = Convert.ToDecimal(strDealCost);
                objAcq_Deal_Cost.Cost_Center_Id = null;
                objAcq_Deal_Cost.Variable_Cost_Type = VariableCostType;
                objAcq_Deal_Cost.Variable_Cost_Sharing_Type = "L";
                objAcq_Deal_Cost.Royalty_Recoupment_Code = (recoupmentCode > 0 ? Convert.ToInt32(recoupmentCode) : (int?)null);

                if (objAcq_Deal_Cost.Acq_Deal_Cost_Code > 0)
                {
                    objAcq_Deal_Cost.Last_Action_By = objLoginUser.Users_Code;
                    objAcq_Deal_Cost.Last_Updated_Time = DBUtil.getServerDate();
                    objAcq_Deal_Cost.EntityState = State.Modified;
                    strViewBagMsg = "Cost updated successfully.";
                }
                else
                {
                    objAcq_Deal_Cost.Inserted_On = DBUtil.getServerDate();
                    objAcq_Deal_Cost.Inserted_By = objLoginUser.Users_Code;
                    objAcq_Deal_Cost.EntityState = State.Added;
                    strViewBagMsg = "Cost added successfully.";
                }
                List<string> arrTitleCode = TitleCodes.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList();
                //if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                //{
                //    //List<int> lstTitleCode = objDeal_Schema.Title_List.Where(x => arrTitleCode.Contains(x.Acq_Deal_Movie_Code.ToString())).Select(x => x.Title_Code).ToList();
                //    Title_List objTL = objDeal_Schema.Title_List.Where(x => arrTitleCode.Contains(x.Acq_Deal_Movie_Code.ToString())).FirstOrDefault();
                //    foreach (Acq_Deal_Cost_Title titleInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(t => objTL.Title_Code == t.Title_Code.Value && t.Episode_From == objTL.Episode_From &&
                //                t.Episode_To == objTL.Episode_To))
                //    {
                //        titleInstance.EntityState = State.Modified;
                //    }
                //    foreach (Acq_Deal_Cost_Title titleInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(t => objTL.Title_Code != t.Title_Code.Value && t.Episode_From != objTL.Episode_From &&
                //                t.Episode_To != objTL.Episode_To))
                //    {
                //        titleInstance.EntityState = State.Deleted;
                //    }
                //}
                //else
                //{
                //    foreach (Acq_Deal_Cost_Title titleInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(t => arrTitleCode.Contains(t.Title_Code.Value.ToString())))
                //    {
                //        titleInstance.EntityState = State.Modified;
                //    }
                //    foreach (Acq_Deal_Cost_Title titleInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(t => !arrTitleCode.Contains(t.Title_Code.Value.ToString())))
                //    {
                //        titleInstance.EntityState = State.Deleted;
                //    }
                //}
                objAcq_Deal_Cost.Acq_Deal_Cost_Title.ToList<Acq_Deal_Cost_Title>().ForEach(t => t.EntityState = State.Deleted);
                foreach (string strTitleCode in arrTitleCode)
                {
                    int titleCode = strTitleCode == "" ? 0 : Convert.ToInt32(strTitleCode.Trim());
                    if (titleCode > 0)
                    {
                        Acq_Deal_Cost_Title objADCT = new Acq_Deal_Cost_Title();
                        if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                        {
                            Title_List objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == titleCode).FirstOrDefault();
                            //if (objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(w => w.Title_Code == objTL.Title_Code && w.Episode_From == objTL.Episode_From &&
                            //    w.Episode_To == objTL.Episode_To).Count() == 0)
                            //{
                            objADCT.Title_Code = objTL.Title_Code;
                            objADCT.Episode_From = objTL.Episode_From;
                            objADCT.Episode_To = objTL.Episode_To;
                            objAcq_Deal_Cost.Acq_Deal_Cost_Title.Add(objADCT);
                            //}
                        }
                        else if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Movie )
                        {
                            Title_List objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == titleCode).FirstOrDefault();
                            objADCT.Title_Code = objTL.Title_Code;
                            objADCT.Episode_From = 1;
                            objADCT.Episode_To = 1;
                            objAcq_Deal_Cost.Acq_Deal_Cost_Title.Add(objADCT);
                            
                        }
                        else
                        {
                            //if (objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(t => t.Title_Code == titleCode).Count() == 0)
                            //{
                            objADCT.Title_Code = titleCode;
                            objADCT.Episode_From = 1;
                            objADCT.Episode_To = 1;
                            objAcq_Deal_Cost.Acq_Deal_Cost_Title.Add(objADCT);
                            //}
                        }
                    }
                }

                if (VariableCostType == "N")
                {

                    Acq_Deal_Cost_Variable_Cost variableCostInstance;

                }
                else
                {
                    foreach (Acq_Deal_Cost_Variable_Cost objADM_MVC in VariableCostRows)
                    {
                        int variableCostCode = Convert.ToInt32(objADM_MVC.Acq_Deal_Cost_Variable_Cost_Code);
                        Acq_Deal_Cost_Variable_Cost variableCostInstance;

                        if (variableCostCode > 0)
                        {
                            variableCostInstance = objAcq_Deal_Cost.Acq_Deal_Cost_Variable_Cost.Where(v => v.Acq_Deal_Cost_Variable_Cost_Code == variableCostCode).SingleOrDefault();
                            variableCostInstance.Last_Action_By = objLoginUser.Users_Code;
                            variableCostInstance.Last_Updated_Time = DBUtil.getServerDate();
                            variableCostInstance.EntityState = State.Modified;
                        }
                        else
                        {
                            variableCostInstance = new Acq_Deal_Cost_Variable_Cost();
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
                        objAcq_Deal_Cost.Acq_Deal_Cost_Variable_Cost.Add(variableCostInstance);

                    }
                }

                foreach (Acq_Deal_Cost_Costtype costTypeInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Where(c => c.EntityState != State.Deleted))
                {
                    if (costTypeInstance.Acq_Deal_Cost_Costtype_Code > 0)
                        costTypeInstance.EntityState = State.Modified;
                }
                foreach (Acq_Deal_Cost_Additional_Exp additionalExpInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Additional_Exp.Where(ae => ae.EntityState != State.Deleted))
                {
                    if (additionalExpInstance.Acq_Deal_Cost_Additional_Exp_Code > 0)
                        additionalExpInstance.EntityState = State.Modified;
                }
                foreach (Acq_Deal_Cost_Commission commissionInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Commission.Where(c => c.EntityState != State.Deleted))
                {
                    if (commissionInstance.Acq_Deal_Cost_Commission_Code > 0)
                        commissionInstance.EntityState = State.Modified;
                }
                dynamic resultSet;
                objAcq_Deal_Cost_Service.Save(objAcq_Deal_Cost, out resultSet);
                string a = resultSet;

                BindTotalDealCost();
                ClearSession();

                #endregion
            }
            string TotalFixedDealCost = BindTotalDealCost();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strViewBagMsg);
            obj.Add("TotalFixedDealCost", TotalFixedDealCost);
            obj.Add("Error_Message", strViewBagErrorMsg);
            return Json(obj);
        }

        public void CancelDealCost(object sender, EventArgs e)
        {
            ClearSession();
        }

        #endregion
    }


}