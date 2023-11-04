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
    public class Deal_DescriptionController : BaseController
    {
        #region --Properties--

        private List<RightsU_Entities.Deal_Description> lstDealDesc
        {
            get
            {
                if (Session["lstDealDesc"] == null)
                    Session["lstDealDesc"] = new List<RightsU_Entities.Deal_Description>();
                return (List<RightsU_Entities.Deal_Description>)Session["lstDealDesc"];
            }
            set { Session["lstDealDesc"] = value; }
        }

        private List<RightsU_Entities.Deal_Description> lstDealDesc_Searched
        {
            get
            {
                if (Session["lstDealDesc_Searched"] == null)
                    Session["lstDealDesc_Searched"] = new List<RightsU_Entities.Deal_Description>();
                return (List<RightsU_Entities.Deal_Description>)Session["lstDealDesc_Searched"];
            }
            set { Session["lstDealDesc_Searched"] = value; }
        }

        #endregion
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForDealDescription);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForDealDescription.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstDealDesc_Searched = lstDealDesc = new Deal_Description_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Deal_Description/Index.cshtml");
        }

        public PartialViewResult BindDealDescList(int pageNo, int recordPerPage, int DealDescsCode, string commandName, string sortType)
        {
            ViewBag.DealDescs_Code = DealDescsCode;
            ViewBag.CommandName = commandName;
            List<RightsU_Entities.Deal_Description> lst = new List<RightsU_Entities.Deal_Description>();
            int RecordCount = 0;
            RecordCount = lstDealDesc_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                //if (sortType == "T")
                //    lst = lstDealDesc_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //else if (sortType == "NA")
                //    lst = lstDealDesc_Searched.OrderBy(o => o.DealDescs_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //else
                    lst = lstDealDesc_Searched.OrderByDescending(o => o.Deal_Desc_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Deal_Description/_DealDescsList.cshtml", lst);
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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForDealDescription), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        #endregion

        public JsonResult CheckRecordLock(int DealDescsCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (DealDescsCode > 0)
            {
                isLocked = DBUtil.Lock_Record(DealDescsCode, GlobalParams.ModuleCodeForDealDescription, objLoginUser.Users_Code, out RLCode, out strMessage);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public JsonResult SearchDealDesc(string searchText)
        {
            Deal_Description_Service objService = new Deal_Description_Service(objLoginEntity.ConnectionStringName);
            if (!string.IsNullOrEmpty(searchText))
            {
                lstDealDesc_Searched = lstDealDesc.Where(w => w.Deal_Desc_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstDealDesc_Searched = lstDealDesc;


            var obj = new
            {
                Record_Count = lstDealDesc_Searched.Count
            };
            return Json(obj);
        }

        public JsonResult ActiveDeactiveDealDesc(int DealDescs_Code, string doActive)
        {
            string status = "S", message = "", strMessage = "", Action = "";
            int RLCode = 0;

            bool isLocked = DBUtil.Lock_Record(DealDescs_Code, GlobalParams.ModuleCodeForDealDescription, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {
                Deal_Description_Service objService = new Deal_Description_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Deal_Description objDealDesc = objService.GetById(DealDescs_Code);
                objDealDesc.Is_Active = doActive;
                objDealDesc.EntityState = State.Modified;
                dynamic resultSet;

                bool isValid = objService.Save(objDealDesc, out resultSet);
                if (isValid)
                {
                    lstDealDesc.Where(w => w.Deal_Desc_Code == DealDescs_Code).First().Is_Active = doActive;
                    lstDealDesc_Searched.Where(w => w.Deal_Desc_Code == DealDescs_Code).First().Is_Active = doActive;
                    if (doActive == "Y")
                    {
                        Action = "A"; // A = "Activate";
                        message = objMessageKey.Recordactivatedsuccessfully;
                    }
                    else
                    {
                        Action = "DA"; // DA = "Deactivate";
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                    }

                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objDealDesc);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForDealDescription, objDealDesc.Deal_Desc_Code, LogData, Action, objLoginUser.Users_Code);
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

        public JsonResult SaveDealDesc(int DealDescsCode, string DealDescsName,string Type, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully, Action = "C"; // C = "Create"; 
            if (DealDescsCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            Deal_Description_Service objService = new Deal_Description_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Deal_Description objDealDesc = null;

            if (DealDescsCode > 0)
            {
                objDealDesc = objService.GetById(DealDescsCode);
                objDealDesc.EntityState = State.Modified;
                Action = "U"; // U = "Update"; 
            }
            else
            {
                objDealDesc = new RightsU_Entities.Deal_Description();
                objDealDesc.EntityState = State.Added;
                //objDealDesc.Inserted_On = DateTime.Now;
                //objDealDesc.Inserted_By = objLoginUser.Users_Code;
            }

            //objDealDesc.Last_Updated_Time = DateTime.Now;
            //objDealDesc.Last_Action_By = objLoginUser.Users_Code;
            objDealDesc.Is_Active = "Y";
            objDealDesc.Deal_Desc_Name = DealDescsName;
            objDealDesc.Type = Type;
            dynamic resultSet;
            bool isValid = objService.Save(objDealDesc, out resultSet);

            if (isValid)
            {                
                lstDealDesc_Searched = lstDealDesc = objService.SearchFor(s => true).OrderByDescending(x => x.Deal_Desc_Code).ToList();

                try
                {
                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objDealDesc);
                    bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForDealDescription, objDealDesc.Deal_Desc_Code, LogData, Action, objLoginUser.Users_Code);
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
                RecordCount = lstDealDesc_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}


