using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_Dapper.Entity;
//using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Collections;
using RightsU_Dapper.BLL.Services;

namespace RightsU_Plus.Controllers
{
    public class AssignWorkflowController : BaseController
    {
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();
        private readonly Workflow_Module_Service objWorkflowModuleService = new Workflow_Module_Service();
        private readonly Workflow_Service objWorkflowService = new Workflow_Service();
        private readonly System_Module_Service objSystemModuleService = new System_Module_Service();
        private readonly User_Service objUserService = new User_Service();
        private readonly Security_Group_Service objSecurityGroupService = new Security_Group_Service();
        private readonly Business_Unit_Service objBusinessUnitService = new Business_Unit_Service();
        private readonly Workflow_Role_Service objWorkflowRoleService = new Workflow_Role_Service();
        private readonly Workflow_Module_Role_Service objWorkflowModuleRoleService = new Workflow_Module_Role_Service();



        #region --- Properties ---
        private List<RightsU_Dapper.Entity.Workflow> lstWorkflow
        {
            get
            {
                if (Session["lstWorkflow"] == null)
                    Session["lstWorkflow"] = new List<RightsU_Dapper.Entity.Workflow>();
                return (List<RightsU_Dapper.Entity.Workflow>)Session["lstWorkflow"];
            }
            set { Session["lstWorkflow"] = value; }
        }
        private List<RightsU_Dapper.Entity.Workflow> lstWorkflow_Searched
        {
            get
            {
                if (Session["lstWorkflow_Searched"] == null)
                    Session["lstWorkflow_Searched"] = new List<RightsU_Dapper.Entity.Workflow>();
                return (List<RightsU_Dapper.Entity.Workflow>)Session["lstWorkflow_Searched"];
            }
            set { Session["lstWorkflow_Searched"] = value; }
        }

        private List<RightsU_Dapper.Entity.Business_Unit> lstBusiness_Unit
        {
            get
            {
                if (Session["lstBusiness_Unit"] == null)
                    Session["lstBusiness_Unit"] = new List<RightsU_Dapper.Entity.Business_Unit>();
                return (List<RightsU_Dapper.Entity.Business_Unit>)Session["lstBusiness_Unit"];
            }
            set { Session["lstBusiness_Unit"] = value; }
        }
        private List<RightsU_Dapper.Entity.Business_Unit> lstBusiness_Unit_Searched
        {
            get
            {
                if (Session["lstBusiness_Unit_Searched"] == null)
                    Session["lstBusiness_Unit_Searched"] = new List<RightsU_Dapper.Entity.Business_Unit>();
                return (List<RightsU_Dapper.Entity.Business_Unit>)Session["lstBusiness_Unit_Searched"];
            }
            set { Session["lstBusiness_Unit_Searched"] = value; }
        }

        private List<RightsU_Dapper.Entity.Workflow_Role> lstWorkflow_Role
        {
            get
            {
                if (Session["lstWorkflow_Role"] == null)
                    Session["lstWorkflow_Role"] = new List<RightsU_Dapper.Entity.Workflow_Role>();
                return (List<RightsU_Dapper.Entity.Workflow_Role>)Session["lstWorkflow_Role"];
            }
            set { Session["lstWorkflow_Role"] = value; }
        }
        private List<RightsU_Dapper.Entity.Workflow_Role> lstWorkflow_Role_Searched
        {
            get
            {
                if (Session["lstWorkflow_Role_Searched"] == null)
                    Session["lstWorkflow_Role_Searched"] = new List<RightsU_Dapper.Entity.Workflow_Role>();
                return (List<RightsU_Dapper.Entity.Workflow_Role>)Session["lstWorkflow_Role_Searched"];
            }
            set { Session["lstWorkflow_Role_Searched"] = value; }
        }

