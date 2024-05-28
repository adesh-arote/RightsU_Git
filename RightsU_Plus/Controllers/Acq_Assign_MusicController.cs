using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Acq_Assign_MusicController : BaseController
    {
        #region --- Attributes & Properties ---

        public string rightCodes
        {
            get
            {
                if (Session["rightCodes"] == null)
                    Session["rightCodes"] = "0";
                return Convert.ToString(Session["rightCodes"]);
            }
            set { Session["rightCodes"] = value; }
        }
        public int Acq_Deal_Code
        {
            get
            {
                if (Session["Acq_Deal_Code"] == null)
                    Session["Acq_Deal_Code"] = "0";
                return Convert.ToInt32(Session["Acq_Deal_Code"]);
            }
            set { Session["Acq_Deal_Code"] = value; }
        }
        public Acq_Deal objAD_Session
        {
            get
            {
                if (Session[RightsU_Session.SESS_DEAL] == null)
                    Session[RightsU_Session.SESS_DEAL] = new Acq_Deal();

                return (Acq_Deal)Session[RightsU_Session.SESS_DEAL];
            }
            set { Session[RightsU_Session.SESS_DEAL] = value; }
        }
        public Acq_Deal_Service objADS
        {
            get
            {
                if (Session["ADS_Acq_General"] == null)
                    Session["ADS_Acq_General"] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Service)Session["ADS_Acq_General"];
            }
            set { Session["ADS_Acq_General"] = value; }
        }
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.ACQ_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.ACQ_DEAL_SCHEMA] = value; }
        }
        private List<USP_List_Assign_Music_Result> lstMusicLibrary_All
        {
            get
            {
                if (Session["lstMusicLibrary_All"] == null)
                    Session["lstMusicLibrary_All"] = new List<USP_List_Assign_Music_Result>();
                return (List<USP_List_Assign_Music_Result>)Session["lstMusicLibrary_All"];
            }
            set { Session["lstMusicLibrary_All"] = value; }
        }
        private List<USP_List_Assign_Music_Result> lstMusicLibrary
        {
            get
            {
                if (Session["lstMusicLibrary"] == null)
                    Session["lstMusicLibrary"] = new List<USP_List_Assign_Music_Result>();
                return (List<USP_List_Assign_Music_Result>)Session["lstMusicLibrary"];
            }
            set { Session["lstMusicLibrary"] = value; }
        }
        private List<USP_Populate_Music_Result> lstPopulate_Music_Result
        {
            get
            {
                if (Session["lstPopulate_Music_Result"] == null)
                    Session["lstPopulate_Music_Result"] = new List<USP_Populate_Music_Result>();
                return (List<USP_Populate_Music_Result>)Session["lstPopulate_Music_Result"];
            }
            set { Session["lstPopulate_Music_Result"] = value; }
        }
        private List<USP_Validate_And_Save_Assigned_Music_UDT> lstErrorRecord
        {
            get
            {
                if (Session["lstErrorRecord"] == null)
                    Session["lstErrorRecord"] = new List<USP_Validate_And_Save_Assigned_Music_UDT>();
                return (List<USP_Validate_And_Save_Assigned_Music_UDT>)Session["lstErrorRecord"];
            }
            set { Session["lstErrorRecord"] = value; }
        }
        private List<Link_Show_Episode_Play> lstLink_Show_Episode_Play
        {
            get
            {
                if (Session["lstLink_Show_Episode_Play"] == null)
                    Session["lstLink_Show_Episode_Play"] = new List<Link_Show_Episode_Play>();
                return (List<Link_Show_Episode_Play>)Session["lstLink_Show_Episode_Play"];
            }
            set { Session["lstLink_Show_Episode_Play"] = value; }
        }

        #endregion

        #region --- Actions ---
        public ActionResult Index()
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();

            #region --- Clear Session ---
            Acq_Deal_Code = 0;
            objAD_Session = null;
            objADS = null;
            objDeal_Schema = null;
            lstMusicLibrary_All = null;
            lstMusicLibrary = null;
            lstPopulate_Music_Result = null;
            lstErrorRecord = null;
            lstLink_Show_Episode_Play = null;
            #endregion

            objDeal_Schema.Record_Locking_Code = 0;
            if (TempData["QueryString"] != null)
            {
                obj_Dictionary = TempData["QueryString"] as Dictionary<string, string>;
                Acq_Deal_Code = Convert.ToInt32(obj_Dictionary["Acq_Deal_Code"]);

                if (!string.IsNullOrEmpty(obj_Dictionary["RLCode"]))
                    objDeal_Schema.Record_Locking_Code = Convert.ToInt32(obj_Dictionary["RLCode"]);
            }

            objAD_Session = objADS.GetById(Acq_Deal_Code);
            objDeal_Schema.Agreement_No = objAD_Session.Agreement_No;
            objDeal_Schema.Version = objAD_Session.Version;
            objDeal_Schema.Agreement_Date = objAD_Session.Agreement_Date;
            objDeal_Schema.Deal_Desc = objAD_Session.Deal_Desc;
            objDeal_Schema.Status = objAD_Session.Deal_Tag.Deal_Tag_Description;
            objDeal_Schema.Deal_Workflow_Status = new RightsU_BLL.USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Deal_DealWorkFlowStatus(Acq_Deal_Code, objAD_Session.Deal_Workflow_Status, 143, "A").First();
            objDeal_Schema.Deal_Type_Code = (int)objAD_Session.Deal_Type_Code;
            objDeal_Schema.Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objDeal_Schema.Deal_Type_Code);

            string searchPlaceHolderText = "Search by Music Library, Music Title";
            string popupSearchPlaceHolderText = "Music Title, Album / Movie, Singer, Music Composer, Lyricist";
            if (objAD_Session.Deal_Type_Code != GlobalParams.Deal_Type_Music)
            {
                searchPlaceHolderText = "Search by Program, Music Library, Music Title";
                popupSearchPlaceHolderText = "Search by Agreement No, Library, Music Title, Label";
            }

            ObjectResult<string> objRightCodes = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            rightCodes = objRightCodes.FirstOrDefault();

            string pageHeader = "Assign Music List", pageSubHeader = "";
            string rightForAssignMusic = "N";
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                if (rightCodes.Contains("~" + GlobalParams.RightCodeForAssignMusic_Music + "~"))
                    rightForAssignMusic = "Y";
            }
            else
            {
                pageHeader = "Assign Music - ";
                pageSubHeader = "Program";
                if (rightCodes.Contains("~" + GlobalParams.RightCodeForAssignMusic_NonMusic + "~"))
                    rightForAssignMusic = "Y";
            }

            ViewBag.PageHeader = pageHeader;
            ViewBag.PageSubHeader = pageSubHeader;
            ViewBag.RightForAssignMusic = rightForAssignMusic;
            ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            ViewBag.Search_PlaceHolder = searchPlaceHolderText;
            ViewBag.PopupSearch_PlaceHolder = popupSearchPlaceHolderText;

            return View();
        }
        public ActionResult Back()
        {
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);

            Session["Acq_Deal_Code"] = null;
            objAD_Session = null;
            objADS = null;
            objDeal_Schema = null;
            lstMusicLibrary_All = null;
            lstMusicLibrary = null;

            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
            return RedirectToAction("Index", "Acq_List");
        }
        public JsonResult Search(string searchText, string showAll)
        {
            if (string.IsNullOrEmpty(searchText))
                searchText = "";

            searchText = searchText.ToUpper();
            if (lstMusicLibrary_All.Count == 0 || showAll == "Y")
            {
                lstMusicLibrary_All = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Assign_Music(Acq_Deal_Code).ToList();
                lstMusicLibrary = lstMusicLibrary_All;
            }
            else
            {
                lstMusicLibrary = lstMusicLibrary_All.Where(x => (x.Program.ToUpper().Contains(searchText) && objDeal_Schema.Deal_Type_Condition != GlobalParams.Deal_Music) ||
                    x.Music_Library.ToUpper().Contains(searchText) || x.Music_Title.ToUpper().Contains(searchText)).ToList();
            }
            int recordCount = lstMusicLibrary.Count;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", "S");
            obj.Add("Record_Count", recordCount);
            return Json(obj);
        }
        public JsonResult PopupSearch(string searchText, int dealMovieCode, string linkShow, string mode)
        {
            if (string.IsNullOrEmpty(searchText))
                searchText = "";

            searchText = searchText.ToUpper();
            string allCodes = "";

            if ((dealMovieCode > 0 || linkShow == "Y") && (searchText != "" || (linkShow == "Y" && mode == "VIEW")))
            {
                lstPopulate_Music_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Populate_Music(dealMovieCode, searchText, objDeal_Schema.Deal_Type_Code, linkShow, mode.ToUpper()).ToList();
                allCodes = string.Join(",", lstPopulate_Music_Result.Select(s => s.Int_Code).ToArray());
            }
            else
            {
                lstPopulate_Music_Result.Clear();
            }

            int recordCount = lstPopulate_Music_Result.Count;


            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", "S");
            obj.Add("Record_Count", recordCount);
            obj.Add("All_Codes", allCodes);
            return Json(obj);
        }
        public JsonResult FillLinkShowDetails(int musicCode)
        {
            string musicLength = "", yearOfRelease = "", musicLangauge = "", musicType = "";
            USP_List_Assign_Music_Result objAM = lstMusicLibrary.Where(w => w.Int_Code == musicCode.ToString()).FirstOrDefault();

            Acq_Deal_Movie_Music objADMM = new Acq_Deal_Movie_Music_Service(objLoginEntity.ConnectionStringName).GetById(musicCode);
            if (objADMM != null)
            {
                if (objADMM.Music_Title != null)
                {
                    if (objADMM.Music_Title.Duration_In_Min != null)
                        musicLength = objADMM.Music_Title.Duration_In_Min.ToString();

                    if (objADMM.Music_Title.Release_Year != null)
                        yearOfRelease = objADMM.Music_Title.Release_Year.ToString();

                    if (objADMM.Music_Title.Language != null)
                        musicLangauge = objADMM.Music_Title.Language.Language_Name;

                    if (objADMM.Music_Title.Music_Type != null)
                        musicType = objADMM.Music_Title.Music_Type.Music_Type_Name;
                }
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Music_Library", objAM.Music_Library);
            obj.Add("Music_Title", objAM.Music_Title);
            obj.Add("Music_Singer", objAM.Singer);
            obj.Add("Music_Composer", objAM.Music_Composer);
            obj.Add("Music_Length", musicLength);
            obj.Add("Year_Of_Release", yearOfRelease);
            obj.Add("Music_Language", musicLangauge);
            obj.Add("Music_Type", musicType);
            return Json(obj);
        }
        public JsonResult BindDealMoviePopup()
        {
            List<SelectListItem> lstDealMoviePopup = objAD_Session.Acq_Deal_Movie.Select(s => new SelectListItem() { Text = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, s.Title.Title_Name, s.Episode_Starts_From, s.Episode_End_To), Value = s.Acq_Deal_Movie_Code.ToString() }).ToList();
            return Json(lstDealMoviePopup, JsonRequestBehavior.AllowGet);

        }
        public JsonResult BindEpisodeListPopup(int dealMovieCode, int episodeFrom, int episodeTo, string dummyGuid)
        {
            List<SelectListItem> lstEpisodeListPopup = new List<SelectListItem>();

            string selectedCode = "";
            if (episodeFrom == 0 && episodeTo == 0)
            {
                Acq_Deal_Movie objADM = objAD_Session.Acq_Deal_Movie.Where(w => w.Acq_Deal_Movie_Code == dealMovieCode).FirstOrDefault();
                if (objADM != null)
                {
                    episodeFrom = (int)objADM.Episode_Starts_From;
                    episodeTo = (int)objADM.Episode_End_To;
                }

            }

            Link_Show_Episode_Play objLink;
            objLink = lstLink_Show_Episode_Play.Where(w => w.Deal_Movie_Code == dealMovieCode).FirstOrDefault();

            if (objLink != null)
            {
                Episode_Play objEP = objLink.lstEpisode_Play.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
                if (objEP != null)
                    selectedCode = objEP.Episode_Numbers;
            }

            for (int i = episodeTo; i >= episodeFrom; i--)
            {
                int count = 0;
                if (objLink != null)
                    count = objLink.lstEpisode_Play.Where(w => w.Dummy_Guid != dummyGuid && w.Episode_Numbers.Split(',').Contains(i.ToString())).Count();

                if (count == 0)
                {
                    SelectListItem objSLI = new SelectListItem();
                    objSLI.Text = "Episode-" + i;
                    objSLI.Value = i.ToString();
                    lstEpisodeListPopup.Insert(0, objSLI);
                }
            }


            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Selected_Codes", selectedCode);
            obj.Add("Episode_List", lstEpisodeListPopup);
            return Json(obj, JsonRequestBehavior.AllowGet);

        }
        public JsonResult Save(string selectedDealMovieCodes, string selectedMusicCodes, string linkShow)
        {
            string status = "S", message = "";

            string[] arrSelectedMusicCode = selectedMusicCodes.Trim().Trim(',').Trim().Split(',');
            string[] arrSelectedDealMovieCode = selectedDealMovieCodes.Trim().Trim(',').Trim().Split(',');

            List<Assign_Music_UDT> lstAssign_Music_UDT = new List<Assign_Music_UDT>();

            foreach (string strDealMovieCode in arrSelectedDealMovieCode)
            {
                if (!string.IsNullOrEmpty(strDealMovieCode))
                {
                    int dealMovieCode = Convert.ToInt32(strDealMovieCode);

                    Link_Show_Episode_Play objLink = new Link_Show_Episode_Play();
                    objLink = lstLink_Show_Episode_Play.Where(w => w.Deal_Movie_Code == dealMovieCode).FirstOrDefault();

                    foreach (string strMusicCode in arrSelectedMusicCode)
                    {
                        if (!string.IsNullOrEmpty(strMusicCode))
                        {
                            int musicCode = Convert.ToInt32(strMusicCode);

                            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music && linkShow != "Y")
                            {
                                Assign_Music_UDT objAS_UDT = new Assign_Music_UDT();
                                objAS_UDT.Deal_Movie_Code = dealMovieCode;
                                objAS_UDT.Music_Code = musicCode;
                                lstAssign_Music_UDT.Add(objAS_UDT);
                            }
                            else
                            {
                                if (objLink != null)
                                {
                                    foreach (Episode_Play objEps in objLink.lstEpisode_Play)
                                    {
                                        string[] arrEpsNo = objEps.Episode_Numbers.Split(',');
                                        foreach (string strEpsNo in arrEpsNo)
                                        {
                                            if (!string.IsNullOrEmpty(strEpsNo))
                                            {
                                                int epsNo = Convert.ToInt32(strEpsNo);
                                                Assign_Music_UDT objAS_UDT = new Assign_Music_UDT();
                                                objAS_UDT.Deal_Movie_Code = dealMovieCode;
                                                objAS_UDT.Music_Code = musicCode;
                                                objAS_UDT.Episode_No = epsNo;
                                                objAS_UDT.No_Of_Play = objEps.No_Of_Play;
                                                lstAssign_Music_UDT.Add(objAS_UDT);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            lstErrorRecord.Clear();
            lstErrorRecord = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_And_Save_Assigned_Music_UDT(objDeal_Schema.Deal_Type_Code, objLoginUser.Users_Code, linkShow, "S", lstAssign_Music_UDT).ToList();
            if (lstErrorRecord.Count > 0)
            {
                int errorCount = lstErrorRecord.Where(w => w.Is_Warning == "N").Count();

                if (errorCount > 0)
                    status = "E";
                else
                    status = "W";
            }
            else
                ClearPopupSession();

            lstLink_Show_Episode_Play = null;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }
        public JsonResult Delete(string musicCodes)
        {
            string status = "S", message = "";
            string[] arrMusicCode = musicCodes.Trim().Trim(',').Trim().Split(',');
            List<Assign_Music_UDT> lstAssign_Music_UDT = new List<Assign_Music_UDT>();

            foreach (string strMusicCode in arrMusicCode)
            {
                if (!string.IsNullOrEmpty(strMusicCode))
                {
                    int musicCode = Convert.ToInt32(strMusicCode);
                    Assign_Music_UDT objAS_UDT = new Assign_Music_UDT();
                    objAS_UDT.Music_Code = musicCode;
                    lstAssign_Music_UDT.Add(objAS_UDT);
                }
            }

            lstErrorRecord.Clear();

            // Here we are passing parameter "Action = 'D'" to USP_Validate_And_Save_Assigned_Music_UDT, It means Delete Record
            lstErrorRecord = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_And_Save_Assigned_Music_UDT(objDeal_Schema.Deal_Type_Code, objLoginUser.Users_Code, "N", "D", lstAssign_Music_UDT).ToList();
            if (lstErrorRecord.Count > 0)
            {
                status = "E";
                if (lstErrorRecord.Count == 1)
                    message = lstErrorRecord.First().Err_Message.Trim();
            }
            else
            {
                USP_List_Assign_Music_Result objAMR = lstMusicLibrary.Where(w => w.Int_Code.Trim().Trim(',').Trim() == musicCodes).FirstOrDefault();
                if (objAMR != null)
                {
                    lstMusicLibrary.Remove(objAMR);
                    lstMusicLibrary_All.Remove(objAMR);
                }
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }
        public JsonResult SaveEpisode(int dealMovieCode, string selectedEpisodes, int noOfPlay, string dummyGuid)
        {
            string status = "S", message = "";

            selectedEpisodes = selectedEpisodes.Trim().Trim(',').Trim();
            Link_Show_Episode_Play objLink = lstLink_Show_Episode_Play.Where(w => w.Deal_Movie_Code == dealMovieCode).FirstOrDefault();
            if (objLink == null)
            {
                objLink = new Link_Show_Episode_Play();
                lstLink_Show_Episode_Play.Add(objLink);
            }
            objLink.Deal_Movie_Code = dealMovieCode;

            Episode_Play objEps = objLink.lstEpisode_Play.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();

            if (objEps == null)
            {
                objEps = new Episode_Play();
                objLink.lstEpisode_Play.Add(objEps);
            }

            objEps.Episode_Numbers = selectedEpisodes;
            objEps.No_Of_Play = noOfPlay;

            string episodeDisplay = "";

            string[] arrEpisodes = selectedEpisodes.Split(',');
            foreach (string strEps in arrEpisodes)
            {
                if (!string.IsNullOrEmpty(episodeDisplay))
                    episodeDisplay = episodeDisplay + ", ";

                episodeDisplay = episodeDisplay + "Episode-" + strEps;
            }
            objEps.Episode_Numbers_Display = episodeDisplay;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }
        public JsonResult DeleteEpisode(int dealMovieCode, string dummyGuid)
        {
            string status = "S", message = "";

            Link_Show_Episode_Play objLink = lstLink_Show_Episode_Play.Where(w => w.Deal_Movie_Code == dealMovieCode).FirstOrDefault();
            if (objLink != null)
            {
                Episode_Play objEps = objLink.lstEpisode_Play.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
                if (objEps != null)
                    objLink.lstEpisode_Play.Remove(objEps);

                if (objLink.lstEpisode_Play.Count == 0)
                    lstLink_Show_Episode_Play.Remove(objLink);
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }
        public JsonResult ClearPopupSession()
        {
            lstPopulate_Music_Result = null;
            lstErrorRecord = null;
            lstLink_Show_Episode_Play = null;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", "S");
            return Json(obj);
        }
        #endregion

        #region --- Bind Partial Views ---
        public PartialViewResult BindMusicLibraryList(int pageNo, int recordPerPage)
        {
            string rightForDelete = "N";
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                if (rightCodes.Contains("~" + GlobalParams.RightCodeForAssignMusic_Music + "~"))
                    rightForDelete = "Y";
            }
            else
            {
                if (rightCodes.Contains("~" + GlobalParams.RightCodeForAssignMusic_NonMusic + "~"))
                    rightForDelete = "Y";
            }

            string rightForLinkShow = "N";

            if (rightCodes.Contains("~" + GlobalParams.RightCodeForAssignMusic_LinkShow + "~"))
                rightForLinkShow = "Y";

            ViewBag.RightForLinkShow = rightForLinkShow;
            ViewBag.RightForDelete = rightForDelete;
            List<USP_List_Assign_Music_Result> lst = GetMusicLibraryList(pageNo, recordPerPage);
            return PartialView("_Music_Title_List", lst);
        }
        public PartialViewResult BindPopupMusicList(string linkShow, int pageNo, int recordPerPage, string mode)
        {
            string viewName = "_Popup_Assign_Music";
            if (linkShow == "Y")
            {
                viewName = "_Popup_Link_Show";
                ViewBag.MODE = mode;
            }
            List<USP_Populate_Music_Result> lst = GetPopupMusicList(pageNo, recordPerPage);
            return PartialView(viewName, lst);
        }
        public PartialViewResult BindPopupMusicError(string linkShow)
        {
            ViewBag.Link_Show = linkShow;
            return PartialView("_Popup_Music_Error_List", lstErrorRecord);
        }

        public PartialViewResult BindEpisodeGrid(int dealMovieCode, string dummyGuid, string linkShow)
        {
            Link_Show_Episode_Play objLink;
            objLink = lstLink_Show_Episode_Play.Where(w => w.Deal_Movie_Code == dealMovieCode).FirstOrDefault();

            string commandName = "ADD_EPISODE";
            if (!string.IsNullOrEmpty(dummyGuid))
                commandName = "EDIT_EPISODE";

            ViewBag.CommandName = commandName;
            ViewBag.DummmyGuid = dummyGuid;
            ViewBag.DealMovieCode = dealMovieCode;
            ViewBag.LinkShow = linkShow;
            List<Episode_Play> lstEpisode_Play = new List<Episode_Play>();

            if (objLink != null)
                lstEpisode_Play = objLink.lstEpisode_Play;

            return PartialView("_Episode_GridView", lstEpisode_Play);
        }

        public PartialViewResult BindEpisodeDetail(string musicCodes)
        {
            string[] arrMusicCode = musicCodes.Trim().Trim(',').Trim().Split(',');

            List<Acq_Deal_Movie_Music_Link> lstMusicLink = new Acq_Deal_Movie_Music_Link_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrMusicCode.Contains(x.Acq_Deal_Movie_Music_Link_Code.ToString())).ToList();

            List<Episode_Play> lstEpisodeDetails = (from objMusic in lstMusicLink
                                                    group objMusic.Episode_No by objMusic.No_Of_Play into newEpisodeList
                                                    select new Episode_Play
                                                    {
                                                        No_Of_Play = (int)newEpisodeList.Key,
                                                        Episode_Numbers_Display = string.Join(", ", newEpisodeList.Select(s => "Episode-" + s.Value).ToArray())
                                                    }).ToList();

            ViewBag.CommandName = "VIEW";
            ViewBag.DummmyGuid = "";
            ViewBag.DealMovieCode = "0";
            ViewBag.LinkShow = "N";
            return PartialView("_Episode_GridView", lstEpisodeDetails);
        }
        #endregion

        #region --- Methods ---
        private List<USP_List_Assign_Music_Result> GetMusicLibraryList(int pageNo, int recordPerPage)
        {
            List<USP_List_Assign_Music_Result> lst = null;
            int RecordCount = 0;
            RecordCount = lstMusicLibrary.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                GetPagingNo(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);

                lst = lstMusicLibrary.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            return lst;
        }
        private List<USP_Populate_Music_Result> GetPopupMusicList(int pageNo, int recordPerPage)
        {
            List<USP_Populate_Music_Result> lst = null;
            int RecordCount = 0;
            RecordCount = lstPopulate_Music_Result.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                GetPagingNo(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);

                lst = lstPopulate_Music_Result.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            return lst;
        }
        private void GetPagingNo(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
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
            noOfRecordTake = 0;
            if (recordCount < (noOfRecordSkip + recordPerPage))
                noOfRecordTake = recordCount - noOfRecordSkip;
            else
                noOfRecordTake = recordPerPage;
        }
        #endregion
    }
}
