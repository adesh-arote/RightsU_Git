//using RightsU_BLL;
//using RightsU_Entities;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;
using RightsU_Dapper.BLL.Services;
using RightsU_BLL;

namespace RightsU_Plus.Controllers
{
   
    public class Music_Deal_ListController : BaseController
    {
        private readonly Music_DealServices objMusic_Deal_Services = new Music_DealServices();
        private readonly System_Parameter_NewService objSPNService = new System_Parameter_NewService();
        

        private Music_Deal_Search objMusicDealSearch
        {
            get
            {
                if (Session["objMusicDealSearch"] == null)
                    Session["objMusicDealSearch"] = new Music_Deal_Search();
                return (Music_Deal_Search)Session["objMusicDealSearch"];
            }

            set
            {
                Session["objMusicDealSearch"] = value;
            }
        }    
        public ActionResult Index()
        {
            string isMenu = "Y";
            if (TempData["IsMenu"] != null)
                isMenu = TempData["IsMenu"].ToString();

            string searchType = "", searchText = "";
            int pageNo = 1, recordPerPage = 10;
            int RecordLockingCode = objMusicDealSearch.RecordLockingCode;
            if (isMenu == "Y")
                objMusicDealSearch = null;
            else
            {
                pageNo = objMusicDealSearch.PageNo;
                recordPerPage = objMusicDealSearch.RecordPerPage;
                if (!string.IsNullOrEmpty(objMusicDealSearch.IsAdvance_Search))
                {
                    if (objMusicDealSearch.IsAdvance_Search == "Y")
                        searchType = "A";
                    else if (objMusicDealSearch.SearchText != "")
                    {
                        searchType = "C";
                        searchText = objMusicDealSearch.SearchText;
                    }
                }
            }

            if (RecordLockingCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(RecordLockingCode, objLoginEntity.ConnectionStringName);
            }
            ViewBag.SearchType = searchType;
            ViewBag.SearchText = searchText;
            ViewBag.PageNo = pageNo;
            ViewBag.RecordPerPage = recordPerPage;
            ViewBag.UserModuleRights = GetUserModuleRights();
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicDeal);

