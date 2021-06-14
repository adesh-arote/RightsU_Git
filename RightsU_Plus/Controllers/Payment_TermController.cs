using RightsU_Dapper.BLL.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_BLL;
//using RightsU_Dapper.Entity;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Payment_TermController : BaseController
    {
        
        private readonly Payment_Term_Service objPaymentTermsService = new Payment_Term_Service();
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();

        #region --Properties--
        private List<RightsU_Dapper.Entity.Payment_Term> lstPayment_Term
        {
            get
            {
                if (Session["lstPayment_Term"] == null)
                    Session["lstPayment_Term"] = new List<RightsU_Dapper.Entity.Payment_Term>();
                return (List<RightsU_Dapper.Entity.Payment_Term>)Session["lstPayment_Term"];
            }
            set { Session["lstPayment_Term"] = value; }
        }

        private List<RightsU_Dapper.Entity.Payment_Term> lstPayment_Term_Searched
        {
            get
            {
                if (Session["lstPayment_Term_Searched"] == null)
                    Session["lstPayment_Term_Searched"] = new List<RightsU_Dapper.Entity.Payment_Term>();
                return (List<RightsU_Dapper.Entity.Payment_Term>)Session["lstPayment_Term_Searched"];
            }
            set { Session["lstPayment_Term_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForPaymentTerms);
            //string modulecode = Request.QueryString["modulecode"];
            string modulecode = GlobalParams.ModuleCodeForPaymentTerms.ToString();
            ViewBag.Code = modulecode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstPayment_Term_Searched = lstPayment_Term = objPaymentTermsService.GetAll().ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Payment_Term/Index.cshtml");
        }
        public PartialViewResult BindPayment_TermList(int pageNo, int recordPerPage, int paymentTermcode, string commandName, string sortType)
        {
            ViewBag.PaymentTermcode = paymentTermcode;
            ViewBag.CommandName = commandName;
            List<RightsU_Dapper.Entity.Payment_Term> lst = new List<RightsU_Dapper.Entity.Payment_Term>();
            int RecordCount = 0;
            RecordCount = lstPayment_Term_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstPayment_Term_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstPayment_Term_Searched.OrderBy(o => o.Payment_Terms).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstPayment_Term_Searched.OrderByDescending(o => o.Payment_Terms).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Payment_Term/_Payment_TermList.cshtml", lst);
        }
        #region --Other Method--
        private int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= recordCount)
                {
                    int v1 = recordCount / recordPerPage;
                    if ((v1 * recordPerPage) == recordCount)
                        pageNo = v1;
                    else
                        pageNo = v1 + 1;
                }
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                    noOfRecordTake = recordCount - noOfRecordSkip;
                else
                    noOfRecordTake = recordPerPage;
            }
            return pageNo;
        }
        #endregion
        public JsonResult CheckRecordLock(int paymentTermcode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (paymentTermcode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(paymentTermcode, GlobalParams.ModuleCodeForPaymentTerms, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SearchPayment_Term(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstPayment_Term_Searched = lstPayment_Term.Where(w => w.Payment_Terms.ToUpper().Contains(searchText.ToUpper().Trim())).ToList();
            }
            else
                lstPayment_Term_Searched = lstPayment_Term;

            var obj = new
            {
                Record_Count = lstPayment_Term_Searched.Count
            };
            return Json(obj);
        }
        private string GetUserModuleRights()
        {
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForPaymentTerms), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        public JsonResult ActiveDeactivePayment_Term(int paymentTermCode, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(paymentTermCode, GlobalParams.ModuleCodeForPaymentTerms, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Payment_Term_Service objService = new Payment_Term_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Payment_Term objPaymentTerm = objPaymentTermsService.GetByID(paymentTermCode);
                objPaymentTerm.Is_Active = doActive;
                //objPaymentTerm.EntityState = State.Modified;
                dynamic resultSet;
                objPaymentTermsService.AddEntity(objPaymentTerm);
                bool isValid = true;// objService.Save(objPaymentTerm, out resultSet);
                if (isValid)
                {
                    lstPayment_Term.Where(w => w.Payment_Terms_Code == paymentTermCode).First().Is_Active = doActive;
                    lstPayment_Term_Searched.Where(w => w.Payment_Terms_Code == paymentTermCode).First().Is_Active = doActive;
                    if (doActive == "Y")
                        message = objMessageKey.Recordactivatedsuccessfully;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                }
                else
                {
                    status = "E";
                    message = "";
                }
                objCommonUtil.Release_Record(RLCode, objLoginEntity.ConnectionStringName);
            }
            else
            {
                status = "E";
                message = strMessage;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public JsonResult SavePayment_Term(int paymentTermcode, string paymentTermName, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (paymentTermcode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

           // Payment_Term_Service objService = new Payment_Term_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Payment_Term objPaymentTerm = null;

            if (paymentTermcode > 0)
            {
                objPaymentTerm = objPaymentTermsService.GetByID(paymentTermcode);
                //objPaymentTerm.EntityState = State.Modified;
            }
            else
            {
                objPaymentTerm = new RightsU_Dapper.Entity.Payment_Term();
                //objPaymentTerm.EntityState = State.Added;
                objPaymentTerm.Inserted_On = DateTime.Now;
                objPaymentTerm.Inserted_By = objLoginUser.Users_Code;
            }
            objPaymentTerm.Last_Updated_Time = DateTime.Now;
            objPaymentTerm.Last_Action_By = objLoginUser.Users_Code;
            objPaymentTerm.Is_Active = "Y";
            objPaymentTerm.Payment_Terms = paymentTermName.Trim();
            string resultSet;
            bool isDuplicate = objPaymentTermsService.Validate(objPaymentTerm, out resultSet);
            if (isDuplicate)
            {
                    objPaymentTermsService.AddEntity(objPaymentTerm);
            }
            else
            {
                status = "E";
                message = resultSet;
            }
            
            bool isValid = true;// objService.Save(objPaymentTerm, out resultSet);
            if (isValid)
            {
                lstPayment_Term_Searched = lstPayment_Term = objPaymentTermsService.GetAll().OrderByDescending(x => x.Last_Updated_Time).ToList();
            }
            else
            {
                status = "E";
                message = "";
            }
            int recordLockingCode = Convert.ToInt32(Record_Code);
            CommonUtil objCommonUtil = new CommonUtil();
            objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
            var obj = new
            {
                RecordCount = lstPayment_Term_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

    }
}
