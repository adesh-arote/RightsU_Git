using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Collections;
using Newtonsoft.Json;

namespace RightsU_Plus.Controllers
{
    public class ApprovalWorkflowController : BaseController
    {
        #region --- Properties ---

        private List<RightsU_Entities.Workflow> lstWorkflow
        {
            get
            {
                if (Session["lstWorkflow"] == null)
                    Session["lstWorkflow"] = new List<RightsU_Entities.Workflow>();
                return (List<RightsU_Entities.Workflow>)Session["lstWorkflow"];
            }
            set { Session["lstWorkflow"] = value; }
        }

        private List<RightsU_Entities.Workflow> lstWorkflow_Searched
        {
            get
            {
                if (Session["lstWorkflow_Searched"] == null)
                    Session["lstWorkflow_Searched"] = new List<RightsU_Entities.Workflow>();
                return (List<RightsU_Entities.Workflow>)Session["lstWorkflow_Searched"];
            }
            set { Session["lstWorkflow_Searched"] = value; }
        }

        private List<RightsU_Entities.Business_Unit> lstBusiness_Unit
        {
            get
            {
                if (Session["lstBusiness_Unit"] == null)
                    Session["lstBusiness_Unit"] = new List<RightsU_Entities.Business_Unit>();
                return (List<RightsU_Entities.Business_Unit>)Session["lstBusiness_Unit"];
            }
            set { Session["lstBusiness_Unit"] = value; }
        }

        private List<RightsU_Entities.Business_Unit> lstBusiness_Unit_Searched
        {
            get
            {
                if (Session["lstBusiness_Unit_Searched"] == null)
                    Session["lstBusiness_Unit_Searched"] = new List<RightsU_Entities.Business_Unit>();
                return (List<RightsU_Entities.Business_Unit>)Session["lstBusiness_Unit_Searched"];
            }
            set { Session["lstBusiness_Unit_Searched"] = value; }
        }

        private List<RightsU_Entities.Workflow_Role> lstWorkflow_Role
        {
            get
            {
                if (Session["lstWorkflow_Role"] == null)
                    Session["lstWorkflow_Role"] = new List<RightsU_Entities.Workflow_Role>();
                return (List<RightsU_Entities.Workflow_Role>)Session["lstWorkflow_Role"];
            }
            set { Session["lstWorkflow_Role"] = value; }
        }

        private List<RightsU_Entities.Workflow_Role> lstWorkflow_Role_Searched
        {
            get
            {
                if (Session["lstWorkflow_Role_Searched"] == null)
                    Session["lstWorkflow_Role_Searched"] = new List<RightsU_Entities.Workflow_Role>();
                return (List<RightsU_Entities.Workflow_Role>)Session["lstWorkflow_Role_Searched"];
            }
            set { Session["lstWorkflow_Role_Searched"] = value; }
        }

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

        private List<RightsU_Entities.User> lstUser
        {
            get
            {
                if (Session["lstUser"] == null)
                    Session["lstUser"] = new List<RightsU_Entities.User>();
                return (List<RightsU_Entities.User>)Session["lstUser"];
            }
            set { Session["lstUser"] = value; }
        }

        private List<RightsU_Entities.User> lstUser_Searched
        {
            get
            {
                if (Session["lstlstUser_Searched"] == null)
                    Session["lstlstUser_Searched"] = new List<RightsU_Entities.User>();
                return (List<RightsU_Entities.User>)Session["lstlstUser_Searched"];
            }
            set { Session["lstlstUser_Searched"] = value; }
        }

        #endregion

        #region --- List And Binding ---

        public ViewResult Index()
        {
            return View("~/Views/ApprovalWorkflow/Index.cshtml");
        }

        public PartialViewResult BindWorkflowList(int pageNo, int recordPerPage)
        {
            List<RightsU_Entities.Workflow> lst = new List<RightsU_Entities.Workflow>();
            int RecordCount = 0;
            RecordCount = lstWorkflow_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstWorkflow_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/ApprovalWorkflow/_ApprovalWorkflowList.cshtml", lst);
        }

        public PartialViewResult BindWorkflowSG(int WorkflowCode, int BUCode)
        {
            List<RightsU_Entities.Workflow_Role> lst = new List<RightsU_Entities.Workflow_Role>();
            int RecordCount = 0;
            RecordCount = lstWorkflow_Role_Searched.Where(x => x.Workflow_Code == WorkflowCode || x.Workflow_Code == 0).Where(x => x.EntityState != State.Deleted).ToList().Count();
            if (RecordCount > 0)
            {
                lst = lstWorkflow_Role_Searched.Where(x => x.Workflow_Code == WorkflowCode || x.Workflow_Code == 0).Where(x => x.EntityState != State.Deleted).ToList();
            }
            ViewData["SecurityGroup"] = lstSecurity_Group_Searched;
            ViewData["User"] = lstUser_Searched;
            ViewBag.UserModuleRights = GetUserModuleRights();
            ViewBag.BUCode = BUCode;
            return PartialView("~/Views/ApprovalWorkflow/_Add_Edit_AWSecurityGroup.cshtml", lst);
        }

