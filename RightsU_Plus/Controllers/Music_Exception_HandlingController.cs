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

namespace RightsU_Plus.Controllers
{
    public class Music_Exception_HandlingController : BaseController
    {
        public Music_Exception_Search objPage_Properties
        {
            get
            {
                if (Session["objPage_Properties"] == null)
                    Session["objPage_Properties"] = new Music_Exception_Search();
                return (Music_Exception_Search)Session["objPage_Properties"];
            }
            set { Session["objPage_Properties"] = value; }
        }
        public string IsAiredForDash
        {
            get
            {
                if (Session["IsAiredForDash"] == null)
                    Session["IsAiredForDash"] = "";
                return (string)Session["IsAiredForDash"];
            }
            set { Session["IsAiredForDash"] = value; }
        }
        public string AStart_Date
        {
            get
            {
                if (Session["AStart_Date"] == null)
                    Session["AStart_Date"] = "";
                return (string)Session["AStart_Date"];
            }
            set { Session["AStart_Date"] = value; }
        }
        public string AEnd_Date
        {
            get
            {
                if (Session["AEnd_Date"] == null)
                    Session["AEnd_Date"] = "";
                return (string)Session["AEnd_Date"];
            }
            set { Session["AEnd_Date"] = value; }
        }
        public string NStart_Date
        {
            get
            {
                if (Session["NStart_Date"] == null)
                    Session["NStart_Date"] = "";
                return (string)Session["NStart_Date"];
            }
            set { Session["NStart_Date"] = value; }
        }
        public string NEnd_Date
        {
            get
            {
                if (Session["NEnd_Date"] == null)
                    Session["NEnd_Date"] = "";
                return (string)Session["NEnd_Date"];
            }
            set { Session["NEnd_Date"] = value; }
        }
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicExceptionHandling);
            ClearAll();
           
            AStart_Date = Convert.ToDateTime(objUSP_Service.USPGetAiredNotAiredDates().Select(x => x.AStart_Date).Single()).ToString("dd/MM/yyyy");
            AEnd_Date = Convert.ToDateTime(objUSP_Service.USPGetAiredNotAiredDates().Select(x => x.AEnd_Date).Single()).ToString("dd/MM/yyyy");
           NStart_Date = Convert.ToDateTime(objUSP_Service.USPGetAiredNotAiredDates().Select(x => x.NStart_Date).Single()).ToString("dd/MM/yyyy");
            NEnd_Date= Convert.ToDateTime(objUSP_Service.USPGetAiredNotAiredDates().Select(x => x.NEnd_Date).Single()).ToString("dd/MM/yyyy");

