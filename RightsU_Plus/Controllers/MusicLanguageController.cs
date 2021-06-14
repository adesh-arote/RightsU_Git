//using RightsU_BLL;
//using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class MusicLanguageController : BaseController
    {
        private readonly Music_Language_Service objMusicLanguageService = new Music_Language_Service();
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();


        #region --Properties--
        private List<RightsU_Dapper.Entity.Music_Language> lstMusicLanguage
        {
            get
            {
                if (Session["lstMusicLanguage"] == null)
                    Session["lstMusicLanguage"] = new List<RightsU_Dapper.Entity.Music_Language>();
                return (List<RightsU_Dapper.Entity.Music_Language>)Session["lstMusicLanguage"];
            }
            set { Session["lstMusicLanguage"] = value; }
        }
        private List<RightsU_Dapper.Entity.Music_Language> lstMusicLanguage_Searched
        {
            get
            {
                if (Session["lstMusicLanguage_Searched"] == null)
                    Session["lstMusicLanguage_Searched"] = new List<RightsU_Dapper.Entity.Music_Language>();
                return (List<RightsU_Dapper.Entity.Music_Language>)Session["lstMusicLanguage_Searched"];
            }
            set { Session["lstMusicLanguage_Searched"] = value; }
        }
        #endregion
        public ViewResult Index()
        {
            //string modulecode = Request.QueryString["modulecode"];
            string modulecode = GlobalParams.ModuleCodeForMusicLanguage.ToString();
            ViewBag.Code = modulecode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicLanguage);
            lstMusicLanguage_Searched = lstMusicLanguage = objMusicLanguageService.GetAll().ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/MusicLanguage/Index.cshtml");
        }
        public PartialViewResult BindMusicLanguageList(int pageNo, int recordPerPage, int music_Language_Code, string commandName, string sortType)
        {
            ViewBag.Music_Language_Code = music_Language_Code;
            ViewBag.CommandName = commandName;
            List<RightsU_Dapper.Entity.Music_Language> lst = new List<RightsU_Dapper.Entity.Music_Language>();
            int RecordCount = 0;
            RecordCount = lstMusicLanguage_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstMusicLanguage_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstMusicLanguage_Searched.OrderBy(o => o.Language_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstMusicLanguage_Searched.OrderByDescending(o => o.Language_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/MusicLanguage/_MusicLanguageList.cshtml", lst);
        }
        #region --other Method--
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
        public JsonResult CheckRecordLock(int music_Language_Code, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (music_Language_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(music_Language_Code, GlobalParams.ModuleCodeForMusicLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
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
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForMusicLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        public JsonResult SearchMusicLanguage(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstMusicLanguage_Searched = lstMusicLanguage.Where(w => w.Language_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstMusicLanguage_Searched = lstMusicLanguage;

            var obj = new
            {
                Record_Count = lstMusicLanguage_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult ActiveDeactiveMusicLanguage(int music_Language_Code, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(music_Language_Code, GlobalParams.ModuleCodeForMusicLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Music_Language_Service objService = new Music_Language_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Music_Language objMusicLanguage = objMusicLanguageService.GetByID(music_Language_Code);
                objMusicLanguage.Is_Active = doActive;
               // objMusicLanguage.EntityState = State.Modified;
                dynamic resultSet;
                objMusicLanguageService.AddEntity(objMusicLanguage);
                bool isValid = true;// objMusicLanguageService.AddEntity(objMusicLanguage);

                if (isValid)
                {
                    lstMusicLanguage.Where(w => w.Music_Language_Code == music_Language_Code).First().Is_Active = doActive;
                    lstMusicLanguage_Searched.Where(w => w.Music_Language_Code == music_Language_Code).First().Is_Active = doActive;
                    if (doActive == "Y")
                        message = objMessageKey.Recordactivatedsuccessfully;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                }
                else
                {
                    status = "E";
                    message = "";
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
        public JsonResult SaveMusicLanguage(int music_Language_Code, string languageName, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (music_Language_Code > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

           // Music_Language_Service objService = new Music_Language_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Music_Language objMusicLanguage = null;

            if (music_Language_Code > 0)
            {
                objMusicLanguage = objMusicLanguageService.GetByID(music_Language_Code);
               // objMusicLanguage.EntityState = State.Modified;
            }
            else
            {
                objMusicLanguage = new RightsU_Dapper.Entity.Music_Language();
               // objMusicLanguage.EntityState = State.Added;
                objMusicLanguage.Inserted_On = DateTime.Now;
                objMusicLanguage.Inserted_By = objLoginUser.Users_Code;
            }

            objMusicLanguage.Last_Updated_Time = DateTime.Now;
            objMusicLanguage.Last_Action_By = objLoginUser.Users_Code;
            objMusicLanguage.Is_Active = "Y";
            objMusicLanguage.Language_Name = languageName;
            string resultSet;
            bool isDuplicate = objMusicLanguageService.Validate(objMusicLanguage, out resultSet);
            if (isDuplicate)
            {
                objMusicLanguageService.AddEntity(objMusicLanguage);
            }
            else
            {
                status = "";
                message = resultSet;
            }
            bool isValid = true;// objService.Save(objMusicLanguage, out resultSet);
            if (isValid)
            {
                lstMusicLanguage_Searched = lstMusicLanguage = objMusicLanguageService.GetAll().OrderByDescending(x => x.Last_Updated_Time).ToList();
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
                RecordCount = lstMusicLanguage_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}