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
    public class Platform_GroupController : BaseController
    {
        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult, ref List<T> UPResult) where T : class
        {
            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);
            var UpdateResult = FirstList.Except(DeleteResult, comparer);
            var Modified_Result = UpdateResult.Except(AddResult);

            DelResult = DeleteResult.ToList<T>();
            UPResult = Modified_Result.ToList<T>();

            return AddResult.ToList<T>();
        }

        private List<RightsU_Entities.Platform_Group> lstPlatform_Group
        {
            get
            {
                if (Session["lstPlatform_Group"] == null)
                    Session["lstPlatform_Group"] = new List<RightsU_Entities.Platform_Group>();
                return (List<RightsU_Entities.Platform_Group>)Session["lstPlatform_Group"];
            }
            set { Session["lstPlatform_Group"] = value; }
        }

        private List<RightsU_Entities.Platform_Group> lstPlatform_Group_Searched
        {
            get
            {
                if (Session["lstPlatform_Group_Searched"] == null)
                    Session["lstPlatform_Group_Searched"] = new List<RightsU_Entities.Platform_Group>();
                return (List<RightsU_Entities.Platform_Group>)Session["lstPlatform_Group_Searched"];
            }
            set { Session["lstPlatform_Group_Searched"] = value; }
        }

        private List<RightsU_Entities.Platform> lstPlatform
        {
            get
            {
                if (Session["lstPlatform"] == null)
                    Session["lstPlatform"] = new List<RightsU_Entities.Platform>();
                return (List<RightsU_Entities.Platform>)Session["lstPlatform"];
            }
            set { Session["lstPlatform"] = value; }
        }

        private List<RightsU_Entities.Platform> lstPlatform_Searched
        {
            get
            {
                if (Session["lstPlatform_Searched"] == null)
                    Session["lstPlatform_Searched"] = new List<RightsU_Entities.Platform>();
                return (List<RightsU_Entities.Platform>)Session["lstPlatform_Searched"];
            }
            set { Session["lstPlatform_Searched"] = value; }
        }

        private RightsU_Entities.Platform_Group objPlatform_Group
        {
            get
            {
                if (Session["objPlatform_Group"] == null)
                    Session["objPlatform_Group"] = new RightsU_Entities.Platform_Group();
                return (RightsU_Entities.Platform_Group)Session["objPlatform_Group"];
            }
            set { Session["objPlatform_Group"] = value; }
        }

        private Platform_Group_Service objPlatform_Group_Service
        {
            get
            {
                if (Session["objPlatform_Group_Service"] == null)
                    Session["objPlatform_Group_Service"] = new Platform_Group_Service(objLoginEntity.ConnectionStringName);
                return (Platform_Group_Service)Session["objPlatform_Group_Service"];
            }
            set { Session["objPlatform_Group_Service"] = value; }
        }

        public PartialViewResult BindPlatform_GroupList(int pageNo, int recordPerPage, int Platform_Group_Code, string commandName ,string sortType)
        {

            ViewBag.Platform_Group_Code = Platform_Group_Code;
            ViewBag.CommandName = commandName;
            Platform_Group_Service objService = new Platform_Group_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Platform_Group objLanguage_Group = objService.GetById(Platform_Group_Code);
            if (commandName == "EDIT" || commandName == "ADD")
            {
                List<RightsU_Entities.Platform> lstPlatform = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).OrderBy(o => o.Platform_Name).ToList();
                if (commandName == "EDIT")
                {
                    var platformCode = objLanguage_Group.Platform_Group_Details.Select(s => s.Platform_Code).ToArray();
                    ViewBag.PlatformList = new MultiSelectList(lstPlatform, "Platform_Code", "Platform_Name", platformCode);
                }
                else
                {
                    ViewBag.LanguageList = new MultiSelectList(lstPlatform, "Platform_Code", "Platform_Name");
                }
            }
            List<RightsU_Entities.Platform_Group> lst = new List<RightsU_Entities.Platform_Group>();
            int RecordCount = 0;
            RecordCount = lstPlatform_Group_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstPlatform_Group_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstPlatform_Group_Searched.OrderBy(o => o.Platform_Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstPlatform_Group_Searched.OrderByDescending(o => o.Platform_Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Platform_Group/_Platform_Group.cshtml", lst);
        }

        public PartialViewResult BindPlatformTreeView(string strPlatform)
        {
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //objPTV.PlatformCodes_Display = strPlatform;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }

        public PartialViewResult BindPlatformTreePopup(int platformGroupCode)
        {
            RightsU_Entities.Platform_Group objPG = new Platform_Group_Service(objLoginEntity.ConnectionStringName).GetById(platformGroupCode);
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string strPlatform = string.Join(",", objPG.Platform_Group_Details.Select(s => s.Platform_Code).ToArray());
            objPTV.PlatformCodes_Display = strPlatform;
            objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            objPTV.Show_Selected = true;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }

        public PartialViewResult PartialPlatform_Group()
        {

            return PartialView("_Add_Movie_Album", new Music_Album());
        }

        public PartialViewResult AddEditPlatform_Group(int Platform_Group_Code)
        {
            objPlatform_Group = new RightsU_Entities.Platform_Group(); ;
            objPlatform_Group_Service = null;

            if (Platform_Group_Code > 0)
                objPlatform_Group = objPlatform_Group_Service.GetById(Platform_Group_Code);

            string strPlatform_Code = string.Join(",", new Platform_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Platform_Group_Code == Platform_Group_Code).ToList().Select(x => Convert.ToString(x.Platform_Code)));

            //   objPlatform_Group.Is_Thetrical = (objPlatform_Group.Is_Thetrical ?? "N");
            List<RightsU_Entities.Platform> lstPlatforms = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Platform_Code).ToList();
            var platformCode = objPlatform_Group.Platform_Group_Details.Select(s => s.Platform_Code).ToArray();
            ViewBag.PlatformList = new MultiSelectList(lstPlatforms, "Platform_Code", "Platform_Name", platformCode);

            ViewBag.strPlatformCode = strPlatform_Code;
            return PartialView("~/Views/Platform_Group/_AddEditPlatform_Group.cshtml", objPlatform_Group);
        }

        public JsonResult CheckRecordLock(int Platform_Group_Code)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Platform_Group_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Platform_Group_Code, GlobalParams.ModuleCodeForPlatformGroup, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public JsonResult ActiveDeactivePlatform_Group(int Platform_Group_Code, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "", Action = Convert.ToString(ActionType.A); // A = "Active";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(Platform_Group_Code, GlobalParams.ModuleCodeForPlatformGroup, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                Platform_Group_Service objService = new Platform_Group_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Platform_Group objPlatform_Group = objService.GetById(Platform_Group_Code);
                objPlatform_Group.Is_Active = doActive;
                objPlatform_Group.Last_Updated_Time = System.DateTime.Now;
                objPlatform_Group.Last_Action_By = objLoginUser.Users_Code;
                objPlatform_Group.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objPlatform_Group, out resultSet);
                if (isValid)
                {
                    lstPlatform_Group.Where(w => w.Platform_Group_Code == Platform_Group_Code).First().Is_Active = doActive;
                    lstPlatform_Group_Searched.Where(w => w.Platform_Group_Code == Platform_Group_Code).First().Is_Active = doActive;
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
                        objPlatform_Group.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objPlatform_Group.Inserted_By));
                        objPlatform_Group.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objPlatform_Group.Last_Action_By));
                        objPlatform_Group.Platform_Group_Details.ToList().ForEach(f => f.Platform_Name = new Platform_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Platform_Code)).Platform_Name);

                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objPlatform_Group);
                        //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForPlatformGroup), Convert.ToInt32(objPlatform_Group.Platform_Group_Code), LogData, Action, objLoginUser.Users_Code);

                        MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                        objAuditLog.moduleCode = GlobalParams.ModuleCodeForPlatformGroup;
                        objAuditLog.intCode = objPlatform_Group.Platform_Group_Code;
                        objAuditLog.logData = LogData;
                        objAuditLog.actionBy = objLoginUser.Login_Name;
                        objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objPlatform_Group.Last_Updated_Time));
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

        public JsonResult SearchPlatform_Group(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstPlatform_Group_Searched = lstPlatform_Group.Where(w => w.Platform_Group_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstPlatform_Group_Searched = lstPlatform_Group;

            var obj = new
            {
                Record_Count = lstPlatform_Group_Searched.Count
            };
            return Json(obj);
        }

        public JsonResult SearchPlatform(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstPlatform_Searched = lstPlatform.Where(w => w.Platform_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstPlatform_Searched = lstPlatform;

            var obj = new
            {
                Record_Count = lstPlatform.Count
            };
            return Json(obj);
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

        private void FetchData()
        {
            lstPlatform_Group_Searched = lstPlatform_Group = new Platform_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
        }

        public ActionResult SavePlatform_Group(FormCollection objFormCollection)
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForPlatformGroup);
            string PlatformCodes = objFormCollection["hdnTVCodes"].ToString();

            int platformGroupCode = Convert.ToInt32(objFormCollection["hdnPlatformCode"]);
            string PlatformGroupName = objFormCollection["txtPlatformGroupName"].ToString().Trim();

            Platform_Group_Service objService = new Platform_Group_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Platform_Group objPlatformGroup = null;
            if (platformGroupCode > 0)
            {
                objPlatformGroup = objService.GetById(platformGroupCode);
                objPlatformGroup.EntityState = State.Modified;
            }
            else
            {
                objPlatformGroup = new RightsU_Entities.Platform_Group();
                objPlatformGroup.EntityState = State.Added;
                objPlatformGroup.Inserted_On = DateTime.Now;
                objPlatformGroup.Inserted_By = objLoginUser.Users_Code;
            }
            objPlatformGroup.Last_Updated_Time = System.DateTime.Now;
            objPlatformGroup.Last_Action_By = objLoginUser.Users_Code;
            objPlatformGroup.Is_Active = "Y";
            objPlatformGroup.Platform_Group_Name = PlatformGroupName;

            dynamic resultSet;
            string status = "S", message = "Record {ACTION} successfully", Action = Convert.ToString(ActionType.C); // C = "Create";
            ICollection<RightsU_Entities.Platform_Group_Details> BuisnessUnitList = new HashSet<RightsU_Entities.Platform_Group_Details>();
            if (PlatformCodes != null)
            {
                var split = PlatformCodes.Split(',');

                foreach (var strPlatformCode in split)
                {
                    if (strPlatformCode != "0")
                    {
                        RightsU_Entities.Platform_Group_Details objTR = new Platform_Group_Details();
                        objTR.EntityState = State.Added;
                        objTR.Platform_Code = Convert.ToInt32(strPlatformCode);
                        objTR.Platform_Group_Code = platformGroupCode;
                        BuisnessUnitList.Add(objTR);
                    }
                }
            }
            RightsU_Entities.Platform_Group_Details objTR1 = new Platform_Group_Details();


            #region --- SecurityGroupRel List ---

            IEqualityComparer<Platform_Group_Details> comparerTalentRole = new LambdaComparer<Platform_Group_Details>((x, y) => x.Platform_Code == y.Platform_Code && x.EntityState != State.Deleted);
            var Deleted_SecurityGroupRel = new List<Platform_Group_Details>();
            var Updated_SecurityGroupRel = new List<Platform_Group_Details>();
            var Added_SecurityGroupRel = CompareLists<Platform_Group_Details>(BuisnessUnitList.ToList<Platform_Group_Details>(), objPlatformGroup.Platform_Group_Details.ToList<Platform_Group_Details>(), comparerTalentRole, ref Deleted_SecurityGroupRel, ref Updated_SecurityGroupRel);
            Added_SecurityGroupRel.ToList<Platform_Group_Details>().ForEach(t => objPlatformGroup.Platform_Group_Details.Add(t));
            Deleted_SecurityGroupRel.ToList<Platform_Group_Details>().ForEach(t => t.EntityState = State.Deleted);
            #endregion


            bool isValid = objService.Save(objPlatformGroup, out resultSet);
            if (isValid)
            {
                status = "S";
                if (platformGroupCode > 0)
                {
                    message = objMessageKey.Recordupdatedsuccessfully;
                    Action = Convert.ToString(ActionType.U); // U = "Update";
                }                    
                else
                {
                    message = objMessageKey.RecordAddedSuccessfully;
                }
                
                ViewBag.Alert = message;
                int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                FetchData();

                try
                {
                    objPlatformGroup.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objPlatformGroup.Inserted_By));
                    objPlatformGroup.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objPlatformGroup.Last_Action_By));
                    objPlatformGroup.Platform_Group_Details.ToList().ForEach(f => f.Platform_Name = new Platform_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Platform_Code)).Platform_Name);

                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objPlatformGroup);
                    //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForPlatformGroup), Convert.ToInt32(objPlatformGroup.Platform_Group_Code), LogData, Action, objLoginUser.Users_Code);

                    MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                    objAuditLog.moduleCode = GlobalParams.ModuleCodeForPlatformGroup;
                    objAuditLog.intCode = objPlatformGroup.Platform_Group_Code;
                    objAuditLog.logData = LogData;
                    objAuditLog.actionBy = objLoginUser.Login_Name;
                    objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objPlatformGroup.Last_Updated_Time));
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

            var obj = new
            {
                Record_Count = lstPlatform_Group_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForPlatformGroup), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();
            return rights;
        }

        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForPlatformGroup);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForPlatformGroup.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            lstPlatform_Group_Searched = lstPlatform_Group = new Platform_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View(lstPlatform_Group_Searched);

        }

    }
}
