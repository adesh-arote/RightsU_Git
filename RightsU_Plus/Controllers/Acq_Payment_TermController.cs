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
    public class Acq_Payment_TermController : BaseController
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
        public Acq_Deal objDeal
        {
            get
            {
                if (Session["objDeal"] == null)
                    Session["objDeal"] = new Acq_Deal();
                return (Acq_Deal)Session["objDeal"];
            }
            set { Session["objDeal"] = value; }
        }

        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.ACQ_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.ACQ_DEAL_SCHEMA] = value; }
        }

        #endregion

        #region Actions

        public PartialViewResult Index(string Message = "")
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            ViewBag.CommandName = "";
            ViewBag.Message = Message;
            int Deal_Code = objDeal_Schema.Deal_Code;
            objDeal_Schema.Page_From = GlobalParams.Page_From_PaymentTerm;
            objDeal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(Deal_Code);
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
            Session["FileName"] = "";
            Session["FileName"] = "Acq_Payment_Term";

            int prevAcq_Deal = 0;
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_VIEW && TempData["prevAcqDeal"] != null)
            {
                prevAcq_Deal = Convert.ToInt32(TempData["prevAcqDeal"]);
                TempData.Keep("prevAcqDeal");
            }
            ViewBag.prevAcq_Deal = prevAcq_Deal;
            return PartialView("~/Views/Acq_Deal/_Acq_Payment_Term_List.cshtml", objDeal.Acq_Deal_Payment_Terms.ToList());
        }

        public PartialViewResult Create(string isAdd)
        {
            ViewBag.AcqDealPaymentCode = 0;
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
            return BindGridAcqPaymentTerms(PageSize, PageNo - 1);
        }

        [HttpPost]
        public PartialViewResult BindGridAcqPaymentTerms(int txtPageSize, int page_No = 0)
        {
            PageSize = txtPageSize;
            USP_Service objUsp = new USP_Service(objLoginEntity.ConnectionStringName);

            List<USP_List_Acq_PaymentTerms_Result> pagedList = objUsp.USP_List_Acq_PaymentTerms(objDeal_Schema.Deal_Code).ToList();
            List<USP_List_Acq_PaymentTerms_Result> list;

            PageNo = page_No + 1;
            if (PageNo == 1)
                list = pagedList.Take(txtPageSize).ToList();
            else
            {
                objDeal_Schema.Cost_PageNo = PageNo - 1;

                list = pagedList.Skip((PageNo - 1) * txtPageSize).Take(txtPageSize).ToList();
            }

            ViewBag.RecordCount = pagedList.Count;//objAcq_Deal_Payment_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Count();
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = txtPageSize;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            ViewBag.PageMode = objDeal_Schema.Mode;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Acq_Deal/_List_Payment_Term.cshtml", list);
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

        public PartialViewResult SavePaymentTerms(int Acq_Deal_Payment_Terms_Code, int Payment_Term_Code, int Cost_Type_Code, decimal Percentage, decimal Amount, int Days_After, string Due_Date)
        {
            if (Acq_Deal_Payment_Terms_Code == 0)
            {
                Acq_Deal_Payment_Terms objAcq_Deal_Payment_Terms = new Acq_Deal_Payment_Terms();
                Acq_Deal_Payment_Terms_Service objAcq_Deal_Payment_Terms_Service = new Acq_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName);
                objAcq_Deal_Payment_Terms.Acq_Deal_Code = objDeal.Acq_Deal_Code;
                objAcq_Deal_Payment_Terms.Inserted_On = DateTime.Now;
                objAcq_Deal_Payment_Terms.Inserted_By = objLoginUser.Users_Code; // to be changed

                objAcq_Deal_Payment_Terms.Payment_Term_Code = Payment_Term_Code;
                objAcq_Deal_Payment_Terms.Cost_Type_Code = Cost_Type_Code;
                objAcq_Deal_Payment_Terms.Percentage = Percentage;
                objAcq_Deal_Payment_Terms.Amount = Amount;
                objAcq_Deal_Payment_Terms.Days_After = Days_After;

                if (Due_Date != "")
                {
                    string[] arrdate = Due_Date.Trim().Split('/');
                    DateTime date = Convert.ToDateTime(arrdate[2] + "-" + arrdate[1] + "-" + arrdate[0]);

                    objAcq_Deal_Payment_Terms.Due_Date = date;
                }
                else
                    objAcq_Deal_Payment_Terms.Due_Date = null;
                objAcq_Deal_Payment_Terms.EntityState = State.Added;
                dynamic resultSet;
                objAcq_Deal_Payment_Terms_Service.Save(objAcq_Deal_Payment_Terms, out resultSet);

            }
            else
            {
                Acq_Deal_Payment_Terms_Service objAcq_Deal_Payment_Terms_Service = new Acq_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName);
                Acq_Deal_Payment_Terms obj = objAcq_Deal_Payment_Terms_Service.GetById(Acq_Deal_Payment_Terms_Code);
                if (obj != null)
                {
                    obj.Payment_Term_Code = Payment_Term_Code;
                    obj.Cost_Type_Code = Cost_Type_Code;
                    obj.Percentage = Percentage;
                    obj.Amount = Amount;
                    obj.Days_After = Days_After;
                    obj.Acq_Deal_Code = objDeal.Acq_Deal_Code;
                    if (Due_Date != "")
                    {
                        string[] arrdate = Due_Date.Trim().Split('/');
                        DateTime date = Convert.ToDateTime(arrdate[2] + "-" + arrdate[1] + "-" + arrdate[0]);
                        obj.Due_Date = date;
                    }
                    obj.Last_Updated_Time = DateTime.Now;
                    obj.Last_Action_By = objLoginUser.Users_Code;
                    obj.EntityState = State.Modified;
                    dynamic resultSet;
                    objAcq_Deal_Payment_Terms_Service.Save(obj, out resultSet);
                }

            }
            return BindGridAcqPaymentTerms(PageSize, PageNo - 1);

        }

        public JsonResult ChangeTab(string HdnPaymentTermRemark, string hdnTabName, string hdnReopenMode = "")
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
                objDeal_Schema.Deal_Workflow_Flag = objDeal.Deal_Workflow_Status = Convert.ToString(mode).Trim();
            }

            if (objDeal_Schema.Mode != "V")
                SaveRemark(HdnPaymentTermRemark);
            if (hdnTabName == "")
            {
                Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
                obj_Dic.Add("Page_No", objDeal_Schema.PageNo.ToString());
                TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
                string Mode = objDeal_Schema.Mode;
                TempData["RedirectAcqDeal"] = objDeal;
                msg = "Deal saved successfully";
                if (Mode == GlobalParams.DEAL_MODE_EDIT)
                    msg = "Deal updated successfully";
            }

            string redirectUrl = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetRedirectURL(hdnTabName, objDeal_Schema.PageNo, null, objDeal_Schema.Deal_Type_Code);

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Success_Message", msg);
            obj.Add("Redirect_URL", redirectUrl);
            return Json(obj);
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
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                return RedirectToAction("Index", "Acq_List");
            }
        }

        public PartialViewResult Edit(int Acq_Deal_Payment_Terms_Code)
        {
            ViewBag.Acq_Deal_Payment_Terms_Code = Acq_Deal_Payment_Terms_Code;
            Acq_Deal_Payment_Terms_Service objAcq_Deal_Payment_Terms_Service = new Acq_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal_Payment_Terms objAcq_Deal_Payment_Terms = objAcq_Deal_Payment_Terms_Service.GetById(Acq_Deal_Payment_Terms_Code);

            ViewBag.CommandName = "Edit";
            if (objAcq_Deal_Payment_Terms.Due_Date == DateTime.MinValue)
                objAcq_Deal_Payment_Terms.Due_Date = null;
            BindPaymentTerm(Convert.ToInt32(objAcq_Deal_Payment_Terms.Payment_Term_Code));
            BindCostType(Convert.ToInt32(objAcq_Deal_Payment_Terms.Cost_Type_Code));

            return BindGridAcqPaymentTerms(PageSize, PageNo - 1);
        }

        public PartialViewResult Delete(int Acq_Deal_Payment_Terms_Code)
        {
            if (Acq_Deal_Payment_Terms_Code > 0)
            {
                Acq_Deal_Payment_Terms_Service objAcq_Deal_Payment_Terms_Service = new Acq_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName);
                Acq_Deal_Payment_Terms objAcq_Deal_Payment_Terms = objAcq_Deal_Payment_Terms_Service.GetById(Acq_Deal_Payment_Terms_Code);
                objAcq_Deal_Payment_Terms.EntityState = State.Deleted;
                dynamic resultSet;
                objAcq_Deal_Payment_Terms_Service.Save(objAcq_Deal_Payment_Terms, out resultSet);
            }
            return BindGridAcqPaymentTerms(PageSize, PageNo - 1);
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForAcqDeal), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        #endregion

        #region Methods

        private bool SaveRemark(string HdnRemark)
        {
            Acq_Deal_Service objADS = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
            objDeal = objADS.GetById(objDeal_Schema.Deal_Code);
            objDeal.Payment_Terms_Conditions = HdnRemark.Trim().Substring(0, Math.Min(HdnRemark.Trim().Length, 4000));
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
            objDeal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            if (objDeal.Acq_Deal_Payment_Terms.Count <= 0)
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
                lstPayment_Terms.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect});
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
                foreach (Acq_Deal_Cost costInstance in objDeal.Acq_Deal_Cost)
                {
                    lstCostTypeCode.AddRange(costInstance.Acq_Deal_Cost_Costtype.Select(c => c.Cost_Type_Code.Value).ToList());
                }
                List<SelectListItem> lstCost_Type = new SelectList(new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && lstCostTypeCode.Contains(x.Cost_Type_Code)), "Cost_Type_Code", "Cost_Type_Name").ToList();
                lstCost_Type.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.Cost_Type_List = lstCost_Type;
            }
            else
            {
                List<int> lstCostTypeCode = new List<int>();
                foreach (Acq_Deal_Cost costInstance in objDeal.Acq_Deal_Cost)
                {
                    lstCostTypeCode.AddRange(costInstance.Acq_Deal_Cost_Costtype.Select(c => c.Cost_Type_Code.Value).ToList());
                }
                List<SelectListItem> lstCost_Type = new SelectList(new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && lstCostTypeCode.Contains(x.Cost_Type_Code)), "Cost_Type_Code", "Cost_Type_Name", Cost_Type_Code).ToList();
                lstCost_Type.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.Cost_Type_List = lstCost_Type;
            }
        }

        public JsonResult CostTypeAmount(int CostTypeCode)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            string[] AcqDealCostCode = new Acq_Deal_Cost_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Acq_Deal_Code == objDeal.Acq_Deal_Code).Select(s => s.Acq_Deal_Cost_Code.ToString()).ToArray();
            int? amount =Convert.ToInt32(new Acq_Deal_Cost_Costtype_Service(objLoginEntity.ConnectionStringName).SearchFor(w => AcqDealCostCode.Contains(w.Acq_Deal_Cost_Code.ToString()) && w.Cost_Type_Code == CostTypeCode).Select(s => s.Amount).FirstOrDefault());

            var obj = new
            {
                Amount = amount,
                CTCode = CostTypeCode
            };

            objJson.Add("Amount", amount);
            return Json(obj);
        }
        public JsonResult ValidateIsDuplicate(int Acq_Deal_Payment_Term_Code ,int PaymentTermCode, int CostTypeCode)
        {
            int Count = 0;

            int[] AcqDealPaymentTermCode = new Acq_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objDeal.Acq_Deal_Code && x.Payment_Term_Code == PaymentTermCode
            && x.Cost_Type_Code == CostTypeCode).Select(s => s.Acq_Deal_Payment_Terms_Code).Distinct().ToArray();

            if (AcqDealPaymentTermCode.Contains(Acq_Deal_Payment_Term_Code))
            {
                Count = 0;
            }
            else
            {
                Count = new Acq_Deal_Payment_Terms_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Payment_Term_Code == PaymentTermCode && x.Acq_Deal_Code == objDeal.Acq_Deal_Code && x.Cost_Type_Code == CostTypeCode).Distinct().Count();
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
