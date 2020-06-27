using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Net;
using System.Globalization;
using System.Collections;
using System.Text.RegularExpressions;
using OfficeOpenXml;
using System.Data.Entity.Core.Objects;

namespace RightsU_Plus.Controllers
{
    public class Project_MilestoneListController : BaseController
    {
        #region --- Properties ---
        // GET: /Title/
      
        //USP_Title_Deal_Info_Result
        public string Message
        {
            get
            {
                if (Session["Message"] == null)
                    Session["Message"] = string.Empty;
                return (string)Session["Message"];
            }
            set { Session["Message"] = value; }
        }

        public RightsU_Entities.Title objTitle
        {
            get
            {
                if (Session["Session_Title"] == null)
                    Session["Session_Title"] = new RightsU_Entities.Title();
                return (RightsU_Entities.Title)Session["Session_Title"];
            }
            set { Session["Session_Title"] = value; }
        }


        public Title_Service objTitleS
        {
            get
            {
                if (Session["objTitleS_Service"] == null)
                    Session["objTitleS_Service"] = new Title_Service(objLoginEntity.ConnectionStringName);
                return (Title_Service)Session["objTitleS_Service"];
            }
            set { Session["objTitleS_Service"] = value; }
        }


        public string mode
        {
            get
            {
                if (Session["mode"] == null || Session["mode"] == "E")
                    mode = "E";
                return (string)Session["mode"];
            }
            set { Session["mode"] = value; }
        }

        public int PageNo
        {
            get
            {
                if (Session["PageNo"] == null)
                    Session["PageNo"] = "1";
                return (int)Session["PageNo"];
            }
            set { Session["PageNo"] = value; }
        }

        public int recordPerPage
        {
            get
            {
                if (Session["recordPerPage"] == null)
                    Session["recordPerPage"] = 10;
                return (int)Session["recordPerPage"];
            }
            set { Session["recordPerPage"] = value; }
        }
        private List<RightsU_Entities.Title_Milestone> lstTitle_Milestone
        {
            get
            {
                if (Session["lstTitle_Milestone"] == null)
                    Session["lstTitle_Milestone"] = new List<RightsU_Entities.Title_Milestone>();
                return (List<RightsU_Entities.Title_Milestone>)Session["lstTitle_Milestone"];
            }
            set { Session["lstTitle_Milestone"] = value; }
        }

        private List<RightsU_Entities.ProjectMilestone> lstProjectMilestone
        {
            get
            {
                if (Session["lstProjectMilestone"] == null)
                    Session["lstProjectMilestone"] = new List<RightsU_Entities.ProjectMilestone>();
                return (List<RightsU_Entities.ProjectMilestone>)Session["lstProjectMilestone"];
            }
            set { Session["lstProjectMilestone"] = value; }
        }

        private List<RightsU_Entities.ProjectMilestone> lstProjectMilestone_Searched
        {
            get
            {
                if (Session["lstProjectMilestone_Searched"] == null)
                    Session["lstProjectMilestone_Searched"] = new List<RightsU_Entities.ProjectMilestone>();
                return (List<RightsU_Entities.ProjectMilestone>)Session["lstProjectMilestone_Searched"];
            }
            set { Session["lstProjectMilestone_Searched"] = value; }
        }
        #endregion



        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTitle), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
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
        public ActionResult Index(int id = 0, int Page_No = 0, int PageSize = 10)
        {
            PageNo = Page_No;
            ViewBag.PageNo = PageNo;
            var MilestoneType = new Milestone_Nature_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").Select(s => new { s.Milestone_Nature_Code, s.Milestone_Nature_Name }).Distinct().ToList();
            ViewBag.MilestoneNatureList = new SelectList(MilestoneType, "Milestone_Nature_Code", "Milestone_Nature_Name");
            string moduleCode = GlobalParams.ModuleCodeForProjectMilestone.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            objTitle = new Title_Service(objLoginEntity.ConnectionStringName).GetById(id);
            if (TempData["RecodLockingCode"] == "" || TempData["RecodLockingCode"] == null)
                ViewBag.RecordLockingCode = 0;
            else
                ViewBag.RecordLockingCode = TempData["RecodLockingCode"];
            int RecordLockingCode =Convert.ToInt32(TempData["RecodLockingCode"]);

         
            lstProjectMilestone = lstProjectMilestone_Searched= new ProjectMilestone_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();

            ViewBag.RecordCount = lstProjectMilestone.Count();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Project_MilestoneList/Index.cshtml");
        }
        public PartialViewResult BindProjectMilestoneList(int pageNo, int recordPerPage)
        {
            List<RightsU_Entities.ProjectMilestone> lst = new List<RightsU_Entities.ProjectMilestone>();
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            
            lst = lstProjectMilestone.ToList();
            RecordCount = lstProjectMilestone_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstProjectMilestone_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            ViewBag.UserModuleRights = GetUserModuleRights();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;

            return PartialView("~/Views/Project_MilestoneList/_Project_Milestone_List.cshtml", lst);
        }

        public JsonResult SearchPM(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                    lstProjectMilestone_Searched  = lstProjectMilestone_Searched.Where(w => w.ProjectName.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
            {
                lstProjectMilestone_Searched = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                lstProjectMilestone_Searched = lstProjectMilestone_Searched;
            }


            var obj = new
            {

                Record_Count = lstProjectMilestone_Searched.Count
            };
            return Json(obj);
        }

        public ActionResult AddEditProject_Milestone(int ProjectMilestoneCode, string CommandName = "")
       {

            ProjectMilestone_Service objPM_Service = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.ProjectMilestone objPM = null;

            if (ProjectMilestoneCode > 0)
            {
                objPM = objPM_Service.GetById(ProjectMilestoneCode);
            }
            else
                objPM = new RightsU_Entities.ProjectMilestone();

            var TitleName = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Code == objTitle.Title_Code).Select(x => x.Title_Name).SingleOrDefault();
            int TitleCode = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Code == objTitle.Title_Code).Select(x => x.Title_Code).SingleOrDefault();
            ViewBag.TitleMilestonename = TitleName;
            ViewBag.TitleMilestoneCode = TitleCode;