        public PartialViewResult BindPartialPages(string key, int WorkflowCode)
        {
            TempData["View"] = "";
            if (key == "LIST")
            {
                lstUser_Searched = lstUser = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                lstSecurity_Group_Searched = lstSecurity_Group = new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                lstWorkflow_Role_Searched = lstWorkflow_Role = new Workflow_Role_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                lstWorkflow_Searched = lstWorkflow = new Workflow_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                lstBusiness_Unit_Searched = lstBusiness_Unit = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/ApprovalWorkflow/_ApprovalWorkflow.cshtml");
            }
            else if (key == "VIEW")
            {
                Session["WorkflowCode_AddEdit"] = WorkflowCode;
                if (WorkflowCode > 0)
                {
                    TempData["View"] = "V";
                    ViewData["Status"] = "V";
                    Workflow_Service objService = new Workflow_Service(objLoginEntity.ConnectionStringName);
                    RightsU_Entities.Workflow objWorkflow = objService.GetById(WorkflowCode);
                    TempData["BusinessUnit"] = new SelectList(lstBusiness_Unit_Searched.Where(x => x.Is_Active == "Y"), "Business_Unit_Code", "Business_Unit_Name", objWorkflow.Business_Unit_Code);
                    ViewData["MyWorkflow"] = objWorkflow;
                    ViewBag.BUCode = objWorkflow.Business_Unit_Code;
                }
                return PartialView("~/Views/ApprovalWorkflow/_AddEditApprovalWorkFlow.cshtml");
            }
            else
            {
                Session["WorkflowCode_AddEdit"] = WorkflowCode;
                if (WorkflowCode > 0)
                {
                    ViewData["Status"] = "U";
                    Workflow_Service objService = new Workflow_Service(objLoginEntity.ConnectionStringName);
                    RightsU_Entities.Workflow objWorkflow = objService.GetById(WorkflowCode);
                    TempData["BusinessUnit"] = new SelectList(lstBusiness_Unit_Searched.Where(x => x.Is_Active == "Y"), "Business_Unit_Code", "Business_Unit_Name", objWorkflow.Business_Unit_Code);
                    ViewData["MyWorkflow"] = objWorkflow;
                }
                else
                {
                    ViewData["Status"] = "A";
                    ViewData["MyWorkflow"] = "";
                    TempData["BusinessUnit"] = new SelectList(lstBusiness_Unit_Searched.Where(x => x.Is_Active == "Y"), "Business_Unit_Code", "Business_Unit_Name");
                }
                return PartialView("~/Views/ApprovalWorkflow/_AddEditApprovalWorkFlow.cshtml");
            }
        }

        #endregion

        #region  --- Other Methods ---

        public JsonResult CheckRecordLock(int ApprovalWorkflowCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (ApprovalWorkflowCode > 0)
            {
                isLocked = DBUtil.Lock_Record(ApprovalWorkflowCode, GlobalParams.ModuleCodeForApprovalWorkflow, objLoginUser.Users_Code, out RLCode, out strMessage);
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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForApprovalWorkflow), objLoginUser.Security_Group_Code,objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();
            return rights;
        }

        #endregion

        #region --- WorkflowList ---

