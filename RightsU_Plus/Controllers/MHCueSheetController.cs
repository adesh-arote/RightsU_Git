using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.IO;
using System.Reflection;
using System.Data.Entity.Core.Objects;

namespace RightsU_Plus.Controllers
{
    public class MHCueSheetController : BaseController
    {
        #region --Properties--
        private List<RightsU_Entities.USPMHCueSheetList_Result> lstMHCueSheet
        {
            get
            {
                if (Session["lstMHCueSheet"] == null)
                    Session["lstMHCueSheet"] = new List<RightsU_Entities.USPMHCueSheetList_Result>();
                return (List<RightsU_Entities.USPMHCueSheetList_Result>)Session["lstMHCueSheet"];
            }
            set { Session["lstMHCueSheet"] = value; }
        }

        private List<RightsU_Entities.USPMHCueSheetList_Result> lstMHCueSheet_Searched
        {
            get
            {
                if (Session["lstMHCueSheet_Searched"] == null)
                    Session["lstMHCueSheet_Searched"] = new List<RightsU_Entities.USPMHCueSheetList_Result>();
                return (List<RightsU_Entities.USPMHCueSheetList_Result>)Session["lstMHCueSheet_Searched"];
            }
            set { Session["lstMHCueSheet_Searched"] = value; }
        }

        private List<MusicTrackList> lstMusicTrackList
        {
            get
            {
                if (Session["lstMusicTrackList"] == null)
                    Session["lstMusicTrackList"] = new List<MusicTrackList>();
                return (List<MusicTrackList>)Session["lstMusicTrackList"];
            }
            set { Session["lstMusicTrackList"] = value; }
        }

        private MHTabPaging objMHTabPaging
        {
            get
            {
                if (Session["objMHTabPaging"] == null)
                    Session["objMHTabPaging"] = new MHTabPaging();
                return (MHTabPaging)Session["objMHTabPaging"];
            }
            set { Session["objMHTabPaging"] = value; }
        }

        private List<RightsU_Entities.MHCueSheetSong> lstMHCueSheetSongs
        {
            get
            {
                if (Session["lstMHCueSheetSongs"] == null)
                    Session["lstMHCueSheetSongs"] = new List<RightsU_Entities.MHCueSheetSong>();
                return (List<RightsU_Entities.MHCueSheetSong>)Session["lstMHCueSheetSongs"];
            }
            set { Session["lstMHCueSheetSongs"] = value; }
        }

        private List<RightsU_Entities.MHCueSheetSong> lstMHCueSheetSongs_Searched
        {
            get
            {
                if (Session["lstMHCueSheetSongs_Searched"] == null)
                    Session["lstMHCueSheetSongs_Searched"] = new List<RightsU_Entities.MHCueSheetSong>();
                return (List<RightsU_Entities.MHCueSheetSong>)Session["lstMHCueSheetSongs_Searched"];
            }
            set { Session["lstMHCueSheetSongs_Searched"] = value; }
        }
        #endregion

        public ViewResult Index()
        {
            var lst = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Music_Album.Album_Type != null).Select(x => new
            {
                x.Music_Title_Code,
                x.Music_Title_Name,
                x.Music_Album_Code,
                x.Music_Album.Music_Album_Name,
            }).ToList();

            foreach (var item in lst)
            {
                MusicTrackList obj = new MusicTrackList();
                obj.Music_Title_Code = item.Music_Title_Code;
                obj.Music_Title_Name = item.Music_Title_Name;
                obj.Music_Album_Code = item.Music_Album_Code;
                obj.Music_Album_Name = item.Music_Album_Name;
                lstMusicTrackList.Add(obj);
            }
            this. UpdateMHCueSheetRecord();

