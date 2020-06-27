using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Data.Entity.Core.Objects;

namespace RightsU_Plus.Controllers
{
    public class Music_Title_AssignmentController : BaseController
    {
        #region --- Properties ---

        List<USP_Multi_Music_Schedule_Process> lstExcelErrorList
        {
            get
            {
                if (Session["lstExcelErrorList"] == null)
                    Session["lstExcelErrorList"] = new List<USP_Multi_Music_Schedule_Process>();
                return (List<USP_Multi_Music_Schedule_Process>)Session["lstExcelErrorList"];
            }
            set { Session["lstExcelErrorList"] = value; }
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
        private List<USP_List_Content_Result> lstContent
        {
            get
            {
                if (Session["lstContent"] == null)
                    Session["lstContent"] = new List<USP_List_Content_Result>();
                return (List<USP_List_Content_Result>)Session["lstContent"];
            }
            set { Session["lstContent"] = value; }
        }
        private List<USP_List_MusicTrack_Result> lstMusicTrack_All
        {
            get
            {
                if (Session["lstMusicTrack_All"] == null)
                    Session["lstMusicTrack_All"] = new List<USP_List_MusicTrack_Result>();
                return (List<USP_List_MusicTrack_Result>)Session["lstMusicTrack_All"];
            }
            set { Session["lstMusicTrack_All"] = value; }
        }
        private List<USP_List_MusicTrack_Result> lstMusicTrack_Result
        {
            get
            {
                if (Session["lstMusicTrack_Result"] == null)
                    Session["lstMusicTrack_Result"] = new List<USP_List_MusicTrack_Result>();
                return (List<USP_List_MusicTrack_Result>)Session["lstMusicTrack_Result"];
            }
            set { Session["lstMusicTrack_Result"] = value; }
        }
        private List<USP_List_MusicTrack_Result> lstMusicTrack_Result_Selected
        {
            get
            {
                if (Session["lstMusicTrack_Result_Selected"] == null)
                    Session["lstMusicTrack_Result_Selected"] = new List<USP_List_MusicTrack_Result>();
                return (List<USP_List_MusicTrack_Result>)Session["lstMusicTrack_Result_Selected"];
            }
            set { Session["lstMusicTrack_Result_Selected"] = value; }
        }
        private List<USP_List_MusicTrack_Result> lstMusicTrack_Result_Selected_Searched
        {
            get
            {
                if (Session["lstMusicTrack_Result_Selected_Searched"] == null)
                    Session["lstMusicTrack_Result_Selected_Searched"] = new List<USP_List_MusicTrack_Result>();
                return (List<USP_List_MusicTrack_Result>)Session["lstMusicTrack_Result_Selected_Searched"];
            }
            set { Session["lstMusicTrack_Result_Selected_Searched"] = value; }
        }
        public USP_Service objUSPService
        {
            get
            {
                if (Session["objUSPService"] == null)
                    Session["objUSPService"] = new USP_Service(objLoginEntity.ConnectionStringName);
                return (USP_Service)Session["objUSPService"];
            }
            set { Session["objUSPService"] = value; }
        }
        private List<Content_Music_Link> lstContent_Music_Link
        {
            get
            {
                if (Session["lstContent_Music_Link"] == null)
                    Session["lstContent_Music_Link"] = new List<Content_Music_Link>();
                return (List<Content_Music_Link>)Session["lstContent_Music_Link"];
            }
            set { Session["lstContent_Music_Link"] = value; }
        }
        private List<Content_Music_Link> lstContent_Music_Link_Searched
        {
            get
            {
                if (Session["lstContent_Music_Link_Searched"] == null)
                    Session["lstContent_Music_Link_Searched"] = new List<Content_Music_Link>();
                return (List<Content_Music_Link>)Session["lstContent_Music_Link_Searched"];
            }
            set { Session["lstContent_Music_Link_Searched"] = value; }
        }
        private List<Content_Music_Link> Temp_lstContent_Music_Link
        {
            get
            {
                if (Session["Temp_lstContent_Music_Link"] == null)
                    Session["Temp_lstContent_Music_Link"] = new List<Content_Music_Link>();
                return (List<Content_Music_Link>)Session["Temp_lstContent_Music_Link"];
            }
            set { Session["Temp_lstContent_Music_Link"] = value; }
        }
        private List<Title_Content> lstTC
        {
            get
            {
                if (Session["lstTC"] == null)
                    Session["lstTC"] = new List<Title_Content>();
                return (List<Title_Content>)Session["lstTC"];
            }
            set { Session["lstTC"] = value; }
        }
        private List<RightsU_Entities.Title> lstT
        {
            get
            {
                if (Session["lstT"] == null)
                    Session["lstT"] = new List<RightsU_Entities.Title>();
                return (List<RightsU_Entities.Title>)Session["lstT"];
            }
            set { Session["lstT"] = value; }
        }
        private Title_Content objTC
        {
            get
            {
                if (Session["objTC"] == null)
                    Session["objTC"] = new Title_Content();
                return (Title_Content)Session["objTC"];
            }
            set { Session["objTC"] = value; }
        }
        public Title_Content_Service objTC_Service
        {
            get
            {
                if (Session["objTC_Service"] == null)
                    Session["objTC_Service"] = new Title_Content_Service(objLoginEntity.ConnectionStringName);
                return (Title_Content_Service)Session["objTC_Service"];
            }
            set { Session["objTC_Service"] = value; }
        }
        private List<USP_GetContentRestrictionRemarks_Result> lstContentRestrictionRemarks
        {
            get
            {
                if (Session["lstContentRestrictionRemarks"] == null)
                    Session["lstContentRestrictionRemarks"] = new List<USP_GetContentRestrictionRemarks_Result>();
                return (List<USP_GetContentRestrictionRemarks_Result>)Session["lstContentRestrictionRemarks"];
            }
            set { Session["lstContentRestrictionRemarks"] = value; }
        }
        private List<Content_Music_Link> lstCML
        {
            get
            {
                if (Session["lstCML"] == null)
                    Session["lstCML"] = new List<Content_Music_Link>();
                return (List<Content_Music_Link>)Session["lstCML"];
            }
            set { Session["lstCML"] = value; }
        }
        private List<Content_Music_Link> lstContent_Music_Link_View
        {
            get
            {
                if (Session["lstContent_Music_Link_View"] == null)
                    Session["lstContent_Music_Link_View"] = new List<Content_Music_Link>();
                return (List<Content_Music_Link>)Session["lstContent_Music_Link_View"];
            }
            set { Session["lstContent_Music_Link_View"] = value; }
        }
        private List<Content_Music_Link> lstContent_Music_Link_View_Searched
        {
            get
            {
                if (Session["lstContent_Music_Link_View_Searched"] == null)
                    Session["lstContent_Music_Link_View_Searched"] = new List<Content_Music_Link>();
                return (List<Content_Music_Link>)Session["lstContent_Music_Link_View_Searched"];
            }
            set { Session["lstContent_Music_Link_View_Searched"] = value; }
        }
        #endregion

        #region --- Other Method ---
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

        #region --- Binding and Index ---

        public ViewResult Index()
        {
            Music_Title_Search obj = objPage_Properties;
            System_Parameter_New_Service objSPService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            if (objSPService.SearchFor(s => s.Parameter_Name == "FrameLimit").Count() > 0)
                ViewBag.FrameLimit = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "FrameLimit").Select(s => s.Parameter_Value).First();
            else
                ViewBag.FrameLimit = "24";

            lstTC = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            lstT = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            lstCML = new Content_Music_Link_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            lstMusicTrack_All = objUSPService.USP_List_MusicTrack("").ToList();
            lstMusicTrack_Result.Clear();
            lstMusicTrack_Result_Selected.Clear();
            lstContent_Music_Link.Clear();
            lstContent_Music_Link_Searched.Clear();
            Temp_lstContent_Music_Link.Clear();
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicTrackAssignment);
            return View("~/Views/Music_Title_Assignment/Index.cshtml");
        }

