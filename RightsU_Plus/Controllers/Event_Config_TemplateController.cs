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
    public class Event_Config_TemplateController : BaseController
    {
        #region  Sessions
        private List<RightsU_Entities.Email_Config_Template> lstEmail_Template
        {
            get
            {
                if (Session["lstEmail_Template"] == null)
                    Session["lstEmail_Template"] = new List<RightsU_Entities.Email_Config_Template>();
                return (List<RightsU_Entities.Email_Config_Template>)Session["lstEmail_Template"];
            }
            set { Session["lstEmail_Template"] = value; }
        }

        private List<Email_Config_Template> lstEmail_Template_Searched = new List<Email_Config_Template>();
        #endregion

        #region Event Config Template list
        public ActionResult Index()
        {
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Email Template Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Email Template Desc", Value = "ND" });
            ViewBag.SortType = lstSort;

            ViewBag.UserModuleRights = GetUserModuleRights();
            string moduleCode = GlobalParams.ModuleCodeForEmailConfigTemplate.ToString();
            string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            ViewBag.ModuleCode = moduleCode;
            ViewBag.LangCode = SysLanguageCode;

            return View();
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForEmailConfigTemplate), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        public PartialViewResult Bind_Email_Config_Template(int pageNo, int recordPerPage, int Email_Config_Template_Code, string commandName, string sortType)
        {
            lstEmail_Template_Searched = lstEmail_Template;
            ViewBag.Email_Config_Template_Code = Email_Config_Template_Code;
            ViewBag.CommandName = commandName;
            List<Email_Config_Template> lst = new List<Email_Config_Template>();
            lst = lstEmail_Template_Searched.OrderBy(a => a.Email_Config_Template_Code).ToList();
            int RecordCount = 0;
            RecordCount = lstEmail_Template_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                {
                    lst = lstEmail_Template_Searched.OrderByDescending(o => o.Last_UpDated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "NA")
                {
                    lst = lstEmail_Template_Searched.OrderBy(o => o.Email_Type).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "ND")
                {
                    lst = lstEmail_Template_Searched.OrderByDescending(o => o.Email_Type).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
            }

            List<SelectListItem> lstTemplateType = new List<SelectListItem>();
            lstTemplateType.Add(new SelectListItem { Selected = true, Text = "TEXT", Value = "T" });
            lstTemplateType.Add(new SelectListItem { Text = "HTML", Value = "H" });

            var lstEmailConfig = new Email_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            var lstPlatform = new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();

            if (commandName == "ADD")
            {
                ViewBag.lst_EmailConfig = new SelectList(lstEmailConfig, "Email_Config_Code", "Email_Type");
                
                ViewBag.lst_Platform = new SelectList(lstPlatform, "Event_Platform_Code", "Event_Platform_Name");

                ViewBag.lst_TemplateType = new SelectList(lstTemplateType, "Value", "Text");

            }
            else if (commandName == "EDIT")
            {
                Email_Config_Template Detail = lst.Where(s => s.Email_Config_Template_Code == Email_Config_Template_Code).FirstOrDefault();

                ViewBag.lst_EmailConfig = new SelectList(lstEmailConfig, "Email_Config_Code", "Email_Type", Detail.Email_Config_Code);

                ViewBag.lst_Platform = new SelectList(lstPlatform, "Event_Platform_Code", "Event_Platform_Name", Detail.Event_Platform_Code);

                string SelectedTemplateTypeValue = lstTemplateType.Where(w => Detail.Event_Template_Type.Any(a => w.Value == a.ToString())).Select(s => s.Value).FirstOrDefault();
                ViewBag.lst_TemplateType = new SelectList(lstTemplateType, "Value", "Text", SelectedTemplateTypeValue);
            }

            ViewBag.UserModuleRights = GetUserModuleRights();

            var result = (from x in new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList()
                                         join y in new Email_Config_Detail_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList()
                                         on x.Email_Config_Code equals y.Email_Config_Code
                                         join z in new Email_Config_Detail_User_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList()
                                         on y.Email_Config_Detail_Code equals z.Email_Config_Detail_Code
                                         select new
                                         {
                                             z.Event_Platform_Code,
                                             z.Event_Template_Type,
                                             x.Email_Config_Code
                                         }).ToList();

            foreach(var item in lst)
            {
                var ValidList = result.Where(a => a.Email_Config_Code == item.Email_Config_Code && a.Event_Platform_Code == item.Event_Platform_Code && a.Event_Template_Type == item.Event_Template_Type).ToList();

                if(ValidList.Count > 0)
                    item.AllowEdit = "N";
            }                

        return PartialView("_EmailTemplate_List", lst);
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

        public JsonResult Search_Email_Config_Template(string searchText)
        {
            lstEmail_Template_Searched = new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();

            foreach(var item in lstEmail_Template_Searched)
            {
                item.Email_Type = new Email_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Email_Config_Code == item.Email_Config_Code).Select(x => x.Email_Type).FirstOrDefault();
            }

            if (!string.IsNullOrEmpty(searchText))
            {
                //var configNames = FindEmailConfig(searchText);
                //string[] terms = configNames.Split(',');
                //lstEmail_Template_Searched = lstEmail_Template_Searched.Where(a => terms.Contains(Convert.ToString(a.Email_Config_Code))).ToList();
                lstEmail_Template_Searched = lstEmail_Template_Searched.Where(w => w.Email_Type.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            var obj = new
            {

                Record_Count = lstEmail_Template_Searched.Count
            };
            lstEmail_Template = lstEmail_Template_Searched;
            return Json(obj);
        }

        public JsonResult Save_Email_Config_Template(int Email_Config_Template_Code, int Email_Config_Code, string Event_Template_Type, int Event_Platform_Code)
        {
            string status = "S", message = "", Action = Convert.ToString(ActionType.C); // C = "Create";
            Email_Config_Template ObjEmail_Config_Template = new Email_Config_Template();

            if (Email_Config_Template_Code > 0)
            {
                ObjEmail_Config_Template = new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).GetById(Email_Config_Template_Code);
                ObjEmail_Config_Template.EntityState = State.Modified;
            }
            else
            {
                ObjEmail_Config_Template = new Email_Config_Template();
                ObjEmail_Config_Template.EntityState = State.Added;
                ObjEmail_Config_Template.Inserted_By = objLoginUser.Users_Code;
                ObjEmail_Config_Template.Inserted_On = DateTime.Now;
            }

            ObjEmail_Config_Template.Email_Config_Code = Email_Config_Code;
            ObjEmail_Config_Template.Event_Template_Type = Event_Template_Type;
            ObjEmail_Config_Template.Event_Platform_Code = Event_Platform_Code;
            ObjEmail_Config_Template.Is_Active = "Y";
            ObjEmail_Config_Template.Last_Action_By = objLoginUser.Users_Code;
            ObjEmail_Config_Template.Last_UpDated_Time = DateTime.Now;

            dynamic resultSet;
            if (!new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).Save(ObjEmail_Config_Template, out resultSet))
            {
                status = "E";
                message = resultSet;
            }
            else
            {
                if (Email_Config_Template_Code > 0)
                { 
                    message = objMessageKey.Recordupdatedsuccessfully;
                    Action = Convert.ToString(ActionType.U); // U = "Update";
                }
                else
                {
                    message = objMessageKey.Recordsavedsuccessfully;
                }
                status = "S";
                lstEmail_Template = new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();

                try
                {
                    ObjEmail_Config_Template.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(ObjEmail_Config_Template.Inserted_By));
                    ObjEmail_Config_Template.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(ObjEmail_Config_Template.Last_Action_By));
                    ObjEmail_Config_Template.Email_Type = new Email_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Email_Config_Code == ObjEmail_Config_Template.Email_Config_Code).Select(w => w.Email_Type).FirstOrDefault();
                    //ObjEmail_Config_Template.Event_Template_Name = new Event_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Event_Template_Code == ObjEmail_Config_Template.Event_Template_Code).Select(w => w.Event_Template_Name).FirstOrDefault();
                    ObjEmail_Config_Template.Event_Platform_Name = new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Event_Platform_Code == ObjEmail_Config_Template.Event_Platform_Code).Select(w => w.Event_Platform_Name).FirstOrDefault();

                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(ObjEmail_Config_Template);

                    MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                    objAuditLog.moduleCode = GlobalParams.ModuleCodeForEmailConfigTemplate;
                    objAuditLog.intCode = ObjEmail_Config_Template.Email_Config_Template_Code;
                    objAuditLog.logData = LogData;
                    objAuditLog.actionBy = objLoginUser.Login_Name;
                    objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(ObjEmail_Config_Template.Last_UpDated_Time));
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

            var obj = new
            {
                RecordCount = lstEmail_Template.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult CheckRecordLock(int Email_Config_Template_Code)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Email_Config_Template_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Email_Config_Template_Code, GlobalParams.ModuleCodeForEmailConfigTemplate, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public JsonResult ActivateDeactivate(int Email_Config_Template_Code, string Action)
        {
            string status = "", message = "", RecordAction = Convert.ToString(ActionType.A); // A = "Active";
             
            Dictionary<string, object> obj = new Dictionary<string, object>();
            Email_Config_Template ObjEmail_Config_Template = new Email_Config_Template();

            if (Email_Config_Template_Code != 0)
            {
                ObjEmail_Config_Template = new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).GetById(Email_Config_Template_Code);
                ObjEmail_Config_Template.EntityState = State.Modified;
                ObjEmail_Config_Template.Is_Active = Action;
                ObjEmail_Config_Template.Last_Action_By = objLoginUser.Users_Code;
                ObjEmail_Config_Template.Last_UpDated_Time = DateTime.Now;

                dynamic resultSet;
                if (!new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).Save(ObjEmail_Config_Template, out resultSet))
                {
                    status = "E";
                    if (Action == "Y")
                    {
                        message = objMessageKey.CouldNotActivatedRecord;
                    }
                    else
                    {
                        message = objMessageKey.CouldNotDeactivatedRecord;
                    }
                }
                else
                {
                    status = "S";
                    if (Action == "Y")
                    {
                        message = objMessageKey.Recordactivatedsuccessfully;
                    }
                    else
                    {
                        RecordAction = Convert.ToString(ActionType.D); // D = "Deactive";
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                    }

                    try
                    {
                        ObjEmail_Config_Template.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(ObjEmail_Config_Template.Inserted_By));
                        ObjEmail_Config_Template.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(ObjEmail_Config_Template.Last_Action_By));
                        ObjEmail_Config_Template.Email_Type = new Email_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Email_Config_Code == ObjEmail_Config_Template.Email_Config_Code).Select(w => w.Email_Type).FirstOrDefault();
                        //ObjEmail_Config_Template.Event_Template_Name = new Event_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Event_Template_Code == ObjEmail_Config_Template.Event_Template_Code).Select(w => w.Event_Template_Name).FirstOrDefault();
                        ObjEmail_Config_Template.Event_Platform_Name = new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Event_Platform_Code == ObjEmail_Config_Template.Event_Platform_Code).Select(w => w.Event_Platform_Name).FirstOrDefault();

                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(ObjEmail_Config_Template);

                        MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                        objAuditLog.moduleCode = GlobalParams.ModuleCodeForEmailConfigTemplate;
                        objAuditLog.intCode = ObjEmail_Config_Template.Email_Config_Template_Code;
                        objAuditLog.logData = LogData;
                        objAuditLog.actionBy = objLoginUser.Login_Name;
                        objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(ObjEmail_Config_Template.Last_UpDated_Time));
                        objAuditLog.actionType = RecordAction;
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
            }
            lstEmail_Template = new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();

            var Obj = new
            {
                Status = status,
                Message = message
            };
            return Json(Obj);
        }
        #endregion

        #region Event Template Popup
        public PartialViewResult Bind_Event_Template_PopUp(int Email_Config_Template_Code, int Email_Config_Code, int Event_Platform_Code, string Event_Template_Type, int Event_Template_Code = 0)
        {
            Event_Template objEv_Template = new Event_Template();

            var lstEventTemplate = new Event_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            objEv_Template = lstEventTemplate.Where(w => w.Event_Template_Code == Event_Template_Code).FirstOrDefault();
            ViewBag.Email_Type = new Email_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Email_Config_Code == Email_Config_Code).Select(s => s.Email_Type).FirstOrDefault();
            ViewBag.Platform = new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Event_Platform_Code == Event_Platform_Code).Select(s => s.Event_Platform_Name).FirstOrDefault();
            if(Event_Template_Type == "H")
                ViewBag.Template_Type = "HTML";
            else
                ViewBag.Template_Type = "TEXT";        

            if (Event_Template_Code != 0)
            {
                ViewBag.lst_EventTemplate = new SelectList(lstEventTemplate, "Event_Template_Code", "Event_Template_Name", objEv_Template.Event_Template_Code);

                var objEt = new Event_Template_Service(objLoginEntity.ConnectionStringName).GetById(Event_Template_Code);
                ViewBag.Subject = objEt.Subject;
            }
            else
            {
                ViewBag.lst_EventTemplate = new SelectList(lstEventTemplate, "Event_Template_Code", "Event_Template_Name");
            }
            ViewBag.Event_Template_Code = Event_Template_Code;
            ViewBag.Platform_Code = Event_Platform_Code;
            ViewBag.Email_Config_Template_Code = Email_Config_Template_Code;

            //var lstEventTemplateKeys = new Event_Template_Key_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            //ViewBag.lst_EventTemplateKeys = new SelectList(lstEventTemplateKeys, "Event_Template_Keys_Code", "Key_Name");

            var lstEventTemplateKeys = (from x in new Event_Template_Key_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList()
                                        join y in new Email_Config_Keys_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList()
                                        on x.Event_Template_Keys_Code equals y.Event_Template_Keys_Code
                                        join z in new Email_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList()
                                        on y.Email_Config_Code equals z.Email_Config_Code
                                        where y.Email_Config_Code == Email_Config_Code
                                        select new
                                        {
                                            x.Event_Template_Keys_Code,
                                            x.Key_Name
                                        }).ToList();

            ViewBag.lst_EventTemplateKeys = new SelectList(lstEventTemplateKeys, "Event_Template_Keys_Code", "Key_Name");



            return PartialView("_Config_Template_PopUp", objEv_Template);
        }

        public JsonResult Save_Event_Template(int Email_Config_Template_Code, int Event_Template_Code, string Template_Type, int Platform_Code, string editorData, string subject, string IsNewTemplate, string TemplateName = "")
        {
            string status = "S", message = "", Action = Convert.ToString(ActionType.C); // C = "Create";
            Event_Template_Service ObjEvent_Template_Service = new Event_Template_Service(objLoginEntity.ConnectionStringName);
            Event_Template ObjEvent_Template = new Event_Template();

            if (IsNewTemplate != "Y" && Event_Template_Code > 0)
            {
                ObjEvent_Template = new Event_Template_Service(objLoginEntity.ConnectionStringName).GetById(Event_Template_Code);
                ObjEvent_Template.EntityState = State.Modified;
            }
            else
            {
                ObjEvent_Template = new Event_Template();
                ObjEvent_Template.EntityState = State.Added;
                ObjEvent_Template.Event_Template_Name = TemplateName;
                ObjEvent_Template.Inserted_By = objLoginUser.Users_Code;
                ObjEvent_Template.Inserted_On = DateTime.Now;
            }
            
            ObjEvent_Template.Event_Template_Type = Template_Type;
            ObjEvent_Template.Event_Platform_Code = Platform_Code;
            ObjEvent_Template.Subject = subject;
            ObjEvent_Template.Template = editorData;
            ObjEvent_Template.Last_Action_By = objLoginUser.Users_Code;
            ObjEvent_Template.Last_UpDated_Time = DateTime.Now;

            dynamic resultSet;
            if (!new Event_Template_Service(objLoginEntity.ConnectionStringName).Save(ObjEvent_Template, out resultSet))
            {
                status = "E";
                message = resultSet;
            }
            else
            {
                if (Event_Template_Code > 0)
                {
                    Action = Convert.ToString(ActionType.U); // U = "Update";
                    message = objMessageKey.Recordupdatedsuccessfully;
                }
                else
                {
                    message = objMessageKey.Recordsavedsuccessfully;
                }

                Email_Config_Template ObjEmail_Config_Template = new Email_Config_Template();
                ObjEmail_Config_Template = new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).GetById(Email_Config_Template_Code);
                ObjEmail_Config_Template.EntityState = State.Modified;
                ObjEmail_Config_Template.Event_Template_Code = ObjEvent_Template.Event_Template_Code;
                ObjEmail_Config_Template.Last_Action_By = objLoginUser.Users_Code;
                ObjEmail_Config_Template.Last_UpDated_Time = DateTime.Now;

                new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).Save(ObjEmail_Config_Template, out resultSet);
                lstEmail_Template = new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
                status = "S";

                try
                {
                    ObjEvent_Template.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(ObjEvent_Template.Inserted_By));
                    ObjEvent_Template.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(ObjEvent_Template.Last_Action_By));
                    ObjEvent_Template.Event_Platform_Name = new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Event_Platform_Code == ObjEmail_Config_Template.Event_Platform_Code).Select(w => w.Event_Platform_Name).FirstOrDefault();

                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(ObjEvent_Template);

                    MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                    objAuditLog.moduleCode = GlobalParams.ModuleCodeForEmailConfigTemplate;
                    objAuditLog.intCode = ObjEvent_Template.Event_Template_Code;
                    objAuditLog.logData = LogData;
                    objAuditLog.actionBy = objLoginUser.Login_Name;
                    objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(ObjEvent_Template.Last_UpDated_Time));
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

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult Bind_Template_Data(int ExistingValue)
        {            
            var result = new Event_Template_Service(objLoginEntity.ConnectionStringName).GetById(ExistingValue);

            var obj = new
            {
                Template = result.Template,
                Subject = result.Subject
            };

            return Json(obj);
        }

        public string FindEmailConfig(string searchText)
        {
            searchText = searchText.Trim();
            string configNames = "";
            if (searchText != "")
            {
                string[] ConfigCodes = new Email_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Email_Type.Contains(searchText)).Select(s => s.Email_Config_Code.ToString()).ToArray();
                configNames = string.Join(", ", ConfigCodes);
                if (configNames == "")
                    configNames = "0";
            }
            return configNames;
        }
        #endregion

    }
}