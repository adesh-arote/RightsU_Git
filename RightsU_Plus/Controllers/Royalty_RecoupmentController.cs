using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using Newtonsoft.Json;

namespace RightsU_Plus.Controllers
{
    public class Royalty_RecoupmentController : BaseController
    {
        #region --- Properties ---

        private List<RightsU_Entities.Royalty_Recoupment> lstRoyalty
        {
            get
            {
                if (Session["lstRoyalty"] == null)
                    Session["lstRoyalty"] = new List<RightsU_Entities.Royalty_Recoupment>();
                return (List<RightsU_Entities.Royalty_Recoupment>)Session["lstRoyalty"];
            }
            set { Session["lstRoyalty"] = value; }
        }

        private List<RightsU_Entities.Royalty_Recoupment> lstRoyalty_Searched
        {
            get
            {
                if (Session["lstRoyalty_Searched"] == null)
                    Session["lstRoyalty_Searched"] = new List<RightsU_Entities.Royalty_Recoupment>();
                return (List<RightsU_Entities.Royalty_Recoupment>)Session["lstRoyalty_Searched"];
            }
            set { Session["lstRoyalty_Searched"] = value; }
        }

        private List<RightsU_Entities.Royalty_Recoupment_Details> RoyaltyRecoupmentDetailsList
        {
            get
            {
                if (Session["RoyaltyRecoupmentDetailsList"] == null)
                    Session["RoyaltyRecoupmentDetailsList"] = new List<RightsU_Entities.Royalty_Recoupment_Details>();
                return (List<RightsU_Entities.Royalty_Recoupment_Details>)Session["RoyaltyRecoupmentDetailsList"];
            }
            set { Session["RoyaltyRecoupmentDetailsList"] = value; }
        }

        private string ModuleCode
        {
            get
            {
                if (Session["ModuleCode"] == null)
                {
                    Session["ModuleCode"] = 0;
                }
                return Convert.ToString(Session["ModuleCode"].ToString());
            }
            set
            {
                Session["ModuleCode"] = value;
            }
        }

        #endregion

