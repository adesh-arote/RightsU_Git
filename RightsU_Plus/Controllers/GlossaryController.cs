using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Entity.SqlServer;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;


namespace RightsU_Plus.Controllers
{
    public class GlossaryController : BaseController
    {
        //
        // GET: /Glossary/
        public ActionResult FAQ()
        {
            List<Glossary> lstFAQ = new List<Glossary>();
            lstFAQ = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_FAQ).ToList();
            return View(lstFAQ);
        }

        public ActionResult ReportsUsage()
        {
            List<Glossary> lstReport = new List<Glossary>();
            lstReport = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Reports).ToList();
            return View(lstReport);
        }

        public ActionResult AskExpert(string subject, string query)
        {
            return View();
        }

        public ActionResult SubmitQuery(string subject, string query)
        {
            string Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_SendMail_AskExpert(objLoginUser.Users_Code, subject, query, objLoginUser.Email_Id, "").FirstOrDefault().Result;   
            return Json(Result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ContactInfo()
        {
            List<Glossary> lstContactInfo = new List<Glossary>();
            lstContactInfo = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_ContactInfo).ToList();
            return View(lstContactInfo);
        }

        public ActionResult ShowPlatforms()
        {
            ViewBag.LastUpdatedTime = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Parameter_Name == "Last_Updated_On").Select(x => x.Parameter_Value).FirstOrDefault();
            return View();
        }
        public PartialViewResult ShowPlatform_Partial(string[] commonSearch, int pageNo = 1)
        {
            //List<Glossary> lstPlatforms = new List<Glossary>();
            //var total = 0;
            //if (commonSearch != null)
            //{
            //    var j = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Definitions);
            //    foreach (var obj in commonSearch)
            //    {
            //        var result = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Definitions && p.Name.Contains(obj)).First();
            //        if (result != null)
            //            lstPlatforms.Add(result);
            //    }
            //    total = lstPlatforms.Count();
            //}
            //else
            //    total = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Definitions).Count();
            //var pageSize = 10;
            //ViewBag.PageNo = pageNo;
            //int skip = pageSize * (ViewBag.PageNo - 1);

            //ViewBag.RecordCount = total;
            //if (commonSearch == null)
            //    //lstPlatforms = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Definitions && commonSearch.Contains(p.Name)).OrderBy(p => p.Name).Skip(skip).Take(pageSize).ToList();
            //    lstPlatforms = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Definitions).OrderBy(p => p.Name).Skip(skip).Take(pageSize).ToList();
            //else
            //    lstPlatforms = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Definitions).OrderBy(p => p.Name).Skip(skip).Take(pageSize).ToList();

            //return PartialView("_List_Platforms", lstPlatforms);

            List<Glossary> lstPlatforms = new List<Glossary>();
            var total = 0;
            if (commonSearch != null)
                total = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Definitions && commonSearch.Any(x => x == p.Name)).Count();
            else
                total = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Definitions).Count();
            var pageSize = 10;
            ViewBag.PageNo = pageNo;
            int skip = pageSize * (ViewBag.PageNo - 1);

            ViewBag.RecordCount = total;
            if (commonSearch != null)
                lstPlatforms = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Definitions && commonSearch.Any(x => x == p.Name)).OrderBy(p => p.Name).Skip(skip).Take(pageSize).ToList();
            else
                lstPlatforms = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Definitions).OrderBy(p => p.Name).Skip(skip).Take(pageSize).ToList();

            return PartialView("_List_Platforms", lstPlatforms);
        }

        public JsonResult BindPlatform()
        {
            var lstPlatforms = new Glossary_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Glossary_Type == GlobalParams.Glossary_Definitions).Select(p => new { p.Name }).ToList();
            return Json(new SelectList(lstPlatforms, "Name", "Name"), JsonRequestBehavior.AllowGet);
        }
    }
}
