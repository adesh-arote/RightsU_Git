using Newtonsoft.Json;
using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Title_Objection_TypeController : BaseController
    {
        #region --Properties--
        private List<RightsU_Entities.Title_Objection_Type> lstTitle_Objection_Type
        {
            get
            {
                if (Session["lstTitle_Objection_Type"] == null)
                    Session["lstTitle_Objection_Type"] = new List<RightsU_Entities.Title_Objection_Type>();
                return (List<RightsU_Entities.Title_Objection_Type>)Session["lstTitle_Objection_Type"];
            }
            set { Session["lstTitle_Objection_Type"] = value; }
        }

        private List<RightsU_Entities.Title_Objection_Type> lstTitle_Objection_Type_Searched
        {
            get
            {
                if (Session["lstTitle_Objection_Type_Searched"] == null)
                    Session["lstTitle_Objection_Type_Searched"] = new List<RightsU_Entities.Title_Objection_Type>();
                return (List<RightsU_Entities.Title_Objection_Type>)Session["lstTitle_Objection_Type_Searched"];
            }
            set { Session["lstTitle_Objection_Type_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForTitleObjectionType.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstTitle_Objection_Type_Searched = lstTitle_Objection_Type = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = "Latest Modified", Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Objection Type Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Objection Type Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Title_Objection_Type/Index.cshtml");
        }

        public PartialViewResult BindTitle_Objection_TypeList(int pageNo, int recordPerPage, int Title_Objection_TypeCode, string commandName, string sortType)
        {
            ViewBag.Title_Objection_Type_Code = Title_Objection_TypeCode;
            ViewBag.CommandName = commandName;
            int? ParentObjectionType = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Objection_Type_Code == Title_Objection_TypeCode)
                    .Select(x => x.Parent_Objection_Type_Code).FirstOrDefault();
            ViewBag.ParentObjectionType = ParentObjectionType ?? 0;
            if (commandName == "ADD" || commandName == "EDIT")
            {
                ViewBag.ddlPTOT =
                    new SelectList(
                    new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName)
                    .SearchFor(x => x.Is_Active == "Y" && x.Parent_Objection_Type_Code == 0)
                    .ToList(),
                    "Objection_Type_Code", "Objection_Type_Name");
            }

            List<RightsU_Entities.Title_Objection_Type> lst = new List<RightsU_Entities.Title_Objection_Type>();
            int RecordCount = 0;
            RecordCount = lstTitle_Objection_Type_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstTitle_Objection_Type_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstTitle_Objection_Type_Searched.OrderBy(o => o.Objection_Type_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstTitle_Objection_Type_Searched.OrderByDescending(o => o.Objection_Type_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Title_Objection_Type/_Title_Objection_Type_List.cshtml", lst);
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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForTitleObjectionType), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        #endregion
        public JsonResult CheckRecordLock(int Title_Objection_TypeCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Title_Objection_TypeCode > 0)
            {
                isLocked = DBUtil.Lock_Record(Title_Objection_TypeCode, GlobalParams.ModuleCodeForTitleObjectionType, objLoginUser.Users_Code, out RLCode, out strMessage);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SearchTitle_Objection_Type(string searchText)
        {
            Title_Objection_Type_Service objService = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName);
            if (!string.IsNullOrEmpty(searchText))
            {
                lstTitle_Objection_Type_Searched = lstTitle_Objection_Type.Where(w => w.Objection_Type_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstTitle_Objection_Type_Searched = lstTitle_Objection_Type;


            var obj = new
            {
                Record_Count = lstTitle_Objection_Type_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult ActiveDeactiveTitle_Objection_Type(int Title_Objection_Type_Code, string doActive)
        {
            string status = "S", message = "", strMessage = "", Action = Convert.ToString(ActionType.A); // A = "Active";
            int RLCode = 0;

            bool isLocked = DBUtil.Lock_Record(Title_Objection_Type_Code, GlobalParams.ModuleCodeForTitleObjectionType, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {
                Title_Objection_Type_Service objService = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Title_Objection_Type objTitle_Objection_Type = objService.GetById(Title_Objection_Type_Code);
                objTitle_Objection_Type.Is_Active = doActive;
                objTitle_Objection_Type.Last_Updated_Time = DateTime.Now;
                objTitle_Objection_Type.Last_Action_By = objLoginUser.Users_Code;
                objTitle_Objection_Type.EntityState = State.Modified;
                dynamic resultSet;

                bool isValid = objService.Save(objTitle_Objection_Type, out resultSet);
                if (isValid)
                {
                    lstTitle_Objection_Type.Where(w => w.Objection_Type_Code == Title_Objection_Type_Code).First().Is_Active = doActive;
                    lstTitle_Objection_Type_Searched.Where(w => w.Objection_Type_Code == Title_Objection_Type_Code).First().Is_Active = doActive;
                    if (doActive == "Y")
                    {
                        message = objMessageKey.Recordactivatedsuccessfully;
                    }                        
                    else
                    {
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                        Action = Convert.ToString(ActionType.D); // D = "Deactive";
                    }

                    try
                    {
                        objTitle_Objection_Type.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objTitle_Objection_Type.Inserted_By));
                        objTitle_Objection_Type.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objTitle_Objection_Type.Last_Action_By));
                        objTitle_Objection_Type.Parent_Objection_Type_Name = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Objection_Type_Code == objTitle_Objection_Type.Parent_Objection_Type_Code).Select(x => x.Objection_Type_Name).FirstOrDefault();

                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objTitle_Objection_Type);
                        //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForTitleObjectionType), Convert.ToInt32(objTitle_Objection_Type.Objection_Type_Code), LogData, Action, objLoginUser.Users_Code);

                        MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                        objAuditLog.moduleCode = GlobalParams.ModuleCodeForTitleObjectionType;
                        objAuditLog.intCode = objTitle_Objection_Type.Objection_Type_Code;
                        objAuditLog.logData = LogData;
                        objAuditLog.actionBy = objLoginUser.Login_Name;
                        objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objTitle_Objection_Type.Last_Updated_Time));
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
        public JsonResult SaveTitle_Objection_Type(int Title_Objection_TypeCode, string Title_Objection_TypeName, int Record_Code, int TOT_Parent_Code = 0)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully, Action = Convert.ToString(ActionType.C); // C = "Create";
            if (Title_Objection_TypeCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            Title_Objection_Type_Service objService = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Title_Objection_Type objTitle_Objection_Type = null;

            if (Title_Objection_TypeCode > 0)
            {
                objTitle_Objection_Type = objService.GetById(Title_Objection_TypeCode);
                objTitle_Objection_Type.EntityState = State.Modified;
                Action = Convert.ToString(ActionType.U); // U = "Update";
            }
            else
            {
                objTitle_Objection_Type = new RightsU_Entities.Title_Objection_Type();
                objTitle_Objection_Type.EntityState = State.Added;
                objTitle_Objection_Type.Inserted_On = DateTime.Now;
                objTitle_Objection_Type.Inserted_By = objLoginUser.Users_Code;
            }

            objTitle_Objection_Type.Last_Updated_Time = DateTime.Now;
            objTitle_Objection_Type.Last_Action_By = objLoginUser.Users_Code;
            objTitle_Objection_Type.Is_Active = "Y";
            objTitle_Objection_Type.Objection_Type_Name = Title_Objection_TypeName;
            objTitle_Objection_Type.Parent_Objection_Type_Code = TOT_Parent_Code;
            dynamic resultSet;

            bool isValid = objService.Save(objTitle_Objection_Type, out resultSet);

            if (isValid)
            {
                lstTitle_Objection_Type_Searched = lstTitle_Objection_Type = objService.SearchFor(s => true).OrderByDescending(x => x.Last_Updated_Time).ToList();

                try
                {
                    objTitle_Objection_Type.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objTitle_Objection_Type.Inserted_By));
                    objTitle_Objection_Type.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objTitle_Objection_Type.Last_Action_By));
                    objTitle_Objection_Type.Parent_Objection_Type_Name = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Objection_Type_Code == objTitle_Objection_Type.Parent_Objection_Type_Code).Select(x => x.Objection_Type_Name).FirstOrDefault();

                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objTitle_Objection_Type);
                    //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForTitleObjectionType), Convert.ToInt32(objTitle_Objection_Type.Objection_Type_Code), LogData, Action, objLoginUser.Users_Code);

                    MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                    objAuditLog.moduleCode = GlobalParams.ModuleCodeForTitleObjectionType;
                    objAuditLog.intCode = objTitle_Objection_Type.Objection_Type_Code;
                    objAuditLog.logData = LogData;
                    objAuditLog.actionBy = objLoginUser.Login_Name;
                    objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objTitle_Objection_Type.Last_Updated_Time));
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
                message = resultSet;
            }
            int recordLockingCode = Convert.ToInt32(Record_Code);
            DBUtil.Release_Record(recordLockingCode);
            var obj = new
            {
                RecordCount = lstTitle_Objection_Type_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}


