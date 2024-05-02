using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

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

        #endregion

        public ActionResult Index()
        {
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Email Template Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Email Template Desc", Value = "ND" });
            ViewBag.SortType = lstSort;

            return View();
        }

        public PartialViewResult Bind_EmailTemplate(int pageNo, int recordPerPage, int Event_PlatformCode, string commandName, string sortType)
        {
            lstEmail_Template_Searched = new Email_Config_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            ViewBag.Event_PlatformCode = Event_PlatformCode;
            ViewBag.CommandName = commandName;
            List<Email_Config_Template> lst = new List<Email_Config_Template>();
            if (lstEmail_Template != null)
            {
                lstEmail_Template_Searched = lstEmail_Template;
            }
            lst = lstEmail_Template.OrderBy(a => a.Email_Config_Template_Code).ToList();
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

            if (commandName == "ADD")
            {
                Email_Config_Service objEmail_Config_Service = new Email_Config_Service(objLoginEntity.ConnectionStringName);
                Event_Platform_Service objEvent_Platform_Service = new Event_Platform_Service(objLoginEntity.ConnectionStringName);

                var lstEmailConfig = objEmail_Config_Service.SearchFor(s => true).ToList();
                ViewBag.lstEmailConfig = new SelectList(lstEmailConfig, "Email_Config_Code", "Email_Type");

                List<SelectListItem> lstTemplateType = new List<SelectListItem>();
                lstTemplateType.Add(new SelectListItem { Selected = true, Text = "Text", Value = "TXT" });
                lstTemplateType.Add(new SelectListItem { Text = "HTML", Value = "HTML" });
                ViewBag.lstTemplateType = lstTemplateType;

                var lstPlatform = objEvent_Platform_Service.SearchFor(s => true).ToList();
                ViewBag.lstPlatform = new SelectList(lstPlatform, "Event_Platform_Code", "Event_Platform_Name");

            }
            else if (commandName == "EDIT")
            {
                
                
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
    }
}