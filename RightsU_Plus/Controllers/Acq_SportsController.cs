using System;
using System.Collections.Generic;
using System.Linq;
using System.Collections;
using System.Globalization;
using System.Threading;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.IO;

namespace RightsU_Plus.Controllers
{
    public class Acq_SportsController : BaseController
    {
        #region --- Properties ---

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
        public Acq_Deal objAcq_Deal
        {
            get
            {
                if (Session["objDeal"] == null)
                    Session["objDeal"] = new Acq_Deal();
                return (Acq_Deal)Session["objDeal"];
            }
            set { Session["objDeal"] = value; }
        }
        public Acq_Deal_Sport_Service objAcq_Deal_Sport_Service
        {
            get
            {
                if (Session["Acq_Deal_Sport_Service"] == null)
                    Session["Acq_Deal_Sport_Service"] = new Acq_Deal_Sport_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Sport_Service)Session["Acq_Deal_Sport_Service"];
            }
            set { Session["Acq_Deal_Sport_Service"] = value; }
        }

        public int PageNo
        {
            get
            {
                if (ViewBag.PageNo == null)
                    ViewBag.PageNo = 1;
                return (int)ViewBag.PageNo;
            }
            set { ViewBag.PageNo = value; }
        }

        public Acq_Deal_Sport objAcq_Deal_Sport
        {
            get
            {
                if (Session["Acq_Deal_Sport"] == null)
                    Session["Acq_Deal_Sport"] = new Acq_Deal_Sport();
                return (Acq_Deal_Sport)Session["Acq_Deal_Sport"];
            }
            set { Session["Acq_Deal_Sport"] = value; }
        }

        public string Mode
        {
            get
            {
                if (ViewBag.Mode == null)
                    ViewBag.Mode = String.Empty;
                return (string)ViewBag.Mode;
            }
            set { ViewBag.Mode = value; }
        }
        #endregion

