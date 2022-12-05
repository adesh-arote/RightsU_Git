using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using System.Data.Entity.Core.Objects;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.Collections;
using System.IO;
using System.Web.UI;
using System.Text;
using System.Web.UI.WebControls;
using System.Data;
using System.Net;

namespace RightsU_Plus.Controllers
{
    public class Acq_ListController : BaseController
    {
        #region --------------- ATTRIBUTES AND PROPERTIES---------------
        public CommonUtil objCommonUtil = new CommonUtil();
        public Acq_Syn_List_Search obj_Acq_Syn_List_Search
        {
            get { return (Acq_Syn_List_Search)Session["obj_Acq_List_Search"]; }
            set { Session["obj_Acq_List_Search"] = value; }
        }
        private List<USP_Validate_Rights_Duplication_UDT> lstDupRecords
        {
            get
            {
                if (Session["lstDupRecords"] == null)
                    Session["lstDupRecords"] = new List<USP_Validate_Rights_Duplication_UDT>();
                return (List<USP_Validate_Rights_Duplication_UDT>)Session["lstDupRecords"];
            }
            set
            {
                Session["lstDupRecords"] = value;
            }
        }
        private List<Acq_Deal_Rights_Error_Details> lstErrorRecords
        {
            get
            {
                if (Session["lstErrorRecords_AcqList"] == null)
                    Session["lstErrorRecords_AcqList"] = new List<Acq_Deal_Rights_Error_Details>();
                return (List<Acq_Deal_Rights_Error_Details>)Session["lstErrorRecords_AcqList"];
            }
            set
            {
                Session["lstErrorRecords_AcqList"] = value;
            }
        }
        private List<Acq_Deal_Rights_Error_Details> lstErrorRecords_Titles
        {
            get
            {
                if (Session["lstErrorRecords_Titles_AcqList"] == null)
                    Session["lstErrorRecords_Titles_AcqList"] = new List<Acq_Deal_Rights_Error_Details>();
                return (List<Acq_Deal_Rights_Error_Details>)Session["lstErrorRecords_Titles_AcqList"];
            }
            set
            {
                Session["lstErrorRecords_Titles_AcqList"] = value;
            }
        }
        private List<USP_Get_Release_Content_List_Result> lstRelease_Content
        {
            get
            {
                if (Session["lstRelease_Content"] == null)
                    Session["lstRelease_Content"] = new List<USP_Get_Release_Content_List_Result>();
                return (List<USP_Get_Release_Content_List_Result>)Session["lstRelease_Content"];
            }
            set
            {
                Session["lstRelease_Content"] = value;
            }
        }

        private List<USP_Get_Release_Content_List_Result> lstRelease_Content_Searched
        {
            get
            {
                if (Session["lstRelease_Content_Searched"] == null)
                    Session["lstRelease_Content_Searched"] = new List<USP_Get_Release_Content_List_Result>();
                return (List<USP_Get_Release_Content_List_Result>)Session["lstRelease_Content_Searched"];
            }
            set
            {
                Session["lstRelease_Content_Searched"] = value;
            }
        }

        private List<USP_Validate_Rights_Duplication_UDT> lstDupRecords_Titles
        {
            get
            {
                if (Session["lstDupRecords_Titles"] == null)
                    Session["lstDupRecords_Titles"] = new List<USP_Validate_Rights_Duplication_UDT>();
                return (List<USP_Validate_Rights_Duplication_UDT>)Session["lstDupRecords_Titles"];
            }
            set
            {
                Session["lstDupRecords_Titles"] = value;
            }
        }
        private List<USP_Acq_Termination_UDT> lstTerminationError
        {
            get
            {
                if (Session["lstTerminationError"] == null)
                    Session["lstTerminationError"] = new List<USP_Acq_Termination_UDT>();
                return (List<USP_Acq_Termination_UDT>)Session["lstTerminationError"];
            }
            set
            {
                Session["lstTerminationError"] = value;
            }
        }
        public Acq_Deal objAcq_Deal
        {
            get
            {
                if (Session[UtoSession.SESS_DEAL] == null)
                    Session[UtoSession.SESS_DEAL] = new Acq_Deal();
                return (Acq_Deal)Session[UtoSession.SESS_DEAL];
            }
            set { Session[UtoSession.SESS_DEAL] = value; }
        }

        private Acq_Amendement_History_Service objAcq_Amendement_History_Service
        {
            get
            {
                if (Session["objAcq_Amendement_History_Service"] == null)
                    Session["objAcq_Amendement_History_Service"] = new Acq_Amendement_History_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Amendement_History_Service)Session["objAcq_Amendement_History_Service"];
            }
            set { Session["objTerritory_Service"] = value; }
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
        public bool isLocked
        {
            get;
            set;
        }
        string Err_filename = "WebPage_Log.txt";
        #endregion

        #region---------------Index & Bind-------------
        public ActionResult Index(string Message = "", string ReleaseRecord = "")
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            CommonUtil.WriteErrorLog("Index method of Acq_ListController is executing", Err_filename);
            if (Session[RightsU_Entities.RightsU_Session.ACQ_DEAL_SCHEMA] != null)
            {
                Deal_Schema objDS = ((Deal_Schema)Session[RightsU_Entities.RightsU_Session.ACQ_DEAL_SCHEMA]);
                if (objDS != null && objDS.Mode == GlobalParams.DEAL_MODE_APPROVE)
                    DBUtil.Release_Record(objDS.Record_Locking_Code);
            }
            #region --- Clear Session ---
            Session[UtoSession.SESS_DEAL] = null;
            Session["ADS_Acq_General"] = null;
            Session[UtoSession.ACQ_DEAL_SCHEMA] = null;
            Session["TS_Acq_General"] = null;
            TempData["TitleData"] = null;
            #endregion

            string IsMenu = "";
            Dictionary<string, string> obj_Dic_Layout = new Dictionary<string, string>();
            if (TempData["QS_LayOut"] != null)
            {
                CommonUtil.WriteErrorLog("Condition 1 executing", Err_filename);
                obj_Dic_Layout = TempData["QS_LayOut"] as Dictionary<string, string>;
                IsMenu = obj_Dic_Layout["IsMenu"];
                TempData.Keep("QS_LayOut");
                CommonUtil.WriteErrorLog("Condition 1 executed", Err_filename);
            }

            if (IsMenu == "Y")
            {
                CommonUtil.WriteErrorLog("Condition 2 executing", Err_filename);
                if (Session["obj_Syn_List_Search"] != null)
                    Session["obj_Syn_List_Search"] = null;
                Reset_Srch_Criteria();
                ViewBag.IncludeSubDeal = obj_Acq_Syn_List_Search.IncludeSubDeal;
                ViewBag.IncludeArchiveDeal = obj_Acq_Syn_List_Search.strIncludeArchiveDeal;
                CommonUtil.WriteErrorLog("Condition 2 executed", Err_filename);
            }
            else
            {
                CommonUtil.WriteErrorLog("Condition 3 executing", Err_filename);
                if (obj_Acq_Syn_List_Search == null)
                    obj_Acq_Syn_List_Search = new Acq_Syn_List_Search();
                ViewBag.isAdvanced = obj_Acq_Syn_List_Search.isAdvanced;
                ViewBag.DealNo_Search = obj_Acq_Syn_List_Search.DealNo_Search;
                ViewBag.DealFrmDt_Search = obj_Acq_Syn_List_Search.DealFrmDt_Search;
                ViewBag.DealToDt_Search = obj_Acq_Syn_List_Search.DealToDt_Search;
                ViewBag.Search = obj_Acq_Syn_List_Search.Common_Search;
                ViewBag.BUCode = obj_Acq_Syn_List_Search.BUCode;
                ViewBag.WorkFlowStatus = obj_Acq_Syn_List_Search.WorkFlowStatus_Search;
                if (obj_Acq_Syn_List_Search.IncludeSubDeal == "Y")
                    obj_Acq_Syn_List_Search.IncludeSubDeal = "true";
                else
                    obj_Acq_Syn_List_Search.IncludeSubDeal = "false";
                ViewBag.IncludeSubDeal = obj_Acq_Syn_List_Search.IncludeSubDeal;

                if (obj_Acq_Syn_List_Search.strIncludeArchiveDeal == "Y")
                    obj_Acq_Syn_List_Search.strIncludeArchiveDeal = "true";
                else
                    obj_Acq_Syn_List_Search.strIncludeArchiveDeal = "false";
                ViewBag.IncludeArchiveDeal = obj_Acq_Syn_List_Search.strIncludeArchiveDeal;

                CommonUtil.WriteErrorLog(" Condition 3 executed", Err_filename);
            }