        public JsonResult SearchMusicTrack(string searchText, bool fetchData, int PageNo, int PageSize, char isClear)
        {
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            ViewBag.PageNo = objPage_Properties.PageNo;
            List<USP_List_Music_Title_Result> MusicTitleList;

            if (fetchData)
                if (isClear == 'Y')
                    lstMusicTrack_Result.Clear();
                else
                    lstMusicTrack_Result = objUSPService.USP_List_MusicTrack(searchText).ToList();
            else
            {
                lstMusicTrack_Result.Clear();
                objPage_Properties.isAdvanced = "Y";
                MusicTitleList = objUSP.USP_List_Music_Title("", PageNo, objLoginUser.System_Language_Code, objRecordCount, "Y", PageSize,
                    objPage_Properties.StarCastCodes_Search, "", objPage_Properties.AlbumsCodes_Search, "", objPage_Properties.MusicLabelCodes_Search, "", "", "", "", objPage_Properties.MusicTitleName_Search, "","","").ToList();

                MusicTitleList.Remove(MusicTitleList.ElementAt(0));
                foreach (var item in MusicTitleList)
                {
                    USP_List_MusicTrack_Result objLMTR = new USP_List_MusicTrack_Result();
                    objLMTR.Movie_Album = item.Movie_Album;
                    objLMTR.Music_Label_Name = item.Music_Label;
                    objLMTR.Music_Title_Code =  Convert.ToInt32(item.Music_Title_Code);
                    objLMTR.Music_Title_Name = item.Music_Title_Name;
                    objLMTR.Release_Year = Convert.ToInt32(item.Release_Year);
                    lstMusicTrack_Result.Add(objLMTR);
                }

                RecordCount = Convert.ToInt32(objRecordCount.Value);
                ViewBag.RecordCount = RecordCount;

            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            if (fetchData)
                obj.Add("Record_Count", lstMusicTrack_Result.Where(w => !w.isSelected).Count());
            else
                obj.Add("Record_Count", RecordCount);


            return Json(obj);
        }

        private List<USP_List_MusicTrack_Result> GetMusicTrackList(int pageNo, int recordPerPage, out int newPageNo)
        {
            List<USP_List_MusicTrack_Result> lst = new List<USP_List_MusicTrack_Result>();
            int RecordCount = 0;
            RecordCount = lstMusicTrack_Result.Where(w => !w.isSelected).Count();

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstMusicTrack_Result.Where(w => !w.isSelected).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            newPageNo = pageNo;

            return lst;
        }

        public PartialViewResult BindMusicTrackList(int pageNo, int recordPerPage, string command)
        {
            ViewBag.CallFor = "LIST";
            int newPageNo = 0;
            List<USP_List_MusicTrack_Result> lst = GetMusicTrackList(pageNo, recordPerPage, out newPageNo);
            return PartialView("~/Views/Music_Title_Assignment/_Music_Track_List.cshtml", lst);
        }

        public JsonResult SearchMusicTrack_Selected(string searchText, string commandName, string SelectedContentLinkGUID)
        {
            // lstMusicTrack_Result_Selected_Searched.Clear();
            if (!string.IsNullOrEmpty(searchText))
            {
                lstMusicTrack_Result_Selected_Searched = lstMusicTrack_Result_Selected.Where(w => w.Music_Title_Name.ToUpper().Contains(searchText.ToUpper())
                      || w.Music_Label_Name.ToUpper().Contains(searchText.ToUpper())
                      || w.Movie_Album.ToUpper().Contains(searchText.ToUpper())
                    ).ToList();
            }
            else
                lstMusicTrack_Result_Selected_Searched = lstMusicTrack_Result_Selected;


            //lstUser_Searched = lstUser.Where(w => w.First_Name.ToUpper().Contains(searchText.ToUpper())
            //  || w.Last_Name.ToUpper().Contains(searchText.ToUpper())
            //  ).ToList();


            string strAllContentLinkGUID = "," + string.Join(",", lstMusicTrack_Result_Selected_Searched.Select(s => s.Dummy_Guid).ToArray()) + ",";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Record_Count", lstMusicTrack_Result_Selected_Searched.Where(w => true).Count());
            obj.Add("AllContentLinkGUID", strAllContentLinkGUID);
            obj.Add("SelectedContentLinkGUID", SelectedContentLinkGUID);
            return Json(obj);
        }

        public PartialViewResult BindMusicTrack_Selected(int pageNo, int recordPerPage, string mode = "")
        {
            int newPageNo = 0;
            ViewBag.Mode = mode;
            ViewBag.CallFor = "SELECTED";
            List<USP_List_MusicTrack_Result> lst = GetMusicTrackList_Selected(pageNo, recordPerPage, out newPageNo);
            return PartialView("~/Views/Music_Title_Assignment/_Music_Track_List.cshtml", lst);
        }

        private List<USP_List_MusicTrack_Result> GetMusicTrackList_Selected(int pageNo, int recordPerPage, out int newPageNo)
        {
            List<USP_List_MusicTrack_Result> lst = new List<USP_List_MusicTrack_Result>();
            int RecordCount = 0;
            RecordCount = lstMusicTrack_Result_Selected_Searched.Where(w => !w.isSelected).Count();

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstMusicTrack_Result_Selected_Searched.Where(w => !w.isSelected).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            newPageNo = pageNo;

            return lst;
        }

        #endregion

        public JsonResult AddToMusicTrackList(string[] musicTrackList, string callFor, int Music_Title_Code)
        {
            string Music_Title_Name = "";
            int MusicTitleCode = 0;
            foreach (string dummyGuid in musicTrackList) 
            {
                USP_List_MusicTrack_Result objMT = new USP_List_MusicTrack_Result();
                objMT = lstMusicTrack_Result.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
                if (objMT == null)
                {
                    objMT = lstMusicTrack_All.Where(w => w.Music_Title_Code == Music_Title_Code).FirstOrDefault();
                }
                if (callFor == "SELECTED")
                {
                    Music_Title_Name = objMT.Music_Title_Name;
                    MusicTitleCode = objMT.Music_Title_Code;
                }
                else
                {
                    var a = (from u in lstMusicTrack_Result_Selected where u.Dummy_Guid.Contains(objMT.Dummy_Guid) select u).AsEnumerable().ToList();
                    if (a.Count == 0)
                    {
                        var b = (from u in lstMusicTrack_Result_Selected where u.Music_Title_Code == objMT.Music_Title_Code select u).AsEnumerable().ToList();
                        if (b.Count == 0)
                        {
                            // lstMusicTrack_Result_Selected_Searched.Insert(0, objMT);
                            lstMusicTrack_Result_Selected.Insert(0, objMT);
                        }
                    }
                }
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", "S");
            obj.Add("Linked_Record_Count", lstMusicTrack_Result_Selected_Searched.Count);
            obj.Add("Music_Title_Name", Music_Title_Name);
            obj.Add("Music_Title_Code", MusicTitleCode);
            return Json(obj);
        }

        #region --- Delete Code ---

        public JsonResult DeleteSelectedMusicTrack(string Dummy_Guid)
        {
            var st = lstMusicTrack_Result_Selected.Find(c => c.Dummy_Guid == Dummy_Guid);
            var list = Temp_lstContent_Music_Link.Where(x => x.Music_Title_Code == st.Music_Title_Code).ToList();
            foreach (var item in list)
            {
                Temp_lstContent_Music_Link.Remove(item);
            }
            lstMusicTrack_Result_Selected.Remove(st);
            var obj = new
            {
                Status = "S",
            };
            return Json(obj);
        }

        public JsonResult DeleteCML(string Dummy_Guid)
        {
            var st = Temp_lstContent_Music_Link.Find(c => c.Dummy_Guid == Dummy_Guid);
            Temp_lstContent_Music_Link.Remove(st);
            var obj = new
            {
                Status = "S",
            };
            return Json(obj);
        }

        #endregion

        #region --- Content music link list ---

        public JsonResult SearchContent_Music_Link(string searchText, string episodeFrom, string episodeTo, string music_Title_Code, string commandName) //, string SelectedContentLinkGUID
        {
            List<Content_Music_Link> temp_List = new List<Content_Music_Link>();
            int EpisodeFrom = 0;
            int EpisodeTo = 0;

            int Music_Title_Code = 0;
            if (music_Title_Code != "")
            {
                Music_Title_Code = Convert.ToInt32(music_Title_Code);
            }

            // if (searchText != "" && episodeFrom != "" && episodeTo != "")
            if (searchText != "")
            {
                EpisodeFrom = episodeFrom != "" ? Convert.ToInt32(episodeFrom) : 0 ;
                EpisodeTo = episodeTo != "" ? Convert.ToInt32(episodeTo) : 0 ;
            }
            // if (searchText != "" && EpisodeFrom > 0 && EpisodeTo > 0)
            if (searchText != "")
            {
                lstContent = objUSPService.USP_List_Content(searchText, EpisodeFrom, EpisodeTo).ToList();
                lstContent_Music_Link_Searched = Temp_lstContent_Music_Link.Where(x => x.Music_Title_Code == Music_Title_Code).ToList();
                temp_List = Temp_lstContent_Music_Link.Where(x => x.Music_Title_Code == Music_Title_Code).ToList();
                lstContent_Music_Link_Searched.Clear();
                foreach (var lstC in lstContent)
                {
                    foreach (var item in temp_List)
                    {
                        if (lstC.Title_Content_Code == item.Title_Content_Code)
                        {
                            lstContent_Music_Link_Searched.Add(item);
                        }
                    }
                }
            }
            else
            {
                lstContent_Music_Link_Searched = Temp_lstContent_Music_Link;
            }
            string strAllContentLinkGUID = "," + string.Join(",", lstContent_Music_Link_Searched.Select(s => s.Dummy_Guid).Distinct().ToArray()) + ",";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Record_Count", lstContent_Music_Link_Searched.Where(w => w.Music_Title_Code == Music_Title_Code).Distinct().Count());
            return Json(obj);
        }

        private List<Content_Music_Link> GetContentMusicLinkList(int pageNo, int recordPerPage, int MusicTitleCode, out int newPageNo)
        {
            List<Content_Music_Link> lst = new List<Content_Music_Link>();
            int RecordCount = 0;
            RecordCount = lstContent_Music_Link_Searched.Where(x => x.Music_Title_Code == MusicTitleCode).Distinct().Count();

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstContent_Music_Link_Searched.Where(x => x.Music_Title_Code == MusicTitleCode).Skip(noOfRecordSkip).Take(noOfRecordTake).Distinct().ToList();
            }
            newPageNo = pageNo;

            return lst;
        }

        private List<SelectListItem> BindEpisodeDDL_Edit(string Content_Name, int episodeNo, int title_Code)
        {
            List<SelectListItem> lstEpisodeNo = new List<SelectListItem>();
            var a = lstTC.Where(x => x.Episode_Title == Content_Name).GroupBy(x => x.Episode_Title).Select(x => x.FirstOrDefault());
            if (a == null)
            {
                List<RightsU_Entities.Title_Content> TEMPLIST = lstTC.Where(x => x.Title_Code == title_Code).ToList();
                var Title_Content_Code = TEMPLIST.Where(x => x.Episode_No == episodeNo).Select(x => x.Title_Content_Code);
                lstEpisodeNo = new SelectList(TEMPLIST, "Title_Content_Code", "Episode_No", Title_Content_Code.ElementAt(0)).ToList();
            }
            else
            {
                List<RightsU_Entities.Title_Content> TEMPLIST = lstTC.Where(x => x.Title_Code == title_Code).ToList();
                var Title_Content_Code = TEMPLIST.Where(x => x.Episode_No == episodeNo).Select(x => x.Title_Content_Code);
                Dictionary<string, object> objJson = new Dictionary<string, object>();
                lstEpisodeNo = new SelectList(TEMPLIST, "Title_Content_Code", "Episode_No", Title_Content_Code.ElementAt(0)).ToList();
            }
            return lstEpisodeNo;
        }

        public PartialViewResult BindContentMusicLinkList(int pageNo, int recordPerPage, string commandName = "", int MusicTitleCode = 0, string DummyID = "", string episodeTitle = "", int episodeNo = 0, int title_Code = 0, int version_Code = 0)
        {
            int newPageNo = 0;
            if (commandName == "EDIT")
            {
                ViewBag.Action = "EDIT";
                ViewBag.dummyID = DummyID;
                ViewBag.EpisodeNo = BindEpisodeDDL_Edit(episodeTitle, episodeNo, title_Code);
                ViewBag.VersionList_Edit = new SelectList(new Version_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Version_Name != "").ToList(), "Version_Code", "Version_Name", version_Code);
            }
                ViewBag.VersionList = new SelectList(new Version_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Version_Name != "").ToList(), "Version_Code", "Version_Name");
            List<Content_Music_Link> lst = GetContentMusicLinkList(pageNo, recordPerPage, MusicTitleCode, out newPageNo);
            return PartialView("~/Views/Music_Title_Assignment/_Content_Music_Link_List.cshtml", lst);
        }

        public JsonResult SaveContentMusicLink(List<Content_Music_Link> lstCML, string SelectedContentLinkGUID, string callOn, string key)
        {
            int? MTC = 0;
            string status = "S";
            if (callOn == "S")
            {
                if (lstCML != null)
                {
                    foreach (Content_Music_Link objCML_MVC in lstCML)
                    {
                        Content_Music_Link objContent_Music_Link = new Content_Music_Link();
                        objContent_Music_Link.Last_UpDated_Time = System.DateTime.Now;
                        MTC = objCML_MVC.Music_Title_Code;
                        if (key == "ADD")
                        {
                            objContent_Music_Link.From = objCML_MVC.From;
                            objContent_Music_Link.From_Frame = objCML_MVC.From_Frame;
                            objContent_Music_Link.To = objCML_MVC.To;
                            objContent_Music_Link.To_Frame = objCML_MVC.To_Frame;
                            objContent_Music_Link.Duration = objCML_MVC.Duration;
                            objContent_Music_Link.Duration_Frame = objCML_MVC.Duration_Frame;
                            objContent_Music_Link.Title_Content_Code = objCML_MVC.Title_Content_Code;
                            objContent_Music_Link.Version_Code = objCML_MVC.Version_Code;
                            objContent_Music_Link.Music_Title_Code = objCML_MVC.Music_Title_Code;
                            objContent_Music_Link.Last_Action_By = objLoginUser.Users_Code;
                            objContent_Music_Link.EntityState = State.Added;
                            Temp_lstContent_Music_Link.Add(objContent_Music_Link);
                        }
                        else
                        {
                            Content_Music_Link objCML_S = Temp_lstContent_Music_Link.Where(w => w.Dummy_Guid == objCML_MVC.Dummy_Guid).FirstOrDefault();
                            Temp_lstContent_Music_Link.Remove(Temp_lstContent_Music_Link.Where(w => w.Dummy_Guid == objCML_MVC.Dummy_Guid).FirstOrDefault());
                            if (objCML_S != null)
                            {
                                objContent_Music_Link.From = objCML_MVC.From;
                                objContent_Music_Link.From_Frame = objCML_MVC.From_Frame;
                                objContent_Music_Link.To = objCML_MVC.To;
                                objContent_Music_Link.To_Frame = objCML_MVC.To_Frame;
                                objContent_Music_Link.Duration = objCML_MVC.Duration;
                                objContent_Music_Link.Duration_Frame = objCML_MVC.Duration_Frame;
                                objContent_Music_Link.Title_Content_Code = objCML_MVC.Title_Content_Code;
                                objContent_Music_Link.Version_Code = objCML_MVC.Version_Code;
                                objContent_Music_Link.Music_Title_Code = objCML_MVC.Music_Title_Code;
                                objContent_Music_Link.Last_Action_By = objLoginUser.Users_Code;
                                objContent_Music_Link.EntityState = State.Added;
                                Temp_lstContent_Music_Link.Add(objContent_Music_Link);
                            }
                        }
                    }
                }
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("recordCount", lstContent_Music_Link_Searched.Where(x => x.Music_Title_Code == MTC).Count());
            return Json(obj);
        }

        public JsonResult SaveAllContentMusicLink()
        {
            string status = "S";
            List<Music_Content_Assignment_UDT> lstMusic_Content_Assignment_UDT = new List<Music_Content_Assignment_UDT>();
            Content_Music_Link_Service objService = new Content_Music_Link_Service(objLoginEntity.ConnectionStringName);
            if (Temp_lstContent_Music_Link.Count > 0)
            {
                foreach (var item in Temp_lstContent_Music_Link)
                {
                    dynamic resultSet;
                    bool isValid = true;
                    Title_Content_Version_Service objTCS = new Title_Content_Version_Service(objLoginEntity.ConnectionStringName);
                    Title_Content_Version objTCV = objTCS.SearchFor(s => s.Title_Content_Code == item.Title_Content_Code && s.Version_Code == item.Version_Code).FirstOrDefault();
                    if (objTCV == null)
                    {
                        objTCV = new Title_Content_Version();
                        objTCV.Title_Content_Code = item.Title_Content_Code;
                        objTCV.Version_Code = item.Version_Code;
                        objTCV.EntityState = State.Added;
                        isValid = objTCS.Save(objTCV, out resultSet);
                    }

                    if (isValid)
                    {
                        Content_Music_Link objContent_Music_Link = new Content_Music_Link();
                        objContent_Music_Link._Dummy_Guid = item.Dummy_Guid;
                        objContent_Music_Link.Duration = item.Duration;
                        objContent_Music_Link.Duration_Frame = item.Duration_Frame;
                        objContent_Music_Link.From = item.From;
                        objContent_Music_Link.From_Frame = item.From_Frame;
                        objContent_Music_Link.To = item.To;
                        objContent_Music_Link.To_Frame = item.To_Frame;
                        objContent_Music_Link.Music_Title_Code = item.Music_Title_Code;
                        objContent_Music_Link.Title_Content_Code = item.Title_Content_Code;
                        objContent_Music_Link.Title_Content_Version_Code = objTCV.Title_Content_Version_Code;
                        objContent_Music_Link.Inserted_By = objLoginUser.Users_Code;
                        objContent_Music_Link.Inserted_On = System.DateTime.Now;
                        objContent_Music_Link.Last_Action_By = objLoginUser.Users_Code;
                        objContent_Music_Link.Last_UpDated_Time = System.DateTime.Now;
                        objContent_Music_Link.EntityState = State.Added;
                        isValid = objService.Save(objContent_Music_Link, out resultSet);
                        if (!isValid)
                            status = "E";
                        else
                        {
                            Music_Content_Assignment_UDT objMusic_Content_Assignment_UDT = new Music_Content_Assignment_UDT();
                            objMusic_Content_Assignment_UDT.Duration = Convert.ToString(item.Duration);
                            objMusic_Content_Assignment_UDT.Duration_Frame = item.Duration_Frame;
                            objMusic_Content_Assignment_UDT.From = Convert.ToString(item.From);
                            objMusic_Content_Assignment_UDT.From_Frame = item.From_Frame;
                            objMusic_Content_Assignment_UDT.To = Convert.ToString(item.To);
                            objMusic_Content_Assignment_UDT.To_Frame = item.To_Frame;
                            objMusic_Content_Assignment_UDT.Music_Title_Code = item.Music_Title_Code;
                            objMusic_Content_Assignment_UDT.Title_Content_Code = item.Title_Content_Code;
                            lstMusic_Content_Assignment_UDT.Add(objMusic_Content_Assignment_UDT);
                        }
                    }
                    else
                    {
                        status = "Ë";
                    }
                }
                if (status == "S")
                {
                    
                    if (lstMusic_Content_Assignment_UDT != null && lstMusic_Content_Assignment_UDT.Count() > 0)
                    {  
                        lstExcelErrorList = null;
                        lstExcelErrorList = new USP_Service(objLoginEntity.ConnectionStringName).USP_Multi_Music_Schedule_Process(lstMusic_Content_Assignment_UDT).ToList();
                        var pl = from r in Temp_lstContent_Music_Link
                                 orderby r.Title_Content_Code
                                 group r by r.Title_Content_Code into grp
                                 select new { key = grp.Key, cnt = grp.Count() };
                        foreach (var item in pl)
                        {
                            AddContentStatusHistoryObject(Convert.ToInt32(item.key), Convert.ToInt32(item.cnt), "I");
                        }
                    }
                    ClearAllList();
                    lstTC = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                    lstCML = new Content_Music_Link_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                    lstT = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                    lstMusicTrack_All = objUSPService.USP_List_MusicTrack("").ToList();
                }
            }
            else
                status = "N";
            var obj = new
            {
                Status = status,
            };
            return Json(obj);
        }

        private void ClearAllList()
        {
            lstT.Clear();
            lstTC.Clear();
            lstCML.Clear();
            lstMusicTrack_Result.Clear();
            lstMusicTrack_Result_Selected.Clear();
            lstContent_Music_Link.Clear();
            lstContent_Music_Link_Searched.Clear();
            Temp_lstContent_Music_Link.Clear();
        }

        private void AddContentStatusHistoryObject(int title_Content_Code, int recordCount, string userAction)
        {
            if (recordCount > 0)
            {
                Content_Status_History_Service objService = new Content_Status_History_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Content_Status_History objCSH = new RightsU_Entities.Content_Status_History();
                objCSH.User_Code = objLoginUser.Users_Code;
                objCSH.Title_Content_Code = title_Content_Code;
                objCSH.User_Action = userAction;
                objCSH.Record_Count = recordCount;
                objCSH.Created_On = DateTime.Now;
                objCSH.EntityState = State.Added;
                dynamic resultSet;
                bool isValid = objService.Save(objCSH, out resultSet);
            }
        }

        public JsonResult PopulateTitleContent(string searchPrefix = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(searchPrefix))
            {
                result = new USP_Service(objLoginEntity.ConnectionStringName).USP_PopulateContent(searchPrefix).ToList();
            }
            return Json(result);
        }

        public JsonResult BindEpisodeDDL(string Content_Name, int Content_Code)
        {
            List<RightsU_Entities.Title_Content> TEMPLIST = lstTC.Where(x => x.Title_Code == Content_Code).OrderBy(x=>x.Episode_No).ToList();
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            SelectList lstEpisodeNo = new SelectList(TEMPLIST.Select(i => new { Display_Value = i.Title_Content_Code, Display_Text = i.Episode_No }), "Display_Value", "Display_Text");
            objJson.Add("lstEpisodeNo", lstEpisodeNo);
            return Json(objJson);
        }

        #endregion

        #region  --- Advance Search ---

        public JsonResult BindAdvanced_Search_Controls()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();

            var lstTalent = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Talent_Name().ToList();

            var lstStarCast = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_StarCast);

            MultiSelectList lstMLabel = new MultiSelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Select(i => new { Display_Value = i.Music_Label_Code, Display_Text = i.Music_Label_Name }).ToList(),
                "Display_Value", "Display_Text");

            MultiSelectList lstMStarCast = new MultiSelectList(lstStarCast.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
                "Display_Value", "Display_Text");


            objJson.Add("lstMStarCast", lstMStarCast);

            objJson.Add("lstMLabel", lstMLabel);

            objPage_Properties.StarCastCodes_Search = "";
            objPage_Properties.AlbumsCodes_Search = "";
            objPage_Properties.MusicLabelCodes_Search = "";
            objPage_Properties.MusicTitleName_Search = "";

            objJson.Add("objPage_Properties", objPage_Properties);
            return Json(objJson);
        }

        public void AdvanceSearch(string SrchStarCast = "", string SrchMusicLabel = "", string SrchMusic = "", string SrchAlbum = "")
        {
            if (SrchAlbum != "")
            {
                SrchAlbum = SrchAlbum.Replace("﹐", ",");
            }

            objPage_Properties.StarCastCodes_Search = SrchStarCast;
            objPage_Properties.AlbumsCodes_Search = SrchAlbum;
            objPage_Properties.MusicLabelCodes_Search = SrchMusicLabel;
            objPage_Properties.MusicTitleName_Search = SrchMusic;

            objPage_Properties.isAdvanced = "Y";
        }

        public JsonResult AutoMovieAlbum(string keyword)
        {
            List<string> terms = keyword.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            var result = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name.ToUpper().Contains(searchString.ToUpper())).Distinct()
                .Select(x => new { Music_Album_Name = x.Music_Album_Name, Music_Album_Code = x.Music_Album_Code }).ToList();

            return Json(result);
        }

        public JsonResult Bind_Title(int Selected_BUCode, string Selected_Title_Codes = "", string Searched_Title = "")//int Selected_deal_type_Code, 
        {
            List<string> terms = Searched_Title.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            Music_Title_Service objMusicTitle = new Music_Title_Service(objLoginEntity.ConnectionStringName);
            string searchString = terms.LastOrDefault().ToString().Trim();
            var result = objMusicTitle.SearchFor(x => x.Is_Active == "Y" && x.Music_Title_Name.Contains(searchString) && !terms.Contains(x.Music_Title_Name))
                .Select(i => new { Music_Title_Name = i.Music_Title_Name, Music_Title_Code = 0 }).Distinct().ToList();

            return Json(result);
        }

        #endregion

        #region ---  CML VIEW Popup

        public PartialViewResult ViewCML(int Music_Title_Code)
        {
            if (Music_Title_Code > 0)
                lstContent_Music_Link_View_Searched = lstContent_Music_Link_View = lstCML.Where(c => c.Music_Title_Code == Music_Title_Code).ToList();
            ViewBag.MusicTitleCode = Music_Title_Code;
            return PartialView("~/Views/Music_Title_Assignment/_Title_Content_View.cshtml");
        }

        public JsonResult PopulateContentCML(string searchPrefix = "", int music_Title_Code = 0)
        {
            List<string> terms = searchPrefix.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();

            dynamic result = "";
            if (!string.IsNullOrEmpty(searchString))
            {
                result = new USP_Service(objLoginEntity.ConnectionStringName).USP_PopulateContent(searchString).ToList();
            }
            return Json(result);
        }

        public PartialViewResult BindContentTypeView(int pageNo, int recordPerPage)
        {
            List<RightsU_Entities.Content_Music_Link> lst = new List<RightsU_Entities.Content_Music_Link>();
            int RecordCount = 0;
            RecordCount = lstContent_Music_Link_View_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstContent_Music_Link_View_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            return PartialView("~/Views/Music_Title_Assignment/_Title_Content_List.cshtml", lst);
        }

        public JsonResult SearchContentTypeView(string searchText, string episodeFrom, string episodeTo, string musicTitleCode)
        {
            List<Content_Music_Link> temp_List = new List<Content_Music_Link>();
            int EpisodeFrom = 0;
            int EpisodeTo = 0;

            int Music_Title_Code = 0;
            if (musicTitleCode != "")
            {
                Music_Title_Code = Convert.ToInt32(musicTitleCode);
            }
            List<USP_List_Content_Result> lst_searchedCMLView = new List<USP_List_Content_Result>();
            if (searchText != "" && episodeFrom != "" && episodeTo != "")
            {
                EpisodeFrom = Convert.ToInt32(episodeFrom);
                EpisodeTo = Convert.ToInt32(episodeTo);
            }
            if (searchText != "" && EpisodeFrom > 0 && EpisodeTo > 0)
            {
                lst_searchedCMLView = objUSPService.USP_List_Content(searchText, EpisodeFrom, EpisodeTo).ToList();
                lstContent_Music_Link_View_Searched.Clear();
                temp_List = lstCML.Where(c => c.Music_Title_Code == Music_Title_Code).ToList();
                foreach (var lstC in lst_searchedCMLView)
                {
                    foreach (var item in temp_List)
                    {
                        if (lstC.Title_Content_Code == item.Title_Content_Code)
                        {
                            lstContent_Music_Link_View_Searched.Add(item);
                        }
                    }
                }
            }
            else
            {
                lstContent_Music_Link_View_Searched.Clear();
                lstContent_Music_Link_View.Clear();
                lstContent_Music_Link_View_Searched = lstContent_Music_Link_View = lstCML.Where(c => c.Music_Title_Code == Music_Title_Code).ToList();
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Record_Count", lstContent_Music_Link_View_Searched.Where(w => w.Music_Title_Code == Music_Title_Code).Count());
            return Json(obj);
        }

        #endregion

    }
}

