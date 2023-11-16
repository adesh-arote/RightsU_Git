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
    public class GenresController : BaseController
    {
        #region --Properties--

        private List<RightsU_Entities.Genre> lstGenre
        {
            get
            {
                if (Session["lstGenre"] == null)
                    Session["lstGenre"] = new List<RightsU_Entities.Genre>();
                return (List<RightsU_Entities.Genre>)Session["lstGenre"];
            }
            set { Session["lstGenre"] = value; }
        }

        private List<RightsU_Entities.Genre> lstGenre_Searched
        {
            get
            {
                if (Session["lstGenre_Searched"] == null)
                    Session["lstGenre_Searched"] = new List<RightsU_Entities.Genre>();
                return (List<RightsU_Entities.Genre>)Session["lstGenre_Searched"];
            }
            set { Session["lstGenre_Searched"] = value; }
        }

        #endregion
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForGenres);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForGenres.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstGenre_Searched = lstGenre = new Genre_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Genres/Index.cshtml");
        }

        public PartialViewResult BindGenreList(int pageNo, int recordPerPage, int genresCode, string commandName, string sortType)
        {
            ViewBag.Genres_Code = genresCode;
            ViewBag.CommandName = commandName;
            List<RightsU_Entities.Genre> lst = new List<RightsU_Entities.Genre>();
            int RecordCount = 0;
            RecordCount = lstGenre_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstGenre_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstGenre_Searched.OrderBy(o => o.Genres_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstGenre_Searched.OrderByDescending(o => o.Genres_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Genres/_GenresList.cshtml", lst);
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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForGenres), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        #endregion

        public JsonResult CheckRecordLock(int genresCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (genresCode > 0)
            {
                isLocked = DBUtil.Lock_Record(genresCode, GlobalParams.ModuleCodeForGenres, objLoginUser.Users_Code, out RLCode, out strMessage);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public JsonResult SearchGenre(string searchText)
        {
            Genre_Service objService = new Genre_Service(objLoginEntity.ConnectionStringName);
            if (!string.IsNullOrEmpty(searchText))
            {
                lstGenre_Searched = lstGenre.Where(w => w.Genres_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstGenre_Searched = lstGenre;


            var obj = new
            {
                Record_Count = lstGenre_Searched.Count
            };
            return Json(obj);
        }

        public JsonResult ActiveDeactiveGenre(int genres_Code, string doActive)
        {
            string status = "S", message = "", strMessage = "", Action = "";
            int RLCode = 0;

            bool isLocked = DBUtil.Lock_Record(genres_Code, GlobalParams.ModuleCodeForGenres, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {
                Genre_Service objService = new Genre_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Genre objGenre = objService.GetById(genres_Code);
                objGenre.Is_Active = doActive;
                objGenre.EntityState = State.Modified;
                dynamic resultSet;

                bool isValid = objService.Save(objGenre, out resultSet);
                if (isValid)
                {
                    lstGenre.Where(w => w.Genres_Code == genres_Code).First().Is_Active = doActive;
                    lstGenre_Searched.Where(w => w.Genres_Code == genres_Code).First().Is_Active = doActive;
                    if (doActive == "Y")
                    {
                        Action = "A"; // A = "Active";
                        message = objMessageKey.Recordactivatedsuccessfully;   
                    }
                    else
                    {
                        Action = "DA"; // DA = "Deactivate";
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                    }

                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objGenre);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForGenres, objGenre.Genres_Code, LogData, Action, objLoginUser.Users_Code);
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

        public JsonResult SaveGenre(int genresCode, string genresName, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully, Action = "C"; // C = "Create";
            if (genresCode > 0)
            {
                Action = "U"; // U = "Update";
                message = objMessageKey.Recordupdatedsuccessfully;
            }
                
            Genre_Service objService = new Genre_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Genre objGenre = null;

            if (genresCode > 0)
            {
                objGenre = objService.GetById(genresCode);
                objGenre.EntityState = State.Modified;
            }
            else
            {
                objGenre = new RightsU_Entities.Genre();
                objGenre.EntityState = State.Added;
                objGenre.Inserted_On = DateTime.Now;
                objGenre.Inserted_By = objLoginUser.Users_Code;
            }

            objGenre.Last_Updated_Time = DateTime.Now;
            objGenre.Last_Action_By = objLoginUser.Users_Code;
            objGenre.Is_Active = "Y";
            objGenre.Genres_Name = genresName;
            dynamic resultSet;
            bool isValid = objService.Save(objGenre, out resultSet);

            if (isValid)
            {                
                lstGenre_Searched = lstGenre = objService.SearchFor(s => true).OrderByDescending(x => x.Last_Updated_Time).ToList();

                try
                {
                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objGenre);
                    bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForGenres, objGenre.Genres_Code, LogData, Action, objLoginUser.Users_Code);
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
                RecordCount = lstGenre_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}