            return View("~/Views/MHCueSheet/Index.cshtml");
        }
        public void UpdateMHCueSheetRecord()
        {
            MHCueSheet_Service objService = new MHCueSheet_Service(objLoginEntity.ConnectionStringName);
            List<MHCueSheet> lstMHCueSheet = objService.SearchFor(x => x.UploadStatus == "S").ToList();

            foreach (var item in lstMHCueSheet)
            {
                if (item.MHCueSheetSongs.Count() == 0)
                    item.UploadStatus = "E";
                if (item.MHCueSheetSongs.Where(x => x.RecordStatus == "E").ToList().Count() > 0)
                    item.UploadStatus = "E";
                else if (item.MHCueSheetSongs.Where(x => x.RecordStatus == "W").ToList().Count() > 0)
                    item.UploadStatus = "W";
                else if (item.MHCueSheetSongs.Where(x => x.RecordStatus == "W" && x.RecordStatus == "E").ToList().Count() == 0)
                    item.UploadStatus = "R";

                item.EntityState = State.Modified;

                dynamic resultSet;
                bool istRUE = objService.Save(item, out resultSet);
            }  
        }

        public PartialViewResult BindPartialPages(string key, int MHCueCode, string callFor= "")
        {
            MHCueSheet_Service objService = new MHCueSheet_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.USPMHCueSheetList_Result objMHCueSheet = null;
            if (key == "LIST")
            {
                List<SelectListItem> lstStatus = new List<SelectListItem>();
                lstStatus.Add(new SelectListItem { Text = "All", Value = "" });
                lstStatus.Add(new SelectListItem { Text = "Completed", Value = "C" });
                lstStatus.Add(new SelectListItem { Text = "Data Error", Value = "W" });
                lstStatus.Add(new SelectListItem { Text = "Submitted", Value = "S" });

                var lstProductionRoleVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y"
                              && s.Vendor_Role.Where(x => x.Role_Code == 9).Count() > 0).ToList();
                ViewBag.ProdHouseList = new SelectList(lstProductionRoleVendor, "Vendor_Code", "Vendor_Name");

                ViewBag.Status = lstStatus;
                ViewBag.callFor = callFor;

                int RecordCount = 0;
                ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
                lstMHCueSheet = lstMHCueSheet_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USPMHCueSheetList(0, "", 1, 10, objRecordCount).ToList();
                return PartialView("~/Views/MHCueSheet/_MHCueSheetMetaData.cshtml");
            }
            else
            {
                ViewBag.Key = key;
                if (MHCueCode > 0 && key != "VIEW")
                {
                    objMHCueSheet = lstMHCueSheet.Where(x => x.MHCueSheetCode == MHCueCode).FirstOrDefault();
                    var objAppByOn = new MHCueSheet_Service(objLoginEntity.ConnectionStringName).SearchFor(x=>x.MHCueSheetCode == MHCueCode).Select(x=> new { x.ApprovedBy, x.ApprovedOn }).FirstOrDefault();
                    ViewBag.ApprovedOn =  objAppByOn.ApprovedOn.ToString() == "" ? "NA" : objAppByOn.ApprovedOn.ToString();
                    ViewBag.ApprovedBy = objAppByOn.ApprovedBy == null ? "NA" : new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Users_Code == objAppByOn.ApprovedBy).Select(x => x.Login_Name).FirstOrDefault();
                    lstMHCueSheetSongs = lstMHCueSheetSongs_Searched = new MHCueSheetSong_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.MHCueSheetCode == MHCueCode).ToList();
                }
                else if (MHCueCode > 0 && key == "VIEW")
                {
                    objMHCueSheet = lstMHCueSheet.Where(x => x.MHCueSheetCode == MHCueCode).FirstOrDefault();
                    var objAppByOn = new MHCueSheet_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.MHCueSheetCode == MHCueCode).Select(x => new { x.ApprovedBy, x.ApprovedOn }).FirstOrDefault();
                    ViewBag.ApprovedOn = objAppByOn.ApprovedOn.ToString() == "" ? "NA" : objAppByOn.ApprovedOn.ToString();
                    ViewBag.ApprovedBy = objAppByOn.ApprovedBy == null ? "NA" : new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Users_Code == objAppByOn.ApprovedBy).Select(x => x.Login_Name).FirstOrDefault();
                    lstMHCueSheetSongs = lstMHCueSheetSongs_Searched = new MHCueSheetSong_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.MHCueSheetCode == MHCueCode).ToList();
                }
                return PartialView("~/Views/MHCueSheet/_MHMusicAssignMetaData.cshtml", objMHCueSheet);
            }
        }

        public PartialViewResult BindMHCueList(int pageNo, int recordPerPage, string searchStatus = "", int searchPH = 0, int RecCount = 0)
        {
           // List<RightsU_Entities.USPMHCueSheetList_Result> lst = new List<RightsU_Entities.USPMHCueSheetList_Result>();
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);

            //RecordCount = lstMHCueSheet_Searched.Count;

            var lst = new USP_Service(objLoginEntity.ConnectionStringName).USPMHCueSheetList(searchPH, searchStatus, 1, recordPerPage, objRecordCount).ToList();
            if (Convert.ToInt32(objRecordCount.Value) != RecCount)
            {
                RecCount = lst.Count();
            }

            if (RecCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecCount, out noOfRecordSkip, out noOfRecordTake);
            //    lst = lstMHCueSheet_Searched.OrderByDescending(o => o.CreatedOn).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.PageNo = pageNo;
            ViewBag.PageSize = recordPerPage;

            lstMHCueSheet = lstMHCueSheet_Searched  = new USP_Service(objLoginEntity.ConnectionStringName).USPMHCueSheetList(searchPH, searchStatus, pageNo, recordPerPage, objRecordCount).ToList();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;

            //ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/MHCueSheet/_MHCueSheetList.cshtml", lstMHCueSheet_Searched);
        }
        
        #region Other Methods
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

        #region
        public JsonResult SearchMHCueSheet(int PHCode, string StatusCode)
        {
            if (!string.IsNullOrEmpty(StatusCode))
            {
                lstMHCueSheet_Searched = lstMHCueSheet.Where(w => w.UploadStatus.ToUpper().Contains(StatusCode.ToUpper())).ToList();
            }
            else
                lstMHCueSheet_Searched = lstMHCueSheet;

            var obj = new
            {
                Record_Count = lstMHCueSheet_Searched.Count
            };
            return Json(obj);
        }
        #endregion

        #region
        public PartialViewResult BindGrid(string MHCueSheetCode, bool fetchData, bool isTabChanged, string currentTabName, 
            string previousTabName, int pageNo, int recordPerPage, string key = "")
        {
            MHCueSheet objmHCueSheet = null;
            List<MHCueSheetSong> lst = new List<MHCueSheetSong>();
            ViewBag.TabName = currentTabName;
            ViewBag.Key = key;
            //if (fetchData)
            //{
            objmHCueSheet = new MHCueSheet_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(MHCueSheetCode));
            //}
            if (isTabChanged)
            {
                objMHTabPaging.SetPropertyValue("PageNo_" + previousTabName, pageNo);
                objMHTabPaging.SetPropertyValue("PageSize_" + previousTabName, recordPerPage);

                pageNo = (int)objMHTabPaging.GetPropertyValue("PageNo_" + currentTabName);
                pageNo = (pageNo == 0) ? 1 : pageNo;
                recordPerPage = (int)objMHTabPaging.GetPropertyValue("PageSize_" + currentTabName);
                recordPerPage = (recordPerPage == 0) ? 10 : recordPerPage;
            }
            else
            {
                objMHTabPaging.SetPropertyValue("PageNo_" + currentTabName, pageNo);
                objMHTabPaging.SetPropertyValue("PageSize_" + currentTabName, recordPerPage);
            }

            if (currentTabName == "CM")
            {
                if (objmHCueSheet.UploadStatus == "C")
                {
                    ViewBag.RecordCount = lstMHCueSheetSongs_Searched.Count();

                    if (ViewBag.RecordCount > 0)
                    {
                        int noOfRecordSkip, noOfRecordTake;
                        pageNo = GetPaging(pageNo, recordPerPage, ViewBag.RecordCount, out noOfRecordSkip, out noOfRecordTake);
                        lst = lstMHCueSheetSongs_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    }
                }
                else
                {
                    ViewBag.RecordCount = lstMHCueSheetSongs_Searched.Where(x => x.RecordStatus == "S").ToList().Count();

                    if (ViewBag.RecordCount > 0)
                    {
                        int noOfRecordSkip, noOfRecordTake;
                        pageNo = GetPaging(pageNo, recordPerPage, ViewBag.RecordCount, out noOfRecordSkip, out noOfRecordTake);
                        lst = lstMHCueSheetSongs_Searched.Where(x => x.RecordStatus == "S").Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    }
                }
                
            }
            else if (currentTabName == "OT")
            {
                ViewBag.RecordCount = lstMHCueSheetSongs_Searched.Where(x => x.RecordStatus == "W").ToList().Count();
                if (ViewBag.RecordCount > 0)
                {
                    int noOfRecordSkip, noOfRecordTake;
                    pageNo = GetPaging(pageNo, recordPerPage, ViewBag.RecordCount, out noOfRecordSkip, out noOfRecordTake);
                    lst = lstMHCueSheetSongs_Searched.Where(x => x.RecordStatus == "W").Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
            }
            ViewBag.PageNo = pageNo;
            ViewBag.PageSize = recordPerPage;
            ViewBag.currentTabName = currentTabName;

            if (key.ToUpper() == "VIEW")
                return PartialView("~/Views/MHCueSheet/_MHMusicAssignListView.cshtml", lst); 
            else
                return PartialView("~/Views/MHCueSheet/_MHMusicAssignValidErrorList.cshtml", lst);

        }

        public JsonResult SaveMHCueSheetSongs_List(List<MHCSS> lstCML)
        {
            foreach (var item in lstCML)
            {
                MHCueSheetSong obj = lstMHCueSheetSongs_Searched.Where(x => x.MHCueSheetSongCode == item.MHCueSheetSongCode).FirstOrDefault();
                if (obj != null)
                {
                    if (item.TitleCode != 0)
                    {
                        obj.TitleName = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == item.TitleCode).Select(x => x.Title_Name).FirstOrDefault();
                        obj.TitleCode = item.TitleCode;
                    }
                    if (item.TitleContentCode != 0)
                    {
                        obj.TitleContentCode = item.TitleContentCode;
                        obj.EpisodeNo = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Content_Code == item.TitleContentCode).Select(x => x.Episode_No).FirstOrDefault();
                    }

                    if (item.MusicTitleCode != 0)
                    {
                        obj.MusicTitleCode = item.MusicTitleCode;
                        obj.MusicTrackName = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Code == item.MusicTitleCode).Select(x => x.Music_Title_Name).FirstOrDefault();
                    }
                    obj.IsApprove = item.isApprove ? "Y" : obj.IsApprove;
                }

                MHCueSheetSong obj_Search = lstMHCueSheetSongs.Where(x => x.MHCueSheetSongCode == item.MHCueSheetSongCode).FirstOrDefault();
                if (obj_Search != null)
                {
                    if (item.TitleCode != 0)
                    {
                        obj.TitleName = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == item.TitleCode).Select(x => x.Title_Name).FirstOrDefault();
                        obj.TitleCode = item.TitleCode;
                    }
                    if (item.TitleContentCode != 0)
                    {
                        obj.TitleContentCode = item.TitleContentCode;
                        obj.EpisodeNo = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Content_Code == item.TitleContentCode).Select(x => x.Episode_No).FirstOrDefault();
                    }

                    if (item.MusicTitleCode != 0)
                    {
                        obj.MusicTitleCode = item.MusicTitleCode;
                        obj.MusicTrackName = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Code == item.MusicTitleCode).Select(x => x.Music_Title_Name).FirstOrDefault();
                    }
                    obj.IsApprove = item.isApprove ? "Y" : obj.IsApprove;
                }
            }
            return Json("S");
        }

        public JsonResult RemoveMHCueSheetSongs_List(int MHCueSheetSongCode)
        {
            MHCueSheetSong obj = lstMHCueSheetSongs_Searched.Where(x => x.MHCueSheetSongCode == MHCueSheetSongCode).FirstOrDefault();
            obj.IsApprove = "N";

            //MHCueSheetSong obj_Search = lstMHCueSheetSongs.Where(x => x.MHCueSheetSongCode == MHCueSheetSongCode).FirstOrDefault();
            //obj_Search.IsApprove = "N";

            return Json("S");
        }

        public JsonResult FinalSave(string callFor, string spclInst = "")
        {
            MHCueSheet_Service objServiceMH = new MHCueSheet_Service(objLoginEntity.ConnectionStringName);
            MHCueSheetSong_Service objService = new MHCueSheetSong_Service(objLoginEntity.ConnectionStringName);
            string status = "S", message = "";
            int MHCueSheetCode = 0;
            var lst = lstMHCueSheetSongs_Searched.Where(x => x.RecordStatus == "W" && x.IsApprove == "Y").ToList();
            MHCueSheetCode = lstMHCueSheetSongs_Searched.FirstOrDefault().MHCueSheetCode.Value;
            if (callFor == "M")
            {
                message = "Record Mapped Successfully"; 
                foreach (var item in lst)
                {
                    MHCueSheetSong objMHCueSheetSong = objService.SearchFor(x => x.MHCueSheetSongCode == item.MHCueSheetSongCode).FirstOrDefault();
                    if (item.ErrorMessage.Contains("~MHMTNF~"))
                    {
                        objMHCueSheetSong.MusicTrackName = item.MusicTrackName;
                        objMHCueSheetSong.MusicTitleCode = item.MusicTitleCode;
                    }
                    if (item.ErrorMessage.Contains("~MHSNNF~") || item.ErrorMessage.Contains("~MHENIV~"))
                    {
                        objMHCueSheetSong.TitleName = item.TitleName;
                        objMHCueSheetSong.TitleCode = item.TitleCode;
                        objMHCueSheetSong.TitleContentCode = item.TitleContentCode;
                        objMHCueSheetSong.EpisodeNo = item.EpisodeNo;
                    }
                    objMHCueSheetSong.ErrorMessage = null;
                    objMHCueSheetSong.IsApprove = "O";
                    objMHCueSheetSong.RecordStatus = "S";
                    objMHCueSheetSong.EntityState = State.Modified;

                    dynamic resultSet;
                    bool isValid = objService.Save(objMHCueSheetSong, out resultSet);
                    if (!isValid)
                    {
                        status = "E";
                        message = "Record Mapping Failed";
                        break;
                    }
                }
                if (lst.Count == 0)
                {
                    status = "E";
                    message = "Please Select atleast one record";
                }
            }
            else if (callFor == "S")
            {
                if (lstMHCueSheetSongs_Searched.Where(x => x.RecordStatus == "W").ToList().Count() > 0)
                {
                    status = "E";
                    message = "Cue Sheet Cannot be Submitted as Data Error List is still Pending.";
                }
                else
                {
                    MHCueSheet objMHCueSheet = objServiceMH.SearchFor(x => x.MHCueSheetCode == MHCueSheetCode).FirstOrDefault();
                    objMHCueSheet.SpecialInstruction = spclInst;
                    objMHCueSheet.UploadStatus = "R";
                    objMHCueSheet.ApprovedBy = objLoginUser.Users_Code;
                    objMHCueSheet.ApprovedOn = System.DateTime.Now;
                    objMHCueSheet.EntityState = State.Modified;
                    dynamic resultSet;
                    bool isValid = objServiceMH.Save(objMHCueSheet, out resultSet);
                    if (!isValid)
                    {
                        status = "E";
                        message = "Record Submit Failed"; 
                    }
                    else
                        message = "Record Submitted Successfully";
                }
               
            }
            if (status == "S")
            {
                RightsU_Entities.MHCueSheet objMHCueSheet = null;
                objMHCueSheet = objServiceMH.SearchFor(x => x.MHCueSheetCode == MHCueSheetCode).FirstOrDefault();
                lstMHCueSheetSongs = lstMHCueSheetSongs_Searched = objMHCueSheet.MHCueSheetSongs.ToList();
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        #endregion

        #region Bindings
        public JsonResult Bind_Title(string Selected_Title_Codes = "", string Searched_Title = "", int ContentTypeCode = 0)//int Selected_deal_type_Code, 
        {
            List<string> terms = Searched_Title.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            List<USPVWTitleList_Result> lstUSPVWTitleListResult = new List<USPVWTitleList_Result>();
            lstUSPVWTitleListResult = new USP_Service(objLoginEntity.ConnectionStringName).USPVWTitleList(searchString, "").ToList();
            return Json(lstUSPVWTitleListResult);
        }

        public JsonResult BindEpsNo(string titleName, int TitleContentCode = 0)
        {
            if (titleName != "")
            {
                Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();
                try
                {
                    int titleCode = new USP_Service(objLoginEntity.ConnectionStringName).USPGetTitleCode(titleName).ToList().FirstOrDefault().Title_Code;
                    //SelectList lstEpisode = new SelectList(context.USPGetTitleEpisodes(titleCode).Select(i => new { Display_Value = i.Title_Content_Code, Display_Text = "Episode - " + i.Episode_No }).ToList(), "Display_Value", "Display_Text");
                    var list = new USP_Service(objLoginEntity.ConnectionStringName).USPGetTitleEpisodes(titleCode).Select(i => new { Display_Value = i.Title_Content_Code, Display_Text = i.Episode_No }).ToList();
                    if (TitleContentCode > 0)
                    {
                        SelectList lstEpisode = new SelectList(list, "Display_Value", "Display_Text",list.Where(x=>x.Display_Value == TitleContentCode).FirstOrDefault());
                        obj_Dictionary.Add("lstEpisode", lstEpisode);
                        return Json(obj_Dictionary);
                    }
                    else
                    {
                        SelectList lstEpisode = new SelectList(list, "Display_Value", "Display_Text");
                        obj_Dictionary.Add("lstEpisode", lstEpisode);
                        return Json(obj_Dictionary);
                    }

                }
                catch (Exception ex)
                {
                    obj_Dictionary.Add("lstEpisode", "E");
                    return Json(obj_Dictionary);
                } 
            }
            else
            {
                return Json("");
            }
        }

        public JsonResult Bind_Music_track(string Selected_Track_Codes = "", string Searched_Track = "")
        {
            List<string> terms = Searched_Track.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            var lst = lstMusicTrackList.Where(x => x.Music_Title_Name.ToUpper().Contains(searchString.ToUpper())).Select(x => new { x.Music_Title_Name, x.Music_Title_Code }).ToList();
            return Json(lst);
        }
        public JsonResult BindAlbumName(int Track_Code = 0)
        {
            string MusicAlbumName = Track_Code > 0 ? lstMusicTrackList.Where(x => x.Music_Title_Code == Track_Code).Select(x => x.Music_Album_Name.ToString()).FirstOrDefault() : "";
            MusicAlbumName = MusicAlbumName ?? "";
            return Json(MusicAlbumName);
        }

        #endregion 

    }

    public class MHTabPaging
    {
        public int PageNo_CM { get; set; }
        public int PageSize_CM { get; set; }
        public int PageNo_OT { get; set; }
        public int PageSize_OT { get; set; }
        public int PageNo_SM { get; set; }
        public int PageSize_SM { get; set; }

        public object GetPropertyValue(string propertyName)
        {
            object value = this.GetType().GetProperty(propertyName).GetValue(this, null);
            return value;
        }
        public void SetPropertyValue(string propertyName, object value)
        {
            PropertyInfo propertyInfo = this.GetType().GetProperty(propertyName);
            propertyInfo.SetValue(this, Convert.ChangeType(value, propertyInfo.PropertyType), null);

        }
    }

    public class MusicTrackList
    {
        public int Music_Title_Code { get; set; }
        public string Music_Title_Name { get; set; }
        public int? Music_Album_Code { get; set; }
        public string Music_Album_Name { get; set; }
    }

    public class MHCSS
    {
        public int MHCueSheetSongCode { get; set; }
        public string TitleName { get; set; }
        public int TitleCode { get; set; }
        public int TitleContentCode { get; set; }
        public string MusicTrackName { get; set; }
        public int MusicTitleCode { get; set; }
        public bool isApprove { get; set; }
    }
}


