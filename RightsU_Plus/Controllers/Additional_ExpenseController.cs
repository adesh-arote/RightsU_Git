using RightsU_Dapper.BLL.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_BLL;
//using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Additional_ExpenseController : BaseController
    {
        private readonly Additional_Expense_Services objAdditionalExpenseService = new Additional_Expense_Services();
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();


        #region --Properties--
        private List<RightsU_Dapper.Entity.Master_Entities.Additional_Expense> lstAdditional_Expense
        {
            get
            {
                if (Session["lstAdditional_Expense"] == null)
                    Session["lstAdditional_Expense"] = new List<RightsU_Dapper.Entity.Master_Entities.Additional_Expense>();
                return (List<RightsU_Dapper.Entity.Master_Entities.Additional_Expense>)Session["lstAdditional_Expense"];
            }
            set { Session["lstAdditional_Expense"] = value; }
        }
        private List<RightsU_Dapper.Entity.Master_Entities.Additional_Expense> lstAdditional_Expense_Searched
        {
            get
            {
                if (Session["lstAdditional_Expense_Searched"] == null)
                    Session["lstAdditional_Expense_Searched"] = new List<RightsU_Dapper.Entity.Master_Entities.Additional_Expense>();
                return (List<RightsU_Dapper.Entity.Master_Entities.Additional_Expense>)Session["lstAdditional_Expense_Searched"];
            }
            set { Session["lstAdditional_Expense_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAdditionalExpense);
            string modulecode = GlobalParams.ModuleCodeForAdditionalExpense.ToString();
            ViewBag.Code = modulecode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstAdditional_Expense_Searched = lstAdditional_Expense = objAdditionalExpenseService.GetAll().ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Additional_Expense/Index.cshtml");
        }
        public PartialViewResult BindAdditional_ExpenseList(int pageNo, int recordPerPage, int additionalExpenseCode, string commandName, string sortType)
        {
            ViewBag.AdditionalExpenseCode = additionalExpenseCode;
            ViewBag.CommandName = commandName;
            List<RightsU_Dapper.Entity.Master_Entities.Additional_Expense> lst = new List<RightsU_Dapper.Entity.Master_Entities.Additional_Expense>();
            int RecordCount = 0;
            RecordCount = lstAdditional_Expense_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstAdditional_Expense_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstAdditional_Expense_Searched.OrderBy(o => o.Additional_Expense_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstAdditional_Expense_Searched.OrderByDescending(o => o.Additional_Expense_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Additional_Expense/_Additional_ExpenseList.cshtml", lst);
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
        public JsonResult CheckRecordLock(int additionalExpenseCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (additionalExpenseCode > 0)
            {
                    CommonUtil objCommonUtil = new CommonUtil();
                    isLocked = objCommonUtil.Lock_Record(additionalExpenseCode, GlobalParams.ModuleCodeForAdditionalExpense, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SearchAdditional_Expense(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstAdditional_Expense_Searched = lstAdditional_Expense.Where(w => w.Additional_Expense_Name.ToUpper().Contains(searchText.ToUpper().Trim())).ToList();
            }
            else
                lstAdditional_Expense_Searched = lstAdditional_Expense;

            var obj = new
            {
                Record_Count = lstAdditional_Expense_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult ActiveDeactiveAdditional_Expense(int additionalExpenseCode, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(additionalExpenseCode, GlobalParams.ModuleCodeForAdditionalExpense, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Additional_Expense_Service objService = new Additional_Expense_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Master_Entities.Additional_Expense objAdditionalExpense = objAdditionalExpenseService.GetByID(additionalExpenseCode);
                objAdditionalExpense.Is_Active = doActive;
                //objAdditionalExpense.EntityState = State.Modified;
                dynamic resultSet;
                objAdditionalExpenseService.AddEntity(objAdditionalExpense);
                bool isValid = true;// objService.Save(objAdditionalExpense, out resultSet);

                if (isValid)
                {
                    lstAdditional_Expense.Where(w => w.Additional_Expense_Code == additionalExpenseCode).First().Is_Active = doActive;
                    lstAdditional_Expense_Searched.Where(w => w.Additional_Expense_Code == additionalExpenseCode).First().Is_Active = doActive;
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
        public JsonResult SaveAdditional_Expense(int additionalExpenseCode, string additionalExpenseName, string sapGLGroupCode, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;

            if (additionalExpenseCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            //Additional_Expense_Service objService = new Additional_Expense_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Master_Entities.Additional_Expense objAdditionalExpense = null;

            if (additionalExpenseCode > 0)
            {
                objAdditionalExpense = objAdditionalExpenseService.GetByID(additionalExpenseCode);
                //objAdditionalExpense.EntityState = State.Modified;
            }
            else
            {
                objAdditionalExpense = new RightsU_Dapper.Entity.Master_Entities.Additional_Expense();
                //objAdditionalExpense.EntityState = State.Added;
                objAdditionalExpense.Inserted_On = System.DateTime.Now;
                objAdditionalExpense.Inserted_By = objLoginUser.Users_Code;
            }
           objAdditionalExpense.Last_Updated_Time = DateTime.Now;
           objAdditionalExpense.Last_Action_By = objLoginUser.Users_Code;
           objAdditionalExpense.Is_Active = "Y";
           objAdditionalExpense.Additional_Expense_Name = additionalExpenseName.Trim();
            objAdditionalExpense.SAP_GL_Group_Code = sapGLGroupCode.Trim();
            dynamic resultSet;
            objAdditionalExpenseService.AddEntity(objAdditionalExpense);
            bool isValid = true;// objService.Save(objAdditionalExpense, out resultSet);

            if (isValid)
            {
               lstAdditional_Expense_Searched = lstAdditional_Expense = objAdditionalExpenseService.GetAll().OrderByDescending(x => x.Last_Updated_Time).ToList();
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
                RecordCount = lstAdditional_Expense_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        private string GetUserModuleRights()
        {
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForAdditionalExpense), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
    }
}