        private List<RightsU_Dapper.Entity.Security_Group> lstSecurity_Group
        {
            get
            {
                if (Session["lstSecurity_Group"] == null)
                    Session["lstSecurity_Group"] = new List<RightsU_Dapper.Entity.Security_Group>();
                return (List<RightsU_Dapper.Entity.Security_Group>)Session["lstSecurity_Group"];
            }
            set { Session["lstSecurity_Group"] = value; }
        }
        private List<RightsU_Dapper.Entity.Security_Group> lstSecurity_Group_Searched
        {
            get
            {
                if (Session["lstSecurity_Group_Searched"] == null)
                    Session["lstSecurity_Group_Searched"] = new List<RightsU_Dapper.Entity.Security_Group>();
                return (List<RightsU_Dapper.Entity.Security_Group>)Session["lstSecurity_Group_Searched"];
            }
            set { Session["lstSecurity_Group_Searched"] = value; }
        }

        private List<RightsU_Dapper.Entity.System_Module> lstSystem_Module
        {
            get
            {
                if (Session["lstSystem_Module"] == null)
                    Session["lstSystem_Module"] = new List<RightsU_Dapper.Entity.System_Module>();
                return (List<RightsU_Dapper.Entity.System_Module>)Session["lstSystem_Module"];
            }
            set { Session["lstSystem_Module"] = value; }
        }
        private List<RightsU_Dapper.Entity.System_Module> lstSystem_Module_Searched
        {
            get
            {
                if (Session["lstSystem_Module_Searched"] == null)
                    Session["lstSystem_Module_Searched"] = new List<RightsU_Dapper.Entity.System_Module>();
                return (List<RightsU_Dapper.Entity.System_Module>)Session["lstSystem_Module_Searched"];
            }
            set { Session["lstSystem_Module_Searched"] = value; }
        }

        private List<RightsU_Dapper.Entity.User> lstUser
        {
            get
            {
                if (Session["lstUser"] == null)
                    Session["lstUser"] = new List<RightsU_Dapper.Entity.User>();
                return (List<RightsU_Dapper.Entity.User>)Session["lstUser"];
            }
            set { Session["lstUser"] = value; }
        }
        private List<RightsU_Dapper.Entity.User> lstUser_Searched
        {
            get
            {
                if (Session["lstlstUser_Searched"] == null)
                    Session["lstlstUser_Searched"] = new List<RightsU_Dapper.Entity.User>();
                return (List<RightsU_Dapper.Entity.User>)Session["lstlstUser_Searched"];
            }
            set { Session["lstlstUser_Searched"] = value; }
        }

        private List<RightsU_Dapper.Entity.Workflow_Module> lstWorkflow_Module
        {
            get
            {
                if (Session["lstWorkflow_Module"] == null)
                    Session["lstWorkflow_Module"] = new List<RightsU_Dapper.Entity.Workflow_Module>();
                return (List<RightsU_Dapper.Entity.Workflow_Module>)Session["lstWorkflow_Module"];
            }
            set { Session["lstWorkflow_Module"] = value; }
        }
        private List<RightsU_Dapper.Entity.Workflow_Module> lstWorkflow_Module_Searched
        {
            get
            {
                if (Session["lstWorkflow_Module_Searched"] == null)
                    Session["lstWorkflow_Module_Searched"] = new List<RightsU_Dapper.Entity.Workflow_Module>();
                return (List<RightsU_Dapper.Entity.Workflow_Module>)Session["lstWorkflow_Module_Searched"];
            }
            set { Session["lstWorkflow_Module_Searched"] = value; }
        }

