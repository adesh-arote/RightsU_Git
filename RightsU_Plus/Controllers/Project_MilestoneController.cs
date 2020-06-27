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
    public class Project_MilestoneController : BaseController
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


        public string Mode
        {
            get
            {
                if (Session["Mode"] == null)
                    Session["Mode"] = string.Empty;
                return (string)Session["Mode"];
            }
            set { Session["Mode"] = value; }
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

        private List<RightsU_Entities.ProjectMilestoneDetail> lstProjectMilestoneDetails
        {
            get
            {
                if (Session["lstProjectMilestoneDetails"] == null)
                    Session["lstProjectMilestoneDetails"] = new List<RightsU_Entities.ProjectMilestoneDetail>();
                return (List<RightsU_Entities.ProjectMilestoneDetail>)Session["lstProjectMilestoneDetails"];
            }
            set { Session["lstProjectMilestoneDetails"] = value; }
        }
        private List<RightsU_Entities.ProjectMilestoneTitle> lstProjectMilestoneTitles
        {
            get
            {
                if (Session["lstProjectMilestoneTitles"] == null)
                    Session["lstProjectMilestoneTitles"] = new List<RightsU_Entities.ProjectMilestoneTitle>();
                return (List<RightsU_Entities.ProjectMilestoneTitle>)Session["lstProjectMilestoneTitles"];
            }
            set { Session["lstProjectMilestoneTitles"] = value; }
        }

        private RightsU_Entities.ProjectMilestone objProjectMilestone
        {
            get
            {
                if (Session["objProjectmilestone"] == null)
                    Session["objProjectmilestone"] = new RightsU_Entities.ProjectMilestone();
                return (RightsU_Entities.ProjectMilestone)Session["objProjectmilestone"];
            }
            set { Session["objProjectmilestone"] = value; }
        }
        private List<RightsU_Entities.ProjectMilestone> lstProject_Milestone
        {
            get
            {
                if (Session["lstProject_Milestone"] == null)
                    Session["lstProject_Milestone"] = new List<RightsU_Entities.ProjectMilestone>();
                return (List<RightsU_Entities.ProjectMilestone>)Session["lstProject_Milestone"];
            }
            set { Session["lstProject_Milestone"] = value; }
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
            ProjectMilestone_Service objService = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName);
            //ProjectMilestone objProjectMilestone = new ProjectMilestone();
            PageNo = Page_No;
            ViewBag.PageNo = PageNo;
            string moduleCode = GlobalParams.ModuleCodeForProjectMilestone.ToString();
            ViewBag.Code = moduleCode;
            Mode = TempData["Mode"].ToString();
            TempData.Keep("Mode");
            int ProjectMilestoneCode = Convert.ToInt32(TempData["Project_Milestone_Code"]);
            TempData.Keep("Project_Milestone_Code");


            var MilestoneType = new Milestone_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").Select(s => new { s.Milestone_Type_Code, s.Milestone_Type_Name }).Distinct().ToList();

            ViewBag.MilestoneTypelist = new SelectList(MilestoneType, "Milestone_Type_Code", "Milestone_Type_Name");


            IList<SelectListItem> items = new List<SelectListItem>
            {
                new SelectListItem{Text = "Days", Value = "1"},
                new SelectListItem{Text = "Weeks", Value = "2"},
                new SelectListItem{Text = "Months", Value = "3"},
                new SelectListItem{Text = "Years", Value = "4"},

            };
            ViewBag.MilestoneUnitTypelist = new SelectList(items, "Value", "Text");

            if (ProjectMilestoneCode > 0)
            {
                objProjectMilestone = null;
                objProjectMilestone = objService.GetById(ProjectMilestoneCode);
                ViewBag.MilestoneTypelist = new SelectList(MilestoneType, "Milestone_Type_Code", "Milestone_Type_Name",objProjectMilestone.Milestone_Type_Code);
                ViewBag.MilestoneUnitTypelist = new SelectList(items, "Value", "Text", objProjectMilestone.Milestone_Unit_Type);
            }

            var lstTalent = new SelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList(), "Talent_Code", "Talent_Name");
            ViewBag.TalentList = lstTalent;
            ViewBag.Mode = Mode;
            //var lstMilestoneNature = new SelectList(new Milestone_Nature_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList(), "Milestone_Nature_Code", "Milestone_Nature_Name");
            ViewBag.MilestoneNatureList = new MultiSelectList(new Milestone_Nature_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(t => t.Milestone_Nature_Name).ToList(), "Milestone_Nature_Code", "Milestone_Nature_Name");
           
            objTitle = new Title_Service(objLoginEntity.ConnectionStringName).GetById(id);
            if (TempData["RecodLockingCode"] == "" || TempData["RecodLockingCode"] == null)
                ViewBag.RecordLockingCode = 0;
            else
                ViewBag.RecordLockingCode = TempData["RecodLockingCode"];
            int RecordLockingCode =Convert.ToInt32(TempData["RecodLockingCode"]);

           
            lstTitle_Milestone = new Title_Milestone_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
           
            ViewBag.UserModuleRights = GetUserModuleRights();
            if (Mode == GlobalParams.DEAL_MODE_VIEW)
            {
                if (Mode == GlobalParams.DEAL_MODE_VIEW)
                return View("~/Views/Project_Milestone/View.cshtml", objProjectMilestone);
            }

            return View("~/Views/Project_Milestone/Index.cshtml", objProjectMilestone);
        }

        public JsonResult Save(ProjectMilestone objTempProjectMilestone, FormCollection objForm)
        {
            // string status = "S", message = ""; 
            int agrrementno = 0;
            ProjectMilestone_Service objPMService = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName);
            // ProjectMilestone objPM = new ProjectMilestone();
            List<ProjectMilestone> obj1 = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName).SearchFor(x=>true).ToList();
          
         
            if (objTempProjectMilestone.ProjectMilestoneCode > 0)
            {

                objProjectMilestone = objPMService.GetById(objTempProjectMilestone.ProjectMilestoneCode);
                objProjectMilestone.EntityState = State.Modified;
            }
            else
            {
                if (obj1.Count() == 0)
                {
                    agrrementno = 1;
                }
                else
                {
                    agrrementno = obj1.Select(s => s.ProjectMilestoneCode).Max() + 1;
                }
                objProjectMilestone.EntityState = State.Added;
                objProjectMilestone.AgreementNo = "I-2018-0000" +  agrrementno;
                objProjectMilestone.WorkflowStatus = "O";
            }
            objProjectMilestone.AgreementDate = Convert.ToDateTime(objForm["Agreement_Date"]);
            objProjectMilestone.ProjectName = objForm["ProjectName"];
            objProjectMilestone.MileStone_Nature_Code = objTempProjectMilestone.MileStone_Nature_Code;
            objProjectMilestone.TalentCode = objTempProjectMilestone.TalentCode;
            objProjectMilestone.IsClosed = objForm["Abandoned"];
            objProjectMilestone.IsTentitive = "Y";
            objProjectMilestone.PeriodType = objForm["Right_Type"];

            if (objProjectMilestone.PeriodType == "Y")
            {
                objProjectMilestone.StartDate = Convert.ToDateTime(objForm["Start_Date"]);
                objProjectMilestone.EndDate = Convert.ToDateTime(objForm["End_Date"]);
                objProjectMilestone.Term = objForm["Term_YY"];
            }
           else if(objProjectMilestone.PeriodType == "M")
            {
                objProjectMilestone.StartDate = Convert.ToDateTime(objForm["Milestone_Start_Date"]);
                objProjectMilestone.EndDate = Convert.ToDateTime(objForm["Milestone_End_Date"]);

                objProjectMilestone.Milestone_Type_Code = Convert.ToInt32(objForm["ddlMilestone_Type_Code"]);
                objProjectMilestone.Milestone_No_Of_Unit = Convert.ToInt32(objForm["txtMilestone_No_Of_Unit"]);
                objProjectMilestone.Milestone_Unit_Type = Convert.ToInt32(objForm["ddlMilestone_Unit_Type"]);
            }
          
           



            dynamic resultSet;
            string status = "S", message = "Record {ACTION} successfully";

            bool valid = objPMService.Save(objProjectMilestone, out resultSet);
            
            if (valid)
            {
                int recordLockingCode = Convert.ToInt32(objForm["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                if (objTempProjectMilestone.ProjectMilestoneCode > 0)
                {
                    message = "Project Milestone updated successfully";
                    //message = message.Replace("{ACTION}", "updated");
                }
                else
                {
                    //message = message.Replace("{ACTION}", "added");
                    message = "Project Milestone added successfully";
                    //Mail(objU);
                }
                //FetchData();
            }
            else
            {
                status = "E";
                if (objTempProjectMilestone.ProjectMilestoneCode > 0)
                    message = message.Replace("Record {ACTION} successfully", resultSet);
                else
                    message = message.Replace("Record {ACTION} successfully", resultSet);
            };

            var obj = new
            {
                RecordCount = lstProject_Milestone.Count(),
                Status = status,
                Message = message
            };
            return Json(obj);
        }


        public PartialViewResult BindPMDetailsList(string commandName, string dummyGuid)
        {
            string maxDate = "";
            //List<RightsU_Entities.ProjectMilestoneDetail> lst = new List<RightsU_Entities.ProjectMilestoneDetail>();
            int RecordCount = 0;
            RecordCount = lstProjectMilestoneDetails.Count;

            ViewBag.CommandName = commandName;
            ViewBag.DummmyGuid = dummyGuid;
           
            ViewBag.MaxDate = maxDate;
            List<ProjectMilestoneDetail> lst = objProjectMilestone.ProjectMilestoneDetails.Where(w => w.EntityState != State.Deleted).OrderBy(x => x.MilestoneName).ToList();
            return PartialView("~/Views/Project_Milestone/_PMDetailsList.cshtml", lst);
        }



        public JsonResult SavePMDetails(string dummyGuid, DateTime effectiveDate, string exchangeRate, string exchangeRateRmk)
        {
            string status = "S", message = "";
             
            ProjectMilestoneDetail objPMD = objProjectMilestone.ProjectMilestoneDetails.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
            if (objPMD == null)
            {
                objPMD = new ProjectMilestoneDetail();
                objPMD.EntityState = State.Added;
                objProjectMilestone.ProjectMilestoneDetails.Add(objPMD);
            }
            else
            {
                if (objPMD.ProjectMilestoneDetailCode > 0)
                    objPMD.EntityState = State.Modified;
            }

            objPMD.MileStoneDate = effectiveDate;
            objPMD.MilestoneName = exchangeRate;
            objPMD.Remarks = exchangeRateRmk;

            object obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult DeletePMDetailsList(string dummyGuid)
        {
            string status = "S", message = "";

            ProjectMilestoneDetail objPMD = objProjectMilestone.ProjectMilestoneDetails.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
            if (objPMD != null)
            {
                if (objPMD.ProjectMilestoneDetailCode > 0)
                    objPMD.EntityState = State.Deleted;
                else
                    objProjectMilestone.ProjectMilestoneDetails.Remove(objPMD);
            }
            else
            {
                status = "E";
                message = objMessageKey.Objectnotfound;
            }

            object obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public PartialViewResult BindPMTitleList(string commandName, string dummyGuid)
        {
            List<RightsU_Entities.ProjectMilestoneTitle> lst = new List<RightsU_Entities.ProjectMilestoneTitle>();
            int RecordCount = 0;
            RecordCount = lstProjectMilestoneDetails.Count;

            ViewBag.CommandName = commandName;
            ViewBag.DummmyGuid = dummyGuid;
            List<ProjectMilestoneTitle> lstPMTitle = objProjectMilestone.ProjectMilestoneTitles.Where(w => w.EntityState != State.Deleted).OrderBy(x => x.ProspectTitleName).ToList();
            return PartialView("~/Views/Project_Milestone/_PMTitlesList.cshtml", lstPMTitle);
        }

        public JsonResult SavePMTitles(string dummyGuid, string exchangeRate)
        {
            string status = "S", message = "";

            ProjectMilestoneTitle objPMT = objProjectMilestone.ProjectMilestoneTitles.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
            if (objPMT == null)
            {
                objPMT = new ProjectMilestoneTitle();
                objPMT.EntityState = State.Added;
                objProjectMilestone.ProjectMilestoneTitles.Add(objPMT);
            }
            else
            {
                if (objPMT.ProjectMilestoneTitleCode > 0)
                    objPMT.EntityState = State.Modified;
            }

            objPMT.ProspectTitleName= exchangeRate;

            object obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult DeletePMTitlesList(string dummyGuid)
        {
            string status = "S", message = "";

            ProjectMilestoneTitle objPMT = objProjectMilestone.ProjectMilestoneTitles.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
            if (objPMT != null)
            {
                if (objPMT.ProjectMilestoneTitleCode > 0)
                    objPMT.EntityState = State.Deleted;
                else
                    objProjectMilestone.ProjectMilestoneTitles.Remove(objPMT);
            }
            else
            {
                status = "E";
                message = objMessageKey.Objectnotfound;
            }

            object obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public ActionResult Cancel()
        {
            TempData["IsMenu"] = "N";
            objProjectMilestone = null;
            return RedirectToAction("Index", "Project_MilestoneList");
        }


    }
}
