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
    public class Title_ContentController : BaseController
    {
        #region --- Properties ---
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
        public Title_Content_Search objSearch
        {
            get
            {
                if (Session["objSearch"] == null)
                    Session["objSearch"] = new Title_Content_Search();
                return (Title_Content_Search)Session["objSearch"];
            }
            set { Session["objSearch"] = value; }
        }
        private List<USP_GetRunDefinitonForContent_Result> lstContentRunDefData
        {
            get
            {
                if (Session["lstContentRunDefData"] == null)
                    Session["lstContentRunDefData"] = new List<USP_GetRunDefinitonForContent_Result>();
                return (List<USP_GetRunDefinitonForContent_Result>)Session["lstContentRunDefData"];
            }
            set { Session["lstContentRunDefData"] = value; }
        }
        public string Title_Content_Code
        {
            get
            {
                if (Session["Title_Content_Code"] == null)
                    Session["Title_Content_Code"] = "";
                return Convert.ToString(Session["Title_Content_Code"]);
            }
            set
            {
                Session["Title_Content_Code"] = value;
            }
        }
        #endregion

        #region --- List ---
        public ViewResult Index(string IsMenu = "Y")
        {
            System_Parameter_New_Service objSPService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            if (objSPService.SearchFor(s => s.Parameter_Name == "FrameLimit").Count() > 0)
                ViewBag.FrameLimit = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "FrameLimit").Select(s => s.Parameter_Value).First();
            else
                ViewBag.FrameLimit = "24";
            ViewBag.IsMenu = IsMenu;
            if (IsMenu == "Y")
                ViewBag.RecordPerPage = "10";
            else
                ViewBag.RecordPerPage = objSearch.RecordPerPage;
            ViewBag.PageNo = objSearch.PageNo;
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForContent);
            return View("~/Views/Title_Content/Index.cshtml");
        }

        public PartialViewResult BindPartialPage(string key, string mode, string IsMenu = "Y")
        {
            if (key == "LIST_PAGE")
            {
                string searchText = "";
                int episodeFrom = 0, episodeTo = 0, pageNo = 1, recordPerPage = 10;
                if (IsMenu != "Y")
                {
                    searchText = objSearch.SearchText;
                    episodeFrom = objSearch.EpisodeFrom;
                    episodeTo = objSearch.EpisodeTo;
                    pageNo = objSearch.PageNo;
                    recordPerPage = objSearch.RecordPerPage;
                }
                else
                {
                    objSearch = null;
                    lstContent = null;
                    lstContentRestrictionRemarks = null;
                    ClearSession();
                }

                ViewBag.SearchText = searchText;
                ViewBag.EpisodeFrom = episodeFrom;
                ViewBag.EpisodeTo = episodeTo;
                ViewBag.PageNo = pageNo;
                ViewBag.RecordPerPage = recordPerPage;
                return PartialView("~/Views/Title_Content/_Title_Content.cshtml");
            }
            else
            {
                ViewBag.Mode = mode;
                return PartialView("~/Views/Title_Content/_Assign_Music.cshtml");
            }
        }

        public JsonResult SearchProgram(string searchText, int episodeFrom, int episodeTo)
        {
            string Title_Content_Codes = "";
            string ListSearchedFromTitle = "";
            string TitleUrl = "";
            if (TempData["SearchTitleInTitleContent"] != null)
            {
                searchText = Convert.ToString(TempData["SearchTitleInTitleContent"]);
                ViewBag.ListSearchedFromTitle = "Y";
                TitleUrl = Convert.ToString(TempData["CurrentTitleURL"]);
                ListSearchedFromTitle = "Y";
            }
            if (objSearch.SearchText != null && objSearch.EpisodeFrom > 0 && objSearch.EpisodeTo > 0)
            {
                if (searchText == "" && episodeFrom == 0 && episodeTo == 0)
                {
                    searchText = objSearch.SearchText;
                    episodeFrom = objSearch.EpisodeFrom;
                    episodeTo = objSearch.EpisodeTo;
                }
            }

            if (searchText != "" && episodeFrom > 0 && episodeTo > 0)
            {
                objSearch.SearchText = searchText;
                objSearch.EpisodeFrom = episodeFrom;
                objSearch.EpisodeTo = episodeTo;
                searchText = searchText.Replace('﹐', '~');
                lstContent = objUSPService.USP_List_Content(searchText, episodeFrom, episodeTo).OrderByDescending(o => o.Last_Updated_Time).ToList();
            }
            else if (searchText == "" && episodeFrom == 0 && episodeTo == 0)
            {
                objSearch.SearchText = searchText;
                objSearch.EpisodeFrom = episodeFrom;
                objSearch.EpisodeTo = episodeTo;
                searchText = searchText.Replace('﹐', '~');
                lstContent = objUSPService.USP_List_Content(searchText, episodeFrom, episodeTo).OrderByDescending(o => o.Last_Updated_Time).ToList();
                Title_Content_Codes = string.Join(",", lstContent.Select(s => s.Title_Content_Code));
            }
            else if (
                (searchText != "" && episodeFrom == 0 && episodeTo == 0)
                || (searchText != "" && episodeFrom > 0 && episodeTo == 0)
                || (searchText != "" && episodeFrom == 0 && episodeTo > 0)
                )
            {
                objSearch.SearchText = searchText;
                objSearch.EpisodeFrom = episodeFrom;
                objSearch.EpisodeTo = episodeTo;
                searchText = searchText.Replace('﹐', '~');
                lstContent = objUSPService.USP_List_Content(searchText, episodeFrom, episodeTo).OrderByDescending(o => o.Last_Updated_Time).ToList();
                Title_Content_Codes = string.Join(",", lstContent.Select(s => s.Title_Content_Code));
            }

            Title_Content_Code = string.Join(",", lstContent.Select(s => s.Title_Content_Code));
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Record_Count", lstContent.Count);
            obj.Add("ListSearchedFromTitle", ListSearchedFromTitle);
            obj.Add("TitleUrl", TitleUrl);
            obj.Add("PopulateSearchBox", searchText);
            return Json(obj);
        }

        public PartialViewResult BindProgramList(int pageNo, int recordPerPage, int contentCodeForEdit, string Is_BulkImportExport = "N")
        {
            objSearch.PageNo = pageNo;
            objSearch.RecordPerPage = recordPerPage;

            string rightCodes = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForContent), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList().FirstOrDefault();
            if (string.IsNullOrEmpty(rightCodes))
                rightCodes = "";
            ViewBag.RightCode = rightCodes;
            int newPageNo = 0;
            ViewBag.ContentCodeForEdit = contentCodeForEdit;
            List<USP_List_Content_Result> lst = GetContentList(pageNo, recordPerPage, out newPageNo);
            ViewBag.SrNo_StartFrom = ((newPageNo - 1) * recordPerPage);
            if (Is_BulkImportExport == "Y")
                return PartialView("~/Views/Title_Content_ImportExport/_Music_Program_List.cshtml", lst);
            return PartialView("~/Views/Title_Content/_Music_Program_List.cshtml", lst);
        }
        public PartialViewResult BindChannelList(int Title_Content_Code)
        {
            lstContentRunDefData = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetRunDefinitonForContent(Title_Content_Code, "", 0, "", "", "", "C").ToList();
            return PartialView("~/Views/Title_Content/_Channel_Wise_List.cshtml", lstContentRunDefData);
        }
        private List<USP_List_Content_Result> GetContentList(int pageNo, int recordPerPage, out int newPageNo)
        {
            List<USP_List_Content_Result> lst = new List<USP_List_Content_Result>();
            int RecordCount = 0;
            RecordCount = lstContent.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstContent.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            newPageNo = pageNo;
            return lst;
        }

        public JsonResult PopulateContent(string searchPrefix = "")
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

        public JsonResult SaveContent(int titleContentCode, string contentName, decimal duration)
        {
            string status = "S", message = "";
            bool dataChanged = false;

            duration = Convert.ToDecimal(duration.ToString("0.00"));


            objTC = objTC_Service.GetById(titleContentCode);

            if (objTC.Episode_Title != contentName || objTC.Duration != duration)
                dataChanged = true;

            objTC.Episode_Title = contentName;
            objTC.Duration = duration;
            objTC.Last_Updated_Time = System.DateTime.Now;
            objTC.EntityState = State.Modified;

            if (dataChanged)
                AddContentStatusHistoryObject(1, "C");
            dynamic resultSet;
            bool isValid = objTC_Service.Save(objTC, out resultSet);
            if (isValid)
            {
                USP_List_Content_Result objContent = lstContent.Where(w => w.Title_Content_Code == titleContentCode).FirstOrDefault();
                objContent.Title_Name = contentName;
                objContent.Duration_In_Min = duration;
                objContent.Last_Updated_Time = System.DateTime.Now;
                status = "S";
                message = "Record Updated Successfully";
            }
            else
            {
                status = "E";
                message = resultSet;
            }
            ClearSession();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }

        public void ExportToXML(FormCollection objFormCollection)
        {
            List<USP_List_Title_Content_ExportToXml_Result> USP_List_Content_Version = new List<USP_List_Title_Content_ExportToXml_Result>();
            var TitleList = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Title_Content_ExportToXml(Title_Content_Code).ToList();
            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment; filename=TitleContentVersion.xml");
            Response.ContentType = "text/xml";

            var serializer = new System.Xml.Serialization.XmlSerializer(TitleList.GetType());
            serializer.Serialize(Response.OutputStream, TitleList);
        }
        #endregion

        #region --- Basic Method ----
        private void ClearSession()
        {
            objUSPService = null;
            lstMusicTrack_Result = null;
            lstContent_Music_Link = null;
            objTC = null;
            objTC_Service = null;
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
        #endregion

        #region --- Assign Music ---

        public JsonResult SearchMusicTrack(string searchText, bool fetchData)
        {
            if (fetchData)
                lstMusicTrack_Result = objUSPService.USP_List_MusicTrack(searchText).ToList();

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Record_Count", lstMusicTrack_Result.Where(w => !w.isSelected).Count());
            return Json(obj);
        }
        public JsonResult SearchAssignedMusicTrack(string searchText, string commandName, string SelectedContentLinkGUID)
        {
            string[] arrSelectedGUID = SelectedContentLinkGUID.Trim().Trim(',').Trim().Split(',');
            SelectedContentLinkGUID = "";
            if (arrSelectedGUID.Length > 0 && lstContent_Music_Link_Searched.Count > 0)
                if (arrSelectedGUID[0] != "")
                    SelectedContentLinkGUID = "," + string.Join(",", lstContent_Music_Link_Searched.Where(W =>
                        arrSelectedGUID.Contains(W.Dummy_Guid.ToString())).Select(s => s.Dummy_Guid).ToArray()) + ",";

            if (commandName == "SEARCH")
            {
                if (!string.IsNullOrEmpty(searchText))
                {
                    lstContent_Music_Link_Searched = lstContent_Music_Link.Where(w =>
                        w.Music_Title.Music_Title_Name.ToUpper().Contains(searchText.ToUpper()) ||
                        ((w.Music_Title.Music_Album ?? new Music_Album()).Music_Album_Name ?? "").ToUpper().Contains(searchText.ToUpper())
                    ).ToList();
                }
            }
            else if (commandName == "SHOW_ALL")
            {
                SelectedContentLinkGUID = "";
                lstContent_Music_Link_Searched = lstContent_Music_Link;
            }

            string strAllContentLinkGUID = "," + string.Join(",", lstContent_Music_Link_Searched.Select(s => s.Dummy_Guid).ToArray()) + ",";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Record_Count", lstContent_Music_Link_Searched.Count);
            obj.Add("AllContentLinkGUID", strAllContentLinkGUID);
            obj.Add("SelectedContentLinkGUID", SelectedContentLinkGUID);
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
        private List<Content_Music_Link> GetContentMusicLinkList(int pageNo, int recordPerPage, out int newPageNo)
        {
            List<Content_Music_Link> lst = new List<Content_Music_Link>();
            int RecordCount = 0;
            RecordCount = lstContent_Music_Link_Searched.Count();

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstContent_Music_Link_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            newPageNo = pageNo;

            return lst;
        }
        public PartialViewResult BindMusicTrackList(int pageNo, int recordPerPage)
        {
            int newPageNo = 0;
            List<USP_List_MusicTrack_Result> lst = GetMusicTrackList(pageNo, recordPerPage, out newPageNo);
            return PartialView("~/Views/Title_Content/_Music_Track_List.cshtml", lst);
        }

        public PartialViewResult BindContentMusicLinkList(int pageNo, int recordPerPage, string mode = "")
        {
            int newPageNo = 0;
            ViewBag.Mode = mode;
            List<Content_Music_Link> lst = GetContentMusicLinkList(pageNo, recordPerPage, out newPageNo);
            if (mode != "V")
            {
                ViewBag.Version = new SelectList(new Version_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Version_Name != "").ToList(), "Version_Code", "Version_Name");
            }
            return PartialView("~/Views/Title_Content/_Content_Music_Link_List.cshtml", lst);
        }

        public PartialViewResult BindRestrictionRemarkList(int pageNo, int recordPerPage)
        {
            return PartialView("~/Views/Title_Content/_Content_Restriction_Remark_List.cshtml", lstContentRestrictionRemarks);
        }

        public JsonResult AddToContentMusicLink(string[] musicTrackList)
        {
            foreach (string dummyGuid in musicTrackList)
            {
                USP_List_MusicTrack_Result objMT = lstMusicTrack_Result.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
                if (objMT != null)
                {
                    objMT._Dummy_Guid = null;
                    Content_Music_Link objCML = new Content_Music_Link();
                    objCML.Music_Title_Code = objMT.Music_Title_Code;
                    objCML._Dummy_Guid = objMT.Dummy_Guid;
                    objCML.Music_Title = new Music_Title_Service(objLoginEntity.ConnectionStringName).GetById(objMT.Music_Title_Code);
                    lstContent_Music_Link.Insert(0, objCML);
                }
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", "S");
            obj.Add("Linked_Record_Count", lstContent_Music_Link.Count);
            return Json(obj);
        }

        public JsonResult SaveContentMusicLink(List<Content_Music_Link> lstCML, string SelectedContentLinkGUID, string callOn)
        {
            string status = "S";

            if (lstCML != null)
            {
                foreach (Content_Music_Link objCML_MVC in lstCML)
                {
                    Content_Music_Link objCML_S = lstContent_Music_Link_Searched.Where(w => w.Dummy_Guid == objCML_MVC.Dummy_Guid).FirstOrDefault();
                    if (objCML_S != null)
                    {

                        objCML_MVC.Music_Title = new Music_Title_Service(objLoginEntity.ConnectionStringName).GetById((int)objCML_MVC.Music_Title_Code);
                        int index = lstContent_Music_Link_Searched.IndexOf(objCML_S);
                        lstContent_Music_Link_Searched.Remove(objCML_S);
                        lstContent_Music_Link_Searched.Insert(index, objCML_MVC);
                    }

                    Content_Music_Link objCML = lstContent_Music_Link.Where(w => w.Dummy_Guid == objCML_MVC.Dummy_Guid).FirstOrDefault();
                    if (objCML != null)
                    {
                        int index = lstContent_Music_Link.IndexOf(objCML);
                        lstContent_Music_Link.Remove(objCML);
                        lstContent_Music_Link.Insert(index, objCML_MVC);
                    }
                }
            }

            if (!string.IsNullOrEmpty(SelectedContentLinkGUID))
            {
                SelectedContentLinkGUID = SelectedContentLinkGUID.Trim().Trim(',').Trim();
                string[] arrRemovedCML = SelectedContentLinkGUID.Split(',');
                lstContent_Music_Link_Searched.Where(w => arrRemovedCML.Contains(w.Dummy_Guid)).ToList().ForEach(a =>
                { lstContent_Music_Link_Searched.Remove(a); });
                lstContent_Music_Link.Where(w => arrRemovedCML.Contains(w.Dummy_Guid)).ToList().ForEach(a =>
                { lstContent_Music_Link.Remove(a); });
                objTC.Content_Music_Link.Where(w => arrRemovedCML.Contains(w.Dummy_Guid)).ToList().ForEach(a =>
                {
                    if (a.Content_Music_Link_Code > 0)
                        a.EntityState = State.Deleted;
                    else
                        objTC.Content_Music_Link.Remove(a);
                });
            }

            if (callOn == "S")
            {
                int insertCount = 0, updateCount = 0, deleteCount = 0;

                //foreach (Content_Music_Link objCML in lstContent_Music_Link)
                foreach (Content_Music_Link objCML in lstContent_Music_Link_Searched)
                {

                    Title_Content_Version objTCV = new Title_Content_Version_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Version_Code == objCML.Version_Code && w.Title_Content_Code == objTC.Title_Content_Code).FirstOrDefault();

                    if (objTCV == null)
                    {
                        objTCV = new Title_Content_Version();
                        dynamic resultset;
                        objTCV.Version_Code = objCML.Version_Code;
                        objTCV.Title_Content_Code = objTC.Title_Content_Code;
                        objTCV.Duration = objTC.Duration;
                        objTCV.EntityState = State.Added;
                        bool isvalid = new Title_Content_Version_Service(objLoginEntity.ConnectionStringName).Save(objTCV, out resultset);
                    }
                    Content_Music_Link objCML_DB = objTC.Content_Music_Link.Where(w => w.Dummy_Guid == objCML.Dummy_Guid).FirstOrDefault();
                    if (objCML_DB != null)
                    {
                        if (
                            objCML_DB.From != objCML.From || objCML_DB.From_Frame != objCML.From_Frame ||
                            objCML_DB.To != objCML.To || objCML_DB.To_Frame != objCML.To_Frame ||
                            objCML_DB.Duration != objCML.Duration || objCML_DB.Duration_Frame != objCML.Duration_Frame || objCML_DB.Version_Code != objTCV.Version_Code
                        )
                        {
                            updateCount++;
                            objCML_DB.EntityState = State.Modified;
                            objCML_DB.Last_UpDated_Time = DateTime.Now;
                            objCML_DB.Last_Action_By = objLoginUser.Users_Code;
                            objCML_DB.From = objCML.From;
                            objCML_DB.From_Frame = objCML.From_Frame;
                            objCML_DB.To = objCML.To;
                            objCML_DB.To_Frame = objCML.To_Frame;
                            objCML_DB.Duration = objCML.Duration;
                            objCML_DB.Duration_Frame = objCML.Duration_Frame;
                            objCML_DB.Title_Content_Version_Code = objTCV.Title_Content_Version_Code;
                        }
                    }
                    else
                    {

                        insertCount++;
                        objCML.Music_Title = null;
                        objCML.EntityState = State.Added;
                        objCML.Inserted_On = DateTime.Now;
                        objCML.Inserted_By = objLoginUser.Users_Code;
                        objCML.Last_Action_By = objLoginUser.Users_Code;
                        objCML.Last_UpDated_Time = DateTime.Now;
                        objCML.Title_Content_Version_Code = objTCV.Title_Content_Version_Code;
                        objTC.Content_Music_Link.Add(objCML);
                    }
                    objCML.Acq_Deal_Movie_Code = null;
                }

                deleteCount = objTC.Content_Music_Link.Where(w => w.EntityState == State.Deleted).Count();

                AddContentStatusHistoryObject(deleteCount, "D");
                AddContentStatusHistoryObject(updateCount, "U");
                AddContentStatusHistoryObject(insertCount, "I");

                dynamic resultSet;
                objTC.EntityState = State.Modified;
                bool isValid = objTC_Service.Save(objTC, out resultSet);
                if (!isValid)
                    status = "E";
                else
                {
                    lstContentRestrictionRemarks = null;
                    if (insertCount > 0)
                    {
                        string musicTitleCodes = string.Join(",", objTC.Content_Music_Link.Where(w => w.EntityState == State.Added).
                            Select(s => s.Music_Title_Code).ToArray());
                        lstContentRestrictionRemarks = objUSPService.USP_GetContentRestrictionRemarks((int)objTC.Title_Content_Code, musicTitleCodes).ToList();
                        int titleCode = (int)objTC.Title_Code;
                        int episodeNo = (int)objTC.Episode_No;
                        objUSPService.USP_Music_Schedule_Process(titleCode, episodeNo, 0, 0, "AM");
                    }
                    ClearSession();
                }
            }

            int effectedCount = objTC.Content_Music_Link.Where(w => w.EntityState != State.Unchanged).Count();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("RestrictionRemarkCount", lstContentRestrictionRemarks.Count);
            obj.Add("RecordEffectedCount", effectedCount);
            return Json(obj);
        }

        private void AddContentStatusHistoryObject(int recordCount, string userAction)
        {
            if (recordCount > 0)
            {
                Content_Status_History objCSH = new Content_Status_History();
                objCSH.User_Code = objLoginUser.Users_Code;
                objCSH.User_Action = userAction;
                objCSH.Record_Count = recordCount;
                objCSH.Created_On = DateTime.Now;
                objCSH.EntityState = State.Added;
                objTC.Content_Status_History.Add(objCSH);
            }
        }

        public JsonResult ClosePopup(string callFor)
        {
            if (callFor == "RR")
                lstContentRestrictionRemarks = null;

            ClearSession();

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", "S");
            return Json(obj);
        }

        public JsonResult AssignMusic(int titleContentCode)
        {
            string status = "S", message = "";
            lstContent_Music_Link = null;
            if (titleContentCode > 0)
            {
                objTC = null;
                objTC = objTC_Service.GetById(titleContentCode);
                lstContent_Music_Link = null;
                lstContent_Music_Link.AddRange(objTC.Content_Music_Link);
            }
            else
            {
                status = "E";
                message = "Object Not Found";
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }
        #endregion
    }

    public class Title_Content_Search
    {
        public string SearchText { get; set; }
        public int PageNo { get; set; }
        public int EpisodeFrom { get; set; }
        public int EpisodeTo { get; set; }
        public int RecordPerPage { get; set; }
    }
}

