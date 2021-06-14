//using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
using System.Web.Mvc;
//using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class CategoryController : BaseController
    {
        private readonly USP_Service objProcedureService = new USP_Service();
        private readonly Category_Service objCategoryService = new Category_Service();

        #region --Properties--
        private List<RightsU_Dapper.Entity.Category> lstCategory
        {
            get
            {
                if (Session["lstCategory"] == null)
                    Session["lstCategory"] = new List<RightsU_Dapper.Entity.Category>();
                return (List<RightsU_Dapper.Entity.Category>)Session["lstCategory"];
            }
            set { Session["lstCategory"] = value; }
        }

        private List<RightsU_Dapper.Entity.Category> lstCategory_Searched
        {
            get
            {
                if (Session["lstCategory_Searched"] == null)
                    Session["lstCategory_Searched"] = new List<RightsU_Dapper.Entity.Category>();
                return (List<RightsU_Dapper.Entity.Category>)Session["lstCategory_Searched"];
            }
            set { Session["lstCategory_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForCategory);
            string modulecode = GlobalParams.ModuleCodeForCategory.ToString();
            ViewBag.Code = modulecode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstCategory_Searched = lstCategory = (List<RightsU_Dapper.Entity.Category>)objCategoryService.GetList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Category/Index.cshtml");
        }
        public PartialViewResult BindCategoryList(int pageNo, int recordPerPage, int categoryCode, string commandName, string sortType)
        {
            ViewBag.CategoryCode = categoryCode;
            ViewBag.CommandName = commandName;
            List<RightsU_Dapper.Entity.Category> lst = new List<RightsU_Dapper.Entity.Category>();
            int RecordCount = 0;
            RecordCount = lstCategory_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstCategory_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstCategory_Searched.OrderBy(o => o.Category_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstCategory_Searched.OrderByDescending(o => o.Category_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Category/_CategoryList.cshtml", lst);
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
        public JsonResult CheckRecordLock(int categoryCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (categoryCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(categoryCode, GlobalParams.ModuleCodeForCategory, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SearchCategory(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstCategory_Searched = lstCategory.Where(w => w.Category_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstCategory_Searched = lstCategory;

            var obj = new
            {
                Record_Count = lstCategory_Searched.Count
            };
            return Json(obj);
        }
        private string GetUserModuleRights()
        {
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForCategory), objLoginUser.Security_Group_Code,objLoginUser.Users_Code);
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        public JsonResult ActiveDeactiveCategory(int categoryCode, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(categoryCode, GlobalParams.ModuleCodeForCategory, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Category_Service objService = new Category_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Category objCategory = objCategoryService.GetCategoryByID(categoryCode);
                objCategory.Is_Active = doActive;
                // objCategory.EntityState = State.Modified;
                objCategoryService.UpdateCategory(objCategory);
                 dynamic resultSet;
                //bool isValid = objService.Save(objCategory, out resultSet);
                bool isValid =  true;

                if (isValid)
                {
                    lstCategory.Where(w => w.Category_Code == categoryCode).First().Is_Active = doActive;
                    lstCategory_Searched.Where(w => w.Category_Code == categoryCode).First().Is_Active = doActive;
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

        public JsonResult SaveCategory(int categoryCode, string categoryName, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;

            if (categoryCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            //Category_Service objService = new Category_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Category objCategory = null;

            if (categoryCode > 0)
            {
                objCategory = objCategoryService.GetCategoryByID(categoryCode);
                //objCategory.EntityState = State.Modified;
            }
            else
            {
                objCategory = new RightsU_Dapper.Entity.Category();
                //objCategory.EntityState = State.Added;
                objCategory.Inserted_On = DateTime.Now;
                objCategory.Inserted_By = objLoginUser.Users_Code;
            }

            objCategory.Last_Updated_Time = DateTime.Now;
            objCategory.Last_Action_By = objLoginUser.Users_Code;
            objCategory.Is_Active = "Y";
            objCategory.Category_Name = categoryName;

            string resultSet;
            bool isDuplicate = objCategoryService.Validate(objCategory, out resultSet);
            if (isDuplicate)
            {
                if (categoryCode > 0)
                {
                    objCategoryService.UpdateCategory(objCategory);
                }
                else
                {
                    objCategoryService.AddEntity(objCategory);
                }
            }
            else
            {
                status = "E";
                message = resultSet;
            }
                //bool isValid = objService.Save(objCategory, out resultSet);
                bool isValid = true;
            if(isValid)
            {
                lstCategory_Searched = lstCategory = objCategoryService.GetList().OrderByDescending(x => x.Last_Updated_Time).ToList();
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
                RecordCount = lstCategory_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}


