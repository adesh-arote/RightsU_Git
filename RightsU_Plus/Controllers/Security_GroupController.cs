using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using System.Web.Script.Serialization;
using UTOFrameWork.FrameworkClasses;
using Newtonsoft.Json;

namespace RightsU_Plus.Controllers
{
    public class Security_GroupController : BaseController
    {
        //
        // GET: /Security_Group/
        private List<RightsU_Entities.Security_Group> lstSecurity_Group
        {
            get
            {
                if (Session["lstSecurity_Group"] == null)
                    Session["lstSecurity_Group"] = new List<RightsU_Entities.Security_Group>();
                return (List<RightsU_Entities.Security_Group>)Session["lstSecurity_Group"];
            }
            set { Session["lstSecurity_Group"] = value; }
        }

        private List<RightsU_Entities.Security_Group> lstSecurity_Group_Searched
        {
            get
            {
                if (Session["lstSecurity_Group_Searched"] == null)
                    Session["lstSecurity_Group_Searched"] = new List<RightsU_Entities.Security_Group>();
                return (List<RightsU_Entities.Security_Group>)Session["lstSecurity_Group_Searched"];
            }
            set { Session["lstSecurity_Group_Searched"] = value; }
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

        private RightsU_Entities.Security_Group objSecurity_Group
        {
            get
            {
                if (Session["objSecurity_Group"] == null)
                    Session["objSecurity_Group"] = new RightsU_Entities.Security_Group();
                return (RightsU_Entities.Security_Group)Session["objSecurity_Group"];
            }
            set { Session["objSecurity_Group"] = value; }
        }

        private Security_Group_Service objSecurity_Group_Service
        {
            get
            {
                if (Session["objSecurity_Group_Service"] == null)
                    Session["objSecurity_Group_Service"] = new Security_Group_Service(objLoginEntity.ConnectionStringName);
                return (Security_Group_Service)Session["objSecurity_Group_Service"];
            }
            set { Session["objSecurity_Group_Service"] = value; }
        }

        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForSecurityGr);
            ModuleCode = GlobalParams.ModuleCodeForSecurityGr.ToString();

            return View("~/Views/Security_Group/Index.cshtml");        
        }

