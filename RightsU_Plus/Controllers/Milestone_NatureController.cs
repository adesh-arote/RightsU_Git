using RightsU_BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Milestone_NatureController : BaseController
    {
        #region --Properties--
        private List<RightsU_Entities.Milestone_Nature> lstMilestoneNature
        {
            get
            {
                if (Session["lstMilestoneNature"] == null)
                    Session["lstMilestoneNature"] = new List<RightsU_Entities.Milestone_Nature>();
                return (List<RightsU_Entities.Milestone_Nature>)Session["lstMilestoneNature"];
            }
            set { Session["lstMilestoneNature"] = value; }
        }

        private List<RightsU_Entities.Milestone_Nature> lstMilestoneNature_Searched
        {
            get
            {
                if (Session["lstMilestoneNature_Searched"] == null)
                    Session["lstMilestoneNature_Searched"] = new List<RightsU_Entities.Milestone_Nature>();
                return (List<RightsU_Entities.Milestone_Nature>)Session["lstMilestoneNature_Searched"];
            }
            set { Session["lstMilestoneNature_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMilestoneNature);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForMilestoneNature.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstMilestoneNature_Searched = lstMilestoneNature= new Milestone_Nature_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Milestone_Nature/Index.cshtml");
        }

        public PartialViewResult BindMilestoneNatureList(int pageNo, int recordPerPage, int MilestoneNatureCode, string commandName, string sortType)
        {
            ViewBag.Milestone_Nature_Code = MilestoneNatureCode;
            ViewBag.CommandName = commandName;
            List<RightsU_Entities.Milestone_Nature> lst = new List<RightsU_Entities.Milestone_Nature>();
            int RecordCount = 0;
            RecordCount = lstMilestoneNature_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstMilestoneNature_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstMilestoneNature_Searched.OrderBy(o => o.Milestone_Nature_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstMilestoneNature_Searched.OrderByDescending(o => o.Milestone_Nature_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Milestone_Nature/_MilestoneNatureList.cshtml", lst);
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
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForMilestoneNature), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        #endregion
        public JsonResult CheckRecordLock(int MilestoneNatureCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (MilestoneNatureCode > 0)
            {
                isLocked = DBUtil.Lock_Record(MilestoneNatureCode, GlobalParams.ModuleCodeForMilestoneNature, objLoginUser.Users_Code, out RLCode, out strMessage);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SearchMilestoneNature(string searchText)
        {
           Milestone_Nature_Service objService = new Milestone_Nature_Service(objLoginEntity.ConnectionStringName);
            if (!string.IsNullOrEmpty(searchText))
            {
                lstMilestoneNature_Searched = lstMilestoneNature.Where(w => w.Milestone_Nature_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstMilestoneNature_Searched = lstMilestoneNature;


            var obj = new
            {
                Record_Count = lstMilestoneNature_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult ActiveDeactiveMilestoneNature(int Milestone_Nature_Code, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;

            bool isLocked = DBUtil.Lock_Record(Milestone_Nature_Code, GlobalParams.ModuleCodeForMilestoneNature, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {
                Milestone_Nature_Service objService = new Milestone_Nature_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Milestone_Nature objMilestoneNature = objService.GetById(Milestone_Nature_Code);
                objMilestoneNature.Is_Active = doActive;
                objMilestoneNature.EntityState = State.Modified;
                dynamic resultSet;

                bool isValid = objService.Save(objMilestoneNature, out resultSet);
                if (isValid)
                {
                    string Action = "A";
                    lstMilestoneNature.Where(w => w.Milestone_Nature_Code == Milestone_Nature_Code).First().Is_Active = doActive;
                    lstMilestoneNature_Searched.Where(w => w.Milestone_Nature_Code == Milestone_Nature_Code).First().Is_Active = doActive;
                    if (doActive == "Y")
                    {
                        message = objMessageKey.Recordactivatedsuccessfully;
                        Action = "A";
                    }                        
                    else
                    {
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                        Action = "DA";
                    }                        

                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objMilestoneNature);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForMilestoneNature), Convert.ToInt32(objMilestoneNature.Milestone_Nature_Code), LogData, Action, objLoginUser.Users_Code);
                    }
                    catch (Exception ex)
                    {

                    }
                }
                else
                {
                    status = "E";
                    message = resultSet;
                }
                DBUtil.Release_Record(RLCode);
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
        public JsonResult SaveMilestoneNature(int MilestoneNatureCode, string MilestoneNatureName, int Record_Code)
        {
            string Action = "C";
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (MilestoneNatureCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            Milestone_Nature_Service objService = new Milestone_Nature_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Milestone_Nature objMilestoneNature = null;

            if (MilestoneNatureCode > 0)
            {
                objMilestoneNature = objService.GetById(MilestoneNatureCode);
                objMilestoneNature.EntityState = State.Modified;
                Action = "U";
            }
            else
            {
                objMilestoneNature = new RightsU_Entities.Milestone_Nature();
                objMilestoneNature.EntityState = State.Added;
                objMilestoneNature.Inserted_On = DateTime.Now;
                objMilestoneNature.Inserted_by= objLoginUser.Users_Code;
                Action = "C";
            }

            objMilestoneNature.Last_Updated_Time = DateTime.Now;
            objMilestoneNature.Last_Action_By= objLoginUser.Users_Code;
            objMilestoneNature.Is_Active = "Y";
            objMilestoneNature.Milestone_Nature_Name= MilestoneNatureName;
            dynamic resultSet;
            bool isValid = objService.Save(objMilestoneNature, out resultSet);

            if (isValid)
            {
                lstMilestoneNature_Searched = lstMilestoneNature = objService.SearchFor(s => true).OrderByDescending(x => x.Last_Updated_Time).ToList();

                try
                {
                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objMilestoneNature);
                    bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForMilestoneNature), Convert.ToInt32(objMilestoneNature.Milestone_Nature_Code), LogData, Action, objLoginUser.Users_Code);
                }
                catch (Exception ex)
                {

                }
            }
            else
            {
                status = "E";
                message = resultSet;
            }
            int recordLockingCode = Convert.ToInt32(Record_Code);
            DBUtil.Release_Record(recordLockingCode);
            var obj = new
            {
                RecordCount = lstMilestoneNature_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}