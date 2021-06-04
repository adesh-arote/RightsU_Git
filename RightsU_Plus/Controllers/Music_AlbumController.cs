using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_Entities;
//using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Web.Mail;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.Entity;

namespace RightsU_Plus.Controllers
{
    public class Music_AlbumController : BaseController
    {
        private readonly Music_Album_Service objMusic_AlbumService = new Music_Album_Service();
        private readonly Talent_Service objTalentService = new Talent_Service();
        private readonly USP_Service objProcedureService = new USP_Service();
        #region --- Properties ---
        private List<RightsU_Dapper.Entity.Music_Album> lstMusic_Album
        {
            get
            {
                if (Session["lstMusic_Album"] == null)
                    Session["lstMusic_Album"] = new List<RightsU_Dapper.Entity.Music_Album>();
                return (List<RightsU_Dapper.Entity.Music_Album>)Session["lstMusic_Album"];
            }
            set { Session["lstMusic_Album"] = value; }
        }

        private List<RightsU_Dapper.Entity.Music_Album> lstMusic_Album_Searched
        {
            get
            {
                if (Session["lstMusic_Album_Searched"] == null)
                    Session["lstMusic_Album_Searched"] = new List<RightsU_Dapper.Entity.Music_Album>();
                return (List<RightsU_Dapper.Entity.Music_Album>)Session["lstMusic_Album_Searched"];
            }
            set { Session["lstMusic_Album_Searched"] = value; }
        }
        #endregion
        Type[] RelationList = new Type[] { typeof(Music_Album_Talent)};
        public ViewResult Index()
        {
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForMusicAlbum.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicAlbum);
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            FetchData();
            return View("~/Views/Music_Album/Index.cshtml");
        }
        public JsonResult CheckRecordLock(int Music_Album_Code, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Music_Album_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Music_Album_Code, GlobalParams.ModuleCodeForMusicAlbum, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public PartialViewResult BindMusic_AlbumList(int pageNo, int recordPerPage, int Music_Album_Code, string commandName, string sortType)
        {
            ViewBag.Music_Album_Code = Music_Album_Code;
            ViewBag.CommandName = commandName;
            //Music_Album_Service objService = new Music_Album_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Music_Album objMusic_Album= objMusic_AlbumService.GetByID(Music_Album_Code);
            List<RightsU_Dapper.Entity.Music_Album> lst = new List<RightsU_Dapper.Entity.Music_Album>();
            int RecordCount = 0;
            RecordCount = lstMusic_Album_Searched.Count;

            if(commandName == "ADD")
            {
                List<RightsU_Dapper.Entity.Talents> lstTalent = objTalentService.GetList(RelationList).Where(w => w.Talent_Role.Any(a => a.Role_Code == GlobalParams.Role_code_StarCast)).OrderBy(o => o.Talent_Name).ToList();
                ViewBag.TalentList = new MultiSelectList(lstTalent, "Talent_Code", "Talent_Name");
            }
            if (commandName == "EDIT")
            {
                List<RightsU_Dapper.Entity.Talents> lstTalent = objTalentService.GetList(RelationList).Where(w => w.Talent_Role.Any(a => a.Role_Code == GlobalParams.Role_code_StarCast)).OrderBy(o => o.Talent_Name).ToList();
               
                var talentcode = objMusic_Album.Music_Album_Talent.Select(s => s.Talent_Code).ToArray();
                ViewBag.TalentListEdit = new MultiSelectList(lstTalent, "Talent_Code", "Talent_Name", talentcode);
            }

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstMusic_Album_Searched.OrderByDescending(o => o.Last_UpDated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstMusic_Album_Searched.OrderBy(o => o.Music_Album_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstMusic_Album_Searched.OrderByDescending(o => o.Music_Album_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Music_Album/_Music_AlbumList.cshtml", lst);
        }

        #region  --- Other Methods ---
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
        private void FetchData()
        {
            lstMusic_Album_Searched = lstMusic_Album = objMusic_AlbumService.GetAll(RelationList).OrderBy(o=>o.Music_Album_Code).ToList();
        }
        #endregion

        public JsonResult SearchMusic_Album(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstMusic_Album_Searched = lstMusic_Album.Where(w => w.Music_Album_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstMusic_Album_Searched = lstMusic_Album;

            var obj = new
            {
                Record_Count = lstMusic_Album_Searched.Count
            };
            return Json(obj);
        }

        public JsonResult ActiveDeactiveMusic_Album(int Music_Album_Code, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(Music_Album_Code, GlobalParams.ModuleCodeForMusicAlbum, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Music_Album_Service objService = new Music_Album_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Music_Album objMusic_Album = objMusic_AlbumService.GetByID(Music_Album_Code);
                objMusic_Album.Is_Active = doActive;
                //objMusic_Album.EntityState = State.Modified;
                dynamic resultSet;
                objMusic_AlbumService.UpdateEntity(objMusic_Album);
                bool isValid = true;//objService.Save(objMusic_Album, out resultSet);
                if (isValid)
                {
                    lstMusic_Album.Where(w => w.Music_Album_Code == Music_Album_Code).First().Is_Active = doActive;
                    lstMusic_Album_Searched.Where(w => w.Music_Album_Code == Music_Album_Code).First().Is_Active = doActive;
                }
                else
                {
                    status = "E";
                    message = "";
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
                {
                    if (status == "E")
                        message = objMessageKey.CouldNotDeactivatedRecord;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                    //message = message.Replace("{ACTION}", "Deactivated");
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

        [HttpPost]
        public ActionResult SaveMusic_Album(int Music_Album_Code, string Music_Album_Name, string Music_Album_Type, int Record_Code, string[] Talent_Code)
        {
            Music_Album objMusic_Album = new Music_Album();
           // Music_Album_Service ObjMusicAlbumService = new Music_Album_Service(objLoginEntity.ConnectionStringName);
            if (Music_Album_Code > 0)
            {
                objMusic_Album = objMusic_AlbumService.GetByID(Music_Album_Code);
                objMusic_Album.Last_Action_By = objLoginUser.Users_Code;
               // objMusic_Album.EntityState = State.Modified;
            }
            else
            {
                //objMusic_Album.EntityState = State.Added;
                objMusic_Album.Is_Active = "Y";
            }
            objMusic_Album.Last_UpDated_Time = DateTime.Now;
            objMusic_Album.Music_Album_Name = Music_Album_Name;
            objMusic_Album.Album_Type = Music_Album_Type;
         

            dynamic resultSet;
            string status = "S", message = "Record {ACTION} successfully";
            ICollection<Music_Album_Talent> TalentList = new HashSet<Music_Album_Talent>();
            if (Talent_Code != null)
            {
                foreach (string TalentCodes in Talent_Code)
                {
                    Music_Album_Talent objMAT = new Music_Album_Talent();
                   // objMAT.EntityState = State.Added;
                    objMAT.Role_Code = GlobalParams.Role_code_StarCast;
                    objMAT.Talent_Code = Convert.ToInt32(TalentCodes);
                    TalentList.Add(objMAT);
                }
            }
            if (Music_Album_Code > 0)
            {
                objMusic_AlbumService.UpdateEntity(objMusic_Album);
            }
            else
            {
                objMusic_AlbumService.AddEntity(objMusic_Album);
            }
                IEqualityComparer<Music_Album_Talent> comparerTalent_Code = new RightsU_Dapper.BLL.LambdaComparer<RightsU_Dapper.Entity.Music_Album_Talent>((x, y) => x.Talent_Code == y.Talent_Code); //&& x.EntityState != State.Deleted);
            var Deleted_Music_Album_Talent = new List<Music_Album_Talent>();
            var Updated_Music_Album_Talent = new List<Music_Album_Talent>();
            var Added_Music_Album_Talent = CompareLists<Music_Album_Talent>(TalentList.ToList<Music_Album_Talent>(), objMusic_Album.Music_Album_Talent.ToList<Music_Album_Talent>(), comparerTalent_Code, ref Deleted_Music_Album_Talent, ref Updated_Music_Album_Talent);
            Added_Music_Album_Talent.ToList<Music_Album_Talent>().ForEach(t => objMusic_Album.Music_Album_Talent.Add(t));
            Deleted_Music_Album_Talent.ToList<Music_Album_Talent>().ForEach(t => objMusic_Album.Music_Album_Talent.Remove(t));
            if (Music_Album_Code > 0)
            {
                objMusic_AlbumService.UpdateEntity(objMusic_Album);
            }
            else
            {
                objMusic_AlbumService.AddEntity(objMusic_Album);
            }
            bool valid = true;//ObjMusicAlbumService.Save(objMusic_Album, out resultSet);

            if (valid)
            {
                if (Music_Album_Code > 0)
                {
                    message = message.Replace("{ACTION}", "updated");
                }
                else
                {
                    message = message.Replace("{ACTION}", "added");
                }
                FetchData();
            }
            else
            {
                status = "E";
                if (Music_Album_Code > 0)
                    message = message.Replace("Record {ACTION} successfully", "");
                else
                    message = message.Replace("Record {ACTION} successfully", "");
            };
            int recordLockingCode = Convert.ToInt32(Record_Code);
            CommonUtil objCommonUtil = new CommonUtil();
            objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
            var obj = new
            {
                RecordCount = lstMusic_Album.Count,
                Status = status,
                Message = message
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
      
       
        private string GetUserModuleRights()
        {
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForMusicAlbum), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
    }
}

