//using RightsU_BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
//using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;
namespace RightsU_Plus.Controllers
{
    public class GradeMastersController : BaseController
    {
        private readonly Grade_Master_Service objGradeMaster_Service = new Grade_Master_Service();
        private readonly USP_Service objProcedureService = new USP_Service();

        #region --Properties--
        private List<RightsU_Dapper.Entity.Grade_Master> lstGrade_Master
        {
            get
            {
                if (Session["lstGrade_Master"] == null)
                    Session["lstGrade_Master"] = new List<RightsU_Dapper.Entity.Grade_Master>();
                return (List<RightsU_Dapper.Entity.Grade_Master>)Session["lstGrade_Master"];
            }
            set { Session["lstGrade_Master"] = value; }
        }

        private List<RightsU_Dapper.Entity.Grade_Master> lstGrade_Master_Searched
        {
            get
            {
                if (Session["lstGrade_Master_Searched"] == null)
                    Session["lstGrade_Master_Searched"] = new List<RightsU_Dapper.Entity.Grade_Master>();
                return (List<RightsU_Dapper.Entity.Grade_Master>)Session["lstGrade_Master_Searched"];
            }
            set { Session["lstGrade_Master_Searched"] = value; }
        }
        #endregion

        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForGradeMaster);
            string modulecode = GlobalParams.ModuleCodeForGradeMaster.ToString();
            ViewBag.Code = modulecode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstGrade_Master_Searched = lstGrade_Master = (List<RightsU_Dapper.Entity.Grade_Master>)objGradeMaster_Service.GetList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/GradeMasters/Index.cshtml");
        }
        public PartialViewResult BindGrade_MasterList(int pageNo, int recordPerPage, int gradeCode, string commandName, string sortType)
        {
            ViewBag.gradeCode = gradeCode;
            ViewBag.CommandName = commandName;
            List<RightsU_Dapper.Entity.Grade_Master> lst = new List<RightsU_Dapper.Entity.Grade_Master>();
            int RecordCount = 0;
            RecordCount = lstGrade_Master_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstGrade_Master_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstGrade_Master_Searched.OrderBy(o => o.Grade_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstGrade_Master_Searched.OrderByDescending(o => o.Grade_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/GradeMasters/_GradeMasterList.cshtml", lst);
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
        public JsonResult CheckRecordLock(int gradeCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (gradeCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(gradeCode, GlobalParams.ModuleCodeForGradeMaster, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
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
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForGradeMaster), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        public JsonResult SearchGrade_Master(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstGrade_Master_Searched = lstGrade_Master.Where(w => w.Grade_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstGrade_Master_Searched = lstGrade_Master;

            var obj = new
            {
                Record_Count = lstGrade_Master_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult ActiveDeactiveGrade_Master(int gradeCode, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(gradeCode, GlobalParams.ModuleCodeForGradeMaster, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Grade_Master_Service objService = new Grade_Master_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Grade_Master objGradeMaster = objGradeMaster_Service.GetGrade_MasterByID(gradeCode);
                objGradeMaster.Is_Active = doActive;
                //objGradeMaster.EntityState = State.Modified;
                dynamic resultSet;
                //bool isValid = objService.Save(objGradeMaster, out resultSet);
                bool isValid = true;

                if (isValid)
                {
                    lstGrade_Master.Where(w => w.Grade_Code == gradeCode).First().Is_Active = doActive;
                    lstGrade_Master_Searched.Where(w => w.Grade_Code == gradeCode).First().Is_Active = doActive;
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
        public JsonResult SaveGrade_Master(int gradeCode, string gradeName, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (gradeCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            //Grade_Master_Service objService = new Grade_Master_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Grade_Master objGradeMaster = null;

            if (gradeCode > 0)
            {
                objGradeMaster = objGradeMaster_Service.GetGrade_MasterByID(gradeCode);
                //objGradeMaster.EntityState = State.Modified;
            }
            else
            {
                objGradeMaster = new RightsU_Dapper.Entity.Grade_Master();
                //objGradeMaster.EntityState = State.Added;
                objGradeMaster.Inserted_On = DateTime.Now;
                objGradeMaster.Inserted_By = objLoginUser.Users_Code;
            }

            objGradeMaster.Last_Updated_Time = DateTime.Now;
            objGradeMaster.Last_Action_By = objLoginUser.Users_Code;
            objGradeMaster.Is_Active = "Y";
            objGradeMaster.Grade_Name = gradeName;
            string resultSet;
            bool isDuplicate = objGradeMaster_Service.Validate(objGradeMaster, out resultSet);
            //bool isValid = objService.Save(objGradeMaster, out resultSet);
            if (isDuplicate)
            {
                if (gradeCode > 0)
                {
                    objGradeMaster_Service.UpdateMusic_Deal(objGradeMaster);
                }
                else
                {
                    objGradeMaster_Service.AddEntity(objGradeMaster);
                }
            }
            else
            {
                status = "";
                message = resultSet;
            }
            bool isValid = true;

            if (isValid)
            {
                lstGrade_Master_Searched = lstGrade_Master = objGradeMaster_Service.GetList().OrderByDescending(x => x.Last_Updated_Time).ToList();
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
                RecordCount = lstGrade_Master_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}