            var MusicDealVersion =  objSPNService.GetList().Where(x=> x.Parameter_Name == "Music_Platform_Visibility").Select(w => w.Parameter_Value).FirstOrDefault();
            ViewBag.IsMuciVersionSPN = MusicDealVersion;
            return View();
        }
        public PartialViewResult BindMusicDealList(int pageNo, int recordPerPage, string SearchText, string Agreement_No, string Title_Code, string Title_Name, DateTime? StartDate,
            DateTime? EndDate, string[] Deal_Type_Code, string[] Show_Type_Code, string[] Status_Code,
            int Business_Unit_Code, string Workflow_Status, string Vendor_Codes, string Music_Label_Codes, string IsAdvance_Search)
        {
            string strDeal_Type_Code = "";
            if (Deal_Type_Code != null)
                strDeal_Type_Code = string.Join(",", Deal_Type_Code);

            string strStatus_Code = "";
            if (Status_Code != null)
                strStatus_Code = string.Join(",", Status_Code);

            string strShow_Type_Code = "";
            if (Show_Type_Code != null)
                strShow_Type_Code = string.Join(",", Show_Type_Code);

            //USP_Service objService = new USP_Service(objLoginEntity.ConnectionStringName);
            int recordCount = 0;
            //ObjectParameter objPageNo = new ObjectParameter("PageNo", pageNo);
            //ObjectParameter objTotalRecord = new ObjectParameter("RecordCount", recordCount);
            //List<USP_List_Music_Deal_Result> lstMusicDeal = objService.USP_List_Music_Deal(
            //    SearchText, Agreement_No, StartDate, EndDate, strDeal_Type_Code, strStatus_Code, Business_Unit_Code,
            //    0, Workflow_Status, Vendor_Codes, strShow_Type_Code, Title_Code, Music_Label_Codes, IsAdvance_Search,
            //    objLoginUser.Users_Code, objPageNo, recordPerPage, objTotalRecord
            //).ToList();

            List<USP_List_Music_Deal_Result> lstMusicDeal = objMusic_Deal_Services.USP_List_Music_Deal(
                SearchText, Agreement_No, StartDate, EndDate, strDeal_Type_Code, strStatus_Code, Business_Unit_Code,
                0, Workflow_Status, Vendor_Codes, strShow_Type_Code, Title_Code, Music_Label_Codes, IsAdvance_Search,
                objLoginUser.Users_Code, pageNo, recordPerPage, out recordCount
            ).ToList();

            //recordCount = Convert.ToInt32(objTotalRecord.Value);
            //pageNo = Convert.ToInt32(objPageNo.Value);

            ViewBag.RecordCount = recordCount;
            ViewBag.PageNo = pageNo;

            #region --- Maintain Search Criteria ---
            objMusicDealSearch.PageNo = pageNo;
            objMusicDealSearch.RecordPerPage = recordPerPage;
            objMusicDealSearch.SearchText = SearchText;
            objMusicDealSearch.Agreement_No = Agreement_No;
            if (StartDate != null)
                objMusicDealSearch.StartDate = ((DateTime)StartDate).ToString(GlobalParams.DateFormat);
            if (EndDate != null)
                objMusicDealSearch.EndDate = ((DateTime)EndDate).ToString(GlobalParams.DateFormat);
            objMusicDealSearch.Deal_Type_Code = strDeal_Type_Code;
            objMusicDealSearch.Show_Type_Code = strShow_Type_Code;
            objMusicDealSearch.Status_Code = strStatus_Code;
            objMusicDealSearch.Business_Unit_Code = Business_Unit_Code;
            objMusicDealSearch.Deal_Tag_Code = 0;
            objMusicDealSearch.Workflow_Status = Workflow_Status;
            objMusicDealSearch.Vendor_Codes = Vendor_Codes;
            objMusicDealSearch.Title_Codes = Title_Code;
            objMusicDealSearch.Title_Name = Title_Name;
            objMusicDealSearch.Music_Label_Codes = Music_Label_Codes;
            objMusicDealSearch.IsAdvance_Search = IsAdvance_Search;
            #endregion          
            return PartialView("~/Views/Music_Deal_List/_Music_Deal_List.cshtml", lstMusicDeal);
        }
        public JsonResult BindAdvanceSearch(string CallFrom)
        {
            string[] arrMDUBUCodes = new RightsU_BLL.Users_Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Users_Code == objLoginUser.Users_Code).Select(x => x.Business_Unit_Code.ToString()).ToArray();
            List<Music_Deal_Dapper> lstMusicDeal = objMusic_Deal_Services.GetMusic_DealList().Where(x => arrMDUBUCodes.Contains(x.Business_Unit_Code.ToString())).ToList();
            string[] arrStatusCodes = lstMusicDeal.Select(x=>x.Deal_Tag_Code.ToString()).Distinct().ToArray();
            string[] arrWorkFlowStatus = lstMusicDeal.Select(x => x.Deal_Workflow_Status).Distinct().ToArray();
            string[] arrVendorCodes = lstMusicDeal.Select(x => x.Primary_Vendor_Code.ToString()).Distinct().ToArray();
            string[] arrMusicLabelCodes = lstMusicDeal.Select(x => x.Music_Label_Code.ToString()).Distinct().ToArray();
            string[] arrLinkShowType = lstMusicDeal.Select(x => x.Link_Show_Type).Distinct().ToArray();              
            string[] arrMDCodes = lstMusicDeal.Select(x => x.Music_Deal_Code.ToString()).ToArray();
            string[] arrMDBUCodes = lstMusicDeal.Select(x=>x.Business_Unit_Code.ToString()).ToArray();

            //System_Parameter_New_Service objSPNService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);

            #region --- Business Unit List ---
            var obj = new
            {
                IsActive = "Y"
            };
            System_Parameter_New objSPN = objSPNService.GetList().Where(s => s.Parameter_Name == "BusinessUnitCodesForMusicDeal" && s.IsActive == "Y").FirstOrDefault();
            if (objSPN == null)
                objSPN = new System_Parameter_New();

            string strBuCodes = (objSPN.Parameter_Value ?? "");
            string[] arrBUCodes = strBuCodes.Split(',');

