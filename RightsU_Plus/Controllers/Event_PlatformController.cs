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
    public class Event_PlatformController : BaseController
    {
        #region  Properties
        private List<RightsU_Entities.Event_Platform> lstEvent_Platform
        {
            get
            {
                if (Session["lstEvent_Platform"] == null)
                    Session["lstEvent_Platform"] = new List<RightsU_Entities.Event_Platform>();
                return (List<RightsU_Entities.Event_Platform>)Session["lstEvent_Platform"];
            }
            set { Session["lstEvent_Platform"] = value; }
        }
        private List<EventTemplateKeys> lstEventTemplateKeys
        {
            get
            {
                if (Session["lstEventTemplateKeys"] == null)
                    Session["lstEventTemplateKeys"] = new List<EventTemplateKeys>();
                return (List<EventTemplateKeys>)Session["lstEventTemplateKeys"];
            }
            set { Session["lstEventTemplateKeys"] = value; }
        }

        private List<Event_Platform> lstEvent_Platform_Searched = new List<Event_Platform>();

        #endregion

        #region UI Methods
        public ActionResult Index()
        {
            string moduleCode = GlobalParams.ModuleCodeForCurrency.ToString();
            string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = SysLanguageCode;

            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Event Platform Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Event Platform Desc", Value = "ND" });
            ViewBag.SortType = lstSort;

            ViewBag.UserModuleRights = GetUserModuleRights();
            return View();
        }

        public PartialViewResult Bind_EventPlatForm(int pageNo, int recordPerPage, int Event_PlatformCode, string commandName, string sortType)
        {
            ViewBag.UserModuleRights = GetUserModuleRights();
            lstEvent_Platform_Searched = new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            ViewBag.Event_PlatformCode = Event_PlatformCode;
            ViewBag.CommandName = commandName;
            List<Event_Platform> lst = new List<Event_Platform>();
            if (lstEvent_Platform != null)
            {
                lstEvent_Platform_Searched = lstEvent_Platform;
            }
            lst = lstEvent_Platform.OrderBy(a => a.Event_Platform_Code).ToList();
            int RecordCount = 0;
            RecordCount = lstEvent_Platform_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                {
                    lst = lstEvent_Platform_Searched.OrderByDescending(o => o.Last_UpDated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "NA")
                {
                    lst = lstEvent_Platform_Searched.OrderBy(o => o.Event_Platform_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "ND")
                {
                    lst = lstEvent_Platform_Searched.OrderByDescending(o => o.Event_Platform_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
            }
            if (commandName == "EDIT")
            {
                Event_Platform_Service objEvent_Platform_Service = new Event_Platform_Service(objLoginEntity.ConnectionStringName);
                Event_Platform ObjEvent_Platform = new Event_Platform();

                ObjEvent_Platform = objEvent_Platform_Service.GetById(Event_PlatformCode);
            }

            return PartialView("_EventPlatform_List", lst);
        }
        public int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= recordCount)
                {
                    int v1 = recordCount / recordPerPage;
                    if ((v1 * recordPerPage) == recordCount)
                    {
                        pageNo = v1;
                    }
                    else
                    {
                        pageNo = v1 + 1;
                    }
                }
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                {
                    noOfRecordTake = recordCount - noOfRecordSkip;
                }
                else
                {
                    noOfRecordTake = recordPerPage;
                }
            }
            return pageNo;
        }

        public JsonResult Search_EventPlatform(string searchText)
        {
            lstEvent_Platform_Searched = new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            if (!string.IsNullOrEmpty(searchText))
            {
                lstEvent_Platform_Searched = lstEvent_Platform_Searched.Where(a => a.Event_Platform_Name.ToUpper().Contains(searchText.ToUpper()) || (a.Event_Platform_Name != null && a.Event_Platform_Name.ToUpper().Contains(searchText.ToUpper()))).ToList();
            }
            var obj = new
            {
                Record_Count = lstEvent_Platform_Searched.Count
            };
            lstEvent_Platform = lstEvent_Platform_Searched;
            return Json(obj);
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForEventPlatform), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        #endregion

        #region Event_Platform_Master
        public JsonResult SaveEventPlatform(int EventPlatform_Code, string EventPlatform_Name, string EventPlatform_short_name, string EnableCCandBCC)
        {
            string status = "S", message = "", Action = Convert.ToString(ActionType.C);

            List<Event_Platform> tempPlatforms = new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList().Where(a => (a.Short_Code.Trim().ToUpper() == EventPlatform_short_name.Trim().ToUpper()) && (a.Event_Platform_Code != EventPlatform_Code)).ToList();
            Event_Platform_Service objEvent_Platform_Service = new Event_Platform_Service(objLoginEntity.ConnectionStringName);
            Event_Platform Objevent_Platform = new Event_Platform();

            if (tempPlatforms.Count == 0)
            {
                if (EventPlatform_Code > 0)
                {
                    Objevent_Platform = objEvent_Platform_Service.GetById(EventPlatform_Code);
                    Objevent_Platform.EntityState = State.Modified;
                }
                else
                {
                    Objevent_Platform = new Event_Platform();
                    Objevent_Platform.EntityState = State.Added;
                    Objevent_Platform.Inserted_By = objLoginUser.Users_Code;
                    Objevent_Platform.Inserted_On = DateTime.Now;
                }
                Objevent_Platform.Event_Platform_Name = EventPlatform_Name;
                Objevent_Platform.Short_Code = EventPlatform_short_name;
                Objevent_Platform.Is_Active = "Y";
                Objevent_Platform.Enable_CC_And_BCC = EnableCCandBCC;
                Objevent_Platform.Last_Action_By = objLoginUser.Users_Code;
                Objevent_Platform.Last_UpDated_Time = DateTime.Now;

                dynamic resultSet;
                if (!objEvent_Platform_Service.Save(Objevent_Platform, out resultSet))
                {
                    status = "E";
                    message = resultSet;
                }
                else
                {
                    if (EventPlatform_Code > 0)
                    {
                        message = objMessageKey.Recordupdatedsuccessfully;
                        Action = Convert.ToString(ActionType.U); // U = "Update";
                    }
                    else
                    {
                        message = objMessageKey.Recordsavedsuccessfully;
                    }
                    lstEvent_Platform_Searched = objEvent_Platform_Service.SearchFor(s => true).ToList();
                }
            }
            else
            {
                status = "E";
                message = "Entry for this record already Exists!";
            }


            try
            {
                Objevent_Platform.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(Objevent_Platform.Inserted_By));
                Objevent_Platform.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(Objevent_Platform.Last_Action_By));

                string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(Objevent_Platform);
                //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForALLab), Convert.ToInt32(lstAL_Lab.AL_Lab_Code), LogData, Action, objLoginUser.Users_Code);

                MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                objAuditLog.moduleCode = GlobalParams.ModuleCodeForALLab;
                objAuditLog.intCode = Objevent_Platform.Event_Platform_Code;
                objAuditLog.logData = LogData;
                objAuditLog.actionBy = objLoginUser.Login_Name;
                objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(Objevent_Platform.Last_UpDated_Time));
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
            var obj = new
            {
                RecordCount = lstEvent_Platform_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult ActivateDeactivate_EvePlatform(string ActiveAction, int EventPlatform_Code)
        {
            string Status = "", Message = "", Action = Convert.ToString(ActionType.A); 
            Event_Platform_Service objEvent_Platform_Service = new Event_Platform_Service(objLoginEntity.ConnectionStringName);
            Event_Platform objEP = new Event_Platform();

            if (EventPlatform_Code != 0)
            {
                objEP = objEvent_Platform_Service.GetById(EventPlatform_Code);
                objEP.Is_Active = ActiveAction;
                objEP.EntityState = State.Modified;


                dynamic resultSet;
                if (!objEvent_Platform_Service.Save(objEP, out resultSet))
                {
                    Status = "E";
                    if (ActiveAction == "Y")
                    {
                        Message = objMessageKey.CouldNotActivatedRecord;
                    }
                    else
                    {
                        Message = objMessageKey.CouldNotDeactivatedRecord;
                    }
                }
                else
                {
                    Status = "S";
                    if (ActiveAction == "Y")
                    {
                        Message = objMessageKey.Recordactivatedsuccessfully;
                    }
                    else
                    {
                        Message = objMessageKey.Recorddeactivatedsuccessfully;
                        Action = Convert.ToString(ActionType.D);  //Deactivate
                    }
                }

                try
                {
                    objEP.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objEP.Inserted_By));
                    objEP.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objEP.Last_Action_By));
                   
                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objEP);
                    //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForExtendedGroup, objExtended_Group.Extended_Group_Code, LogData, Action, objLoginUser.Users_Code);

                    MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                    objAuditLog.moduleCode = GlobalParams.ModuleCodeForExtendedGroup;
                    objAuditLog.intCode = objEP.Event_Platform_Code;
                    objAuditLog.logData = LogData;
                    objAuditLog.actionBy = objLoginUser.Login_Name;
                    objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objEP.Last_UpDated_Time));
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
            var Obj = new
            {
                Status = Status,
                Message = Message
            };
            return Json(Obj);
        }
        #endregion

        #region  Event_Template_Keys
        public PartialViewResult EventTemplateKeysPopUP(int EventPlatform_Code)
        {
            lstEventTemplateKeys = null;
            Session["EventPlatformCode"] = EventPlatform_Code;
            Event_Platform_Service objEvent_Platform_Service = new Event_Platform_Service(objLoginEntity.ConnectionStringName);
            Event_Platform objEP = new Event_Platform();

            if (EventPlatform_Code != 0)
            {
                objEP = objEvent_Platform_Service.GetById(EventPlatform_Code);
                if (objEP.Credentials != null)
                    lstEventTemplateKeys = JsonConvert.DeserializeObject<List<EventTemplateKeys>>(objEP.Credentials);
            }

            return PartialView("_EventTemplateKey_List", lstEventTemplateKeys);
        }

        public PartialViewResult AddEditEventKeys(int Id, string CommandName)
        {
            EventTemplateKeys objkey = new EventTemplateKeys();
            Event_Template_Key_Service Objevent_Template_Key_Service = new Event_Template_Key_Service(objLoginEntity.ConnectionStringName);

            List<string> UsedKeydata = lstEventTemplateKeys.Select(s => s.Key).ToList();

            List<Event_Template_Keys> lstKeys = Objevent_Template_Key_Service.SearchFor(s => true).ToList();
            ViewBag.ddlKeyData2 = lstKeys;
            lstKeys = lstKeys.Where(w => !UsedKeydata.Any(a => a == w.Key_Name)).ToList();
            ViewBag.ddlKeys = new SelectList(lstKeys, "Key_Name", "Key_Name");

            if (CommandName == "ADD")
            {
                TempData["Action"] = "ADD";
            }
            if (CommandName == "EDIT")
            {
                objkey = lstEventTemplateKeys.Where(c => c.Code == Id).FirstOrDefault();
                List<Event_Template_Keys> lstEditKeys = Objevent_Template_Key_Service.SearchFor(s => true).ToList();
                ViewBag.ddlKeys = new SelectList(lstEditKeys, "Key_Name", "Key_Name", objkey.Key);

                TempData["Action"] = "EDIT";
                TempData["Id"] = objkey.Code;
            }
            return PartialView("_EventTemplateKey_List", lstEventTemplateKeys);
        }

        public ActionResult SaveEventKeys(int Id, string Key, string Value, int RowNumber)
        {
            int result = 1;
            EventTemplateKeys objEk = new EventTemplateKeys();
            Dictionary<string, object> obj = new Dictionary<string, object>();

            result = Valid(Id, Key, Value);
            if (result == 1)
            {
                if (Id == 0)
                {
                    objEk.Code = lstEventTemplateKeys.Count + 1;
                    objEk.Key = Key;
                    objEk.Value = Value;
                    lstEventTemplateKeys.Add(objEk);
                }
                else
                {
                    objEk = lstEventTemplateKeys.Where(d => d.Code == Id).FirstOrDefault();
                    objEk.Code = RowNumber;
                    objEk.Key = Key;
                    objEk.Value = Value;
                    lstEventTemplateKeys.Append(objEk);
                }
            }
            else
            {
                obj.Add("Error", "1");
                return Json(obj);
            }
            obj.Add("Status", "S");
            return Json(obj);
        }

        public ActionResult DeleteEventKeys(int Id)
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            EventTemplateKeys ObjEK = lstEventTemplateKeys.Where(d => d.Code == Id).FirstOrDefault();
            lstEventTemplateKeys.Remove(ObjEK);
            int i = 1;

            foreach (EventTemplateKeys objKey in lstEventTemplateKeys)
            {
                objKey.Code = i;
                i++;
            }

            obj.Add("Status", "S");
            return Json(obj);
        }
        public int Valid(int Id, string Key, string Value)
        {
            int result = 0;
            List<EventTemplateKeys> TempList = new List<EventTemplateKeys>();
            if (Id == 0)
            {
                TempList = lstEventTemplateKeys.Where(x => x.Key.ToUpper() == Key.ToUpper()).ToList();
            }
            else
            {
                TempList = lstEventTemplateKeys.Where(x => (x.Key.ToUpper() == Key.ToUpper()) && (x.Code != Id)).ToList();
            }
            if (TempList.Count == 0)
            {
                result = 1;
            }
            else
            {
                result = 2;
            }
            return result;
        }
        #endregion

        public ActionResult SaveEventKeyValuesInDb()
        {
            int PlatformCode = Convert.ToInt32(Session["EventPlatformCode"]);
            string SearializeJsondata = "", status = "S", message = "";
            Event_Platform_Service objEvent_Platform_Service = new Event_Platform_Service(objLoginEntity.ConnectionStringName);
            Event_Platform objEP = new Event_Platform();

            SearializeJsondata = JsonConvert.SerializeObject(lstEventTemplateKeys);

            if (PlatformCode != 0)
            {
                objEP = objEvent_Platform_Service.GetById(PlatformCode);
                objEP.Credentials = SearializeJsondata;
                objEP.EntityState = State.Modified;

                dynamic resultSet;
                if (!objEvent_Platform_Service.Save(objEP, out resultSet))
                {
                    status = "E";
                    message = resultSet;
                }
                else
                {
                    status = "S";
                    message = objMessageKey.Recordupdatedsuccessfully;
                }
                Session["EventPlatformCode"] = null;
            }
            var obj = new
            {
                RecordCount = lstEvent_Platform_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult CheckRecordLock(int EventPlatformCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (EventPlatformCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(EventPlatformCode, GlobalParams.ModuleCodeForLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public class EventTemplateKeys
        {
            public int Code { get; set; }
            public string Key { get; set; }
            public string Value { get; set; }

        }

    }
}