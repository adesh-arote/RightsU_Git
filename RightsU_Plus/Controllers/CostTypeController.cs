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
    public class CostTypeController : BaseController
    {
        private readonly USP_Service objProcedureService = new USP_Service();
        private readonly Cost_Type_Service objCostType_Service = new Cost_Type_Service();
        #region --Properties--
        private List<RightsU_Dapper.Entity.Cost_Type> lstCostType
        {
            get
            {
                if (Session["lstCostType"] == null)
                    Session["lstCostType"] = new List<RightsU_Dapper.Entity.Cost_Type>();
                return (List<RightsU_Dapper.Entity.Cost_Type>)Session["lstCostType"];
            }
            set { Session["lstCostType"] = value; }
        }

        private List<RightsU_Dapper.Entity.Cost_Type> lstCostType_Searched
        {
            get
            {
                if (Session["lstCostType_Searched"] == null)
                    Session["lstCostType_Searched"] = new List<RightsU_Dapper.Entity.Cost_Type>();
                return (List<RightsU_Dapper.Entity.Cost_Type>)Session["lstCostType_Searched"];
            }
            set { Session["lstCostType_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForCostType);
            //string modulecode = Request.QueryString["modulecode"];
            string modulecode = GlobalParams.ModuleCodeForCostType.ToString();
            ViewBag.Code = modulecode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstCostType_Searched = lstCostType = (List<RightsU_Dapper.Entity.Cost_Type>)objCostType_Service.GetList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/CostType/Index.cshtml");
        }
        public PartialViewResult BindCostTypeList(int pageNo, int recordPerPage, int costTypeCode, string commandName, string sortType)
        {
            ViewBag.CostTypeCode = costTypeCode;
            ViewBag.CommandName = commandName;
            List<RightsU_Dapper.Entity.Cost_Type> lst = new List<RightsU_Dapper.Entity.Cost_Type>();
            int RecordCount = 0;
            RecordCount = lstCostType_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstCostType_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstCostType_Searched.OrderBy(o => o.Cost_Type_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstCostType_Searched.OrderByDescending(o => o.Cost_Type_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/CostType/_CostTypeList.cshtml", lst);
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
        public JsonResult CheckRecordLock(int costTypeCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (costTypeCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(costTypeCode, GlobalParams.ModuleCodeForCostType, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        private string GetUserModuleRights()
        {
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForCostType), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        public JsonResult SearchCostType(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstCostType_Searched = lstCostType.Where(w => w.Cost_Type_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstCostType_Searched = lstCostType;

            var obj = new
            {
                Record_Count = lstCostType_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult ActiveDeactiveCostType(int costTypeCode, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(costTypeCode, GlobalParams.ModuleCodeForCostType, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Cost_Type_Service objService = new Cost_Type_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Cost_Type objCostType = objCostType_Service.GetGenresByID(costTypeCode);
                objCostType.Is_Active = doActive;
                objCostType_Service.UpdateGenres(objCostType);
                //objCostType.EntityState = State.Modified;
                dynamic resultSet;
                //bool isValid = objService.Save(objCostType, out resultSet);
                bool isValid = true;

                if (isValid)
                {
                    lstCostType.Where(w => w.Cost_Type_Code == costTypeCode).First().Is_Active = doActive;
                    lstCostType_Searched.Where(w => w.Cost_Type_Code == costTypeCode).First().Is_Active = doActive;
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
        public JsonResult SaveCostType(int costTypeCode, string costTypeName, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (costTypeCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            //Cost_Type_Service objService = new Cost_Type_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Cost_Type objCostType = null;

            if (costTypeCode > 0)
            {
                objCostType = objCostType_Service.GetGenresByID(costTypeCode);
               
                //objCostType.EntityState = State.Modified;
            }
            else
            {
                objCostType = new RightsU_Dapper.Entity.Cost_Type();
                //objCostType.EntityState = State.Added;
                objCostType.Inserted_On = DateTime.Now;
                objCostType.Inserted_By = objLoginUser.Users_Code;
            }

            objCostType.Last_Updated_Time = DateTime.Now;
            objCostType.Last_Action_By = objLoginUser.Users_Code;
            objCostType.Is_Active = "Y";
            objCostType.Cost_Type_Name = costTypeName;

            string resultSet;
            bool isDuplicate = objCostType_Service.Validate(objCostType, out resultSet);
            if (isDuplicate)
            {
                if (costTypeCode > 0)
                {
                    objCostType_Service.UpdateGenres(objCostType);
                }
                else
                {
                    objCostType_Service.AddEntity(objCostType);
                }
                if (costTypeCode > 0)
                    message = objMessageKey.Recordupdatedsuccessfully;
                else
                    message = objMessageKey.Recordsavedsuccessfully;
            }
            else
            {
                status = "E";
                message = resultSet;
            }
                //bool isValid = objService.Save(objCostType, out resultSet);

                bool isValid = true;
            if (isValid)
            {
                lstCostType_Searched = lstCostType = objCostType_Service.GetList().OrderByDescending(x => x.Last_Updated_Time).ToList();
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
                RecordCount = lstCostType_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}

