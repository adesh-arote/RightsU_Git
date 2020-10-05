using System;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Syn_ListController : BaseController
    {
        #region --------------- ATTRIBUTES AND PROPERTIES---------------
        public Acq_Syn_List_Search obj_Acq_Syn_List_Search
        {
            get { return (Acq_Syn_List_Search)Session["obj_Syn_List_Search"]; }
            set { Session["obj_Syn_List_Search"] = value; }
        }
        private List<USP_Get_Syn_Rights_Errors_Result> lstErrorRecords
        {
            get
            {
                if (Session["lstErrorRecords_SynList"] == null)
                    Session["lstErrorRecords_SynList"] = new List<USP_Get_Syn_Rights_Errors_Result>();
                return (List<USP_Get_Syn_Rights_Errors_Result>)Session["lstErrorRecords_SynList"];
            }
            set
            {
                Session["lstErrorRecords_SynList"] = value;
            }
        }
        private List<USP_Get_Syn_Rights_Errors_Result> lstErrorRecords_Titles
        {
            get
            {
                if (Session["lstErrorRecords_Titles_SynList"] == null)
                    Session["lstErrorRecords_Titles_SynList"] = new List<USP_Get_Syn_Rights_Errors_Result>();
                return (List<USP_Get_Syn_Rights_Errors_Result>)Session["lstErrorRecords_Titles_SynList"];
            }
            set
            {
                Session["lstErrorRecords_Titles_SynList"] = value;
            }
        }
        public Syn_Deal objSyn_Deal
        {
            get
            {
                if (Session[UtoSession.SESS_DEAL] == null)
                    Session[UtoSession.SESS_DEAL] = new Syn_Deal();
                return (Syn_Deal)Session[UtoSession.SESS_DEAL];
            }
            set { Session[UtoSession.SESS_DEAL] = value; }
        }
        public int RLCode
        {
            get
            {
                if (Session["RLCode"] == null)
                    Session["RLCode"] = 0;
                return (int)Session["RLCode"];
            }
            set { Session["RLCode"] = value; }
        }


        #endregion

        #region ---------------Index & Bind Method----------------------
        public ActionResult Index(string Message = "", string ReleaseRecord = "")
        {
            string strMessageAutoPush = "Deal Currently is in Amendment state in Viacom 18 Acquisition";
            ViewBag.ErrorMsg = strMessageAutoPush;
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForSynDeal);
            if (Session[RightsU_Entities.RightsU_Session.Syn_DEAL_SCHEMA] != null)
            {
                Deal_Schema objDS = ((Deal_Schema)Session[RightsU_Entities.RightsU_Session.Syn_DEAL_SCHEMA]);
                if (objDS != null && objDS.Mode == GlobalParams.DEAL_MODE_APPROVE)
                    DBUtil.Release_Record(objDS.Record_Locking_Code);
            }
            #region --- Clear Session ---
            Session[UtoSession.SESS_DEAL] = null;
            Session["ADS_Syn_General"] = null;
            Session[UtoSession.Syn_DEAL_SCHEMA] = null;
            Session["TS_Syn_General"] = null;
            #endregion
            TempData["TitleData"] = null;
            string IsMenu = "";
            Dictionary<string, string> obj_Dic_Layout = new Dictionary<string, string>();
            if (TempData["QS_LayOut"] != null)
            {
                obj_Dic_Layout = TempData["QS_LayOut"] as Dictionary<string, string>;
                IsMenu = obj_Dic_Layout["IsMenu"];
                TempData.Keep("QS_LayOut");
            }
            if (IsMenu == "Y")
            {
                if (Session["obj_Acq_List_Search"] != null)
                    Session["obj_Acq_List_Search"] = null;
                Reset_Srch_Criteria();
                ViewBag.IncludeArchiveDeal = obj_Acq_Syn_List_Search.strIncludeArchiveDeal;
            }
            else
            {
                if (obj_Acq_Syn_List_Search == null)
                    obj_Acq_Syn_List_Search = new Acq_Syn_List_Search();
                ViewBag.isAdvanced = obj_Acq_Syn_List_Search.isAdvanced;
                ViewBag.DealNo_Search = obj_Acq_Syn_List_Search.DealNo_Search;
                ViewBag.DealFrmDt_Search = obj_Acq_Syn_List_Search.DealFrmDt_Search;
                ViewBag.DealToDt_Search = obj_Acq_Syn_List_Search.DealToDt_Search;
                ViewBag.BUCode = obj_Acq_Syn_List_Search.BUCode;

                if (obj_Acq_Syn_List_Search.strIncludeArchiveDeal == "Y")
                    obj_Acq_Syn_List_Search.strIncludeArchiveDeal = "true";
                else
                    obj_Acq_Syn_List_Search.strIncludeArchiveDeal = "false";
                ViewBag.IncludeArchiveDeal = obj_Acq_Syn_List_Search.strIncludeArchiveDeal;

                ViewBag.Search = (obj_Acq_Syn_List_Search != null && obj_Acq_Syn_List_Search.Common_Search == null ? "" : obj_Acq_Syn_List_Search.Common_Search);
            }
            obj_Acq_Syn_List_Search.PageNo = 1;
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(GlobalParams.ModuleCodeForSynDeal, objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            bool srchaddRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForAdd) + "~");
            ViewBag.AddVisibility = srchaddRights;
            ViewBag.UserSecurityCode = objLoginUser.Security_Group_Code;
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            if (TempData[GlobalParams.Cancel_From_Deal] != null)
            {
                obj_Dic = TempData[GlobalParams.Cancel_From_Deal] as Dictionary<string, string>;
                obj_Acq_Syn_List_Search.PageNo = Convert.ToInt32(obj_Dic["Page_No"] != null ? obj_Dic["Page_No"].ToString() : "1");
            }
            //ViewBag.Workflow_List = BindWorkflowStatus();
            ViewBag.PageNo = obj_Acq_Syn_List_Search.PageNo - 1;
            ViewBag.ReleaseRecord = ReleaseRecord;
            ViewBag.BusineesUnitList = BindBUList();
            if (obj_Acq_Syn_List_Search.BUCode == null)
            {
                ViewBag.BUCode = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();
            }
            if (obj_Acq_Syn_List_Search.isAdvanced == "Y")
            {
                ViewBag.BUCode = obj_Acq_Syn_List_Search.BUCodes_Search;
            }
            return View("~/Views/Syn_List/Index.cshtml");
        }
        public IEnumerable<RightsU_Entities.USP_List_Syn_Result> BindGridView(string commonSearch = "", string isTAdvanced = "N", string strDealNo = "", string strfrom = "", string strto = "", string strSrchDealType = "", string strSrchDealTag = "", string strWorkflowStatus = "", string strTitles = "", string strDirector = "", string strLicensor = "", string strBU = "1", string strShowAll = "N", string strIncludeArchiveDeal = "", int Page = 0, string ClearSession = "N", string strBUCode = "1")
        {
            string sql = "";
            if (ClearSession == "Y")
                Reset_Srch_Criteria();
            if (!string.IsNullOrEmpty(isTAdvanced.Trim()))
                obj_Acq_Syn_List_Search.isAdvanced = isTAdvanced;
            if (strShowAll == "N")
            {
                if (obj_Acq_Syn_List_Search.isAdvanced == "Y")
                {
                    obj_Acq_Syn_List_Search.DealNo_Search = !string.IsNullOrEmpty(strDealNo) ? strDealNo.Trim() : "";
                    if (obj_Acq_Syn_List_Search.DealNo_Search != "") sql += " and agreement_no like '%" + obj_Acq_Syn_List_Search.DealNo_Search.Trim().Replace("'", "''") + "%'";
                    obj_Acq_Syn_List_Search.DealFrmDt_Search = !string.IsNullOrEmpty(strfrom) ? strfrom.Trim() : "";
                    obj_Acq_Syn_List_Search.DealToDt_Search = !string.IsNullOrEmpty(strto) ? strto.Trim() : "";

                    obj_Acq_Syn_List_Search.strIncludeArchiveDeal = strIncludeArchiveDeal;

                    if (obj_Acq_Syn_List_Search.DealFrmDt_Search != "" && obj_Acq_Syn_List_Search.DealToDt_Search != "")
                        sql += " AND CONVERT(DATETIME, Agreement_Date ) BETWEEN CONVERT(DATETIME,'" + obj_Acq_Syn_List_Search.DealFrmDt_Search + "',103) "
                            + "AND CONVERT(DATETIME,'" + obj_Acq_Syn_List_Search.DealToDt_Search + "',103)";
                    if (obj_Acq_Syn_List_Search.DealFrmDt_Search != "" && obj_Acq_Syn_List_Search.DealToDt_Search == "")
                        sql += " AND CONVERT(DATETIME, Agreement_Date ) >= CONVERT(DATETIME,'" + obj_Acq_Syn_List_Search.DealFrmDt_Search + "',103) ";

                    if (obj_Acq_Syn_List_Search.DealFrmDt_Search == "" && obj_Acq_Syn_List_Search.DealToDt_Search != "")
                        sql += " AND CONVERT(DATETIME, Agreement_Date ) <= CONVERT(datetime,'" + obj_Acq_Syn_List_Search.DealToDt_Search + "',103)";

                    obj_Acq_Syn_List_Search.TitleCodes_Search = !string.IsNullOrEmpty(strTitles) ? strTitles.Trim() : "";
                    if (obj_Acq_Syn_List_Search.TitleCodes_Search != "")
                        sql += " AND Syn_Deal_Code IN (SELECT Syn_Deal_Code FROM Syn_Deal_movie WHERE title_code IN(" + obj_Acq_Syn_List_Search.TitleCodes_Search + "))";

                    obj_Acq_Syn_List_Search.ProducerCodes_Search = !string.IsNullOrEmpty(strLicensor) ? strLicensor.Trim() : "";
                    if (obj_Acq_Syn_List_Search.ProducerCodes_Search != "") sql += " AND Vendor_Code IN(" + obj_Acq_Syn_List_Search.ProducerCodes_Search + ")";

                    obj_Acq_Syn_List_Search.DirectorCodes_Search = !string.IsNullOrEmpty(strDirector) ? strDirector.Trim() : "";
                    if (obj_Acq_Syn_List_Search.DirectorCodes_Search != "")
                        sql += " AND Syn_Deal_Code IN(SELECT Syn_Deal_Code FROM Syn_Deal_movie dm INNER JOIN title t on dm.title_code=t.title_code "
                            + "INNER JOIN Title_Talent tt on t.Title_Code = tt.Title_Code AND tt.Talent_Code in (" + obj_Acq_Syn_List_Search.DirectorCodes_Search + "))";

                    obj_Acq_Syn_List_Search.Status_Search = strSrchDealTag != "" ? strSrchDealTag : "0";
                    if (obj_Acq_Syn_List_Search.Status_Search != "0") sql += " AND Deal_Tag_code = '" + obj_Acq_Syn_List_Search.Status_Search + "'";

                    obj_Acq_Syn_List_Search.DealType_Search = strSrchDealType != "" ? strSrchDealType : "0";
                    if (obj_Acq_Syn_List_Search.DealType_Search != "0") sql += " AND deal_TYpe_Code = '" + obj_Acq_Syn_List_Search.DealType_Search + "'";

                    obj_Acq_Syn_List_Search.WorkFlowStatus_Search = strWorkflowStatus != "0" ? strWorkflowStatus : "0";
                    if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search != "0")
                    {
                        //if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search == "A") 
                        sql += " AND deal_workflow_status = '" + obj_Acq_Syn_List_Search.WorkFlowStatus_Search + "'";
                        //else if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search == "RO")
                        //    sql += " AND deal_workflow_status = 'RO'";

                        //else
                        //    if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search == "W")
                        //        sql += " AND deal_workflow_status = 'W'";
                        //    else
                        //        if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search == "R")
                        //            sql += " AND deal_workflow_status = 'R'";
                        //        else
                        //            sql += " AND Deal_Workflow_Status NOT IN ('A','W','R')";
                    }

                    obj_Acq_Syn_List_Search.BUCodes_Search = strBU != "" ? Convert.ToInt32(strBU) : 0;
                    if (obj_Acq_Syn_List_Search.BUCodes_Search > 0)
                        sql += " And Business_Unit_Code In (" + obj_Acq_Syn_List_Search.BUCodes_Search + ") ";// AND is_active='Y' ";

                    if (obj_Acq_Syn_List_Search.strIncludeArchiveDeal == "Y")
                        sql += " AND (is_active in ('Y') OR ( Deal_Workflow_Status = 'AR'))";
                    else
                        sql += " AND Deal_Workflow_Status <> 'AR' AND is_active='Y' ";
                }
                else
                {
                    obj_Acq_Syn_List_Search.Common_Search = !string.IsNullOrEmpty(commonSearch.Trim()) ? commonSearch.Trim().Replace("'", "''") : "";
                    obj_Acq_Syn_List_Search.BUCode = strBUCode;
                    sql += "AND Business_Unit_Code =" + obj_Acq_Syn_List_Search.BUCode;

                    if (strIncludeArchiveDeal == "Y")
                        sql += " AND (is_active in ('Y') OR ( Deal_Workflow_Status = 'AR'))";
                    else
                        sql += " AND Deal_Workflow_Status <> 'AR' AND is_active ='Y' ";

                    if (obj_Acq_Syn_List_Search.Common_Search != "")
                    {
                        string[] commonStr = obj_Acq_Syn_List_Search.Common_Search.Split(' ');
                        for (int i = 1; i <= commonStr.Length; i++)
                        {
                            if (commonStr[i - 1] != "")
                            {
                                if (i == 1)
                                {
                                    sql += " AND (agreement_no like '%" + commonStr[i - 1] + "%'"
                                         + " OR Entity_Code IN (SELECT Entity_Code FROM Entity WHERE Entity_Name LIKE N'%" + commonStr[i - 1] + "%')"
                                         + " OR Vendor_Code IN (SELECT Vendor_Code FROM Vendor WHERE Vendor_Name LIKE N'%" + commonStr[i - 1] + "%')"
                                         + " OR Syn_Deal_Code IN (SELECT Syn_Deal_Code FROM Syn_Deal_Movie WHERE Title_Code IN (SELECT Title_Code FROM Title WHERE Title_name  LIKE N'%" + commonStr[i - 1] + "%')))";
                                }
                                else
                                {
                                    if (strIncludeArchiveDeal == "Y")
                                        sql += " AND is_active in ('Y') OR ( Deal_Workflow_Status = 'AR')";
                                    else
                                        sql += " AND Deal_Workflow_Status <> 'AR' AND is_active ='Y' ";

                                    sql += " OR Business_Unit_Code =" + obj_Acq_Syn_List_Search.BUCode + " AND (agreement_no like '%" + commonStr[i - 1] + "%'"
                                          + " OR Entity_Code IN (SELECT Entity_Code FROM Entity WHERE Entity_Name LIKE N'%" + commonStr[i - 1] + "%')"
                                          + " OR Vendor_Code IN (SELECT Vendor_Code FROM Vendor WHERE Vendor_Name LIKE N'%" + commonStr[i - 1] + "%')"
                                          + " OR Syn_Deal_Code IN (SELECT Syn_Deal_Code FROM Syn_Deal_Movie WHERE Title_Code IN (SELECT Title_Code FROM Title WHERE Title_name  LIKE N'%" + commonStr[i - 1] + "%')))";
                                }

                            }
                        }
                        // sql += " AND (agreement_no like '%" + obj_Acq_Syn_List_Search.Common_Search + "%'"
                        //     + " OR Entity_Code IN (SELECT Entity_Code FROM Entity WHERE Entity_Name LIKE N'%" + obj_Acq_Syn_List_Search.Common_Search + "%')"
                        //     + " OR Vendor_Code IN (SELECT Vendor_Code FROM Vendor WHERE Vendor_Name LIKE N'%" + obj_Acq_Syn_List_Search.Common_Search + "%')"
                        //     + " OR Syn_Deal_Code IN (SELECT Syn_Deal_Code FROM Syn_Deal_Movie WHERE Title_Code IN (SELECT Title_Code FROM Title WHERE Title_name  LIKE N'%" + obj_Acq_Syn_List_Search.Common_Search + "%')))";

                        sql += " AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Users_Business_Unit WHERE Users_Code=" + objLoginUser.Users_Code + ") ";// AND is_active='Y' ";
                    }
                }
                //   Set_Srch_Criteria();
            }
            //else
            //    Reset_Srch_Criteria();
            obj_Acq_Syn_List_Search.PageNo = Page + 1;
            int pageSize = 10;
            int RecordCount = 0;
            string isPaging = "Y";
            string orderByCndition = "Last_Updated_Time DESC";
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            var objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Syn(sql, obj_Acq_Syn_List_Search.PageNo, orderByCndition, isPaging, pageSize, objRecordCount, objLoginUser.Users_Code, commonSearch).ToList();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = obj_Acq_Syn_List_Search.PageNo;
            return objList;
        }
        #endregion

        #region --------------- Termination-----------------------------
        [HttpPost]
        public PartialViewResult PartialDealList(int Page, string commonSearch, string isTAdvanced, string strDealNo = "", string strfrom = "", string strto = "", string strSrchDealType = "", string strSrchDealTag = "", string strWorkflowStatus = "", string strTitles = "", string strDirector = "", string strLicensor = "", string strBU = "", string strShowAll = "N", string strIncludeArchiveDeal = "", string ClearSession = "N", string strBUCode = "1")
        {
            string[] arrTitleName = strTitles.Split('﹐');
            string sstrTitles = string.Join(",", new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrTitleName.Contains(x.Title_Name)).Select(y => y.Title_Code).ToList());
            IEnumerable<RightsU_Entities.USP_List_Syn_Result> objList = BindGridView(commonSearch, isTAdvanced, strDealNo, strfrom, strto, strSrchDealType, strSrchDealTag, strWorkflowStatus, sstrTitles, strDirector, strLicensor, strBU, strShowAll, strIncludeArchiveDeal, Page, ClearSession, strBUCode);
            return PartialView("~/Views/Shared/_List_Syn_Deal.cshtml", objList);
        }
        public JsonResult ValidateTermination(int dealCode)
        {
            string status = "S", message = "";
            message = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Termination(dealCode, "S").First().ToString();
            if (!message.Trim().Equals("")) status = "E";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }
        public PartialViewResult OpenTerminationPopup(int dealCode, int dealTypeCode, string agreementNo)
        {
            ViewBag.Module_Type = "S";
            ViewBag.Deal_Code = dealCode;
            ViewBag.Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(dealTypeCode);
            ViewBag.Agreement_No = agreementNo;
            IEnumerable<USP_Get_Termination_Title_Data_Result> objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Termination_Title_Data(dealCode, "S").OrderBy(o => o.Title_Code);
            return PartialView("~/Views/Shared/_Termination.cshtml", objList);
        }
        public JsonResult SaveTermination(List<Termination_Deals_UDT> titleList)
        {
            string status = "S", message = "Deal terminated successfully";
            List<USP_Syn_Termination_UDT> updatedList = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Termination_UDT(titleList, objLoginUser.Users_Code).ToList();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }
        #endregion

        #region ---------------- MAINTAIN SEARCH CRITERIA --------------
        public JsonResult BindAdvanced_Search_Controls(bool Is_Bind_Control)
        {
            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();
            Set_Srch_Criteria();
            List<USP_Get_Acq_PreReq_Result> obj_USP_Get_PreReq_Result = new List<USP_Get_Acq_PreReq_Result>();
            obj_USP_Get_PreReq_Result = BindAllDropDowns();
            SelectList lstWorkFlowStatus = new SelectList(new Deal_Workflow_Status_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type == "S")
             .Select(i => new { Display_Value = i.Deal_WorkflowFlag, Display_Text = i.Deal_Workflow_Status_Name }).ToList(),
             "Display_Value", "Display_Text");
            // obj_Acq_Syn_List_Search.WorkFlowStatus_Search = obj_USP_Get_PreReq_Result.Where(i => i.Data_For == "WFL").Select(i => i.Display_Value ?? 0).FirstOrDefault().ToString();

            if (obj_Acq_Syn_List_Search.isAdvanced != "Y")
            {
                obj_Acq_Syn_List_Search.BUCodes_Search = obj_USP_Get_PreReq_Result.Where(i => i.Data_For == "BUT").Select(i => i.Display_Value ?? 0).FirstOrDefault();
                obj_Acq_Syn_List_Search.WorkFlowStatus_Search = "0";
            }
            string[] arrTitleName = obj_Acq_Syn_List_Search.TitleCodes_Search.Split(',');
            string strTitleNames = string.Join("﹐", new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrTitleName.Contains(x.Title_Code.ToString())).Select(y => y.Title_Name).ToList());
            obj_Dictionary.Add("USP_Result", obj_USP_Get_PreReq_Result);
            if (obj_Acq_Syn_List_Search != null)
                obj_Dictionary.Add("Obj_Acq_Syn_List_Search", obj_Acq_Syn_List_Search);
            obj_Dictionary.Add("strTitleNames", strTitleNames);
            obj_Dictionary.Add("lstWorkFlowStatus", lstWorkFlowStatus);
            return Json(obj_Dictionary);
        }
        private void Set_Srch_Criteria()
        {
            ViewBag.DealType_Search = obj_Acq_Syn_List_Search.DealType_Search;
            ViewBag.BUCodes_Search = obj_Acq_Syn_List_Search.BUCodes_Search;
            ViewBag.Status_Search = obj_Acq_Syn_List_Search.Status_Search;
            ViewBag.WorkFlowStatus_Search = obj_Acq_Syn_List_Search.WorkFlowStatus_Search;
            ViewBag.TitleCodes_Search = obj_Acq_Syn_List_Search.TitleCodes_Search;
            ViewBag.DirectorCodes_Search = obj_Acq_Syn_List_Search.DirectorCodes_Search;
            ViewBag.ProducerCodes_Search = obj_Acq_Syn_List_Search.ProducerCodes_Search;
            ViewBag.PageNo = obj_Acq_Syn_List_Search.PageNo;
            ViewBag.IncludeArchiveDeal = obj_Acq_Syn_List_Search.strIncludeArchiveDeal;
        }
        private void Reset_Srch_Criteria()
        {
            obj_Acq_Syn_List_Search = new Acq_Syn_List_Search();
            obj_Acq_Syn_List_Search.Common_Search = "";
            obj_Acq_Syn_List_Search.DealNo_Search = "";
            obj_Acq_Syn_List_Search.DealFrmDt_Search = "";
            obj_Acq_Syn_List_Search.DealToDt_Search = "";
            obj_Acq_Syn_List_Search.TitleCodes_Search = "";
            obj_Acq_Syn_List_Search.DirectorCodes_Search = "";
            obj_Acq_Syn_List_Search.ProducerCodes_Search = "";
            obj_Acq_Syn_List_Search.Status_Search = "0";
            obj_Acq_Syn_List_Search.WorkFlowStatus_Search = "";
            obj_Acq_Syn_List_Search.isAdvanced = "N";
            obj_Acq_Syn_List_Search.DealType_Search = "0";
            obj_Acq_Syn_List_Search.BUCodes_Search = 0;
            obj_Acq_Syn_List_Search.PageNo = 1;
            obj_Acq_Syn_List_Search.strIncludeArchiveDeal = "false";
        }
        #endregion

        #region --------------- BUTTON EVENTS --------------------------
        public JsonResult CheckRecordLock(int Syn_Deal_Code, string CommandName)
        {
            string strMessage = "", Mode = "", DealWorkflowStatus;
            string strMessageAutoPush = " Corresponding deal in Viacom18 Network is not in approved state";
            DealWorkflowStatus = new USP_Service(objLoginEntity.ConnectionStringName).USP_Check_Autopush_Ammend_Syn(Syn_Deal_Code).FirstOrDefault();
            ViewBag.ErrorMsg = strMessageAutoPush;
            int RL_Code = 0;
            bool isLocked = true;
            if (Syn_Deal_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Syn_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, out RL_Code, out strMessage, objLoginEntity.ConnectionStringName);
            }
            if (CommandName == "Amendment")
            {
                if (DealWorkflowStatus != "Y")
                {
                    Mode = GlobalParams.DEAL_MODE_EDIT;
                }
                else
                {
                    ViewBag.ErrorMsg = strMessageAutoPush;
                }
            }
            RLCode = RL_Code;
            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode,
                Syn_Deal_Code = Syn_Deal_Code,
                CommandName = CommandName,
                ErrorMessage = strMessageAutoPush,
                DealStatus = DealWorkflowStatus
            };
            return Json(obj);
        }
        public ActionResult ButtonEvents(string CommandName, int Syn_Deal_Code, int id = 0, int TitlePage_No = 0, string DealTypeCode = "0",
            string SearchedTitle = "", string key = "", int TitlePageSize = 10, int DealListPageNo = 0, int DealListPageSize = 10)
        {
            string strMessage, strViewBagMsg = "", Mode = "";
            Dictionary<string, string> obj = new Dictionary<string, string>();
            if (CommandName == "Add")
            {
                RLCode = 1;
                Mode = GlobalParams.DEAL_MODE_ADD;
            }
            else if (CommandName == "Edit")
            {
                Mode = GlobalParams.DEAL_MODE_EDIT;
            }
            else if (CommandName == "Reopen")
            {
                Mode = GlobalParams.DEAL_MODE_REOPEN;

                if (obj_Acq_Syn_List_Search == null)
                    obj_Acq_Syn_List_Search = new Acq_Syn_List_Search();
                obj_Acq_Syn_List_Search.PageNo = 1;
            }
            else if (CommandName == "View")
            {
                RLCode = 1;
                Mode = GlobalParams.DEAL_MODE_VIEW;
            }
            else if (CommandName == "Amendment")
            {
                Mode = GlobalParams.DEAL_MODE_EDIT;
            }
            else if (CommandName == "Clone")
            {
                RLCode = 1;
                Mode = GlobalParams.DEAL_MODE_CLONE;
            }
            else if (CommandName == "Archive")
            {
                Mode = GlobalParams.DEAL_MODE_ARCHIVE;
            }
            else if (CommandName == "SynAmendment")
            {
                Mode = GlobalParams.DEAL_MODE_EDIT;
            }
            else if (CommandName == "CloseMovie")
            {
                Mode = GlobalParams.DEAL_MOVIE_CLOSE;
            }
            if (RLCode > 0)
            {

                obj.Add("Mode", Mode);
                obj.Add("Syn_Deal_Code", Syn_Deal_Code.ToString());
                obj.Add("ModuleCode", GlobalParams.ModuleCodeForSynDeal.ToString());
                if (key != "fromTitle")
                {
                    if (obj_Acq_Syn_List_Search != null)
                        obj.Add("PageNo", obj_Acq_Syn_List_Search.PageNo.ToString());
                    else
                        obj.Add("PageNo", "1");
                }
                else
                    obj.Add("PageNo", "0");
                obj.Add("RLCode", RLCode.ToString());
                obj.Add("ClearSrchSession", "N");
                TempData["QueryString"] = obj;
                TempData["QS_LayOut"] = null;
                if (key == "fromTitle")
                {
                    Dictionary<string, string> objTitle = new Dictionary<string, string>();
                    objTitle.Add("TitlePage_No", Convert.ToString(TitlePage_No));
                    objTitle.Add("id", Convert.ToString(id));
                    objTitle.Add("DealTypeCode", DealTypeCode);
                    objTitle.Add("SearchedTitle", SearchedTitle);
                    objTitle.Add("key", key);
                    objTitle.Add("TitlePageSize", Convert.ToString(TitlePageSize));
                    objTitle.Add("DealListPageNo", Convert.ToString(DealListPageNo));
                    objTitle.Add("DealListPageSize", Convert.ToString(DealListPageSize));
                    TempData["TitleData"] = objTitle;
                }
                //return RedirectToAction("Index", "Syn_General");
                return RedirectToAction("Index", "Syn_Deal");
            }
            else
            {
                ViewBag.Message = strViewBagMsg;
                TempData["Message"] = strViewBagMsg;
                return RedirectToAction("Index");
            }
        }
        public JsonResult Rollback(int Syn_Deal_Code)
        {
            string strMessage, strViewBagMsg = "", strMsgType = "";
            int RLCode;
            bool isLocked = DBUtil.Lock_Record(Syn_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {

                string errorMessage = objUSP_Service.USP_Validate_Rollback(Syn_Deal_Code, "S").ElementAt(0).ToString();
                if (errorMessage.Trim().Equals(""))
                {
                    //ObjectResult<USP_RollBack_Syn_Deal_Result> objObjectResult = (new USP_Service(objLoginEntity.ConnectionStringName)).USP_RollBack_Syn_Deal(Syn_Deal_Code, objLoginUser.Users_Code);
                    //USP_RollBack_Syn_Deal_Result objUSP_RollBack_Syn_Deal_Result = objObjectResult.FirstOrDefault();
                    //if (objUSP_RollBack_Syn_Deal_Result != null)
                    //{
                    //    if (objUSP_RollBack_Syn_Deal_Result.Flag == "S")
                    //    {
                    strMsgType = "S";
                    strViewBagMsg = "Deal Rolled Back successfully";
                    //    }
                    //    else
                    //        strViewBagMsg = "ERROR : " + objUSP_RollBack_Syn_Deal_Result.Msg;
                    //}
                }
                DBUtil.Release_Record(RLCode);
            }
            else
                strViewBagMsg = strMessage;
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strViewBagMsg);
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }

        public JsonResult Approve(int Syn_Deal_Code, string IsZeroWorkFlow, string remarks_Approval = "")
        {
            string strRedirectTo = "Index", strViewBagMsg = "", strMessage, Result = "";
            string strMsgType = "";
            int RLCode;
            bool isLocked = DBUtil.Lock_Record(Syn_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {
                try
                {
                    int count = new USP_Service(objLoginEntity.ConnectionStringName).USP_Check_Acq_Deal_Status_For_Syn(Syn_Deal_Code).ElementAt(0).Value;

                    if (count > 0)
                        strViewBagMsg = objMessageKey.CannotApprovethisdealasthecorrespondingacquisitiondealisinanonapprovedstate;
                    else
                    {

                        string dealMemoNo = objSyn_Deal.Agreement_No;
                        string lblIsZeroWorkFlow = IsZeroWorkFlow;
                        int work_flow_code = Convert.ToInt32(objSyn_Deal.Work_Flow_Code);

                        if (IsZeroWorkFlow.Trim().Equals("Y") || lblIsZeroWorkFlow == "0")
                        {
                            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
                            string uspResult = Convert.ToString(objUSP.USP_Assign_Workflow(Syn_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, remarks_Approval).ElementAt(0));
                            string[] arrUspResult = uspResult.Split('~');

                            if (arrUspResult.Length > 1)
                                if (arrUspResult[1] == "N")
                                {
                                    strMsgType = "S";
                                    strViewBagMsg = objMessageKey.DealSuccessfullyApproved;
                                }
                        }
                        else
                            strRedirectTo = "View";
                    }
                }
                catch (Exception ex)
                {
                    strViewBagMsg = ex.Message.Replace("'", "");
                }
                DBUtil.Release_Record(RLCode);
            }
            else
            {
                strViewBagMsg = strMessage;
                Result = strViewBagMsg;
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strViewBagMsg);
            obj.Add("RedirectTo", strRedirectTo);
            obj.Add("Error", Result);
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }

        public JsonResult SendForAuthorisation(int Syn_Deal_Code, string remarks_Approval = "")
        {
            string strMessage, strViewBagMsg = "", strRedirectTo = "Index";
            string strMsgType = "";
            int RLCode = 0;
            bool isLocked = DBUtil.Lock_Record(Syn_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, out RLCode, out strMessage);
            List<USP_Validate_Rights_Duplication_UDT> lstRightsDup = new List<USP_Validate_Rights_Duplication_UDT>();
            if (isLocked)
            {
                try
                {
                    int count = new USP_Service(objLoginEntity.ConnectionStringName).USP_Check_Acq_Deal_Status_For_Syn(Syn_Deal_Code).ElementAt(0).Value;
                    if (count > 0)
                        strViewBagMsg = "This deal cannot be sent for approval as the corresponding acquisition deal is in a non-approved state.";
                    else
                    {
                        Syn_Deal objSyn_Deal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(Syn_Deal_Code);
                        objSyn_Deal.Syn_Deal_Rights.Where(r => r.Is_Verified == "N").ToList().ForEach(r =>
                        {
                            Syn_Deal_Rights objRights = AddRightUDT(r);
                            objRights.LstDeal_Rights_UDT.ForEach(rudt =>
                            { rudt.Check_For = ""; }
                           );
                            lstRightsDup.AddRange(new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Rights_Duplication_UDT(objRights.LstDeal_Rights_UDT, objRights.LstDeal_Rights_Title_UDT,
                                objRights.LstDeal_Rights_Platform_UDT, objRights.LstDeal_Rights_Territory_UDT, objRights.LstDeal_Rights_Subtitling_UDT,
                                objRights.LstDeal_Rights_Dubbing_UDT, "AR").ToList());
                        });
                        var q = from objRun in objSyn_Deal.Syn_Deal_Run
                                where objRun.Is_Yearwise_Definition.Trim().ToUpper().Equals("Y") && (objRun.No_Of_Runs != objRun.Syn_Deal_Run_Yearwise_Run.GroupBy(c => c.Syn_Deal_Run_Code).Select(c => c.Sum(cx => cx.No_Of_Runs)).FirstOrDefault())
                                select objRun;
                        if (q.Count() == 0)
                        {
                            string uspResult = "P";
                            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
                            uspResult = Convert.ToString(objUSP.USP_Assign_Workflow(Syn_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, remarks_Approval).ElementAt(0));
                            string[] arrUspResult = uspResult.Split('~');
                            if (Convert.ToInt32(arrUspResult[0]) > 1)
                            {
                                strMsgType = "S";
                                if (arrUspResult[1] == "N")
                                    strViewBagMsg = "Deal Sent for Approval Successfully";
                                else
                                    strViewBagMsg = "Deal Successfully Sent for Approval, but unable to send mail. Please check the error log.";
                            }
                        }
                        else
                        {
                            strRedirectTo = "";
                            strViewBagMsg = "Deal has invalid run definition, hence cannot send this deal for approval.";
                        }
                    }
                }
                catch (Exception ex)
                {
                    strViewBagMsg = ex.Message.Replace("'", "");
                }
                DBUtil.Release_Record(RLCode);
            }
            else
                strViewBagMsg = strMessage;
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strViewBagMsg);
            obj.Add("RedirectTo", strRedirectTo);
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }

        public JsonResult CheckRecordCurrentStatus(int Acq_Deal_Code, string Key = "", string CommandName = "")
        {
            string message = "";
            string isValid = "Y";
            int RLCode = 0;
            int count = 0;
            bool isLocked = false;
            string[] ErrorChk = { "W", "E", "P" };
            var objSynDeal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(S => S.Syn_Deal_Code == Acq_Deal_Code).FirstOrDefault();
            List<Syn_Deal_Rights> objSynDealRights = new List<Syn_Deal_Rights>();
            objSynDealRights = objSynDeal.Syn_Deal_Rights.ToList();
            bool ChkDealStatus = objSynDealRights.Any(w => ErrorChk.Contains(w.Right_Status));

            if (ChkDealStatus)
                isValid = "N";



            CommonUtil objCommonUtil = new CommonUtil();
            if (Key != "" && Acq_Deal_Code > 0)
            {
                isLocked = objCommonUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, out RLCode, out message, objLoginEntity.ConnectionStringName);

                if (!isLocked && Key == "AR")
                    goto Archive;
                else
                    goto End;


            }

            Archive:
            if (CommandName == "SendForArchive" || CommandName == "Archive")
            {
                count = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == Acq_Deal_Code && (s.Deal_Workflow_Status == "AR" || s.Deal_Workflow_Status == "WA")).Count();
                if (count > 0)
                    message = "The deal is already processed by another Archiver";
                else if (Acq_Deal_Code > 0)
                {
                    isLocked = objCommonUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RLCode, out message, objLoginEntity.ConnectionStringName);
                }
            }
            else
            {
                count = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == Acq_Deal_Code && (s.Deal_Workflow_Status == "A" || s.Deal_Workflow_Status == "W")).Count();
                if (count > 0)
                    message = objMessageKey.ThedealisalreadyprocessedbyanotherApprover;
                else if (Acq_Deal_Code > 0)
                    isLocked = objCommonUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, out RLCode, out message, objLoginEntity.ConnectionStringName);
            }

            End:
            //if (message == "" && Key == "AR")
            //{
            //    List<int?> lstTitle_Code = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName)
            //        .SearchFor(x => x.Syn_Deal_Code == Acq_Deal_Code).Select(x => x.Title_Code).ToList();

            //    int countContent_Music_Link = new Title_Content_Service(objLoginEntity.ConnectionStringName)
            //         .SearchFor(x => lstTitle_Code.Contains(x.Title_Code)).Where(x => x.Content_Music_Link.Count() > 0)
            //         .Select(x => x.Content_Music_Link).Count();

            //    if (countContent_Music_Link > 0)
            //    {
            //        message = "Music track is assign to it so deal cannot send for archive.";
            //        isLocked = false;
            //    }
            //}
            var obj = new
            {
                BindList = (count > 0) ? "Y" : "N",
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = message,
                Record_Locking_Code = RLCode,
                isValid = isValid
            };

            return Json(obj);
        }
        public JsonResult DeleteDeal(int Syn_Deal_Code)
        {
            string strMessage, strViewBagMsg = "";
            string strMsgType = "";
            int RLCode = 0;
            try
            {
                bool isLocked = DBUtil.Lock_Record(Syn_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, out RLCode, out strMessage);
                if (isLocked)
                {
                    ObjectResult<string> Obj_USP_DELETE_Deal = new USP_Service(objLoginEntity.ConnectionStringName).USP_DELETE_Syn_DEAL(Syn_Deal_Code, "N");
                    strViewBagMsg = objMessageKey.DealDeletedSuccessfully;
                    strMsgType = "S";
                    DBUtil.Release_Record(RLCode);
                }
                else
                    strViewBagMsg = strMessage;
            }
            catch (DuplicateRecordException ex)
            {
                strViewBagMsg = ex.Message;
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strViewBagMsg);
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }

        public JsonResult Reprocess(int Syn_Deal_Code)
        {
            new USP_Service(objLoginEntity.ConnectionStringName).USP_Reprocess_Rights(Syn_Deal_Code, "L");
            string strMsgType = "S";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", objMessageKey.DealReprocessedsuccessfully);
            obj.Add("RedirectTo", "Index");
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }

        private bool ShowErrorPopup(dynamic resultSet)
        {
            if (resultSet.Count > 0)
                return false;
            lstErrorRecords = resultSet;
            return true;
        }
        [HttpPost]
        public PartialViewResult PartialBindDealStatusPopup(int Syn_Deal_Code)
        {
            ObjectResult<USP_List_Syn_Deal_Status_Result> Obj_USP_List_Syn_Deal_Status_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Syn_Deal_Status(Syn_Deal_Code, "N");
            return PartialView("~/Views/Shared/_Syn_Deal_Status.cshtml", Obj_USP_List_Syn_Deal_Status_Result);
        }

        public PartialViewResult Show_Error_Popup(string searchForTitles, string PageSize, int PageNo, int SynDealCode, string ErrorMsg = "")
        {
            List<string> arrTitleNames = new List<string>();
            List<string> arrErrorNames = new List<string>();
            PageNo += 1;
            ViewBag.PageNo = PageNo;
            int Record_Count = 0;
            if (PageSize == "" || PageSize == "0" || PageSize == null)
                PageSize = "10";
            int partialPageSize = Convert.ToInt32(PageSize);
            lstErrorRecords = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Syn_Rights_Errors(SynDealCode, "L").ToList();
            if (searchForTitles != string.Empty) arrTitleNames = searchForTitles.Split(',').ToList();
            if (ErrorMsg != string.Empty) arrErrorNames = ErrorMsg.Split(',').ToList();
            if (ErrorMsg.TrimEnd() == string.Empty) ErrorMsg = lstErrorRecords[0].ErrorMsg.Trim();
            lstErrorRecords_Titles = lstErrorRecords.Where(w => (arrTitleNames.Contains(w.Title_Name) || arrTitleNames.Count <= 0) && w.ErrorMsg.Trim().Equals(ErrorMsg)).ToList();
            ViewBag.SearchTitles = new MultiSelectList(lstErrorRecords.Where(w => w.ErrorMsg.Trim().Equals(ErrorMsg)).ToList().Select(s => new { Title_Name = s.Title_Name }).Distinct(), "Title_Name", "Title_Name", arrTitleNames);
            Record_Count = lstErrorRecords_Titles.Count;
            ViewBag.RecordCount = Record_Count;
            ViewBag.PageSize = PageSize;
            ViewBag.ErrorRecord = new MultiSelectList(lstErrorRecords.Select(s => new { ErrorMsg = s.ErrorMsg.Trim() }).Distinct(), "ErrorMsg", "ErrorMsg", arrErrorNames);
            return PartialView("~/Views/Shared/_Syn_Error_Popup.cshtml", lstErrorRecords_Titles.Skip((PageNo - 1) * partialPageSize).Take(partialPageSize).ToList());
        }

        private Syn_Deal_Rights AddRightUDT(Syn_Deal_Rights objSynRights)
        {
            Deal_Rights_UDT objDRUDT = new Deal_Rights_UDT();
            objDRUDT.Title_Code = 0;
            objDRUDT.Platform_Code = 0;
            objDRUDT.Deal_Rights_Code = objSynRights.Syn_Deal_Rights_Code;
            objDRUDT.Deal_Code = objSynRights.Syn_Deal_Code;
            objDRUDT.Is_Exclusive = objSynRights.Is_Exclusive;
            objDRUDT.Is_Title_Language_Right = objSynRights.Is_Title_Language_Right;
            objDRUDT.Is_Sub_License = objSynRights.Is_Sub_License;
            objDRUDT.Sub_License_Code = objSynRights.Sub_License_Code;
            objDRUDT.Is_Theatrical_Right = objSynRights.Is_Theatrical_Right;
            objDRUDT.Right_Type = objSynRights.Right_Type;
            objDRUDT.Is_Tentative = objSynRights.Is_Tentative;
            objDRUDT.Check_For = "M";
            objDRUDT.Right_Start_Date = objSynRights.Actual_Right_Start_Date;
            objDRUDT.Right_End_Date = objSynRights.Actual_Right_End_Date;
            objDRUDT.Restriction_Remarks = objSynRights.Restriction_Remarks;
            if (objSynRights.Right_Type == "M")
            {
                objDRUDT.Milestone_Type_Code = objSynRights.Milestone_Type_Code;
                objDRUDT.Milestone_No_Of_Unit = objSynRights.Milestone_No_Of_Unit;
                objDRUDT.Milestone_Unit_Type = objSynRights.Milestone_Unit_Type;
            }
            if (objSynRights.Is_ROFR == "Y")
                objDRUDT.ROFR_Date = objSynRights.ROFR_Date;
            objSynRights.LstDeal_Rights_UDT = new List<Deal_Rights_UDT>();
            objSynRights.LstDeal_Rights_UDT.Add(objDRUDT);

            objSynRights.LstDeal_Rights_Title_UDT = new List<Deal_Rights_Title_UDT>(
                            objSynRights.Syn_Deal_Rights_Title.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Title_UDT
                            {
                                Deal_Rights_Code = (x.Syn_Deal_Rights_Code == null) ? 0 : x.Syn_Deal_Rights_Code,
                                Title_Code = (x.Title_Code == null) ? 0 : x.Title_Code,
                                Episode_From = x.Episode_From,
                                Episode_To = x.Episode_To
                            }));

            objSynRights.LstDeal_Rights_Platform_UDT = new List<Deal_Rights_Platform_UDT>(
                            objSynRights.Syn_Deal_Rights_Platform.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Platform_UDT
                            {
                                Deal_Rights_Code = (x.Syn_Deal_Rights_Code == null) ? 0 : x.Syn_Deal_Rights_Code,
                                Platform_Code = (x.Platform_Code == null) ? 0 : x.Platform_Code
                            }));

            objSynRights.LstDeal_Rights_Territory_UDT = new List<Deal_Rights_Territory_UDT>(
                            objSynRights.Syn_Deal_Rights_Territory.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Territory_UDT
                            {
                                Deal_Rights_Code = (x.Syn_Deal_Rights_Code == null) ? 0 : x.Syn_Deal_Rights_Code,
                                Territory_Code = (x.Territory_Code == null) ? 0 : x.Territory_Code,
                                Country_Code = (x.Country_Code == null) ? 0 : x.Country_Code,
                                Territory_Type = (x.Territory_Type == "") ? "" : x.Territory_Type,
                            }));

            objSynRights.LstDeal_Rights_Subtitling_UDT = new List<Deal_Rights_Subtitling_UDT>(
                            objSynRights.Syn_Deal_Rights_Subtitling.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Subtitling_UDT
                            {
                                Deal_Rights_Code = (x.Syn_Deal_Rights_Code == null) ? 0 : x.Syn_Deal_Rights_Code,
                                Subtitling_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                            }));

            objSynRights.LstDeal_Rights_Dubbing_UDT = new List<Deal_Rights_Dubbing_UDT>(
                            objSynRights.Syn_Deal_Rights_Dubbing.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Dubbing_UDT
                            {
                                Deal_Rights_Code = (x.Syn_Deal_Rights_Code == null) ? 0 : x.Syn_Deal_Rights_Code,
                                Dubbing_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                            }));

            return objSynRights;
        }

        private bool ValidateduplicateRights(List<Syn_Deal_Rights> lstSynDealRights, Syn_Deal_Rights objSyn_Deal_Rights, Nullable<DateTime> startDate, Nullable<DateTime> endDate, int Title_Code)
        {
            bool IsValidate = true;
            if (lstSynDealRights.Where(x => x.Syn_Deal_Rights_Code != objSyn_Deal_Rights.Syn_Deal_Rights_Code && ((startDate >= x.Actual_Right_Start_Date && startDate <= x.Actual_Right_End_Date) || (endDate >= x.Actual_Right_Start_Date && endDate <= x.Actual_Right_End_Date)) && x.Syn_Deal_Rights_Title.Any(t => t.Title_Code == Title_Code)).Count() > 0)
            {
                try
                {
                    string[] arrSelectedPlatformCode = objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Select(p => p.Platform_Code.ToString()).ToArray();
                    string[] arrSelectedCountryTerritoryCode = objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Select(t => t.Country_Code.ToString()).ToArray();
                    string[] arrSelectedSubTitling = objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Select(st => st.Language_Code.ToString()).ToArray();
                    string[] arrSelectedDubbingCodes = objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Select(d => d.Language_Code.ToString()).ToArray();
                    string IsBreak = "N";
                    foreach (Syn_Deal_Rights objRights in lstSynDealRights)
                    {
                        var arrWrapperPlatform = (from Syn_Deal_Rights_Platform objPlatform in objRights.Syn_Deal_Rights_Platform
                                                  where objPlatform.EntityState != State.Deleted
                                                  select objPlatform.Platform_Code.ToString()).ToArray();
                        var listCommon = arrWrapperPlatform.Where(arrSelectedPlatformCode.Contains);
                        if (listCommon.Count() > 0)
                        {
                            var arrWrapperCountryTerritory = (from Syn_Deal_Rights_Territory objTerritory in objRights.Syn_Deal_Rights_Territory where objTerritory.EntityState != State.Deleted select objTerritory.Country_Code.ToString()).ToArray();
                            var listCommonCountry = arrWrapperCountryTerritory.Where(arrSelectedCountryTerritoryCode.Contains);
                            if (listCommonCountry.Count() > 0)
                            {
                                if (objSyn_Deal_Rights.Is_Title_Language_Right == "Y" && objRights.Is_Title_Language_Right == "Y")
                                {
                                    IsBreak = "Y";
                                    break;
                                }

                                if (arrSelectedSubTitling.Length > 0)
                                {
                                    var arrWrapperSubtitlingCodes = (from Syn_Deal_Rights_Subtitling objSubTitling in objRights.Syn_Deal_Rights_Subtitling where objSubTitling.EntityState != State.Deleted select objSubTitling.Language_Code.ToString()).ToArray();
                                    var listCommonSubtitling = arrWrapperSubtitlingCodes.Where(arrSelectedSubTitling.Contains);

                                    if (listCommonSubtitling.Count() > 0)
                                    {
                                        IsBreak = "Y";
                                        break;
                                    }
                                }

                                if (arrSelectedDubbingCodes.Length > 0)
                                {
                                    var arrWrapperDubbingCodes = (from Syn_Deal_Rights_Dubbing objDubbing in objRights.Syn_Deal_Rights_Dubbing where objDubbing.EntityState != State.Deleted select objDubbing.Language_Code.ToString()).ToArray();
                                    var listCommonDubbing = arrWrapperDubbingCodes.Where(arrSelectedDubbingCodes.Contains);

                                    if (listCommonDubbing.Count() > 0)
                                    {
                                        IsBreak = "Y";
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    if (IsBreak == "Y")
                        IsValidate = false;
                }
                catch (Exception e)
                { }
            }
            return IsValidate;
        }
        #endregion

        #region ---------------BIND DROPDOWNS---------------------------
        private List<USP_Get_Acq_PreReq_Result> BindAllDropDowns()
        {
            List<USP_Get_Acq_PreReq_Result> obj_USP_Get_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Syn_PreReq("DTG,DTP,DTC,BUT,LAV,DIR,TIT", "LST", objLoginUser.Users_Code, 0, Convert.ToInt32(obj_Acq_Syn_List_Search.DealType_Search), obj_Acq_Syn_List_Search.BUCodes_Search).ToList();
            return obj_USP_Get_PreReq_Result;
        }
        public JsonResult OnChangeBindTitle(int? dealTypeCode, int? BUCode)
        {
            return Json(BindTitle(dealTypeCode, BUCode), JsonRequestBehavior.AllowGet);
        }
        private MultiSelectList BindTitle(int? Deal_Type_Code, int? BUCode)
        {
            MultiSelectList lstTitle = new MultiSelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(T => T.Is_Active == "Y" &&
                                                 T.Syn_Deal_Movie.Any(AM => AM.Syn_Deal.Business_Unit_Code == BUCode && AM.Title_Code == T.Title_Code)
                                                   && (T.Deal_Type_Code == Deal_Type_Code || Deal_Type_Code == 0)
                                                ).Select(R => new { Title_Name = R.Title_Name, Title_Code = R.Title_Code }),
                                                "Title_Code", "Title_Name", obj_Acq_Syn_List_Search.TitleCodes_Search.Split(','));
            return lstTitle;
        }
        public JsonResult Bind_Title(string Searched_Title = "", string dealTypeCode = "", string BUCode = "")
        {
            List<string> terms = Searched_Title.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            //string[] arrsearchString = searchString.ToUpper().Split(',');

            var result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Movie.Any(AM => AM.Syn_Deal.Business_Unit_Code.ToString() == BUCode && AM.Title_Code == x.Title_Code) && (x.Deal_Type_Code.ToString() == dealTypeCode || dealTypeCode == "0")).Where(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()))
               .Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList();
            return Json(result);
        }
        private SelectList BindWorkflowStatus()
        {
            return new SelectList(new Deal_Workflow_Status_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type == "S"), "Deal_WorkflowFlag", "Deal_Workflow_Status_Name");
        }
        private SelectList BindBUList()
        {

            return new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)), "Business_Unit_Code", "Business_Unit_Name", obj_Acq_Syn_List_Search.BUCode);
        }
        #endregion


        public JsonResult GetSynAsyncStatus(int dealCode)
        {
            var Rec = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_Syn_Status(dealCode, "S", objLoginUser.Users_Code).FirstOrDefault();

            if (Rec.Version_No != null)
            {
                if (Convert.ToInt32(Rec.Version_No) < 9)
                {
                    Rec.Version_No = "0" + Convert.ToInt32(Rec.Version_No);
                }
                else if (Convert.ToInt32(Rec.Version_No) < 99)
                {
                    Rec.Version_No = "0" + Convert.ToInt32(Rec.Version_No);
                }
            }

            var obj = new
            {
                RecordStatus = Rec.Record_Status,
                Button_Visibility = Rec.Button_Visibility == null ? "" : Rec.Button_Visibility,
                Version_No = Rec.Version_No == null ? "" : Rec.Version_No
            };
            return Json(obj);
        }

        public PartialViewResult ActionButtons(int tempCount, int dealCode, string Button_Visibility)
        {
            var Syn_Deal_obj = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == dealCode).FirstOrDefault();
            ViewBag.Deal_Workflow_Status = Syn_Deal_obj.Deal_Workflow_Status;
            ViewBag.Status = Syn_Deal_obj.Status;
            ViewBag.TempCount = tempCount;
            ViewBag.DealCode = dealCode;
            ViewBag.Button_Visibility = Button_Visibility;
            ViewBag.Deal_Type_Code = Syn_Deal_obj.Deal_Type_Code;
            ViewBag.Agreement_No = Syn_Deal_obj.Agreement_No;
            ViewBag.Type = "S";
            return PartialView("~/Views/Shared/_ActionButton.cshtml");
        }

        public JsonResult SessionTitleList(int SynDealCode)
        {
            Session["ListTitle"] = null;
            var lstADM = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            var lstTit = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            dynamic ListTitle = (from t1 in lstADM
                                 join t2 in lstTit on t1.Title_Code equals t2.Title_Code
                                 where t1.Syn_Deal_Code == SynDealCode
                                 select (t2.Title_Name == null) ? t2.Original_Title : t2.Title_Name).Distinct().ToList();

            Session["ListTitle"] = (List<string>)ListTitle;
            var obj = new
            {
                Status = "S",
            };
            return Json(obj);
        }

        public PartialViewResult BindAT(string searchText = "")
        {
            var ListTitle = (List<string>)Session["ListTitle"];
            if (searchText != "")
                ListTitle = ListTitle.Where(w => w.ToUpper().Contains(searchText.ToUpper())).ToList();

            ViewBag.ListTitle = ListTitle;

            return PartialView("~/Views/Shared/_List_More_Title.cshtml");
        }
        public JsonResult Archive(int Syn_Deal_Code, string IsZeroWorkFlow, string remarks_Approval = "")
        {
            string strViewBagMsg = "", strMsgType = "S";
            try
            {
                if (IsZeroWorkFlow.Trim().Equals("Y") || IsZeroWorkFlow == "0")
                {
                    string uspResult = Convert.ToString(new USP_Service(objLoginEntity.ConnectionStringName)
                   .USP_Assign_Workflow(Syn_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, "AR~" + remarks_Approval).ElementAt(0));

                    if (uspResult == "N")
                        strViewBagMsg = "Deal Archived Successfully";
                    else
                        strMsgType = "E";
                }
                else
                    strMsgType = "E";
            }
            catch (Exception ex)
            {
                strViewBagMsg = ex.Message.Replace("'", "");
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strViewBagMsg);
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }

        public JsonResult SendForArchive(int Syn_Deal_Code, string remarks_Approval = "")
        {
            string strViewBagMsg = "";
            string strMsgType = "S";
            try
            {
                string uspResult = Convert.ToString(new USP_Service(objLoginEntity.ConnectionStringName)
                    .USP_Assign_Workflow(Syn_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, "WA~" + remarks_Approval).ElementAt(0));

                if (uspResult == "N")
                {
                    //string uspResult = Convert.ToString(objUSP_Service.USP_Process_Workflow(objAcq_Deal.Syn_Deal_Code, 30, objLoginUser.Users_Code, user_Action, approvalremarks).ElementAt(0));
                    strViewBagMsg = "Deal Sent for Archive Successfully";
                }
                else
                    strMsgType = "E";
            }
            catch (Exception ex)
            {
                strMsgType = "E";
                strViewBagMsg = ex.Message;
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strViewBagMsg);
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }
        public JsonResult Chk_Archive_Validation(int Syn_Deal_Code)
        {
            string strMessage = "", strMsgType = "S";

            //int Cnt_SynMapping = new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Code == Syn_Deal_Code).Count();
            //if (Cnt_SynMapping > 0)
            //{
            //    strMessage = "This deal is Associated with Syndication deal hence cannot Archive.";
            //    strMsgType = "E";
            //}

            //Syn_Deal_Service objADService = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
            //Syn_Deal objAcq_Deal = objADService.GetById(Syn_Deal_Code);
            //var lstSubDeals = objADService.SearchFor(x => x.Agreement_No.Contains(objAcq_Deal.Agreement_No))
            //                                .Select(x => new { x.Syn_Deal_Code, x.Deal_Workflow_Status })
            //                                .ToList();

            //int TotalSubDeal = lstSubDeals.Count();
            //int TotalSubDeal_Approved = lstSubDeals.Where(x => x.Deal_Workflow_Status.TrimEnd() == "A").Count();
            //if (TotalSubDeal > 0)
            //{
            //    strMessage = " This deal include Sub-Deal which will also be Archived.";
            //    //strMsgType = "W";
            //    if (TotalSubDeal_Approved != TotalSubDeal)
            //    {
            //        strMessage += " Some of the Sub-Deal are not Approved Hence cannot Archive.";
            //        strMsgType = "E";
            //    }
            //}

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strMessage);
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }



    }
}
