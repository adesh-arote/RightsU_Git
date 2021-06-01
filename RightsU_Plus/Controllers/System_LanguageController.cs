//using RightsU_BLL;
//using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.Entity;
//using RightsU_Dapper.Entity.StoredProcedure_Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class System_LanguageController : BaseController
    {
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();
        private readonly System_Module_Message_Service objSystemModuleMessageService = new System_Module_Message_Service();
        private readonly System_Module_Service objSystemModuleService = new System_Module_Service();
        private readonly USP_GetSystem_Language_Message_ByModule_Service objProcedureService = new USP_GetSystem_Language_Message_ByModule_Service();
        private readonly System_Language_Service objSystemLanguageService = new System_Language_Service();


        //
        // GET: /System_Language/

        #region Properties
        private List<RightsU_Dapper.Entity.System_Language> lstSystem_Language
        {
            get
            {
                if (Session["lstSystem_Language"] == null)
                    Session["lstSystem_Language"] = new List<RightsU_Dapper.Entity.System_Language>();
                return (List<RightsU_Dapper.Entity.System_Language>)Session["lstSystem_Language"];
            }
            set { Session["lstSystem_Language"] = value; }
        }

        private int RecordlockingCode
        {
            get
            {
                if (Session["RecordLockingCode"] == null)
                {
                    Session["RecordLockingCode"] = 0;
                }
                return Convert.ToInt32(Session["RecordLockingCode"]);
            }
            set
            {
                Session["RecordLockingCode"] = value;
            }
        }


        #endregion

        #region Add Edit Methods

        public PartialViewResult AddEdit(int SystemLanguageCode, int RecordLockingCode)
        {
            //ViewBag.GetModules = new SelectList(new System_Module_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Is_Sub_Module == "N").ToList().OrderBy(x => x.Module_Name), "Module_Code", "Module_Name");

           // ViewBag.GetModules = new SelectList(new System_Module_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Is_Sub_Module == "N").ToList().Join(new System_Module_Message_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList(), x => x.Module_Code, y => y.Module_Code, (x, y) => new { x.Module_Code, x.Module_Name }).Distinct().ToList().OrderBy(x => x.Module_Name), "Module_Code", "Module_Name");
            ViewBag.GetModules = new SelectList(objSystemModuleService.GetAll().Where(x => x.Is_Active == "Y" && x.Is_Sub_Module == "N").ToList().Join(objSystemModuleMessageService.GetAll().ToList(), x => x.Module_Code, y => y.Module_Code, (x, y) => new { x.Module_Code, x.Module_Name }).Distinct().ToList().OrderBy(x => x.Module_Name), "Module_Code", "Module_Name");

            ViewBag.GetFormId = new MultiSelectList(GetFormIdList(0), "Form_ID", "Form_ID");
            //System_Language_Service objService = new System_Language_Service(objLoginEntity.ConnectionStringName);
            System_Language objL = objSystemLanguageService.GetByID(SystemLanguageCode);
            ViewBag.LanguageName = objL.Language_Name;
            TempData["SystemLanguageCode"] = SystemLanguageCode;
            RecordlockingCode = RecordLockingCode;
            ViewBag.RecordlockingCode = RecordlockingCode;
            return PartialView("~/Views/System_Language/AddEdit.cshtml");
        }

        public PartialViewResult BindSystem_LanguageList(int moduleCode, string formId)
        {
            int SysLanguageCode = int.Parse(TempData["SystemLanguageCode"].ToString());
            TempData.Keep();
            ViewBag.GetModules = new SelectList(objSystemModuleService.GetAll().Where(x => x.Is_Active == "Y" && x.Is_Sub_Module == "N").ToList().OrderBy(x => x.Module_Name), "Module_Code", "Module_Name", moduleCode);
            ViewBag.GetFormId = new MultiSelectList(objSystemModuleMessageService.GetAll().Select(i => new { Form_ID = i.Form_ID }).Distinct().OrderBy(x => x.Form_ID).ToList(), "Form_ID", "Form_ID", formId);
           // USP_Service service = new USP_Service(objLoginEntity.ConnectionStringName);
            List<USP_GetSystem_Language_Message_ByModule_Result> list = objProcedureService.USP_GetSystem_Language_Message_ByModule(moduleCode, formId, SysLanguageCode).ToList();
            return PartialView("~/Views/System_Language/_Create.cshtml", list);
        }

        [HttpPost]
        public ActionResult Save(System_Language objMVC)
        {
            int SysLanguageCode = int.Parse(TempData["SystemLanguageCode"].ToString());
            objMVC.System_Language_Code = SysLanguageCode;
            string status = "S", message = "Data saved successfully";
            //System_Language_Service objService = new System_Language_Service(objLoginEntity.ConnectionStringName);
            if (objMVC.System_Language_Message.ToList().Count != 0)
            {
                //Update start
                System_Language objSL = objSystemLanguageService.GetByID(objMVC.System_Language_Code);
                objSL.Last_Updated_Time = System.DateTime.Now;
                objSL.Last_Action_By = objLoginUser.Users_Code;
                objSL.System_Language_Message.ToList().ForEach(f =>
                {
                    System_Language_Message objSLM = objMVC.System_Language_Message.
                        Where(w => w.System_Language_Message_Code == f.System_Language_Message_Code).FirstOrDefault();

                    if (objSLM != null)
                    {
                        //f.EntityState = State.Modified;
                        f.Message_Desc = objSLM.Message_Desc;
                        f.Last_Updated_Time = DateTime.Now;
                        f.Last_Action_By = objLoginUser.Users_Code;
                    }
                });
                //Update End

                //Insert Start
                objMVC.System_Language_Message.Where(w => w.System_Language_Message_Code == 0).ToList().ForEach(f =>
                {
                    System_Language_Message objSLM = new System_Language_Message();
                    objSLM.System_Language_Code = objMVC.System_Language_Code;
                    objSLM.System_Module_Message_Code = f.System_Module_Message_Code;
                    objSLM.Message_Desc = f.Message_Desc;
                    //objSLM.EntityState = State.Added;
                    objSLM.Inserted_On = DateTime.Now;
                    objSLM.Inserted_By = objLoginUser.Users_Code;
                    objSLM.Last_Updated_Time = DateTime.Now;
                    objSLM.Last_Action_By = objLoginUser.Users_Code;
                    objSL.System_Language_Message.Add(objSLM);
                });
                //Insert End

                dynamic resultSet;
                //objSL.EntityState = State.Modified;
                try
                {
                    if(SysLanguageCode > 0)
                    {
                        objSystemLanguageService.UpdateEntity(objSL);
                    }
                    else
                    {
                        objSystemLanguageService.AddEntity(objSL);
                    }
                    CommonUtil objCommonUtil = new CommonUtil();
                    objCommonUtil.Release_Record(RecordlockingCode, objLoginEntity.ConnectionStringName);
                    lstSystem_Language = objSystemLanguageService.GetAll().OrderByDescending(o => o.Last_Updated_Time).ToList();
                }
                catch (Exception e)
                {
                    string a = e.Message;
                    status = "E";
                    message = ("" ?? "Error while saving");
                }
                //if (!objSystemLanguageService.Save(objSL, out resultSet))
                //{
                //    status = "E";
                //    message = (resultSet ?? "Error while saving");
                //}
                //else
                //{
                //    CommonUtil objCommonUtil = new CommonUtil();
                //    objCommonUtil.Release_Record(RecordlockingCode, objLoginEntity.ConnectionStringName);
                //    lstSystem_Language = objSystemLanguageService.GetAll().OrderByDescending(o => o.Last_Updated_Time).ToList();
                //}
            }
            else
            {
                status = "";
                message = "";
            }
            return Json(new
            {
                Status = status,
                Message = message
            });
        }

        public ActionResult BindForm_ByModuleID(int moduleCode)
        {
            return Json(GetFormIdList(moduleCode), JsonRequestBehavior.AllowGet);
        }

        private dynamic GetFormIdList(int moduleCode)
        {  
            dynamic list = objSystemModuleMessageService.GetAll().Where(x => (x.Module_Code ?? 0) == moduleCode)
                   .Select(i => new { Form_ID = (i.Form_ID ?? "Common") }).Distinct().OrderBy(x => x.Form_ID).ToList();

            return list;
        }

        #endregion

        #region List Methods

        public ActionResult Index()
        {
            lstSystem_Language = objSystemLanguageService.GetAll().OrderByDescending(o => o.Last_Updated_Time).ToList();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/System_Language/Index.cshtml");
        }
        private string GetUserModuleRights()
        {
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForSystemLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        public PartialViewResult BindSystemLanguageList(int pageNo, int recordPerPage, string commandName)
        {
            List<RightsU_Dapper.Entity.System_Language> lst = new List<RightsU_Dapper.Entity.System_Language>();
            ViewBag.CommandName = commandName;
            int RecordCount = 0;
            RecordCount = lstSystem_Language.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstSystem_Language.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();

                ViewBag.TotalMessages = objSystemModuleMessageService.GetAll().Count();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/System_Language/_SystemLanguageList.cshtml", lst);
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
        public JsonResult SearchSystemLanguage(string searchText)
        {
            var obj = new
            {
                Record_Count = lstSystem_Language.Count
            };
            return Json(obj);
        }
        public JsonResult CheckRecordLock(int SystemLanguageCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (SystemLanguageCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(SystemLanguageCode, GlobalParams.ModuleCodeForSystemLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SaveSystemLanguage(int SystemLanguageCode, string SystemLanguageName, string Direction, int Record_Code)
        {
            string status = "S", message = "Record saved successfully";

            //System_Language_Service objService = new System_Language_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.System_Language objSystemLanguage = null;

            objSystemLanguage = new RightsU_Dapper.Entity.System_Language();
            //objSystemLanguage.EntityState = State.Added;
            objSystemLanguage.Is_Active = "Y";
            objSystemLanguage.Language_Name = SystemLanguageName.Trim();
            objSystemLanguage.Layout_Direction = Direction;
            objSystemLanguage.Is_Default = "N";
            objSystemLanguage.Inserted_By = objLoginUser.Users_Code;
            objSystemLanguage.Inserted_On = System.DateTime.Now;
            objSystemLanguage.Last_Updated_Time = System.DateTime.Now;
            objSystemLanguage.Last_Action_By = objLoginUser.Users_Code;
            dynamic resultSet;
            objSystemLanguageService.AddEntity(objSystemLanguage);
            bool isValid = true;// objService.Save(objSystemLanguage, out resultSet);
            if (isValid)
            {
                lstSystem_Language = objSystemLanguageService.GetAll().OrderByDescending(x => x.Last_Updated_Time).ToList();
            }
            else
            {
                status = "E";
                message = "";
            }
            int recordLockingCode = Convert.ToInt32(Record_Code);
            CommonUtil objCommonUtil = new CommonUtil();
            objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
            var obj = new
            {
                RecordCount = lstSystem_Language.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        #endregion


    }
}