            CommonUtil.WriteErrorLog("USP_MODULE_RIGHTS executing", Err_filename);
            List<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForAcqDeal), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            CommonUtil.WriteErrorLog("USP_MODULE_RIGHTS executed", Err_filename);
            bool srchaddRights = false;
            bool srchArchieveRights = false;
            if (addRights.FirstOrDefault() != null)
            {
                srchaddRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForAdd) + "~");
                srchArchieveRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForDealArchive) + "~");
            }
            ViewBag.AddVisibility = srchaddRights;
            ViewBag.ArchieveVisibility = (srchArchieveRights == true ? "block" : "none");
            ViewBag.UserSecurityCode = objLoginUser.Security_Group_Code;
            obj_Acq_Syn_List_Search.PageNo = 1;
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            if (TempData[GlobalParams.Cancel_From_Deal] != null)
            {
                obj_Dic = TempData[GlobalParams.Cancel_From_Deal] as Dictionary<string, string>;
                obj_Acq_Syn_List_Search.PageNo = Convert.ToInt32(obj_Dic["Page_No"] != null ? obj_Dic["Page_No"].ToString() : "1");
            }
            //ViewBag.Workflow_List = BindWorkflowStatus();
            ViewBag.PageNo = obj_Acq_Syn_List_Search.PageNo - 1;
            ViewBag.ReleaseRecord = ReleaseRecord;
            Session["FileName"] = "";
            Session["FileName"] = "Acq_General";
            CommonUtil.WriteErrorLog("BindBUList() method is executing", Err_filename);
            //string Is_AllowMultiBUacqdeal = DBUtil.GetSystemParameterValue("Is_AllowMultiBUacqdeal").ToUpper();
            string Is_AllowMultiBUacqdeal = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AllowMultiBUacqdeal").First().Parameter_Value;
            ViewBag.Is_AllowMultiBUacqdeal = Is_AllowMultiBUacqdeal;
            ViewBag.BusineesUnitList = BindBUList();
            CommonUtil.WriteErrorLog("BindBUList() method has been executed", Err_filename);
            if (obj_Acq_Syn_List_Search.BUCode == null)
            {
                CommonUtil.WriteErrorLog("Condition 4 executing", Err_filename);
                ViewBag.BUCode = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();
                CommonUtil.WriteErrorLog("Condition 4 executed", Err_filename);
            }
            if (obj_Acq_Syn_List_Search.isAdvanced == "Y")
            {
                if (Is_AllowMultiBUacqdeal == "Y")
                {
                    ViewBag.BUCode = obj_Acq_Syn_List_Search.BUCode;
                }
                else
                {
                    CommonUtil.WriteErrorLog("Condition 5 executing", Err_filename);
                    ViewBag.BUCode = obj_Acq_Syn_List_Search.BUCodes_Search;
                    CommonUtil.WriteErrorLog("Condition 5 executed", Err_filename);
                }

            }

            CommonUtil.WriteErrorLog("Index method of Acq_ListController has been executed", Err_filename);
            return View("~/Views/Acq_List/Index.cshtml");
        }
        [HttpPost]
        public PartialViewResult PartialDealList(int Page, string commonSearch, string isTAdvanced, string strDealNo = "", string strfrom = "", string strto = "", string strSrchDealType = "", string strSrchDealTag = "", string strWorkflowStatus = "", string strTitles = "", string strDirector = "", string strLicensor = "", string strBU = "", string strShowAll = "N", string strIncludeSubDeal = "", string strIncludeArchiveDeal = "", string ClearSession = "N", string strBUCode = "1", string strSrchEntity = "")
        {
            string[] arrTitleName = strTitles.Split('﹐');
            string sstrTitles = string.Join(",", new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrTitleName.Contains(x.Title_Name)).Select(y => y.Title_Code).ToList());
            CommonUtil.WriteErrorLog("BindGridView() method of Acq_ListController is executing", Err_filename);
            IEnumerable<RightsU_Entities.USP_List_Acq_Result> objList = BindGridView(commonSearch, isTAdvanced, strDealNo, strfrom, strto, strSrchDealType, strSrchDealTag, strWorkflowStatus, sstrTitles, strDirector, strLicensor, strBU, strShowAll, strIncludeSubDeal, strIncludeArchiveDeal, Page, ClearSession, strBUCode, strSrchEntity);
            CommonUtil.WriteErrorLog("BindGridView() method if Acq_ListController has been executed", Err_filename);
            ViewBag.Show_Amendment_Details = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Show_Amendment_Details").First().Parameter_Value;
            return PartialView("~/Views/Shared/_List_Deal.cshtml", objList);
        }


        public void ExportToWord()
        {
            FileInfo fliTemplate = new FileInfo(HttpContext.Server.MapPath("~/Download/ContactDraft.doc"));
            string fullPath = (Server.MapPath("~") + "\\" + "Download\\ContractDraft.docx");
            FileInfo flInfo = new FileInfo(fullPath);
            //FileInfo fliTemplate = new FileInfo(HttpContext.Server.MapPath("~/Download/ContractDraft.docx"));
            WebClient client = new WebClient();
            Byte[] buffer = client.DownloadData(fullPath);
            Response.Clear();
            Response.ContentType = "application/ms-word";
            Response.AddHeader("content-disposition", "Attachment;filename=" + flInfo.Name);
            Response.BinaryWrite(buffer);

            Response.End();
        }

        public IEnumerable<RightsU_Entities.USP_List_Acq_Result> BindGridView(string commonSearch = "", string isTAdvanced = "N", string strDealNo = "", string strfrom = "", string strto = "", string strSrchDealType = "", string strSrchDealTag = "", string strWorkflowStatus = "", string strTitles = "", string strDirector = "", string strLicensor = "", string strBU = "", string strShowAll = "N", string strIncludeSubDeal = "", string strIncludeArchiveDeal = "", int Page = 0, string ClearSession = "N", string strBUCode = "1", string strSrchEntity = "")
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
                    if (obj_Acq_Syn_List_Search.DealNo_Search != "")
                        sql += " and agreement_no like '%" + obj_Acq_Syn_List_Search.DealNo_Search.Trim().Replace("'", "''") + "%'";

                    obj_Acq_Syn_List_Search.DealFrmDt_Search = !string.IsNullOrEmpty(strfrom) ? strfrom.Trim() : "";
                    obj_Acq_Syn_List_Search.DealToDt_Search = !string.IsNullOrEmpty(strto) ? strto.Trim() : "";


                    obj_Acq_Syn_List_Search.IncludeSubDeal = strIncludeSubDeal;
                    obj_Acq_Syn_List_Search.strIncludeArchiveDeal = strIncludeArchiveDeal;

                    if (obj_Acq_Syn_List_Search.DealFrmDt_Search != "" && obj_Acq_Syn_List_Search.DealToDt_Search != "")
                        sql += " AND CONVERT(DATETIME, Agreement_Date ) BETWEEN CONVERT(DATETIME,'" + obj_Acq_Syn_List_Search.DealFrmDt_Search + "',103) "
                            + "AND CONVERT(DATETIME,'" + obj_Acq_Syn_List_Search.DealToDt_Search + "',103)";
                    if (obj_Acq_Syn_List_Search.DealFrmDt_Search != "" && obj_Acq_Syn_List_Search.DealToDt_Search == "")
                        sql += " AND CONVERT(DATETIME, Agreement_Date ) >= CONVERT(DATETIME,'" + obj_Acq_Syn_List_Search.DealFrmDt_Search + "',103) ";
                    if (obj_Acq_Syn_List_Search.DealFrmDt_Search == "" && obj_Acq_Syn_List_Search.DealToDt_Search != "")
                        sql += " AND CONVERT(DATETIME, Agreement_Date ) <= CONVERT(datetime,'" + obj_Acq_Syn_List_Search.DealToDt_Search + "',103)";

                    obj_Acq_Syn_List_Search.TitleCodes_Search = !string.IsNullOrEmpty(strTitles) ? strTitles.Trim() : "";


                    if (!string.IsNullOrEmpty(obj_Acq_Syn_List_Search.TitleCodes_Search))
                    {
                        if (obj_Acq_Syn_List_Search.IncludeSubDeal == "Y")
                        {
                            sql += " and acq_deal_Code in (select acq_deal_Code from acq_deal_movie where title_code in(" + obj_Acq_Syn_List_Search.TitleCodes_Search + ")"
                                + "OR Master_Deal_Movie_Code_ToLink in (select Acq_Deal_Movie_Code from acq_deal_movie where title_code in(" + obj_Acq_Syn_List_Search.TitleCodes_Search + ")))";
                        }
                        else
                            sql += " and acq_deal_Code in (select acq_deal_Code from acq_deal_movie where title_code in(" + obj_Acq_Syn_List_Search.TitleCodes_Search + "))";
                    }
                    else
                    {
                        if (obj_Acq_Syn_List_Search.IncludeSubDeal != "Y")
                            sql += " AND Is_Master_Deal ='Y'";
                    }

                    obj_Acq_Syn_List_Search.ProducerCodes_Search = !string.IsNullOrEmpty(strLicensor) ? strLicensor.Trim() : "";
                    if (obj_Acq_Syn_List_Search.ProducerCodes_Search != "")
                        sql += " AND Vendor_Code IN(" + obj_Acq_Syn_List_Search.ProducerCodes_Search + ")";

                    obj_Acq_Syn_List_Search.DirectorCodes_Search = !string.IsNullOrEmpty(strDirector) ? strDirector.Trim() : "";
                    if (obj_Acq_Syn_List_Search.DirectorCodes_Search != "")
                        sql += " and acq_deal_Code in (select acq_deal_Code from acq_deal_movie dm inner join title t on dm.title_code=t.title_code "
                            + "inner join Title_Talent tt on t.Title_Code = tt.Title_Code and tt.Talent_Code in (" + obj_Acq_Syn_List_Search.DirectorCodes_Search + "))";

                    obj_Acq_Syn_List_Search.Entity_Search = !string.IsNullOrEmpty(strSrchEntity) ? strSrchEntity.Trim() : "";
                    if (obj_Acq_Syn_List_Search.Entity_Search != "")
                        sql += " AND XYZ.Entity_Code IN(" + obj_Acq_Syn_List_Search.Entity_Search + ")";

                    obj_Acq_Syn_List_Search.Status_Search = strSrchDealTag != "" ? strSrchDealTag : "0";
                    if (obj_Acq_Syn_List_Search.Status_Search != "0")
                        sql += " AND Deal_Tag_code = '" + obj_Acq_Syn_List_Search.Status_Search + "'";
                    obj_Acq_Syn_List_Search.DealType_Search = strSrchDealType != "" ? strSrchDealType : "0";
                    if (obj_Acq_Syn_List_Search.DealType_Search != "0" && obj_Acq_Syn_List_Search.IncludeSubDeal == "Y")
                    {
                        string iS_Master_Deal = new Deal_Type_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(obj_Acq_Syn_List_Search.DealType_Search)).Is_Master_Deal;
                        string iS_Master_Deal_Filter = "";
                        if (iS_Master_Deal.Trim().ToUpper() == "N")
                        {
                            iS_Master_Deal_Filter = "";
                            sql += " AND (Deal_Type_Code = '" + obj_Acq_Syn_List_Search.DealType_Search + "' " + iS_Master_Deal_Filter + ")";
                        }
                        else if (string.IsNullOrEmpty(obj_Acq_Syn_List_Search.TitleCodes_Search) && iS_Master_Deal == "Y")
                        {

                            //sql += " AND (deal_Type_Code = '" + obj_Acq_Syn_List_Search.DealType_Search + "'"
                            //    + " OR ISNULL(Master_Deal_Movie_Code_ToLink,0) IN"
                            //    + "("
                            //        + "SELECT ADM.Acq_Deal_Movie_Code"
                            //        + " FROM Acq_Deal_Movie ADM"
                            //        + " WHERE ISNULL(Master_Deal_Movie_Code_ToLink,0) = ADM.Acq_Deal_Movie_Code "
                            //        + "))";

                            sql += " AND (deal_Type_Code = '" + obj_Acq_Syn_List_Search.DealType_Search + "'"
                            + " OR (ISNULL(Acq_Deal_Code,0) IN ( SELECT adT.Acq_Deal_Code FROM Acq_Deal adT WHERE adT.Master_Deal_Movie_Code_ToLink IN ( "
                            + " SELECT adm.Acq_Deal_Movie_Code FROM Acq_Deal_Movie adm WHERE adm.Acq_Deal_Code  = Acq_Deal_Code "
                            + " AND adm.Acq_Deal_Code IN (SELECT Acq_Deal_Code FROM Acq_Deal WHERE deal_Type_Code = '" + obj_Acq_Syn_List_Search.DealType_Search + "'))))) ";
                        }
                    }
                    else if (obj_Acq_Syn_List_Search.DealType_Search != "0")
                        sql += " AND deal_Type_Code = '" + obj_Acq_Syn_List_Search.DealType_Search + "'";


                    obj_Acq_Syn_List_Search.WorkFlowStatus_Search = strWorkflowStatus != "0" ? strWorkflowStatus : "0";
                    if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search != "0")
                    {
                        if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search == "A")
                            sql += " and deal_workflow_status = 'A'";
                        else if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search == "RO")
                            sql += " AND deal_workflow_status = 'RO'";
                        else
                            if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search == "W")
                            sql += " and deal_workflow_status = 'W'";
                        else
                            if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search == "R")
                            sql += " and deal_workflow_status = 'R'";
                        else
                            if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search == "EO")
                            sql += " and deal_workflow_status = 'EO'";
                        else
                            if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search == "WA")
                            sql += " and deal_workflow_status = 'WA'";
                        else
                            if (obj_Acq_Syn_List_Search.WorkFlowStatus_Search == "AR")
                            sql += " and deal_workflow_status = 'AR'";
                        else
                            sql += " and Deal_Workflow_Status not in ('A','W','R')";
                    }
                    //string Is_AllowMultiBUsyndeal = DBUtil.GetSystemParameterValue("Is_AllowMultiBUsyndeal").ToUpper();
                    string Is_AllowMultiBUsyndeal = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AllowMultiBUsyndeal").First().Parameter_Value;
                    if (Is_AllowMultiBUsyndeal != "Y")
                    {
                        obj_Acq_Syn_List_Search.BUCodes_Search = strBU != "" ? Convert.ToInt32(strBU) : 0;

                    }

                    //obj_Acq_Syn_List_Search.BUCodes_Search = strBU != "" ? Convert.ToInt32(strBU) : 0;
                    if (obj_Acq_Syn_List_Search.BUCodes_Search > 0 && Is_AllowMultiBUsyndeal != "Y")
                    {
                        sql += " And Business_Unit_Code In (" + obj_Acq_Syn_List_Search.BUCodes_Search + ") "; // AND is_active='Y'
                    }
                    else
                    {
                        sql += " And Business_Unit_Code In (" + strBU + ") "; // AND is_active='Y'
                    }

                    if (obj_Acq_Syn_List_Search.strIncludeArchiveDeal == "Y")
                        sql += " AND (is_active in ('Y') OR ( Deal_Workflow_Status = 'AR'))";
                    else
                        sql += " AND Deal_Workflow_Status <> 'AR' AND is_active='Y' ";
                }
                else
                {
                    obj_Acq_Syn_List_Search.Common_Search = !string.IsNullOrEmpty(commonSearch.Trim()) ? commonSearch.Trim().Replace("'", "''") : "";
                    obj_Acq_Syn_List_Search.BUCode = strBUCode;
                    sql += " AND Business_Unit_Code IN (" + obj_Acq_Syn_List_Search.BUCode + ")";

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
                                        + " or Entity_Code in (Select Entity_Code from Entity where Entity_Name like N'%" + commonStr[i - 1] + "%')"
                                        + " or Vendor_Code in (Select Vendor_Code from Vendor where Vendor_Name like N'%" + commonStr[i - 1] + "%')"
                                        + " or Acq_Deal_Code in (Select Acq_Deal_Code from Acq_Deal_Movie where Title_Code in (Select Title_Code from Title where Title_name  like N'%" + commonStr[i - 1] + "%')))";
                                }
                                else
                                {
                                    sql += " OR Business_Unit_Code IN (" + obj_Acq_Syn_List_Search.BUCode + ")";

                                    if (strIncludeArchiveDeal == "Y")
                                        sql += " AND is_active in ('Y') OR ( Deal_Workflow_Status = 'AR')";
                                    else
                                        sql += " AND Deal_Workflow_Status <> 'AR' AND is_active ='Y' ";

                                    sql += " AND (agreement_no like '%" + commonStr[i - 1] + "%'"
                                        + " or Entity_Code in (Select Entity_Code from Entity where Entity_Name like N'%" + commonStr[i - 1] + "%')"
                                        + " or Vendor_Code in (Select Vendor_Code from Vendor where Vendor_Name like N'%" + commonStr[i - 1] + "%')"
                                        + " or Acq_Deal_Code in (Select Acq_Deal_Code from Acq_Deal_Movie where Title_Code in (Select Title_Code from Title where Title_name  like N'%" + commonStr[i - 1] + "%')))";
                                }

                            }
                        }
                        //sql += " AND (agreement_no like '%" + obj_Acq_Syn_List_Search.Common_Search + "%'"
                        //    + " or Entity_Code in (Select Entity_Code from Entity where Entity_Name like N'%" + obj_Acq_Syn_List_Search.Common_Search + "%')"
                        //    + " or Vendor_Code in (Select Vendor_Code from Vendor where Vendor_Name like N'%" + obj_Acq_Syn_List_Search.Common_Search + "%')"
                        //    + " or Acq_Deal_Code in (Select Acq_Deal_Code from Acq_Deal_Movie where Title_Code in (Select Title_Code from Title where Title_name  like N'%" + obj_Acq_Syn_List_Search.Common_Search + "%')))";

                        sql += " And Business_Unit_Code In (select Business_Unit_Code from Users_Business_Unit where Users_Code=" + objLoginUser.Users_Code + ")";//AND is_active='Y';

                    }



                    //sql += " AND Deal_Workflow_Status <> 'AR'";
                }

                //   Set_Srch_Criteria();
            }
            obj_Acq_Syn_List_Search.PageNo = Page + 1;
            int pageSize = 10;
            int RecordCount = 0;
            string isPaging = "Y";
            string orderByCndition = "Acq_Deal_Code desc";
            CommonUtil.WriteErrorLog("USP_List_Acq is executing", Err_filename);
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            IEnumerable<RightsU_Entities.USP_List_Acq_Result> objList = new List<RightsU_Entities.USP_List_Acq_Result>();
            objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Acq(sql, obj_Acq_Syn_List_Search.PageNo, orderByCndition, isPaging, pageSize, objLoginUser.Users_Code, commonSearch, objRecordCount).ToList();

            CommonUtil.WriteErrorLog("USP_List_Acq has been executed", Err_filename);
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = obj_Acq_Syn_List_Search.PageNo;
            return objList;
        }
        #endregion

        #region--------------------Termination-----------------
        public JsonResult ValidateTermination(int dealCode)
        {
            string status = "S", message = "";
            message = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Termination(dealCode, "A").First().ToString();
            if (!message.Trim().Equals(""))
                status = "E";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }
        public PartialViewResult ShowTerminateError()
        {
            return PartialView("~/Views/Shared/_Acq_Termination_Validation.cshtml", lstTerminationError);
        }
        public PartialViewResult OpenTerminationPopup(int dealCode, int dealTypeCode, string agreementNo)
        {
            lstTerminationError = null;
            ViewBag.Module_Type = "A";
            ViewBag.Deal_Code = dealCode;
            ViewBag.Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(dealTypeCode);
            ViewBag.Agreement_No = agreementNo;
            IEnumerable<USP_Get_Termination_Title_Data_Result> objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Termination_Title_Data(dealCode, "A").OrderBy(o => o.Title_Code);
            return PartialView("~/Views/Shared/_Termination.cshtml", objList);
        }
        public JsonResult SaveTermination(List<Termination_Deals_UDT> titleList, string Syn_Error_Body = "", string Is_Validate_Error = "N")
        {
            lstTerminationError = null;
            string status = "S", message = "Deal terminated successfully";
            List<USP_Acq_Termination_UDT> updatedList = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Termination_UDT(titleList, objLoginUser.Users_Code, Syn_Error_Body, Is_Validate_Error).ToList();
            lstTerminationError = updatedList.Where(w => w.Is_Error == "Y").ToList();
            if (lstTerminationError.Count > 0)
            {
                status = "E";
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj);
        }

        #endregion

        #region -------------------- MAINTAIN SEARCH CRITERIA --------------------
        public JsonResult BindAdvanced_Search_Controls(bool Is_Bind_Control, string strTitles = "")
        {
            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();
            Set_Srch_Criteria();
            List<USP_Get_Acq_PreReq_Result> obj_USP_Get_PreReq_Result = new List<USP_Get_Acq_PreReq_Result>();
            //List<int> titleName = obj_Acq_Syn_List_Search.TitleCodes_Search.Split(',').Select(int.Parse).ToList();
            obj_USP_Get_PreReq_Result = BindAllDropDowns();
            if (obj_Acq_Syn_List_Search.isAdvanced != "Y")
            {
                obj_Acq_Syn_List_Search.BUCodes_Search = obj_USP_Get_PreReq_Result.Where(i => i.Data_For == "BUT").Select(i => i.Display_Value ?? 0).FirstOrDefault();

                obj_Acq_Syn_List_Search.WorkFlowStatus_Search = "0";
            }
            string[] arrTitleName = obj_Acq_Syn_List_Search.TitleCodes_Search.Split(',');
            string strTitleNames = string.Join("﹐", new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrTitleName.Contains(x.Title_Code.ToString())).Select(y => y.Title_Name).ToList());
            // obj_Acq_Syn_List_Search.WorkFlowStatus_Search = obj_USP_Get_PreReq_Result.Where(i => i.Data_For == "WFL").Select(i => i.Display_Value ?? 0).FirstOrDefault().ToString();

            var Acquisition_DealWorkFlow = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Select(x => x.Deal_Workflow_Status).Distinct().ToList();
            obj_Dictionary.Add("USP_Result", obj_USP_Get_PreReq_Result);
            SelectList lstWorkFlowStatus = new SelectList(new Deal_Workflow_Status_Service(objLoginEntity.ConnectionStringName)
                .SearchFor(x => x.Deal_Type == "A" && Acquisition_DealWorkFlow.Contains(x.Deal_WorkflowFlag) || (x.Deal_WorkflowFlag == "0" && x.Deal_Type == "A"))
              .Select(i => new { Display_Value = i.Deal_WorkflowFlag, Display_Text = i.Deal_Workflow_Status_Name }).ToList(),
              "Display_Value", "Display_Text");

            if (obj_Acq_Syn_List_Search != null)
            {
                obj_Dictionary.Add("strTitleNames", strTitleNames);
                obj_Dictionary.Add("Obj_Acq_Syn_List_Search", obj_Acq_Syn_List_Search);

            }
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
            ViewBag.IncludeSubDeal = obj_Acq_Syn_List_Search.IncludeSubDeal;
            ViewBag.IncludeArchiveDeal = obj_Acq_Syn_List_Search.strIncludeArchiveDeal;
            ViewBag.Entity_Search = obj_Acq_Syn_List_Search.Entity_Search;
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
            obj_Acq_Syn_List_Search.IncludeSubDeal = "false";
            obj_Acq_Syn_List_Search.strIncludeArchiveDeal = "false";
            obj_Acq_Syn_List_Search.Entity_Search = "";
        }

        #endregion

        #region --------------- BUTTON EVENTS ---------------
        public JsonResult CheckRecordLock(int Acq_Deal_Code, string CommandName)
        {
            string strMessage = "", Mode = "", DealWorkflowStatus;
            string strMessageAutoPush = " Corresponding deal in VMP is not in approved state";
            DealWorkflowStatus = new USP_Service(objLoginEntity.ConnectionStringName).USP_Check_Autopush_Ammend_Acq(Acq_Deal_Code).FirstOrDefault();
            ViewBag.ErrorMsg = strMessageAutoPush;
            int RL_Code = 0;
            isLocked = true;
            if (Acq_Deal_Code > 0)
            {
                // CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RL_Code, out strMessage, objLoginEntity.ConnectionStringName);
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
            //if (isLocked)
            //    objMusicDealSearch.RecordLockingCode = RLCode;
            RLCode = RL_Code;
            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode,
                Acq_Deal_Code = Acq_Deal_Code,
                CommandName = CommandName,
                ErrorMessage = strMessageAutoPush,
                DealStatus = DealWorkflowStatus
            };
            return Json(obj);
        }

        public ActionResult ButtonEvents(string CommandName, int Acq_Deal_Code, int id = 0, int TitlePage_No = 0, string DealTypeCode = "0",
            string SearchedTitle = "", string key = "", int TitlePageSize = 10, int DealListPageNo = 0, int DealListPageSize = 10)
        {
            CommonUtil.WriteErrorLog("Called ButtonEvents method of Acq_ListController for CommandName = '" + CommandName + "'", Err_filename);
            Session["EditWOA"] = "N";
            TempData["TitleData"] = null;
            TempData["prevAcqDeal"] = null;
            string strMessage, strViewBagMsg = "", Mode = "";
            // bool isLocked = true;
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
            else if (CommandName == "Content")
            {
                RLCode = 1;
                Mode = GlobalParams.DEAL_MODE_VIEW;
            }
            else if (CommandName == "Amendment")
            {
                Mode = GlobalParams.DEAL_MODE_EDIT;
            }
            else if (CommandName == "Archive")
            {
                Mode = GlobalParams.DEAL_MODE_ARCHIVE;
            }
            else if (CommandName == "Clone")
            {
                RLCode = 1;
                Mode = GlobalParams.DEAL_MODE_CLONE;
            }

            else if (CommandName == "Amendment_Syn")
            {
                Mode = GlobalParams.DEAL_MODE_EDIT;
            }
            else if (CommandName == "CloseMovie")
            {
                Mode = GlobalParams.DEAL_MOVIE_CLOSE;
            }
            else if (CommandName == "Music_Track" || CommandName == "Assign_Music")
            {
                Mode = GlobalParams.DEAL_MODE_EDIT;
            }
            else if (CommandName == "EditWOA")
            {
                Mode = GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL;
                Session["EditWOA"] = "Y";
            }
            else if (CommandName == "Amort")
            {
                Mode = GlobalParams.DEAL_MODE_VIEW;
                TempData["isAmort"] = "Y";
            }
            if (RLCode > 0)
            {
                //string Pushback_Text = DBUtil.GetSystemParameterValue("Pushback_Text").ToUpper();
                string Pushback_Text = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Pushback_Text").First().Parameter_Value;

                obj.Add("Mode", Mode);
                obj.Add("Acq_Deal_Code", Acq_Deal_Code.ToString());
                obj.Add("ModuleCode", GlobalParams.ModuleCodeForAcqDeal.ToString());
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
                obj.Add("Pushback_Text", Pushback_Text);

                if (CommandName == "View" && id > 0)
                    TempData["prevAcqDeal"] = Convert.ToString(id);

                TempData["QueryString"] = obj;
                TempData["QS_LayOut"] = null;
                if (CommandName == "Content")
                    return RedirectToAction("Index", "Acq_Content");
                if (CommandName == "Music_Track" || CommandName == "Assign_Music")
                    return RedirectToAction("Index", "Acq_Assign_Music");
                else
                {
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
                    //return RedirectToAction("Index", "Acq_General");
                    //return View("~/Views/Acq_Deal/Index.cshtml");
                    CommonUtil.WriteErrorLog("Calling Index method of Acq_DealController", Err_filename);
                    return RedirectToAction("Index", "Acq_Deal");
                }
            }
            else
            {
                ViewBag.Message = strViewBagMsg;
                TempData["Message"] = strViewBagMsg;
                return RedirectToAction("Index");
            }
        }

        public JsonResult Rollback(int Acq_Deal_Code)
        {
            string strMessage, strViewBagMsg = "", strMsgType = "";
            int RLCode;
            bool isLocked = DBUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RLCode, out strMessage);

            if (isLocked)
            {
                USP_Service objUSP_Service = new USP_Service(objLoginEntity.ConnectionStringName);
                string errorMessage = objUSP_Service.USP_Validate_Rollback(Acq_Deal_Code, "A").ElementAt(0).ToString();
                if (errorMessage.Trim().Equals(""))
                {
                    //ObjectResult<USP_RollBack_Acq_Deal_Result> objObjectResult = objUSP_Service.USP_RollBack_Acq_Deal(Acq_Deal_Code, objLoginUser.Users_Code);
                    //USP_RollBack_Acq_Deal_Result objUSP_RollBack_Acq_Deal_Result = objObjectResult.FirstOrDefault();
                    //if (objUSP_RollBack_Acq_Deal_Result != null)
                    //{
                    //    if (objUSP_RollBack_Acq_Deal_Result.Flag == "S")
                    //    {
                    strMsgType = "S";
                    strViewBagMsg = "Deal Rolled Back Successfully";
                    //    }
                    //    else
                    //        strViewBagMsg = "ERROR : " + objUSP_RollBack_Acq_Deal_Result.Msg;
                    //}
                }
                else
                {
                    strMsgType = "E";
                    strViewBagMsg = errorMessage;
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

        public JsonResult RollbackWOApp(int Acq_Deal_Code)
        {
            string strMessage, strViewBagMsg = "", strMsgType = "";
            int RLCode;
            bool isLocked = DBUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RLCode, out strMessage);

            if (isLocked)
            {
                objUSP_Service.USP_Edit_Without_Approval(Acq_Deal_Code, "ROL", objLoginUser.Users_Code, "");
                //ObjectResult<USP_RollBack_Acq_Deal_Result> objObjectResult = (new USP_Service()).USP_RollBack_Acq_Deal(Acq_Deal_Code, objLoginUser.Users_Code);
                //USP_RollBack_Acq_Deal_Result objUSP_RollBack_Acq_Deal_Result = objObjectResult.FirstOrDefault();
                //if (objUSP_RollBack_Acq_Deal_Result != null)
                //{
                //    if (objUSP_RollBack_Acq_Deal_Result.Flag == "S")
                //    {
                strMsgType = "S";
                strViewBagMsg = "Deal Rolled Back Successfully";
                //    }
                //    else
                //        strViewBagMsg = "ERROR : " + objUSP_RollBack_Acq_Deal_Result.Msg;
                //}
                DBUtil.Release_Record(RLCode);
            }
            else
                strViewBagMsg = strMessage;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strViewBagMsg);
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }
        public JsonResult Approve(int Acq_Deal_Code, string IsZeroWorkFlow, string remarks_Approval = "")
        {
            string strRedirectTo = "Index", strViewBagMsg = "";
            string strMessage;
            string Result = "";
            string strMsgType = "";
            int RLCode;
            bool isLocked = DBUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RLCode, out strMessage);

            if (isLocked)
            {
                try
                {
                    Acq_Deal objAcq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(Acq_Deal_Code);
                    List<USP_Validate_Rights_Duplication_UDT> lstRightsDup = new List<USP_Validate_Rights_Duplication_UDT>();
                    objAcq_Deal.Acq_Deal_Rights.Where(r => r.Is_Verified == "N").ToList().ForEach(r =>
                    {
                        Acq_Deal_Rights objRights = AddRightUDT(r);
                        objRights.LstDeal_Rights_UDT.ForEach(rudt =>
                        { rudt.Check_For = ""; }
                        );
                        lstRightsDup.AddRange(new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Rights_Duplication_UDT(objRights.LstDeal_Rights_UDT, objRights.LstDeal_Rights_Title_UDT,
                            objRights.LstDeal_Rights_Platform_UDT, objRights.LstDeal_Rights_Territory_UDT, objRights.LstDeal_Rights_Subtitling_UDT,
                            objRights.LstDeal_Rights_Dubbing_UDT, "AR").ToList());
                    });
                    if (ShowValidationPopup(lstRightsDup))
                    {
                        var q = from objRun in objAcq_Deal.Acq_Deal_Run
                                where (
                                (((objRun.No_Of_Runs != objRun.Acq_Deal_Run_Channel.GroupBy(c => c.Acq_Deal_Run_Code).Select(c => c.Sum(cx => cx.Min_Runs)).FirstOrDefault()) && objRun.Run_Definition_Type == "C")

                                || ((objRun.No_Of_Runs != objRun.Acq_Deal_Run_Channel.Count) && objRun.Run_Definition_Type == "A"))
                                && objRun.Is_Channel_Definition_Rights == "Y"
                                && objRun.Run_Type != "U"
                                )
                                select objRun;
                        if (q.Count() == 0)
                        {
                            string dealMemoNo = objAcq_Deal.Agreement_No;
                            int work_flow_code = Convert.ToInt32(objAcq_Deal.Work_Flow_Code);
                            string lblIsZeroWorkFlow = IsZeroWorkFlow;

                            if (IsZeroWorkFlow.Trim().Equals("Y") || lblIsZeroWorkFlow == "0")
                            {
                                string uspResult = Convert.ToString(new USP_Service(objLoginEntity.ConnectionStringName).USP_Assign_Workflow(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, remarks_Approval).ElementAt(0));
                                CommonUtil objCUT = new CommonUtil();
                                objCUT.Send_WBS_Data(GlobalParams.ModuleCodeForAcqDeal, objAcq_Deal.Acq_Deal_Code, objLoginUser.Users_Code, objLoginEntity.ConnectionStringName, "N");

                                string[] arrUspResult = uspResult.Split('~');

                                if (arrUspResult.Length > 1)
                                    if (arrUspResult[1] == "N")
                                    {
                                        strMsgType = "S";
                                        strViewBagMsg = "Deal Approved Successfully";
                                    }
                                    else if (arrUspResult[1] == "Y")
                                    {
                                        strMsgType = "E";
                                        Result = arrUspResult[0];
                                    }
                            }
                            else
                                strRedirectTo = "View";
                        }
                        else
                        {
                            strViewBagMsg = "Deal has invalid run definition, so cannot send this deal for approval .";
                            Result = strViewBagMsg;
                        }
                    }
                    else
                        strRedirectTo = "Partial";
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

        public JsonResult Archive(int Acq_Deal_Code, string IsZeroWorkFlow, string remarks_Approval = "")
        {
            string strViewBagMsg = "", strMsgType = "S";
            try
            {
                if (IsZeroWorkFlow.Trim().Equals("Y") || IsZeroWorkFlow == "0")
                {
                    string uspResult = Convert.ToString(new USP_Service(objLoginEntity.ConnectionStringName)
                   .USP_Assign_Workflow(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, "AR~" + remarks_Approval).ElementAt(0));

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

        public JsonResult Bind_Title(string Searched_Title = "", string dealTypeCode = "", string BUCode = "")
        {
            List<string> terms = Searched_Title.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            //string[] arrsearchString = searchString.ToUpper().Split(',');

            var result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Movie.Any(AM => BUCode.Contains(AM.Acq_Deal.Business_Unit_Code.ToString()) && AM.Title_Code == x.Title_Code) && (x.Deal_Type_Code.ToString() == dealTypeCode || dealTypeCode == "0")).Where(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()))
               .Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList();
            return Json(result);
        }
        public JsonResult SendForAuthorisation(int Acq_Deal_Code, string remarks_Approval = "")
        {
            string strMessage, strViewBagMsg = "";
            string strMsgType = "";
            int RLCode = 0;
            string strRedirectTo = "Index";
            bool isLocked = DBUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RLCode, out strMessage);
            List<USP_Validate_Rights_Duplication_UDT> lstRightsDup = new List<USP_Validate_Rights_Duplication_UDT>();
            if (isLocked)
            {
                try
                {
                    Acq_Deal objAcq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(Acq_Deal_Code);
                    objAcq_Deal.Acq_Deal_Rights.Where(r => r.Is_Verified == "N").ToList().ForEach(r =>
                    {

                        Acq_Deal_Rights objRights = AddRightUDT(r);
                        objRights.LstDeal_Rights_UDT.ForEach(rudt =>
                        { rudt.Check_For = ""; }
                       );
                        lstRightsDup.AddRange(new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Rights_Duplication_UDT(objRights.LstDeal_Rights_UDT, objRights.LstDeal_Rights_Title_UDT,
                            objRights.LstDeal_Rights_Platform_UDT, objRights.LstDeal_Rights_Territory_UDT, objRights.LstDeal_Rights_Subtitling_UDT,
                            objRights.LstDeal_Rights_Dubbing_UDT, "AR").ToList());
                    });
                    #region------------------------ Checking Liner Rights for run defination ------------------------

                    List<int?> lstTRightsTitleCodeLR = new List<int?>();
                    foreach (var item in objAcq_Deal.Acq_Deal_Rights)
                    {
                        if (item.Acq_Deal_Rights_Platform.Where(x => x.Platform.Base_Platform_Code == 35).Count() > 0)
                        {
                            lstTRightsTitleCodeLR.Add(item.Acq_Deal_Rights_Title.Select(x => Convert.ToInt32(x.Title_Code)).Distinct().FirstOrDefault());
                        }
                    }

                    List<int?> lstRunDefTitleCode = objAcq_Deal.Acq_Deal_Run.Select(x => x.Acq_Deal_Run_Title.Select(y => y.Title_Code).FirstOrDefault()).ToList();

                    int CountTitleCode = lstTRightsTitleCodeLR.Distinct().Except(lstRunDefTitleCode).Count();

                    string[] arrDCF = objAcq_Deal.Deal_Complete_Flag.Replace(" ", "").Split(',').ToArray();
                    if (!arrDCF.Contains("D"))
                        CountTitleCode = 0;

                    #endregion


                    if (ShowValidationPopup(lstRightsDup))
                    {
                        if (CountTitleCode == 0)
                        {
                            var q = from objRun in objAcq_Deal.Acq_Deal_Run
                                    where (
                                    (((objRun.No_Of_Runs != objRun.Acq_Deal_Run_Channel.GroupBy(c => c.Acq_Deal_Run_Code).Select(c => c.Sum(cx => cx.Min_Runs)).FirstOrDefault()) && objRun.Run_Definition_Type == "C")

                                    || ((objRun.No_Of_Runs != objRun.Acq_Deal_Run_Channel.Count) && objRun.Run_Definition_Type == "A"))
                                    && objRun.Is_Channel_Definition_Rights == "Y"
                                    && objRun.Run_Type != "U"
                                    )
                                    select objRun;

                            //checking run defination
                            if (q.Count() == 0)
                            {
                                string uspResult = "P";
                                uspResult = Convert.ToString(new USP_Service(objLoginEntity.ConnectionStringName).USP_Assign_Workflow(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, remarks_Approval).ElementAt(0));
                                string[] arrUspResult = uspResult.Split('~');
                                if (Convert.ToInt32(arrUspResult[0]) > 1)
                                {
                                    strMsgType = "S";
                                    if (arrUspResult[1] == "N")
                                        strViewBagMsg = "Deal Sent for Approval Successfully";
                                    else
                                        strViewBagMsg = "Deal Successfully Sent for Approval, but unable to send mail. Please check the error log..";
                                }
                            }
                            else
                            {
                                strRedirectTo = "";
                                strViewBagMsg = "Deal has invalid run definition ,so cannot send this deal for approval .";
                            }
                        }
                        else
                        {
                            strRedirectTo = "";
                            strViewBagMsg = "Deal with Linear Rights doest not contain Run Defination, so cannot send this deal for approval .";
                        }
                    }
                    else
                    {
                        strRedirectTo = "Partial";
                        strViewBagMsg = "Invalid deal duplicate rights found";
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

        public JsonResult SendForArchive(int Acq_Deal_Code, string remarks_Approval = "")
        {
            string strViewBagMsg = "";
            string strMsgType = "S";
            try
            {
                string uspResult = Convert.ToString(new USP_Service(objLoginEntity.ConnectionStringName)
                    .USP_Assign_Workflow(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, "WA~" + remarks_Approval).ElementAt(0));

                if (uspResult == "N")
                {
                    //string uspResult = Convert.ToString(objUSP_Service.USP_Process_Workflow(objAcq_Deal.Acq_Deal_Code, 30, objLoginUser.Users_Code, user_Action, approvalremarks).ElementAt(0));
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
        public JsonResult Chk_Archive_Validation(int Acq_Deal_Code)
        {
            string strMessage = "", strMsgType = "S";

            int Cnt_SynMapping = new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Code == Acq_Deal_Code).Count();
            if (Cnt_SynMapping > 0)
            {
                strMessage = "This deal is Associated with Syndication deal hence cannot Archive.";
                strMsgType = "E";
            }

            Acq_Deal_Service objADService = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal objAcq_Deal = objADService.GetById(Acq_Deal_Code);
            var lstSubDeals = objADService.SearchFor(x => x.Agreement_No.Contains(objAcq_Deal.Agreement_No) && x.Is_Master_Deal == "N")
                                            .Select(x => new { x.Acq_Deal_Code, x.Is_Master_Deal, x.Deal_Workflow_Status })
                                            .ToList();

            int TotalSubDeal = lstSubDeals.Count();
            int TotalSubDeal_Approved = lstSubDeals.Where(x => x.Deal_Workflow_Status.TrimEnd() == "A").Count();
            if (TotalSubDeal > 0)
            {
                strMessage = " This deal include Sub-Deal which will also be Archived.";
                //strMsgType = "W";
                if (TotalSubDeal_Approved != TotalSubDeal)
                {
                    strMessage += " Some of the Sub-Deal are not Approved Hence cannot Archive.";
                    strMsgType = "E";
                }
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", strMessage);
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }


        public JsonResult DeleteDeal(int Acq_Deal_Code)
        {
            string strMessage, strViewBagMsg = "";
            int RLCode = 0;
            string strMsgType = "";
            try
            {
                bool isLocked = DBUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RLCode, out strMessage);
                if (isLocked)
                {
                    ObjectResult<string> Obj_USP_DELETE_Deal = new USP_Service(objLoginEntity.ConnectionStringName).USP_DELETE_Deal(Acq_Deal_Code, "N");
                    strViewBagMsg = "Deal Deleted Successfully";
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

        private bool ShowValidationPopup(dynamic resultSet)
        {
            lstDupRecords = resultSet;
            if (lstDupRecords.Count > 0)
            {
                return false;
            }
            return true;
        }

        private bool CheckLinearRightsforTitle(dynamic resultSet)
        {


            lstDupRecords = resultSet;
            if (lstDupRecords.Count > 0)
            {
                return false;
            }
            return true;
        }

        public JsonResult CheckRecordCurrentStatus(int Acq_Deal_Code, string Key = "", string CommandName = "")
        {
            string message = "";
            int RLCode = 0;
            bool isLocked = false;
            int count = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            if (Key != "" && Acq_Deal_Code > 0)
            {
                isLocked = objCommonUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RLCode, out message, objLoginEntity.ConnectionStringName);

                if (!isLocked && Key == "AR")
                    goto Archive;
                else
                    goto End;
            }

        Archive:
            if (CommandName == "SendForArchive" || CommandName == "Archive")
            {
                count = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == Acq_Deal_Code && (s.Deal_Workflow_Status == "AR" || s.Deal_Workflow_Status == "WA")).Count();
                if (count > 0)
                    message = "The deal is already processed by another Archiver";
                else if (Acq_Deal_Code > 0)
                {
                    isLocked = objCommonUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RLCode, out message, objLoginEntity.ConnectionStringName);
                }
            }
            else
            {
                count = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == Acq_Deal_Code && (s.Deal_Workflow_Status == "A" || s.Deal_Workflow_Status == "W")).Count();
                if (count > 0)
                    message = "The deal is already processed by another Approver";
                else if (Acq_Deal_Code > 0)
                {
                    isLocked = objCommonUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RLCode, out message, objLoginEntity.ConnectionStringName);
                }
            }

        End:
            if (message == "" && Key == "AR")
            {
                List<int?> lstTitle_Code = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName)
                    .SearchFor(x => x.Acq_Deal_Code == Acq_Deal_Code).Select(x => x.Title_Code).ToList();

                int countContent_Music_Link = new Title_Content_Service(objLoginEntity.ConnectionStringName)
                     .SearchFor(x => lstTitle_Code.Contains(x.Title_Code)).Where(x => x.Content_Music_Link.Count() > 0)
                     .Select(x => x.Content_Music_Link).Count();

                if (countContent_Music_Link > 0)
                {
                    message = "Music track is assign to it so deal cannot send for archive.";
                    isLocked = false;
                }
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
        [HttpPost]
        public PartialViewResult PartialBindDealStatusPopup(int Acq_Deal_Code)
        {
            ObjectResult<USP_List_Acq_Deal_Status_Result> Obj_USP_List_Acq_Deal_Status_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Acq_Deal_Status(Acq_Deal_Code, "N");
            return PartialView("~/Views/Shared/_Deal_Status.cshtml", Obj_USP_List_Acq_Deal_Status_Result);
        }

        public PartialViewResult PartialBindLinearStatusPopup(int Acq_Deal_Code)
        {
            List<USP_List_Acq_Linear_Title_Status_Result> lst = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Acq_Linear_Title_Status(Acq_Deal_Code).ToList();
            // ObjectResult<USP_List_Acq_Deal_Status_Result> Obj_USP_List_Acq_Deal_Status_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Acq_Deal_Status(Acq_Deal_Code, "N");
            return PartialView("~/Views/Shared/_Linear_Status.cshtml", lst);
        }

        public PartialViewResult BindReleaseContentList(int pageNo, int recordPerPage)
        {
            List<RightsU_Entities.USP_Get_Release_Content_List_Result> lst = new List<RightsU_Entities.USP_Get_Release_Content_List_Result>();
            int RecordCount = 0;
            RecordCount = lstRelease_Content_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstRelease_Content_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            return PartialView("~/Views/Acq_List/_ReleaseContentList.cshtml", lst);
        }
        public void getReleaseContentList(int acqDealCode)
        {
            ViewBag.AcqDealCode = acqDealCode;
            lstRelease_Content = lstRelease_Content_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Release_Content_List(acqDealCode).ToList();

            //return PartialView("~/Views/Acq_List/_ReleaseContentList.cshtml", lstReleaseContent);
        }

        public JsonResult SearchReleaseContent(string searchText, int acqDealCode, string selectedTitleCodes)
        {
            string[] arrSelectedTitleCodes = selectedTitleCodes.Trim().Trim(',').Trim().Split(',');
            selectedTitleCodes = "";
            if (arrSelectedTitleCodes.Length > 0 && lstRelease_Content_Searched.Count > 0)
                if (arrSelectedTitleCodes[0] != "")
                    selectedTitleCodes = "," + string.Join(",", lstRelease_Content_Searched.Where(W =>
                        arrSelectedTitleCodes.Contains(W.Title_Code.ToString())).Select(s => s.Title_Code).ToArray()) + ",";

            getReleaseContentList(acqDealCode);
            if (!string.IsNullOrEmpty(searchText))
                lstRelease_Content_Searched = lstRelease_Content.Where(w => w.Title_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            else
            {
                selectedTitleCodes = "";
                lstRelease_Content_Searched = lstRelease_Content;
            }

            string allTitleCodes = "," + string.Join(",", lstRelease_Content_Searched.Select(s => s.Title_Code).ToArray()) + ",";

            var obj = new
            {
                Record_Count = lstRelease_Content_Searched.Count,
                AllTitleCodes = allTitleCodes,
                SelectedTitleCodes = selectedTitleCodes
            };
            return Json(obj);
        }


        public JsonResult SaveReleasedContent(int acqDealCode, string titleCodes)
        {
            string status = "S", message = "Data saved successfully";
            ObjectResult<string> objResult = new USP_Service(objLoginEntity.ConnectionStringName).USP_Generate_Title_Content(acqDealCode, titleCodes, objLoginUser.Users_Code);
            string errorMessage = objResult.FirstOrDefault();
            int releasedContentCount = 0;
            if (!string.IsNullOrEmpty(errorMessage))
            {
                status = "E";
                message = errorMessage;
            }
            else
            {
                int[] arrAcqDealMovieCode = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == acqDealCode).Select(s => s.Acq_Deal_Movie_Code).ToArray();
                releasedContentCount = new Title_Content_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(w => arrAcqDealMovieCode.Contains((int)w.Acq_Deal_Movie_Code)).Count();
            }

            var obj = new
            {
                Status = status,
                Message = message,
                Released_Content_Count = releasedContentCount
            };
            return Json(obj);
        }

        private Acq_Deal_Rights AddRightUDT(Acq_Deal_Rights objAcqRights)
        {
            Deal_Rights_UDT objDRUDT = new Deal_Rights_UDT();
            objDRUDT.Title_Code = 0;
            objDRUDT.Platform_Code = 0;
            objDRUDT.Deal_Rights_Code = objAcqRights.Acq_Deal_Rights_Code;
            objDRUDT.Deal_Code = objAcqRights.Acq_Deal_Code;
            objDRUDT.Is_Exclusive = objAcqRights.Is_Exclusive;
            objDRUDT.Is_Title_Language_Right = objAcqRights.Is_Title_Language_Right;
            objDRUDT.Is_Sub_License = objAcqRights.Is_Sub_License;
            objDRUDT.Sub_License_Code = objAcqRights.Sub_License_Code;
            objDRUDT.Is_Theatrical_Right = objAcqRights.Is_Theatrical_Right;
            objDRUDT.Right_Type = objAcqRights.Right_Type;
            objDRUDT.Is_Tentative = objAcqRights.Is_Tentative;
            objDRUDT.Check_For = "M";
            objDRUDT.Buyback_Syn_Rights_Code = objAcqRights.Buyback_Syn_Rights_Code;

            objDRUDT.Right_Start_Date = objAcqRights.Actual_Right_Start_Date;
            objDRUDT.Right_End_Date = objAcqRights.Actual_Right_End_Date;
            if (objAcqRights.Right_Type == "M")
            {
                objDRUDT.Milestone_Type_Code = objAcqRights.Milestone_Type_Code;
                objDRUDT.Milestone_No_Of_Unit = objAcqRights.Milestone_No_Of_Unit;
                objDRUDT.Milestone_Unit_Type = objAcqRights.Milestone_Unit_Type;
            }
            objDRUDT.Is_ROFR = objAcqRights.Is_ROFR;
            objDRUDT.ROFR_Date = null;
            if (objAcqRights.Is_ROFR == "Y")
                objDRUDT.ROFR_Date = objAcqRights.ROFR_Date;
            objDRUDT.Restriction_Remarks = objAcqRights.Restriction_Remarks;

            objAcqRights.LstDeal_Rights_UDT = new List<Deal_Rights_UDT>();
            objAcqRights.LstDeal_Rights_UDT.Add(objDRUDT);

            objAcqRights.LstDeal_Rights_Title_UDT = new List<Deal_Rights_Title_UDT>(
                            objAcqRights.Acq_Deal_Rights_Title.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Title_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                Title_Code = (x.Title_Code == null) ? 0 : x.Title_Code,
                                Episode_From = x.Episode_From,
                                Episode_To = x.Episode_To
                            }));

            objAcqRights.LstDeal_Rights_Platform_UDT = new List<Deal_Rights_Platform_UDT>(
                            objAcqRights.Acq_Deal_Rights_Platform.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Platform_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                Platform_Code = (x.Platform_Code == null) ? 0 : x.Platform_Code
                            }));

            objAcqRights.LstDeal_Rights_Territory_UDT = new List<Deal_Rights_Territory_UDT>(
                            objAcqRights.Acq_Deal_Rights_Territory.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Territory_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                Territory_Code = (x.Territory_Code == null) ? 0 : x.Territory_Code,
                                Country_Code = (x.Country_Code == null) ? 0 : x.Country_Code,
                                Territory_Type = (x.Territory_Type == "") ? "" : x.Territory_Type,
                            }));

            objAcqRights.LstDeal_Rights_Subtitling_UDT = new List<Deal_Rights_Subtitling_UDT>(
                            objAcqRights.Acq_Deal_Rights_Subtitling.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Subtitling_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                Subtitling_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                            }));

            objAcqRights.LstDeal_Rights_Dubbing_UDT = new List<Deal_Rights_Dubbing_UDT>(
                            objAcqRights.Acq_Deal_Rights_Dubbing.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Dubbing_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                Dubbing_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                            }));
            return objAcqRights;
        }

        #endregion

        #region ---------------BIND DROPDOWNS---------------
        private List<USP_Get_Acq_PreReq_Result> BindAllDropDowns()
        {
            List<USP_Get_Acq_PreReq_Result> obj_USP_Get_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("DTG,DTP,DTC,BUT,VEN,DIR,TIT,WFL,ENT", "LST", objLoginUser.Users_Code, 0, Convert.ToInt32(obj_Acq_Syn_List_Search.DealType_Search), obj_Acq_Syn_List_Search.BUCodes_Search).ToList();
            return obj_USP_Get_PreReq_Result;
        }
        public JsonResult OnChangeBindTitle(int? dealTypeCode, int? BUCode, string TitleSearch, params int?[] ddlBUMulti)
        {

            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            //string Is_AllowMultiBUacqdeal = DBUtil.GetSystemParameterValue("Is_AllowMultiBUacqdeal").ToUpper();
            string Is_AllowMultiBUacqdeal = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AllowMultiBUacqdeal").First().Parameter_Value;
            if (Is_AllowMultiBUacqdeal == "Y")
            {
                var arrTitleSearch = TitleSearch.Split('﹐').Where(x => x != "").ToList();

                if (ddlBUMulti != null)
                {


                    var result = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(
                      x => ddlBUMulti.Contains(x.Acq_Deal.Business_Unit_Code)
                           && (x.Title.Deal_Type_Code == dealTypeCode || dealTypeCode == 0)
                      ).Where(x => arrTitleSearch.Contains(x.Title.Title_Name))
                      .Select(x => new { Title_Name = x.Title.Title_Name, Title_Code = x.Title.Title_Code }).Distinct().ToList();

                    obj_Acq_Syn_List_Search.TitleCodes_Search = String.Join(",", result.Select(x => x.Title_Code).ToList());
                    obj_Acq_Syn_List_Search.BUCode = String.Join(",", ddlBUMulti.Select(x => x.ToString()).ToArray());
                    string comma = result.Count > 0 ? "﹐" : "";
                    var obj = new
                    {
                        Title_Name = String.Join("﹐", result.Select(x => x.Title_Name).ToList()) + comma,
                        Title_Code = String.Join(",", result.Select(x => x.Title_Code).ToList())
                    };

                    return Json(obj, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    var obj = new
                    {
                        Title_Name = "",
                        Title_Code = ""
                    };

                    return Json(obj, JsonRequestBehavior.AllowGet);
                }
            }
            else

                return Json(BindTitle(dealTypeCode, BUCode), JsonRequestBehavior.AllowGet);
        }
        private MultiSelectList BindTitle(int? Deal_Type_Code, int? BUCode)
        {
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            MultiSelectList lstTitle = new MultiSelectList(objTS.SearchFor(T => T.Is_Active == "Y" &&
                                                 T.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BUCode && AM.Title_Code == T.Title_Code)
                                                   && (T.Deal_Type_Code == Deal_Type_Code || Deal_Type_Code == 0)
        )
                                     .Select(R => new { Title_Name = R.Title_Name, Title_Code = R.Title_Code }), "Title_Code", "Title_Name", obj_Acq_Syn_List_Search.TitleCodes_Search.Split(','));
            return lstTitle;
        }
        private SelectList BindWorkflowStatus()
        {
            return new SelectList(new Deal_Workflow_Status_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type == "A" && x.Deal_WorkflowFlag != "AR"), "Deal_WorkflowFlag", "Deal_Workflow_Status_Name", ViewBag.WorkFlowStatus);
        }
        private MultiSelectList BindBUList()
        {
            //return new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type == "A" && x.Deal_WorkflowFlag != "AR"), "Deal_WorkflowFlag", "Deal_Workflow_Status_Name", ViewBag.WorkFlowStatus);

            return new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)), "Business_Unit_Code", "Business_Unit_Name", obj_Acq_Syn_List_Search.BUCode ?? "1");
        }
        #endregion

        #region ---------------SET MILESTONE---------------

        public JsonResult SaveMilestone(string MileStoneData)
        {
            string strRedirectTo = "Index";
            string strMessage = "";
            string strMsgType = "";
            int Acq_Deal_Code = Convert.ToInt32(Session["MS_Acq_Deal_Code"]);
            int RLCode = Convert.ToInt32(Session["RLCode"]);
            List<TempMilestone> TempMilestone = new List<TempMilestone>();
            List<Acq_Deal_Rights> lstAcqDealRights = new List<Acq_Deal_Rights>();
            GlobalUtil objGlobalUtil = new GlobalUtil();
            ArrayList arrMileStone = new ArrayList();
            string[] strSplit = MileStoneData.Split('~');

            for (int i = 0; i < strSplit.Count(); i++)
            {
                if (strSplit[i] != "")
                {
                    TempMilestone objT = new TempMilestone();
                    string[] strGetDetails = strSplit[i].Split('#');

                    objT.Title_Code = Convert.ToInt32(strGetDetails[0]);
                    objT.Rights_Code = Convert.ToInt32(strGetDetails[1]);
                    if (strGetDetails[2] != "")
                        objT.StartDate = Convert.ToDateTime(strGetDetails[2]);
                    else
                        objT.StartDate = null;
                    objT.Milestone_No_Of_Unit = Convert.ToInt32(strGetDetails[3]);
                    objT.Milestone_Unit_Type = Convert.ToInt32(strGetDetails[4]);
                    TempMilestone.Add(objT);
                }
            }

            Acq_Deal_Service objAcq_Deal_Service = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal objAcq_Deal = objAcq_Deal_Service.GetById(Acq_Deal_Code);
            objAcq_Deal.EntityState = State.Modified;

            #region-----------------SAVE MILESTONE-----------------------------------
            foreach (TempMilestone temp in TempMilestone)
            {
                Acq_Deal_Rights objAcq_Deal_Rights = objAcq_Deal.Acq_Deal_Rights.Where(x => x.Acq_Deal_Rights_Code == temp.Rights_Code).FirstOrDefault();
                int countSameDates = TempMilestone.Where(x => x.Rights_Code == temp.Rights_Code).Where(z => z.StartDate == temp.StartDate).Count();
                DateTime temp_MileStone_StartDate = Convert.ToDateTime(temp.StartDate);
                Nullable<DateTime> temp_MileStone_EndDate = new Nullable<DateTime>();

                if (temp.StartDate != null)
                    temp_MileStone_EndDate = SetMilestoneStartEndDates(temp.Milestone_Unit_Type, temp.Milestone_No_Of_Unit, temp_MileStone_StartDate);
                else
                    temp_MileStone_EndDate = null;

                if (objAcq_Deal_Rights.Is_ROFR == "Y" && temp_MileStone_EndDate != null)
                {
                    DateTime d1 = Convert.ToDateTime(objAcq_Deal_Rights.Actual_Right_End_Date);
                    DateTime d2 = Convert.ToDateTime(objAcq_Deal_Rights.ROFR_Date);
                    double ROFRDays = (d1 - d2).TotalDays;
                    objAcq_Deal_Rights.ROFR_Date = Convert.ToDateTime(temp_MileStone_EndDate).AddDays(-ROFRDays);
                }

                if (ValidateduplicateRights(lstAcqDealRights, objAcq_Deal_Rights, temp.StartDate, temp_MileStone_EndDate, temp.Title_Code))
                {
                    if (countSameDates > 1) // Means more than two movies has same start dates for one right
                    {
                        int countAllTitles = TempMilestone.Where(x => x.Rights_Code == temp.Rights_Code).Count();

                        if (countSameDates != countAllTitles) //Add new 
                        {
                            #region Condition for one right has more than one title with same date (Grouping)
                            int countAlreadyAdded = 0;
                            countAlreadyAdded = objAcq_Deal.Acq_Deal_Rights.Where(x => x.Actual_Right_Start_Date == temp.StartDate).Count();//.Where(y => y.EntityState == State.Added)

                            if (countAlreadyAdded == 0) // That means its not added before so add it with group of title codes
                            {
                                string titleCodes = string.Join(",", TempMilestone.Where(x => x.Rights_Code == temp.Rights_Code).Where(z => z.StartDate == temp.StartDate).Select(t => t.Title_Code.ToString()));
                                Acq_Deal_Rights objAcq_Deal_RightsNewRight = null;
                                string[] titles = titleCodes.Split(',');

                                foreach (var title in titles)
                                {
                                    if (title != "")
                                    {
                                        if (objAcq_Deal_RightsNewRight == null) //First time create new rights object
                                        {

                                            objAcq_Deal_RightsNewRight = new Acq_Deal_Rights();
                                            Acq_Deal_Rights_Title objAcq_Deal_Right_ExstTitle = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.EntityState != State.Deleted).SingleOrDefault(y => y.Acq_Deal_Rights_Code == temp.Rights_Code && y.Title_Code == temp.Title_Code);
                                            Acq_RightsController objRights = new Acq_RightsController();
                                            objAcq_Deal_RightsNewRight = objRights.SetNewAcqDealRight(objAcq_Deal_Rights, Convert.ToInt32(title), objAcq_Deal_Right_ExstTitle.Episode_From.Value, objAcq_Deal_Right_ExstTitle.Episode_To.Value, 0);

                                            objAcq_Deal_RightsNewRight.Actual_Right_Start_Date = temp.StartDate;
                                            objAcq_Deal_Rights.Actual_Right_End_Date = null;

                                            if (temp.StartDate != null)
                                                objAcq_Deal_RightsNewRight.Actual_Right_End_Date = SetMilestoneStartEndDates(temp.Milestone_Unit_Type, temp.Milestone_No_Of_Unit, temp_MileStone_StartDate);

                                            //Update year based on Milestone period
                                            if (objAcq_Deal.Acq_Deal_Rights.Where(r => r.Right_Type != "M" && r.Acq_Deal_Rights_Title.Any(t => t.Title_Code == temp.Title_Code)).Count() == 0)
                                            {
                                                var run = (from obj in objAcq_Deal.Acq_Deal_Run
                                                           where obj.Is_Yearwise_Definition == "Y" && obj.Acq_Deal_Run_Title.Any(t => t.Title_Code == temp.Title_Code)
                                                           select obj.Acq_Deal_Run_Yearwise_Run).FirstOrDefault();

                                                if (run != null)
                                                {
                                                    if (objAcq_Deal_RightsNewRight.Actual_Right_Start_Date != null && objAcq_Deal_RightsNewRight.Actual_Right_End_Date != null)
                                                    {
                                                        USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
                                                        List<USP_Generate_Deal_Type_Year_Result> objList = objUS.USP_Generate_Deal_Type_Year(objAcq_Deal.Year_Type, objAcq_Deal_RightsNewRight.Actual_Right_Start_Date, objAcq_Deal_RightsNewRight.Actual_Right_End_Date).ToList();
                                                        for (int i = 0; i < objAcq_Deal_Rights.Milestone_No_Of_Unit; i++)
                                                        {
                                                            Acq_Deal_Run_Yearwise_Run objYRun = run.ElementAt(i);
                                                            USP_Generate_Deal_Type_Year_Result objresult = objList.ElementAt(i);
                                                            objYRun.Start_Date = Convert.ToDateTime(objGlobalUtil.ConvertToDMY(objresult.start_date));
                                                            objYRun.End_Date = Convert.ToDateTime(objGlobalUtil.ConvertToDMY(objresult.end_date));
                                                            objYRun.Year_No = i + 1;
                                                        }
                                                    }
                                                    else
                                                    {
                                                        for (int i = 0; i < objAcq_Deal_Rights.Milestone_No_Of_Unit; i++)
                                                        {
                                                            Acq_Deal_Run_Yearwise_Run objYRun = run.ElementAt(i);
                                                            objYRun.Start_Date = null;
                                                            objYRun.End_Date = null;
                                                            objYRun.Year_No = i + 1;
                                                        }
                                                    }
                                                }
                                            }

                                            objAcq_Deal_RightsNewRight.Is_Tentative = "N";
                                            objAcq_Deal.Acq_Deal_Rights.Add(objAcq_Deal_RightsNewRight);
                                        }
                                        else // Add only titles to newly created object 
                                        {
                                            Acq_Deal_Rights_Title objAcq_Deal_Rights_Title_new = new Acq_Deal_Rights_Title();
                                            objAcq_Deal_Rights_Title_new.Title_Code = Convert.ToInt32(title);
                                            objAcq_Deal_Rights_Title_new.EntityState = State.Added;
                                            objAcq_Deal_RightsNewRight.Acq_Deal_Rights_Title.Add(objAcq_Deal_Rights_Title_new);
                                        }
                                        // To delete existing title for right 
                                        Acq_Deal_Rights_Title objAcq_Deal_Rights_Title_Delete = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.Title_Code == Convert.ToInt32(title)).FirstOrDefault();
                                        if (objAcq_Deal_Rights_Title_Delete != null)
                                        {
                                            objAcq_Deal_Rights.Acq_Deal_Rights_Title.Remove(objAcq_Deal_Rights_Title_Delete);
                                            objAcq_Deal_Rights_Title_Delete.EntityState = State.Deleted;
                                        }
                                        // To delete existing title for right Ends
                                    }
                                }
                            }
                            else //Its added and update it
                            {
                                //DateTime Temp_StartDate = Convert.ToDateTime(temp.StartDate);
                                objAcq_Deal_Rights.Actual_Right_Start_Date = temp.StartDate;
                                objAcq_Deal_Rights.Actual_Right_End_Date = null;

                                if (temp.StartDate != null)
                                    objAcq_Deal_Rights.Actual_Right_End_Date = SetMilestoneStartEndDates(temp.Milestone_Unit_Type, temp.Milestone_No_Of_Unit, temp_MileStone_StartDate);

                                if (objAcq_Deal.Acq_Deal_Rights.Where(r => r.Right_Type != "M" && r.Acq_Deal_Rights_Title.Any(t => t.Title_Code == temp.Title_Code)).Count() == 0)
                                {
                                    var run = (from obj in objAcq_Deal.Acq_Deal_Run
                                               where obj.Is_Yearwise_Definition == "Y" && obj.Acq_Deal_Run_Title.Any(t => t.Title_Code == temp.Title_Code)
                                               select obj.Acq_Deal_Run_Yearwise_Run).FirstOrDefault();

                                    if (run != null)
                                    {
                                        if (objAcq_Deal_Rights.Actual_Right_Start_Date != null && objAcq_Deal_Rights.Actual_Right_End_Date != null)
                                        {
                                            USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
                                            List<USP_Generate_Deal_Type_Year_Result> objList = objUS.USP_Generate_Deal_Type_Year(objAcq_Deal.Year_Type, objAcq_Deal_Rights.Actual_Right_Start_Date, objAcq_Deal_Rights.Actual_Right_End_Date).ToList();

                                            for (int i = 0; i < objAcq_Deal_Rights.Milestone_No_Of_Unit; i++)
                                            {
                                                Acq_Deal_Run_Yearwise_Run objYRun = run.ElementAt(i);
                                                USP_Generate_Deal_Type_Year_Result objresult = objList.ElementAt(i);
                                                objYRun.Start_Date = Convert.ToDateTime(objGlobalUtil.ConvertToDMY(objresult.start_date));
                                                objYRun.End_Date = Convert.ToDateTime(objGlobalUtil.ConvertToDMY(objresult.end_date));
                                                objYRun.Year_No = i + 1;
                                            }
                                        }
                                        else
                                        {
                                            for (int i = 0; i < objAcq_Deal_Rights.Milestone_No_Of_Unit; i++)
                                            {
                                                Acq_Deal_Run_Yearwise_Run objYRun = run.ElementAt(i);
                                                objYRun.Start_Date = null;
                                                objYRun.End_Date = null;
                                                objYRun.Year_No = i + 1;
                                            }
                                        }
                                    }
                                }

                                objAcq_Deal_Rights.Is_Tentative = "N";
                                objAcq_Deal_Rights.Last_Updated_Time = DateTime.Now;
                                objAcq_Deal_Rights.Last_Action_By = objLoginUser.Users_Code;
                                objAcq_Deal_Rights.EntityState = State.Modified;
                            }

                            //Check if its a last Title for that right
                            int CountToUpdate = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.EntityState != State.Deleted).Count();

                            if (CountToUpdate == 1)
                            {
                                Acq_Deal_Rights_Title objAcq_Deal_Rights_Title_Update = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.EntityState != State.Deleted).FirstOrDefault();
                                if (objAcq_Deal_Rights_Title_Update != null)
                                {
                                    TempMilestone objTempMilestone = TempMilestone.Where(x => x.Rights_Code == objAcq_Deal_Rights.Acq_Deal_Rights_Code).Where(y => y.Title_Code == objAcq_Deal_Rights_Title_Update.Title_Code).FirstOrDefault();

                                    if (objTempMilestone != null)
                                    {
                                        objAcq_Deal_Rights.Actual_Right_Start_Date = objTempMilestone.StartDate;
                                        objAcq_Deal_Rights.Actual_Right_End_Date = null;

                                        if (temp.StartDate != null)
                                            objAcq_Deal_Rights.Actual_Right_End_Date = SetMilestoneStartEndDates(objTempMilestone.Milestone_Unit_Type, objTempMilestone.Milestone_No_Of_Unit, temp_MileStone_StartDate);

                                        if (objAcq_Deal.Acq_Deal_Rights.Where(r => r.Right_Type != "M" && r.Acq_Deal_Rights_Title.Any(t => t.Title_Code == temp.Title_Code)).Count() == 0)
                                        {
                                            var run = (from obj in objAcq_Deal.Acq_Deal_Run
                                                       where obj.Is_Yearwise_Definition == "Y" && obj.Acq_Deal_Run_Title.Any(t => t.Title_Code == temp.Title_Code)
                                                       select obj.Acq_Deal_Run_Yearwise_Run).FirstOrDefault();

                                            if (run != null)
                                            {
                                                if (objAcq_Deal_Rights.Actual_Right_Start_Date != null && objAcq_Deal_Rights.Actual_Right_End_Date != null)
                                                {
                                                    USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
                                                    List<USP_Generate_Deal_Type_Year_Result> objList = objUS.USP_Generate_Deal_Type_Year(objAcq_Deal.Year_Type, objAcq_Deal_Rights.Actual_Right_Start_Date, objAcq_Deal_Rights.Actual_Right_End_Date).ToList();
                                                    for (int i = 0; i < objAcq_Deal_Rights.Milestone_No_Of_Unit; i++)
                                                    {
                                                        Acq_Deal_Run_Yearwise_Run objYRun = run.ElementAt(i);
                                                        USP_Generate_Deal_Type_Year_Result objresult = objList.ElementAt(i);
                                                        objYRun.Start_Date = Convert.ToDateTime(objGlobalUtil.ConvertToDMY(objresult.start_date));
                                                        objYRun.End_Date = Convert.ToDateTime(objGlobalUtil.ConvertToDMY(objresult.end_date));
                                                        objYRun.Year_No = i + 1;
                                                    }
                                                }
                                                else
                                                {
                                                    for (int i = 0; i < objAcq_Deal_Rights.Milestone_No_Of_Unit; i++)
                                                    {
                                                        Acq_Deal_Run_Yearwise_Run objYRun = run.ElementAt(i);
                                                        objYRun.Start_Date = null;
                                                        objYRun.End_Date = null;
                                                        objYRun.Year_No = i + 1;
                                                    }
                                                }
                                            }
                                        }

                                        objAcq_Deal_Rights.Is_Tentative = "N";
                                        objAcq_Deal_Rights.Last_Updated_Time = DateTime.Now;
                                        objAcq_Deal_Rights.Last_Action_By = objLoginUser.Users_Code;
                                        objAcq_Deal_Rights.EntityState = State.Modified;
                                    }
                                }
                            }
                            //Check if its a last Title for that right
                            #endregion
                        }
                        else // only Update
                        {
                            objAcq_Deal_Rights.Actual_Right_Start_Date = temp.StartDate;
                            objAcq_Deal_Rights.Actual_Right_End_Date = null;

                            if (temp.StartDate != null)
                                objAcq_Deal_Rights.Actual_Right_End_Date = SetMilestoneStartEndDates(temp.Milestone_Unit_Type, temp.Milestone_No_Of_Unit, temp_MileStone_StartDate);

                            objAcq_Deal_Rights.Is_Tentative = "N";
                            objAcq_Deal_Rights.Last_Updated_Time = DateTime.Now;
                            objAcq_Deal_Rights.Last_Action_By = objLoginUser.Users_Code;
                            objAcq_Deal_Rights.EntityState = State.Modified;
                        }
                    }
                    else // Means no movie has same date for one right (different dates)
                    {
                        //Condition to check for atleast one title has to be present in existing right
                        int CheckTitleCount = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.EntityState != State.Deleted).Where(y => y.Acq_Deal_Rights_Code == temp.Rights_Code).Count();
                        if (CheckTitleCount > 1) //Delete more titles from right
                        {
                            Acq_Deal_Rights objAcq_Deal_RightsNewRight = new Acq_Deal_Rights();
                            Acq_Deal_Rights_Title objAcq_Deal_Right_ExstTitle = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.EntityState != State.Deleted).SingleOrDefault(y => y.Acq_Deal_Rights_Code == temp.Rights_Code && y.Title_Code == temp.Title_Code);
                            // To add new right for that title
                            //objAcq_Deal_RightsNewRight = SetNewAcqDealRight(objAcq_Deal_Rights, temp.Title_Code, objAcq_Deal_Right_ExstTitle.Episode_From.Value, objAcq_Deal_Right_ExstTitle.Episode_To.Value, 0);
                            Acq_RightsController objRights = new Acq_RightsController();
                            objAcq_Deal_RightsNewRight = objRights.SetNewAcqDealRight(objAcq_Deal_Rights, temp.Title_Code, objAcq_Deal_Right_ExstTitle.Episode_From.Value, objAcq_Deal_Right_ExstTitle.Episode_To.Value, 0);

                            objAcq_Deal_RightsNewRight.Actual_Right_Start_Date = temp.StartDate;
                            objAcq_Deal_Rights.Actual_Right_End_Date = null;

                            if (temp.StartDate != null)
                                objAcq_Deal_RightsNewRight.Actual_Right_End_Date = SetMilestoneStartEndDates(temp.Milestone_Unit_Type, temp.Milestone_No_Of_Unit, temp_MileStone_StartDate);

                            //Update year based on Milestone period
                            if (objAcq_Deal.Acq_Deal_Rights.Where(r => r.Right_Type != "M" && r.Acq_Deal_Rights_Title.Any(t => t.Title_Code == temp.Title_Code)).Count() == 0)
                            {
                                var run = (from obj in objAcq_Deal.Acq_Deal_Run
                                           where obj.Is_Yearwise_Definition == "Y" && obj.Acq_Deal_Run_Title.Any(t => t.Title_Code == temp.Title_Code)
                                           select obj.Acq_Deal_Run_Yearwise_Run).FirstOrDefault();

                                if (run != null)
                                {
                                    if (objAcq_Deal_RightsNewRight.Actual_Right_Start_Date != null && objAcq_Deal_RightsNewRight.Actual_Right_End_Date != null)
                                    {
                                        USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
                                        List<USP_Generate_Deal_Type_Year_Result> objList = objUS.USP_Generate_Deal_Type_Year(objAcq_Deal.Year_Type, objAcq_Deal_RightsNewRight.Actual_Right_Start_Date, objAcq_Deal_RightsNewRight.Actual_Right_End_Date).ToList();

                                        for (int i = 0; i < objAcq_Deal_Rights.Milestone_No_Of_Unit; i++)
                                        {
                                            Acq_Deal_Run_Yearwise_Run objYRun = run.ElementAt(i);
                                            USP_Generate_Deal_Type_Year_Result objresult = objList.ElementAt(i);
                                            objYRun.Start_Date = Convert.ToDateTime(objGlobalUtil.ConvertToDMY(objresult.start_date));
                                            objYRun.End_Date = Convert.ToDateTime(objGlobalUtil.ConvertToDMY(objresult.end_date));
                                            objYRun.Year_No = i + 1;
                                        }
                                    }
                                    else
                                    {
                                        for (int i = 0; i < objAcq_Deal_Rights.Milestone_No_Of_Unit; i++)
                                        {
                                            Acq_Deal_Run_Yearwise_Run objYRun = run.ElementAt(i);
                                            objYRun.Start_Date = null;
                                            objYRun.End_Date = null;
                                            objYRun.Year_No = i + 1;
                                        }
                                    }
                                }
                            }

                            objAcq_Deal_RightsNewRight.Is_Tentative = "N";
                            objAcq_Deal.Acq_Deal_Rights.Add(objAcq_Deal_RightsNewRight);
                            // To add new right for that title Ends

                            // To delete existing title for right 
                            Acq_Deal_Rights_Title objAcq_Deal_Rights_Title_Delete = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.Title_Code == temp.Title_Code).FirstOrDefault();
                            if (objAcq_Deal_Rights_Title_Delete != null)
                            {
                                objAcq_Deal_Rights.Acq_Deal_Rights_Title.Remove(objAcq_Deal_Rights_Title_Delete);
                                objAcq_Deal_Rights_Title_Delete.EntityState = State.Deleted;
                            }
                            // To delete existing title for right Ends
                        }
                        else // Only One title is present which need to be updated 
                        {
                            Acq_Deal_Rights_Title objAcq_Deal_Rights_Title_Update = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.EntityState != State.Deleted).FirstOrDefault();
                            if (objAcq_Deal_Rights_Title_Update != null)
                            {
                                TempMilestone objTempMilestone = TempMilestone.Where(x => x.Rights_Code == objAcq_Deal_Rights.Acq_Deal_Rights_Code)
                                                                .Where(y => y.Title_Code == objAcq_Deal_Rights_Title_Update.Title_Code).FirstOrDefault();
                                if (objTempMilestone != null)
                                {
                                    DateTime Temp_StartDate = Convert.ToDateTime(objTempMilestone.StartDate);
                                    objAcq_Deal_Rights.Actual_Right_Start_Date = objTempMilestone.StartDate;
                                    objAcq_Deal_Rights.Actual_Right_End_Date = null;

                                    if (objTempMilestone.StartDate != null)
                                        objAcq_Deal_Rights.Actual_Right_End_Date = SetMilestoneStartEndDates(objTempMilestone.Milestone_Unit_Type, objTempMilestone.Milestone_No_Of_Unit, Temp_StartDate);

                                    if (objAcq_Deal.Acq_Deal_Rights.Where(r => r.Right_Type != "M" && r.Acq_Deal_Rights_Title.Any(t => t.Title_Code == temp.Title_Code)).Count() == 0)
                                    {
                                        var run = (from obj in objAcq_Deal.Acq_Deal_Run
                                                   where obj.Is_Yearwise_Definition == "Y" && obj.Acq_Deal_Run_Title.Any(t => t.Title_Code == temp.Title_Code)
                                                   select obj.Acq_Deal_Run_Yearwise_Run).FirstOrDefault();

                                        if (run != null)
                                        {
                                            if (objAcq_Deal_Rights.Actual_Right_Start_Date != null && objAcq_Deal_Rights.Actual_Right_End_Date != null)
                                            {
                                                USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
                                                List<USP_Generate_Deal_Type_Year_Result> objList = objUS.USP_Generate_Deal_Type_Year(objAcq_Deal.Year_Type, objAcq_Deal_Rights.Actual_Right_Start_Date, objAcq_Deal_Rights.Actual_Right_End_Date).ToList();

                                                for (int i = 0; i < objAcq_Deal_Rights.Milestone_No_Of_Unit; i++)
                                                {
                                                    Acq_Deal_Run_Yearwise_Run objYRun = run.ElementAt(i);
                                                    USP_Generate_Deal_Type_Year_Result objresult = objList.ElementAt(i);
                                                    objYRun.Start_Date = Convert.ToDateTime(objresult.start_date);
                                                    objYRun.End_Date = Convert.ToDateTime(objresult.end_date);
                                                    objYRun.Year_No = i + 1;
                                                }
                                            }
                                            else
                                            {
                                                for (int i = 0; i < objAcq_Deal_Rights.Milestone_No_Of_Unit; i++)
                                                {
                                                    Acq_Deal_Run_Yearwise_Run objYRun = run.ElementAt(i);
                                                    objYRun.Start_Date = null;
                                                    objYRun.End_Date = null;
                                                    objYRun.Year_No = i + 1;
                                                }
                                            }
                                        }
                                    }

                                    objAcq_Deal_Rights.Is_Tentative = "N";
                                    objAcq_Deal_Rights.Last_Updated_Time = DateTime.Now;
                                    objAcq_Deal_Rights.Last_Action_By = objLoginUser.Users_Code;
                                    objAcq_Deal_Rights.EntityState = State.Modified;
                                }
                            }
                        }
                    }

                    if (temp.StartDate != null)
                        objAcq_Deal_Rights = AddRightUDT(objAcq_Deal_Rights);

                    lstAcqDealRights.Add(objAcq_Deal_Rights);
                }
                else
                    strMessage = "Can not insert overlapping Right Period.";
            }
            #endregion

            if (strMessage == String.Empty)
            {
                dynamic result;
                //1) Update Version number + 1 in ACQ_Deal table
                objAcq_Deal.Version = (Convert.ToInt32(objAcq_Deal.Version) + 1).ToString("0000");

                // 2) Call AT Procedure to maintain version
                USP_Service objUSP_Service = new USP_Service(objLoginEntity.ConnectionStringName);
                string Is_Error = "";
                ObjectParameter objIs_Error = new ObjectParameter("Is_Error", Is_Error);
                objAcq_Deal.SaveGeneralOnly = false;
                objAcq_Deal_Service.Save(objAcq_Deal, out result);

                if (ShowValidationPopup(result))
                {
                    objUSP_Service.USP_AT_Acq_Deal(objAcq_Deal.Acq_Deal_Code, objIs_Error);
                    // 3) Insert into Module_Status_History table
                    objUSP_Service.USP_Insert_Module_Status_History(GlobalParams.ModuleCodeForAcqDeal, objAcq_Deal.Acq_Deal_Code, "A", objLoginUser.Users_Code, "Milestone Set");

                    strMessage = "Milestone Added Successfully";
                    strMsgType = "S";
                    CommonUtil objCUT = new CommonUtil();
                    objCUT.Send_WBS_Data(GlobalParams.ModuleCodeForAcqDeal, objAcq_Deal.Acq_Deal_Code, objLoginUser.Users_Code, objLoginEntity.ConnectionStringName, "Y");

                    Session["MS_Acq_Deal_Code"] = null;
                    DBUtil.Release_Record(RLCode);
                    ViewBag.ReleaseRecord = "ReleaseRecordLock();";
                }
                else
                    strRedirectTo = "PartialPage";
            }


            Dictionary<string, object> objJson = new Dictionary<string, object>();
            objJson.Add("Message", strMessage);
            objJson.Add("strMsgType", strMsgType);
            objJson.Add("RedirectTo", strRedirectTo);
            return Json(objJson);
        }

        private bool ValidateduplicateRights(List<Acq_Deal_Rights> lstAcqDealRights, Acq_Deal_Rights objAcq_Deal_Rights, Nullable<DateTime> startDate, Nullable<DateTime> endDate, int Title_Code)
        {
            bool IsValidate = true;
            if (lstAcqDealRights.Where(x => x.Acq_Deal_Rights_Code != objAcq_Deal_Rights.Acq_Deal_Rights_Code && ((startDate >= x.Actual_Right_Start_Date && startDate <= x.Actual_Right_End_Date) || (endDate >= x.Actual_Right_Start_Date && endDate <= x.Actual_Right_End_Date)) && x.Acq_Deal_Rights_Title.Any(t => t.Title_Code == Title_Code)).Count() > 0)
            {
                try
                {
                    string[] arrSelectedPlatformCode = objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Select(p => p.Platform_Code.ToString()).ToArray();
                    string[] arrSelectedCountryTerritoryCode = objAcq_Deal_Rights.Acq_Deal_Rights_Territory.Select(t => t.Country_Code.ToString()).ToArray();
                    string[] arrSelectedSubTitling = objAcq_Deal_Rights.Acq_Deal_Rights_Subtitling.Select(st => st.Language_Code.ToString()).ToArray();
                    string[] arrSelectedDubbingCodes = objAcq_Deal_Rights.Acq_Deal_Rights_Dubbing.Select(d => d.Language_Code.ToString()).ToArray();
                    string IsBreak = "N";
                    foreach (Acq_Deal_Rights objRights in lstAcqDealRights)
                    {
                        var arrWrapperPlatform = (from Acq_Deal_Rights_Platform objPlatform in objRights.Acq_Deal_Rights_Platform
                                                  where objPlatform.EntityState != State.Deleted
                                                  select objPlatform.Platform_Code.ToString()).ToArray();

                        var listCommon = arrWrapperPlatform.Where(arrSelectedPlatformCode.Contains);
                        if (listCommon.Count() > 0)
                        {
                            var arrWrapperCountryTerritory = (from Acq_Deal_Rights_Territory objTerritory in objRights.Acq_Deal_Rights_Territory where objTerritory.EntityState != State.Deleted select objTerritory.Country_Code.ToString()).ToArray();
                            var listCommonCountry = arrWrapperCountryTerritory.Where(arrSelectedCountryTerritoryCode.Contains);
                            if (listCommonCountry.Count() > 0)
                            {
                                if (objAcq_Deal_Rights.Is_Title_Language_Right == "Y" && objRights.Is_Title_Language_Right == "Y")
                                {
                                    IsBreak = "Y";
                                    break;
                                }

                                if (arrSelectedSubTitling.Length > 0)
                                {
                                    var arrWrapperSubtitlingCodes = (from Acq_Deal_Rights_Subtitling objSubTitling in objRights.Acq_Deal_Rights_Subtitling where objSubTitling.EntityState != State.Deleted select objSubTitling.Language_Code.ToString()).ToArray();
                                    var listCommonSubtitling = arrWrapperSubtitlingCodes.Where(arrSelectedSubTitling.Contains);
                                    if (listCommonSubtitling.Count() > 0)
                                    {
                                        IsBreak = "Y";
                                        break;
                                    }
                                }

                                if (arrSelectedDubbingCodes.Length > 0)
                                {
                                    var arrWrapperDubbingCodes = (from Acq_Deal_Rights_Dubbing objDubbing in objRights.Acq_Deal_Rights_Dubbing where objDubbing.EntityState != State.Deleted select objDubbing.Language_Code.ToString()).ToArray();
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
                {

                }
            }
            return IsValidate;
        }

        public class TempMilestone
        {
            public Int32 Title_Code { get; set; }
            public Int32 Rights_Code { get; set; }
            public Nullable<DateTime> StartDate { get; set; }
            public Int32 Milestone_No_Of_Unit { get; set; }
            public Int32 Milestone_Unit_Type { get; set; }
        }

        public DateTime SetMilestoneStartEndDates(int Milestone_Unit_Type, int Milestone_No_Of_Unit, DateTime StartDate)
        {
            DateTime End_Date = DateTime.MinValue;
            if (StartDate != null)
            {
                if (Milestone_Unit_Type == 1)
                    End_Date = StartDate.AddDays(Milestone_No_Of_Unit);

                if (Milestone_Unit_Type == 2)
                {
                    int days = Milestone_No_Of_Unit * 7;
                    End_Date = StartDate.AddDays(days);
                }

                if (Milestone_Unit_Type == 3)
                    End_Date = StartDate.AddMonths(Milestone_No_Of_Unit);

                if (Milestone_Unit_Type == 4)
                    End_Date = StartDate.AddYears(Milestone_No_Of_Unit);
            }
            //if (StartDate.Day == End_Date.Day)
            //    End_Date = End_Date.AddDays(-1);
            End_Date = End_Date.AddDays(-1);
            return End_Date;
        }

        [HttpPost]
        public ActionResult PartialBindMilestonePopup(int Acq_Deal_Code)
        {
            string strMessage;
            int RLCode;
            bool isLocked = DBUtil.Lock_Record(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {
                ObjectResult<USP_List_Acq_Deal_Status_Result> Obj_USP_List_Acq_Deal_Status_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Acq_Deal_Status(Acq_Deal_Code, "N");
                USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
                Session["MS_Acq_Deal_Code"] = Acq_Deal_Code;
                Session["RLCode"] = RLCode.ToString();
                return PartialView("~/Views/Shared/_Deal_MileStone.cshtml", objUSP.USP_Add_ACQ_Milestone(Acq_Deal_Code).ToList());
            }
            else
            {
                TempData["Message"] = strMessage;
                ViewBag.Message = strMessage;
                return Json(strMessage);
            }
        }

        public PartialViewResult Show_Validation_Popup(string searchForTitles, string PageSize, int PageNo)
        {
            MultiSelectList arr_Title_List = new MultiSelectList(lstDupRecords.Select(s => new { Title_Name = s.Title_Name }).Distinct().ToList(), "Title_Name", "Title_Name", searchForTitles.Split(','));
            ViewBag.SearchTitles = arr_Title_List;
            PageNo += 1;
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = PageSize;
            int Record_Count = 0;
            List<USP_Validate_Rights_Duplication_UDT> lstDuplicates = (new GlobalController()).Acq_Rights_Validation_Popup(lstDupRecords, searchForTitles, PageSize, PageNo, out Record_Count);
            ViewBag.RecordCount = Record_Count;
            return PartialView("~/Views/Shared/_Acq_Validation_Popup.cshtml", lstDuplicates);
        }
        #endregion


        public JsonResult GetAcqAsyncStatus(int dealCode)
        {
            var Rec = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_Syn_Status(dealCode, "A", objLoginUser.Users_Code).FirstOrDefault();

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
            var Acq_Deal_obj = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == dealCode).FirstOrDefault();
            ViewBag.Deal_Workflow_Status = Acq_Deal_obj.Deal_Workflow_Status;
            ViewBag.Status = Acq_Deal_obj.Status;
            ViewBag.TempCount = tempCount;
            ViewBag.DealCode = dealCode;
            ViewBag.Button_Visibility = Button_Visibility;
            ViewBag.Deal_Type_Code = Acq_Deal_obj.Deal_Type_Code;
            ViewBag.Agreement_No = Acq_Deal_obj.Agreement_No;
            ViewBag.RoleCode = Acq_Deal_obj.Role_Code;



            return PartialView("~/Views/Shared/_ActionButton.cshtml");
        }

        public JsonResult SessionTitleList(int acqDealCode)
        {
            Session["ListTitle"] = null;
            var lstADM = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            var lstTit = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            dynamic ListTitle = (from t1 in lstADM
                                 join t2 in lstTit on t1.Title_Code equals t2.Title_Code
                                 where t1.Acq_Deal_Code == acqDealCode
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

        public PartialViewResult Show_Error_Popup(string searchForTitles, string PageSize, int PageNo, int AcqDealCode, string ErrorMSG = "")
        {
            List<string> lst_ADR_Codes = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == AcqDealCode).Select(x => x.Acq_Deal_Rights_Code.ToString()).ToList();
            List<string> arrTitleNames = new List<string>();
            List<string> arrErrorNames = new List<string>();
            PageNo += 1;
            ViewBag.PageNo = PageNo;
            int Record_Count = 0;
            if (PageSize == "" || PageSize == "0" || PageSize == null)
                PageSize = "10";
            int partialPageSize = Convert.ToInt32(PageSize);
            lstErrorRecords = new Acq_Deal_Rights_Error_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => lst_ADR_Codes.Contains(x.Acq_Deal_Rights_Code.ToString())).ToList();
            if (searchForTitles != string.Empty) arrTitleNames = searchForTitles.Split(',').ToList();
            if (ErrorMSG != string.Empty) arrErrorNames = ErrorMSG.Split(',').ToList();
            if (ErrorMSG.TrimEnd() == string.Empty) ErrorMSG = lstErrorRecords[0].ErrorMSG.Trim();
            lstErrorRecords_Titles = lstErrorRecords.Where(w => (arrTitleNames.Contains(w.Title_Name) || arrTitleNames.Count <= 0) && w.ErrorMSG.Trim().Equals(ErrorMSG)).ToList();
            ViewBag.SearchTitles = new MultiSelectList(lstErrorRecords.Where(w => w.ErrorMSG.Trim().Equals(ErrorMSG)).ToList().Select(s => new { Title_Name = s.Title_Name }).Distinct(), "Title_Name", "Title_Name", arrTitleNames);
            Record_Count = lstErrorRecords_Titles.Count;
            ViewBag.RecordCount = Record_Count;
            ViewBag.PageSize = PageSize;
            ViewBag.ErrorRecord = new MultiSelectList(lstErrorRecords.Select(s => new { ErrorMSG = s.ErrorMSG.Trim() }).Distinct(), "ErrorMSG", "ErrorMSG", arrErrorNames);
            return PartialView("~/Views/Shared/_Acq_Error_Popup.cshtml", lstErrorRecords_Titles.Skip((PageNo - 1) * partialPageSize).Take(partialPageSize).ToList());
        }

        public JsonResult Reprocess(int Acq_Deal_Code)
        {
            Acq_Deal_Service objADSer = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal objADR = objADSer.GetById(Convert.ToInt32(Acq_Deal_Code));

            List<int> lstRightsCode = objADR.Acq_Deal_Rights.Where(x => x.Right_Status == "E").Select(x => x.Acq_Deal_Rights_Code).ToList();

            foreach (int RightsCode in lstRightsCode)
            {
                Acq_Rights_Reprocess(RightsCode, Acq_Deal_Code);
            }

            string strMsgType = "S";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", "Deal Reprocessed Successfully");
            obj.Add("RedirectTo", "Index");
            obj.Add("strMsgType", strMsgType);
            return Json(obj);
        }

        public void Acq_Rights_Reprocess(int rightCode = 0, int Acq_Deal_Code = 0)
        {
            Acq_Deal_Rights_Service objADRSer = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal_Rights objADR = objADRSer.GetById(Convert.ToInt32(rightCode));

            Rights_Bulk_Update_Service objRBUSer = new Rights_Bulk_Update_Service(objLoginEntity.ConnectionStringName);
            Deal_Rights_Process_Service objDRPSer = new Deal_Rights_Process_Service(objLoginEntity.ConnectionStringName);

            var Rights_Bulk_Update_Code = objDRPSer.SearchFor(x => x.Deal_Code == Acq_Deal_Code && x.Deal_Rights_Code == rightCode && x.Record_Status == "E")
                             .OrderByDescending(x => x.Deal_Rights_Process_Code).Select(x => x.Rights_Bulk_Update_Code).FirstOrDefault();

            //List<Deal_Rights_Process> lstDRP = objDRPSer.SearchFor(x => x.Rights_Bulk_Update_Code == Convert.ToInt32(Rights_Bulk_Update_Code)).ToList();
            List<Deal_Rights_Process> lstDRP = objDRPSer.SearchFor(x => x.Rights_Bulk_Update_Code == Rights_Bulk_Update_Code).ToList();

            var AcqDeal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(Acq_Deal_Code);
            //if (String.IsNullOrEmpty(objADR.Buyback_Syn_Rights_Code))
            if (AcqDeal.Role_Code != GlobalParams.RoleCode_BuyBack)
            {
                foreach (Deal_Rights_Process item in lstDRP)
                {
                    item.EntityState = State.Modified;
                    item.Record_Status = "P";
                    dynamic resultSet;
                    objDRPSer.Update(item, out resultSet);
                }

                Rights_Bulk_Update objRBU = objRBUSer.SearchFor(x => x.Rights_Bulk_Update_Code == Rights_Bulk_Update_Code).FirstOrDefault();
                if (objRBU != null)
                {

                    if (objRBU.Action_For.Replace(" ", "") == "D" && objRBU.Change_For.Replace(" ", "") == "P")
                    {
                        int ADRError_Count = new Acq_Deal_Rights_Error_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Rights_Code == rightCode).Where(x => x.ErrorMSG == "Rights Should have atleast one Platform").ToList().Count();
                        if (ADRError_Count > 0)
                        {
                            objRBU.Action_For = "A";
                            objRBU.Codes = String.Join(",", objADR.Acq_Deal_Rights_Platform.Select(x => x.Platform_Code).ToList());
                        }
                    }
                    objRBU.EntityState = State.Modified;
                    objRBU.Is_Processed = "N";
                    dynamic resultSet1;
                    objRBUSer.Update(objRBU, out resultSet1);
                }

            }


            objADR.Right_Status = "P";
            objADR.EntityState = State.Modified;
            dynamic resultSet2;
            objADRSer.Update(objADR, out resultSet2);


        }

        public PartialViewResult AddAmendmentHistory(int acqDealCode)
        {
            ViewBag.RecordCode = acqDealCode;
            string Version = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Acq_Deal_Code == acqDealCode).Select(s => s.Version).FirstOrDefault();
            ViewBag.Version = Version;
            ViewBag.ModuleCode = 30;

            int VersionNumber = Convert.ToInt32(Version);
            Acq_Amendement_History obj = new Acq_Amendement_History();
            var Cnt = new Acq_Amendement_History_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Module_Code == 30 && x.Record_Code == acqDealCode && x.Version == VersionNumber).ToList();
            if (Cnt.Count() > 0)
            {
                obj = Cnt.FirstOrDefault();
            }

            return PartialView("~/Views/Acq_Deal/_AmendmentHistory.cshtml", obj);
        }

        [HttpPost]
        public ActionResult SaveAmendmentHistory(FormCollection objCollection)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            dynamic resultSet;
            Acq_Amendement_History objAcq_Amendement_History = new Acq_Amendement_History();
            objAcq_Amendement_History.Record_Code = Convert.ToInt32(objCollection["RecordCode"]);
            objAcq_Amendement_History.Version = Convert.ToInt32(objCollection["Version"]);
            objAcq_Amendement_History.Module_Code = Convert.ToInt32(objCollection["ModuleCode"]);
            objAcq_Amendement_History.Amendment_Date = Convert.ToDateTime(objCollection["Amendment_Date"]);
            objAcq_Amendement_History.Amended_By = Convert.ToString(objCollection["AmendedBy"]);
            objAcq_Amendement_History.Remarks = Convert.ToString(objCollection["Remarks"]);

            int Acq_Amendement_History_Code = Convert.ToInt32(objCollection["Acq_Amendement_History_Code"]);
            if (Acq_Amendement_History_Code > 0)
            {
                Acq_Amendement_History objAmendment = objAcq_Amendement_History_Service.GetById(Acq_Amendement_History_Code);
                //objAcq_Amendement_History.Acq_Amendement_History_Code = Convert.ToInt32(objCollection["Acq_Amendement_History_Code"]);

                objAmendment.Record_Code = Convert.ToInt32(objCollection["RecordCode"]);
                objAmendment.Version = Convert.ToInt32(objCollection["Version"]);
                objAmendment.Module_Code = Convert.ToInt32(objCollection["ModuleCode"]); ;
                objAmendment.Amendment_Date = Convert.ToDateTime(objCollection["Amendment_Date"]);
                objAmendment.Amended_By = Convert.ToString(objCollection["AmendedBy"]);
                objAmendment.Remarks = Convert.ToString(objCollection["Remarks"]);

                objAmendment.EntityState = State.Modified;
                objAcq_Amendement_History_Service.Update(objAmendment, out resultSet);
            }
            else
            {
                objAcq_Amendement_History.EntityState = State.Added;
                objAcq_Amendement_History_Service.Save(objAcq_Amendement_History, out resultSet);
            }




            var obj = new
            {
                RecordCount = 0,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}
