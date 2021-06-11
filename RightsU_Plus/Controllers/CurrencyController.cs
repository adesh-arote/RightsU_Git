using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
//using RightsU_Entities;
//using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class CurrencyController : BaseController
    {
        private readonly USP_Service objProcedureService = new USP_Service();
        private readonly Currency_Service objCurrencyService = new Currency_Service();
        private readonly Currency_Exchange_Rate_Service objCurrency_Exchange_RateService = new Currency_Exchange_Rate_Service();

        #region --- Properties ---
        private List<RightsU_Dapper.Entity.Currency> lstCurrency
        {
            get
            {
                if (Session["lstCurrency"] == null)
                    Session["lstCurrency"] = new List<RightsU_Dapper.Entity.Currency>();
                return (List<RightsU_Dapper.Entity.Currency>)Session["lstCurrency"];
            }
            set { Session["lstCurrency"] = value; }
        }

        private List<RightsU_Dapper.Entity.Currency> lstCurrency_Searched
        {
            get
            {
                if (Session["lstCurrency_Searched"] == null)
                    Session["lstCurrency_Searched"] = new List<RightsU_Dapper.Entity.Currency>();
                return (List<RightsU_Dapper.Entity.Currency>)Session["lstCurrency_Searched"];
            }
            set { Session["lstCurrency_Searched"] = value; }
        }

        private RightsU_Dapper.Entity.Currency objCurrency
        {
            get
            {
                if (Session["objCurrency"] == null)
                    Session["objCurrency"] = new RightsU_Dapper.Entity.Currency();
                return (RightsU_Dapper.Entity.Currency)Session["objCurrency"];
            }
            set { Session["objCurrency"] = value; }
        }

        private Currency_Service objCurrency_Service
        {
            get
            {
                if (Session["objCurrency_Service"] == null)
                    Session["objCurrency_Service"] = new Currency_Service();
                return (Currency_Service)Session["objCurrency_Service"];
            }
            set { Session["objCurrency_Service"] = value; }
        }
        Type[] RelationList = new Type[] { typeof(Currency_Exchange_Rate)};

        #endregion

        public ViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForCurrency);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForCurrency.ToString();
            string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = SysLanguageCode;
            FetchData();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Currency/Index.cshtml");
        }


        public PartialViewResult BindCurrencyList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Dapper.Entity.Currency> lst = new List<RightsU_Dapper.Entity.Currency>();
            int RecordCount = 0;
            RecordCount = lstCurrency_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstCurrency_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstCurrency_Searched.OrderBy(o => o.Currency_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstCurrency_Searched.OrderByDescending(o => o.Currency_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Currency/_CurrencyList.cshtml", lst);
        }

        #region  --- Other Methods ---
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

        private void FetchData()
        {
            lstCurrency_Searched = lstCurrency = objCurrencyService.GetList().OrderByDescending(o => o.Last_Updated_Time).ToList();
        }

        private string GetUserModuleRights()
        {
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForCurrency), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        #endregion

        public JsonResult SearchCurrency(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstCurrency_Searched = lstCurrency.Where(w => w.Currency_Name.ToUpper().Contains(searchText.ToUpper())
                || w.Currency_Sign.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstCurrency_Searched = lstCurrency;

            var obj = new
            {
                Record_Count = lstCurrency_Searched.Count
            };

            return Json(obj);
        }

        public JsonResult ActiveDeactiveCurrency(int currencyCode, string doActive)
        {
            //string status = "S", message = "";
             string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(currencyCode, GlobalParams.ModuleCodeForCurrency, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Currency_Service objService = new Currency_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Currency objCurrency = objCurrencyService.GetTalentByID(currencyCode);
                objCurrency.Is_Active = doActive;
                //objCurrency.EntityState = State.Modified;
                objCurrencyService.AddEntity(objCurrency);
                dynamic resultSet;
                // bool isValid = objService.Save(objCurrency, out resultSet);
                bool isValid = true;
                if (isValid)
                {
                    lstCurrency.Where(w => w.Currency_Code == currencyCode).First().Is_Active = doActive;
                    lstCurrency_Searched.Where(w => w.Currency_Code == currencyCode).First().Is_Active = doActive;
                    if (doActive == "Y")
                        message = objMessageKey.Recordactivatedsuccessfully;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                }
                else
                {
                    status = "E";
                    if (doActive == "Y")
                        message = objMessageKey.CouldNotActivatedRecord;
                    else
                        message = objMessageKey.CouldNotDeactivatedRecord;
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

        public PartialViewResult AddEditViewCurrency(int currencyCode, string commandName)
        {
            objCurrency = null;
            objCurrency_Service = null;
            string enableBaseCurrency = "Y";
            int count = lstCurrency.Where(w => w.Is_Base_Currency == "Y" && w.Currency_Code != currencyCode).Count();
            if (count > 0)
                enableBaseCurrency = "N";
            else
            {
                count = lstCurrency.Where(w => w.Currency_Code == currencyCode &&
                    (w.Acq_Deal.Count() > 0 || w.Syn_Deal.Count() > 0)
                ).Count();

                if (count > 0)
                    enableBaseCurrency = "N";
            }

            if (currencyCode > 0)
                objCurrency = objCurrencyService.GetTalentByID(currencyCode, RelationList);

            ViewBag.CommandName = commandName;
            ViewBag.EnableBaseCurrency = enableBaseCurrency;
            return PartialView("~/Views/Currency/_AddEditCurrency.cshtml", objCurrency);
        }

        public JsonResult CheckRecordLock(int currencyCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (currencyCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(currencyCode, GlobalParams.ModuleCodeForCurrency, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public JsonResult SaveCurrency(int currencyCode, string currencyName, string currencySign, bool isBaseCurrency, int Record_Code)
        {
            string status = "S", message = "";

            if (currencyCode > 0)
                status = "S";
            //objCurrency.EntityState = State.Modified;
            else
            {
                objCurrency_Service = null;
                // objCurrency.EntityState = State.Added;
                objCurrency.Inserted_On = DateTime.Now;
                objCurrency.Inserted_By = objLoginUser.Users_Code;
            }

            objCurrency.Currency_Name = currencyName;
            objCurrency.Currency_Sign = currencySign;
            objCurrency.Is_Base_Currency = (isBaseCurrency) ? "Y" : "N";
            objCurrency.Last_Updated_Time = DateTime.Now;
            objCurrency.Last_Action_By = objLoginUser.Users_Code;
            objCurrency.Is_Active = "Y";

            dynamic resultSet;
            if (currencyCode > 0)
            {
                objCurrencyService.UpdateCurrency(objCurrency);
            }
            else
            {
                objCurrencyService.AddEntity(objCurrency);
            }
            //if (!objCurrency_Service.Save(objCurrency, out resultSet))
            if(1 == 2)
            {
                status = "E";
                message = "";
            }
            else
            {
                if (currencyCode > 0)
                    message = objMessageKey.Recordupdatedsuccessfully;
                else
                    message = objMessageKey.Recordsavedsuccessfully;

                objCurrency = null;
                objCurrency_Service = null;
                int recordLockingCode = Convert.ToInt32(Record_Code);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                FetchData();
            }

            var obj = new
            {
                RecordCount = lstCurrency.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public PartialViewResult BindExchangeRateList(string commandName, string dummyGuid)
        {
            string maxDate = "";
            if (objCurrency.Currency_Exchange_Rate.Count() > 0)
                maxDate = objCurrency.Currency_Exchange_Rate.Select(s => s.Effective_Start_Date).Max().ToString(GlobalParams.DateFormat);

            string canEdit = "Y", canDelete = "Y";

            if (objCurrency.Is_Base_Currency == "")
                canEdit = canDelete = "N";

            if (objCurrency.Acq_Deal.Count() > 0 || objCurrency.Syn_Deal.Count() > 0)
                canDelete = "N";

            ViewBag.CommandName = commandName;
            ViewBag.DummmyGuid = dummyGuid;
            ViewBag.CanEdit = canEdit;
            ViewBag.CanDelete = canDelete;
            ViewBag.MaxDate = maxDate;
            List<Currency_Exchange_Rate> lst = objCurrency.Currency_Exchange_Rate.OrderBy(x=>x.Effective_Start_Date).ToList();
            return PartialView("~/Views/Currency/_CurrencyExchangeRateList.cshtml",lst);
        }

        public JsonResult SaveExchangeRate(string dummyGuid, DateTime effectiveDate, decimal exchangeRate)
        {
            string status = "S", message = "",Operation = "" ; 

            Currency_Exchange_Rate objCER = objCurrency.Currency_Exchange_Rate.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
            if (objCER == null)
            {
                Operation = "Add";
                objCER = new Currency_Exchange_Rate();
                //objCER.EntityState = State.Added;
                objCurrency.Currency_Exchange_Rate.Add(objCER);
            }
            else
            {
                Operation = "Edit";
                if (objCER.Currency_Exchange_Rate_Code > 0)
                    status = "S";
               // objCurrency.Currency_Exchange_Rate.up
                //objCurrencyService.UpdateMusic_Deal()
                    //objCER.EntityState = State.Modified;
            }
            
                objCER.Effective_Start_Date = effectiveDate;
            objCER.Exchange_Rate = exchangeRate;
            if (Operation == "Add" )
            {
                objCurrency_Exchange_RateService.AddEntity(objCER);
            }
            else if(Operation == "Edit")
            {
                objCurrency_Exchange_RateService.UpdateMusic_Deal(objCER);
            }
            object obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult DeleteExchangeRate(string dummyGuid)
        {
            string status = "S", message = "";

            Currency_Exchange_Rate objCER = objCurrency.Currency_Exchange_Rate.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
            if (objCER != null)
            {
                if (objCER.Currency_Exchange_Rate_Code > 0)
                {
                    status = "Test";
                    objCurrency.Currency_Exchange_Rate.Remove(objCER);
                    //objCurrency_Exchange_RateService.DeleteMusic_Deal(objCER);
                }
                //objCER.EntityState = State.Deleted;
                else
                    objCurrency.Currency_Exchange_Rate.Remove(objCER);
            }
            else
            {
                status = "E";
                message = objMessageKey.Objectnotfound;
            }

            object obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}