        public ViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForRoyaltyRecoupment);
            //ModuleCode = Request.QueryString["modulecode"];
            ModuleCode = GlobalParams.ModuleCodeForRoyaltyRecoupment.ToString();
            return View("~/Views/Royalty_Recoupment/Index.cshtml");
        }

        public PartialViewResult BindPartialPages(string key, int royltyCode)
        {
            if (key == "LIST")
            {
                ViewBag.Code = ModuleCode;
                ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
                FetchData();
                List<SelectListItem> lstSort = new List<SelectListItem>();
                lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
                ViewBag.SortType = lstSort;
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/Royalty_Recoupment/_RoyaltyRecoupment.cshtml");
            }
            else
            {
                Royalty_Recoupment_Service objRoyalty_Service = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Royalty_Recoupment objRoyalty = null;

                if (royltyCode > 0)
                    objRoyalty = objRoyalty_Service.GetById(royltyCode);
                else
                    objRoyalty = new RightsU_Entities.Royalty_Recoupment();

                List<Royalty_Recoupment_Details> lstRRD = new Additional_Expense_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").ToList().Select(s =>
                    new Royalty_Recoupment_Details()
                    {
                        EntityState = State.Added,
                        Recoupment_Type = "A",
                        Recoupment_Type_Code = s.Additional_Expense_Code,
                        Recoupment_Type_Name = s.Additional_Expense_Name,
                        Add_Subtract = "A"
                    }).ToList();

                lstRRD.AddRange(new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").ToList().Select(s =>
                    new Royalty_Recoupment_Details()
                    {
                        EntityState = State.Added,
                        Recoupment_Type = "C",
                        Recoupment_Type_Code = s.Cost_Type_Code,
                        Recoupment_Type_Name = s.Cost_Type_Name,
                        Add_Subtract = "A"
                    }).ToList());

                if (royltyCode > 0 && objRoyalty.Royalty_Recoupment_Details.Count > 0)
                {
                    int Postion = objRoyalty.Royalty_Recoupment_Details.Max(m => (m.Position ?? 0));
                    lstRRD.OrderBy(o => o.Recoupment_Type_Name).ToList().ForEach(f =>
                    {
                        Postion++;
                        Royalty_Recoupment_Details objRRD = objRoyalty.Royalty_Recoupment_Details.ToList().Where(w => w.Recoupment_Type_Code == f.Recoupment_Type_Code
                            && w.Recoupment_Type == f.Recoupment_Type).FirstOrDefault();

                        f.Position = (objRRD != null) ? objRRD.Position : Postion;
                    });
                }
                ViewBag.RecoupmentTypeList = RoyaltyRecoupmentDetailsList = lstRRD.OrderBy(o => o.Position).ToList();
                return PartialView("~/Views/Royalty_Recoupment/_AddEditRoyaltyRecoupment.cshtml", objRoyalty);

            }
        }

        public PartialViewResult BindRoyltyList(int pageNo, int recordPerPage,string sortType)
        {
            List<RightsU_Entities.Royalty_Recoupment> lst = new List<RightsU_Entities.Royalty_Recoupment>();
            int RecordCount = 0;
            RecordCount = lstRoyalty_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstRoyalty_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstRoyalty_Searched.OrderBy(o => o.Royalty_Recoupment_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstRoyalty_Searched.OrderByDescending(o => o.Royalty_Recoupment_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Royalty_Recoupment/_RoyaltyRecoupmentList.cshtml", lst);
        }

        #region  --- Other Methods ---

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

        private void FetchData()
        {
            lstRoyalty_Searched = lstRoyalty = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
        }

        #endregion

        public JsonResult SearchRoyalty(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstRoyalty_Searched = lstRoyalty.Where(w => w.Royalty_Recoupment_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstRoyalty_Searched = lstRoyalty;

            var obj = new
            {
                Record_Count = lstRoyalty_Searched.Count
            };
            return Json(obj);
        }

        public JsonResult ActiveDeactiveRoyalty(int royaltyCode, string doActive)
        {
             string status = "S", message = "Record {ACTION} successfully", strMessage = "", Action = Convert.ToString(ActionType.A); // A = "Active";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(royaltyCode, GlobalParams.ModuleCodeForRoyaltyRecoupment, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                Royalty_Recoupment_Service objService = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Royalty_Recoupment objRoyalty = objService.GetById(royaltyCode);
                objRoyalty.Is_Active = doActive;
                objRoyalty.Last_Updated_Time = DateTime.Now;
                objRoyalty.Last_Action_By = objLoginUser.Users_Code;
                objRoyalty.EntityState = State.Modified;
                dynamic resultSet;

                bool isValid = objService.Save(objRoyalty, out resultSet);

                if (isValid)
                {
                    lstRoyalty.Where(w => w.Royalty_Recoupment_Code == royaltyCode).First().Is_Active = doActive;
                    lstRoyalty_Searched.Where(w => w.Royalty_Recoupment_Code == royaltyCode).First().Is_Active = doActive;
                    
                    foreach (var items in objRoyalty.Royalty_Recoupment_Details)
                    {
                        int Type_Code = Convert.ToInt32(items.Recoupment_Type_Code);
                        string Tbl_Type = items.Recoupment_Type;
                        if(Tbl_Type == "A")
                            items.Recoupment_Type_Name = new Additional_Expense_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Additional_Expense_Code == Type_Code).Select(x => x.Additional_Expense_Name).FirstOrDefault();
                        else
                            items.Recoupment_Type_Name = new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Cost_Type_Code == Type_Code).Select(x => x.Cost_Type_Name).FirstOrDefault();
                    }

                    if (doActive == "Y")
                    {
                        //message = message.Replace("{ACTION}", "Activated");
                        message = objMessageKey.Recordactivatedsuccessfully;
                    }
                    else
                    {
                        Action = Convert.ToString(ActionType.D); // D = "Deactive";
                        //message = message.Replace("{ACTION}", "Deactivated");
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                    }

                    try
                    {
                        objRoyalty.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objRoyalty.Inserted_By));
                        objRoyalty.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objRoyalty.Last_Action_By));

                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objRoyalty);
                        //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForRoyaltyRecoupment, objRoyalty.Royalty_Recoupment_Code, LogData, Action, objLoginUser.Users_Code);

                        MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                        objAuditLog.moduleCode = GlobalParams.ModuleCodeForRoyaltyRecoupment;
                        objAuditLog.intCode = objRoyalty.Royalty_Recoupment_Code;
                        objAuditLog.logData = LogData;
                        objAuditLog.actionBy = objLoginUser.Login_Name;
                        objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objRoyalty.Last_Updated_Time));
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
                    if (doActive == "Y")
                        message = objMessageKey.CouldNotActivatedRecord;
                    else
                        message = objMessageKey.CouldNotDeactivatedRecord;
                }

                objCommonUtil.Release_Record(RLCode, objLoginEntity.ConnectionStringName);
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

        public ViewResult AddEditRoyality(int royltyCode)
        {
            Royalty_Recoupment_Service objRoyalty_Service = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Royalty_Recoupment objRoyalty = null;
            if (royltyCode > 0)
                objRoyalty = objRoyalty_Service.GetById(royltyCode);
            else
                objRoyalty = new RightsU_Entities.Royalty_Recoupment();

            List<Royalty_Recoupment_Details> lstRRD = new Additional_Expense_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").ToList().Select(s =>
                new Royalty_Recoupment_Details()
                {
                    EntityState = State.Added,
                    Recoupment_Type = "A",
                    Recoupment_Type_Code = s.Additional_Expense_Code,
                    Recoupment_Type_Name = s.Additional_Expense_Name,
                    Add_Subtract = "A"                                      
                }).ToList();

            lstRRD.AddRange(new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").ToList().Select(s =>
                new Royalty_Recoupment_Details()
                {
                    EntityState = State.Added,
                    Recoupment_Type = "C",
                    Recoupment_Type_Code = s.Cost_Type_Code,
                    Recoupment_Type_Name = s.Cost_Type_Name,
                    Add_Subtract = "A"
                }).ToList());
            if (royltyCode > 0 && objRoyalty.Royalty_Recoupment_Details.Count>0)
            {
                int Postion = objRoyalty.Royalty_Recoupment_Details.Max(m => (m.Position ?? 0));
                lstRRD.OrderBy(o => o.Recoupment_Type_Name).ToList().ForEach(f =>
                {
                    Postion++;
                    Royalty_Recoupment_Details objRRD = objRoyalty.Royalty_Recoupment_Details.ToList().Where(w => w.Recoupment_Type_Code == f.Recoupment_Type_Code
                        && w.Recoupment_Type == f.Recoupment_Type).FirstOrDefault();

                    f.Position = (objRRD != null) ? objRRD.Position : Postion;
                });
            }

            ViewBag.RecoupmentTypeList = RoyaltyRecoupmentDetailsList = lstRRD.OrderBy(o => o.Position).ToList();
            return View("~/Views/Royalty_Recoupment/AddEditRoyaltyRecoupment.cshtml", objRoyalty);
        }

        [HttpPost]
        public ActionResult SaveRoyalty(RightsU_Entities.Royalty_Recoupment objRoyalty_MVC, FormCollection objFormCollection)
        {
            string Action = Convert.ToString(ActionType.C); // C = "Create";
            Royalty_Recoupment_Service objRoyalty_Service = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Royalty_Recoupment objRoyalty = null;
            if (objRoyalty_MVC.Royalty_Recoupment_Code > 0)
            {
                dynamic resultSets = "";
                objRoyalty = objRoyalty_Service.GetById(objRoyalty_MVC.Royalty_Recoupment_Code);
                objRoyalty.Royalty_Recoupment_Details.ToList().ForEach(f => { f.EntityState = State.Deleted; });

                objRoyalty.Royalty_Recoupment_Code = objRoyalty_MVC.Royalty_Recoupment_Code;
                objRoyalty.EntityState = State.Modified;
            }
            else
            {
                objRoyalty = new RightsU_Entities.Royalty_Recoupment();
                objRoyalty.EntityState = State.Added;
                objRoyalty.Royalty_Recoupment_Name = objRoyalty_MVC.Royalty_Recoupment_Name;
                objRoyalty.Is_Active = "Y";
                objRoyalty.Inserted_By = objLoginUser.Users_Code;
                objRoyalty.Inserted_On = DateTime.Now;
            }
            objRoyalty.Last_Updated_Time = DateTime.Now;
            objRoyalty.Last_Action_By = objLoginUser.Users_Code;

            if (objFormCollection["chkRecoupmentType"] != null)
            {
                string[] arrDummyGuid = objFormCollection["chkRecoupmentType"].Split(',');
                int i = 0;
                foreach (string dummyGuid in arrDummyGuid)
                {
                    Royalty_Recoupment_Details objRRD = RoyaltyRecoupmentDetailsList.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
                    if (objRRD != null)
                    {
                        i++;
                        objRRD.Position = i;
                        objRoyalty.Royalty_Recoupment_Details.Add(objRRD);
                    }
                }
            }

            objRoyalty.Royalty_Recoupment_Name = objRoyalty_MVC.Royalty_Recoupment_Name;
            Royalty_Recoupment objR = new Royalty_Recoupment();
            Royalty_Recoupment_Service objRoyaltyService = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);

            dynamic resultSet;
            string status = "S", message = "";

            bool valid = objRoyalty_Service.Save(objRoyalty, out resultSet);
            if(valid)
            {
                int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                if (objRoyalty_MVC.Royalty_Recoupment_Code > 0)
                {
                    Action = Convert.ToString(ActionType.U); // U = "Update";
                    message = objMessageKey.Recordupdatedsuccessfully;
                }
                else
                {
                    message = objMessageKey.RecordAddedSuccessfully;
                }

                try
                {
                    objRoyalty.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objRoyalty.Inserted_By));
                    objRoyalty.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objRoyalty.Last_Action_By));

                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objRoyalty);
                    //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForRoyaltyRecoupment, objRoyalty.Royalty_Recoupment_Code, LogData, Action, objLoginUser.Users_Code);

                    MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                    objAuditLog.moduleCode = GlobalParams.ModuleCodeForRoyaltyRecoupment;
                    objAuditLog.intCode = objRoyalty.Royalty_Recoupment_Code;
                    objAuditLog.logData = LogData;
                    objAuditLog.actionBy = objLoginUser.Login_Name;
                    objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objRoyalty.Last_Updated_Time));
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

        public JsonResult CheckRecordLock(int royltyCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (royltyCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(royltyCode, GlobalParams.ModuleCodeForRoyaltyRecoupment, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForRoyaltyRecoupment), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
    }
}

