using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Syn_Payment_TermController : BaseController
    {
        #region Properties

        //public int PageNo
        //{
        //    get
        //    {
        //        if (ViewBag.PageNo == null)
        //            ViewBag.PageNo = 1;
        //        return (int)ViewBag.PageNo;
        //    }
        //    set { ViewBag.PageNo = value; }
        //}

        public int PageNo
        {
            get
            {
                if (Session["PageNo"] == null)
                    Session["PageNo"] = 1;
                return (int)Session["PageNo"];
            }
            set { Session["PageNo"] = value; }
        }
        public int PageSize
        {
            get
            {
                if (Session["PageSize"] == null)
                    Session["PageSize"] = 10;
                return (int)Session["PageSize"];
            }
            set { Session["PageSize"] = value; }
        }
        public Syn_Deal objDeal
        {
            get
            {
                if (Session["objDeal"] == null)
                    Session["objDeal"] = new Syn_Deal();
                return (Syn_Deal)Session["objDeal"];
            }
            set { Session["objDeal"] = value; }
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

        #region Actions

        public PartialViewResult Index(string Message = "")
        {
            ViewBag.CommandName = "";
            ViewBag.Message = Message;
            //objDeal_Schema.Deal_Code = 7;
            int Deal_Code = objDeal_Schema.Deal_Code;
            objDeal_Schema.Page_From = GlobalParams.Page_From_PaymentTerm;
            objDeal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(Deal_Code);
            if (string.IsNullOrEmpty(objDeal.Payment_Terms_Conditions))
                objDeal.Payment_Terms_Conditions = "";
            ViewBag.Remark = objDeal.Payment_Terms_Conditions;
            Session["objDeal"] = objDeal;
            ViewBag.PageMode = objDeal_Schema.Mode;
            ViewBag.Approver_Remark = objDeal_Schema.Approver_Remark;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            //return View("Index", objDeal.Syn_Deal_Payment_Terms.ToList());            
            return PartialView("~/Views/Syn_Deal/_Syn_Payment_Term_List.cshtml", objDeal.Syn_Deal_Payment_Terms.ToList());
        }

        public PartialViewResult Create(string isAdd)
        {
            ViewBag.SynDealPaymentCode = 0;
            if (isAdd == "1")
            {
                ViewBag.CommandName = "Add";
            }
            else
            {
                ViewBag.CommandName = "";
            }

            BindPaymentTerm(0);
            BindCostType(0);
            return BindGridSynPaymentTerms(PageSize, PageNo-1);
        }

        [HttpPost]
        public PartialViewResult BindGridSynPaymentTerms(int txtPageSize, int page_No)
        {
            PageSize = txtPageSize;
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
            ICollection<Syn_Deal_Payment_Terms> lst_Syn_Deal_Payment;
            Syn_Deal_Payment_Terms_Service objSyn_Deal_Payment_Service = new Syn_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName);
            if (PageNo == 1)
                lst_Syn_Deal_Payment = objSyn_Deal_Payment_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Syn_Deal_Payment_Terms_Code).Take(pageSize).ToList();
            else
            {
                lst_Syn_Deal_Payment = objSyn_Deal_Payment_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Syn_Deal_Payment_Terms_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (lst_Syn_Deal_Payment.Count == 0)
                {
                    if (PageNo != 1)
                    {
                        objDeal_Schema.Cost_PageNo = PageNo - 1;
                        //PageNo = PageNo - 1;
                    }
                    lst_Syn_Deal_Payment = objSyn_Deal_Payment_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Syn_Deal_Payment_Terms_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }
            ViewBag.RecordCount = objSyn_Deal_Payment_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).Count();
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = txtPageSize;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            ViewBag.UserModuleRights = GetUserModuleRights();
            ViewBag.PageMode = objDeal_Schema.Mode;
            return PartialView("~/Views/Syn_Deal/_List_Payment_Term.cshtml", lst_Syn_Deal_Payment);
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForSynDeal), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        public JsonResult Save_Payment_Term(string Payment_Term_Name)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            string status = "S", message = "Record saved successfully";
            Payment_Terms_Service objService = new Payment_Terms_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Payment_Terms objPaymentTerm = new RightsU_Entities.Payment_Terms();
            objPaymentTerm.EntityState = State.Added;
            objPaymentTerm.Inserted_On = DateTime.Now;
            objPaymentTerm.Inserted_By = objLoginUser.Users_Code;
            objPaymentTerm.Last_Updated_Time = DateTime.Now;
            objPaymentTerm.Last_Action_By = objLoginUser.Users_Code;
            objPaymentTerm.Is_Active = "Y";
            objPaymentTerm.Payment_Terms1 = Payment_Term_Name;
            dynamic resultSet;
            bool isValid = objService.Save(objPaymentTerm, out resultSet);
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {

                Status = status,
                Message = message,
                Value = objPaymentTerm.Payment_Terms_Code,
                Text = objPaymentTerm.Payment_Terms1
            };

            return Json(obj);
        }

        public PartialViewResult SavePaymentTerms(int Syn_Deal_Payment_Terms_Code, int Payment_Term_Code, int Cost_Type_Code, decimal Percentage,decimal Amount, int Days_After, string Due_Date)
        {
            if (Syn_Deal_Payment_Terms_Code == 0)
            {
                Syn_Deal_Payment_Terms objSyn_Deal_Payment_Terms = new Syn_Deal_Payment_Terms();
                Syn_Deal_Payment_Terms_Service objSyn_Deal_Payment_Terms_Service = new Syn_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName);
                objSyn_Deal_Payment_Terms.Syn_Deal_Code = objDeal.Syn_Deal_Code;
                objSyn_Deal_Payment_Terms.Inserted_On = DateTime.Now;
                objSyn_Deal_Payment_Terms.Inserted_By = objLoginUser.Users_Code; // to be changed

                objSyn_Deal_Payment_Terms.Payment_Terms_Code = Payment_Term_Code;
                objSyn_Deal_Payment_Terms.Cost_Type_Code = Cost_Type_Code;
                objSyn_Deal_Payment_Terms.Percentage = Percentage;
                objSyn_Deal_Payment_Terms.Amount = Amount;
                objSyn_Deal_Payment_Terms.Days_After = Days_After;

                if (Due_Date != "")
                {
                    string[] arrdate = Due_Date.Trim().Split('/');
                    DateTime date = Convert.ToDateTime(arrdate[2] + "-" + arrdate[1] + "-" + arrdate[0]);

                    objSyn_Deal_Payment_Terms.Due_Date = date;
                }
                else
                    objSyn_Deal_Payment_Terms.Due_Date = null;
                objSyn_Deal_Payment_Terms.EntityState = State.Added;
                dynamic resultSet;
                objSyn_Deal_Payment_Terms_Service.Save(objSyn_Deal_Payment_Terms, out resultSet);

            }
            else
            {
                Syn_Deal_Payment_Terms_Service objSyn_Deal_Payment_Terms_Service = new Syn_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName);
                Syn_Deal_Payment_Terms obj = objSyn_Deal_Payment_Terms_Service.GetById(Syn_Deal_Payment_Terms_Code);
                if (obj != null)
                {
                    obj.Payment_Terms_Code = Payment_Term_Code;
                    obj.Cost_Type_Code = Cost_Type_Code;
                    obj.Percentage = Percentage;
                    obj.Amount = Amount;
                    obj.Days_After = Days_After;
                    obj.Syn_Deal_Code = objDeal.Syn_Deal_Code;
                    if (Due_Date != "")
                    {
                        string[] arrdate = Due_Date.Trim().Split('/');
                        DateTime date = Convert.ToDateTime(arrdate[2] + "-" + arrdate[1] + "-" + arrdate[0]);
                        obj.Due_Date = date;
                    }
                    else
                        obj.Due_Date = null;

                    obj.Last_Updated_Time = DateTime.Now;
                    obj.Last_Action_By = objLoginUser.Users_Code;
                    obj.EntityState = State.Modified;
                    dynamic resultSet;
                    objSyn_Deal_Payment_Terms_Service.Save(obj, out resultSet);
                }

            }
            return BindGridSynPaymentTerms(PageSize, PageNo-1);

        }

        public JsonResult ChangeTab(string HdnPaymentTermRemark, string hdnTabName, string hdnReopenMode = "")
        {
            string mode = ""; 
            string status = "S";
            if (hdnReopenMode == "RO")
            {
                mode = GlobalParams.DEAL_MODE_EDIT;
                status = "SA";
            }
            else
                mode = objDeal_Schema.Mode;

            if (mode == GlobalParams.DEAL_MODE_REOPEN)
            {
                objDeal_Schema.Deal_Workflow_Flag = objDeal.Deal_Workflow_Status = Convert.ToString(mode).Trim();
            }
            string msg = "";
            if (objDeal_Schema.Mode != "V")
            SaveRemark(HdnPaymentTermRemark);
            if (hdnTabName == "")
            {

                Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
                obj_Dic.Add("Page_No", objDeal_Schema.PageNo.ToString());
                TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
                
                string Mode = objDeal_Schema.Mode;
                TempData["RedirectSynDeal"] = objDeal;
                msg = objMessageKey.DealSavedSuccessfully;
                if (Mode == GlobalParams.DEAL_MODE_EDIT)
                    msg = objMessageKey.DealUpdatedSuccessfully;
            }

            string redirectUrl = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetRedirectURL(hdnTabName, objDeal_Schema.PageNo, null, objDeal_Schema.Deal_Type_Code, GlobalParams.ModuleCodeForSynDeal);

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Success_Message", msg);
            obj.Add("Redirect_URL", redirectUrl);
            return Json(obj);
            //  return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code);
        }
        public ActionResult Cancel()
        {
            ClearSession();
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            objDeal_Schema = null;
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
                obj_Dic.Add("Page_No", pageNo.ToString());
                obj_Dic.Add("ReleaseRecord", "Y");
                TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
                return RedirectToAction("Index", "Syn_List");
            }
            //return RedirectToAction("Index", "Syn_List", new { Page_No = pageNo, ReleaseRecord = "Y" });
        }

        public PartialViewResult Edit(int Syn_Deal_Payment_Terms_Code)
        {
            ViewBag.Syn_Deal_Payment_Terms_Code = Syn_Deal_Payment_Terms_Code;
            Syn_Deal_Payment_Terms_Service objSyn_Deal_Payment_Terms_Service = new Syn_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal_Payment_Terms objSyn_Deal_Payment_Terms = objSyn_Deal_Payment_Terms_Service.GetById(Syn_Deal_Payment_Terms_Code);

            ViewBag.CommandName = "Edit";
            if (objSyn_Deal_Payment_Terms.Due_Date == DateTime.MinValue)
                objSyn_Deal_Payment_Terms.Due_Date = null;
            BindPaymentTerm(Convert.ToInt32(objSyn_Deal_Payment_Terms.Payment_Terms_Code));
            BindCostType(Convert.ToInt32(objSyn_Deal_Payment_Terms.Cost_Type_Code));

            return BindGridSynPaymentTerms(PageSize, PageNo-1);
        }

        public PartialViewResult Delete(int Syn_Deal_Payment_Terms_Code)
        {
            if (Syn_Deal_Payment_Terms_Code > 0)
            {
                Syn_Deal_Payment_Terms_Service objSyn_Deal_Payment_Terms_Service = new Syn_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName);
                Syn_Deal_Payment_Terms objSyn_Deal_Payment_Terms = objSyn_Deal_Payment_Terms_Service.GetById(Syn_Deal_Payment_Terms_Code);
                objSyn_Deal_Payment_Terms.EntityState = State.Deleted;
                dynamic resultSet;
                objSyn_Deal_Payment_Terms_Service.Save(objSyn_Deal_Payment_Terms, out resultSet);
            }
            return BindGridSynPaymentTerms(PageSize, PageNo-1);
        }

        #endregion

        #region Methods

        private bool SaveRemark(string HdnRemark)
        {
            Syn_Deal_Service objADS = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
            objDeal = objADS.GetById(objDeal_Schema.Deal_Code);
            objDeal.Payment_Terms_Conditions = HdnRemark.Trim().Substring(0, Math.Min(HdnRemark.Trim().Length, 4000));//TruncateLongString(HdnRemark.Trim(),4000);//.Trim();
            objDeal.EntityState = State.Modified;
            dynamic resultSet;
            bool Result = objADS.Save(objDeal, out resultSet);
            return Result;
        }
       
        private void ClearSession()
        {
            objDeal = null;
        }

        private bool ValidatPayment()
        {
            objDeal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            if (objDeal.Syn_Deal_Payment_Terms.Count <= 0)
            {
                return false; //
            }
            else
                return true;
        }

        private void BindPaymentTerm(int Payment_Terms_Code)
        {
            if (Payment_Terms_Code == 0)
            {
                List<SelectListItem> lstPayment_Terms = new SelectList(new Payment_Terms_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Payment_Terms_Code", "Payment_Terms1").ToList();
                lstPayment_Terms.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.Payment_Terms_List = lstPayment_Terms;
            }
            else
            {
                List<SelectListItem> lstPayment_Terms = new SelectList(new Payment_Terms_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Payment_Terms_Code", "Payment_Terms1", Payment_Terms_Code).ToList();
                lstPayment_Terms.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.Payment_Terms_List = lstPayment_Terms;
            }
        }

        private void BindCostType(int Cost_Type_Code)
        {
            if (Cost_Type_Code == 0)
            {
                List<int> lstCostTypeCode = new List<int>();
                foreach (Syn_Deal_Revenue costInstance in objDeal.Syn_Deal_Revenue)
                {
                    lstCostTypeCode.AddRange(costInstance.Syn_Deal_Revenue_Costtype.Select(c => c.Cost_Type_Code.Value).ToList());
                }
                List<SelectListItem> lstCost_Type = new SelectList(new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && lstCostTypeCode.Contains(x.Cost_Type_Code)), "Cost_Type_Code", "Cost_Type_Name").ToList();
                lstCost_Type.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.Cost_Type_List = lstCost_Type;
            }
            else
            {
                List<int> lstCostTypeCode = new List<int>();
                foreach (Syn_Deal_Revenue costInstance in objDeal.Syn_Deal_Revenue)
                {
                    lstCostTypeCode.AddRange(costInstance.Syn_Deal_Revenue_Costtype.Select(c => c.Cost_Type_Code.Value).ToList());
                }
                List<SelectListItem> lstCost_Type = new SelectList(new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && lstCostTypeCode.Contains(x.Cost_Type_Code)), "Cost_Type_Code", "Cost_Type_Name", Cost_Type_Code).ToList();
                lstCost_Type.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.Cost_Type_List = lstCost_Type;
            }
        }
        public JsonResult CostTypeAmount(int CostTypeCode)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            string[] SynDealRevenueCode = new Syn_Deal_Revenue_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Syn_Deal_Code == objDeal.Syn_Deal_Code).Select(s => s.Syn_Deal_Revenue_Code.ToString()).ToArray();
           int? amount = Convert.ToInt32(new Syn_Deal_Revenue_Costtype_Service(objLoginEntity.ConnectionStringName).SearchFor(w => SynDealRevenueCode.Contains(w.Syn_Deal_Revenue_Code.ToString()) && w.Cost_Type_Code == CostTypeCode).Select(s => s.Amount).FirstOrDefault());
           

            var obj = new
            {
                Amount = amount,
                CTCode = CostTypeCode
            };

            //objJson.Add("Amount", amount);
            return Json(obj);
        }
        public JsonResult ValidateIsDuplicate(int Syn_Deal_Payment_Term_Code, int PaymentTermCode, int CostTypeCode)
        {
            int Count = 0;
            int[] SynDealPaymentTermCode = new Syn_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal.Syn_Deal_Code && x.Payment_Terms_Code == PaymentTermCode && x.Cost_Type_Code == CostTypeCode).Select(s => s.Syn_Deal_Payment_Terms_Code).Distinct().ToArray();
            if (SynDealPaymentTermCode.Contains(Syn_Deal_Payment_Term_Code))
            {
                Count = 0;
            }
            else
            {
                Count = new Syn_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Payment_Terms_Code == PaymentTermCode && x.Syn_Deal_Code == objDeal.Syn_Deal_Code && x.Cost_Type_Code == CostTypeCode).Distinct().Count();
            }
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            if (Count > 0)
                objJson.Add("Message", "Payment Term with same cost type already exists");
            else
                objJson.Add("Message", "");

            return Json(objJson);
        }

        #endregion
    }
}