            List<SelectListItem> lstBusinessUnit = new SelectList(new RightsU_BLL.Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"
               && (arrBUCodes.Contains(x.Business_Unit_Code.ToString()) || string.IsNullOrEmpty(strBuCodes))).
                SelectMany(s => s.Users_Business_Unit).Where(w => w.Users_Code == objLoginUser.Users_Code && (arrMDBUCodes.Contains(w.Business_Unit_Code.ToString()))).
                Select(s => s.Business_Unit).ToList(), "Business_Unit_Code", "Business_Unit_Name").OrderBy(o => o.Text).ToList();
            lstBusinessUnit.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            #endregion --- Business Unit List ---

            #region --- Deal Tag List ---
            objSPN = objSPNService.SearchFor(obj).Where(s => s.Parameter_Name == "DealTagCodesForMusicDeal" && s.IsActive == "Y").FirstOrDefault();
            if (objSPN == null)
                objSPN = new System_Parameter_New();
            string strDealTagCodes = (objSPN.Parameter_Value ?? "");
            string[] arrDealTagCodes = strDealTagCodes.Split(',');

            List<SelectListItem> lstDealTag = new SelectList(new RightsU_BLL.Deal_Tag_Service(objLoginEntity.ConnectionStringName).SearchFor(x =>
                (arrDealTagCodes.Contains(x.Deal_Tag_Code.ToString()) || string.IsNullOrEmpty(strDealTagCodes))).ToList(),
              "Deal_Tag_Code", "Deal_Tag_Description").OrderBy(o => o.Text).ToList();
            lstDealTag.Insert(0, new SelectListItem() { Text = "Please Select", Value = "0" });
            #endregion --- Deal Tag List ---

            #region --- Deal Type List ---
            objSPN = objSPNService.SearchFor(obj).Where(s => s.Parameter_Name == "DealTypeCodesForMusicDeal" && s.IsActive == "Y").FirstOrDefault();
            if (objSPN == null)
                objSPN = new System_Parameter_New();
            string strDealTypeCodes = (objSPN.Parameter_Value ?? "");
            string[] arrDealTypeCodes = strDealTypeCodes.Split(',');

            List<SelectListItem> lstDealType = new SelectList(new RightsU_BLL.Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x =>
                (arrDealTypeCodes.Contains(x.Deal_Type_Code.ToString()) || string.IsNullOrEmpty(strDealTypeCodes))).
                SelectMany(s=>s.Music_Deal_DealType).Where( w=> (arrMDCodes.Contains(w.Music_Deal_Code.ToString()))).
                Select(s=>s.Deal_Type).Distinct().ToList(), "Deal_Type_Code", "Deal_Type_Name").OrderBy(o => o.Text).ToList();
          
            List<SelectListItem> lstShowType = new List<SelectListItem>();

            lstShowType.Insert(0, new SelectListItem() { Text = "Fiction", Value = "AF" });
            lstShowType.Insert(0, new SelectListItem() { Text = "Non Fiction", Value = "AN" });
            lstShowType.Insert(0, new SelectListItem() { Text = "Event", Value = "AE" });
            lstShowType.Insert(0, new SelectListItem() { Text = "All Shows", Value = "AS" });
            lstShowType.Insert(0, new SelectListItem() { Text = "Specific", Value = "SP" });

            List<SelectListItem> lstLinkShowType = lstShowType.Where(x => (arrLinkShowType.Contains(x.Value))).Distinct().ToList();
            #endregion --- Deal Type List ---
            #region Statys Type list

            List<SelectListItem> lstStatus = new SelectList(new RightsU_BLL.Deal_Tag_Service(objLoginEntity.ConnectionStringName).SearchFor(x => (arrStatusCodes.Contains(x.Deal_Tag_Code.ToString()))).OrderByDescending(o => o.Deal_Tag_Code).ToList(),
              "Deal_Tag_Code", "Deal_Tag_Description").OrderBy(o => o.Text).ToList();
            #endregion   
            List<SelectListItem> lstWorkFlowStatus = new SelectList(new RightsU_BLL.Deal_Workflow_Status_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type == "M" && (arrWorkFlowStatus.Contains(x.Deal_WorkflowFlag.ToUpper()))).ToList(),
              "Deal_WorkflowFlag", "Deal_Workflow_Status_Name").OrderBy(o => o.Text).ToList();
            lstWorkFlowStatus.Insert(0, new SelectListItem() { Text = "All", Value = "0" });

            List<SelectListItem> lstVendor = new SelectList(new RightsU_BLL.Music_Deal_Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(s => (arrMDCodes.Contains(s.Music_Deal_Code.ToString())))
              .Select(s => new { Display_Value = s.Vendor_Code, Display_Text = s.Vendor.Vendor_Name.Trim() }).Distinct().ToList(),
              "Display_Value", "Display_Text").OrderBy(o => o.Text).ToList();

            List<SelectListItem> lstMusicLabel = new List<SelectListItem>();
            //List<SelectListItem> lstMusicLabel = new SelectList(objMusic_Deal_Services.GetMusic_DealList().Where(s => (arrMusicLabelCodes.Contains(s.Music_Label_Code.ToString())))
            //    .Select(s => new { Display_Value = s.Music_Label_Code, Display_Text = s.Music_Label.Music_Label_Name.Trim() }).Distinct().ToList(),
            //    "Display_Value", "Display_Text").OrderBy(o => o.Text).ToList();

            Dictionary<string, object> objDictionary = new Dictionary<string, object>();
            objDictionary.Add("Deal_Type_List", lstDealType);
            objDictionary.Add("Show_Type_List", lstLinkShowType);
            objDictionary.Add("Status_List", lstStatus);
            objDictionary.Add("Business_Unit_List", lstBusinessUnit);
            objDictionary.Add("Deal_Tag_List", lstDealTag);
            objDictionary.Add("Vendor_List", lstVendor);
            objDictionary.Add("Music_Label_List", lstMusicLabel);
            objDictionary.Add("Workflow_Status_List", lstWorkFlowStatus);

            if (CallFrom == "PGL")
                objDictionary.Add("ObjMusicDealSearch", objMusicDealSearch);

            return Json(objDictionary);
        }
        public ActionResult ButtonEvents(string CommandName, int Music_Deal_Code, int Record_Locking_Code = 0, string ApprovalRemark = "", bool calledByAjax = false)
        {
            if (calledByAjax)
            {
                bool isLocked = true;
                string status = "S", message = "";

                if (Record_Locking_Code == 0)
                {
                    CommonUtil objCommonUtil = new CommonUtil();
                    isLocked = objCommonUtil.Lock_Record(Music_Deal_Code, GlobalParams.ModuleCodeForMusicDeal, objLoginUser.Users_Code, out Record_Locking_Code, out message, objLoginEntity.ConnectionStringName);
                }
                if (isLocked)
                {
                    if (CommandName == GlobalParams.DEAL_MODE_DELETE)
                    {
                        
                        Music_Deal_Dapper objMusicDeal = objMusic_Deal_Services.GetMusic_DealByID(Music_Deal_Code);
                        //dynamic resultSet = "";
                        objMusic_Deal_Services.DeleteMusic_Deal(objMusicDeal);
                        //if (!objService.Delete(objMusicDeal, out resultSet))
                        //{
                        //    status = "E";
                        //    message = resultSet;
                        //}
                        //else
                            message = "Deal deleted successfully";
                    }
                    else if (CommandName == GlobalParams.DEAL_MODE_ROLLBACK)
                    {
                        //ObjectParameter objErrorMessage = new ObjectParameter("ErrorMessage", message);
                       objMusic_Deal_Services.USP_RollBack_Music_Deal(Music_Deal_Code, objLoginUser.Users_Code, out message);
                       // message = Convert.ToString(objErrorMessage.Value);
                        if (message != "")
                            status = "E";
                        else
                            message = "Deal rolled back successfully";
                    }
                    else if (CommandName == GlobalParams.DEAL_MODE_SEND_FOR_APPROVAL || CommandName == GlobalParams.DEAL_MODE_APPROVE)
                    {
                        string uspResult = Convert.ToString(new USP_Service(objLoginEntity.ConnectionStringName).USP_Assign_Workflow(Music_Deal_Code, GlobalParams.ModuleCodeForMusicDeal, objLoginUser.Users_Code, ApprovalRemark).ElementAt(0));
                        string[] arrUspResult = uspResult.Split('~');

                        if (arrUspResult.Length == 2)
                        {
                            string isError = arrUspResult[1];
                            bool isMailError = false;
                            int count = 0;
                            try
                            {
                                count = Convert.ToInt32(arrUspResult[0]);
                                if (count > 1 && isError == "Y")
                                {
                                    isError = "N";
                                    isMailError = true;
                                }
                            }
                            catch (Exception)
                            {
                                count = 0;
                                isError = "Y";
                            }

                            if (isError == "N")
                            {
                                status = "S";
                                if (CommandName == GlobalParams.DEAL_MODE_APPROVE)
                                {
                                    if (isMailError)
                                        message = "Deal Approved Successfully, but unable to send mail. Please check the error log..";
                                    else
                                        message = "Deal Approved Successfully";
                                }
                                else
                                {
                                    if (isMailError)
                                        message = "Deal Successfully Sent for Approval, but unable to send mail. Please check the error log..";
                                    else
                                        message = "Deal Sent for Approval Successfully";
                                }
                            }
                            else if (isError == "Y")
                            {
                                status = "E";
                                message = arrUspResult[0];
                            }
                        }
                    }
                }
                else
                    status = "E";

                if (Record_Locking_Code > 0)
                {
                    CommonUtil objCommonUtil = new CommonUtil();
                    objCommonUtil.Release_Record(Record_Locking_Code, objLoginEntity.ConnectionStringName);
                }
                var obj = new
                {
                    Status = status,
                    Message = message
                };
                return Json(obj);
            }
            else
            {
                if (CommandName == "APPROVE_NEXT_PAGE")
                    CommandName = GlobalParams.DEAL_MODE_APPROVE;
                TempData["Music_Deal_Code"] = Music_Deal_Code;
                TempData["Mode"] = CommandName;
                TempData["RecodLockingCode"] = objMusicDealSearch.RecordLockingCode;
                return RedirectToAction("Index", "Music_Deal");
            }
        }
        public JsonResult CheckRecordLock(int Music_Deal_Code)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Music_Deal_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Music_Deal_Code, GlobalParams.ModuleCodeForMusicDeal, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }
            if (isLocked)
                objMusicDealSearch.RecordLockingCode = RLCode;

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult CheckRecordCurrentStatus(int Music_Deal_Code)
        {
            string message = "";
            int RLCode = 0;
            bool isLocked = false;
            int count = objMusic_Deal_Services.GetMusic_DealList().Where(s => s.Music_Deal_Code == Music_Deal_Code && (s.Deal_Workflow_Status == "A" || s.Deal_Workflow_Status == "W")).Count();
            if (count > 0)
                message = "The deal is already processed by another Approver";
            else if (Music_Deal_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Music_Deal_Code, GlobalParams.ModuleCodeForMusicDeal, objLoginUser.Users_Code, out RLCode, out message, objLoginEntity.ConnectionStringName);
            }
            var obj = new
            {
                BindList = (count > 0) ? "Y" : "N",
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = message,
                Record_Locking_Code = RLCode
            };

            return Json(obj);
        }
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForMusicDeal), objLoginUser.Security_Group_Code,objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();
            return rights;
        }
        public JsonResult PopulateTitleNameForAcqDeal(string[] Show_Type_Code, string keyword = "")
        {
            string Deal_Type_Short_Name = string.Empty;
            string Deal_Type_Name = string.Empty;
            List<string> arrDTCodes = new List<string>();
            List<string> arrTTCodes = new List<string>();
            List<string> lst = new List<string>();
            if (Show_Type_Code != null)
            {
                foreach (var item in Show_Type_Code)
                {
                    Deal_Type_Short_Name = item.ToString();
                    switch (Deal_Type_Short_Name)
                    {
                        case "AF":
                            Deal_Type_Name = "FICTION";
                            break;
                        case "AN":
                            Deal_Type_Name = "NON-FICTION";
                            break;
                        case "AE":
                            Deal_Type_Name = "EVENT";
                            break;
                        case "AS":
                            Deal_Type_Name = "SHOW";
                            break;
                        case "SP":
                            Deal_Type_Name = "SPECIFIC";
                            break;
                    }

                    if (Deal_Type_Short_Name != "AS" && Deal_Type_Short_Name != "SP")
                    {
                        lst = new Deal_Type_Service(objLoginEntity.ConnectionStringName)
                                       .SearchFor(x => x.Deal_Type_Name.ToUpper() == Deal_Type_Name)
                                       .Select(x => x.Deal_Type_Code.ToString())
                                       .ToList();
                    }
                    else if (Deal_Type_Short_Name == "AS")
                    {
                        lst = new Deal_Type_Service(objLoginEntity.ConnectionStringName)
                                 .SearchFor(x => x.Deal_Type_Name.ToUpper() == "FICTION" || x.Deal_Type_Name.ToUpper() == "NON-FICTION" || x.Deal_Type_Name.ToUpper() == "EVENT")
                                 .Select(x => x.Deal_Type_Code.ToString()).ToList();
                    }
                    else if (Deal_Type_Short_Name == "SP")
                    {
                        arrTTCodes = new Music_Deal_LinkShow_Service(objLoginEntity.ConnectionStringName)
                                    .SearchFor(x => true).Select(x => x.Title_Code.ToString()).Distinct().ToList();
                    }

                    foreach (var val in lst)
                    {
                        arrDTCodes.Add(val);
                    }

                }
            }
            else
            {
                lst = new Deal_Type_Service(objLoginEntity.ConnectionStringName)
                                 .SearchFor(x => x.Deal_Type_Name.ToUpper() == "FICTION" || x.Deal_Type_Name.ToUpper() == "NON-FICTION" || x.Deal_Type_Name.ToUpper() == "EVENT")
                                 .Select(x => x.Deal_Type_Code.ToString()).ToList();

                arrTTCodes = new Music_Deal_LinkShow_Service(objLoginEntity.ConnectionStringName)
                                   .SearchFor(x => true).Select(x => x.Title_Code.ToString()).Distinct().ToList();

                foreach (var val in lst)
                {
                    arrDTCodes.Add(val);
                }

            }
            //dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();

                if (Show_Type_Code != null)
                {
                    var result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Name.ToUpper()
                    .Contains(searchString.ToUpper())
                    && s.Is_Active == "Y"
                    && arrDTCodes.Contains(s.Deal_Type_Code.ToString()))
                    .Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).Distinct().ToList();


                    if (Show_Type_Code.Contains("SP"))
                    {
                        var titleresult = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Name.ToUpper()
                            .Contains(searchString.ToUpper())
                            && s.Is_Active == "Y"
                            && arrTTCodes.Contains(s.Title_Code.ToString()))
                            .Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).Distinct().ToList();

                        foreach (var item in titleresult)
                        {
                            result.Add(item);
                        }
                    }
                    return Json(result);
                }
                else
                {
                    var result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Name.ToUpper()
                   .Contains(searchString.ToUpper())
                    && s.Is_Active == "Y"
                    && (arrDTCodes.Contains(s.Deal_Type_Code.ToString()) || arrTTCodes.Contains(s.Title_Code.ToString()))
                     )
                   .Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).Distinct().ToList();
                    return Json(result);
                }
                
            }

            return Json("");
        }
    }

    public class Music_Deal_Search
    {
        public int PageNo { get; set; }
        public int RecordPerPage { get; set; }
        public string SearchText { get; set; }
        public string Agreement_No { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Deal_Type_Code { get; set; }
        public string Show_Type_Code { get; set; }
        public string Status_Code { get; set; }
        public int Business_Unit_Code { get; set; }
        public int Deal_Tag_Code { get; set; }
        public string Workflow_Status { get; set; }
        public string Vendor_Codes { get; set; }
        public string Title_Codes { get; set; }
        public string Title_Name { get; set; }
        public string Music_Label_Codes { get; set; }
        public string IsAdvance_Search { get; set; }
        public int RecordLockingCode { get; set; }
    }
}