        private List<RightsU_Dapper.Entity.Workflow_Module_Role> lstWorkflow_Module_Role
        {
            get
            {
                if (Session["lstWorkflow_Module_Role"] == null)
                    Session["lstWorkflow_Module_Role"] = new List<RightsU_Dapper.Entity.Workflow_Module_Role>();
                return (List<RightsU_Dapper.Entity.Workflow_Module_Role>)Session["lstWorkflow_Module_Role"];
            }
            set { Session["lstWorkflow_Module_Role"] = value; }
        }
        private List<RightsU_Dapper.Entity.Workflow_Module_Role> lstWorkflow_Module_Role_Searched
        {
            get
            {
                if (Session["lstWorkflow_Module_Role_Searched"] == null)
                    Session["lstWorkflow_Module_Role_Searched"] = new List<RightsU_Dapper.Entity.Workflow_Module_Role>();
                return (List<RightsU_Dapper.Entity.Workflow_Module_Role>)Session["lstWorkflow_Module_Role_Searched"];
            }
            set { Session["lstWorkflow_Module_Role_Searched"] = value; }
        }
        #endregion

        #region --- List And Binding ---

        public ViewResult Index()
        {
            lstSystem_Module_Searched = lstSystem_Module = objSystemModuleService.GetAll().Where(x => x.Can_Workflow_Assign == "Y").ToList();
            lstUser_Searched = lstUser = objUserService.GetAll().ToList();
            lstSecurity_Group_Searched = lstSecurity_Group = objSecurityGroupService.GetList().ToList();
            lstWorkflow_Role_Searched = lstWorkflow_Role = objWorkflowRoleService.GetAll().ToList();
            lstWorkflow_Searched = lstWorkflow = objWorkflowService.GetAll().ToList();
            lstBusiness_Unit_Searched = lstBusiness_Unit = objBusinessUnitService.GetAll().ToList();
            lstWorkflow_Module_Role_Searched = lstWorkflow_Module_Role = objWorkflowModuleRoleService.GetAll().ToList();
            lstWorkflow_Module_Searched = lstWorkflow_Module = objWorkflowModuleService.GetAll().Where(x => x.Is_Active == "Y").ToList();
            return View("~/Views/AssignWorkflow/Index.cshtml");
        }
        public PartialViewResult BindWorkflowList(int pageNo, int recordPerPage)
        {
            List<RightsU_Dapper.Entity.Workflow_Module> lst = new List<RightsU_Dapper.Entity.Workflow_Module>();
            int RecordCount = 0;
            RecordCount = lstWorkflow_Module_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstWorkflow_Module_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/AssignWorkflow/_AssignWorkflowList.cshtml", lst);
        }
        public PartialViewResult BindWorkflowSG(int WFCode, int BUCode,string Status)
        {
            List<RightsU_Dapper.Entity.Workflow_Role> lst = new List<RightsU_Dapper.Entity.Workflow_Role>();
            int RecordCount = 0;
            RecordCount = lstWorkflow_Role_Searched.Where(x => x.Workflow_Code == WFCode || x.Workflow_Code == 0).ToList().Count();
            if (RecordCount > 0)
            {
                lst = lstWorkflow_Role_Searched.Where(x => x.Workflow_Code == WFCode || x.Workflow_Code == 0).ToList();
            }
            ViewData["SecurityGroup"] = lstSecurity_Group_Searched;
            ViewData["User"] = lstUser_Searched;
            ViewBag.UserModuleRights = GetUserModuleRights();
            ViewBag.BUCode = BUCode;
            ViewBag.Status = Status;
            return PartialView("~/Views/AssignWorkflow/_Add_Edit_AWSecurityGroup.cshtml", lst);
        }
        public void UpdateList(int WFRCode, int ReminderDays)
        {
            short reminderDays = (short)ReminderDays;
            lstWorkflow_Role_Searched.Where(x => x.Workflow_Role_Code == WFRCode).FirstOrDefault().Reminder_Days= reminderDays;
        }
        public PartialViewResult BindPartialPages(string key, int WorkflowModuleCode)
        {
            TempData["View"] = "";
            if (key == "LIST")
            {
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/AssignWorkflow/_AssignWorkflow.cshtml");
            }
            else if (key == "VIEW")
            {
                Session["WorkflowCode_AddEdit"] = WorkflowModuleCode;
                if (WorkflowModuleCode > 0)
                {
                    TempData["View"] = "V";
                    ViewData["Status"] = "V";
                   // Workflow_Module_Service objService = new Workflow_Module_Service(objLoginEntity.ConnectionStringName);
                    RightsU_Dapper.Entity.Workflow_Module objWorkflow = objWorkflowModuleService.GetByID(WorkflowModuleCode);
                    //ViewData["Reminder_Days"] = (new Workflow_Module_Role_Service()).SearchFor(x => x.Workflow_Module_Code == objWorkflow.Workflow_Module_Code).FirstOrDefault().Reminder_Days;
                    // TempData["BusinessUnit"] = new SelectList(lstBusiness_Unit_Searched.Where(x => x.Is_Active == "Y"), "Business_Unit_Code", "Business_Unit_Name", objWorkflow.Business_Unit_Code);
                    ViewData["MyWorkflow"] = objWorkflow;
                    ViewBag.BUCode = objWorkflow.Business_Unit_Code;
                }
                return PartialView("~/Views/AssignWorkflow/_AddEditAssignWorkFlow.cshtml");
            }
            else if (key == "VIEWHistory")
            {
                Session["WorkflowCode_AddEdit"] = WorkflowModuleCode;
                if (WorkflowModuleCode > 0)
                {

                    //Workflow_Module_Service objService = new Workflow_Module_Service(objLoginEntity.ConnectionStringName);
                    RightsU_Dapper.Entity.Workflow_Module objWorkflow = objWorkflowModuleService.GetByID(WorkflowModuleCode);

                    List<RightsU_Dapper.Entity.Workflow_Module> lstWorkflow_Module = new List<RightsU_Dapper.Entity.Workflow_Module>();

                    lstWorkflow_Module = objWorkflowModuleService.GetAll().Where(x => x.Business_Unit_Code == objWorkflow.Business_Unit_Code && x.Module_Code == objWorkflow.Module_Code).Where(x => x.Is_Active == "N").ToList();
                    ViewBag.HistoryModuleName = objWorkflow.System_Module.Module_Name;
                    ViewData["MyWorkflow"] = lstWorkflow_Module;
                }
                return PartialView("~/Views/AssignWorkflow/_HistoryWorkflowList.cshtml");
            }
            else
            {
                Session["WorkflowCode_AddEdit"] = WorkflowModuleCode;
                if (WorkflowModuleCode > 0)
                {
                    ViewData["Status"] = "U";
                    //Workflow_Module_Service objService = new Workflow_Module_Service(objLoginEntity.ConnectionStringName);
                    RightsU_Dapper.Entity.Workflow_Module objWorkflow = objWorkflowModuleService.GetByID(WorkflowModuleCode);
                    //ViewData["Reminder_Days"] = (new Workflow_Module_Role_Service()).SearchFor(x => x.Workflow_Module_Code == objWorkflow.Workflow_Module_Code).FirstOrDefault().Reminder_Days;
                    ViewData["MyWorkflow"] = objWorkflow;
                }
                else
                {
                    Session["WorkflowCode_AddEdit"] = WorkflowModuleCode;
                    ViewData["Status"] = "A";
                    ViewData["MyWorkflow"] = "";
                    ViewData["Reminder_Days"] = "";
                    return PartialView("~/Views/AssignWorkflow/_AddEditAssignWorkFlow.cshtml");
                }
                return PartialView("~/Views/AssignWorkflow/_AddEditAssignWorkFlow.cshtml");
            }
        }

