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
    public class Email_Config_TemplateController : BaseController
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
        private List<Event_Template> lstEvent_Template_Searched = new List<Event_Template>();
        #endregion

        #region Master save
        public ActionResult Index()
        {
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Email Template Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Email Template Desc", Value = "ND" });
            ViewBag.SortType = lstSort;

            return View();
        }

        public PartialViewResult Bind_Email_Config_Template(int pageNo, int recordPerPage, int Email_Config_Template_Code, string commandName, string sortType)
        {
            lstEmail_Template_Searched = new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
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
                    lst = lstEmail_Template_Searched.OrderBy(o => o.Email_Config_Template_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "ND")
                {
                    lst = lstEmail_Template_Searched.OrderByDescending(o => o.Email_Config_Template_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }

            }

            Email_Config_Service objEmail_Config_Service = new Email_Config_Service(objLoginEntity.ConnectionStringName);
            Event_Platform_Service objEvent_Platform_Service = new Event_Platform_Service(objLoginEntity.ConnectionStringName);

            List<SelectListItem> lstTemplateType = new List<SelectListItem>();
            lstTemplateType.Add(new SelectListItem { Selected = true, Text = "TEXT", Value = "T" });
            lstTemplateType.Add(new SelectListItem { Text = "HTML", Value = "H" });

            var lstEmailConfig = objEmail_Config_Service.SearchFor(s => true).ToList();
            var lstPlatform = objEvent_Platform_Service.SearchFor(s => true).ToList();

            if (commandName == "ADD")
            {
                ViewBag.lst_EmailConfig = new SelectList(lstEmailConfig, "Email_Config_Code", "Email_Type");
                
                ViewBag.lst_Platform = new SelectList(lstPlatform, "Event_Platform_Code", "Event_Platform_Name");

                ViewBag.lst_TemplateType = new SelectList(lstTemplateType, "Value", "Text");

            }
            else if (commandName == "EDIT")
            {
                Email_Config_Template Detail = lst.FirstOrDefault();

                ViewBag.lst_EmailConfig = new SelectList(lstEmailConfig, "Email_Config_Code", "Email_Type", Detail.Email_Config_Code);

                ViewBag.lst_Platform = new SelectList(lstPlatform, "Event_Platform_Code", "Event_Platform_Name", Detail.Event_Platform_Code);

                string SelectedTemplateTypeValue = lstTemplateType.Where(w => Detail.Event_Template_Type.Any(a => w.Value == a.ToString())).Select(s => s.Value).FirstOrDefault();
                ViewBag.lst_TemplateType = new SelectList(lstTemplateType, "Value", "Text", SelectedTemplateTypeValue);
                
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
            if (!string.IsNullOrEmpty(searchText))
            {
                lstEmail_Template_Searched = lstEmail_Template_Searched.Where(a => a.Event_Template_Type.ToUpper().Contains(searchText.ToUpper())).ToList();
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

            Email_Config_Template_Service objEmail_Config_Template_Service = new Email_Config_Template_Service(objLoginEntity.ConnectionStringName);
            Email_Config_Template ObjEmail_Config_Template = new Email_Config_Template();

            if (Email_Config_Template_Code > 0)
            {
                ObjEmail_Config_Template = objEmail_Config_Template_Service.GetById(Email_Config_Template_Code);
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
            if (!objEmail_Config_Template_Service.Save(ObjEmail_Config_Template, out resultSet))
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
                lstEmail_Template_Searched = objEmail_Config_Template_Service.SearchFor(s => true).ToList();
            }

            var obj = new
            {
                RecordCount = lstEmail_Template_Searched.Count,
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
                isLocked = objCommonUtil.Lock_Record(Email_Config_Template_Code, GlobalParams.ModuleCodeForLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
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
            string status = "", message = "";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            Email_Config_Template_Service objEmail_Config_Template_Service = new Email_Config_Template_Service(objLoginEntity.ConnectionStringName);
            Email_Config_Template ObjEmail_Config_Template = new Email_Config_Template();

            if (Email_Config_Template_Code != 0)
            {
                ObjEmail_Config_Template = objEmail_Config_Template_Service.GetById(Email_Config_Template_Code);
                ObjEmail_Config_Template.EntityState = State.Modified;
                ObjEmail_Config_Template.Is_Active = Action;
                ObjEmail_Config_Template.Last_Action_By = objLoginUser.Users_Code;
                ObjEmail_Config_Template.Last_UpDated_Time = DateTime.Now;

                dynamic resultSet;
                if (!objEmail_Config_Template_Service.Save(ObjEmail_Config_Template, out resultSet))
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
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                    }
                }
            }
            var Obj = new
            {
                Status = status,
                Message = message
            };
            return Json(Obj);
        }
        #endregion

        #region Template configuration

        public PartialViewResult Bind_Config_Template_PopUp(int Email_Config_Template_Code, int Email_Config_Code, int Event_Platform_Code, string Event_Template_Type, int Event_Template_Code = 0)
        {
            Event_Template_Service objEvent_Template_Service = new Event_Template_Service(objLoginEntity.ConnectionStringName);
            Email_Config_Service objEmail_Config_Service = new Email_Config_Service(objLoginEntity.ConnectionStringName);
            Event_Platform_Service objEvent_Platform_Service = new Event_Platform_Service(objLoginEntity.ConnectionStringName);
            Event_Template_Key_Service objEvent_Template_Key_Service = new Event_Template_Key_Service(objLoginEntity.ConnectionStringName);
            Event_Template objEv_Template = new Event_Template();

            var lstEventTemplate = objEvent_Template_Service.SearchFor(s => true).ToList();
            objEv_Template = lstEventTemplate.Where(w => w.Event_Template_Code == Event_Template_Code).FirstOrDefault();
            ViewBag.Email_Type = objEmail_Config_Service.SearchFor(w => w.Email_Config_Code == Email_Config_Code).Select(s => s.Email_Type).FirstOrDefault();
            ViewBag.Platform = objEvent_Platform_Service.SearchFor(w => w.Event_Platform_Code == Event_Platform_Code).Select(s => s.Event_Platform_Name).FirstOrDefault();
            if(Event_Template_Type == "H")
                ViewBag.Template_Type = "HTML";
            else
                ViewBag.Template_Type = "TEXT";        

            if (Event_Template_Code != 0)
            {
                ViewBag.lst_EventTemplate = new SelectList(lstEventTemplate, "Event_Template_Code", "Event_Template_Name", objEv_Template.Event_Template_Code);
            }
            else
            {
                ViewBag.lst_EventTemplate = new SelectList(lstEventTemplate, "Event_Template_Code", "Event_Template_Name");
            }
            ViewBag.Event_Template_Code = Event_Template_Code;
            ViewBag.Platform_Code = Event_Platform_Code;

            var lstEventTemplateKeys = objEvent_Template_Key_Service.SearchFor(s => true).ToList();
            ViewBag.lst_EventTemplateKeys = new SelectList(lstEventTemplateKeys, "Event_Template_Keys_Code", "Key_Name");

            return PartialView("_Config_Template_PopUp", objEv_Template);
        }

        public JsonResult Save_Config_Template(int Config_Template_Code, string TemplateName, string ExistingName, string editorData, string subject = "")
        {
            string status = "S", message = "";

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        #endregion

    }
}