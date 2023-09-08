using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity.Core.Objects;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using System.Web.UI.WebControls;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;
using Microsoft.Reporting.WebForms;

namespace RightsU_Plus.Controllers
{

    public class Music_TitleController : BaseController
    {
        ReportViewer ReportViewer1;

        public int PageNo
        {
            get
            {
                if (Session["MusicPageNo"] == null)
                    Session["MusicPageNo"] = 0;
                return (int)Session["MusicPageNo"];
            }
            set { Session["MusicPageNo"] = value; }
        }
        public int MusicPageSize
        {
            get
            {
                if (Session["PageSize"] == null)
                    Session["PageSize"] = 0;
                return (int)Session["PageSize"];
            }
            set { Session["PageSize"] = value; }
        }
        public string Message
        {
            get
            {
                if (Session["Music_Message"] == null)
                    Session["Music_Message"] = string.Empty;
                return (string)Session["Music_Message"];
            }
            set { Session["Music_Message"] = value; }
        }

        public string SearchCriteria
        {
            get
            {
                if (Session["search_Criteria"] == null)
                    Session["search_Criteria"] = string.Empty;
                return (string)Session["search_Criteria"];
            }
            set { Session["search_Criteria"] = value; }
        }

        public string mode
        {
            get
            {
                if (Session["music_mode"] == null || Session["music_mode"] == "E")
                    mode = "E";
                return (string)Session["music_mode"];
            }
            set { Session["music_mode"] = value; }
        }
        public RightsU_Entities.Music_Title objTitle
        {
            get
            {
                if (Session["Session_Music_Title"] == null)
                    Session["Session_Music_Title"] = new RightsU_Entities.Music_Title();
                return (RightsU_Entities.Music_Title)Session["Session_Music_Title"];
            }
            set { Session["Session_Music_Title"] = value; }
        }
        public RightsU_Entities.DM_Master_Import objDMImport
        {
            get
            {
                if (Session["Session_DM_Import"] == null)
                    Session["Session_DM_Import"] = new RightsU_Entities.DM_Master_Import();
                return (RightsU_Entities.DM_Master_Import)Session["Session_DM_Import"];
            }
            set { Session["Session_DM_Import"] = value; }
        }
        public Music_Title_Search objPage_Properties
        {
            get
            {
                if (Session["Music_Title_Search_Page_Properties"] == null)
                    Session["Music_Title_Search_Page_Properties"] = new Music_Title_Search();
                return (Music_Title_Search)Session["Music_Title_Search_Page_Properties"];
            }
            set { Session["Music_Title_Search_Page_Properties"] = value; }
        }
        public Music_Title_Service objTitleS
        {
            get
            {
                if (Session["objMusicTitleS_Service"] == null)
                    Session["objMusicTitleS_Service"] = new Music_Title_Service(objLoginEntity.ConnectionStringName);
                return (Music_Title_Service)Session["objMusicTitleS_Service"];
            }
            set { Session["objMusicTitleS_Service"] = value; }
        }
        public Music_Title_Label objMTL_Session
        {
            get
            {
                if (Session["objMTL_Session"] == null)
                    Session["objMTL_Session"] = new Music_Title_Label();
                return (Music_Title_Label)Session["objMTL_Session"];
            }
            set { Session["objMTL_Session"] = value; }
        }
        public List<USP_Insert_Music_Title_Import_UDT> lstError
        {
            get
            {
                if (Session["lstError_Session"] == null)
                    Session["lstError_Session"] = new List<USP_Insert_Music_Title_Import_UDT>();
                return (List<USP_Insert_Music_Title_Import_UDT>)Session["lstError_Session"];
            }
            set { Session["lstError_Session"] = value; }
        }
        private List<RightsU_Entities.DM_Master_Import> lstDMImport
        {
            get
            {
                if (Session["lstDMImport"] == null)
                    Session["lstDMImport"] = new List<RightsU_Entities.DM_Master_Import>();
                return (List<RightsU_Entities.DM_Master_Import>)Session["lstDMImport"];
            }
            set { Session["lstDMImport"] = value; }
        }
        public List<USP_Get_Talent_Name_Result> lstTalent
        {
            get
            {
                if (Session["lstTalent"] == null)
                    Session["lstTalent"] = new List<USP_Get_Talent_Name_Result>();
                return (List<USP_Get_Talent_Name_Result>)Session["lstTalent"];
            }
            set { Session["lstTalent"] = value; }
        }
        public void ResetMessageSession()
        {
            Session["Music_Message"] = string.Empty;
        }
        public int Record_Locking_Code
        {
            get
            {
                if (Session["Record_Locking_Code"] == null)
                    Session["Record_Locking_Code"] = 0;
                return (int)Session["Record_Locking_Code"];
            }
            set { Session["Record_Locking_Code"] = value; }
        }
        public int pageNo
        {
            get
            {
                if (Session["pageNo"] == null)
                    Session["pageNo"] = 0;
                return (int)Session["pageNo"];
            }
            set { Session["pageNo"] = value; }
        }
        public string Locking_Messgae
        {
            get
            {
                if (Session["Locking_Messgae"] == null)
                    Session["Locking_Messgae"] = string.Empty;
                return (string)Session["Locking_Messgae"];
            }
            set { Session["Locking_Messgae"] = value; }
        }
        public string SearchedTitle_EDIT
        {
            get
            {
                if (Session["SearchedMusicTitle_EDIT"] == null)
                    Session["SearchedMusicTitle_EDIT"] = "";
                return (string)Session["SearchedMusicTitle_EDIT"];
            }
            set { Session["SearchedMusicTitle_EDIT"] = value; }
        }
        private List<RightsU_Entities.USP_Music_Title_Contents_Result> lstMusicTitleContent
        {
            get
            {
                if (Session["lstMusicTitleContent"] == null)
                    Session["lstMusicTitleContent"] = new List<RightsU_Entities.USP_Music_Title_Contents_Result>();
                return (List<RightsU_Entities.USP_Music_Title_Contents_Result>)Session["lstMusicTitleContent"];
            }
            set { Session["lstMusicTitleContent"] = value; }
        }
        private List<RightsU_Entities.USP_Music_Title_Contents_Result> lstMusicTitleContent_Searched
        {
            get
            {
                if (Session["lstMusicTitleContent_Searched"] == null)
                    Session["lstMusicTitleContent_Searched"] = new List<RightsU_Entities.USP_Music_Title_Contents_Result>();
                return (List<RightsU_Entities.USP_Music_Title_Contents_Result>)Session["lstMusicTitleContent_Searched"];
            }
            set { Session["lstMusicTitleContent_Searched"] = value; }
        }

        public int MusicTitleCode
        {
            get
            {
                if (Session["MusicTitleCode"] == null)
                    Session["MusicTitleCode"] = 0;
                return (int)Session["MusicTitleCode"];
            }
            set { Session["MusicTitleCode"] = value; }
        }
        public JsonResult CheckRecordLock(int id = 0, int Page_No = 0, string SearchedTitle = "", int PageSize = 10, string commandName = "")
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (id > 0)
            {
                isLocked = DBUtil.Lock_Record(id, GlobalParams.ModuleCodeForMusic_Title, objLoginUser.Users_Code, out RLCode, out strMessage);
            }
            ViewBag.Id = id;
            var obj = new
            {
                Is_Locked = (isLocked) ? "N" : "Y",
                Message = strMessage,
                Record_Locking_Code = RLCode,
                id = id,

            };
            return Json(obj);
        }

