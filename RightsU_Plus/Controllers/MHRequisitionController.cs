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
//USPMHRequisitionList_Result
namespace RightsU_Plus.Controllers
{
    public partial class MHRequisitionController : BaseController
    {
        #region Properties
        private List<RightsU_Entities.MHRequest> lstMHRequest
        {
            get
            {
                if (Session["lstMHRequest"] == null)
                    Session["lstMHRequest"] = new List<RightsU_Entities.MHRequest>();
                return (List<RightsU_Entities.MHRequest>)Session["lstMHRequest"];
            }
            set { Session["lstMHRequest"] = value; }
        }

        private List<RightsU_Entities.MHRequest> lstMHRequest_Searched
        {
            get
            {
                if (Session["lstMHRequest_Searched"] == null)
                    Session["lstMHRequest_Searched"] = new List<RightsU_Entities.MHRequest>();
                return (List<RightsU_Entities.MHRequest>)Session["lstMHRequest_Searched"];
            }
            set { Session["lstMHRequest_Searched"] = value; }
        }

        private List<RightsU_Entities.MHRequestDetail> lstMHRequestDetails
        {
            get
            {
                if (Session["lstMHRequestDetails"] == null)
                    Session["lstMHRequestDetails"] = new List<RightsU_Entities.MHRequestDetail>();
                return (List<RightsU_Entities.MHRequestDetail>)Session["lstMHRequestDetails"];
            }
            set { Session["lstMHRequestDetails"] = value; }
        }

        private List<RightsU_Entities.MHRequestDetail> lstMHRequestDetails_Searched
        {
            get
            {
                if (Session["lstMHRequestDetails_Searched"] == null)
                    Session["lstMHRequestDetails_Searched"] = new List<RightsU_Entities.MHRequestDetail>();
                return (List<RightsU_Entities.MHRequestDetail>)Session["lstMHRequestDetails_Searched"];
            }
            set { Session["lstMHRequestDetails_Searched"] = value; }
        }

        private List<RightsU_Entities.USPMHRequistionTrackList_Result> lstMHRequestDetailsTrack
        {
            get
            {
                if (Session["lstMHRequestDetailsTrack"] == null)
                    Session["lstMHRequestDetailsTrack"] = new List<RightsU_Entities.USPMHRequistionTrackList_Result>();
                return (List<RightsU_Entities.USPMHRequistionTrackList_Result>)Session["lstMHRequestDetailsTrack"];
            }
            set { Session["lstMHRequestDetailsTrack"] = value; }
        }

        private List<RightsU_Entities.USPMHRequistionTrackList_Result> lstMHRequestDetailsTrack_Searched
        {
            get
            {
                if (Session["lstMHRequestDetailsTrack_Searched"] == null)
                    Session["lstMHRequestDetailsTrack_Searched"] = new List<RightsU_Entities.USPMHRequistionTrackList_Result>();
                return (List<RightsU_Entities.USPMHRequistionTrackList_Result>)Session["lstMHRequestDetailsTrack_Searched"];
            }
            set { Session["lstMHRequestDetailsTrack_Searched"] = value; }
        }

        private MHRequestTabPaging objMHRequestTabPaging
        {
            get
            {
                if (Session["objMHRequestTabPaging"] == null)
                    Session["objMHRequestTabPaging"] = new MHRequestTabPaging();
                return (MHRequestTabPaging)Session["objMHRequestTabPaging"];
            }
            set { Session["objMHRequestTabPaging"] = value; }
        }

        #endregion
        public ActionResult GetAllRequest(string Key = "", int MHRequestCode = 0, string callFor = "", int MHTypeCode = 1)
        {
            TempData["key"] = Key;
            TempData["MHRequestCode"] = MHRequestCode;
            TempData["callFor"] = callFor;
            if (MHTypeCode == 2)
            {
                TempData["MHTypeCode"] = "OT";
            }
            else if (MHTypeCode == 3)
            {
                TempData["MHTypeCode"] = "SM";
            }
            else
            {
                TempData["MHTypeCode"] = "CM";
            }
            return RedirectToAction("Index", "MHRequisition");
        }
        public ViewResult Index()
        {
            // var lstData = "";
            ViewBag.Key = TempData["key"];
            ViewBag.MHRequestCode = TempData["MHRequestCode"];
            ViewBag.CallFor = TempData["callFor"];
            ViewBag.MHTypeCode = TempData["MHTypeCode"];
            // LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusic_Title);       
            return View("~/Views/MHRequisition/Index.cshtml");
        }

