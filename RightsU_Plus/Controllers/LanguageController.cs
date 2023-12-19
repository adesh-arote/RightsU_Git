using Newtonsoft.Json;
using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class LanguageController : BaseController
    {
        private List<RightsU_Entities.Language> lstLanguage
        {
            get
            {
                if (Session["lstLanguage"] == null)
                    Session["lstLanguage"] = new List<RightsU_Entities.Language>();
                return (List<RightsU_Entities.Language>)Session["lstLanguage"];
            }
            set { Session["lstLanguage"] = value; }
        }

        private List<RightsU_Entities.Language> lstLanguage_Searched
        {
            get
            {
                if (Session["lstLanguage_Searched"] == null)
                    Session["lstLanguage_Searched"] = new List<RightsU_Entities.Language>();
                return (List<RightsU_Entities.Language>)Session["lstLanguage_Searched"];
            }
            set { Session["lstLanguage_Searched"] = value; }
        }

        public ViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForLanguage);
            string moduleCode = GlobalParams.ModuleCodeForLanguage.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstLanguage_Searched = lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(s => s.Last_Updated_Time).ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Language/Index.cshtml");
        }

        public PartialViewResult BindLanguageList(int pageNo, int recordPerPage, int Language_Code, string commandName, string sortType)
        {
            ViewBag.Language_Code = Language_Code;
            ViewBag.CommandName = commandName;
            List<RightsU_Entities.Language> lst = new List<RightsU_Entities.Language>();
            int RecordCount = 0;
            RecordCount = lstLanguage_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstLanguage_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstLanguage_Searched.OrderBy(o => o.Language_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstLanguage_Searched.OrderByDescending(o => o.Language_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Language/_Language.cshtml", lst);
        }

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

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        public JsonResult SearchLanguage(string searchText)
        {

            if (!string.IsNullOrEmpty(searchText))
            {
                lstLanguage_Searched = lstLanguage.Where(w => w.Language_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstLanguage_Searched = lstLanguage;

            var obj = new
            {
                Record_Count = lstLanguage_Searched.Count
            };
            return Json(obj);
        }

        //private void FetchData()
        //{
        //    lstLanguage_Searched = lstLanguage = new Language_Service().SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
        //}

        public JsonResult CheckRecordLock(int Language_Code)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Language_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Language_Code, GlobalParams.ModuleCodeForLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public JsonResult EditLanguage(int Language_Code)
        {

            string status = "S", message = "Record {ACTION} successfully";
            Language_Service objService = new Language_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Language objTalent = objService.GetById(Language_Code);

            TempData["Action"] = "EditTalent";
            TempData["idTalent"] = objTalent.Language_Code;

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult ActiveDeactiveLanguage(int Language_Code, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "", Action = Convert.ToString(ActionType.A); // A = "Active";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(Language_Code, GlobalParams.ModuleCodeForLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                Language_Service objService = new Language_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Language objLanguage = objService.GetById(Language_Code);
                objLanguage.Is_Active = doActive;
                objLanguage.Last_Updated_Time = DateTime.Now;
                objLanguage.Last_Action_By = objLoginUser.Users_Code;
                objLanguage.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objLanguage, out resultSet);
                if (isValid)
                {
                    lstLanguage.Where(w => w.Language_Code == Language_Code).First().Is_Active = doActive;
                    lstLanguage_Searched.Where(w => w.Language_Code == Language_Code).First().Is_Active = doActive;

                    if (doActive != "Y")
                        Action = Convert.ToString(ActionType.D); // D = "Deactive";

                    try
                    {
                        objLanguage.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objLanguage.Inserted_By));
                        objLanguage.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objLanguage.Last_Action_By));

                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objLanguage);
                        //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForLanguage, objLanguage.Language_Code, LogData, Action, objLoginUser.Users_Code);

                        MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                        objAuditLog.moduleCode = GlobalParams.ModuleCodeForLanguage;
                        objAuditLog.intCode = objLanguage.Language_Code;
                        objAuditLog.logData = LogData;
                        objAuditLog.actionBy = objLoginUser.Login_Name;
                        objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objLanguage.Last_Updated_Time));
                        objAuditLog.actionType = Action;
                        var strCheck = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().PostAuditLogAPI(objAuditLog, "");

                        var LogDetail = JsonConvert.DeserializeObject<JsonData>(strCheck);
                        if (Convert.ToString(LogDetail.ErrorMessage) == "Error")
                        {

                        }
                    }
                    catch (Exception ex)
                    {

                    }
                }
                else
                {
                    status = "E";
                   // message = "Cound not {ACTION} record";
                    message = resultSet;
                }
                objCommonUtil.Release_Record(RLCode, objLoginEntity.ConnectionStringName);
                if (doActive == "Y")
                    message = objMessageKey.Recordactivatedsuccessfully;
                //message = message.Replace("{ACTION}", "Activated");
                else
                    message = objMessageKey.Recorddeactivatedsuccessfully;
                    //message = message.Replace("{ACTION}", "Deactivated");

            }
            else
            {
                status = "E";
                //message = "Cound not {ACTION} record";
                message = strMessage;
            }


            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult SaveLanguage(int Language_Code, string Language_Name, int Record_Code)
        {
            string status = "S", message = "Record {ACTION} successfully", Action = Convert.ToString(ActionType.C); // C = "Create";
            Language_Service objService = new Language_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Language objLanguage = null;

            if (Language_Code > 0)
            {
                objLanguage = objService.GetById(Language_Code);
                objLanguage.EntityState = State.Modified;
            }
            else
            {
                objLanguage = new RightsU_Entities.Language();
                objLanguage.EntityState = State.Added;
                objLanguage.Inserted_On = DateTime.Now;
                objLanguage.Inserted_By = objLoginUser.Users_Code;
            }

            objLanguage.Last_Updated_Time = DateTime.Now;
            objLanguage.Last_Action_By = objLoginUser.Users_Code;
            objLanguage.Is_Active = "Y";
            objLanguage.Language_Name = Language_Name;
            dynamic resultSet;
            bool isValid = objService.Save(objLanguage, out resultSet);
            if (isValid)
            {
                if (Language_Code > 0)
                    Action = Convert.ToString(ActionType.U); // U = "Update";

                try
                {
                    objLanguage.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objLanguage.Inserted_By));
                    objLanguage.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objLanguage.Last_Action_By));

                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objLanguage);
                    //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForLanguage, objLanguage.Language_Code, LogData, Action, objLoginUser.Users_Code);

                    MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                    objAuditLog.moduleCode = GlobalParams.ModuleCodeForLanguage;
                    objAuditLog.intCode = objLanguage.Language_Code;
                    objAuditLog.logData = LogData;
                    objAuditLog.actionBy = objLoginUser.Login_Name;
                    objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objLanguage.Last_Updated_Time));
                    objAuditLog.actionType = Action;
                    var strCheck = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().PostAuditLogAPI(objAuditLog, "");

                    var LogDetail = JsonConvert.DeserializeObject<JsonData>(strCheck);
                    if (Convert.ToString(LogDetail.ErrorMessage) == "Error")
                    {

                    }
                }
                catch (Exception ex)
                {

                }

                lstLanguage_Searched = lstLanguage = objService.SearchFor(s => true).OrderByDescending(x => x.Last_Updated_Time).ToList();
            }
            else
            {
                status = "E";
                message = resultSet;
            }
            int recordLockingCode = Convert.ToInt32(Record_Code);
            CommonUtil objCommonUtil = new CommonUtil();
            objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
            if (Language_Code > 0)
                if (status == "E")
                    message = objMessageKey.Languagealreadyexists;
                else
                    message = objMessageKey.Recordupdatedsuccessfully;
            //message = message.Replace("{ACTION}", "updated");
            else
                if (status == "E")
                    message = objMessageKey.Languagealreadyexists;
                else
                    message = objMessageKey.Recordsavedsuccessfully;
                //message = message.Replace("{ACTION}", "saved");

            var obj = new
            {
                RecordCount = lstLanguage_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}