        public JsonResult CheckRecordLock_Bookmark(int id = 0)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (id > 0)
            {
                isLocked = DBUtil.Lock_Record(id, GlobalParams.ModuleCodeForMusic_Title, objLoginUser.Users_Code, out RLCode, out strMessage);
            }
            ViewBag.Id = id;
            var obj = new
            {
                Is_Locked = (isLocked) ? "N" : "Y",
                Message = strMessage,
                Record_Locking_Code = RLCode,
                id = id,

            };
            return Json(obj);
        }

        public ActionResult Index(int id = 0, int Page_No = 0, string SearchedTitle = "", int PageSize = 10, string commandName = "")
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusic_Title);
            var MusicTitleVersion = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "SPN_Music_Version").Select(w => w.Parameter_Value).SingleOrDefault();
            ViewBag.IsMuciVersionSPN = MusicTitleVersion;
            Message = string.Empty;
            bool isLocked = true;
            string strMessage = "", strViewBagMsg = "";
            int RLCode = 0;
            Session["music_mode"] = null;
            Session["Session_Music_Title"] = null;
            TempData["Page_No"] = Page_No;
            TempData["Page_Size"] = PageSize;
            Session["SearchedTitle"] = SearchedTitle;
            Music_Title_Search obj = objPage_Properties;
            mode = "E";
            ViewBag.commandName = commandName;
            if (commandName == "")
            {
                try
                {
                    isLocked = DBUtil.Lock_Record(id, GlobalParams.ModuleCodeForMusic_Title, objLoginUser.Users_Code, out RLCode, out strMessage);
                    if (!isLocked)
                        strViewBagMsg = strMessage;
                }
                catch (Exception ex)
                {
                    strViewBagMsg = ex.Message;
                }
            }
            if (isLocked)
            {
                PageNo = Page_No;
                MusicPageSize = PageSize;
                //ViewBag.PageNo = PageNo;
                ViewBag.SearchedTitle = SearchedTitle;
                SearchedTitle_EDIT = SearchedTitle;
                objTitle = new Music_Title_Service(objLoginEntity.ConnectionStringName).GetById(id);

                objTitle.Movie_Album_Type = string.IsNullOrEmpty(objTitle.Movie_Album_Type) ? "A" : objTitle.Movie_Album_Type;

                BindDDL();
                Role_Service objRoleService = new Role_Service(objLoginEntity.ConnectionStringName);
                string MusicThemeVisibility = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "MusicThemeVisibility").Select(i => i.Parameter_Value).FirstOrDefault();
                ViewBag.MusicThemeVisibility = MusicThemeVisibility;
                ViewBag.RolesList = new SelectList(objRoleService.SearchFor(r => r.Role_Type == "T"), "Role_Code", "Role_Name").ToList();

                if (String.IsNullOrEmpty(objTitle.Movie_Album_Type) || objTitle.Movie_Album_Type == "A")
                {
                    int Music_Album_Code = Convert.ToInt32(objTitle.Music_Album_Code);
                    string Movie_Album_Name = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Code == objTitle.Music_Album_Code).Select(x => x.Music_Album_Name).FirstOrDefault();
                    ViewBag.MovieAlbum = Movie_Album_Name;
                    ViewBag.MovieAlbumCode = Music_Album_Code;

                    BindStarcast(Music_Album_Code, objTitle.Movie_Album_Type);
                }
                else
                {
                    int Title_Code = Convert.ToInt32(objTitle.Title_Code);
                    string Movie_Album_Name = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == objTitle.Title_Code).Select(x => x.Title_Name).FirstOrDefault();
                    ViewBag.MovieAlbum = Movie_Album_Name;
                    ViewBag.MovieAlbumCode = Title_Code;

                    BindStarcast(Title_Code, objTitle.Movie_Album_Type);
                }

                //ViewBag.MovieAlbum = BindMovieAlbum(Music_Album_Code);
                ViewBag.Record_Locking_Code = RLCode;
                Record_Locking_Code = RLCode;

                return View(objTitle);
            }
            else
            {
                ViewBag.Locking_Message = strViewBagMsg;
                ViewBag.IncludePublicDomain = objTitle.Public_Domain;
                Locking_Messgae = strViewBagMsg;
                return RedirectToAction("List");
            }

        }


        public JsonResult GetTitle(int Selected_deal_type_Code, int Selected_BUCode, string Selected_Title_Codes = "", string strBindTitleType = "N",
            string Searched_Title = "")
        {
            List<string> terms = Searched_Title.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();

            //Extract the term to be searched from the list
            string searchString = terms.LastOrDefault().ToString().Trim();
            string strFlag = "TT";
            if (Selected_BUCode <= 0)
            {
                var result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq(strFlag, Selected_deal_type_Code, 0, searchString).Where(x => x.Data_For == "TT" && !terms.Contains(x.Display_Text)).ToList();

                return Json(result);
            }
            else
            {
                var result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq(strFlag, Selected_deal_type_Code, Selected_BUCode, searchString).Where(x => x.Data_For == "TT" && !terms.Contains(x.Display_Text)).ToList();
                //arr_Title_List = new MultiSelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "TT"), "Display_Value", "Display_Text", Selected_Title_Codes.Split(','));

                return Json(result);
            }
        }
        public JsonResult Bind_Title(int Selected_BUCode, string Selected_Title_Codes = "", string Searched_Title = "")//int Selected_deal_type_Code, 
        {
            List<string> terms = Searched_Title.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            Music_Title_Service objMusicTitle = new Music_Title_Service(objLoginEntity.ConnectionStringName);
            //if (objPage_Properties.MusicTitleName != null)
            //    return new MultiSelectList(objTitleS.SearchFor(x => x.Is_Active == "Y")
            //                                   .Select(i => new { Music_Title_Code = i.Music_Title_Code, Music_Title_Name = i.Music_Title_Name }).ToList(), "Music_Title_Code", "Music_Title_Name", objPage_Properties.MusicTitleName.Split(','));
            //if (Selected_BUCode <= 0)
            //{
            string searchString = terms.LastOrDefault().ToString().Trim();

            //.Where(x => terms.Contains(x.Music_Title_Name)).Select(i => new { Music_Title_Code = i.Music_Title_Code, Music_Title_Name = i.Music_Title_Name }).ToList();
            var result = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name.ToUpper().Contains(searchString.ToUpper())).Distinct()
               .Select(x => new { Music_Title_Name = x.Music_Title_Name, Music_Title_Code = 0 }).ToList();

            return Json(result);
            //}
            //else
            //{
            //    var result = objTitleS.SearchFor(x => x.Is_Active == "Y")
            //                 .Select(i => new { Music_Title_Code = i.Music_Title_Code, Music_Title_Name = i.Music_Title_Name }).ToList();

            //    return Json(result);
            //}
        }

        //public JsonResult BindTitle_Ajax(int Selected_BUCode, string Selected_Title_Codes = "")//int Selected_deal_type_Code, 
        //{
        //    MultiSelectList arr_Title_List = Bind_Title(Selected_BUCode, Selected_Title_Codes);
        //    return Json(arr_Title_List);
        //}
        public ActionResult View(int id = 0, int Page_No = 0, string SearchedTitle = "", int PageSize = 10)
        {
            Message = string.Empty;
            Session["music_mode"] = null;
            Session["Session_Music_Title"] = null;
            TempData["Page_No"] = Page_No;
            TempData["Page_Size"] = PageSize;
            TempData["SearchedTitle"] = SearchedTitle;
            mode = "V";
            PageNo = Page_No;
            string PublicDomainView = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Music_Title_Code == objTitle.Music_Title_Code).Select(w => w.Public_Domain).ToString();
            ViewBag.PublicDomainView = PublicDomainView;
            if (MusicPageSize == 0)
                MusicPageSize = PageSize;
            ViewBag.PageNo = PageNo;
            ViewBag.SearchedTitle = SearchedTitle;
            //SearchedTitle_EDIT = SearchedTitle;
            objTitle = new Music_Title_Service(objLoginEntity.ConnectionStringName).GetById(id);
            objTitle.Movie_Album_Type = string.IsNullOrEmpty(objTitle.Movie_Album_Type) ? "A" : objTitle.Movie_Album_Type;

            BindDDL();
            Role_Service objRoleService = new Role_Service(objLoginEntity.ConnectionStringName);
            ViewBag.RolesList = new SelectList(objRoleService.SearchFor(r => r.Role_Type == "T"), "Role_Code", "Role_Name").ToList();
            var MusicTitleVersion = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "SPN_Music_Version").Select(w => w.Parameter_Value).SingleOrDefault();
            ViewBag.IsMuciVersionSPN = MusicTitleVersion;


            string MusicThemeVisibility = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "MusicThemeVisibility").Select(i => i.Parameter_Value).FirstOrDefault();
            ViewBag.MusicThemeVisibility = MusicThemeVisibility;

            if (String.IsNullOrEmpty(objTitle.Movie_Album_Type) || objTitle.Movie_Album_Type == "A")
            {
                int code = Convert.ToInt32(objTitle.Music_Album_Code);
                BindStarcast(code, objTitle.Movie_Album_Type);
            }
            else
            {
                int code = Convert.ToInt32(objTitle.Title_Code);
                BindStarcast(code, objTitle.Movie_Album_Type);
            }
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusic_Title);
            return View(objTitle);
            //if (objTitle.Original_Language_Code > 0)
            //    ViewBag.OriginalLanguage = new Language_Service().SearchFor(e => e.Language_Code == objTitle.Original_Language_Code).Select(i => new { i.Language_Name });
            //else
            //    ViewBag.OriginalLanguage = "No Original Langauge";
        }


        private MultiSelectList BindOriginalLanguage()
        {
            //List<SelectListItem> lstOriginalLanguage = new List<SelectListItem>();

            //lstOriginalLanguage = new SelectList(new Language_Service().SearchFor(x => x.Is_Active == "Y"), "Language_Code", "Language_Name", Convert.ToInt32(objTitle.Language_Code)).ToList();


            var language_code = string.Join(",", (objTitle.Music_Title_Language.Where(i => i.Music_Title_Code == objTitle.Music_Title_Code)
                .Select(i => i.Music_Language_Code).ToList()));

            MultiSelectList lstOriginalLanguage = new MultiSelectList(new Music_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                 .Select(i => new { Language_Code = i.Music_Language_Code, Language_Name = i.Language_Name }).ToList(), "Language_Code", "Language_Name",
                 language_code.Split(','));

            return lstOriginalLanguage;
        }

        private MultiSelectList BindTheme()
        {
            var theme_code = string.Join(",", (objTitle.Music_Title_Theme.Where(i => i.Music_Title_Code == objTitle.Music_Title_Code)
                .Select(i => i.Music_Theme_Code).ToList()));

            MultiSelectList lstTheme = new MultiSelectList(new Music_Theme_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                 .Select(i => new { Music_Theme_Code = i.Music_Theme_Code, Music_Theme_Name = i.Music_Theme_Name }).ToList(), "Music_Theme_Code", "Music_Theme_Name",
                 theme_code.Split(','));

            return lstTheme;
        }


        private List<SelectListItem> BindTitleType()
        {
            List<SelectListItem> lstTitleType = new List<SelectListItem>();

            lstTitleType = new SelectList(new Music_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Type == "MT"), "Music_Type_Code", "Music_Type_Name", Convert.ToInt32(objTitle.Music_Type_Code)).ToList();
            lstTitleType.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });

            return lstTitleType;
        }
        private List<SelectListItem> BindGenres()
        {
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("G", 0, 0, "").ToList();
            List<SelectListItem> lstGenres = new List<SelectListItem>();
            lstGenres = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "G"), "Display_Value", "Display_Text",
                Convert.ToInt32(objTitle.Genres_Code)).ToList();
            lstGenres.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            return lstGenres;
        }
        private List<SelectListItem> BindTitleTypeVersion()
        {
            List<SelectListItem> lstTitleType = new List<SelectListItem>();

            lstTitleType = new SelectList(new Music_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Type == "MV"), "Music_Type_Code", "Music_Type_Name", Convert.ToInt32(objTitle.Music_Version_Code)).ToList();
            lstTitleType.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });

            return lstTitleType;
        }
        private void BindDDL()
        {
            //ViewBag.MusicLabelList = BindMusicLabel();
            ViewBag.Language = BindOriginalLanguage();
            ViewBag.TitleType = BindTitleType();
            ViewBag.TitleVersion = BindTitleTypeVersion();
            ViewBag.TitleGenres = BindGenres();
            ViewBag.Theme = BindTheme();
            var lstTalent = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Talent_Name().ToList();
            var lstSinger = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_Code_Singer);
            var lstMusicComposer = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_MusicComposer);
            var lstStarCast = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_StarCast);
            var lstLyricist = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_lyricist);
            var lstMusicLabel = new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
            var singer_code = string.Join(",", (objTitle.Music_Title_Talent.Where(i => i.Music_Title_Code == objTitle.Music_Title_Code && i.Role_Code == GlobalParams.Role_Code_Singer).Select(i => i.Talent_Code).ToList()));
            var composer_code = string.Join(",", (objTitle.Music_Title_Talent.Where(i => i.Music_Title_Code == objTitle.Music_Title_Code && i.Role_Code == GlobalParams.Role_code_MusicComposer).Select(i => i.Talent_Code).ToList()));
            var lyricist_code = string.Join(",", (objTitle.Music_Title_Talent.Where(i => i.Music_Title_Code == objTitle.Music_Title_Code && i.Role_Code == GlobalParams.Role_code_lyricist).Select(i => i.Talent_Code).ToList()));
            var StarCast_code = string.Join(",", (objTitle.Music_Title_Talent.Where(i => i.Music_Title_Code == objTitle.Music_Title_Code && i.Role_Code == GlobalParams.Role_code_StarCast).Select(i => i.Talent_Code).ToList()));
            var language_code = string.Join(",", (objTitle.Music_Title_Language.Where(i => i.Music_Title_Code == objTitle.Music_Title_Code)
                .Select(i => i.Music_Language_Code).ToList()));
            var theme_code = string.Join(",", (objTitle.Music_Title_Theme.Where(i => i.Music_Title_Code == objTitle.Music_Title_Code)
                .Select(i => i.Music_Theme_Code).ToList()));
            if (objTitle.Music_Version_Code != null)
            {
                string version_Name = new Music_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Type_Code == objTitle.Music_Version_Code).FirstOrDefault().Music_Type_Name;
                ViewBag.version_Name = version_Name;
            }
            if (mode == "V")
            {
                if (singer_code != "")
                {
                    var singernames = string.Join(", ", (lstSinger.Where(y => singer_code.Split(',').Contains(y.Talent_Code.ToString())).Distinct().Select(i => i.Talent_Name)));
                    ViewBag.SingerList = singernames.Trim(',');
                }
                else
                    ViewBag.SingerList = "";

                if (StarCast_code != "")
                {
                    var starcastnames = string.Join(", ", (lstStarCast.Where(y => StarCast_code.Split(',').Contains(y.Talent_Code.ToString())).Distinct().Select(i => i.Talent_Name)));
                    ViewBag.StarCastList = starcastnames.Trim(',');
                }
                else
                    ViewBag.StarCastList = "";

                if (composer_code != "")
                {
                    var composernames = string.Join(", ", (lstMusicComposer.Where(y => composer_code.Split(',').Contains(y.Talent_Code.ToString())).Distinct().Select(i => i.Talent_Name)));
                    ViewBag.ComposerList = composernames.Trim(',');
                }
                else
                    ViewBag.ComposerList = "";

                if (lyricist_code != "")
                {
                    var lyricistnames = string.Join(", ", (lstLyricist.Where(y => lyricist_code.Split(',').Contains(y.Talent_Code.ToString())).Distinct().Select(i => i.Talent_Name)));
                    ViewBag.LyricistList = lyricistnames.Trim(',');
                }
                else
                    ViewBag.LyricistList = "";

                var Label_code = objTitle.Music_Title_Label.Where(i => i.Music_Title_Code == objTitle.Music_Title_Code && i.Effective_To == null).Select(i => i.Music_Label_Code).FirstOrDefault();
                if (Label_code != 0 && Label_code != null)
                {
                    ViewBag.MusicLabelList = new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Music_Label_Code == Label_code)
                        .FirstOrDefault().Music_Label_Name;
                }
                else
                    ViewBag.MusicLabelList = "";
                string GenresName = "";
                if (objTitle.Genres_Code != null && objTitle.Genres_Code != 0)
                {
                    List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("G", 0, 0, "").ToList();
                    GenresName = lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "G" && x.Display_Value == objTitle.Genres_Code).FirstOrDefault().Display_Text;
                }
                ViewBag.GenresName = GenresName;

                string LanguageName = "";
                if (language_code != "")
                {
                    LanguageName = string.Join(", ", ((new Music_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList()).Where(y => language_code.Split(',')
                        .Contains(y.Music_Language_Code.ToString())).Distinct().Select(i => i.Language_Name)));
                }
                ViewBag.LanguageName = LanguageName;

                string ThemeName = "";
                if (theme_code != "")
                {
                    ThemeName = string.Join(", ", ((new Music_Theme_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList()).Where(y => theme_code.Split(',')
                        .Contains(y.Music_Theme_Code.ToString())).Distinct().Select(i => i.Music_Theme_Name)));
                }
                ViewBag.ThemeName = ThemeName;
            }
            else
            {
                ViewBag.SingerList = new MultiSelectList(lstSinger, "Talent_code", "Talent_Name", singer_code.Split(','));
                ViewBag.ComposerList = new MultiSelectList(lstMusicComposer, "Talent_code", "Talent_Name", composer_code.Split(','));
                ViewBag.LyricistList = new MultiSelectList(lstLyricist, "Talent_code", "Talent_Name", lyricist_code.Split(','));
                ViewBag.StarCastList = new MultiSelectList(lstStarCast, "Talent_code", "Talent_Name", StarCast_code.Split(','));
                ViewBag.MusicLabelList = BindMusicLabel();
            }
        }

        public JsonResult BindAdvanced_Search_Controls()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();

            int Original_Language_code = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Title_OriginalLanguage").Select(i => i.Parameter_Value).FirstOrDefault());

            var lstTalent = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Talent_Name().ToList();
            var lstStarCast = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_StarCast);
            var lstSinger = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_Code_Singer);
            var lstComposer = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_MusicComposer);
            var lstLyricist = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_lyricist);
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("G", 0, 0, "").ToList();
            MultiSelectList lstGenres = new MultiSelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "G")
                .Select(i => new { Display_Value = i.Display_Value, Display_Text = i.Display_Text }), "Display_Value", "Display_Text");
            //MultiSelectList lstMLabel = new MultiSelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
            //    .Select(i => new { Display_Value = i.Music_Label_Code, Display_Text = i.Music_Label_Name }).ToList(),
            //    "Display_Value", "Display_Text");

            int?[] arrMusicLabelCodes = new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Select(s => s.Music_Label_Code).Distinct().ToArray();
            MultiSelectList lstMLabel = new MultiSelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").
                Where(x => arrMusicLabelCodes.Contains(x.Music_Label_Code)).Select(i => new { Display_Value = i.Music_Label_Code, Display_Text = i.Music_Label_Name }).ToList(),
                "Display_Value", "Display_Text");

            int?[] arrMusicLanguageCodes = new Music_Title_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Select(s => s.Music_Language_Code).Distinct().ToArray();
            MultiSelectList lstLanguageList = new MultiSelectList(new Music_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").
                Where(x => arrMusicLanguageCodes.Contains(x.Music_Language_Code)).Select(i => new { Display_Value = i.Music_Language_Code, Display_Text = i.Language_Name }).ToList(),
                "Display_Value", "Display_Text");

            int?[] arrMusicThemeCodes = new Music_Title_Theme_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Select(s => s.Music_Theme_Code).Distinct().ToArray();
            MultiSelectList lstThemeList = new MultiSelectList(new Music_Theme_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").
                Where(x => arrMusicThemeCodes.Contains(x.Music_Theme_Code)).Select(i => new { Display_Value = i.Music_Theme_Code, Display_Text = i.Music_Theme_Name }).ToList(),
                "Display_Value", "Display_Text");

            int?[] arrstarcastCodes = new Music_Title_Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true && x.Role_Code == GlobalParams.Role_code_StarCast).Select(s => s.Talent_Code).Distinct().ToArray();
            MultiSelectList lstMStarCast = new MultiSelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Where(x => arrstarcastCodes.Contains(x.Talent_Code)).Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).Distinct().OrderBy(i => i.Display_Value).ToList(),
                "Display_Value", "Display_Text");

            int?[] arrSingerCodes = new Music_Title_Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true && x.Role_Code == GlobalParams.Role_Code_Singer).Select(s => s.Talent_Code).Distinct().ToArray();
            MultiSelectList lstMSinger = new MultiSelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Where(x => arrSingerCodes.Contains(x.Talent_Code)).Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).Distinct().OrderBy(i => i.Display_Value).ToList(),
                "Display_Value", "Display_Text");

            int?[] arrComposerCodes = new Music_Title_Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true && x.Role_Code == GlobalParams.Role_code_MusicComposer).Select(s => s.Talent_Code).Distinct().ToArray();
            MultiSelectList lstMComposer = new MultiSelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Where(x => arrComposerCodes.Contains(x.Talent_Code)).Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).Distinct().OrderBy(i => i.Display_Value).ToList(),
                "Display_Value", "Display_Text");

            int?[] arrLyricistCodes = new Music_Title_Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true && x.Role_Code == GlobalParams.Role_code_lyricist).Select(s => s.Talent_Code).Distinct().ToArray();
            MultiSelectList lstMLyricist = new MultiSelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Where(x => arrLyricistCodes.Contains(x.Talent_Code)).Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).Distinct().OrderBy(i => i.Display_Value).ToList(),
                "Display_Value", "Display_Text");

            //MultiSelectList lstMStarCast1 = new MultiSelectList(lstStarCast.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).Distinct().OrderBy(i => i.Display_Value),
            //    "Display_Value", "Display_Text");
            //MultiSelectList lstMSinger = new MultiSelectList(lstSinger.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).Distinct(),
            //    "Display_Value", "Display_Text");
            //MultiSelectList lstMComposer = new MultiSelectList(lstComposer.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).Distinct(),
            //    "Display_Value", "Display_Text");
            //MultiSelectList lstMLyricist = new MultiSelectList(lstLyricist.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).Distinct(),
            //    "Display_Value", "Display_Text");

            objJson.Add("lstMStarCast", lstMStarCast);
            objJson.Add("lstMSinger", lstMSinger);
            objJson.Add("lstMComposer", lstMComposer);
            objJson.Add("lstMLyricist", lstMLyricist);
            objJson.Add("lstMTheme", lstThemeList);
            objJson.Add("lstLanguageList", lstLanguageList);
            objJson.Add("lstGenres", lstGenres);
            objJson.Add("lstMLabel", lstMLabel);
            if (objPage_Properties.LanguagesCodes_Search != "" && objPage_Properties.LanguagesCodes_Search != null)
                objPage_Properties.LanguagesCodes_Search = objPage_Properties.LanguagesCodes_Search;
            else
                objPage_Properties.LanguagesCodes_Search = "";
            if (objPage_Properties.StarCastCodes_Search != "" && objPage_Properties.StarCastCodes_Search != null)
                objPage_Properties.StarCastCodes_Search = objPage_Properties.StarCastCodes_Search;
            else
                objPage_Properties.StarCastCodes_Search = "";


            if (objPage_Properties.SingerCodes_Search != "" && objPage_Properties.SingerCodes_Search != null)
                objPage_Properties.SingerCodes_Search = objPage_Properties.SingerCodes_Search;
            else
                objPage_Properties.SingerCodes_Search = "";

            if (objPage_Properties.ComposerCodes_Search != "" && objPage_Properties.ComposerCodes_Search != null)
                objPage_Properties.ComposerCodes_Search = objPage_Properties.ComposerCodes_Search;
            else
                objPage_Properties.ComposerCodes_Search = "";

            if (objPage_Properties.MusicLabelCodes_Search != "" && objPage_Properties.MusicLabelCodes_Search != null)
                objPage_Properties.MusicLabelCodes_Search = objPage_Properties.MusicLabelCodes_Search;
            else
                objPage_Properties.MusicLabelCodes_Search = "";

            if (objPage_Properties.AlbumsCodes_Search != "" && objPage_Properties.AlbumsCodes_Search != null)
            {
                objPage_Properties.AlbumsCodes_Search = objPage_Properties.AlbumsCodes_Search;
                objPage_Properties.MusicAlbumName = objPage_Properties.MusicAlbumName;

                //lstMovieAlbum = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Code == MovieAlbumcode).Select(x => x.Music_Album_Name).ToList();
            }
            else
                objPage_Properties.AlbumsCodes_Search = "";

            if (objPage_Properties.MusicTitleName_Search != "" && objPage_Properties.MusicTitleName_Search != null)
                objPage_Properties.MusicTitleName_Search = objPage_Properties.MusicTitleName_Search;

            else
                objPage_Properties.MusicTitleName_Search = "";

            if (objPage_Properties.GenresCodes_Search != "" && objPage_Properties.GenresCodes_Search != null)
                objPage_Properties.GenresCodes_Search = objPage_Properties.GenresCodes_Search;
            else
                objPage_Properties.GenresCodes_Search = "";

            if (objPage_Properties.LyricistCodes_Search != "" && objPage_Properties.LyricistCodes_Search != null)
                objPage_Properties.LyricistCodes_Search = objPage_Properties.LyricistCodes_Search;
            else
                objPage_Properties.LyricistCodes_Search = "";

            if (objPage_Properties.MusicTitleName_Search != "" && objPage_Properties.MusicTitleName_Search != null)
                objPage_Properties.MusicTitleName_Search = objPage_Properties.MusicTitleName_Search;
            else
                objPage_Properties.MusicTitleName_Search = "";

            if (objPage_Properties.ThemeCodes_Search != "" && objPage_Properties.ThemeCodes_Search != null)
                objPage_Properties.ThemeCodes_Search = objPage_Properties.ThemeCodes_Search;
            else
                objPage_Properties.ThemeCodes_Search = "";

            if (objPage_Properties.Music_Tag_Search != "" && objPage_Properties.Music_Tag_Search != null)
                objPage_Properties.Music_Tag_Search = objPage_Properties.Music_Tag_Search;
            else
                objPage_Properties.Music_Tag_Search = "";

            if (objPage_Properties.Public_Domain != "" && objPage_Properties.Public_Domain != null)
                objPage_Properties.Public_Domain = objPage_Properties.Public_Domain;
            else
                objPage_Properties.Public_Domain = "";
            objJson.Add("objPage_Properties", objPage_Properties);
            return Json(objJson);
        }
        private List<SelectListItem> BindMusicLabel()
        {
            int Label_code = 0;
            List<SelectListItem> lstMusicLabel = new List<SelectListItem>();
            if (objTitle.Music_Title_Label.Count > 0)
                Label_code = Convert.ToInt32(objTitle.Music_Title_Label.Where(i => i.Music_Title_Code == objTitle.Music_Title_Code && i.Effective_To == null).FirstOrDefault().Music_Label_Code);
            lstMusicLabel = new SelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Label_Code", "Music_Label_Name", Label_code).ToList();
            //lstMusicLabel.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            return lstMusicLabel;
        }

        public JsonResult DeactivateTitle(string TitleCode, string Type)
        {
            if (Session["objMessageKey"] != null)
            {
                objMessageKey = (MessageKey)Session["objMessageKey"];
            }
            int Count = 0, RLCode = 0;
            string strMessage = "";
            int Title_Code = Convert.ToInt32(TitleCode);
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            bool isLocked = DBUtil.Lock_Record(Title_Code, GlobalParams.ModuleCodeForMusic_Title, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {

                //Music_Title_Service objTS = new Music_Title_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Music_Title objTitle = objTitleS.SearchFor(x => x.Music_Title_Code == Title_Code).Distinct().FirstOrDefault();

                //if (Type == "N")
                //    Count = (from Acq_Deal_Movie obj in objTitle.Acq_Deal_Movie where obj.Title_Code == Title_Code && (obj.Is_Closed != "X" || obj.Is_Closed != "Y") select obj).ToList().Distinct().Count();


                if (Count > 0)
                    objJson.Add("Error", objMessageKey.CannotdeactivatethisMusictitleasTitleisusedindeal);
                else
                {

                    objTitle.EntityState = State.Modified;
                    objTitle.Is_Active = Type;
                    objTitleS.Save(objTitle);


                    if (Type == "N")
                        objJson.Add("Message", objMessageKey.MusicTrackDeActivatedSuccessfully);
                    else
                        objJson.Add("Message", objMessageKey.MusicTrackActivatedSuccessfully);

                    objJson.Add("Error", "");
                }
                DBUtil.Release_Record(RLCode);
            }
            else
            {
                objJson.Add("Error", strMessage);
            }
            return Json(objJson);
        }
        public ActionResult List(string SearchedTitle = "", string IsMenu = "Y")
        {
            lstTalent = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Talent_Name().ToList();

            if (Locking_Messgae == "")
                ViewBag.Locking_Message = "";
            else
            {
                ViewBag.Locking_Message = Locking_Messgae;
                Locking_Messgae = null;
            }

            Dictionary<string, string> obj_Dic_Layout = new Dictionary<string, string>();
            if (TempData["QS_LayOut"] != null)
            {
                obj_Dic_Layout = TempData["QS_LayOut"] as Dictionary<string, string>;
                IsMenu = obj_Dic_Layout["IsMenu"];
            }

            if (IsMenu == "Y")
            {

                objPage_Properties.isAdvanced = "N";
                objPage_Properties = null;
                PageNo = 0;
            }

            var MusicTitleVersion = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "SPN_Music_Version").Select(w => w.Parameter_Value).SingleOrDefault();
            ViewBag.IsMuciVersionSPN = MusicTitleVersion;
            ViewBag.SearchText = objPage_Properties.SearchText; ;
            ViewBag.AdvanceSearch = objPage_Properties.isAdvanced;
            ViewBag.IsMenu = IsMenu;
            ViewBag.PageNo = (objPage_Properties.PageNo == 0) ? 1 : objPage_Properties.PageNo;
            if (PageNo != 0)
                ViewBag.PageNo = PageNo;
            ViewBag.PageSize = (objPage_Properties.Page_Size == 0) ? 10 : objPage_Properties.Page_Size;

            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForMusic_Title), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string c = addRights.FirstOrDefault();
            ViewBag.VisibilityforAdd = c;
            string MusicThemeVisibility = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "MusicThemeVisibility").Select(i => i.Parameter_Value).FirstOrDefault();
            ViewBag.MusicThemeVisibility = MusicThemeVisibility;
            DBUtil.Release_Record(Record_Locking_Code);
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusic_Title);
            return View("List");
        }

        public PartialViewResult AddMusicTitle()
        {

            int Original_Language_code = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Title_OriginalLanguage").Select(i => i.Parameter_Value).FirstOrDefault());
            //List<SelectListItem> lstLanguageList = new List<SelectListItem>();

            MultiSelectList lstMusicLanguage = new MultiSelectList(new Music_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                 .Select(i => new { Language_Code = i.Music_Language_Code, Language_Name = i.Language_Name }).ToList(), "Language_Code", "Language_Name");

            //lstLanguageList = new SelectList(new Language_Service().SearchFor(x => x.Is_Active == "Y"), "Language_Code", "Language_Name", Original_Language_code).ToList();
            //lstLanguageList.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            ViewBag.Language = lstMusicLanguage;


            ViewBag.PageNo = PageNo;
            ViewBag.SearchedTitle = objPage_Properties.SearchText;
            ViewBag.PageSize = MusicPageSize;

            List<SelectListItem> lstMusicLabel = new List<SelectListItem>();
            lstMusicLabel = new SelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Label_Code", "Music_Label_Name", 0).ToList();
            lstMusicLabel.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            ViewBag.MusicLabelList = lstMusicLabel;

            // ViewBag.MovieAlbum = BindMovieAlbum();

            return PartialView("_Create", new Music_Title());
        }

        public JsonResult ValidateIsDuplicate(string MusicTitleName, int MusicAlbumCode, string MusicAlbumName, string Movie_Album_Type, string mode = "Add")
        {
            int Count = 0;
            bool dupStringsCount = true;
            int MusicAlbum = 0;
            char[] splitchar = { '~' };
            string[] parts = MusicTitleName.Split(splitchar, StringSplitOptions.RemoveEmptyEntries);
            string Music_Album_Code = "";
            //MusicTitleName = MusicTitleName.Trim(' ');
            //MovieAlbumName = MovieAlbumName;
            foreach (string NewMusicTitleName in parts)
            {
                if (parts.Distinct().Count() != parts.Count())
                {
                    dupStringsCount = false;
                }
                if (MusicAlbumCode == 0)
                {
                    if (Movie_Album_Type == "A")
                    {
                        Music_Album_Code = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name == MusicAlbumName).Select(x => x.Music_Album_Code).FirstOrDefault().ToString();
                    }
                    else if (Movie_Album_Type == "M")
                    {
                        string dealType = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "AL_DealType_Movies").Select(x => x.Parameter_Value).FirstOrDefault();
                        var strArrdealType = dealType.Split(',');
                        Music_Album_Code = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name == MusicAlbumName && strArrdealType.Contains(x.Deal_Type_Code.ToString())).Select(x => x.Title_Code).FirstOrDefault().ToString();
                    }
                    else if (Movie_Album_Type == "S")
                    {
                        string dealType = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "AL_DealType_Show").Select(x => x.Parameter_Value).FirstOrDefault();
                        var strArrdealType = dealType.Split(',');
                        Music_Album_Code = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name == MusicAlbumName && strArrdealType.Contains(x.Deal_Type_Code.ToString())).Select(x => x.Title_Code).FirstOrDefault().ToString();
                    }

                    MusicAlbumCode = Convert.ToInt32(Music_Album_Code);
                }
                if (mode == "Add")
                {
                    int countDuplicate = 0;

                    if (Movie_Album_Type == "A")
                    {
                        countDuplicate = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name == NewMusicTitleName && x.Music_Album_Code == MusicAlbumCode).Distinct().Count();
                    }
                    else if (Movie_Album_Type == "M" || Movie_Album_Type == "S")
                    {
                        countDuplicate = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name == NewMusicTitleName && x.Title_Code == MusicAlbumCode).Distinct().Count();
                    }

                    Count += countDuplicate;
                }
                else if (mode == "Clone")
                {
                    int countDuplicate = 0;

                    if (Movie_Album_Type == "A")
                    {
                        countDuplicate = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name == NewMusicTitleName && x.Music_Album_Code == MusicAlbumCode).Distinct().Count();
                    }
                    else if (Movie_Album_Type == "M" || Movie_Album_Type == "S")
                    {
                        countDuplicate = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name == NewMusicTitleName && x.Title_Code == MusicAlbumCode).Distinct().Count();
                    }

                    Count += countDuplicate;
                }
                else
                {
                    int countDuplicate = 0;

                    if (Movie_Album_Type == "A")
                    {
                        countDuplicate = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name == NewMusicTitleName && x.Music_Album_Code == MusicAlbumCode && x.Music_Title_Code != objTitle.Music_Title_Code).Distinct().Count();
                    }
                    else if (Movie_Album_Type == "M" || Movie_Album_Type == "S")
                    {
                        countDuplicate = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name == NewMusicTitleName && x.Title_Code == MusicAlbumCode && x.Music_Title_Code != objTitle.Music_Title_Code).Distinct().Count();
                    }

                    Count += countDuplicate;
                }
                if (MusicAlbumCode != 0)
                {
                    if (Movie_Album_Type == "A")
                    {
                        MusicAlbum = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name == MusicAlbumName).Select(x => x.Music_Album_Code).FirstOrDefault();
                    }
                    else if (Movie_Album_Type == "M")
                    {
                        string dealType = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "AL_DealType_Movies").Select(x => x.Parameter_Value).FirstOrDefault();
                        var strArrdealType = dealType.Split(',');
                        MusicAlbum = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name == MusicAlbumName && strArrdealType.Contains(x.Deal_Type_Code.ToString())).Select(x => x.Title_Code).FirstOrDefault();
                    }
                    else if (Movie_Album_Type == "S")
                    {
                        string dealType = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "AL_DealType_Show").Select(x => x.Parameter_Value).FirstOrDefault();
                        var strArrdealType = dealType.Split(',');
                        MusicAlbum = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name == MusicAlbumName && strArrdealType.Contains(x.Deal_Type_Code.ToString())).Select(x => x.Title_Code).FirstOrDefault();
                    }
                }
            }

            Dictionary<string, object> objJson = new Dictionary<string, object>();
            if (!dupStringsCount)
                objJson.Add("ErrorMsg", "Music Title name can not be duplicate");
            else
                objJson.Add("ErrorMsg", "");
            if (Count > 0)
                objJson.Add("Message", objMessageKey.MusicTitlewithsamenamealreadyexists);
            else
                objJson.Add("Message", "");
            if (MusicAlbum == 0)
                objJson.Add("ErrorMessage", objMessageKey.MusicAlbumisnotFound);
            else
                objJson.Add("ErrorMessage", "");
            if (Music_Album_Code != "")
            {
                objJson.Add("MusicAlbumCode", Music_Album_Code);
            }
            else
                objJson.Add("MusicAlbumCode", "");
            return Json(objJson);
        }

        public JsonResult GetTitleName(string keyword)
        {
            var result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type_Code == 1 && x.Title_Name.Contains(keyword))
                         .Select(R => R.Title_Name).Distinct().ToList()
                         .Union(new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name.Contains(keyword)).Select(R => R.Music_Title_Name).Distinct().ToList());
            return Json(result);
        }


        public JsonResult SaveTitle(string MusicTitleName, string MovieAlbumName, string hdnddlLanguage, string hdnMusicLabel, string Movie_Album_Type)
        {
            char[] splitchar = { '~' };
            string[] parts = MusicTitleName.Split(splitchar, StringSplitOptions.RemoveEmptyEntries);
            foreach (string NewMusicTitleName in parts)
            {
                Music_Title objMusicTitle = new Music_Title();
                objMusicTitle.Music_Title_Name = NewMusicTitleName;
                objMusicTitle.Movie_Album = "";
                int Music_Version = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Music_Version_Code").Select(x => x.Parameter_Value).FirstOrDefault());
                objMusicTitle.Music_Version_Code = Music_Version;
                objMusicTitle.EntityState = State.Added;
                //objMusicTitle.Language_Code = Convert.ToInt32(hdnddlLanguage);
                objMusicTitle.Inserted_By = objLoginUser.Users_Code;
                objMusicTitle.Inserted_On = DateTime.Now;
                objMusicTitle.Last_UpDated_Time = DateTime.Now;
                objMusicTitle.Is_Active = "Y";
                objMusicTitle.Public_Domain = "N";
                objMusicTitle.Movie_Album_Type = Movie_Album_Type;
                if (MovieAlbumName != "")
                {
                    if (Movie_Album_Type == "A")
                    {
                        objMusicTitle.Music_Album_Code = Convert.ToInt32(MovieAlbumName);
                    }
                    else
                    {
                        objMusicTitle.Title_Code = Convert.ToInt32(MovieAlbumName);
                    }

                }
                new Music_Title_Service(objLoginEntity.ConnectionStringName).Save(objMusicTitle);
                TempData["MusicTitleCode"] = objMusicTitle.Music_Title_Code;

                Music_Title_Label objMusicLabel = new Music_Title_Label();
                objMusicLabel.Music_Label_Code = Convert.ToInt32(hdnMusicLabel);
                objMusicLabel.Music_Title_Code = objMusicTitle.Music_Title_Code;
                objMusicLabel.Effective_From = Convert.ToDateTime(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Music_Label_Effective_From").Select(i => i.Parameter_Value).FirstOrDefault());
                objMusicLabel.EntityState = State.Added;
                new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).Save(objMusicLabel);


                #region ========= Music Language creation =========
                string[] Language_Codes = hdnddlLanguage.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string languageCodes in Language_Codes)
                {
                    if (languageCodes != "")
                    {
                        int lanCode = Convert.ToInt32(languageCodes);
                        Music_Title_Language objTL = new Music_Title_Language();
                        objTL.EntityState = State.Added;
                        objTL.Music_Title_Code = objMusicTitle.Music_Title_Code;
                        objTL.Music_Language_Code = Convert.ToInt32(languageCodes);
                        //objTitle.Music_Title_Language.Add(objT);
                        new Music_Title_Language_Service(objLoginEntity.ConnectionStringName).Save(objTL);
                    }
                }
                #endregion
            }
            //new Music_Title_Language_Service().
            //Message = "Record Added SuccessFully";
            Message = objMessageKey.RecordAddedSuccessfully;
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            objJson.Add("Message", Message);
            objJson.Add("MusicTitleCode", Convert.ToInt32(TempData["MusicTitleCode"]));
            return Json(objJson);
        }

        public PartialViewResult BindGrid(string searchText, int pageNo, int recordPerPage, string command, string IsMenu)
        {
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            ViewBag.PageNo = objPage_Properties.PageNo;
            List<USP_List_Music_Title_Result> MusicTitleList;
            //if(objPage_Properties.isAdvanced == "Y")
            //    command= "ADVANCE_SEARCH";
            string sqlStr = "";
            string ExactMatchStr = searchText;
            searchText = searchText.Replace("'", "''");
            if (command == "SEARCH")
            {
                string[] commonStr = searchText.Split(' ');
                for (int i = 1; i <= commonStr.Length; i++)
                {
                    if (commonStr[i - 1] != "")
                    {
                        if (i == 1)
                        {
                            sqlStr += " AND Masters_Value like N'%" + commonStr[i - 1] + "%'";
                        }
                        else
                        {
                            sqlStr += " OR Masters_Value like N'%" + commonStr[i - 1] + "%'";
                        }

                    }
                }

                objPage_Properties = null;
                objPage_Properties.isAdvanced = "N";
                MusicTitleList = objUSP.USP_List_Music_Title(sqlStr, objLoginUser.System_Language_Code, pageNo, objRecordCount, "Y", recordPerPage, "", "", "", "", "", "", "", "", "", "", "", "", "", ExactMatchStr).ToList();
                //MusicTitleList = objUSP.USP_List_Music_Title(sqlStr, pageNo, objRecordCount, "Y", "", "", "", "", "", "", "", "", "", "", "", "", "", searchText);

            }
            else if (command != "ADVANCE_SEARCH")
            {
                objPage_Properties = null;
                objPage_Properties.isAdvanced = "N";

                MusicTitleList = objUSP.USP_List_Music_Title(searchText, objLoginUser.System_Language_Code, pageNo, objRecordCount, "Y", recordPerPage, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "").ToList();
            }
            else
            {
                objPage_Properties.AlbumsCodes_Search = objPage_Properties.AlbumsCodes_Search.Trim().Trim('﹐').Trim();
                string[] terms = objPage_Properties.AlbumsCodes_Search.Split('﹐');
                objPage_Properties.AlbumsCodes_Search = string.Join(",", terms);

                objPage_Properties.MusicTitleName_Search = objPage_Properties.MusicTitleName_Search.Trim().Trim('﹐').Trim();
                string[] termsMTN = objPage_Properties.MusicTitleName_Search.Split('﹐');
                objPage_Properties.MusicTitleName_Search = string.Join(",", termsMTN);

                objPage_Properties.isAdvanced = "Y";
                MusicTitleList = objUSP.USP_List_Music_Title("", objLoginUser.System_Language_Code, pageNo, objRecordCount, "Y", recordPerPage,
                    objPage_Properties.StarCastCodes_Search, objPage_Properties.LanguagesCodes_Search, objPage_Properties.AlbumsCodes_Search,
                    objPage_Properties.GenresCodes_Search, objPage_Properties.MusicLabelCodes_Search, objPage_Properties.YearOfRelease,
                    objPage_Properties.SingerCodes_Search, objPage_Properties.ComposerCodes_Search, objPage_Properties.LyricistCodes_Search,
                    objPage_Properties.MusicTitleName_Search, objPage_Properties.ThemeCodes_Search, objPage_Properties.Music_Tag_Search, objPage_Properties.Public_Domain, "", objPage_Properties.Movie_Album_Type).ToList();

            }

            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = pageNo;
            PageNo = pageNo;
            objPage_Properties.PageNo = pageNo;
            objPage_Properties.Page_Size = recordPerPage;
            objPage_Properties.SearchText = ExactMatchStr;
            objPage_Properties.MusicTitleName = searchText;
            ViewBag.Command = command;
            ViewBag.searchText = searchText;

            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForMusic_Title), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string c = addRights.FirstOrDefault();
            ViewBag.AddVisibility = c;
            return PartialView("_List_Music_Title", MusicTitleList);

        }
        public void AdvanceSearch(string SrchStarCast = "", string SrchLanguage = "", string SrchAlbum = "", string SrchGenres = "", string SrchMusicLabel = "", string SrchTheme = "",
            string SrchYearOfRelease = "", string SrchSinger = "", string SrchComposer = "", string SrchLyricist = "", string SrchMusic = "", string SrchMusicTag = "", string SrchMusicAlbumName = "", string SrchPublicDomain = "", string SrchMovieAlbumType = "")
        {
            objPage_Properties.StarCastCodes_Search = SrchStarCast;
            objPage_Properties.LanguagesCodes_Search = SrchLanguage;
            objPage_Properties.GenresCodes_Search = SrchGenres;
            objPage_Properties.MusicLabelCodes_Search = SrchMusicLabel;
            //objPage_Properties.AlbumsCodes_Search = SrchAlbum;
            objPage_Properties.AlbumsCodes_Search = SrchMusicAlbumName;
            objPage_Properties.YearOfRelease = SrchYearOfRelease;
            objPage_Properties.SingerCodes_Search = SrchSinger;
            objPage_Properties.ComposerCodes_Search = SrchComposer;
            objPage_Properties.LyricistCodes_Search = SrchLyricist;
            objPage_Properties.MusicTitleName_Search = SrchMusic;
            objPage_Properties.ThemeCodes_Search = SrchTheme;
            objPage_Properties.Music_Tag_Search = SrchMusicTag;
            objPage_Properties.MusicAlbumName = SrchMusicAlbumName;
            objPage_Properties.Public_Domain = SrchPublicDomain;
            objPage_Properties.isAdvanced = "Y";
            objPage_Properties.Movie_Album_Type = SrchMovieAlbumType;
        }
        public void ExportToExcel(string TitleName = "", int PageIndex = 0)//string DealTypeCode = "1", 
        {
            ReportViewer1 = new ReportViewer();
            if (TitleName == "")
                TitleName = " ";
            string extension;
            string encoding;
            string mimeType;
            string[] streams;
            Warning[] warnings;
            ReportParameter[] parm = new ReportParameter[20];
            int pageSize = 10;
            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);

            PageNo = Convert.ToInt32(Request.QueryString["Page_No"] != null ? Request.QueryString["Page_No"].ToString() : "1");
            PageNo = PageIndex + 1;
            if (objPage_Properties.MusicTitleName == null)
                objPage_Properties.MusicTitleName = "";

            if (objPage_Properties.StarCastCodes_Search == null && objPage_Properties.LanguagesCodes_Search == null
                && objPage_Properties.AlbumsCodes_Search == null && objPage_Properties.GenresCodes_Search == null && objPage_Properties.MusicLabelCodes_Search == null &&
               objPage_Properties.YearOfRelease == null && objPage_Properties.SingerCodes_Search == null && objPage_Properties.ComposerCodes_Search == null &&
                objPage_Properties.LyricistCodes_Search == null && objPage_Properties.MusicTitleName_Search == null && objPage_Properties.ThemeCodes_Search == null && objPage_Properties.Public_Domain == null)
            {
                objPage_Properties.StarCastCodes_Search = "";
                objPage_Properties.LanguagesCodes_Search = "";
                objPage_Properties.AlbumsCodes_Search = "";
                objPage_Properties.GenresCodes_Search = "";
                objPage_Properties.MusicLabelCodes_Search = "";
                objPage_Properties.YearOfRelease = "";
                objPage_Properties.SingerCodes_Search = "";
                objPage_Properties.ComposerCodes_Search = "";
                objPage_Properties.LyricistCodes_Search = "";
                objPage_Properties.MusicTitleName_Search = "";
                objPage_Properties.ThemeCodes_Search = "";
                objPage_Properties.Public_Domain = "";
            }
            if (objPage_Properties.Music_Tag_Search == null)
                objPage_Properties.Music_Tag_Search = "";

            string sqlStr = "";
            string ExactMatchStr = Convert.ToString(objPage_Properties.SearchText);
            string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            objPage_Properties.MusicTitleName = objPage_Properties.MusicTitleName.Replace("'", "''");

            string[] commonStr = objPage_Properties.MusicTitleName.Split(' ');
            for (int i = 1; i <= commonStr.Length; i++)
            {
                if (commonStr[i - 1] != "")
                {
                    if (i == 1)
                    {
                        sqlStr += " AND Masters_Value like N'%" + commonStr[i - 1] + "%'";
                    }
                    else
                    {
                        sqlStr += " OR Masters_Value like N'%" + commonStr[i - 1] + "%'";
                    }

                }
            }
            parm[0] = new ReportParameter("MusicTitleName", sqlStr);
            parm[1] = new ReportParameter("PageNo", "");
            parm[2] = new ReportParameter("SysLanguageCode", SysLanguageCode);
            parm[3] = new ReportParameter("RecordCount", Convert.ToString(0));
            parm[4] = new ReportParameter("IsPaging", "N");
            parm[5] = new ReportParameter("PageSize", "");
            parm[6] = new ReportParameter("StarCastCode", objPage_Properties.StarCastCodes_Search);
            parm[7] = new ReportParameter("LanguageCode", objPage_Properties.LanguagesCodes_Search);
            parm[8] = new ReportParameter("AlbumCode", objPage_Properties.AlbumsCodes_Search);
            parm[9] = new ReportParameter("GenresCode", objPage_Properties.GenresCodes_Search);
            parm[10] = new ReportParameter("MusicLabelCode", objPage_Properties.MusicLabelCodes_Search);
            parm[11] = new ReportParameter("YearOfRelease", objPage_Properties.YearOfRelease);
            parm[12] = new ReportParameter("SingerCode", objPage_Properties.SingerCodes_Search);
            parm[13] = new ReportParameter("ComposerCode", objPage_Properties.ComposerCodes_Search);
            parm[14] = new ReportParameter("LyricistCode", objPage_Properties.LyricistCodes_Search);
            parm[15] = new ReportParameter("MusicNameText", objPage_Properties.MusicTitleName_Search);
            parm[16] = new ReportParameter("ThemeCode", objPage_Properties.ThemeCodes_Search);
            parm[17] = new ReportParameter("MusicTag", objPage_Properties.Music_Tag_Search);
            parm[18] = new ReportParameter("ExactMatch", ExactMatchStr);
            parm[19] = new ReportParameter("PublicDomain", objPage_Properties.Public_Domain);
            ReportCredential();
            ReportViewer1.ServerReport.ReportPath = string.Empty;
            if (ReportViewer1.ServerReport.ReportPath == "")
            {
                ReportSetting objRS = new ReportSetting();
                ReportViewer1.ServerReport.ReportPath = objRS.GetReport("rptListMusicTitle");
            }
            ReportViewer1.ServerReport.SetParameters(parm);
            Byte[] buffer = ReportViewer1.ServerReport.Render("EXCELOPENXML", null, out extension, out encoding, out mimeType, out streams, out warnings);
            Response.Clear();
            Response.ContentType = "application/excel";
            Response.AddHeader("Content-disposition", "filename=MusicTitleList.xls");
            Response.OutputStream.Write(buffer, 0, buffer.Length);
            Response.End();
        }

        public void ReportCredential()
        {
            var rptCredetialList = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.IsActive == "Y" && w.Parameter_Name.Contains("RPT_")).ToList();

            string ReportingServer = rptCredetialList.Where(x => x.Parameter_Name == "RPT_ReportingServer").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["ReportingServer"];
            string IsCredentialRequired = rptCredetialList.Where(x => x.Parameter_Name == "RPT_IsCredentialRequired").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["IsCredentialRequired"];

            if (IsCredentialRequired.ToUpper() == "TRUE")
            {
                string CredentialPassWord = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserPassWord").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["CredentialsUserPassWord"];
                string CredentialUser = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialsUserName"];
                string CredentialdomainName = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialdomainName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialdomainName"];

                ReportViewer1.ServerReport.ReportServerCredentials = new ReportServerCredentials(CredentialUser, CredentialPassWord, CredentialdomainName);
            }

            ReportViewer1.Visible = true;
            ReportViewer1.ServerReport.Refresh();
            ReportViewer1.ProcessingMode = ProcessingMode.Remote;
            if (ReportViewer1.ServerReport.ReportServerUrl.OriginalString == "http://localhost/reportserver")
            {
                ReportViewer1.ServerReport.ReportServerUrl = new Uri(ReportingServer);
            }
        }

        public JsonResult SaveMusicTitle(string MusicLabelName)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            try
            {
                int count = new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Label_Name == MusicLabelName).ToList().Count();

                if (count > 0)
                    throw new DuplicateRecordException("Record Already Exists");

                RightsU_Entities.Music_Label objMusicLabel = new RightsU_Entities.Music_Label();
                dynamic resultSet;

                objMusicLabel.Music_Label_Name = MusicLabelName;
                objMusicLabel.Inserted_By = objLoginUser.Users_Code;
                objMusicLabel.Inserted_On = DateTime.Now;
                objMusicLabel.Is_Active = "Y";


                if (objMusicLabel.Music_Label_Code > 0)
                    objMusicLabel.EntityState = State.Modified;
                else
                    objMusicLabel.EntityState = State.Added;

                //NEED TO CHANGE
                dynamic resultSetML;
                new Music_Label_Service(objLoginEntity.ConnectionStringName).Save(objMusicLabel, out resultSetML);
                objJson.Add("Value", objMusicLabel.Music_Label_Code);
                objJson.Add("Text", objMusicLabel.Music_Label_Name);
                //objMusicAlbum = null;
            }
            catch (DuplicateRecordException)
            {
                //resposeText = "duplicate";
                objJson.Add("MusicLabelError", "Record Already Exists.");
            }
            catch (Exception)
            {
                objJson.Add("MusicLabelError", "Error");
            }

            return Json(objJson);
        }

        public JsonResult SaveCommonField(string FieldName, string Type)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            try
            {
                int count = 0;
                if (Type == "Music Theme")
                    count = new Music_Theme_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Theme_Name == FieldName.Trim()).ToList().Count();
                if (Type == "Music Language")
                    count = new Music_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Language_Name == FieldName.Trim()).ToList().Count();

                if (count > 0)
                    throw new DuplicateRecordException("Record Already Exists");

                if (Type == "Music Theme")
                {
                    Music_Theme objMusicTheme = new Music_Theme();
                    objMusicTheme.Music_Theme_Name = FieldName;
                    objMusicTheme.Inserted_On = DateTime.Now;
                    objMusicTheme.Inserted_By = objLoginUser.Users_Code;
                    objMusicTheme.Is_Active = "Y";
                    objMusicTheme.EntityState = State.Added;

                    //NEED TO CHANGE
                    dynamic resultSetMT;
                    new Music_Theme_Service(objLoginEntity.ConnectionStringName).Save(objMusicTheme, out resultSetMT);
                    objJson.Add("Value", objMusicTheme.Music_Theme_Code);
                    objJson.Add("Text", objMusicTheme.Music_Theme_Name);
                }
                if (Type == "Music Language")
                {
                    Music_Language objMusicLan = new Music_Language();
                    objMusicLan.Language_Name = FieldName;
                    objMusicLan.Inserted_On = DateTime.Now;
                    objMusicLan.Inserted_By = objLoginUser.Users_Code;
                    objMusicLan.Is_Active = "Y";

                    //NEED TO CHANGE
                    dynamic resultSetML;
                    new Music_Language_Service(objLoginEntity.ConnectionStringName).Save(objMusicLan, out resultSetML);
                    objJson.Add("Value", objMusicLan.Music_Language_Code);
                    objJson.Add("Text", objMusicLan.Language_Name);
                }
                //RightsU_Entities.Music_Label objMusicLabel = new RightsU_Entities.Music_Label();
                //dynamic resultSet;

                //objMusicLabel.Music_Label_Name = MusicLabelName;
                //objMusicLabel.Inserted_By = objLoginUser.Users_Code;
                //objMusicLabel.Inserted_On = DateTime.Now;
                //objMusicLabel.Is_Active = "Y";


                //if (objMusicLabel.Music_Label_Code > 0)
                //    objMusicLabel.EntityState = State.Modified;
                //else
                //    objMusicLabel.EntityState = State.Added;

                //new Music_Label_Service(objLoginEntity.ConnectionStringName).Save(objMusicLabel);
                //objJson.Add("Value", objMusicLabel.Music_Label_Code);
                //objJson.Add("Text", objMusicLabel.Music_Label_Name);
                //objMusicAlbum = null;
            }
            catch (DuplicateRecordException e)
            {
                //resposeText = "duplicate";
                objJson.Add("MusicLabelError", e.Message);
            }
            catch (Exception)
            {
                objJson.Add("MusicLabelError", "Error");
            }

            return Json(objJson);
        }

        [HttpPost]
        public ActionResult Save(RightsU_Entities.Music_Title objTitleModel, string Language_Code, string Music_Type_Code, string hdnLanguage, string hdnTheme
            , string hdnSinger, string hdnComposer, string hdnLyricist, string Music_Label_Code, string Music_Version_Code, string Genres_Code, string hdnStarCast, string Music_Album_Name, string hdnmode, string Public_Domain, int? hdnMusicTitleCode)
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusic_Title);
            HttpPostedFileBase file = Request.Files["uploadFile"];
            int Music_Album_Code = 0;

            if (objTitleModel.Movie_Album_Type == "M")
            {
                string dealType = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "AL_DealType_Movies").Select(x => x.Parameter_Value).FirstOrDefault();
                var strArrdealType = dealType.Split(',');
                Music_Album_Code = Convert.ToInt32(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name == Music_Album_Name && strArrdealType.Contains(x.Deal_Type_Code.ToString())).Select(x => x.Title_Code).FirstOrDefault());
            }
            else if (objTitleModel.Movie_Album_Type == "S")
            {
                string dealType = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "AL_DealType_Show").Select(x => x.Parameter_Value).FirstOrDefault();
                var strArrdealType = dealType.Split(',');
                Music_Album_Code = Convert.ToInt32(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name == Music_Album_Name && strArrdealType.Contains(x.Deal_Type_Code.ToString())).Select(x => x.Title_Code).FirstOrDefault());
            }
            else if (objTitleModel.Movie_Album_Type == "A")
            {
                Music_Album_Code = Convert.ToInt32(new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name == Music_Album_Name).Select(x => x.Music_Album_Code).FirstOrDefault());
            }

            int TitleCode = 0;
            if (hdnmode != "C")
            {
                TitleCode = Convert.ToInt32(objTitleModel.Music_Title_Code);
                objTitle = objTitleS.GetById(objTitleModel.Music_Title_Code);
            }

            objTitle = objTitleS.GetById(TitleCode);
            string filename = DateTime.Now.Ticks.ToString() + "_";
            filename += file.FileName;
            if (filename != "" && file.FileName != "")
            {
                file.SaveAs(Server.MapPath(ConfigurationManager.AppSettings["TitleImagePath"] + filename));
                objTitle.Image_Path = filename;
            }

            objTitle.Music_Title_Name = objTitleModel.Music_Title_Name;
            objTitle.Release_Year = objTitleModel.Release_Year;
            objTitle.Duration_In_Min = objTitleModel.Duration_In_Min;
            objTitle.Last_UpDated_Time = DateTime.Now;
            objTitle.Last_Action_By = objLoginUser.Users_Code;

            objTitle.Music_Tag = objTitleModel.Music_Tag;
            objTitle.Public_Domain = objTitleModel.Public_Domain;

            if (objTitleModel.Movie_Album_Type == "M")
            {
                if (Music_Album_Name != "")
                {
                    objTitle.Title_Code = Music_Album_Code;
                    objTitle.Music_Album_Code = null;
                }
            }
            else if (objTitleModel.Movie_Album_Type == "S")
            {
                if (Music_Album_Name != "")
                {
                    objTitle.Title_Code = Music_Album_Code;
                    objTitle.Music_Album_Code = null;
                }
            }
            else if (objTitleModel.Movie_Album_Type == "A")
            {
                if (Music_Album_Name != "")
                {
                    objTitle.Music_Album_Code = Music_Album_Code;
                    objTitle.Title_Code = null;
                }
            }

            objTitle.Movie_Album_Type = objTitleModel.Movie_Album_Type;

            if (Music_Type_Code != "0")
                objTitle.Music_Type_Code = Convert.ToInt32(Music_Type_Code);
            else
                objTitle.Music_Type_Code = null;

            if (Music_Version_Code != "0")
                objTitle.Music_Version_Code = Convert.ToInt32(Music_Version_Code);
            else
                objTitle.Music_Version_Code = null;

            if (Genres_Code != "0")
                objTitle.Genres_Code = Convert.ToInt32(Genres_Code);
            else
                objTitle.Genres_Code = null;

            #region ========= Music Label creation =========
            if (Music_Label_Code != "0" && Music_Label_Code != null)
            {
                objTitle.Music_Title_Label.ToList().ForEach(i => i.EntityState = State.Deleted);
                string Music_Label_Codes = Music_Label_Code;
                Music_Title_Label_Service objMTLService = new Music_Title_Label_Service(objLoginEntity.ConnectionStringName);
                Music_Title_Label objTL = new Music_Title_Label();
                objTL.Music_Label_Code = Convert.ToInt32(Music_Label_Codes);
                if (!string.IsNullOrEmpty(Music_Label_Codes) && TitleCode == 0)
                {
                    Music_Title_Label objT = (Music_Title_Label)objTitle.Music_Title_Label.Where(t => t.Music_Label_Code == Convert.ToInt32(Music_Label_Codes) && t.Effective_From != null).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Music_Title_Label();
                    if (objT.Music_Label_Code > 0)
                    {
                        objT.EntityState = State.Unchanged;
                        objTitle.Music_Title_Label.Add(objT);
                    }
                    else
                    {
                        Music_Title_Label objMTL_Last = objMTLService.SearchFor(w => w.Music_Title_Code == hdnMusicTitleCode && w.Music_Label_Code == objTL.Music_Label_Code && w.Music_Label_Code == objTL.Music_Label_Code && w.Effective_From != null && w.Effective_To == null).
                          OrderByDescending(o => o.Effective_From).FirstOrDefault();
                        objT.EntityState = State.Added;
                        if (objMTL_Last == null)
                        {
                            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
                            objT.Effective_From = Convert.ToDateTime(objSystemParamService.SearchFor(p => p.Parameter_Name == "Music_Label_Effective_From").ToList().FirstOrDefault().Parameter_Value);
                        }
                        else
                        {
                            objT.Effective_From = objMTL_Last.Effective_From;
                        }
                        objT.Music_Title_Code = TitleCode;
                        objT.Music_Label_Code = Convert.ToInt32(Music_Label_Codes);
                        objTitle.Music_Title_Label.Add(objT);
                    }
                }
            }

            #endregion
            objTitle.Music_Title_Talent.ToList().ForEach(i => i.EntityState = State.Deleted);
            objTitle.Music_Title_Language.ToList().ForEach(i => i.EntityState = State.Deleted);
            objTitle.Music_Title_Theme.ToList().ForEach(i => i.EntityState = State.Deleted);

            #region ========= Singer creation =========
            string[] Singer_Codes = hdnSinger.Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string singercodes in Singer_Codes)
            {
                if (singercodes != "")
                {
                    Music_Title_Talent objT = (Music_Title_Talent)objTitle.Music_Title_Talent.Where(t => t.Talent_Code == Convert.ToInt32(singercodes) && t.Role_Code == GlobalParams.Role_Code_Singer).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Music_Title_Talent();
                    if (objT.Music_Title_Talent_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Music_Title_Code = TitleCode;
                        objT.Talent_Code = Convert.ToInt32(singercodes);
                        objT.Role_Code = GlobalParams.Role_Code_Singer;
                        objTitle.Music_Title_Talent.Add(objT);
                    }
                }
            }
            #endregion

            #region ========= Composer creation =========
            string[] Composer_Codes = hdnComposer.Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string composercodes in Composer_Codes)
            {
                if (composercodes != "")
                {
                    Music_Title_Talent objT = (Music_Title_Talent)objTitle.Music_Title_Talent.Where(t => t.Talent_Code == Convert.ToInt32(composercodes) && t.Role_Code == GlobalParams.Role_code_MusicComposer).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Music_Title_Talent();
                    if (objT.Music_Title_Talent_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Talent_Code = Convert.ToInt32(composercodes);
                        objT.Music_Title_Code = TitleCode;
                        objT.Role_Code = GlobalParams.Role_code_MusicComposer;
                        objTitle.Music_Title_Talent.Add(objT);
                    }
                }
            }
            #endregion

            #region ========= Lyricist creation =========
            string[] Lyricist_Codes = hdnLyricist.Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string lyricistCodes in Lyricist_Codes)
            {
                if (lyricistCodes != "")
                {
                    Music_Title_Talent objT = (Music_Title_Talent)objTitle.Music_Title_Talent.Where(t => t.Talent_Code == Convert.ToInt32(lyricistCodes) && t.Role_Code == GlobalParams.Role_code_lyricist).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Music_Title_Talent();
                    if (objT.Music_Title_Talent_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Music_Title_Code = TitleCode;
                        objT.Talent_Code = Convert.ToInt32(lyricistCodes);
                        objT.Role_Code = GlobalParams.Role_code_lyricist;
                        objTitle.Music_Title_Talent.Add(objT);
                    }
                }
            }
            #endregion

            #region ========= Movie Star Cast creation =========

            string[] StarCast_Codes = hdnStarCast.Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string starCastcodes in StarCast_Codes)
            {
                if (starCastcodes != "")
                {
                    Music_Title_Talent objT = (Music_Title_Talent)objTitle.Music_Title_Talent.Where(t => t.Talent_Code == Convert.ToInt32(starCastcodes) && t.Role_Code == GlobalParams.Role_code_StarCast).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Music_Title_Talent();
                    if (objT.Music_Title_Talent_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Music_Title_Code = TitleCode;
                        objT.Talent_Code = Convert.ToInt32(starCastcodes);
                        objT.Role_Code = GlobalParams.Role_code_StarCast;
                        objTitle.Music_Title_Talent.Add(objT);
                    }
                }
            }
            #endregion

            #region ========= Music Language creation =========
            string[] Language_Codes = hdnLanguage.Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string languageCodes in Language_Codes)
            {
                if (languageCodes != "")
                {
                    int lanCode = Convert.ToInt32(languageCodes);
                    Music_Title_Language objT = (Music_Title_Language)objTitle.Music_Title_Language.Where(t => t.Music_Language_Code == lanCode).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Music_Title_Language();
                    if (objT.Music_Title_Language_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Music_Title_Code = TitleCode;
                        objT.Music_Language_Code = Convert.ToInt32(languageCodes);
                        objTitle.Music_Title_Language.Add(objT);
                    }
                }
            }
            #endregion

            #region ========= Theme creation =========
            if (hdnTheme != null)
            {
                string[] Theme_Codes = hdnTheme.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string themeCodes in Theme_Codes)
                {
                    if (themeCodes != "")
                    {
                        int themeCode = Convert.ToInt32(themeCodes);
                        Music_Title_Theme objT = (Music_Title_Theme)objTitle.Music_Title_Theme.Where(t => t.Music_Theme_Code == themeCode).Select(i => i).FirstOrDefault();
                        if (objT == null)
                            objT = new Music_Title_Theme();
                        if (objT.Music_Title_Theme_Code > 0)
                            objT.EntityState = State.Unchanged;
                        else
                        {
                            objT.EntityState = State.Added;
                            objT.Music_Title_Code = TitleCode;
                            objT.Music_Theme_Code = Convert.ToInt32(themeCodes);
                            objTitle.Music_Title_Theme.Add(objT);
                        }
                    }
                }
            }
            #endregion

            objTitleModel.Music_Title_Code = TitleCode;
            if (objTitle.Music_Title_Code > 0)
                objTitle.EntityState = State.Modified;
            else
            {
                objTitle.EntityState = State.Added;
                objTitle.Is_Active = "Y";
            }



            objTitleS.Save(objTitle);
            objTitleS = null;
            if (objTitle.EntityState == State.Added)
            {
                Message = objMessageKey.RecordAddedSuccessfully;
            }
            else
            {
                Message = objMessageKey.MusicTrackupdatedsuccessfully;
            }
            DBUtil.Release_Record(Record_Locking_Code);
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForMusic_Title), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string c = addRights.FirstOrDefault();
            ViewBag.VisibilityforAdd = c;
            ViewBag.Message = objMessageKey.MusicTrackupdatedsuccessfully;
            PageNo = (PageNo == 0) ? 1 : PageNo;
            return RedirectToAction("List", "Music_Title", new { @Page_No = PageNo, @SearchedTitle = SearchedTitle_EDIT, @IsMenu = "N" });
        }

        //public JsonResult ValidateIsDuplicate(string MusicTitleName)
        //{
        //    MusicTitleName = MusicTitleName.Trim(' ');
        //    int Count = 0;
        //    Count = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name == MusicTitleName && x.Music_Title_Code != objTitle.Music_Title_Code).Distinct().Count();
        //    Dictionary<string, object> objJson = new Dictionary<string, object>();
        //    if (Count > 0)
        //        objJson.Add("Message", "Music Title with same name already exists");
        //    else
        //        objJson.Add("Message", "");

        //    return Json(objJson);
        //}

        public ActionResult Music_Title_Import()
        {
            List<SelectListItem> lstFliter = new List<SelectListItem>();
            lstFliter.Add(new SelectListItem { Text = "All", Value = "A", Selected = true });
            lstFliter.Add(new SelectListItem { Text = "Error", Value = "E" });
            lstFliter.Add(new SelectListItem { Text = "In Process", Value = "Q" });
            lstFliter.Add(new SelectListItem { Text = "Resolve Conflict", Value = "R" });
            lstFliter.Add(new SelectListItem { Text = "Success", Value = "S" });
            ViewBag.FilterBy = lstFliter;
            ViewBag.FilterbyStatus = TempData["FilterByStatus"] == null ? "A" : TempData["FilterByStatus"];
            int PageNo = Convert.ToInt32(TempData["PageNoBack"]);
            ViewBag.PageNoBack = PageNo == 0 ? 0 : PageNo - 1;
            ViewBag.Query_String_Page_No = objPage_Properties.PageNo;
            ViewBag.Page_Size = objPage_Properties.Page_Size;
            ViewBag.searchText = objPage_Properties.SearchText;
            ViewBag.txtPageSizeBack = TempData["txtPageSizeBack"] == null ? 10 : TempData["txtPageSizeBack"];
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusic_Title);
            Session["lstError_Session"] = null;
            return View("Music_Title_Import", objPage_Properties);
        }
        public void SampleDownload()
        {
            var MusicTitleVersion = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "SPN_Music_Version").Select(w => w.Parameter_Value).SingleOrDefault();
            ViewBag.IsMuciVersionSPN = MusicTitleVersion;
            string message = "";
            string filePath = "";
            // string filePath = (Server.MapPath("~") + "\\Download\\Music_Title_Import_Sample.xlsx").Replace("\\\\", "\\");
            if (MusicTitleVersion == "Y")
            {
                filePath = Server.MapPath("~") + "\\Download\\SPN_Music_Title_Import_Sample.xlsx";
            }
            else
            {
                filePath = Server.MapPath("~") + "\\Download\\Music_Title_Import_Sample.xlsx";
            }
            try
            {
                if (System.IO.File.Exists(filePath))
                {
                    FileInfo objFileInfo = new FileInfo(filePath);
                    WebClient client = new WebClient();
                    Byte[] buffer = client.DownloadData(filePath);
                    Response.Clear();
                    Response.ContentType = "application/ms-excel";
                    Response.AddHeader("content-disposition", "Attachment;filename=" + objFileInfo.Name);
                    Response.BinaryWrite(buffer);
                    Response.End();
                }
            }
            catch (FileNotFoundException)
            {

            }
        }

        public PartialViewResult UploadTitle(HttpPostedFileBase InputFile)
        {
            Session["SearchedMusicTitle_EDIT"] = null;
            string message = "";
            string sheetName = "Sheet1";
            int pageSize = 10;
            int PageNo = 0;
            List<USP_Insert_Music_Title_Import_UDT> lstRE = new List<USP_Insert_Music_Title_Import_UDT>();
            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var PostedFile = InputFile;
                //string fullPath = (Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"]);
                string fullPath = (Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"]);
                string ext = System.IO.Path.GetExtension(PostedFile.FileName);
                if (ext == ".xlsx" || ext == ".xls")
                {
                    ExcelReader objExcelReader = new ExcelReader();
                    DataSet ds = new DataSet();

                    try
                    {
                        //throw new Exception("Anchal " + fullPath);
                        string errorStr = "";
                        //arrSameSheetDataForDuplicate = new ArrayList();


                        string strActualFileNameWithDate;
                        // string path = senderWebForm.Request.ServerVariables["APPL_PHYSICAL_PATH"];
                        string strFileName = System.IO.Path.GetFileName(PostedFile.FileName);
                        //If excel sheet is of extension other than ".xls" ~or~ path is wrong for file to be uploaded.
                        if ((ext.ToLower() != ".xls" && ext.ToLower() != ".xlsx") || (PostedFile.ContentLength <= 0))
                        {
                            //errorStr = "Please upload Excel Sheet named as " + sheetName.Trim() + " only with .xlsx extension.";
                            errorStr = objMessageKey.PleaseuploadExcelSheetnamedas + " " + sheetName.Trim() + " " + objMessageKey.onlywithxlsxextension;
                            //return true;
                        }
                        strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
                        string fullpathname = fullPath + strActualFileNameWithDate; ;

                        // throw new Exception("Anchal " + fullpathname);
                        PostedFile.SaveAs(fullpathname);
                        OleDbConnection cn;
                        ds = new DataSet();
                        try
                        {
                            cn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fullpathname + ";Extended Properties='Excel 12.0;HDR=No;IMEX=1'");
                            OleDbCommand cmdExcel = new OleDbCommand();
                            OleDbDataAdapter oda = new OleDbDataAdapter();
                            DataTable dt = new DataTable();
                            cmdExcel.Connection = cn;

                            //Get the name of First Sheet
                            cn.Open();
                            DataTable dtExcelSchema;
                            dtExcelSchema = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                            string SheetName = dtExcelSchema.Rows[0]["TABLE_NAME"].ToString();
                            cn.Close();
                            OleDbDataAdapter da = new OleDbDataAdapter("Select * From [" + SheetName + "]", cn);
                            da.Fill(ds);
                        }
                        catch (Exception ex)
                        {
                            //If error in select of sheet data.....
                            //errorStr = "Please upload excel sheet named as \\'" + sheetName.Trim() + "\\'";
                            errorStr = objMessageKey.PleaseuploadExcelSheetnamedas + " \\'" + sheetName.Trim() + "\\'";
                        }
                        finally
                        {
                            //Always delete uploaded excel file from folder.
                            System.IO.File.Delete(fullpathname.Trim());
                        }
                        if (ds.Tables.Count > 0)
                        {
                            for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                            {
                                string ss = Convert.ToString(ds.Tables[0].Rows[0][j]);
                                if (Convert.ToString(ds.Tables[0].Rows[0][j]) != "")
                                    ds.Tables[0].Columns[j].ColumnName = Convert.ToString(ds.Tables[0].Rows[0][j]);
                            }
                            ds.Tables[0].Rows.RemoveAt(0);
                            for (int i = ds.Tables[0].Rows.Count; i >= 1; i--)
                            {
                                int cnt = 0;
                                DataRow currentRow = ds.Tables[0].Rows[i - 1];
                                foreach (var colValue in currentRow.ItemArray)
                                {
                                    if (string.IsNullOrEmpty(colValue.ToString()))
                                        cnt++;
                                    if (ds.Tables[0].Columns.Count == cnt)
                                    {
                                        ds.Tables[0].Rows.RemoveAt(i - 1);
                                        break;
                                    }
                                }
                            }
                        }



                        if (ds.Tables[0].Columns[1].ColumnName != "Music Track" || ds.Tables[0].Columns[2].ColumnName != "Length"
                            || ds.Tables[0].Columns[3].ColumnName != "Movie/Album" || ds.Tables[0].Columns[4].ColumnName != "Singer"
                            || ds.Tables[0].Columns[5].ColumnName != "Lyricist" || ds.Tables[0].Columns[6].ColumnName != "Music Composer"
                            || ds.Tables[0].Columns[7].ColumnName != "Music Language" || ds.Tables[0].Columns[8].ColumnName != "Music Label"
                            || ds.Tables[0].Columns[9].ColumnName != "Year of Release" || ds.Tables[0].Columns[10].ColumnName != "Music Type"
                            || ds.Tables[0].Columns[11].ColumnName != "Genres" || ds.Tables[0].Columns[12].ColumnName != "Song Star Cast"
                            || ds.Tables[0].Columns[13].ColumnName != "Music Version" || ds.Tables[0].Columns[14].ColumnName != "Effective Start Date (DD-MMM-YYYY)"
                            || ds.Tables[0].Columns[15].ColumnName != "Music Theme" || ds.Tables[0].Columns[16].ColumnName != "Music Tag"
                            || ds.Tables[0].Columns[17].ColumnName != "Movie Star Cast" || ds.Tables[0].Columns[18].ColumnName != "Movie/Album Type")
                        {
                            //message = "Please Don't Modify the name of the field in excel File";
                            message = objMessageKey.PleaseDontModifythenameofthefieldinexcelFile;
                        }
                        else
                        {
                            if (ds.Tables[0].Columns.Count >= 18)
                            {
                                if (ds.Tables[0].Rows.Count > 0)
                                {
                                    List<Music_Title_Import_UDT> lst_Title_Import_UDT = new List<Music_Title_Import_UDT>();
                                    foreach (DataRow row in ds.Tables[0].Rows)
                                    {
                                        Music_Title_Import_UDT obj_Title_Import_UDT = new Music_Title_Import_UDT();
                                        obj_Title_Import_UDT.Music_Title_Name = row["Music Track"].ToString();
                                        obj_Title_Import_UDT.Duration = row["Length"].ToString();
                                        obj_Title_Import_UDT.Movie_Album = row["Movie/Album"].ToString();
                                        obj_Title_Import_UDT.Singers = row["Singer"].ToString();
                                        obj_Title_Import_UDT.Lyricist = row["Lyricist"].ToString();
                                        obj_Title_Import_UDT.Music_Director = row["Music Composer"].ToString();
                                        obj_Title_Import_UDT.Title_Language = row["Music Language"].ToString();
                                        obj_Title_Import_UDT.Music_Label = row["Music Label"].ToString();
                                        obj_Title_Import_UDT.Year_of_Release = row["Year of Release"].ToString();
                                        obj_Title_Import_UDT.Title_Type = row["Music Type"].ToString();
                                        obj_Title_Import_UDT.Genres = row["Genres"].ToString();
                                        obj_Title_Import_UDT.Star_Cast = row["Song Star Cast"].ToString();
                                        obj_Title_Import_UDT.Music_Version = row["Music Version"].ToString();
                                        obj_Title_Import_UDT.Effective_Start_Date = row["Effective Start Date (DD-MMM-YYYY)"].ToString();
                                        obj_Title_Import_UDT.Theme = row["Music Theme"].ToString();
                                        obj_Title_Import_UDT.Music_Tag = row["Music Tag"].ToString();
                                        obj_Title_Import_UDT.Movie_Star_Cast = row["Movie Star Cast"].ToString();
                                        obj_Title_Import_UDT.Music_Album_Type = row["Movie/Album Type"].ToString();
                                        lst_Title_Import_UDT.Add(obj_Title_Import_UDT);
                                    }

                                    lstError = new USP_Service(objLoginEntity.ConnectionStringName).USP_Insert_Music_Title_Import_UDT(lst_Title_Import_UDT, Convert.ToInt32(objLoginUser.Users_Code)).ToList();
                                    if (lstError.Count == 0)
                                    {
                                        //message = "Data Saved successfully";
                                        message = objMessageKey.DataSavedsuccessfully;

                                    }
                                    // return PartialView("_TitleImport_List", lstRE);
                                }
                                else
                                {
                                    // message = "please Fill the Data in the Excel File";
                                    message = objMessageKey.PleaseFillTheDataIntheExcelFile;
                                }
                            }
                            else
                            {
                                //message = "please Fill Correct Data in the Excel File";
                                message = objMessageKey.PleaseFillCorrectDataInTheExcelFile;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        message = ex.Message;
                    }
                }
                else
                {
                    message = objMessageKey.PleaseSelectExcelFile + "...";
                }

            }
            else
            {
                message = objMessageKey.PleaseSelectExcelFile + "...";

            }
            ViewBag.Message = message;
            return PopulateErrorGrid(Convert.ToString(pageSize), Convert.ToString(PageNo));
            //return PartialView("_MusicTitleImport_List", lstError);
        }

        public PartialViewResult PopulateErrorGrid(string txtPageSize = "10", string PgNo = "0")
        {
            // int pageSize = Convert.ToInt32(txtPageSize);
            int PageNo = Convert.ToInt32(PgNo);
            PageNo = PageNo + 1;
            List<USP_Insert_Music_Title_Import_UDT> lstErr = new List<USP_Insert_Music_Title_Import_UDT>();
            int pageSize;
            if (txtPageSize != null)
            {
                //objDeal_Schema.Budget_PageSize = txtPageSize;
                pageSize = Convert.ToInt32(txtPageSize);
            }
            else
            {
                //objDeal_Schema.Budget_PageSize = 50;
                pageSize = 50;
            }

            //ViewBag.SrNo_StartFrom = ((PageNo - 1) * pageSize);

            if (PageNo == 0)
                PageNo = 1;

            ViewBag.RecordCount = lstError.Count;
            ViewBag.PageNo = PageNo;
            if (PageNo == 1)
                lstErr = lstError.Take(pageSize).ToList();
            else
            {
                lstErr = lstError.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (lstError.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList().Count == 0)
                {
                    if (PageNo != 1)
                    {
                        //objDeal_Schema.Budget_PageNo = PageNo - 1;
                        PageNo = PageNo - 1;
                    }
                    lstErr = lstError.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }

            return PartialView("_MusicTitleImport_List", lstErr);
        }
        public PartialViewResult PartialAddMovie_Album()
        {
            ////lstTalent = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Talent_Name().ToList();
            ////lstStarCast = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_StarCast).ToList();

            //var StarCast_code = string.Join(",", (objTitle.Music_Title_Talent.Where(i => i.Music_Title_Code != objTitle.Music_Title_Code && i.Role_Code == GlobalParams.Role_code_StarCast).Select(i => i.Talent_Code).ToList()));
            //ViewBag.StarCastList = new MultiSelectList(lstStarCast, "Talent_code", "Talent_Name", StarCast_code.Split(','));

            //// ViewBag.MovieAlbum = BindMovieAlbum();
            return PartialView("_Add_Movie_Album", new Music_Album());
        }
        public JsonResult AutoCompleteMovieStarCast(string keyword)
        {
            List<string> terms = keyword.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            var result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Talent_Name().Where(w => w.Talent_Name.ToUpper().Contains(searchString.ToUpper()) && w.Role_Code == GlobalParams.Role_code_StarCast).Distinct()
                .Select(x => new { Talent_Name = x.Talent_Name, Talent_Code = x.Talent_Code }).ToList();

            return Json(result);
        }
        public JsonResult SaveMovieAlbum(Music_Album frmdata, string rdoMovieAlbum, string Music_Album_Name, string hdnStarCastList)
        {
            // string rdoMovieAlbum = "";

            //string hdnMovieAlbum = frmdata["hdnMovieAlbum"].ToString();
            //string rdoMovieAlbum = frmdata["rdoMovieAlbum"].ToString();
            //string lstStarcast = frmdata["selectedValue"].ToString();
            Music_Album objMusicAlbum = new Music_Album();
            Music_Album_Service objService = new Music_Album_Service(objLoginEntity.ConnectionStringName);
            string lstStarcast = hdnStarCastList.Trim();

            objMusicAlbum.Music_Album_Name = Music_Album_Name;
            objMusicAlbum.Album_Type = rdoMovieAlbum;
            objMusicAlbum.Inserted_By = objLoginUser.Users_Code;
            objMusicAlbum.Inserted_On = System.DateTime.Now;
            objMusicAlbum.Is_Active = "Y";
            objMusicAlbum.EntityState = State.Added;

            var RoleCode = new Role_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true).Where(b => b.Role_Name.Contains("Star Cast")).Select(c => c.Role_Code).ToList();

            //#region --- Talent Role List ---
            List<string> talentlst = new List<string>();
            var strtalents = "";
            ICollection<Music_Album_Talent> talentRoleList = new HashSet<Music_Album_Talent>();
            if (lstStarcast != null)
            {
                string[] arrRoleCodes = lstStarcast.Split(',');
                foreach (string talentcode in arrRoleCodes)
                {
                    if (talentcode != "")
                    {
                        int code = Convert.ToInt32(talentcode);
                        Music_Album_Talent objTR = new Music_Album_Talent();
                        objTR.EntityState = State.Added;
                        objTR.Talent_Code = Convert.ToInt32(talentcode);
                        objTR.Role_Code = Convert.ToInt32(RoleCode[0]);
                        objTR.Music_Album_Code = objMusicAlbum.Music_Album_Code;
                        talentlst = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true).Where(b => b.Talent_Code == code).Select(c => c.Talent_Name).ToList();
                        strtalents += talentlst[0] + ", ";
                        talentRoleList.Add(objTR);
                    }
                }
            }

            //IEqualityComparer<Music_Album_Talent> comparerTalentRole = new LambdaComparer<Music_Album_Talent>((x, y) => x.Role_Code == y.Role_Code && x.EntityState != State.Deleted);
            //var Deleted_Talent_Role = new List<Music_Album_Talent>();
            //var Updated_Talent_Role = new List<Music_Album_Talent>();
            //var Added_Talent_Role = CompareLists<Music_Album_Talent>(talentRoleList.ToList<Music_Album_Talent>(), objMusicAlbum.Music_Album_Talent.ToList<Music_Album_Talent>(), comparerTalentRole, ref Deleted_Talent_Role, ref Updated_Talent_Role);
            //Added_Talent_Role.ToList<Music_Album_Talent>().ForEach(t => objMusicAlbum.Music_Album_Talent.Add(t));
            //Deleted_Talent_Role.ToList<Music_Album_Talent>().ForEach(t => t.EntityState = State.Deleted);
            //#endregion

            objMusicAlbum.Music_Album_Talent = talentRoleList;

            var result = ValidateIsDuplicateMovieAlbumName(Music_Album_Name);
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            if (result != "")
            {
                objJson.Add("Message", result);
                return Json(objJson);
            }

            //NEED TO CHANGE
            dynamic resultSetMA;
            objService.Save(objMusicAlbum, out resultSetMA);
            objJson.Add("Value", objMusicAlbum.Music_Album_Code);
            objJson.Add("Text", objMusicAlbum.Music_Album_Name);

            //var MusicAlbum = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true).ToList();
            //ViewBag.MovieAlbum = BindMovieAlbum();
            ViewBag.MovieAlbum = objMusicAlbum.Music_Album_Name;
            string status = "S", message = "Record {ACTION} successfully";
            status = "S";
            message = objMessageKey.RecordAddedSuccessfully;
            var obj = new
            {
                Status = status,
                Message = message
            };
            int id = Convert.ToInt32(Session["EditId"]);

            Talent_Service objTalentService = new Talent_Service(objLoginEntity.ConnectionStringName);




            objJson.Add("listStarCast", strtalents);
            return Json(objJson);
        }
        public JsonResult onChangeDropdown(string value)
        {
            var TalentList = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true);
            var MovieAlbum = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true);
            var MovieAlbumTalent = new Music_Album_Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true);

            //var result = from a in MovieAlbum
            //             join b in MovieAlbumTalent on a.Music_Album_Code equals b.Music_Album_Code
            //             select new { b.Talent_Code };
            int code = Convert.ToInt32(value);
            //var lstTalentName = from a in TalentList
            //                    join b in MovieAlbumTalent on a.Talent_Code equals b.Talent_Code
            //                    where b.Music_Album_Code == code
            //                    select new { a.Talent_Name, a.Talent_Code };
            //var code = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name == value).Select(x => x.Music_Album_Code).FirstOrDefault();
            var lstTalentName = MovieAlbumTalent.Where(a => a.Music_Album_Code == code).Select(b => b.Talent).ToList();

            string strName = string.Join(", ", lstTalentName.Select(s => s.Talent_Name).ToArray());
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            objJson.Add("Value", strName);
            return Json(objJson);
        }
        public void BindStarcast(int value, string Movie_Album_Type)
        {
            int code = Convert.ToInt32(value);

            if (Movie_Album_Type == "A")
            {
                var MovieAlbumTalent = new Music_Album_Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true);
                var lstTalentName = MovieAlbumTalent.Where(a => a.Music_Album_Code == code).Select(b => b.Talent).ToList();
                string strName = string.Join(", ", lstTalentName.Select(s => s.Talent_Name).ToArray());
                ViewBag.StarcastJoins = strName;
            }
            else
            {
                var TitleTalent = new Title_Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(a => a.Role_Code == 2);
                var lstTalentName = TitleTalent.Where(a => a.Title_Code == code).Select(b => b.Talent).ToList();
                string strName = string.Join(", ", lstTalentName.Select(s => s.Talent_Name).ToArray());
                ViewBag.StarcastJoins = strName;
            }
        }
        private List<SelectListItem> BindMovieAlbum(int Music_Album_Code = 0)
        {
            List<SelectListItem> lstTitleType = new List<SelectListItem>();

            lstTitleType = new SelectList(new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Album_Code", "Music_Album_Name", Music_Album_Code).ToList();
            lstTitleType.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });

            return lstTitleType;
        }
        public string ValidateIsDuplicateMovieAlbumName(string MovieAlbumName, int Music_Album_Code = 0, string command = "Add")
        {
            MovieAlbumName = MovieAlbumName.Trim(' ');
            int Count = 0;
            //if (command == "Add")
            //{
            Count = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name == MovieAlbumName).Distinct().Count();
            //}
            //else
            //{
            //    Count = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name == MovieAlbumName && x.Music_Album_Code != Music_Album_Code).Distinct().Count();
            //}
            string msg = "";

            if (Count > 0)
                //msg = "Music Album Name with same name already exists";
                msg = objMessageKey.MusicAlbumNamewithsamenamealreadyexists;
            else
                msg = "";

            return msg;
        }
        public ViewResult MusicTitleContent(int id)
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusic_Title);
            ViewBag.code = id;
            return View("~/Views/Music_Title/Music_Title_Contents.cshtml");
        }
        public JsonResult SearchMusicContent(int id, string searchText, int RecordPerPage, int PageNo)
        {

            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            lstMusicTitleContent_Searched = lstMusicTitleContent = new USP_Service(objLoginEntity.ConnectionStringName).USP_Music_Title_Contents(id, searchText, objRecordCount, "Y", RecordPerPage, PageNo).ToList<RightsU_Entities.USP_Music_Title_Contents_Result>();

            var obj = new
            {
                Record_Count = Convert.ToInt32(objRecordCount.Value)
            };
            return Json(obj);
        }
        public PartialViewResult BindMusicTitleContentList(int pageNo, int recordPerPage)
        {
            List<RightsU_Entities.USP_Music_Title_Contents_Result> lst = new List<RightsU_Entities.USP_Music_Title_Contents_Result>();

            lst = lstMusicTitleContent_Searched.ToList();

            return PartialView("~/Views/Music_Title/_List_Music_Title_Contents.cshtml", lst);
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

        #region --- Assigne Music Label ---
        public JsonResult AssignMusicLabel(int musicTitleCode)
        {
            objMTL_Session = null;
            string status = "S", message = "", minEffectiveFrom = "";

            objMTL_Session = new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Music_Title_Code == musicTitleCode && w.Effective_From != null && w.Effective_To == null).
                OrderByDescending(o => o.Music_Title_Label_Code).FirstOrDefault();

            if (objMTL_Session.Music_Title_Label_Code == 0)
            {
                objMTL_Session = new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Music_Title_Code == musicTitleCode && w.Effective_To == null).
                OrderByDescending(o => o.Music_Title_Label_Code).FirstOrDefault();
            }

            objMTL_Session.Music_Title_Code = musicTitleCode;
            List<SelectListItem> lstMusicLabel = new SelectList((new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y" && w.Music_Label_Code != objMTL_Session.Music_Label_Code).OrderBy(o => o.Music_Label_Name)), "Music_Label_Code", "Music_Label_Name").ToList();
            lstMusicLabel.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });

            if (objMTL_Session.Effective_From != null)
                // minEffectiveFrom = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Music_Label_Effective_From").Select(i => i.Parameter_Value).FirstOrDefault();
                minEffectiveFrom = Convert.ToDateTime(objMTL_Session.Effective_From).ToString(GlobalParams.DateFormat_Display);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            obj.Add("MinEffectiveFrom", minEffectiveFrom);
            obj.Add("MusicLabelList", lstMusicLabel);
            return Json(obj);
        }

        public PartialViewResult BindMusicLabelHistory(int musicLabelCode, string commandName, DateTime? hdnEffectiveFrom)
        {
            ViewBag.MusicLabelCode = musicLabelCode;
            ViewBag.CommandName = commandName;
            List<Music_Title_Label> lstMusicTitleLabel = new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Music_Title_Code == objMTL_Session.Music_Title_Code && w.Effective_From != null).
                OrderByDescending(o => o.Music_Title_Label_Code).ToList();
            ViewBag.HdnEffectiveFrom = Convert.ToDateTime(lstMusicTitleLabel.FirstOrDefault().Effective_From).ToString(GlobalParams.DateFormat_Display);
            return PartialView("~/Views/Music_Title/_MusicLabelHistory.cshtml", lstMusicTitleLabel);
        }
        public JsonResult SaveMusicLabelHistory(int musicTitleLabelCode, DateTime Effective_From)
        {
            string status = "S", message = "";
            if (musicTitleLabelCode > 0)
                message = "Effective date updated successfully";
            Music_Title_Label_Service objMTLService = new Music_Title_Label_Service(objLoginEntity.ConnectionStringName);
            Music_Title_Label objMTL = objMTLService.GetById((int)objMTL_Session.Music_Title_Label_Code);
            Music_Title_Service objMTService = new Music_Title_Service(objLoginEntity.ConnectionStringName);
            Music_Title objMTC = objMTService.GetById((int)objMTL_Session.Music_Title_Code);
            Music_Title_Label objMTL_Last = objMTLService.SearchFor(w => w.Music_Title_Code == objMTL_Session.Music_Title_Code && w.Effective_From != null && w.Effective_To != null).
              OrderByDescending(o => o.Effective_To).FirstOrDefault();
            if (objMTL_Last != null)
            {
                objMTL.EntityState = State.Modified;
                objMTL_Last.Effective_To = Effective_From.AddDays(-1);
                objMTL.Effective_To = objMTL_Last.Effective_To;
            }
            if (objMTL_Session.Effective_From != null && Effective_From != null)
            {
                if (Effective_From <= objMTL_Session.Effective_From)
                {
                    status = "E";
                    message = objMessageKey.PleaseSelectEffectiveDateGreaterthan + Convert.ToDateTime(objMTL_Session.Effective_From).ToString(GlobalParams.DateFormat_Display);
                }
            }
            if (status != "E")
            {
                Music_Title_Label objMT = new Music_Title_Label();
                objMTL.EntityState = State.Modified;
                objMTL.Music_Label_Code = musicTitleLabelCode;
                objMTL.Effective_From = Effective_From;
                objMTL.Effective_To = null;
                objMTLService.Save(objMT);
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }
        public JsonResult SaveAssignedMusicLabel(int musicLabelCode, DateTime? effectiveDate)
        {

            if (Session["objMessageKey"] != null)
            {
                objMessageKey = (MessageKey)Session["objMessageKey"];
            }

            string status = "S", message = objMessageKey.MusicLabelassignedsuccessfully;

            Music_Title_Service objMTService = new Music_Title_Service(objLoginEntity.ConnectionStringName);
            Music_Title objMT = objMTService.GetById((int)objMTL_Session.Music_Title_Code);

            if (objMTL_Session.Effective_From != null && effectiveDate != null)
            {
                if (effectiveDate <= objMTL_Session.Effective_From)
                {
                    status = "E";
                    // message = "Please select Effective Date Greater than " + Convert.ToDateTime(objMTL_Session.Effective_From).ToString(GlobalParams.DateFormat_Display);
                    message = objMessageKey.PleaseSelectEffectiveDateGreaterthan + " " + Convert.ToDateTime(objMTL_Session.Effective_From).ToString(GlobalParams.DateFormat_Display);
                }
            }
            if (status != "E")
            {
                Music_Title_Label objMTL = new Music_Title_Label();
                objMTL.EntityState = State.Added;
                objMTL.Effective_From = effectiveDate;
                objMTL.Effective_To = null;
                objMTL.Music_Label_Code = musicLabelCode;
                objMT.Music_Title_Label.Add(objMTL);

                objMT.Music_Title_Label.Where(w => w.Music_Title_Label_Code == objMTL_Session.Music_Title_Label_Code).ToList().
                    ForEach(a =>
                    {
                        a.Effective_To = Convert.ToDateTime(effectiveDate).AddDays(-1);
                        a.EntityState = State.Modified;
                    });

                objMT.EntityState = State.Modified;
                objMTService.Save(objMT);
                objMTL_Session = null;
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }
        #endregion
        public ActionResult PopulateAutoCompleteMovieAlbum(string keyword, string Movie_Album_Type)
        {
            dynamic result = "";
            if (Movie_Album_Type == "M")
            {
                string dealType = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "AL_DealType_Movies").Select(x => x.Parameter_Value).FirstOrDefault();
                var strArrdealType = dealType.Split(',');
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(keyword.ToUpper()) && x.Is_Active == "Y" && strArrdealType.Contains(x.Deal_Type_Code.ToString())).Distinct()
                .Select(x => new { Music_Album_Name = x.Title_Name, Music_Album_Code = x.Title_Code }).ToList();
            }
            else if (Movie_Album_Type == "S")
            {
                string dealType = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "AL_DealType_Show").Select(x => x.Parameter_Value).FirstOrDefault();
                var strArrdealType = dealType.Split(',');
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(keyword.ToUpper()) && x.Is_Active == "Y" && strArrdealType.Contains(x.Deal_Type_Code.ToString())).Distinct()
                .Select(x => new { Music_Album_Name = x.Title_Name, Music_Album_Code = x.Title_Code }).ToList();
            }
            else if (Movie_Album_Type == "A")
            {
                result = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name.ToUpper().Contains(keyword.ToUpper()) && x.Is_Active == "Y").Distinct()
                .Select(x => new { Music_Album_Name = x.Music_Album_Name, Music_Album_Code = x.Music_Album_Code }).ToList();
                //.Where(x => x.Music_Album_Code == music_Album_Code)
            }

            return Json(result);
        }
        public JsonResult AutoMovieAlbum(string keyword, string Movie_Album_Type)
        {
            List<string> terms = keyword.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();

            dynamic result = "";

            if (Movie_Album_Type == "M")
            {
                string dealType = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "AL_DealType_Movies").Select(x => x.Parameter_Value).FirstOrDefault();
                var strArrdealType = dealType.Split(',');
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y" && strArrdealType.Contains(x.Deal_Type_Code.ToString())).Distinct()
                .Select(x => new { Music_Album_Name = x.Title_Name, Music_Album_Code = x.Title_Code }).ToList();
            }
            else if (Movie_Album_Type == "S")
            {
                string dealType = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "AL_DealType_Show").Select(x => x.Parameter_Value).FirstOrDefault();
                var strArrdealType = dealType.Split(',');
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y" && strArrdealType.Contains(x.Deal_Type_Code.ToString())).Distinct()
                .Select(x => new { Music_Album_Name = x.Title_Name, Music_Album_Code = x.Title_Code }).ToList();
            }
            else if (Movie_Album_Type == "A")
            {
                result = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y").Distinct()
                .Select(x => new { Music_Album_Name = x.Music_Album_Name, Music_Album_Code = x.Music_Album_Code }).ToList();
            }

            return Json(result);
        }
    }

    public partial class Music_Title_Search
    {
        public string MusicTitleName { get; set; }
        public int DealTypeCode { get; set; }
        public string isAdvanced { get; set; }
        public string MusicLabelCodes_Search { get; set; }
        public string AlbumsCodes_Search { get; set; }
        public string MusicAlbumName { get; set; }
        public string StarCastCodes_Search { get; set; }
        public string SingerCodes_Search { get; set; }
        public string ComposerCodes_Search { get; set; }
        public string GenresCodes_Search { get; set; }
        public string LanguagesCodes_Search { get; set; }
        public string YearOfRelease { get; set; }
        public string isSearch { get; set; }
        public string LyricistCodes_Search { get; set; }
        public string MusicTitleName_Search { get; set; }
        public string ThemeCodes_Search { get; set; }
        public string Music_Tag_Search { get; set; }
        public string SearchText { get; set; }
        public string Public_Domain { get; set; }
        public int PageNo { get; set; }
        public int Page_Size { get; set; }
        public string Movie_Album_Type { get; set; }
    }

}