        public PartialViewResult BindPartialPages(string key, int MHRequestCode, string callFor = "")
        {

            if (callFor == "D")
            {
                lstMHRequest = lstMHRequest_Searched = new MHRequest_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            }
            MHRequest_Service objService = new MHRequest_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.MHRequest objMHRequest = null;
            if (key == "LIST")
            {
                // lstMHRequest = lstMHRequest_Searched = objService.SearchFor(x => true).ToList();
                return PartialView("~/Views/MHRequisition/_MHRequsistionMetadata.cshtml");
            }
            else if (key == "CHILD" || key == "VIEW")
            {
                int? MHrequestCode = 0;

                ViewBag.CallFor = callFor;
                ViewBag.key = key;
                objMHRequest = lstMHRequest.Where(x => x.MHRequestCode == MHRequestCode).FirstOrDefault();
                lstMHRequestDetails = lstMHRequestDetails_Searched = objMHRequest.MHRequestDetails.ToList();
                ViewBag.MHRequestCode = lstMHRequestDetails.Select(x => x.MHRequestCode).FirstOrDefault();
                MHrequestCode = Convert.ToInt32(ViewBag.MHRequestCode);
                List<RightsU_Entities.USPMHRequistionTrackList_Result> lstUSPMHRequistionTrackList_Result = new USP_Service(objLoginEntity.ConnectionStringName).USPMHRequistionTrackList(MHrequestCode).ToList();
                lstMHRequestDetailsTrack = lstMHRequestDetailsTrack_Searched = lstUSPMHRequistionTrackList_Result.ToList();

                return PartialView("~/Views/MHRequisition/_MHRequisitionApprove.cshtml", objMHRequest);
            }

            return PartialView("~/Views/MHRequisition/_MHRequisitionApprove.cshtml", objMHRequest);
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
        public PartialViewResult BindGrid(bool fetchData, bool isTabChanged, string currentTabName, string previousTabName, int pageNo,
            int recordPerPage, string productionHouseCode = "", string musicLabel = "", string fromDate = "", string toDate = "", string statusCode = "",
            string titleCodes = ""
            )
        {
            titleCodes = titleCodes.Replace('﹐', ',');
            List<USPMHRequisitionList_Result> lst = new List<USPMHRequisitionList_Result>();
            ViewBag.TabName = currentTabName;
            if (fetchData)
            {
                lstMHRequest = lstMHRequest_Searched = new MHRequest_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            }

            if (isTabChanged)
            {
                objMHRequestTabPaging.SetPropertyValue("PageNo_" + previousTabName, pageNo);
                objMHRequestTabPaging.SetPropertyValue("PageSize_" + previousTabName, recordPerPage);

                pageNo = (int)objMHRequestTabPaging.GetPropertyValue("PageNo_" + currentTabName);
                pageNo = (pageNo == 0) ? 1 : pageNo;
                recordPerPage = (int)objMHRequestTabPaging.GetPropertyValue("PageSize_" + currentTabName);
                recordPerPage = (recordPerPage == 0) ? 10 : recordPerPage;
            }
            else
            {
                objMHRequestTabPaging.SetPropertyValue("PageNo_" + currentTabName, pageNo);
                objMHRequestTabPaging.SetPropertyValue("PageSize_" + currentTabName, recordPerPage);
            }
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);

            if (currentTabName == "CM")
            {
                //ViewBag.RecordCount = lstMHRequest.Where(x => x.MHRequestTypeCode == 1).ToList().Count();
                ViewBag.PageNo = pageNo;
                ViewBag.PageSize = recordPerPage;

                lst = new USP_Service(objLoginEntity.ConnectionStringName).USPMHRequisitionList(productionHouseCode, musicLabel, 1, fromDate, toDate, statusCode, titleCodes, "", "", pageNo, recordPerPage, "", "", objRecordCount).ToList();
                RecordCount = Convert.ToInt32(objRecordCount.Value);
                ViewBag.RecordCount = RecordCount;
                //}
            }
            else if (currentTabName == "OT")
            {
                //ViewBag.RecordCount = lstMHRequest.Where(x => x.MHRequestTypeCode == 2).ToList().Count();
                ViewBag.PageNo = pageNo;
                ViewBag.PageSize = recordPerPage;


                lst = lst = new USP_Service(objLoginEntity.ConnectionStringName).USPMHRequisitionList(productionHouseCode, musicLabel, 2, fromDate, toDate, statusCode, "", "", "", pageNo, recordPerPage, "", "", objRecordCount).ToList();
                RecordCount = Convert.ToInt32(objRecordCount.Value);
                ViewBag.RecordCount = RecordCount;
                //}
            }
            else if (currentTabName == "SM")
            {
                // ViewBag.RecordCount = lstMHRequest.Where(x => x.MHRequestTypeCode == 3).ToList().Count();  
                ViewBag.PageNo = pageNo;
                ViewBag.PageSize = recordPerPage;

                lst = lst = new USP_Service(objLoginEntity.ConnectionStringName).USPMHRequisitionList(productionHouseCode, musicLabel, 3, fromDate, toDate, statusCode, "", "", "", pageNo, recordPerPage, "", "", objRecordCount).ToList();
                RecordCount = Convert.ToInt32(objRecordCount.Value);
                ViewBag.RecordCount = RecordCount;
                //}
            }
            ViewBag.currentTabName = currentTabName;
            return PartialView("~/Views/MHRequisition/_MHRequisitionList.cshtml", lst);
        }
        public PartialViewResult BindMHRequestDetails_List(int pageNo, int recordPerPage, int MHRequestDetailsCode, string commandName, int MHRequestTypeCode, string Status)
        {
            string Url = "";
            ViewBag.CommandName = commandName;
            List<RightsU_Entities.MHRequestDetail> lst = new List<RightsU_Entities.MHRequestDetail>();
            dynamic lstdata;
            int RecordCount = 0;
            int? MHrequestCode = 0;
            RecordCount = lstMHRequestDetails_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstMHRequestDetails_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.PageSize = recordPerPage;
            ViewBag.PageNo = pageNo;
            ViewBag.key = Status;
            ViewBag.MHRequestCode = lst.Select(x => x.MHRequestCode).FirstOrDefault();
            MHrequestCode = Convert.ToInt32(ViewBag.MHRequestCode);
            lstdata = lst;
            if (MHRequestTypeCode == 1)
            {
                Url = "~/Views/MHRequisition/_MHRequisitionConsumeList.cshtml";
            }
            else if (MHRequestTypeCode == 2)
            {

                int noOfRecordSkip, noOfRecordTake;

                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lstdata = lstMHRequestDetailsTrack_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //RecordCount = lstdata.Count;
                //List<RightsU_Entities.USPMHRequistionTrackList_Result> lstUSPMHRequistionTrackList_Result = new USP_Service(objLoginEntity.ConnectionStringName).USPMHRequistionTrackList(MHrequestCode).ToList();
                // lstdata = lstUSPMHRequistionTrackList_Result;

                Url = "~/Views/MHRequisition/_MHRequisitionTrackList.cshtml";

            }
            else if (MHRequestTypeCode == 3)
            {
                Url = "~/Views/MHRequisition/_MHRequisitionMovieList.cshtml";
            }
            return PartialView(Url, lstdata);
        }
        public JsonResult SearchMHRequestDetails(string searchText, string tabName = "CM")
        {

            Genre_Service objService = new Genre_Service(objLoginEntity.ConnectionStringName);
            if (!string.IsNullOrEmpty(searchText))
            {
                if (tabName == "CM")
                {
                    lstMHRequestDetails_Searched = lstMHRequestDetails.Where(w => w.Music_Title.Music_Title_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
                }
                else if (tabName == "OT")
                {

                    lstMHRequestDetailsTrack_Searched = lstMHRequestDetailsTrack.Where(w => w.RequestedMusicTitleName.ToUpper().Contains(searchText.ToUpper())).ToList();

                }
                else if (tabName == "SM")
                {
                    lstMHRequestDetails_Searched = lstMHRequestDetails.Where(w => w.TitleName.ToUpper().Contains(searchText.ToUpper())).ToList();
                }
            }
            else
            {
                if (tabName == "OT")
                {
                    int? MHrequestCode = 0;
                    ViewBag.MHRequestCode = lstMHRequestDetails_Searched.Select(x => x.MHRequestCode).FirstOrDefault();
                    MHrequestCode = Convert.ToInt32(ViewBag.MHRequestCode);
                    List<RightsU_Entities.USPMHRequistionTrackList_Result> lstUSPMHRequistionTrackList_Result = new USP_Service(objLoginEntity.ConnectionStringName).USPMHRequistionTrackList(MHrequestCode).ToList();
                    lstMHRequestDetailsTrack_Searched = lstUSPMHRequistionTrackList_Result.ToList();
                    //lstMHRequestDetailsTrack_Searched = lstMHRequestDetailsTrack;
                }
                else
                {
                    lstMHRequestDetails_Searched = lstMHRequestDetails;
                }
            }


            var obj = new
            {

                Record_Count = tabName == "OT" ? lstMHRequestDetailsTrack_Searched.Count : lstMHRequestDetails_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult SaveMHRequestDetails_List(List<MHRD> lstCML)
        {
            foreach (var item in lstCML)
            {
                MHRequestDetail obj = lstMHRequestDetails.Where(x => x.MHRequestDetailsCode == item.MHRDCode).FirstOrDefault();
                if (obj != null)
                {
                    if (obj.IsApprove != "Y" && obj.IsApprove != "N")
                    { obj.IsApprove = item.IsApprove ? "O" : "P"; }
                    obj.Remarks = item.Remarks;
                }

                MHRequestDetail obj_Search = lstMHRequestDetails_Searched.Where(x => x.MHRequestDetailsCode == item.MHRDCode).FirstOrDefault();
                if (obj_Search != null && obj.IsApprove != "Y")
                {
                    if (obj.IsApprove != "Y" && obj.IsApprove != "N")
                    { obj.IsApprove = item.IsApprove ? "O" : "P"; }

                    obj.Remarks = item.Remarks;
                }
            }
            return Json("S");
        }

        public JsonResult finalConsApprove(string SpecialInst, string InternalRmk, int MHRequestCode, string key, string Is_ApproveRejectYes)
        {
            dynamic resultSet;
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            MHRequest_Service objService = new MHRequest_Service(objLoginEntity.ConnectionStringName);
            MHRequest objMHRequest = new MHRequest();
            objMHRequest = objService.GetById(MHRequestCode);

            objMHRequest.SpecialInstruction = SpecialInst;
            objMHRequest.InternalRemarks = InternalRmk;
            objMHRequest.EntityState = State.Modified;

            int TotalCount_P = lstMHRequestDetails.Where(x => x.IsApprove == "P").ToList().Count();
            int TotalCountMHReqDetails = lstMHRequestDetails.Count();

            if (TotalCount_P == TotalCountMHReqDetails)
            {
                status = "E";
                message = "Please select atleast one record";
            }
            else
            {
                foreach (var item in lstMHRequestDetails)
                {
                    MHRequestDetail obj = objMHRequest.MHRequestDetails.Where(x => x.MHRequestDetailsCode == item.MHRequestDetailsCode).FirstOrDefault();
                    obj.EntityState = State.Modified;
                    obj.Remarks = item.Remarks;
                    if (key == "A" && item.IsApprove == "O")
                    {
                        obj.IsApprove = "Y";
                    }
                    else if (key == "R" && item.IsApprove == "O")
                    {
                        obj.IsApprove = "N";
                    }
                }

                int TotalCount_Y = objMHRequest.MHRequestDetails.Where(x => x.IsApprove == "Y").ToList().Count();
                int TotalCount_N = objMHRequest.MHRequestDetails.Where(x => x.IsApprove == "N").ToList().Count();
                int TotalCount = objMHRequest.MHRequestDetails.Count();
                int Count_YN = TotalCount_Y + TotalCount_N;

                if ((TotalCount != Count_YN && Is_ApproveRejectYes == "Approve") || (TotalCount != Count_YN && Is_ApproveRejectYes == "Reject"))
                {
                    status = "C";
                    message = "Do You Want to Leave This Page ?";
                }
                else
                {
                    if (TotalCount == TotalCount_Y || TotalCount == TotalCount_N)
                    {
                        objMHRequest.ApprovedOn = DateTime.Now;
                        objMHRequest.MHRequestStatusCode = (TotalCount == TotalCount_Y ? 1 : 3);//Approved : REJECT
                    }
                    else if (TotalCount_Y < TotalCount || TotalCount_N < TotalCount)
                    {
                        objMHRequest.MHRequestStatusCode = 4;
                    }

                    objMHRequest.ApprovedOn = DateTime.Now;
                    objMHRequest.ApprovedBy = objLoginUser.Users_Code;
                    bool isValid = objService.Save(objMHRequest, out resultSet);

                    if (isValid)
                    {
                        var result = new USP_Service(objLoginEntity.ConnectionStringName).USPMHMailNotification((int)objMHRequest.MHRequestCode, objMHRequest.MHRequestTypeCode, 0).FirstOrDefault();
                        lstMHRequest = lstMHRequest_Searched = objService.SearchFor(x => true).ToList();
                    }
                    else
                    {
                        status = "E";
                        message = resultSet;
                    }
                }
            }
            var objNEW = new
            {
                Status = status,
                Message = message,
                Is_ApproveRejectYes = Is_ApproveRejectYes
            };
            return Json(objNEW);
        }
    }
    public class MHRequestTabPaging
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
    public class MHRD
    {
        public int MHRDCode { get; set; }
        public string Remarks { get; set; }
        public bool IsApprove { get; set; }
    }
}