        #endregion

        #region  --- Other Methods ---

        public JsonResult CheckRecordLock(int WorkflowModuleCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (WorkflowModuleCode > 0)
            {
                isLocked = DBUtil.Lock_Record(WorkflowModuleCode, GlobalParams.ModuleCodeForAssignWorkflow, objLoginUser.Users_Code, out RLCode, out strMessage);
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
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForAssignWorkflow), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;
            return rights;
        }
        public JsonResult SearchWorkflow(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstWorkflow_Module_Searched = lstWorkflow_Module.Where(w => w.Workflow.Workflow_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstWorkflow_Module_Searched = lstWorkflow_Module;

            var obj = new
            {
                Record_Count = lstWorkflow_Module_Searched.Count
            };
            return Json(obj);
        }

        #endregion

        #region

        public JsonResult BindDDL()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            SelectList lstModuleName = new SelectList(lstSystem_Module_Searched
               .Select(i => new { Display_Value = i.Module_Code, Display_Text = i.Module_Name }), "Display_Value", "Display_Text");
            objJson.Add("lstModuleName", lstModuleName);
            return Json(objJson);
        }
        public JsonResult BindBusinesUnit(int MCode)
        {
            var exceptionList = lstWorkflow_Module_Searched.Where(x => x.Module_Code == MCode).Select(x => x.Business_Unit_Code).ToList();
            var query = lstBusiness_Unit_Searched.Where(x => !exceptionList.Contains(x.Business_Unit_Code));
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            SelectList lstBusinessUnit = new SelectList(query
             .Select(i => new { Display_Value = i.Business_Unit_Code, Display_Text = i.Business_Unit_Name }), "Display_Value", "Display_Text");
            objJson.Add("lstBusinessUnit", lstBusinessUnit);

            return Json(objJson);
        }
        public JsonResult BindWorkflow(int BUCode, int MNCode)
        {

            string a = "select  Workflow_Code from Workflow_Module where Is_Active = 'Y' and Workflow_Code not in (select Workflow_Code from Workflow_Module where Module_Code = 30 and Business_Unit_Code = 2 and Is_Active = 'Y')";

            //var exceptionList = lstWorkflow_Module_Searched.Where(x => x.Module_Code == MNCode && x.Business_Unit_Code == BUCode && x.Is_Active == "Y").Select(x => x.Workflow_Code).ToList();
            //var query = lstWorkflow_Searched.Where(x => !exceptionList.Contains(x.Workflow_Code));

            var query = objWorkflowService.GetAll().Where(x => x.Business_Unit_Code == BUCode).ToList();

            Dictionary<string, object> objJson = new Dictionary<string, object>();

            SelectList lstWorkflowName = new SelectList(query
           .Select(i => new { Display_Value = i.Workflow_Code, Display_Text = i.Workflow_Name }), "Display_Value", "Display_Text");

            objJson.Add("lstWorkflowName", lstWorkflowName);

            return Json(objJson);
        }
        public JsonResult BindWorkflowEdit(int AACode)
        {
            List<RightsU_Dapper.Entity.Workflow> lst_New_WorkFlow = new List<RightsU_Dapper.Entity.Workflow>();
            //Workflow_Module_Service objWorkflowService = new Workflow_Module_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Workflow_Module objWorkflowModule = new RightsU_Dapper.Entity.Workflow_Module();
            objWorkflowModule = objWorkflowModuleService.GetByID(AACode);

            int MNCode = Convert.ToInt32(objWorkflowModule.Module_Code);
            int BUCode = Convert.ToInt32(objWorkflowModule.Business_Unit_Code);
            string a = "select Workflow_Code from Workflow_Module where Workflow_Code not in (select Workflow_Code " +
            "from Workflow_Module where Module_Code = 30 and Business_Unit_Code = 2)";


            lst_New_WorkFlow = lstWorkflow_Searched.Where(x => x.Workflow_Code != objWorkflowModule.Workflow_Code).ToList();

            var exceptionList = lstWorkflow_Module_Searched.Where(x => x.Module_Code == MNCode && x.Business_Unit_Code == BUCode && x.Is_Active == "Y").Select(x => x.Workflow_Code).ToList();


            //var query = lst_New_WorkFlow.Where(x => !exceptionList.Contains(x.Workflow_Code));

            var query = objWorkflowService.GetAll().Where(x => x.Business_Unit_Code == BUCode && !exceptionList.Contains(x.Workflow_Code)).ToList();


            Dictionary<string, object> objJson = new Dictionary<string, object>();

            SelectList lstWorkflowName_Edit = new SelectList(query
           .Select(i => new { Display_Value = i.Workflow_Code, Display_Text = i.Workflow_Name }), "Display_Value", "Display_Text");
            objJson.Add("lstWorkflowName_Edit", lstWorkflowName_Edit);

            return Json(objJson);
        }