        #region  --- Actions ---
        public PartialViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            ViewBag.CommandName = "";
            objDeal_Schema.Page_From = GlobalParams.Page_From_Sports;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            ViewBag.CommandName = "";
            ViewBag.Mode = objDeal_Schema.Mode;
            ViewBag.Approver_Remark = objDeal_Schema.Approver_Remark;
            Session["FileName"] = "";
            Session["FileName"] = "acq_SportsRights";
            return PartialView("~/Views/Acq_Deal/_Acq_Sports_List.cshtml", objAcq_Deal.Acq_Deal_Sport.ToList());
        }

        public ActionResult Cancel()
        {
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            else
                ViewBag.Record_Locking_Code = 0;
            ClearSession();
            objDeal_Schema = null;
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
            return RedirectToAction("Index", "Acq_List");
        }

        public PartialViewResult EditView(int Acq_Deal_Sport_Code, string Mode)
        {
            ViewBag.Acq_Deal_Sport_Code = Acq_Deal_Sport_Code;
            objAcq_Deal_Sport = objAcq_Deal_Sport_Service.GetById(Acq_Deal_Sport_Code);
            if (Mode == "Edit")
            {
                ViewBag.HeaderLabel = objMessageKey.EditSportsRights;
                ViewBag.CommandName = "Edit";

                string titleCodes = "";
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    titleCodes = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Sport.Acq_Deal_Sport_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code.ToString()));
                }
                else
                {
                    titleCodes = string.Join(",", objAcq_Deal_Sport.Acq_Deal_Sport_Title.Select(y => y.Title.Title_Code));
                }

                BindTitle(titleCodes);

                string BroadcastModeCode = "";
                BroadcastModeCode = string.Join(",", objAcq_Deal_Sport.Acq_Deal_Sport_Broadcast.Where(x => x.Type == "MO").Select(y => y.Broadcast_Mode.Broadcast_Mode_Code));
                BindBroadcastMode(BroadcastModeCode);

                string BroadcastModeObligationCode = "";
                BroadcastModeObligationCode = string.Join(",", objAcq_Deal_Sport.Acq_Deal_Sport_Broadcast.Where(x => x.Type == "OB").Select(y => y.Broadcast_Mode.Broadcast_Mode_Code));
                BindBroadcastModeObligation(BroadcastModeObligationCode);


                string StandalonePlatformCode = "";
                StandalonePlatformCode = string.Join(",", objAcq_Deal_Sport.Acq_Deal_Sport_Platform.Where(x => x.Type == "ST").Select(y => y.Platform_Code));
                BindStandalonePlatform(StandalonePlatformCode);

                string SimulcastPlatformCode = "";
                SimulcastPlatformCode = string.Join(",", objAcq_Deal_Sport.Acq_Deal_Sport_Platform.Where(x => x.Type == "SM").Select(y => y.Platform_Code));
                BindSimulcastPlatform(SimulcastPlatformCode);

                string LanguageCode = "";
                LanguageCode = string.Join(",", objAcq_Deal_Sport.Acq_Deal_Sport_Language.Where(x => x.Language_Type == "L").Select(y => y.Language_Code));
                BindCommentaryLanguage(LanguageCode);

                string LanguageGroupCode = "";
                LanguageGroupCode = string.Join(",", objAcq_Deal_Sport.Acq_Deal_Sport_Language.Where(x => x.Language_Type == "G").Select(y => y.Language_Group_Code));
                BindCommentaryLanguageGroup(LanguageGroupCode);

                string LanguageType = string.Join(",", objAcq_Deal_Sport.Acq_Deal_Sport_Language.Select(y => y.Language_Type).Distinct().ToArray());
                ViewBag.LanguageType = LanguageType;

                ViewBag.MBOCriticalNotes = objAcq_Deal_Sport.MBO_Note;
                ViewBag.MTOCriticalNotes = objAcq_Deal_Sport.Remarks;
                ViewBag.Mode = objDeal_Schema.Mode;
                ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
                return PartialView("~/Views/Acq_Deal/_Acq_Sports.cshtml", objAcq_Deal_Sport);
            }
            else
            {
                ViewBag.HeaderLabel = objMessageKey.ViewSportsRights;
                ViewBag.CommandName = "View";
                ViewBag.Mode = objDeal_Schema.Mode;
                ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
                return PartialView("~/Views/Acq_Deal/_Acq_Sports.cshtml", objAcq_Deal_Sport);
            }
        }

        public PartialViewResult BindGridAcqSport(int txtPageSize, int page_No)
        {
            int pageSize;
            if (txtPageSize != null)
            {
                objDeal_Schema.Cost_PageSize = Convert.ToInt32(txtPageSize);
                pageSize = Convert.ToInt32(txtPageSize);
            }
            else
            {
                objDeal_Schema.Cost_PageSize = 50;
                pageSize = 50;
            }
            int Deal_Code = objDeal_Schema.Deal_Code;
            objAcq_Deal_Sport_Service = new Acq_Deal_Sport_Service(objLoginEntity.ConnectionStringName);

            ICollection<Acq_Deal_Sport> lst_Acq_Deal_Sport;
            if (PageNo == 1)
                lst_Acq_Deal_Sport = objAcq_Deal_Sport_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Sport_Code).Take(pageSize).ToList();
            else
            {
                lst_Acq_Deal_Sport = objAcq_Deal_Sport_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Sport_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (lst_Acq_Deal_Sport.Count == 0)
                {
                    if (PageNo != 1)
                    {
                        objDeal_Schema.Cost_PageNo = PageNo - 1;
                        PageNo = PageNo - 1;
                    }
                    lst_Acq_Deal_Sport = objAcq_Deal_Sport_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Sport_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }

            ViewBag.RecordCount = objAcq_Deal_Sport_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Count();
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = txtPageSize;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            ViewBag.Mode = objDeal_Schema.Mode;

            return PartialView("~/Views/Acq_Deal/_List_Sports.cshtml", lst_Acq_Deal_Sport);
        }

        public ActionResult DownloadFile(string System_File_Name, string Attachment_File_Name)
        {
            string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"];
            string path = fullPath + "/" + Attachment_File_Name;
            FileInfo file = new FileInfo(path);
            if (file.Exists)
            {
                byte[] bts = System.IO.File.ReadAllBytes(path);
                Response.Clear();
                Response.ClearHeaders();
                Response.AddHeader("Content-Type", "Application/octet-stream");
                Response.AddHeader("Content-Length", bts.Length.ToString());
                Response.AddHeader("Content-Disposition", "attachment;   filename=" + System_File_Name.Split('~')[1]);
                Response.BinaryWrite(bts);
                Response.Flush();
                Response.End();
                return RedirectToAction("Index", new { Message = objMessageKey.AttachmentFiledownloadedsuccessfully });
            }
            else
            {
                return RedirectToAction("Index", new { Message = objMessageKey.Failedtodownloadfile + "!" });
            }
        }

        [HttpPost]
        public PartialViewResult PartialAddEditDealSportRight(int AcqDealSportCode, string CommandName)
        {
            if (AcqDealSportCode > 0)
            {
                objAcq_Deal_Sport = objAcq_Deal_Sport_Service.GetById(AcqDealSportCode);
                BindHeaderData();
            }

            if (CommandName == "Add")
            {
                objAcq_Deal_Sport = null;
                ViewBag.HeaderLabel = objMessageKey.AddSportsRights;
                BindTitle("");
                BindBroadcastMode("");
                BindBroadcastModeObligation("");
                BindStandalonePlatform("");
                BindSimulcastPlatform("");
                BindCommentaryLanguage("");
                BindCommentaryLanguageGroup("");
                BindAllRadionButtonList();
            }
            else if (CommandName == "View")
            {
                ViewBag.HeaderLabel = "View Cost";
            }
            ViewBag.Mode = objDeal_Schema.Mode;

            Mode = objDeal_Schema.Mode;
            return PartialView("~/Views/Acq_Deal/_Acq_Sports.cshtml", objAcq_Deal_Sport);
        }

        public PartialViewResult Delete(int Acq_Deal_Sport_Code)
        {
            dynamic resultSet;
            bool deleted = false;

            Acq_Deal_Sport objAcq_Deal_Sport = objAcq_Deal_Sport_Service.GetById(Acq_Deal_Sport_Code);
            objAcq_Deal_Sport.EntityState = State.Deleted;
            objAcq_Deal_Sport.Acq_Deal_Sport_Title.ToList<Acq_Deal_Sport_Title>().ForEach(t => t.EntityState = State.Deleted);
            objAcq_Deal_Sport.Acq_Deal_Sport_Broadcast.ToList<Acq_Deal_Sport_Broadcast>().ForEach(t => t.EntityState = State.Deleted);
            objAcq_Deal_Sport.Acq_Deal_Sport_Platform.ToList<Acq_Deal_Sport_Platform>().ForEach(t => t.EntityState = State.Deleted);
            objAcq_Deal_Sport.Acq_Deal_Sport_Language.ToList<Acq_Deal_Sport_Language>().ForEach(t => t.EntityState = State.Deleted);

            deleted = objAcq_Deal_Sport_Service.Delete(objAcq_Deal_Sport, out resultSet);
            return BindGridAcqSport(10, PageNo);

        }

        public JsonResult OnLanguageClick(string strLanguage)
        {
            List<SelectListItem> lstLanguage = null;
            Dictionary<string, object> obj = new Dictionary<string, object>();
            if (strLanguage == "L")
            {
                lstLanguage = new SelectList((new Language_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Is_Active == "Y").ToList(), "Language_Code", "Language_Name").OrderBy(o => o.Text).ToList();
            }
            else
            {
                lstLanguage = new SelectList((new Language_Group_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Is_Active == "Y").ToList(), "Language_Group_Code", "Language_Group_Name").OrderBy(o => o.Text).ToList();
            }
            obj.Add("lstLanguage", lstLanguage);
            return Json(obj);
        }

        public ActionResult ChangeTab(string hdnTabName)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code);
        }

        #endregion
        string ConnectionString = Convert.ToString(((LoginEntity)System.Web.HttpContext.Current.Session[RightsU_Session.CurrentLoginEntity]).ConnectionStringName);
        #region Methods

        private void ClearSession()
        {
            objAcq_Deal = null;
        }

        public string SaveFile()
        {
            string ReturnMessage = "Y";
            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var PostedFile = System.Web.HttpContext.Current.Request.Files["InputFile"];
                string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"];
                if (PostedFile.FileName != "" || PostedFile.FileName != null)
                {
                    if (!Directory.Exists(fullPath))
                        Directory.CreateDirectory(fullPath);
                    PostedFile.SaveAs(fullPath + "\\" + PostedFile.FileName);
                }
                return ReturnMessage;
            }
            else
                return ReturnMessage = "N";
        }

        private void BindHeaderData()
        {
            Session[UtoSession.SESS_DEAL] = new Acq_Deal_Service(ConnectionString).GetById(objDeal_Schema.Deal_Code);
            objAcq_Deal = (Acq_Deal)Session[UtoSession.SESS_DEAL];
        }

        public string SaveSportRight(string hdnAcq_Deal_Sport_Code, string hdnContentDelivery, string hdnObligationBroadcast, string hdnddllstTitle,
            string hdnddlContent_Broadcast_Mode_Code,
            string hdnddlObligation_Broadcast_Mode_Code, string hdnDeferredLive,
            string hdntxtDeferredDuration, string hdnTapeDelayed, string hdntxtTapeDelayed, string hdnMBOCriticalNotes,
            string hdnCriticalNotes, string hdnStandalone, string hdnSubstantialStandalone, string hdnddlStandalonePlatform,
            string hdnSimulcast, string hdnSimulcastSubstantial, string hdnddlSimulcastPlatform, string hdnrdbLanguage, string hdnLang,
            string Attachment_File_Name)
        {
            string status = "S";
            string strMessage = "";
            string msg = "";
            string mode = objDeal_Schema.Mode;
            bool IsSameAsGroup = false;

            #region Validation
            if (hdnddllstTitle == null || hdnddllstTitle == "")
            {
                status = "E";
                strMessage = objMessageKey.Pleaseselectatleastonetitle;
            }
            #endregion

            if (status == "S")
            {
                #region Add to Object

                if (hdnAcq_Deal_Sport_Code == "0")
                {
                    objAcq_Deal_Sport = new Acq_Deal_Sport();
                }
                objAcq_Deal_Sport.Acq_Deal_Code = objDeal_Schema.Deal_Code;
                objAcq_Deal_Sport.Content_Delivery = hdnContentDelivery;

                objAcq_Deal_Sport.Obligation_Broadcast = hdnObligationBroadcast;

                objAcq_Deal_Sport.Deferred_Live = hdnDeferredLive;
                objAcq_Deal_Sport.Tape_Delayed = hdnTapeDelayed;

                objAcq_Deal_Sport.Standalone_Transmission = hdnStandalone;
                objAcq_Deal_Sport.Simulcast_Transmission = hdnSimulcast;
                objAcq_Deal_Sport.Standalone_Substantial = hdnSubstantialStandalone;
                objAcq_Deal_Sport.Simulcast_Substantial = hdnSimulcastSubstantial;

                if (Attachment_File_Name != "")
                {
                    objAcq_Deal_Sport.File_Name = Attachment_File_Name;
                    objAcq_Deal_Sport.Sys_File_Name = DateTime.Now.Ticks + "~" + objAcq_Deal_Sport.File_Name.Replace(" ", "_");
                }

                string DF_Duration = "";
                string TD_Duration = "";

                if (hdnDeferredLive == "DF")
                    DF_Duration = hdntxtDeferredDuration == "00:00:00" ? "" : hdntxtDeferredDuration;

                if (hdnTapeDelayed == "DF")
                    TD_Duration = hdntxtTapeDelayed == "00:00:00" ? "" : hdntxtTapeDelayed;

                objAcq_Deal_Sport.Deferred_Live_Duration = DF_Duration;
                objAcq_Deal_Sport.Tape_Delayed_Duration = TD_Duration;

                objAcq_Deal_Sport.Remarks = hdnCriticalNotes.Trim();
                objAcq_Deal_Sport.MBO_Note = hdnMBOCriticalNotes.Trim();

                #region Broadcast Mode

                string[] arrSelected_Broadcasts = hdnddlContent_Broadcast_Mode_Code.Split(',');
                ICollection<Acq_Deal_Sport_Broadcast> selectBroadcastList = new HashSet<Acq_Deal_Sport_Broadcast>();

                foreach (string strCode in arrSelected_Broadcasts)
                {
                    Acq_Deal_Sport_Broadcast objADS_Broadcast = new Acq_Deal_Sport_Broadcast();
                    int code = (string.IsNullOrEmpty(strCode)) ? 0 : Convert.ToInt32(strCode);

                    if (code > 0)
                    {
                        objADS_Broadcast.Acq_Deal_Sport_Code = objAcq_Deal_Sport.Acq_Deal_Sport_Code;
                        objADS_Broadcast.Broadcast_Mode_Code = code;
                        objADS_Broadcast.Type = "MO";
                        objADS_Broadcast.EntityState = State.Added;

                        selectBroadcastList.Add(objADS_Broadcast);
                    }
                }
                #endregion

                #region Obligation to Broadcast
                string[] arrSelected_BroadcastsOB = hdnddlObligation_Broadcast_Mode_Code.Split(',');

                foreach (string strCode in arrSelected_BroadcastsOB)
                {
                    Acq_Deal_Sport_Broadcast objADS_Broadcast = new Acq_Deal_Sport_Broadcast();
                    int code = (string.IsNullOrEmpty(strCode)) ? 0 : Convert.ToInt32(strCode);

                    if (code > 0)
                    {
                        objADS_Broadcast.Acq_Deal_Sport_Code = objAcq_Deal_Sport.Acq_Deal_Sport_Code;
                        objADS_Broadcast.Broadcast_Mode_Code = code;
                        objADS_Broadcast.Type = "OB";
                        objADS_Broadcast.EntityState = State.Added;

                        selectBroadcastList.Add(objADS_Broadcast);
                    }
                }

                IEqualityComparer<Acq_Deal_Sport_Broadcast> comparerOB = new LambdaComparer<Acq_Deal_Sport_Broadcast>((x, y) => x.Broadcast_Mode_Code == y.Broadcast_Mode_Code && x.Type == y.Type && x.EntityState != State.Deleted);
                var Deleted_Acq_Deal_Sport_BroadcastOB = new List<Acq_Deal_Sport_Broadcast>();
                var Added_Acq_Deal_Sport_BroadcastOB = CompareLists<Acq_Deal_Sport_Broadcast>(selectBroadcastList.ToList<Acq_Deal_Sport_Broadcast>(), objAcq_Deal_Sport.Acq_Deal_Sport_Broadcast.ToList<Acq_Deal_Sport_Broadcast>(), comparerOB, ref Deleted_Acq_Deal_Sport_BroadcastOB);
                Added_Acq_Deal_Sport_BroadcastOB.ToList<Acq_Deal_Sport_Broadcast>().ForEach(t => objAcq_Deal_Sport.Acq_Deal_Sport_Broadcast.Add(t));
                Deleted_Acq_Deal_Sport_BroadcastOB.ToList<Acq_Deal_Sport_Broadcast>().ForEach(t => t.EntityState = State.Deleted);
                #endregion

                #region Title
                string[] arrSelected_Titles = hdnddllstTitle.Split(',');

                ICollection<Acq_Deal_Sport_Title> selectTitleList = new HashSet<Acq_Deal_Sport_Title>();

                foreach (string strCode in arrSelected_Titles)
                {
                    Acq_Deal_Sport_Title objADS_Title = new Acq_Deal_Sport_Title();
                    int code = (string.IsNullOrEmpty(strCode)) ? 0 : Convert.ToInt32(strCode);

                    if (code > 0)
                    {
                        if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                        {
                            Title_List objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();
                            objADS_Title.Episode_From = objTL.Episode_From;
                            objADS_Title.Episode_To = objTL.Episode_To;
                            objADS_Title.Title_Code = objTL.Title_Code;
                        }
                        else
                        {
                            objADS_Title.Episode_From = 1;
                            objADS_Title.Episode_To = 1;
                            objADS_Title.Title_Code = code;
                        }
                        objADS_Title.EntityState = State.Added;
                        selectTitleList.Add(objADS_Title);
                    }
                }

                IEqualityComparer<Acq_Deal_Sport_Title> comparerT = new LambdaComparer<Acq_Deal_Sport_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted && x.Episode_From == y.Episode_From && x.Episode_To == y.Episode_To);
                var Deleted_Acq_Deal_Sport_Title = new List<Acq_Deal_Sport_Title>();
                var Added_Acq_Deal_Sport_Title = CompareLists<Acq_Deal_Sport_Title>(selectTitleList.ToList<Acq_Deal_Sport_Title>(), objAcq_Deal_Sport.Acq_Deal_Sport_Title.ToList<Acq_Deal_Sport_Title>(), comparerT, ref Deleted_Acq_Deal_Sport_Title);
                Added_Acq_Deal_Sport_Title.ToList<Acq_Deal_Sport_Title>().ForEach(t => objAcq_Deal_Sport.Acq_Deal_Sport_Title.Add(t));
                Deleted_Acq_Deal_Sport_Title.ToList<Acq_Deal_Sport_Title>().ForEach(t => t.EntityState = State.Deleted);
                #endregion

                #region Standalone Platform
                string[] arrSelected_PlatformST = hdnddlStandalonePlatform.Split(',');
                ICollection<Acq_Deal_Sport_Platform> selectPlatformListST = new HashSet<Acq_Deal_Sport_Platform>();

                foreach (string strCode in arrSelected_PlatformST)
                {
                    Acq_Deal_Sport_Platform objADS_PlatformST = new Acq_Deal_Sport_Platform();
                    int code = (string.IsNullOrEmpty(strCode)) ? 0 : Convert.ToInt32(strCode);

                    if (code > 0)
                    {
                        objADS_PlatformST.Acq_Deal_Sport_Code = objAcq_Deal_Sport.Acq_Deal_Sport_Code;
                        objADS_PlatformST.Platform_Code = code;
                        objADS_PlatformST.Type = "ST";
                        objADS_PlatformST.EntityState = State.Added;

                        selectPlatformListST.Add(objADS_PlatformST);
                    }
                }
                #endregion

                #region Simulcast Platform
                string[] arrSelected_PlatformSM = hdnddlSimulcastPlatform.Split(',');

                foreach (string strCode in arrSelected_PlatformSM)
                {
                    Acq_Deal_Sport_Platform objADS_PlatformSM = new Acq_Deal_Sport_Platform();
                    int code = (string.IsNullOrEmpty(strCode)) ? 0 : Convert.ToInt32(strCode);

                    if (code > 0)
                    {
                        objADS_PlatformSM.Acq_Deal_Sport_Code = objAcq_Deal_Sport.Acq_Deal_Sport_Code;
                        objADS_PlatformSM.Platform_Code = code;
                        objADS_PlatformSM.Type = "SM";
                        objADS_PlatformSM.EntityState = State.Added;

                        selectPlatformListST.Add(objADS_PlatformSM);
                    }
                }

                IEqualityComparer<Acq_Deal_Sport_Platform> comparerPSM = new LambdaComparer<Acq_Deal_Sport_Platform>((x, y) => x.Platform_Code == y.Platform_Code && x.Type == y.Type && x.EntityState != State.Deleted);
                var Deleted_Acq_Deal_Sport_Platform = new List<Acq_Deal_Sport_Platform>();
                var Added_Acq_Deal_Sport_Platform = CompareLists<Acq_Deal_Sport_Platform>(selectPlatformListST.ToList<Acq_Deal_Sport_Platform>(), objAcq_Deal_Sport.Acq_Deal_Sport_Platform.ToList<Acq_Deal_Sport_Platform>(), comparerPSM, ref Deleted_Acq_Deal_Sport_Platform);
                Added_Acq_Deal_Sport_Platform.ToList<Acq_Deal_Sport_Platform>().ForEach(t => objAcq_Deal_Sport.Acq_Deal_Sport_Platform.Add(t));
                Deleted_Acq_Deal_Sport_Platform.ToList<Acq_Deal_Sport_Platform>().ForEach(t => t.EntityState = State.Deleted);
                #endregion

                #region ========= Language =========
                bool IsChangeType = false;
                objAcq_Deal_Sport.Acq_Deal_Sport_Language.ToList<Acq_Deal_Sport_Language>().ForEach(t => t.EntityState = State.Deleted);
                if (objAcq_Deal_Sport.Acq_Deal_Sport_Language != null)
                    if (objAcq_Deal_Sport.Acq_Deal_Sport_Language.Count > 0)
                    {
                        if (objAcq_Deal_Sport.Acq_Deal_Sport_Language.ElementAt(0).Language_Type == "G" && hdnrdbLanguage == "L")
                        {
                            if (hdnLang != "")
                            {
                                string[] terCodes = hdnLang.Split(new char[] { ',' }, StringSplitOptions.None);
                                foreach (string LanguageCode in terCodes)
                                {
                                    Acq_Deal_Sport_Language objSub = new Acq_Deal_Sport_Language();
                                    objSub.Language_Type = "L";
                                    objSub.EntityState = State.Added;
                                    objSub.Language_Code = Convert.ToInt32(LanguageCode);
                                    objAcq_Deal_Sport.Acq_Deal_Sport_Language.Add(objSub);
                                }
                            }
                            IsChangeType = true;
                        }
                        else if (objAcq_Deal_Sport.Acq_Deal_Sport_Language.ElementAt(0).Language_Type == "L" && hdnrdbLanguage == "G")
                        {
                            if (hdnLang != "")
                            {
                                string[] terCodes = hdnLang.Split(new char[] { ',' }, StringSplitOptions.None);
                                foreach (string LanguageCode in terCodes)
                                {
                                    Acq_Deal_Sport_Language objSub = new Acq_Deal_Sport_Language();
                                    objSub.Language_Type = "G";
                                    objSub.EntityState = State.Added;
                                    objSub.Language_Group_Code = Convert.ToInt32(LanguageCode);
                                    objAcq_Deal_Sport.Acq_Deal_Sport_Language.Add(objSub);
                                }
                            }
                            IsChangeType = true;
                        }
                    }
                if (!IsChangeType)
                {
                    if (hdnLang != "")
                    {
                        string[] subCodes = hdnLang.Split(new char[] { ',' }, StringSplitOptions.None);
                        foreach (string LanguageCode in subCodes)
                        {
                            Acq_Deal_Sport_Language objSub = null;
                            if (hdnrdbLanguage == "G")
                            {
                                objSub = objAcq_Deal_Sport.Acq_Deal_Sport_Language.Where(t => t.Language_Group_Code == Convert.ToInt32(LanguageCode)).Select(i => i).FirstOrDefault();
                                if (objSub == null)
                                {
                                    objSub = new Acq_Deal_Sport_Language();
                                    objSub.Language_Type = "G";
                                    objSub.Language_Group_Code = Convert.ToInt32(LanguageCode);
                                    objSub.Language_Code = null;
                                    objSub.EntityState = State.Added;
                                    objAcq_Deal_Sport.Acq_Deal_Sport_Language.Add(objSub);
                                }
                                else
                                    objSub.EntityState = State.Unchanged;
                            }
                            else
                            {
                                objSub = objAcq_Deal_Sport.Acq_Deal_Sport_Language.Where(t => t.Language_Code == Convert.ToInt32(LanguageCode)).Select(i => i).FirstOrDefault();
                                if (objSub == null)
                                {
                                    objSub = new Acq_Deal_Sport_Language();
                                    objSub.Language_Type = "L";
                                    objSub.Language_Code = Convert.ToInt32(LanguageCode);
                                    objSub.Language_Group_Code = null;
                                    objSub.EntityState = State.Added;
                                    objAcq_Deal_Sport.Acq_Deal_Sport_Language.Add(objSub);
                                }
                                else
                                    objSub.EntityState = State.Unchanged;
                            }
                        }
                    }
                }
                #endregion

                #endregion

                dynamic resultSet;
                if (hdnAcq_Deal_Sport_Code == "0")
                {
                    objAcq_Deal_Sport.EntityState = State.Added;
                    objAcq_Deal_Sport_Service.Save(objAcq_Deal_Sport, out resultSet);
                }
                else
                {
                    objAcq_Deal_Sport.EntityState = State.Modified;
                    objAcq_Deal_Sport.Acq_Deal_Code = objDeal_Schema.Deal_Code;
                    //if(objAcq_Deal_Sport.Acq_Deal_Sport_Title.Count 
                    objAcq_Deal_Sport.Acq_Deal_Sport_Code = Convert.ToInt32(hdnAcq_Deal_Sport_Code);
                    objAcq_Deal_Sport_Service.Save(objAcq_Deal_Sport, out resultSet);
                }

                if (status.Equals("S"))
                {
                    msg = objMessageKey.SportsRightsaddedsuccessfully;
                    if (hdnAcq_Deal_Sport_Code != "0")
                        msg = objMessageKey.SportsRightsupdatedsuccessfully;
                }
            }

            return status;
        }

        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult) where T : class
        {
            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);
            DelResult = DeleteResult.ToList<T>();

            return AddResult.ToList<T>();
        }

        private void BindAllRadionButtonList()
        {
            //Content Delivery
            SelectListItem liContentDeliveryLV = new SelectListItem() { Value = "LV", Text = objMessageKey.Live, Selected = true };
            SelectListItem liContentDeliveryRC = new SelectListItem() { Value = "RC", Text = objMessageKey.Recorded, Selected = false };
            List<SelectListItem> lstContentDelivery = new List<SelectListItem>();
            lstContentDelivery.Add(liContentDeliveryLV);
            lstContentDelivery.Add(liContentDeliveryRC);
            ViewBag.ContentDelivery = lstContentDelivery;

            //Obligation To Broadcast
            SelectListItem liObligationYes = new SelectListItem() { Value = "Y", Text = objMessageKey.Yes, Selected = false };
            SelectListItem liObligationNo = new SelectListItem() { Value = "N", Text = objMessageKey.NO, Selected = true };
            List<SelectListItem> lstObligation = new List<SelectListItem>();
            lstObligation.Add(liObligationYes);
            lstObligation.Add(liObligationNo);
            ViewBag.lstObligation = lstObligation;

            //Deffered Live
            SelectListItem liDefferedNA = new SelectListItem() { Value = "NA", Text = objMessageKey.NA, Selected = false };
            SelectListItem liDefferedUN = new SelectListItem() { Value = "UL", Text = objMessageKey.Unlimited, Selected = true };
            SelectListItem liDefferedDF = new SelectListItem() { Value = "DF", Text = objMessageKey.Defined, Selected = false };
            List<SelectListItem> lstDeferred = new List<SelectListItem>();
            lstDeferred.Add(liDefferedNA);
            lstDeferred.Add(liDefferedUN);
            lstDeferred.Add(liDefferedDF);
            ViewBag.lstDeferred = lstDeferred;

            //Tape Delayed
            SelectListItem liTapeNA = new SelectListItem() { Value = "NA", Text = objMessageKey.NA, Selected = false };
            SelectListItem liTapeUN = new SelectListItem() { Value = "UL", Text = objMessageKey.Unlimited, Selected = true };
            SelectListItem liTapeDF = new SelectListItem() { Value = "DF", Text = objMessageKey.Defined, Selected = false };
            List<SelectListItem> lstTape = new List<SelectListItem>();
            lstTape.Add(liTapeNA);
            lstTape.Add(liTapeUN);
            lstTape.Add(liTapeDF);
            ViewBag.lstTape = lstTape;

            //Standalone
            SelectListItem liStandaloneYes = new SelectListItem() { Value = "Y", Text = objMessageKey.Yes, Selected = true };
            SelectListItem liStandaloneNo = new SelectListItem() { Value = "N", Text = objMessageKey.NO, Selected = false };
            List<SelectListItem> lstStandalone = new List<SelectListItem>();
            lstStandalone.Add(liStandaloneYes);
            lstStandalone.Add(liStandaloneNo);
            ViewBag.lstStandalone = lstStandalone;
        }

        private void BindTitle(string titleCodes)
        {
            if (titleCodes == "")
            {
                ViewBag.lstTitle = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindTitle_List(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Code, "");
            }
            else
            {
                ViewBag.lstTitle = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindTitle_List(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Code, titleCodes);
            }
        }

        private void BindBroadcastMode(string Broadcast_Mode_Code)
        {
            if (Broadcast_Mode_Code == "")
            {
                //List<SelectListItem> lstBroadcast_Mode = new SelectList(new Broadcast_Mode_Service(objLoginEntity.ConnectionStringName).SearchFor(x => 1 == 1), "Broadcast_Mode_Code", "Broadcast_Mode_Name").ToList();
                MultiSelectList lstBroadcast_Mode = new MultiSelectList(new Broadcast_Mode_Service(objLoginEntity.ConnectionStringName).SearchFor(x => 1 == 1).ToList(), "Broadcast_Mode_Code", "Broadcast_Mode_Name");
                ViewBag.lstBroadcastMode = lstBroadcast_Mode;
            }
            else
            {
                MultiSelectList lstBroadcast_Mode = new MultiSelectList(new Broadcast_Mode_Service(objLoginEntity.ConnectionStringName).SearchFor(x => 1 == 1).ToList(), "Broadcast_Mode_Code", "Broadcast_Mode_Name", Broadcast_Mode_Code.Split(','));
                ViewBag.lstBroadcastMode = lstBroadcast_Mode;
            }
        }

        private void BindBroadcastModeObligation(string Broadcast_Mode_Code)
        {
            if (Broadcast_Mode_Code == "")
            {
                MultiSelectList lstBroadcast_Mode = new MultiSelectList(new Broadcast_Mode_Service(objLoginEntity.ConnectionStringName).SearchFor(x => 1 == 1).ToList(), "Broadcast_Mode_Code", "Broadcast_Mode_Name");
                ViewBag.lstBroadcastModeObligation = lstBroadcast_Mode;
            }
            else
            {
                MultiSelectList lstBroadcast_Mode = new MultiSelectList(new Broadcast_Mode_Service(objLoginEntity.ConnectionStringName).SearchFor(x => 1 == 1).ToList(), "Broadcast_Mode_Code", "Broadcast_Mode_Name", Broadcast_Mode_Code.Split(','));
                ViewBag.lstBroadcastModeObligation = lstBroadcast_Mode;
            }
        }

        public void BindStandalonePlatform(string Platform_Code)
        {
            if (Platform_Code == "")
            {
                string Standalone = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Sports_Standalone_Base_Platform").Select(s => s.Parameter_Value).FirstOrDefault();
                MultiSelectList lstStandalonePlatform = new MultiSelectList(new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Sport_Right == "Y" && x.Base_Platform_Code.ToString() == Standalone).ToList(), "Platform_Code", "Platform_Hiearachy");
                ViewBag.lstStandalonePlatform = lstStandalonePlatform;
            }
            else
            {
                string Standalone = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Sports_Standalone_Base_Platform").Select(s => s.Parameter_Value).FirstOrDefault();
                MultiSelectList lstStandalonePlatform = new MultiSelectList(new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Sport_Right == "Y" && x.Base_Platform_Code.ToString() == Standalone).ToList(), "Platform_Code", "Platform_Hiearachy", Platform_Code.Split(','));
                ViewBag.lstStandalonePlatform = lstStandalonePlatform;
            }
        }

        public void BindSimulcastPlatform(string Platform_Code)
        {
            if (Platform_Code == "")
            {
                string Standalone = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Sports_Simulcast_Base_Platform").Select(s => s.Parameter_Value).FirstOrDefault();
                MultiSelectList lstSimulcastPlatform = new MultiSelectList(new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Sport_Right == "Y" && x.Base_Platform_Code.ToString() == Standalone).ToList(), "Platform_Code", "Platform_Hiearachy");
                ViewBag.lstSimulcastPlatform = lstSimulcastPlatform;
            }
            else
            {
                string Standalone = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Sports_Simulcast_Base_Platform").Select(s => s.Parameter_Value).FirstOrDefault();
                MultiSelectList lstSimulcastPlatform = new MultiSelectList(new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Sport_Right == "Y" && x.Base_Platform_Code.ToString() == Standalone), "Platform_Code", "Platform_Hiearachy", Platform_Code.Split(','));
                ViewBag.lstSimulcastPlatform = lstSimulcastPlatform;
            }
        }

        private void BindCommentaryLanguage(string Language_Code)
        {
            ViewBag.lstLanguage = null;
            MultiSelectList lstLanguage = new MultiSelectList((new Language_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Is_Active == "Y")
                .Select(i => new { Language_Code = i.Language_Code, Language_Name = i.Language_Name })
                .ToList(), "Language_Code", "Language_Name", Language_Code.Split(','));
            ViewBag.lstLanguage = lstLanguage;
        }

        private void BindCommentaryLanguageGroup(string Language_Group_Code)
        {
            ViewBag.lstLanguageGroup = null;
            MultiSelectList lstLanguage = new MultiSelectList((new Language_Group_Service(objLoginEntity.ConnectionStringName))
                                                        .SearchFor(x => x.Is_Active == "Y")
                                                        .Select(i => new { Language_Group_Code = i.Language_Group_Code, Language_Group_Name = i.Language_Group_Name })
                                                        .ToList(), "Language_Group_Code", "Language_Group_Name", Language_Group_Code.Split(','));
            ViewBag.lstLanguageGroup = lstLanguage;
        }

        #endregion
    }
}