        public JsonResult SearchWorkflow(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstWorkflow_Searched = lstWorkflow.Where(w => w.Workflow_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstWorkflow_Searched = lstWorkflow;

            var obj = new
            {
                Record_Count = lstWorkflow_Searched.Count
            };
            return Json(obj);
        }

        public JsonResult SearchUser(int SGCode, int BUCode)
        {
            List<Users_Business_Unit> lst_Users_Business_Unit_Service = new List<Users_Business_Unit>();
            lst_Users_Business_Unit_Service = new Users_Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(z => true).Where(x=>x.Users_Code != null).ToList();
            var query = lst_Users_Business_Unit_Service.Where(x => x.User.Security_Group_Code == SGCode && x.Business_Unit_Code == BUCode).Select(s => s.User.Login_Name).ToArray();
            string strRoles = "";
            if (lstUser.Count > 0)
            {
                strRoles = string.Join(", ", lst_Users_Business_Unit_Service.Where(x => x.User.Security_Group_Code == SGCode && x.Business_Unit_Code == BUCode).Select(s => s.User.Login_Name).ToArray());
            }
            var obj = new
            {
                UserList = strRoles
            };
            return Json(obj);
        }

        public JsonResult SaveWorkflow(RightsU_Entities.Workflow objUser_MVC, FormCollection objFormCollection)
        {
            Workflow_Service objWorkflowService = new Workflow_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Workflow objWorkflow = new RightsU_Entities.Workflow();
            #region --FormCollection
            int WorkflowCode = 0;
            string Workflow_Name = objFormCollection["Workflow_Name"].ToString().Trim();
            string Workflow_Remarks = objFormCollection["Workflow_Remarks"].ToString().Trim();
            //    int Business_Unit_Code = Convert.ToInt32(objFormCollection["Business_Unit_Code"]);hdnBUCode
            int Business_Unit_Code = Convert.ToInt32(objFormCollection["hdnBUCode"]);

            if (objFormCollection["Workflow_Code"] != null)
            {
                WorkflowCode = Convert.ToInt32(objFormCollection["Workflow_Code"]);
            }
            #endregion
            string status = "S", message = "Record {ACTION} successfully", Action = Convert.ToString(ActionType.C); // C = "Create";
            if (WorkflowCode > 0)
            {
                #region   -- -Update Workflow
                objWorkflow = objWorkflowService.GetById(WorkflowCode);
                objWorkflow.Workflow_Name = Workflow_Name;
                objWorkflow.Last_Updated_Time = System.DateTime.Now;
                objWorkflow.Remarks = Workflow_Remarks;
                objWorkflow.Business_Unit_Code = Business_Unit_Code;
                objWorkflow.EntityState = State.Modified;
                List<RightsU_Entities.Workflow_Role> temp_lstWorkflow_Role = new List<RightsU_Entities.Workflow_Role>();
                temp_lstWorkflow_Role = lstWorkflow_Role_Searched.Where(x => x.Workflow_Code == 0).ToList();
                if (temp_lstWorkflow_Role.Count > 0)
                {
                    foreach (RightsU_Entities.Workflow_Role item in temp_lstWorkflow_Role)
                    {
                        item.Workflow_Code = WorkflowCode;
                        objWorkflow.Workflow_Role.Add(item);
                    }
                }
                List<RightsU_Entities.Workflow_Role> tempVendorContact = new List<RightsU_Entities.Workflow_Role>();
                tempVendorContact = lstWorkflow_Role_Searched.Where(x => x.Workflow_Code == 0 || x.Workflow_Code == WorkflowCode && x.EntityState != State.Deleted).ToList();
                IEqualityComparer<Workflow_Role> comparerVendor_Contacts = new LambdaComparer<Workflow_Role>((x, y) => x.Workflow_Role_Code == y.Workflow_Role_Code && x.EntityState != State.Deleted);
                var Deleted_Vendor_Contacts = new List<Workflow_Role>();
                var Updated_Vendor_Contacts = new List<Workflow_Role>();
                var Added_Vendor_Contacts = CompareLists<Workflow_Role>(tempVendorContact.ToList<Workflow_Role>(), objWorkflow.Workflow_Role.ToList<Workflow_Role>(), comparerVendor_Contacts, ref Deleted_Vendor_Contacts, ref Updated_Vendor_Contacts);
                // Added_Vendor_Contacts.ToList<Workflow_Role>().ForEach(t => objWorkflow.Workflow_Role.Add(t));
                Deleted_Vendor_Contacts.ToList<Workflow_Role>().ForEach(t => t.EntityState = State.Deleted);
                List<RightsU_Entities.Workflow_Role> Modified_VC = new List<RightsU_Entities.Workflow_Role>();
                Modified_VC = tempVendorContact.Where(x => x.EntityState == State.Modified).ToList();
                foreach (var item in Modified_VC)
                {
                    foreach (var objVendorContact in objWorkflow.Workflow_Role)
                    {
                        if (objVendorContact.Workflow_Role_Code == item.Workflow_Role_Code)
                        {
                            objVendorContact.Group_Code = item.Group_Code;
                            objVendorContact.Workflow_Code = item.Workflow_Code;

                            objVendorContact.EntityState = State.Modified;
                        }
                    }
                }
                objWorkflow.Workflow_Role.Except(Deleted_Vendor_Contacts);
                if (objWorkflow.Workflow_Role.Count > 0)
                {
                    int Counter = 0;
                    foreach (RightsU_Entities.Workflow_Role item in objWorkflow.Workflow_Role.Where(x => x.EntityState != State.Deleted))
                    {
                        Counter = Counter + 1;
                        item.Group_Level = Convert.ToInt16(Counter);
                    }
                }
                #endregion
            }
            else
            {
                #region   -- -save Workflow
                objWorkflow.Workflow_Name = Workflow_Name;
                objWorkflow.Remarks = Workflow_Remarks;
                objWorkflow.Business_Unit_Code = Business_Unit_Code;
                objWorkflow.Workflow_Type = "F";
                objWorkflow.Inserted_By = objLoginUser.Users_Code;
                objWorkflow.Inserted_On = System.DateTime.Now;
                objWorkflow.EntityState = State.Added;

                List<RightsU_Entities.Workflow_Role> temp_lstWorkflow_Role = new List<RightsU_Entities.Workflow_Role>();
                temp_lstWorkflow_Role = lstWorkflow_Role_Searched.Where(x => x.Workflow_Code == 0).ToList();
                if (temp_lstWorkflow_Role.Count > 0)
                {
                    int Counter = 0;
                    foreach (RightsU_Entities.Workflow_Role item in temp_lstWorkflow_Role)
                    {
                        Counter = Counter + 1;
                        item.Group_Level = Convert.ToInt16(Counter);
                        objWorkflow.Workflow_Role.Add(item);
                    }
                }
                #endregion
            }
            objWorkflow.Last_Action_By = objLoginUser.Users_Code;
            objWorkflow.Last_Updated_Time = System.DateTime.Now;
            dynamic resultSet;
            bool isDuplicate = objWorkflowService.Validate(objWorkflow, out resultSet);
            if (isDuplicate)
            {
                bool isValid = objWorkflowService.Save(objWorkflow, out resultSet);
                if (isValid)
                {
                    lstWorkflow_Searched = lstWorkflow = new Workflow_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                    status = "S";

                    int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                    DBUtil.Release_Record(recordLockingCode);


                    if (WorkflowCode > 0)
                    {
                        Action = Convert.ToString(ActionType.U); // U = "Update";
                        message = message.Replace("{ACTION}", "updated");
                    }   
                    else
                    {
                        message = message.Replace("{ACTION}", "added");
                    }

                    try
                    {
                        objWorkflow.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objWorkflow.Inserted_By));
                        objWorkflow.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objWorkflow.Last_Action_By));
                        objWorkflow.Business_Unit_Name = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Business_Unit_Code == objWorkflow.Business_Unit_Code).Select(x => x.Business_Unit_Name).FirstOrDefault();

                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objWorkflow);
                        //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForApprovalWorkflow, objWorkflow.Workflow_Code, LogData, Action, objLoginUser.Users_Code);