        public PartialViewResult BindSecurity_GroupList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Entities.Security_Group> lst = new List<RightsU_Entities.Security_Group>();
            int RecordCount = 0;
            ViewBag.UserModuleRights = GetUserModuleRights();
            RecordCount = lstSecurity_Group_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstSecurity_Group_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstSecurity_Group_Searched.OrderBy(o => o.Security_Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstSecurity_Group_Searched.OrderByDescending(o => o.Security_Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            return PartialView("~/Views/Security_Group/_SecurityGroupList.cshtml", lst);
        }

        public PartialViewResult BindPartialPages(string key, string SecurityGroupCode)
        {
            if (key == "LIST")
            {
                ViewBag.Code = ModuleCode;
                ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
                List<SelectListItem> lstSort = new List<SelectListItem>();
                lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
                ViewBag.SortType = lstSort;
                lstSecurity_Group_Searched = lstSecurity_Group = new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
                ViewBag.RightRuleCode = "";
                ViewBag.Action = "";
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/Security_Group/_SecurityGroup.cshtml", lstSecurity_Group_Searched);
            }
            else
            {
                Security_Tree_View objST = new Security_Tree_View(objLoginEntity.ConnectionStringName);  
                objST.SecurityCodes_Selected = SecurityGroupCode.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                ViewBag.TV_Platform = objST.PopulateTreeNode("Y");
                ViewBag.TreeId = "Rights_Security";
                ViewBag.TreeValueId = "hdnTVCodes";
                return PartialView("_TV_Platform");
            }   
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
        #endregion

        public JsonResult SearchSecurity_Group(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstSecurity_Group_Searched = lstSecurity_Group.Where(w => w.Security_Group_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstSecurity_Group_Searched = lstSecurity_Group;

            var obj = new
            {
                Record_Count = lstSecurity_Group_Searched.Count
            };
            return Json(obj);
        }

         public PartialViewResult AddEditSecurity_Group(int Security_Group_Code)
        {
            List<Security_Group_Rel> lstSecurity_Group_Rel = new List<Security_Group_Rel>();
            if (Security_Group_Code == 0)
            {
                TempData["Action"] = "Add";
                objSecurity_Group = null;
            }
            else
            {

                objSecurity_Group = objSecurity_Group_Service.GetById(Security_Group_Code);
                TempData["Action"] = "Edit";

            }
            string strModule_right_Code = string.Join(",", new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Security_Group_Code == Security_Group_Code).ToList().Select(x => Convert.ToString(x.System_Module_Rights_Code)));
            ViewBag.strRightModuleCode = strModule_right_Code;
            objSecurity_Group_Service = null;
            return PartialView("~/Views/Security_Group/_AddEditSecurityGroup.cshtml", objSecurity_Group);
        }

        public JsonResult SaveSecurity_Group(FormCollection objFormCollection)
        {
            string ModuleRight = objFormCollection["hdnTVCodes"].ToString();
            string Securityname = objFormCollection["txtSecurityGroupName"].ToString().Trim();
             int SecurityGroupCode = Convert.ToInt32(objFormCollection["hdnSecurityCode"].ToString());

            Security_Group_Service objService = new Security_Group_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Security_Group objSecurity_Group = new RightsU_Entities.Security_Group();
            
            if (SecurityGroupCode > 0)
                objSecurity_Group = objSecurity_Group_Service.GetById(SecurityGroupCode);

            objSecurity_Group.Security_Group_Name = Securityname;
            // objSecurity_Group.
            objSecurity_Group.Is_Active = "Y";

            if (SecurityGroupCode > 0)
            {
                objSecurity_Group.EntityState = State.Modified;                
            }
            else
            {
                objSecurity_Group.EntityState = State.Added;
                objSecurity_Group.Inserted_By = objLoginUser.Users_Code;
                objSecurity_Group.Inserted_On = System.DateTime.Now;
            }
            objSecurity_Group.Last_Updated_Time = System.DateTime.Now;
            objSecurity_Group.Last_Action_By = objLoginUser.Users_Code;

            Security_Group_Rel_Service objSecurity_Group_Rel_Service = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName);


            List<System_Module_Right> lstSystemModuleRight = new List<System_Module_Right>();
            System_Module_Right_Service objSystem_Module_Right_Service = new System_Module_Right_Service(objLoginEntity.ConnectionStringName);
            lstSystemModuleRight = new System_Module_Right_Service(objLoginEntity.ConnectionStringName).SearchFor(p => true).ToList();

            var splitModule = ModuleRight.Split(',').Where(x => x.All(char.IsNumber)).ToList();

            ///////////////////////////////////////////////////////

            #region --- SecurityGroupRel List ---
            ICollection<Security_Group_Rel> SecurityRelList = new HashSet<Security_Group_Rel>();
            if (splitModule != null)
            {
                foreach (var item in splitModule)
                {
                    if (item != 0.ToString())
                    {
                        RightsU_Entities.Security_Group_Rel objSecurity_Group_Rel = new RightsU_Entities.Security_Group_Rel();
                        objSecurity_Group_Rel.Security_Group_Code = objSecurity_Group.Security_Group_Code;
                        objSecurity_Group_Rel.System_Module_Rights_Code = Convert.ToInt32(item);
                        objSecurity_Group_Rel.EntityState = State.Added;
                        SecurityRelList.Add(objSecurity_Group_Rel);
                    }
                }
            }
            IEqualityComparer<Security_Group_Rel> comparerTalentRole = new LambdaComparer<Security_Group_Rel>((x, y) => x.System_Module_Rights_Code == y.System_Module_Rights_Code && x.EntityState != State.Deleted);
            var Deleted_SecurityGroupRel = new List<Security_Group_Rel>();
            var Updated_SecurityGroupRel = new List<Security_Group_Rel>();
            var Added_SecurityGroupRel = CompareLists<Security_Group_Rel>(SecurityRelList.ToList<Security_Group_Rel>(), objSecurity_Group.Security_Group_Rel.ToList<Security_Group_Rel>(), comparerTalentRole, ref Deleted_SecurityGroupRel, ref Updated_SecurityGroupRel);
            Added_SecurityGroupRel.ToList<Security_Group_Rel>().ForEach(t => objSecurity_Group.Security_Group_Rel.Add(t));
            Deleted_SecurityGroupRel.ToList<Security_Group_Rel>().ForEach(t => t.EntityState = State.Deleted);
            #endregion

            dynamic resultSet;
            string status = "S", message = "Record {ACTION} successfully", Action = Convert.ToString(ActionType.C); // C = "Create";
            bool isValid = objSecurity_Group_Service.Save(objSecurity_Group, out resultSet);
            if (isValid)
            {
                status = "S";
                if(SecurityGroupCode > 0)
                {
                    Action = Convert.ToString(ActionType.U); // U = "Update";
                    message = objMessageKey.Recordupdatedsuccessfully;
                }                   
                else
                {
                    message = objMessageKey.RecordAddedSuccessfully;
                }
                
                FetchData();
                int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                //if(recordLockingCode > 0)
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);

                try
                {
                    objSecurity_Group.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objSecurity_Group.Inserted_By));
                    objSecurity_Group.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objSecurity_Group.Last_Action_By));
                    objSecurity_Group.Security_Group_Rel.ToList().ForEach(f => 
                    {
                        f.System_Module_Name = new System_Module_Right_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.System_Module_Rights_Code)).System_Module.Module_Name;
                        f.System_Right_Name = new System_Module_Right_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.System_Module_Rights_Code)).System_Right.Right_Name;
                    });

                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objSecurity_Group);
                    //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForSecurityGr), Convert.ToInt32(objSecurity_Group.Security_Group_Code), LogData, Action, objLoginUser.Users_Code);

                    MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                    objAuditLog.moduleCode = GlobalParams.ModuleCodeForSecurityGr;
                    objAuditLog.intCode = objSecurity_Group.Security_Group_Code;
                    objAuditLog.logData = LogData;
                    objAuditLog.actionBy = objLoginUser.Login_Name;
                    objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objSecurity_Group.Last_Updated_Time));
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
                Status = status,
                Message = message
            };        
            return Json(obj);
        }

        public JsonResult ActiveDeactiveSecurityGroup(int SecurityGroupCode, string doActive)
        {
             string status = "S", message = "Record {ACTION} successfully", strMessage = "", Action = Convert.ToString(ActionType.A); // A = "Active";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(SecurityGroupCode, GlobalParams.ModuleCodeForSecurityGr, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                Security_Group_Service objService = new Security_Group_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Security_Group objSecurity_Group = objService.GetById(SecurityGroupCode);
                objSecurity_Group.Is_Active = doActive;
                objSecurity_Group.Last_Action_By = objLoginUser.Users_Code;
                objSecurity_Group.Last_Updated_Time = System.DateTime.Now;
                objSecurity_Group.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objSecurity_Group, out resultSet);
                if (isValid)
                {
                    lstSecurity_Group.Where(w => w.Security_Group_Code == SecurityGroupCode).First().Is_Active = doActive;
                    lstSecurity_Group_Searched.Where(w => w.Security_Group_Code == SecurityGroupCode).First().Is_Active = doActive;
                }
                else
                {
                    status = "E";
                    message = "Cound not {ACTION} record";
                }
                if (doActive == "Y")
                {
                    message = objMessageKey.Recordactivatedsuccessfully;
                    //message = message.Replace("{ACTION}", "Activated");
                }
                else
                {
                    message = objMessageKey.Recorddeactivatedsuccessfully;
                    //message = message.Replace("{ACTION}", "Deactivated");
                    Action = Convert.ToString(ActionType.D); // D = "Deactive";
                }

                if (isValid)
                {
                    try
                    {
                        objSecurity_Group.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objSecurity_Group.Inserted_By));
                        objSecurity_Group.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objSecurity_Group.Last_Action_By));
                        objSecurity_Group.Security_Group_Rel.ToList().ForEach(f =>
                        {
                            f.System_Module_Name = new System_Module_Right_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.System_Module_Rights_Code)).System_Module.Module_Name;
                            f.System_Right_Name = new System_Module_Right_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.System_Module_Rights_Code)).System_Right.Right_Name;
                        });

                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objSecurity_Group);
                        //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForSecurityGr), Convert.ToInt32(objSecurity_Group.Security_Group_Code), LogData, Action, objLoginUser.Users_Code);

                        MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                        objAuditLog.moduleCode = GlobalParams.ModuleCodeForSecurityGr;
                        objAuditLog.intCode = objSecurity_Group.Security_Group_Code;
                        objAuditLog.logData = LogData;
                        objAuditLog.actionBy = objLoginUser.Login_Name;
                        objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objSecurity_Group.Last_Updated_Time));
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

        public JsonResult CheckRecordLock(int SecurityGroupCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (SecurityGroupCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(SecurityGroupCode, GlobalParams.ModuleCodeForSecurityGr, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

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
        private void FetchData()
        {
            lstSecurity_Group_Searched = lstSecurity_Group = new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

    }
}