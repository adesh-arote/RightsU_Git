using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Payment_TermController : BaseController
    {
        #region --Properties--

        private List<RightsU_Entities.Payment_Terms> lstPayment_Term
        {
            get
            {
                if (Session["lstPayment_Term"] == null)
                    Session["lstPayment_Term"] = new List<RightsU_Entities.Payment_Terms>();
                return (List<RightsU_Entities.Payment_Terms>)Session["lstPayment_Term"];
            }
            set { Session["lstPayment_Term"] = value; }
        }

        private List<RightsU_Entities.Payment_Terms> lstPayment_Term_Searched
        {
            get
            {
                if (Session["lstPayment_Term_Searched"] == null)
                    Session["lstPayment_Term_Searched"] = new List<RightsU_Entities.Payment_Terms>();
                return (List<RightsU_Entities.Payment_Terms>)Session["lstPayment_Term_Searched"];
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
            lstPayment_Term_Searched = lstPayment_Term = new Payment_Terms_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
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
            List<RightsU_Entities.Payment_Terms> lst = new List<RightsU_Entities.Payment_Terms>();
            int RecordCount = 0;
            RecordCount = lstPayment_Term_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstPayment_Term_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstPayment_Term_Searched.OrderBy(o => o.Payment_Terms1).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstPayment_Term_Searched.OrderByDescending(o => o.Payment_Terms1).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
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
                lstPayment_Term_Searched = lstPayment_Term.Where(w => w.Payment_Terms1.ToUpper().Contains(searchText.ToUpper().Trim())).ToList();
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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForPaymentTerms), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        public JsonResult ActiveDeactivePayment_Term(int paymentTermCode, string doActive)
        {
            string status = "S", message = "", strMessage = "", Action = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(paymentTermCode, GlobalParams.ModuleCodeForPaymentTerms, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                Payment_Terms_Service objService = new Payment_Terms_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Payment_Terms objPaymentTerm = objService.GetById(paymentTermCode);
                objPaymentTerm.Is_Active = doActive;
                objPaymentTerm.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objPaymentTerm, out resultSet);
                if (isValid)
                {
                    lstPayment_Term.Where(w => w.Payment_Terms_Code == paymentTermCode).First().Is_Active = doActive;
                    lstPayment_Term_Searched.Where(w => w.Payment_Terms_Code == paymentTermCode).First().Is_Active = doActive;
                    if (doActive == "Y")
                    {
                        Action = "A"; // A = "Activate";
                        message = objMessageKey.Recordactivatedsuccessfully;
                    }          
                    else
                    {
                        Action = "DA"; // DA = "Deactivate";
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                    }       

                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objPaymentTerm);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForPaymentTerms, objPaymentTerm.Payment_Terms_Code, LogData, Action, objLoginUser.Users_Code);
                    }
                    catch (Exception ex)
                    {


                    }
                }
                else
                {
                    status = "E";
                    message = resultSet;
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
            string status = "S", message = objMessageKey.Recordsavedsuccessfully, Action = "C"; // C = "Create"; 
            if (paymentTermcode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            Payment_Terms_Service objService = new Payment_Terms_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Payment_Terms objPaymentTerm = null;

            if (paymentTermcode > 0)
            {
                objPaymentTerm = objService.GetById(paymentTermcode);
                objPaymentTerm.EntityState = State.Modified;
                Action = "U"; // U = "Update"; 
            }
            else
            {
                objPaymentTerm = new RightsU_Entities.Payment_Terms();
                objPaymentTerm.EntityState = State.Added;
                objPaymentTerm.Inserted_On = DateTime.Now;
                objPaymentTerm.Inserted_By = objLoginUser.Users_Code;
            }

            objPaymentTerm.Last_Updated_Time = DateTime.Now;
            objPaymentTerm.Last_Action_By = objLoginUser.Users_Code;
            objPaymentTerm.Is_Active = "Y";
            objPaymentTerm.Payment_Terms1 = paymentTermName.Trim();
            dynamic resultSet;
            bool isValid = objService.Save(objPaymentTerm, out resultSet);
            if (isValid)
            {
                lstPayment_Term_Searched = lstPayment_Term = objService.SearchFor(s => true).OrderByDescending(x => x.Last_Updated_Time).ToList();

                try
                {
                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objPaymentTerm);
                    bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForPaymentTerms, objPaymentTerm.Payment_Terms_Code, LogData, Action, objLoginUser.Users_Code);
                }
                catch (Exception ex)
                {


                }
            }
            else
            {
                status = "E";
                message = resultSet;
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
