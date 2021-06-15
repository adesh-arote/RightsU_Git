//using RightsU_BLL;
//using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;
using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.Entity;

namespace RightsU_Plus.Controllers
{
    public class LanguageController : BaseController
    {
        private readonly Language_Services objLanguageService = new Language_Services();
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();

        private List<RightsU_Dapper.Entity.Language> lstLanguage
        {
            get
            {
                if (Session["lstLanguage"] == null)
                    Session["lstLanguage"] = new List<RightsU_Dapper.Entity.Language>();
                return (List<RightsU_Dapper.Entity.Language>)Session["lstLanguage"];
            }
            set { Session["lstLanguage"] = value; }
        }

        private List<RightsU_Dapper.Entity.Language> lstLanguage_Searched
        {
            get
            {
                if (Session["lstLanguage_Searched"] == null)
                    Session["lstLanguage_Searched"] = new List<RightsU_Dapper.Entity.Language>();
                return (List<RightsU_Dapper.Entity.Language>)Session["lstLanguage_Searched"];
            }
            set { Session["lstLanguage_Searched"] = value; }
        }

        public ViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForLanguage);
            string moduleCode = GlobalParams.ModuleCodeForLanguage.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            //lstLanguage_Searched = lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(s => s.Last_Updated_Time).ToList();
            lstLanguage_Searched = lstLanguage = objLanguageService.GetAll().OrderByDescending(s => s.Last_Updated_Time).ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Language/Index.cshtml");
        }

        public PartialViewResult BindLanguageList(int pageNo, int recordPerPage, int Language_Code, string commandName, string sortType)
        {
            ViewBag.Language_Code = Language_Code;
            ViewBag.CommandName = commandName;
            List<RightsU_Dapper.Entity.Language> lst = new List<RightsU_Dapper.Entity.Language>();
            int RecordCount = 0;
            RecordCount = lstLanguage_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstLanguage_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstLanguage_Searched.OrderBy(o => o.Language_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstLanguage_Searched.OrderByDescending(o => o.Language_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Language/_Language.cshtml", lst);
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
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }

        public JsonResult SearchLanguage(string searchText)
        {

            if (!string.IsNullOrEmpty(searchText))
            {
                lstLanguage_Searched = lstLanguage.Where(w => w.Language_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstLanguage_Searched = lstLanguage;

            var obj = new
            {
                Record_Count = lstLanguage_Searched.Count
            };
            return Json(obj);
        }

        //private void FetchData()
        //{
        //    lstLanguage_Searched = lstLanguage = new Language_Service().SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
        //}
        public JsonResult CheckRecordLock(int Language_Code)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Language_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Language_Code, GlobalParams.ModuleCodeForLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public JsonResult EditLanguage(int Language_Code)
        {

            string status = "S", message = "Record {ACTION} successfully";
            //Language_Service objService = new Language_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Language objTalent = objLanguageService.GetByID(Language_Code);

            TempData["Action"] = "EditTalent";
            TempData["idTalent"] = objTalent.Language_Code;

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult ActiveDeactiveLanguage(int Language_Code, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(Language_Code, GlobalParams.ModuleCodeForLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Language_Service objService = new Language_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Language objLanguage = objLanguageService.GetByID(Language_Code);
                objLanguage.Is_Active = doActive;
                //objLanguage.EntityState = State.Modified;
                dynamic resultSet;
                objLanguageService.UpdateEntity(objLanguage);
                bool isValid = true;// objService.Save(objLanguage, out resultSet);
                if (isValid)
                {
                    lstLanguage.Where(w => w.Language_Code == Language_Code).First().Is_Active = doActive;
                    lstLanguage_Searched.Where(w => w.Language_Code == Language_Code).First().Is_Active = doActive;
                }
                else
                {
                    status = "E";
                   // message = "Cound not {ACTION} record";
                    message = "";
                }
                objCommonUtil.Release_Record(RLCode, objLoginEntity.ConnectionStringName);
                if (doActive == "Y")
                    message = objMessageKey.Recordactivatedsuccessfully;
                //message = message.Replace("{ACTION}", "Activated");
                else
                    message = objMessageKey.Recorddeactivatedsuccessfully;
                    //message = message.Replace("{ACTION}", "Deactivated");

            }
            else
            {
                status = "E";
                //message = "Cound not {ACTION} record";
                message = strMessage;
            }


            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult SaveLanguage(int Language_Code, string Language_Name, int Record_Code)
        {
            string status = "S", message = "Record {ACTION} successfully";
            // Language_Service objService = new Language_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Language objGenre = null;

            if (Language_Code > 0)
            {
                objGenre = objLanguageService.GetByID(Language_Code);
                //objGenre.EntityState = State.Modified;
            }
            else
            {
                objGenre = new RightsU_Dapper.Entity.Language();
                //objGenre.EntityState = State.Added;
                objGenre.Inserted_On = DateTime.Now;
                objGenre.Inserted_By = objLoginUser.Users_Code;
            }

            objGenre.Last_Updated_Time = DateTime.Now;
            objGenre.Last_Action_By = objLoginUser.Users_Code;
            objGenre.Is_Active = "Y";
            objGenre.Language_Name = Language_Name;
            string resultSet;
            bool isDuplicate = objLanguageService.Validate(objGenre, out resultSet);
            if (isDuplicate)
            {
                if (Language_Code > 0)
                {
                    objLanguageService.UpdateEntity(objGenre);
                }
                else
                {
                    objLanguageService.AddEntity(objGenre);
                }
                if (Language_Code > 0)
                     message = objMessageKey.Recordupdatedsuccessfully;
                    //message = message.Replace("{ACTION}", "updated");    
                else
                    message = objMessageKey.Recordsavedsuccessfully;
            }
            else
            {
                status = "";
                message = resultSet;
            }
            bool isValid = true;// objService.Save(objGenre, out resultSet);

            if (isValid)
            {
                lstLanguage_Searched = lstLanguage = objLanguageService.GetAll().OrderByDescending(x => x.Last_Updated_Time).ToList();
            }
            else
            {
                status = "E";
                message = "";
            }
            int recordLockingCode = Convert.ToInt32(Record_Code);
            CommonUtil objCommonUtil = new CommonUtil();
            objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
            //if (Language_Code > 0)
            //    if (status == "E")
            //        message = objMessageKey.Languagealreadyexists;
            //    else
            //        message = objMessageKey.Recordupdatedsuccessfully;
            ////message = message.Replace("{ACTION}", "updated");
            //else
            //    if (status == "E")
            //        message = objMessageKey.Languagealreadyexists;
            //    else
            //        message = objMessageKey.Recordsavedsuccessfully;
                //message = message.Replace("{ACTION}", "saved");

            var obj = new
            {
                RecordCount = lstLanguage_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}
