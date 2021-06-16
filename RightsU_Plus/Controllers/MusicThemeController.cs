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
    public class MusicThemeController : BaseController
    {
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();
        private readonly Music_Theme_Service objMusic_Theme_Service = new Music_Theme_Service();

        
        private List<RightsU_Dapper.Entity.Music_Theme> lstMusicTheme
        {
            get
            {
                if (Session["lstMusicTheme"] == null)
                    Session["lstMusicTheme"] = new List<RightsU_Dapper.Entity.Music_Theme>();
                return (List<RightsU_Dapper.Entity.Music_Theme>)Session["lstMusicTheme"];
            }
            set { Session["lstMusicTheme"] = value; }
        }

        private List<RightsU_Dapper.Entity.Music_Theme> lstMusicTheme_Searched
        {
            get
            {
                if (Session["lstMusicTheme_Searched"] == null)
                    Session["lstMusicTheme_Searched"] = new List<RightsU_Dapper.Entity.Music_Theme>();
                return (List<RightsU_Dapper.Entity.Music_Theme>)Session["lstMusicTheme_Searched"];
            }
            set { Session["lstMusicTheme_Searched"] = value; }
        }
        public ViewResult Index()
        {
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForMusicTheme.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicTheme);
            lstMusicTheme_Searched = lstMusicTheme = objMusic_Theme_Service.GetAll().ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/MusicTheme/Index.cshtml");
        }
        public PartialViewResult BindMusicThemeList(int pageNo, int recordPerPage, int MusicTheme_Code, string commandName, string sortType)
        {
            ViewBag.MusicTheme_Code = MusicTheme_Code;
            ViewBag.CommandName = commandName;
            List<RightsU_Dapper.Entity.Music_Theme> lst = new List<RightsU_Dapper.Entity.Music_Theme>();
            int RecordCount = 0;
            RecordCount = lstMusicTheme_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstMusicTheme_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstMusicTheme_Searched.OrderBy(o => o.Music_Theme_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstMusicTheme_Searched.OrderByDescending(o => o.Music_Theme_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/MusicTheme/_MusicTheme.cshtml", lst);
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
           string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForMusicTheme), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        public JsonResult CheckRecordLock(int MusicTheme_Code, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (MusicTheme_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(MusicTheme_Code, GlobalParams.ModuleCodeForMusicTheme, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SearchMusicTheme(string searchText)
        {

            if (!string.IsNullOrEmpty(searchText))
            {
                lstMusicTheme_Searched = lstMusicTheme.Where(w => w.Music_Theme_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstMusicTheme_Searched = lstMusicTheme;

            var obj = new
            {
                Record_Count = lstMusicTheme_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult EditMusicTheme(int MusicTheme_Code)
        {

            string status = "S", message = "Record {ACTION} successfully";
           // Music_Theme_Service objService = new Music_Theme_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Music_Theme objMusicTheme = objMusic_Theme_Service.GetByID(MusicTheme_Code);

            TempData["Action"] = "EditMusicTheme";
            TempData["idMusicTheme"] = objMusicTheme.Music_Theme_Code;

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public JsonResult ActiveDeactiveMusicTheme(int MusicTheme_Code, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(MusicTheme_Code, GlobalParams.ModuleCodeForMusicTheme, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
               // Music_Theme_Service objService = new Music_Theme_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Music_Theme objMusicTheme = objMusic_Theme_Service.GetByID(MusicTheme_Code);
                objMusicTheme.Is_Active = doActive;
                //objMusicTheme.EntityState = State.Modified;
                dynamic resultSet;
                objMusic_Theme_Service.AddEntity(objMusicTheme);
                bool isValid = true;// objMusic_Theme_Service.AddEntity(objMusicTheme);
                if (isValid)
                {
                    lstMusicTheme.Where(w => w.Music_Theme_Code == MusicTheme_Code).First().Is_Active = doActive;
                    lstMusicTheme_Searched.Where(w => w.Music_Theme_Code == MusicTheme_Code).First().Is_Active = doActive;
                }
                else
                {
                    status = "E";
                    message = "Cound not {ACTION} record";
                }
                if (doActive == "Y")
                {
                    if (status == "E")
                        message = objMessageKey.CouldNotActivatedRecord;
                    else
                        message = objMessageKey.Recordactivatedsuccessfully;
                    //message = message.Replace("{ACTION}", "Activated");
                }
                else
                    if (status == "E")
                        message = objMessageKey.CouldNotDeactivatedRecord;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                //message = message.Replace("{ACTION}", "Deactivated");
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
        public JsonResult SaveMusicTheme(int MusicTheme_Code, string MusicTheme_Name, int Record_Code)
        { 
            string status = "S", message = "Record {ACTION} successfully";
           // Music_Theme_Service objService = new Music_Theme_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Music_Theme objMusicTheme = null;

            if (MusicTheme_Code > 0)
            {
                objMusicTheme = objMusic_Theme_Service.GetByID(MusicTheme_Code);
                //objMusicTheme.EntityState = State.Modified;
            }
            else
            {
                objMusicTheme = new RightsU_Dapper.Entity.Music_Theme();
                //objMusicTheme.EntityState = State.Added;
                objMusicTheme.Inserted_On = DateTime.Now;
                objMusicTheme.Inserted_By = objLoginUser.Users_Code;
            }

            objMusicTheme.Last_Updated_Time = DateTime.Now;
            objMusicTheme.Last_Action_By = objLoginUser.Users_Code;
            objMusicTheme.Is_Active = "Y";
            objMusicTheme.Music_Theme_Name = MusicTheme_Name;
            string resultSet;
            bool isDuplicate = objMusic_Theme_Service.Validate(objMusicTheme, out resultSet);
            if (isDuplicate)
            {
                objMusic_Theme_Service.AddEntity(objMusicTheme);
                if (MusicTheme_Code > 0)
                {
                    if (status == "E")
                        message = objMessageKey.CouldNotupdatedRecord;
                    else
                        message = objMessageKey.Recordupdatedsuccessfully;
                    //message = message.Replace("{ACTION}", "updated");
                }
                else
                {
                    if (status == "E")
                        message = objMessageKey.CouldNotsavedRecord;
                    else
                        message = objMessageKey.Recordsavedsuccessfully;
                    //message = message.Replace("{ACTION}", "saved");
                }
            }
            else
            {
                status = "";
                message = resultSet;
            }
            
            bool isValid = true; //objService.Save(objMusicTheme, out resultSet);
            if (isValid)
            {
                lstMusicTheme_Searched = lstMusicTheme = objMusic_Theme_Service.GetAll().OrderByDescending(x => x.Last_Updated_Time).ToList();
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
                RecordCount = lstMusicTheme.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}