                        MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                        objAuditLog.moduleCode = GlobalParams.ModuleCodeForApprovalWorkflow;
                        objAuditLog.intCode = objWorkflow.Workflow_Code;
                        objAuditLog.logData = LogData;
                        objAuditLog.actionBy = objLoginUser.Login_Name;
                        objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objWorkflow.Last_Updated_Time));
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

        public JsonResult DeleteWorkflow(int WorkflowCode)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "", Action = Convert.ToString(ActionType.X); // X = "Delete";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(WorkflowCode, GlobalParams.ModuleCodeForApprovalWorkflow, objLoginUser.Users_Code, out RLCode, out strMessage,objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                // string status = "S", message = "Record {ACTION} successfully";
                Workflow_Service objService = new Workflow_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Workflow objWorkflow = objService.GetById(WorkflowCode);
                objWorkflow.EntityState = State.Deleted;
                if (objWorkflow.Workflow_Role.Count > 0)
                {
                    foreach (RightsU_Entities.Workflow_Role item in objWorkflow.Workflow_Role)
                    {
                        item.EntityState = State.Deleted;
                    }
                }
                dynamic resultSet;
                bool isValid = objService.Save(objWorkflow, out resultSet);
                if (isValid)
                {
                    message = message.Replace("{ACTION}", "Deleted");
                    lstWorkflow_Searched = lstWorkflow = new Workflow_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();

                    try
                    {
                        objWorkflow.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objWorkflow.Inserted_By));
                        objWorkflow.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objWorkflow.Last_Action_By));
                        objWorkflow.Business_Unit_Name = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Business_Unit_Code == objWorkflow.Business_Unit_Code).Select(x => x.Business_Unit_Name).FirstOrDefault();

                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objWorkflow);
                        //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForApprovalWorkflow, objWorkflow.Workflow_Code, LogData, Action, objLoginUser.Users_Code);

                        MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                        objAuditLog.moduleCode = GlobalParams.ModuleCodeForApprovalWorkflow;
                        objAuditLog.intCode = objWorkflow.Workflow_Code;
                        objAuditLog.logData = LogData;
                        objAuditLog.actionBy = objLoginUser.Login_Name;
                        objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objWorkflow.Last_Updated_Time));
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
                    message = "Cound not Delete record";
                }
                objCommonUtil.Release_Record(RLCode,objLoginEntity.ConnectionStringName);
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

        #endregion

        #region --- Workflow Role Crud Method ---

        public JsonResult SaveWorkflowSG(FormCollection objFormCollection)
        {
            int Security_Group_Code = Convert.ToInt32(objFormCollection["Security_Group_Code"]);

            string status = "S", message = "Record Added successfully";

            int WorkflowCode_AddEdit = Convert.ToInt32(Session["WorkflowCode_AddEdit"]);

            RightsU_Entities.Workflow_Role objWorkflow_Role = new RightsU_Entities.Workflow_Role();

            objWorkflow_Role.Group_Code = Security_Group_Code;
            objWorkflow_Role.Workflow_Code = 0;
            objWorkflow_Role.EntityState = State.Added;
            lstWorkflow_Role_Searched.Add(objWorkflow_Role);

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult AddEditWorkflowSG(string dummyGuid, string commandName)
        {
            string status = "S", message = "Record {ACTION} successfully";
            int WorkflowCode_AddEdit = Convert.ToInt32(Session["WorkflowCode_AddEdit"]);
            var lst = lstWorkflow_Role_Searched.Where(x => x.Workflow_Code == WorkflowCode_AddEdit || x.Workflow_Code == 0).Where(x => x.EntityState != State.Deleted).ToList();

            ArrayList arrayList = new ArrayList();
            if (lst.Count > 0)
            {
                foreach (var item in lst)
                {
                    arrayList.Add(item.Group_Code);
                }
            }
            var lstSG = lstSecurity_Group_Searched.Where(x => x.Is_Active == "Y");

            if (commandName == "ADD")
            {
                var a = lstSG.Where(x => !arrayList.Contains(x.Security_Group_Code)).ToList();
                TempData["SecurityGroup"] = new SelectList(a, "Security_Group_Code", "Security_Group_Name");
                TempData["Action"] = "AddWorkFlowSG";
            }
            else if (commandName == "EDIT")
            {

                RightsU_Entities.Workflow_Role objWorkflow_Role = new RightsU_Entities.Workflow_Role();
                objWorkflow_Role = lstWorkflow_Role_Searched.Where(x => x.Dummy_Guid.ToString() == dummyGuid).SingleOrDefault();
                arrayList.Remove(objWorkflow_Role.Group_Code);
                var a = lstSG.Where(x => !arrayList.Contains(x.Security_Group_Code)).ToList();

                TempData["SecurityGroupEdit"] = new SelectList(a, "Security_Group_Code", "Security_Group_Name", objWorkflow_Role.Group_Code);
                TempData["Action"] = "EditWorkFlowSG";
                TempData["idWorkFlowSG"] = objWorkflow_Role.Dummy_Guid;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult UpdateWorkflowSG(FormCollection objFormCollection)
        {
            string str_DummyGuid = objFormCollection["DummyGuid"].ToString();

            int Security_Group_Code_Edit = Convert.ToInt32(objFormCollection["Security_Group_Code_Edit"]);

            string status = "S", message = "Record Updated successfully";

            int WorkflowCode_AddEdit = Convert.ToInt32(Session["WorkflowCode_AddEdit"]);

            RightsU_Entities.Workflow_Role objWorkflow_Role = lstWorkflow_Role_Searched.Where(x => x._Dummy_Guid == str_DummyGuid).SingleOrDefault();
            objWorkflow_Role.Group_Code = Security_Group_Code_Edit;

            if (objWorkflow_Role.Workflow_Code > 0)
            {
                objWorkflow_Role.EntityState = State.Modified;
            }


            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult DeleteWorkflowSG(string dummyGuid)
        {
            string status = "S", message = "Record {ACTION} successfully";
            RightsU_Entities.Workflow_Role objWorkflow_Role = lstWorkflow_Role_Searched.Where(x => x._Dummy_Guid == dummyGuid).SingleOrDefault();
            if (objWorkflow_Role != null)
            {
                if (objWorkflow_Role.Workflow_Code > 0)
                {
                    objWorkflow_Role.EntityState = State.Deleted;
                }
                else
                {
                    lstWorkflow_Role_Searched.Remove(objWorkflow_Role);
                }
                message = message.Replace("{ACTION}", "Deleted");
            }
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
