using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
//using RightsU_BLL;
//using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;
namespace RightsU_Plus.Controllers
{
    public class System_ParameterController : BaseController
    {
        private readonly System_Parameter_New_Service objSystem_Parameter_New_Service = new System_Parameter_New_Service();
        private readonly USP_Service objProcedureService = new USP_Service();
        #region --Properties--
        private List<RightsU_Dapper.Entity.System_Parameter_New> lstSystem_Parameter
        {
            get
            {
                if (Session["lstSystem_Parameter"] == null)
                    Session["lstSystem_Parameter"] = new List<RightsU_Dapper.Entity.System_Parameter_New>();
                return (List<RightsU_Dapper.Entity.System_Parameter_New>)Session["lstSystem_Parameter"];
            }
            set { Session["lstSystem_Parameter"] = value; }
        }

        private List<RightsU_Dapper.Entity.System_Parameter_New> lstSystem_Parameter_Searched
        {
            get
            {
                if (Session["lstSystem_Parameter_Searched"] == null)
                    Session["lstSystem_Parameter_Searched"] = new List<RightsU_Dapper.Entity.System_Parameter_New>();
                return (List<RightsU_Dapper.Entity.System_Parameter_New>)Session["lstSystem_Parameter_Searched"];
            }
            set { Session["lstSystem_Parameter_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForSystemParameter);
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            string moduleCode = GlobalParams.ModuleCodeForSystemParameter.ToString();
            ViewBag.Code = moduleCode;
            lstSystem_Parameter_Searched = lstSystem_Parameter = (List<RightsU_Dapper.Entity.System_Parameter_New>)objSystem_Parameter_New_Service.GetList();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/System_Parameter/Index.cshtml");
        }
        public PartialViewResult BindSystem_ParameterList(int pageNo, int recordPerPage, int id, string commandName)
        {
            ViewBag.Id = id;
            ViewBag.CommandName = commandName;
            List<RightsU_Dapper.Entity.System_Parameter_New> lst = new List<RightsU_Dapper.Entity.System_Parameter_New>();
            int RecordCount = 0;
            RecordCount = lstSystem_Parameter_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstSystem_Parameter_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            return PartialView("~/Views/System_Parameter/_SystemParameterList.cshtml", lst);
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
        #endregion
        public JsonResult CheckRecordLock(int id, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (id > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(id, GlobalParams.ModuleCodeForSystemParameter, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SearchSystem_Parameter(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstSystem_Parameter_Searched = lstSystem_Parameter.Where(w => w.Parameter_Name.ToUpper().Contains(searchText.ToUpper().Trim())).ToList();
            }
            else
                lstSystem_Parameter_Searched = lstSystem_Parameter;

            var obj = new
            {
                Record_Count = lstSystem_Parameter_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult SaveSystem_Parameter(int id, string paramValue, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (id > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

           // System_Parameter_New_Service objService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.System_Parameter_New objSystemParameter = null;

            if (id > 0)
            {
                objSystemParameter = objSystem_Parameter_New_Service.GetCategoryByID(id);
                //objSystemParameter.EntityState = State.Modified;
            }
            else
            {
                objSystemParameter = new RightsU_Dapper.Entity.System_Parameter_New();
                //objSystemParameter.EntityState = State.Added;
                objSystemParameter.Inserted_On = DateTime.Now;
                objSystemParameter.Inserted_By = objLoginUser.Users_Code;
            }
            objSystemParameter.Last_Updated_Time = DateTime.Now;
            objSystemParameter.Last_Action_By = objLoginUser.Users_Code;
            objSystemParameter.Parameter_Value = paramValue.Trim();
            dynamic resultSet;
            if (id > 0)
            {
                objSystem_Parameter_New_Service.UpdateCategory(objSystemParameter);
            }
            //else
            //{

            //}
            // bool isValid = objService.Save(objSystemParameter, out resultSet);
            bool isValid = true;

            if (isValid)
            {
                lstSystem_Parameter_Searched = lstSystem_Parameter = objSystem_Parameter_New_Service.GetList().OrderByDescending(x => x.Last_Updated_Time).ToList();
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
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        private string GetUserModuleRights()
        {
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForSystemParameter), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string rights = "";
            if (lstRights != null)
                rights = lstRights;
            return rights;
        }
    }
}