        #endregion

        public JsonResult SaveWorkflowModule(FormCollection objFormCollection)
        {

           // Workflow_Module_Service objWorkflowService = new Workflow_Module_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Workflow_Module objWorkflowModule = new RightsU_Dapper.Entity.Workflow_Module();

            #region --FormCollection
            int WorkflowModuleCode = 0;
            int New_Workflow_Code = 0;
            int Module_Code = 0;
            int Workflow_Code = 0;
            int Business_Unit_Code = 0;
            DateTime ESD = System.DateTime.Now;
            DateTime New_ESD = System.DateTime.Now;
            if (objFormCollection["AACode"] != null)
            {
                if (Convert.ToInt32(objFormCollection["AACode"]) != 0)
                {
                    WorkflowModuleCode = Convert.ToInt32(objFormCollection["AACode"]);
                    New_Workflow_Code = Convert.ToInt32(objFormCollection["New_Workflow_Code"]);
                    New_ESD = Convert.ToDateTime(objFormCollection["New_ESD"]);
                }
            }
            if (WorkflowModuleCode == 0)
            {
                Module_Code = Convert.ToInt32(objFormCollection["Module_Code"]);
                Business_Unit_Code = Convert.ToInt32(objFormCollection["Businessunit_Code"]);
                Workflow_Code = Convert.ToInt32(objFormCollection["Workflow_Code"]);
                ESD = Convert.ToDateTime(objFormCollection["ESD"]);
            }

            //if (objFormCollection["Reminder_Days"] != null) {
            //    objFormCollection["Reminder_Days"]='0~0'
            //}
            //var lstReminder_Days = objFormCollection["Reminder_Days"];


            #endregion
            string status = "S", message = "Record {ACTION} successfully";
            if (WorkflowModuleCode > 0)
            {
                //Workflow_Module_Service objWorkflowService_Update = new Workflow_Module_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Workflow_Module objWM_Update = new RightsU_Dapper.Entity.Workflow_Module();
                objWM_Update = objWorkflowModuleService.GetByID(WorkflowModuleCode);
                objWM_Update.Is_Active = "N";
                objWM_Update.Last_Updated_Time = System.DateTime.Now;
                objWM_Update.System_End_Date = New_ESD.AddDays(-1);
                //objWM_Update.EntityState = State.Modified;
                objWM_Update.Last_Action_By = objLoginUser.Users_Code;

                dynamic resultSet_Upt;
                objWorkflowModuleService.UpdateEntity(objWM_Update);
                bool isValid = true;// objWorkflowService_Update.Save(objWM_Update, out resultSet_Upt);
                if (isValid)
                {
                    lstWorkflow_Module_Searched = lstWorkflow_Module = objWorkflowModuleService.GetAll().Where(x => x.Is_Active == "Y").ToList();
                }


                #region   -- -Update Workflow

                objWorkflowModule.Business_Unit_Code = objWM_Update.Business_Unit_Code;
                objWorkflowModule.Module_Code = objWM_Update.Module_Code;
                objWorkflowModule.Workflow_Code = New_Workflow_Code;
                objWorkflowModule.Effective_Start_Date = New_ESD;
                objWorkflowModule.Ideal_Process_Days = 0;
                objWorkflowModule.Is_Active = "Y";
                //objWorkflowModule.EntityState = State.Added;


                List<RightsU_Dapper.Entity.Workflow_Role> temp_lstWorkflow_Role = new List<RightsU_Dapper.Entity.Workflow_Role>();
                temp_lstWorkflow_Role = lstWorkflow_Role_Searched.Where(x => x.Workflow_Code == New_Workflow_Code).ToList();

                if (temp_lstWorkflow_Role.Count > 0)
                {
                    foreach (var item in temp_lstWorkflow_Role)
                    {
                        RightsU_Dapper.Entity.Workflow_Module_Role obj_WMR = new RightsU_Dapper.Entity.Workflow_Module_Role();
                        obj_WMR.Group_Level = item.Group_Level;
                        obj_WMR.Group_Code = item.Group_Code;
                        obj_WMR.Workflow_Role_Code = item.Workflow_Role_Code;
                        obj_WMR.Reminder_Days = item.Reminder_Days==null?0:item.Reminder_Days;
                       // obj_WMR.EntityState = State.Added;
                        objWorkflowModule.Workflow_Module_Role.Add(obj_WMR);
                    }
                }

                #endregion
            }
            else
            {
                #region   -- -save Workflow
                objWorkflowModule.Business_Unit_Code = Business_Unit_Code;
                objWorkflowModule.Module_Code = Module_Code;
                objWorkflowModule.Workflow_Code = Workflow_Code;
                objWorkflowModule.Effective_Start_Date = ESD;
                objWorkflowModule.Ideal_Process_Days = 0;
                objWorkflowModule.Is_Active = "Y";
                objWorkflowModule.Last_Action_By = objLoginUser.Users_Code;
                //objWorkflowModule.EntityState = State.Added;

                List<RightsU_Dapper.Entity.Workflow_Role> temp_lstWorkflow_Role = new List<RightsU_Dapper.Entity.Workflow_Role>();
                temp_lstWorkflow_Role = lstWorkflow_Role_Searched.Where(x => x.Workflow_Code == Workflow_Code).ToList();
                if (temp_lstWorkflow_Role.Count > 0)
                {
                    foreach (var item in temp_lstWorkflow_Role)
                    {
                        RightsU_Dapper.Entity.Workflow_Module_Role obj_WMR = new RightsU_Dapper.Entity.Workflow_Module_Role();
                        obj_WMR.Group_Level = item.Group_Level;
                        obj_WMR.Group_Code = item.Group_Code;
                        obj_WMR.Workflow_Role_Code = item.Workflow_Role_Code;
                        obj_WMR.Reminder_Days = 0;
                       // obj_WMR.EntityState = State.Added;
                        objWorkflowModule.Workflow_Module_Role.Add(obj_WMR);
                    }
                }
                #endregion
            }
            objWorkflowModule.Last_Action_By = objLoginUser.Users_Code;
            objWorkflowModule.Last_Updated_Time = System.DateTime.Now;
            dynamic resultSet;
            bool isDuplicate = true;// objWorkflowService.Validate(objWorkflowModule, out resultSet);
            if (isDuplicate)
            {
                objWorkflowModuleService.AddEntity(objWorkflowModule);
                bool isValid = true;// objWorkflowService.Save(objWorkflowModule, out resultSet);
                if (isValid)
                {
                    lstWorkflow_Module_Searched = lstWorkflow_Module = objWorkflowModuleService.GetAll().Where(x => x.Is_Active == "Y").ToList();
                    status = "S";

                    int recordLockingCode = Convert.ToInt32(objFormCollection["Record_Code"]);
                    DBUtil.Release_Record(recordLockingCode);

                    if (WorkflowModuleCode > 0)
                        message = message.Replace("{ACTION}", "updated");
                    else
                        message = message.Replace("{ACTION}", "added");
                }
                else
                {
                    status = "E";
                    message = "";
                }
            }
            else
            {
                status = "E";
                message = "";
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }


    }
}