            var lstTalent = new SelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList(), "Talent_Code", "Talent_Name");
            ViewBag.TalentList = lstTalent;
            ViewBag.Mode = CommandName;
            var lstMilestoneNature = new SelectList(new Milestone_Nature_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList(), "Milestone_Nature_Code", "Milestone_Nature_Name");
            ViewBag.MilestoneNatureList = lstMilestoneNature;
            if (CommandName == "V")
            {
                ViewBag.TalentName = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.ProjectMilestoneCode == ProjectMilestoneCode).Select(s => s.Talent.Talent_Name).FirstOrDefault();
                ViewBag.MilestoneNatureName = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.ProjectMilestoneCode == ProjectMilestoneCode).Select(s => s.Milestone_Nature.Milestone_Nature_Name).FirstOrDefault();
            }
            TempData["Project_Milestone_Code"] = ProjectMilestoneCode;
            TempData["Mode"] = CommandName;
            return RedirectToAction("Index", "Project_Milestone",objPM); 
        }

        public ActionResult SaveTitleMilestone(RightsU_Entities.Title_Milestone objTM_MVC, FormCollection objFormCollection)
        {
            //string TalentCode = objFormCollection["divddlTalent"];
            //string TitleNAme = objFormCollection["lblTitleMilestoneName"];
            string Expiry_Date = objFormCollection["Expiry_Date"];
            objTM_MVC.Expiry_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(Expiry_Date));


            Title_Milestone objTM = new Title_Milestone();
            Title_Milestone_Service ObjTMService = new Title_Milestone_Service(objLoginEntity.ConnectionStringName);
            if (objTM_MVC.Title_Milestone_Code > 0)
            {
                objTM = ObjTMService.GetById(objTM_MVC.Title_Milestone_Code);
                objTM.Last_Action_By = objLoginUser.Users_Code;
                objTM.EntityState = State.Modified;
            }
            else
            {
                objTM.EntityState = State.Added;
                objTM.Is_Active = "Y";
            }
            objTM.Title_Code = Convert.ToInt32(objFormCollection["hdnTitleMilestoneCode"]);
            //objTM.Talent_Code = Convert.ToInt32(objFormCollection["divddlTalent"]);
            //objTM.Milestone_Nature_Code = Convert.ToInt32(objFormCollection["divddlMilestoneNature"]);
            objTM.Talent_Code = objTM_MVC.Talent_Code;
            objTM.Milestone_Nature_Code = objTM_MVC.Milestone_Nature_Code;
            objTM.Expiry_Date = objTM_MVC.Expiry_Date;
            objTM.Milestone = objFormCollection["txtMilestone"];
            objTM.Action_Item = objFormCollection["txtAction"];
            //objTM.Is_Abandoned = objTM_MVC.Is_Abandoned;
            objTM.Is_Abandoned = objFormCollection["Abandoned"];
            objTM.Remarks = objTM_MVC.Remarks;
            objTM.Inserted_On = DateTime.Now;
            objTM.Inserted_by = objLoginUser.Users_Code;
            objTM.Last_Updated_Time = DateTime.Now;
            objTM.Last_Action_By = objLoginUser.Users_Code;

            dynamic resultSet;
            string status = "S", message = "Record {ACTION} successfully";

            bool valid = ObjTMService.Save(objTM, out resultSet);

            if (valid)
            {
                int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                if (objTM_MVC.Title_Milestone_Code > 0)
                {
                    message = "Title Milestone updated successfully";
                    //message = message.Replace("{ACTION}", "updated");
                }
                else
                {
                    //message = message.Replace("{ACTION}", "added");
                    message = "Title Milestone added successfully";
                    //Mail(objU);
                }
                //FetchData();
            }
            else
            {
                status = "E";
                if (objTM_MVC.Title_Milestone_Code > 0)
                    message = message.Replace("Record {ACTION} successfully", resultSet);
                else
                    message = message.Replace("Record {ACTION} successfully", resultSet);
            };

            var obj = new
            {
                RecordCount = lstTitle_Milestone.Count(),
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public void Delete(int Project_Milestone_Code)
        {
            if (Project_Milestone_Code > 0)
            {
                ProjectMilestone_Service objProjectMilestone_Service = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName);
                ProjectMilestone objProject_Milestone = objProjectMilestone_Service.GetById(Project_Milestone_Code);
                objProject_Milestone.EntityState = State.Deleted;
                dynamic resultSet;
                objProjectMilestone_Service.Save(objProject_Milestone, out resultSet);
                lstProjectMilestone_Searched = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                lstProjectMilestone_Searched = lstProjectMilestone_Searched;
            }

        }
        public void SendForApproval(int Project_Milestone_Code)
        {
            if (Project_Milestone_Code > 0)
            {
                ProjectMilestone_Service objProjectMilestone_Service = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName);
                ProjectMilestone objProject_Milestone = objProjectMilestone_Service.GetById(Project_Milestone_Code);
                objProject_Milestone.EntityState = State.Modified;
                objProject_Milestone.WorkflowStatus = "A";
                dynamic resultSet;
                objProjectMilestone_Service.Save(objProject_Milestone, out resultSet);
                lstProjectMilestone_Searched = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                lstProjectMilestone_Searched = lstProjectMilestone_Searched;
            }

        }
    }
}
