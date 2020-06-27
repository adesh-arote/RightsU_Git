using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Document_TypeController : BaseController
    {
        #region --Properties--
        private List<RightsU_Entities.Document_Type> lstDocument_Type
        {
            get
            {
                if (Session["lstDocument_Type"] == null)
                    Session["lstDocument_Type"] = new List<RightsU_Entities.Document_Type>();
                return (List<RightsU_Entities.Document_Type>)Session["lstDocument_Type"];
            }
            set { Session["lstDocument_Type"] = value; }
        }

        private List<RightsU_Entities.Document_Type> lstDocument_Type_Searched
        {
            get
            {
                if (Session["lstDocument_Type_Searched"] == null)
                    Session["lstDocument_Type_Searched"] = new List<RightsU_Entities.Document_Type>();
                return (List<RightsU_Entities.Document_Type>)Session["lstDocument_Type_Searched"];
            }
            set { Session["lstDocument_Type_Searched"] = value; }
        }
        #endregion

        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForDocumentType);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForDocumentType.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            lstDocument_Type_Searched = lstDocument_Type = new Document_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Document_Type/Index.cshtml");
        }
        public PartialViewResult BindDocument_TypeList(int pageNo, int recordPerPage, int documentTypeCode, string commandName,string sortType)
        {
            ViewBag.DocumentTypeCode = documentTypeCode;
            ViewBag.CommandName = commandName;
            List<RightsU_Entities.Document_Type> lst = new List<RightsU_Entities.Document_Type>();
            int RecordCount = 0;
            RecordCount = lstDocument_Type_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstDocument_Type_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstDocument_Type_Searched.OrderBy(o => o.Document_Type_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstDocument_Type_Searched.OrderByDescending(o => o.Document_Type_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Document_Type/_Document_TypeList.cshtml", lst);
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
        public JsonResult CheckRecordLock(int documentTypeCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (documentTypeCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(documentTypeCode, GlobalParams.ModuleCodeForDocumentType, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SearchDocument_Type(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstDocument_Type_Searched = lstDocument_Type.Where(w => w.Document_Type_Name.ToUpper().Contains(searchText.ToUpper().Trim())).ToList();
            }
            else
                lstDocument_Type_Searched = lstDocument_Type;

            var obj = new
            {
                Record_Count = lstDocument_Type_Searched.Count
            };
            return Json(obj);
        }
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForDocumentType), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        public JsonResult ActiveDeactiveDocument_Type(int documentTypeCode, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(documentTypeCode, GlobalParams.ModuleCodeForDocumentType, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                Document_Type_Service objService = new Document_Type_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Document_Type objDocumentType = objService.GetById(documentTypeCode);
                objDocumentType.Is_Active = doActive;
                objDocumentType.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objDocumentType, out resultSet);
                if (isValid)
                {
                    lstDocument_Type.Where(w => w.Document_Type_Code == documentTypeCode).First().Is_Active = doActive;
                    lstDocument_Type_Searched.Where(w => w.Document_Type_Code == documentTypeCode).First().Is_Active = doActive;
                    if (doActive == "Y")
                        message = objMessageKey.Recordactivatedsuccessfully;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                }
                else
                {
                    status = "E";
                    message = resultSet;
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
        public JsonResult SaveDocument_Type(int documentTypeCode, string documentTypeName, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (documentTypeCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            Document_Type_Service objService = new Document_Type_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Document_Type objDocumentType = null;

            if (documentTypeCode > 0)
            {
                objDocumentType = objService.GetById(documentTypeCode);
                objDocumentType.EntityState = State.Modified;
            }
            else
            {
                objDocumentType = new RightsU_Entities.Document_Type();
                objDocumentType.EntityState = State.Added;
                objDocumentType.Inserted_On = DateTime.Now;
                objDocumentType.Inserted_By = objLoginUser.Users_Code;
            }
            objDocumentType.Last_Updated_Time = DateTime.Now;
            objDocumentType.Last_Action_By = objLoginUser.Users_Code;
            objDocumentType.Is_Active = "Y";
            objDocumentType.Document_Type_Name = documentTypeName.Trim();
            dynamic resultSet;
            bool isValid = objService.Save(objDocumentType, out resultSet);

            if (isValid)
            {
                lstDocument_Type_Searched = lstDocument_Type = objService.SearchFor(s => true).OrderByDescending(x => x.Last_Updated_Time).ToList();
            }
            else
            {
                status = "E";
                message = resultSet;
            }
            int recordLockingCode = Convert.ToInt32(Record_Code);
            CommonUtil objCommonUtil = new CommonUtil();
            objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
            var obj = new
            {
                RecordCount = lstDocument_Type_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}