            return View("~/Views/Music_Exception_Handling/Index.cshtml");
        }
        public PartialViewResult BindGrid(string IsAired = "", int PageIndex = 0, int pageSize = 10, string CommonSearch = "", string IsAdvance = "",string StartDate="",string EndDate="")
        {
            if (IsAdvance == "N")
            {
                ClearAll();
                objPage_Properties.CommonSearch = CommonSearch;
            }
            
            IsAiredForDash = "N";
            int PageNo = PageIndex + 1;
            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            
            objPage_Properties.StartDate = Convert.ToDateTime(StartDate == "" ? (IsAired == "Y" ? AStart_Date : NStart_Date) : StartDate);
            objPage_Properties.EndDate = Convert.ToDateTime(EndDate == "" ? (IsAired == "Y" ? AEnd_Date : NEnd_Date) : EndDate);
            
            List<USP_Music_Exception_Handling_Result> LstMusicE = new List<USP_Music_Exception_Handling_Result>();
            LstMusicE = objUSP.USP_Music_Exception_Handling(IsAired, PageNo, objRecordCount, "Y", pageSize, objPage_Properties.MusicTrackCode,
                objPage_Properties.MusicLabelCode, objPage_Properties.ChannelCode, objPage_Properties.Contents, objPage_Properties.EpsFrom, objPage_Properties.EpsTo
                , objPage_Properties.InitialResponse, objPage_Properties.Status, objLoginUser.Users_Code, objPage_Properties.CommonSearch,objPage_Properties.StartDate,objPage_Properties.EndDate).ToList();

            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageSize = pageSize;
            ViewBag.IsAired = IsAired;
            ViewBag.AStart_Date = StartDate==""? AStart_Date: StartDate;
            ViewBag.AEnd_Date = EndDate==""? AEnd_Date:EndDate;
            ViewBag.NStart_Date = StartDate == "" ? NStart_Date : StartDate;
            ViewBag.NEnd_Date = EndDate == "" ? NEnd_Date : EndDate;
            if (PageNo <= 0)
                ViewBag.PageNo = 1;
            else
                ViewBag.PageNo = PageNo;
            return PartialView("_List_Music_Exception", LstMusicE);
        }
        public void ClearAll()
        {
            objPage_Properties.MusicTrackCode = "";
            objPage_Properties.MusicLabelCode = "";
            objPage_Properties.ChannelCode = "";
            objPage_Properties.Contents = "";
            objPage_Properties.EpsFrom = "";
            objPage_Properties.EpsTo = "";
            objPage_Properties.InitialResponse = "";
            objPage_Properties.Status = "";
            
           
        }
        public PartialViewResult ShowAll(string IsAired = "")
        {
            ClearAll();
            return BindGrid(IsAired, 0, 10);
        }

        public string SearchList(string IsAired = "", string MusicTrackCode = "", string MusicLabelCode = "", string ChannelCode = "", string Contents = ""
            , string EpsFrom = "", string EpsTo = "", string InitialResponse = "", string Status = "")
        {
            var primeArray = MusicTrackCode.Split('﹐');
            string arrays = "";
            for(int i = 0; i < primeArray.Length; i++)
            {
                var a  = Convert.ToString(primeArray[i]);
                int result = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name == a).Select(x => x.Music_Title_Code).FirstOrDefault();
                if (result != 0)                
                    arrays = arrays + result + ',';
            }
            var ContentArray = Contents.Replace('﹐',',');
            objPage_Properties.MusicTrackCode = arrays;
            objPage_Properties.MusicLabelCode = MusicLabelCode;
            objPage_Properties.ChannelCode = ChannelCode;
            objPage_Properties.Contents = ContentArray;
            objPage_Properties.EpsFrom = EpsFrom;
            objPage_Properties.EpsTo = EpsTo;
            objPage_Properties.InitialResponse = InitialResponse;
            objPage_Properties.Status = Status;
            //objPage_Properties.IsAired = IsAired;
            //return BindGrid(IsAired, 0, 10, "", "Y");
            return "";
        }

        public JsonResult Bind_Title(int Selected_BUCode, string Selected_Title_Codes = "", string Searched_Title = "")
        {
            List<string> terms = Searched_Title.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            var result = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y").Distinct()
               .Select(x => new { Music_Title_Name = x.Music_Title_Name, Music_Title_Code = 0 }).ToList();
            return Json(result);

        }

        public JsonResult Bind_Content(int Selected_BUCode, string Selected_Content_Codes = "", string Searched_Content = "")
        {
            List<string> terms = Searched_Content.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            var result = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Episode_Title.ToUpper().Contains(searchString.ToUpper())).Where(x => x.Episode_Title != null).Distinct()
               .Select(x => new { Title_Content_Name = x.Episode_Title, Title_Content_Code = x.Title_Content_Code }).ToList();
            return Json(result);
        }


        public PartialViewResult SendForApprovalPopup(int Music_Schedule_Transaction_Code, string IsZeroworkflow)
        {
            List<SelectListItem> lstMORS = new SelectList(new Music_Override_Reason_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Override_Reason_Name != ""), "Music_Override_Reason_Code", "Music_Override_Reason_Name", 0).ToList();
            //lstMORS.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            ViewBag.Music_Schedule_Transaction_Code = Music_Schedule_Transaction_Code;
            ViewBag.lstMORS = lstMORS;
            ViewBag.IsZeroworkflow = IsZeroworkflow.Trim();
            return PartialView("_Authorize");
        }
        public JsonResult SendForApproval(int Music_Schedule_Transaction_Code, int ReasonCode, string IgnoreOrOverride = "", string Remark = "")
        {
            string strMsgType = "", strViewBagMsg = "";
            Music_Schedule_Transaction_Service objMSTS = new Music_Schedule_Transaction_Service(objLoginEntity.ConnectionStringName);
            Music_Schedule_Transaction objMSE = new Music_Schedule_Transaction();
            objMSE = objMSTS.GetById(Music_Schedule_Transaction_Code);
            objMSE.Remarks = Remark;
            if (IgnoreOrOverride == "O")
            {
                objMSE.Music_Override_Reason_Code = ReasonCode;
                objMSE.Initial_Response = "O";
            }
            else
            objMSE.Initial_Response = "I";
            objMSE.EntityState = State.Modified;
            objMSTS.Save(objMSE);

            string uspResult = "P";
            uspResult = Convert.ToString(new USP_Service(objLoginEntity.ConnectionStringName).USP_Assign_Workflow(Music_Schedule_Transaction_Code, 154, objLoginUser.Users_Code, "").ElementAt(0));
            string[] arrUspResult = uspResult.Split('~');
            //if (Convert.ToInt32(arrUspResult[0].Count()) > 1)
            //{
            strMsgType = "S";
            //if (arrUspResult[1] == "N")
            strViewBagMsg = objMessageKey.SentforApprovalSuccessfully;
            //else
            //    strViewBagMsg = "Deal Successfully Sent for Approval, but unable to send mail. Please check the error log..";
            //}
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strViewBagMsg);
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }
        public PartialViewResult ShowAriedViewHistory(int Music_Schedule_Transaction_Code, string Mode = "", string IsAired = "")
        {
            // List<Module_Status_History> LSTMSH = new List<Module_Status_History>();
            List<USP_List_Status_History_Result> LSTMSH = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Status_History(Music_Schedule_Transaction_Code, GlobalParams.ModuleCodeForMusicExceptionHandling).ToList();
            // LSTMSH = new Module_Status_History_Type_Service().SearchFor(i => i.Record_Code == Music_Schedule_Transaction_Code && i.Module_Code==154).ToList();
            ViewBag.Music_Schedule_Transaction_Code = Music_Schedule_Transaction_Code;
            ViewBag.Mode = Mode;
            ViewBag.IsAired = IsAired;
            if (Mode == "V")
            {
                if (IsAired == "Y")
                    ViewBag.HeadingName = "Aired";
                else
                    ViewBag.HeadingName = "Not Aired";
                return PartialView("_List_Aired_Status_History", LSTMSH);
            }
            else
                return PartialView("_ApproveOrReject", LSTMSH);
        }

        public JsonResult ShowException(string ErrorCode = "")
        {
            string ErrorDes = new Error_Code_Master_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Upload_Error_Code == ErrorCode.Trim()).FirstOrDefault().Error_Description;

            //if (Mode == "V")
            //{
            //    return PartialView("_List_Aired_Status_History", LSTMSH);
            //}
            //else
            //    return PartialView("_ApproveOrReject", LSTMSH);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Error_Description", ErrorDes);
            return Json(obj);
        }

        public JsonResult ApproveOrReject(int Music_Schedule_Transaction_Code, int ReasonCode, string IgnoreOrOverride = "", string Remark = "", string user_Action = "")
        {

            try
            {
                Music_Schedule_Transaction_Service objMSTS = new Music_Schedule_Transaction_Service(objLoginEntity.ConnectionStringName);
                Music_Schedule_Transaction objMSE = new Music_Schedule_Transaction();
                objMSE = objMSTS.GetById(Music_Schedule_Transaction_Code);
                objMSE.Remarks = Remark;
                objMSE.Workflow_Status = user_Action;
                if (IgnoreOrOverride == "O")
                {
                    objMSE.Music_Override_Reason_Code = ReasonCode;
                    objMSE.Initial_Response = "O";
                }
                else
                objMSE.Initial_Response = "I";
                objMSE.EntityState = State.Modified;
                objMSTS.Save(objMSE);

                //USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
                //string uspResult = Convert.ToString(objUSP.USP_Process_Workflow(Music_Schedule_Transaction_Code, 154, objLoginUser.Users_Code, user_Action.TrimEnd()
                //    .TrimStart(), Remark).ElementAt(0));
                Dictionary<string, object> obj = new Dictionary<string, object>();

                //Music_Schedule_Transaction objMSE = new Music_Schedule_Transaction();
                //objMSE = new Music_Schedule_Transaction_Service().GetById(Music_Schedule_Transaction_Code);
                //objMSE.Remarks = Remark;
                //objMSE.Workflow_Status = user_Action;
                //objMSE.EntityState = State.Modified;
                //(new Music_Schedule_Transaction_Service()).Save(objMSE);
                if (user_Action.TrimEnd() == "R")
                    obj.Add("Message", objMessageKey.RejectedSuccessfully);
                else
                    obj.Add("Message", objMessageKey.ApprovedSuccessfully);
                return Json(obj);
            }
            catch(Exception ex)
            {
                return Json("Error");
            }
        }

        private List<SelectListItem> BindMusicTitle()
        {
            List<SelectListItem> lstMusicTitle = new List<SelectListItem>();

            lstMusicTitle = new SelectList(new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Title_Code", "Music_Title_Name", objPage_Properties.MusicTrackCode).ToList();
            //lstMusicTitle.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });

            return lstMusicTitle;
        }
        private List<SelectListItem> BindMusicLabel()
        {
            List<SelectListItem> lstMusicLabel = new List<SelectListItem>();

            lstMusicLabel = new SelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Label_Code", "Music_Label_Name", objPage_Properties.MusicLabelCode).ToList();
            //lstMusicLabel.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });

            return lstMusicLabel;
        }
        private List<SelectListItem> BindChannel()
        {
            List<SelectListItem> lstChannel = new List<SelectListItem>();

            lstChannel = new SelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Channel_Code", "Channel_Name", objPage_Properties.ChannelCode).ToList();
            // lstChannel.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });

            return lstChannel;
        }
        private List<SelectListItem> BindContent()
        {
            List<SelectListItem> lstContent = new List<SelectListItem>();
            lstContent = new SelectList(new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Episode_Title != null).Select(x => new { x.Episode_Title }).Distinct(),
                "Episode_Title", "Episode_Title", objPage_Properties.Contents).ToList();
            return lstContent;
        }
        private List<SelectListItem> BindInitialResponse()
        {
            List<SelectListItem> lstInitialResponse = new List<SelectListItem>();
            lstInitialResponse.Insert(0, new SelectListItem() { Value = "I", Text = "Ignore" });
            lstInitialResponse.Insert(1, new SelectListItem() { Value = "O", Text = "Override" });

            return lstInitialResponse;
        }
        private List<SelectListItem> BindStatus()
        {
            List<SelectListItem> lstStatus = new List<SelectListItem>();
            lstStatus.Insert(0, new SelectListItem() { Value = "O", Text = "Open" });
            //lstStatus.Insert(1, new SelectListItem() { Value = "W", Text = "Waiting for authorization" });
            lstStatus.Insert(1, new SelectListItem() { Value = "A", Text = "Approved" });
            lstStatus.Insert(2, new SelectListItem() { Value = "R", Text = "Rejected" });

            return lstStatus;
        }
        public JsonResult BindAdvanced_Search_Controls()
        {
            //MultiSelectList lstMusicTrack = new MultiSelectList(BindMusicTitle(), "Value", "Text");
            MultiSelectList lstMusicLabel = new MultiSelectList(BindMusicLabel(), "Value", "Text");
            //MultiSelectList lstContent = new MultiSelectList(BindContent(), "Value", "Text");
            MultiSelectList lstChannel = new MultiSelectList(BindChannel(), "Value", "Text");

            MultiSelectList lstInitialResponse = new MultiSelectList(BindInitialResponse(), "Value", "Text");
            MultiSelectList lstStatus = new MultiSelectList(BindStatus(), "Value", "Text");

            Dictionary<string, object> obj = new Dictionary<string, object>();
            //obj.Add("lstMusicTrack", lstMusicTrack);
            obj.Add("lstMusicLabel", lstMusicLabel);
            //obj.Add("lstContent", lstContent);
            obj.Add("lstChannel", lstChannel);
            obj.Add("lstInitialResponse", lstInitialResponse);
            obj.Add("lstStatus", lstStatus);
            obj.Add("objPage_Properties", objPage_Properties);
            return Json(obj);
        }

        public JsonResult BindDashboard(string IsAired = "",string StartDate="",string EndDate="")
        {
            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            int RecordCount = 0;
            IsAiredForDash = IsAired;           
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            objPage_Properties.StartDate = Convert.ToDateTime(StartDate == "" ? (IsAired == "Y" ? AStart_Date : NStart_Date) : StartDate);
            objPage_Properties.EndDate = Convert.ToDateTime(EndDate == "" ? (IsAired == "Y" ? AEnd_Date : NEnd_Date) : EndDate);
            List<USP_Music_Exception_Handling_Result> LstMusicE = new List<USP_Music_Exception_Handling_Result>();
            LstMusicE = objUSP.USP_Music_Exception_Handling(IsAired, 0, objRecordCount, "N", 0, objPage_Properties.MusicTrackCode,
                    objPage_Properties.MusicLabelCode, objPage_Properties.ChannelCode, objPage_Properties.Contents, objPage_Properties.EpsFrom, objPage_Properties.EpsTo
                    , objPage_Properties.InitialResponse, objPage_Properties.Status, objLoginUser.Users_Code, objPage_Properties.CommonSearch, objPage_Properties.StartDate, objPage_Properties.EndDate).ToList();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            List<USP_Music_Exception_Dashboard_Result> LstMusicDash = new List<USP_Music_Exception_Dashboard_Result>();
            LstMusicDash = objUSP.USP_Music_Exception_Dashboard(IsAired, objPage_Properties.MusicTrackCode,
                    objPage_Properties.MusicLabelCode, objPage_Properties.ChannelCode, objPage_Properties.Contents, objPage_Properties.EpsFrom, objPage_Properties.EpsTo
                    , objPage_Properties.InitialResponse, objPage_Properties.Status, objLoginUser.Users_Code, objPage_Properties.CommonSearch, objPage_Properties.StartDate, objPage_Properties.EndDate).ToList();
            object[] arrMusicDash = GetChartData(LstMusicDash);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("arrMusicDashboard", arrMusicDash);
            obj.Add("OpenCount", LstMusicE.Where(x => x.Workflow_Status == "O" || x.Workflow_Status == null || x.Workflow_Status == "R").ToList().Count());
            obj.Add("InProgressCount", LstMusicE.Where(x => x.Workflow_Status == "W").ToList().Count());
            obj.Add("ClosedCount", LstMusicE.Where(x => x.Workflow_Status == "A").ToList().Count());
            obj.Add("AStart_Date",StartDate==""? AStart_Date:StartDate);
            obj.Add("AEnd_Date", EndDate==""? AEnd_Date: EndDate);
            obj.Add("NStart_Date" , StartDate == "" ? NStart_Date:StartDate);
            obj.Add("NEnd_Date" , EndDate == "" ? NEnd_Date:EndDate);
            return Json(obj);
        }
        public PartialViewResult ShowDashboard(string Flag = "")
        {
            if (Flag == "showAll")
            {
                ClearAll();
            }
            ViewBag.IsAired = IsAiredForDash;
            ViewBag.AStart_Date = AStart_Date;
            ViewBag.AEnd_Date = AEnd_Date;
            ViewBag.NStart_Date = NStart_Date;
            ViewBag.NEnd_Date = NEnd_Date;
            return PartialView("_Exception_Dashboard");
        }

        private object[] GetChartData(List<USP_Music_Exception_Dashboard_Result> lst)
        {
            object[] arrMain = new object[lst.Count + 1];

            for (int i = 0; i < arrMain.Length; i++)
            {
                if (i == 0)
                {
                    object[] arrHeader = new object[5];
                    string[] arr = new string[5];
                    arr[0] = "";
                    arr[1] = "Open";
                    arr[2] = "In Process";
                    arr[3] = "Closed";
                    arr[4] = "{ANN}";
                    for (int j = 0; j < arr.Length; j++)
                    {
                        string str = arr[j];
                        if (str.ToUpper().Equals("{ANN}"))
                        {
                            arrHeader[j] = new { role = "annotation" };
                        }
                        else if (str.ToUpper().Equals("{ANN_NUM}"))
                        {
                            arrHeader[j] = new { type = "number", role = "annotation" };
                        }
                        else
                        {
                            arrHeader[j] = str;
                        }
                    }

                    arrMain[i] = arrHeader;
                }
                else
                {
                    USP_Music_Exception_Dashboard_Result item = lst[i - 1];
                    string[] arr = new string[5];
                    arr[0] = item.MusicLabel;
                    arr[1] = Convert.ToString(item.OpenCount);
                    arr[2] = Convert.ToString(item.InProcessCount);
                    arr[3] = Convert.ToString(item.ClosedCount);
                    arr[4] = "";
                    object[] arrVal = new object[arr.Length];
                    for (int k = 0; k < arrVal.Length; k++)
                    {
                        string val = arr[k];
                        if (k == 0)
                            arrVal[k] = val;
                        else
                        {
                            try
                            {
                                arrVal[k] = Convert.ToInt32(val);
                            }
                            catch (Exception)
                            {
                                if ((val == null || val == "") && k != arrVal.Length - 1)
                                    arrVal[k] = 0;
                                else
                                    arrVal[k] = val;
                            }
                        }
                    }

                    arrMain[i] = arrVal;
                }
            }

            return arrMain;
        }

      

    }
    public partial class Music_Exception_Search
    {
        public string MusicTrackCode { get; set; }
        public string MusicLabelCode { get; set; }
        public string ChannelCode { get; set; }
        public string Contents { get; set; }
        public string EpsFrom { get; set; }
        public string EpsTo { get; set; }
        public string InitialResponse { get; set; }
        public string Status { get; set; }
        public string CommonSearch { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        //public string IsAired { get; set; }
    }
}
